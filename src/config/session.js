const session = require('express-session');
const KnexSessionStore = require('connect-session-knex')(session);
const db = require('./database');

const store = new KnexSessionStore({
  knex: db,
  tablename: 'sessions', // optional
  createtable: true,
});

module.exports = session({
  store: store,
  secret: process.env.SESSION_SECRET || 'default-secret',
  resave: false,
  saveUninitialized: false,
  cookie: {
    maxAge: 24 * 60 * 60 * 1000, // 24 hours
    httpOnly: true,
  },
});
