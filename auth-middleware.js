const admin = require('firebase-admin');

function initializeFirebaseAdmin() {
  if (admin.apps.length) return;
  admin.initializeApp({ credential: admin.credential.applicationDefault() });
}

async function requireFirebaseUser(req, res, next) {
  try {
    initializeFirebaseAdmin();
    const header = req.headers.authorization || '';
    const token = header.startsWith('Bearer ') ? header.slice(7) : '';
    if (!token) return res.status(401).json({ error: 'missing_bearer_token' });
    req.user = await admin.auth().verifyIdToken(token);
    next();
  } catch (_) {
    res.status(401).json({ error: 'invalid_or_expired_token' });
  }
}

module.exports = { requireFirebaseUser };
