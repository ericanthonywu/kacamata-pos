const repo = require('../repositories/penjualan.repository');
const barangRepo = require('../repositories/barang.repository');

exports.getAll = function () { return repo.findAll(); };
exports.getDatatablesData = function (params) { return repo.getDatatablesData(params); };
exports.getPelunasanDpDatatables = function (params) { return repo.getPelunasanDpDatatablesData(params); };

exports.getById = async function (id) {
  const penjualan = await repo.findById(id);
  if (!penjualan) return null;
  const [detail, pembayaran] = await Promise.all([
    repo.findDetailsByPenjualanId(id),
    repo.findPaymentsByPenjualanId(id)
  ]);
  return { ...penjualan, detail, pembayaran };
};

exports.create = async function (data, userId) {
  if (!data.items || data.items.length === 0)
    throw Object.assign(new Error('Minimal satu item harus diisi'), { status: 400 });

  let subtotal = 0;
  const items = data.items.filter(i => i.barang_id || i.tipe === 'lain_lain');

  // --- Stock validation ---
  // Aggregate quantities per barang_id (in case same item appears multiple times)
  const qtyMap = {};
  for (const item of items) {
    if (item.barang_id) {
      const id = item.barang_id;
      qtyMap[id] = (qtyMap[id] || 0) + (parseInt(item.jumlah) || 1);
    }
  }

  for (const [barangId, totalQty] of Object.entries(qtyMap)) {
    const barang = await barangRepo.findById(barangId);
    if (!barang) {
      throw Object.assign(new Error(`Barang dengan ID ${barangId} tidak ditemukan`), { status: 400 });
    }
  }
  const warnings = [];
  for (const item of items) {
    subtotal += ((parseFloat(item.harga) || 0) - (parseFloat(item.diskon) || 0)) * (parseInt(item.jumlah) || 1);
    if (item.barang_id) {
      const barang = await barangRepo.findById(item.barang_id);
      if (barang && barang.qty !== null && barang.qty <= 0) {
        warnings.push(`Pemberitahuan: Stok barang "${barang.nama_barang}" saat ini sedang kosong (0). Transaksi tetap berhasil dicatat.`);
      }
    }
  }

  const bpjsAmount = parseFloat(data.bpjs) || 0;
  const total = subtotal - bpjsAmount;
  const no_nota = await repo.generateNotaNumber(data.is_b2b);

  const penjualanData = {
    no_nota,
    pelanggan_id: data.pelanggan_id || null,
    sales_id: data.sales_id || null,
    created_by: userId === 0 ? null : userId,
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
    pd: data.pd || null,
    is_b2b: data.is_b2b || false,
    metode_bayar: data.metode_bayar || null,
  };

  const penjualan = await repo.create(penjualanData, items);
  const result = await exports.getById(penjualan.id);
  result.warnings = warnings;
  return result;
};

exports.del = function (id) { return repo.del(id); };
