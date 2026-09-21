const session = require('express-session');

module.exports = session({
  name: process.env.SESSION_NAME || 'kacamata_cabang_sid',
  secret: process.env.SESSION_SECRET || 'kacamata-cabang-session-secret',
  resave: false,
  saveUninitialized: false,
  cookie: {
    maxAge: 24 * 60 * 60 * 1000, // 24 hours
    httpOnly: true,
  },
});
