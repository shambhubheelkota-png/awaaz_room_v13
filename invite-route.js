const express = require('express');
const admin = require('firebase-admin');
const { requireFirebaseUser } = require('./auth-middleware');
const { roomLimiter } = require('./rate-limit');
const { sendRoomInvite } = require('./notification-sender');

const router = express.Router();
router.post('/rooms/:roomId/invite', roomLimiter, requireFirebaseUser, async (req, res) => {
  try {
    const recipientId = String(req.body.recipientId || '').trim();
    const roomTitle = String(req.body.roomTitle || '').trim();
    const inviterName = String(req.body.inviterName || 'Awaaz Room user').trim();
    if (!recipientId || !roomTitle) return res.status(400).json({ error: 'recipient_and_room_title_required' });

    const db = admin.firestore();
    const roomDoc = await db.collection('rooms').doc(req.params.roomId).get();
    if (!roomDoc.exists || roomDoc.data().hostId !== req.user.uid) {
      return res.status(403).json({ error: 'host_only' });
    }
    const blocked = await db.collection('users').doc(recipientId)
      .collection('blocks').doc(req.user.uid).get();
    if (blocked.exists) return res.status(403).json({ error: 'invite_not_allowed' });

    const result = await sendRoomInvite({ recipientId, roomId: req.params.roomId, roomTitle, inviterName });
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message || 'notification_failed' });
  }
});
module.exports = router;
