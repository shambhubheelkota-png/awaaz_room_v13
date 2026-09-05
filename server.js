require('dotenv').config();
const express = require('express');
const http = require('http');
const crypto = require('crypto');
const cors = require('cors');
const { Server } = require('socket.io');
const { createLiveKitToken } = require('./token-provider');
const { requireFirebaseUser } = require('./auth-middleware');
const { tokenLimiter, roomLimiter } = require('./rate-limit');
const inviteRouter = require('./invite-route');

const app = express();
app.use(cors());
app.use(express.json());
app.use(inviteRouter);
const rooms = new Map();

app.get('/health', (_, res) => res.json({ ok: true, service: 'awaaz-room' }));
app.post('/livekit/token', tokenLimiter, requireFirebaseUser, async (req, res) => {
  try {
    const roomName = String(req.body.roomName || '').trim();
    const identity = req.user.uid;
    const displayName = String(req.body.displayName || req.user.name || 'User').trim();
    if (!roomName || !identity) return res.status(400).json({ error: 'room_and_identity_required' });
    const token = await createLiveKitToken({ roomName, identity, displayName });
    res.json({ token });
  } catch (error) {
    res.status(error.statusCode || 500).json({ error: error.message || 'token_error' });
  }
});
app.get('/rooms', (_, res) => res.json([...rooms.values()]));
app.post('/rooms', roomLimiter, (req, res) => {
  const title = String(req.body.title || '').trim();
  if (!title) return res.status(400).json({ error: 'title_required' });
  const room = { id: crypto.randomUUID(), title, createdAt: new Date().toISOString() };
  rooms.set(room.id, room);
  res.status(201).json(room);
});

const server = http.createServer(app);
const io = new Server(server, { cors: { origin: '*' } });

io.on('connection', (socket) => {
  socket.on('join-room', async ({ roomId, user }) => {
    if (!roomId || !user) return;
    const existing = [...(io.sockets.adapter.rooms.get(roomId) || [])];
    socket.join(roomId);
    socket.data = { roomId, user };
    socket.emit('room-peers', existing);
    socket.to(roomId).emit('participant-joined', { ...user, socketId: socket.id });
  });

  socket.on('raise-hand', ({ roomId, userId, raised }) => {
    io.to(roomId).emit('hand-updated', { userId, raised: Boolean(raised) });
  });

  socket.on('signal', ({ roomId, target, payload }) => {
    if (!roomId || !target || !payload) return;
    io.to(target).emit('signal', { roomId, from: socket.id, payload });
  });

  socket.on('disconnect', () => {
    const { roomId, user } = socket.data || {};
    if (roomId && user) socket.to(roomId).emit('participant-left', { ...user, socketId: socket.id });
  });
});

server.listen(process.env.PORT || 3000, () => console.log('Awaaz Room API running'));
