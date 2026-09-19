function errorHandler(err, req, res, next) {
  console.error('Error:', err.message);
  if (process.env.NODE_ENV !== 'production') {
    console.error(err.stack);
  }

  const status = err.status || 500;
  const message = err.message || 'Terjadi kesalahan pada server';

  // If AJAX request, respond with JSON
  if (req.xhr || (req.headers.accept && req.headers.accept.includes('application/json'))) {
    return res.status(status).json({ success: false, message });
  }

  // Prevent redirect loops on GET errors or when referer is the same page
  const referer = req.get('referer');
  const currentUrl = req.originalUrl;
  const isLoop = referer && (referer.endsWith(currentUrl) || referer === currentUrl);

  if (req.method !== 'GET' && referer && !isLoop) {
    req.flash('error', message);
    return res.redirect('back');
  }

  // Render clean error page instead of redirect loop
  return res.status(status).send(`
    <!DOCTYPE html>
    <html lang="id">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Terjadi Kesalahan (${status})</title>
      <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #f0f2f5; color: #1a1d27; display: flex; align-items: center; justify-content: center; min-height: 100vh; margin: 0; padding: 20px; box-sizing: border-box; }
        .error-card { background: #fff; padding: 32px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); max-width: 500px; width: 100%; text-align: center; }
        h1 { font-size: 2rem; margin-bottom: 8px; color: #dc3545; }
        p { color: #6c757d; margin-bottom: 24px; font-size: 0.95rem; }
        .btn { display: inline-block; background: #6c63ff; color: #fff; text-decoration: none; padding: 10px 24px; border-radius: 6px; font-weight: 600; font-size: 0.875rem; }
        .btn:hover { background: #5a52e0; }
      </style>
    </head>
    <body>
      <div class="error-card">
        <h1>Error ${status}</h1>
        <p>${message}</p>
        <a href="${req.basePath || '/'}" class="btn">Kembali ke Halaman Utama</a>
      </div>
    </body>
    </html>
  `);
}

module.exports = errorHandler;
