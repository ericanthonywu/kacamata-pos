const repo = require('../repositories/pembelian.repository');
const barangRepo = require('../repositories/barang.repository');

exports.getAll = function () { return repo.findAll(); };
exports.getDatatablesData = function (params) { return repo.getDatatablesData(params); };

exports.getById = async function (id) {
  const pembelian = await repo.findById(id);
  if (!pembelian) return null;
  const detail = await repo.findDetailsByPembelianId(id);
  return { ...pembelian, detail };
};

exports.create = async function (data) {
  if (!data.items || data.items.length === 0)
    throw Object.assign(new Error('Minimal satu item harus diisi'), { status: 400 });

  if (!data.supplier_id)
    throw Object.assign(new Error('Supplier harus dipilih'), { status: 400 });

  const items = data.items.filter(i => i.barang_id);
  if (items.length === 0)
    throw Object.assign(new Error('Minimal satu barang harus dipilih'), { status: 400 });

  // Validate all barang exist
  for (const item of items) {
    const barang = await barangRepo.findById(item.barang_id);
    if (!barang) {
      throw Object.assign(new Error(`Barang dengan ID ${item.barang_id} tidak ditemukan`), { status: 400 });
    }
  }

  // Calculate total
  let total_harga = 0;
  for (const item of items) {
    total_harga += (parseFloat(item.harga_beli) || 0) * (parseInt(item.jumlah) || 1);
  }

  const kode_pembelian = await repo.generateKodePembelian();

  const pembelianData = {
    kode_pembelian,
    tanggal_pembelian: data.tanggal_pembelian || new Date().toISOString().split('T')[0],
    supplier_id: data.supplier_id,
    total_harga,
    status_bayar: data.status_bayar || 'belum_lunas',
  };

  const pembelian = await repo.create(pembelianData, items);
  return exports.getById(pembelian.id);
};

exports.del = function (id) { return repo.del(id); };
