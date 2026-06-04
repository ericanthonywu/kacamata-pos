function auth(req, res, next) {
  if (req.session && req.session.user) {
    res.locals.currentUser = req.session.user;
    return next();
  }
  return res.redirect('/login');
}

module.exports = auth;
