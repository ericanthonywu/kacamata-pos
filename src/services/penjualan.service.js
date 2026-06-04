const repo = require('../repositories/penjualan.repository');

exports.getAll = function () { return repo.findAll(); };

exports.getById = async function (id) {
  const penjualan = await repo.findById(id);
  if (!penjualan) return null;
  const detail = await repo.findDetailsByPenjualanId(id);
  return { ...penjualan, detail };
};

exports.create = async function (data, userId) {
  if (!data.items || data.items.length === 0)
    throw Object.assign(new Error('Minimal satu item harus diisi'), { status: 400 });

  let subtotal = 0;
  const items = data.items.filter(i => i.barang_id);
  for (const item of items) {
    subtotal += ((parseFloat(item.harga) || 0) - (parseFloat(item.diskon) || 0)) * (parseInt(item.jumlah) || 1);
  }

  const total = subtotal + (parseFloat(data.biaya) || 0);
  const no_nota = await repo.generateNotaNumber();

  const penjualanData = {
    no_nota,
    pelanggan_id: data.pelanggan_id || null,
    sales_id: data.sales_id || null,
    created_by: userId,
    order_date: data.order_date || new Date().toISOString().split('T')[0],
    biaya: parseFloat(data.biaya) || 0,
    subtotal,
    bpjs: data.bpjs || '',
    total,
  };

  const penjualan = await repo.create(penjualanData, items);
  return exports.getById(penjualan.id);
};

exports.del = function (id) { return repo.del(id); };
