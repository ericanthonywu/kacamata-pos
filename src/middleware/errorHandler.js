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

  // Otherwise render error or redirect back
  req.flash('error', message);
  res.redirect('back');
}

module.exports = errorHandler;
