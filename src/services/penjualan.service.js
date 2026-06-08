const repo = require('../repositories/penjualan.repository');
const barangRepo = require('../repositories/barang.repository');

exports.getAll = function () { return repo.findAll(); };
exports.getDatatablesData = function (params) { return repo.getDatatablesData(params); };

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

  // --- Stock validation ---
  // Aggregate quantities per barang_id (in case same item appears multiple times)
  const qtyMap = {};
  for (const item of items) {
    const id = item.barang_id;
    qtyMap[id] = (qtyMap[id] || 0) + (parseInt(item.jumlah) || 1);
  }

  for (const [barangId, totalQty] of Object.entries(qtyMap)) {
    const barang = await barangRepo.findById(barangId);
    if (!barang) {
      throw Object.assign(new Error(`Barang dengan ID ${barangId} tidak ditemukan`), { status: 400 });
    }
    if (barang.qty < totalQty) {
      throw Object.assign(
        new Error(`Stok "${barang.nama_barang}" tidak cukup (tersedia: ${barang.qty}, dibutuhkan: ${totalQty})`),
        { status: 400 }
      );
    }
  }
  for (const item of items) {
    subtotal += ((parseFloat(item.harga) || 0) - (parseFloat(item.diskon) || 0)) * (parseInt(item.jumlah) || 1);
  }

  const bpjsAmount = parseFloat(data.bpjs) || 0;
  const total = subtotal - bpjsAmount;
  const no_nota = await repo.generateNotaNumber();

  const penjualanData = {
    no_nota,
    pelanggan_id: data.pelanggan_id || null,
    sales_id: data.sales_id || null,
    created_by: userId,
    order_date: data.order_date || new Date().toISOString().split('T')[0],
    tanggal_selesai: data.tanggal_selesai || null,
    biaya: 0,
    subtotal,
    bpjs: bpjsAmount,
    total,
    status_bayar: data.status_bayar || 'lunas',
    dp: parseFloat(data.dp) || 0,
    sph_r: data.sph_r || null,
    sph_l: data.sph_l || null,
    cyl_r: data.cyl_r || null,
    cyl_l: data.cyl_l || null,
    axis_r: data.axis_r || null,
    axis_l: data.axis_l || null,
    add_r: data.add_r || null,
    add_l: data.add_l || null,
  };

  const penjualan = await repo.create(penjualanData, items);
  return exports.getById(penjualan.id);
};

exports.del = function (id) { return repo.del(id); };
