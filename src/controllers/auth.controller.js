const penggunaService = require('../services/pengguna.service');
const cabangService = require('../services/cabang.service');

exports.loginPage = async function (req, res, next) {
  try {
    if (req.session.user) return res.redirect('/');
    const cabangList = await cabangService.getAll();
    res.render('auth/login', { layout: false, cabangList });
  } catch (err) {
    next(err);
  }
};

exports.login = async function (req, res) {
  try {
    const { username, password, cabang_id } = req.body;
    if (!username || !password || !cabang_id) {
      req.flash('error', 'Cabang, username, dan password harus diisi');
      return res.redirect('/login');
    }
    const cabangIdNum = parseInt(cabang_id, 10);
    const user = await penggunaService.authenticate(username, password, cabangIdNum);
    if (!user) {
      req.flash('error', 'Username, password, atau cabang salah');
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
