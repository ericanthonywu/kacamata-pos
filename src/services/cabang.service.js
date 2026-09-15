const cabangRepo = require('../repositories/cabang.repository');

exports.getAll = function () {
  return cabangRepo.findAll();
};

exports.getById = function (id) {
  return cabangRepo.findById(id);
};
