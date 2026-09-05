const { rateLimit } = require('express-rate-limit');

const tokenLimiter = rateLimit({
  windowMs: 60 * 1000,
  limit: 20,
  standardHeaders: 'draft-8',
  legacyHeaders: false,
  message: { error: 'too_many_token_requests' },
});

const roomLimiter = rateLimit({
  windowMs: 60 * 1000,
  limit: 30,
  standardHeaders: 'draft-8',
  legacyHeaders: false,
  message: { error: 'too_many_requests' },
});

module.exports = { tokenLimiter, roomLimiter };
