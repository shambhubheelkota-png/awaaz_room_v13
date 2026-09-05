const { AccessToken } = require('livekit-server-sdk');

async function createLiveKitToken({ roomName, identity, displayName, canPublish = true }) {
  const key = process.env.LIVEKIT_API_KEY;
  const secret = process.env.LIVEKIT_API_SECRET;
  if (!key || !secret) {
    const error = new Error('livekit_not_configured');
    error.statusCode = 503;
    throw error;
  }
  const token = new AccessToken(key, secret, {
    identity,
    name: displayName || identity,
    ttl: '15m',
  });
  token.addGrant({
    roomJoin: true,
    room: roomName,
    canPublish,
    canSubscribe: true,
  });
  return token.toJwt();
}

module.exports = { createLiveKitToken };
