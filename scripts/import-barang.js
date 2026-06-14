require('dotenv').config();
const knex = require('knex')(require('../knexfile'));
const XLSX = require('xlsx');

async function run() {
  try {
    // ── 1. TRUNCATE all tables except kategori, pengguna, knex_* ─────────────
    console.log('Truncating tables...');
    await knex.raw(`
      TRUNCATE TABLE
        komisi_sales,
        pembayaran_penjualan,
        pembayaran_pembelian,
        penjualan_retur_detail,
        penjualan_retur,
        pembelian_retur_detail,
        pembelian_retur,
        penjualan_detail,
        penjualan,
        pembelian_detail,
        pembelian,
        barang,
        supplier,
        pelanggan,
        sales
      RESTART IDENTITY CASCADE
    `);
    console.log('Tables truncated.');

    // ── 2. Ensure SOFTLENS kategori exists ────────────────────────────────────
    console.log('Syncing kategori...');
    const existingKat = await knex('kategori').select('id', 'nama');
    const katMap = {};
    existingKat.forEach(k => { katMap[k.nama.toUpperCase()] = k.id; });

    if (!katMap['SOFTLENS']) {
      const [row] = await knex('kategori').insert({ nama: 'Softlens' }).returning('*');
      katMap['SOFTLENS'] = row.id;
      console.log('  Created kategori: Softlens →', row.id);
    }
    console.log('Kategori map:', katMap);

    // ── 3. Read data barang (1).xlsx ──────────────────────────────────────────
    const wb1 = XLSX.readFile('import/data barang (1).xlsx');
    const data1 = XLSX.utils.sheet_to_json(wb1.Sheets[wb1.SheetNames[0]], { header: 1 });
    // headers: kodebarang[0], barcode[1], namabarang[2], kategori[3], merk[4],
    //          satuan[5], hb[6], persen[7], hj[8], ...

    const seenBarcodes = new Set();
    const barangRows = [];
    for (const row of data1.slice(1)) {
      const barcode   = row[1] ? String(row[1]).trim() : null;
      const nama      = row[2] ? String(row[2]).trim() : null;
      const katStr    = row[3] ? String(row[3]).trim().toUpperCase() : null;
      const hargaJual = row[8] ? Number(row[8]) : 0;

      if (!barcode || !nama) continue;
      if (katStr === 'LAIN LAIN') continue;
      if (seenBarcodes.has(barcode)) continue; // keep first occurrence only

      const kategoriId = katMap[katStr];
      if (!kategoriId) {
        console.warn(`  Skipping unknown kategori "${katStr}" for barcode ${barcode}`);
        continue;
      }

      seenBarcodes.add(barcode);
      barangRows.push({
        barcode_id:   barcode,
        nama_barang:  nama,
        kategori_id:  kategoriId,
        harga_jual:   hargaJual,
        qty:          0,
      });
    }
    console.log(`Inserting ${barangRows.length} barang rows...`);

    // Insert in batches of 200
    const BATCH = 200;
    for (let i = 0; i < barangRows.length; i += BATCH) {
      await knex('barang').insert(barangRows.slice(i, i + BATCH));
    }
    console.log('Barang inserted.');

    // ── 4. Update qty from stok gudang.xls ────────────────────────────────────
    const wb2 = XLSX.readFile('import/stok gudang.xls');
    const data2 = XLSX.utils.sheet_to_json(wb2.Sheets[wb2.SheetNames[0]], { header: 1 });
    // headers: kodebarang[0], barcode[1], namabarang[2], kategori[3], merk[4],
    //          Qty K[5], satuan[6], HJ[7], ...

    console.log('Updating qty from stok gudang...');
    let updated = 0;
    let skipped = 0;
    for (const row of data2.slice(1)) {
      const barcode = row[1] ? String(row[1]).trim() : null;
      const qty     = row[5] !== undefined && row[5] !== null ? Number(row[5]) : 0;
      if (!barcode) continue;

      const count = await knex('barang')
        .where({ barcode_id: barcode })
        .update({ qty });

      if (count > 0) updated++;
      else skipped++;
    }
    console.log(`Qty updated: ${updated}, skipped (not in barang): ${skipped}`);

    console.log('\nDone!');
  } catch (err) {
    console.error('Error:', err.message);
    process.exit(1);
  } finally {
    await knex.destroy();
  }
}

run();
