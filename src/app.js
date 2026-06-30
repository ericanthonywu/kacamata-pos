require('dotenv').config();
const express = require('express');
const path = require('path');
const flash = require('connect-flash');

const db = require('./config/database');
const { todayStr } = require('./utils/date.helper');
const sessionMiddleware = require('./config/session');
const errorHandler = require('./middleware/errorHandler');
const routes = require('./routes/index.routes');

const app = express();
const PORT = process.env.PORT || 3000;

// View engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '..', 'views'));

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, '..', 'public')));
app.use(sessionMiddleware);
app.use(flash());

// Global template vars
app.use((req, res, next) => {
  res.locals.currentUser = req.session.user || null;
  res.locals.success = req.flash('success')[0] || null;
  res.locals.error = req.flash('error')[0] || null;
  res.locals.todayStr = todayStr;
  next();
});

// Routes
app.use('/', routes);

// Error handler
app.use(errorHandler);

const server = app.listen(PORT, () => {
  console.log(`\n🚀 OPTIK SENTRAL running on http://localhost:${PORT}`);
});

// Graceful Shutdown
function gracefulShutdown(signal) {
  console.log(`\n${signal} signal received: closing HTTP server`);
  server.close(() => {
    console.log('HTTP server closed');
    db.destroy().then(() => {
      console.log('Database connections closed');
      process.exit(0);
    }).catch((err) => {
      console.error('Error closing database connections:', err);
      process.exit(1);
    });
  });
}

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// For nodemon restarts
process.once('SIGUSR2', () => {
  server.close(() => {
    db.destroy().then(() => {
      process.kill(process.pid, 'SIGUSR2');
    });
  });
});
