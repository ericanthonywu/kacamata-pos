const penggunaService = require('../services/pengguna.service');

exports.loginPage = function (req, res) {
  if (req.session.user) return res.redirect('/');
  res.render('auth/login', { layout: false, error: req.flash('error')[0] || null });
};

exports.login = async function (req, res) {
  try {
    const { username, password } = req.body;
    const user = await penggunaService.authenticate(username, password);
    if (!user) {
      req.flash('error', 'Username atau password salah');
      return res.redirect('/login');
    }
    req.session.user = user;
    res.redirect('/');
  } catch (err) {
    req.flash('error', 'Terjadi kesalahan saat login');
    res.redirect('/login');
  }
};

exports.logout = function (req, res) {
  req.session.destroy(() => {
    res.redirect('/login');
  });
};
