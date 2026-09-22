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

app.set('trust proxy', 1);

// View engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '..', 'views'));

const PREFIX = process.env.APP_PREFIX || '/ketapang';

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(PREFIX, express.static(path.join(__dirname, '..', 'public')));
app.use(express.static(path.join(__dirname, '..', 'public')));
app.use(sessionMiddleware);
app.use(flash());

// Global template vars & Base Path / Redirection
app.use((req, res, next) => {
  const host = (req.headers.host || '').toLowerCase();

  // If accessed directly via server public IP, redirect to HTTPS domain with prefix
  if (host.includes('187.77.121.132')) {
    const targetPath = req.originalUrl || req.url || '/';
    const cleanPath = targetPath.startsWith(PREFIX)
      ? targetPath
      : (PREFIX + (targetPath === '/' ? '/' : (targetPath.startsWith('/') ? targetPath : '/' + targetPath)));
    return res.redirect(302, 'https://srv1743851.hstgr.cloud' + cleanPath);
  }

  req.basePath = PREFIX;
  res.locals.basePath = PREFIX;
  res.locals.bp = PREFIX;

  res.locals.appUrl = (p) => {
    if (!p) return PREFIX || '/';
    if (p.startsWith('http://') || p.startsWith('https://') || p.startsWith('//')) return p;
    if (!p.startsWith('/')) p = '/' + p;
    if (p === PREFIX || p.startsWith(PREFIX + '/')) return p;
    return PREFIX + p;
  };

  // Redirect wrapper: ensures relative paths always include PREFIX
  const origRedirect = res.redirect.bind(res);
  res.redirect = function (first, second) {
    let status = 302;
    let url = first;
    if (typeof first === 'number') {
      status = first;
      url = second;
    }
    if (typeof url === 'string' && url.startsWith('/') && !url.startsWith('//')) {
      if (!url.startsWith(PREFIX + '/') && url !== PREFIX) {
        url = PREFIX + url;
      }
    }
    return origRedirect(status, url);
  };

  res.locals.currentUser = req.session?.user ?? null;
  res.locals.success = req.flash('success')?.[0] ?? null;
  res.locals.error = req.flash('error')?.[0] ?? null;
  res.locals.todayStr = todayStr;
  next();
});

// Root redirect to PREFIX (for localhost or direct port access)
app.get('/', (req, res) => {
  return res.redirect(PREFIX + '/');
});

// Routes mounted at PREFIX and /
app.use(PREFIX, routes);
app.use('/', routes);

// Error handler
app.use(errorHandler);

const server = app.listen(PORT, () => {
  console.log(`\n🚀 OPTIK SENTRAL KETAPANG running on http://localhost:${PORT}`);
});

// Graceful Shutdown
function gracefulShutdown(signal) {
  console.log(`\n${signal} signal received: closing HTTP server`);
  server.close(async () => {
    console.log('HTTP server closed');
    try {
      await db.destroy();
      console.log('Database connections closed');
      process.exit(0);
    } catch (err) {
      console.error('Error closing database connections:', err);
      process.exit(1);
    }
  });
}

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// For process restarts
process.once('SIGUSR2', () => {
  server.close(async () => {
    try {
      await db.destroy();
    } finally {
      process.kill(process.pid, 'SIGUSR2');
    }
  });
});
