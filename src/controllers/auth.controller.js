const penggunaService = require('../services/pengguna.service');

exports.loginPage = function (req, res) {
  if (req.session.user) return res.redirect('/');
  // res.locals.error is already populated globally in app.js
  res.render('auth/login', { layout: false });
};

exports.login = async function (req, res) {
  try {
    const { username, password } = req.body;
    if (!username || !password) {
      req.flash('error', 'Username dan password harus diisi');
      return res.redirect('/login');
    }
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
