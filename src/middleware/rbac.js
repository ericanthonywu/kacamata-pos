function requireRole(role) {
  return function (req, res, next) {
    if (!req.session || !req.session.user) {
      return res.redirect('/login');
    }
    const userRole = req.session.user.hak_akses;
    
    // Admin has access to everything
    if (userRole === 'admin') {
      return next();
    }

    if (userRole === role) {
      return next();
    }

    // If request is an API/AJAX call
    if (req.xhr || req.headers.accept.indexOf('json') > -1) {
      return res.status(403).json({ success: false, message: 'Akses ditolak. Anda tidak memiliki izin.' });
    }

    // Normal page load
    req.flash('error', 'Akses ditolak. Anda tidak memiliki izin ke halaman tersebut.');
    return res.redirect('/');
  };
}

module.exports = {
  requireRole,
  requireAdmin: requireRole('admin')
};
