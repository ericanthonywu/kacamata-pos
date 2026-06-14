const knex = require('knex');
const config = require('../knexfile');
const fs = require('fs');
const path = require('path');
const db = knex(config);

// Parse the CSV file directly for accuracy
function parseCSV(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const lines = content.trim().split('\n');
  const header = lines[0]; // skip header
  const rows = [];

  for (let i = 1; i < lines.length; i++) {
    const line = lines[i].trim();
    if (!line) continue;

    // Parse CSV handling quoted fields with commas
    const fields = [];
    let current = '';
    let inQuotes = false;
    for (let j = 0; j < line.length; j++) {
      const ch = line[j];
      if (ch === '"') {
        inQuotes = !inQuotes;
      } else if (ch === ',' && !inQuotes) {
        fields.push(current.trim());
        current = '';
      } else {
        current += ch;
      }
    }
    fields.push(current.trim());

    // fields: namapelanggan, kodesi, tanggalfaktur, tanggaljatuhtempo, total, returan, bayar, sisa
    const [nama, kodeSI, tanggalFakturRaw, , totalRaw, , bayarRaw] = fields;

    // Parse date from DD-Mon-YYYY to YYYY-MM-DD
    const orderDate = parseDate(tanggalFakturRaw);

    // Parse amount: remove commas, parse as number
    const total = parseAmount(totalRaw);
    const bayar = parseAmount(bayarRaw);

    rows.push({ nama, noNota: kodeSI, orderDate, total, bayar });
  }
  return rows;
}

function parseDate(dateStr) {
  const months = {
    'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
    'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
    'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12',
  };
  const parts = dateStr.split('-');
  const day = parts[0].padStart(2, '0');
  const month = months[parts[1]];
  const year = parts[2];
  return `${year}-${month}-${day}`;
}

function parseAmount(val) {
  if (!val || val === '0.00' || val === '0.0' || val === '0') return 0;
  // Remove commas and parse
  return Math.round(parseFloat(val.replace(/,/g, '')));
}

async function run() {
  const DRY_RUN = process.argv.includes('--dry-run');
  const csvPath = path.join(__dirname, '..', 'import', 'data_pelanggan.csv');

  console.log(`Reading CSV from: ${csvPath}`);
  const rows = parseCSV(csvPath);
  console.log(`Parsed ${rows.length} rows from CSV`);

  // Deduplicate by noNota (kodeSI)
  const deduped = new Map();
  for (const row of rows) {
    if (!deduped.has(row.noNota)) {
      deduped.set(row.noNota, row);
    }
  }
  const uniqueRows = Array.from(deduped.values());
  console.log(`Unique rows (by no_nota): ${uniqueRows.length}`);

  // Collect unique customer names
  const uniqueNames = [...new Set(uniqueRows.map(r => r.nama.trim()))];
  console.log(`Unique customer names: ${uniqueNames.length}`);

  if (DRY_RUN) {
    console.log('\n=== DRY RUN MODE - No data will be inserted ===\n');
    console.log('Customers to insert:');
    uniqueNames.forEach(n => console.log(`  - ${n}`));
    console.log('\nPenjualan rows:');
    for (const row of uniqueRows) {
      const status = row.total === 0 ? 'lunas'
        : row.bayar >= row.total ? 'lunas'
        : row.bayar > 0 ? 'dp'
        : 'belum_lunas';
      const sisa = row.total - row.bayar;
      console.log(`  ${row.noNota} | ${row.nama} | ${row.orderDate} | total=${row.total} | dp=${row.bayar} | sisa=${sisa} | status=${status}`);
    }
    console.log(`\nTotal: ${uniqueRows.length} penjualan, ${uniqueNames.length} pelanggan`);
    console.log('Run without --dry-run to insert data.');
    await db.destroy();
    process.exit(0);
  }

  try {
    // ── Step 1: Insert pelanggan (if not exists) ──
    console.log('\n--- Inserting pelanggan ---');
    const pelangganMap = {}; // name → id
    for (const name of uniqueNames) {
      let existing = await db('pelanggan').where('nama', 'ilike', name).first();
      if (!existing) {
        const [created] = await db('pelanggan').insert({ nama: name }).returning('*');
        existing = created;
        console.log(`  [NEW] Pelanggan: "${name}" → id=${existing.id}`);
      } else {
        console.log(`  [EXISTS] Pelanggan: "${name}" → id=${existing.id}`);
      }
      pelangganMap[name.toUpperCase()] = existing.id;
    }

    // ── Step 2: Insert penjualan + pembayaran ──
    console.log('\n--- Inserting penjualan ---');
    let insertedCount = 0;
    let skippedCount = 0;
    let paymentCount = 0;

    for (const row of uniqueRows) {
      // Check if no_nota already exists
      const existing = await db('penjualan').where('no_nota', row.noNota).first();
      if (existing) {
        console.log(`  [SKIP] no_nota "${row.noNota}" already exists (id=${existing.id})`);
        skippedCount++;
        continue;
      }

      // Determine status_bayar
      let statusBayar;
      if (row.total === 0) {
        statusBayar = 'lunas';
      } else if (row.bayar >= row.total) {
        statusBayar = 'lunas';
      } else if (row.bayar > 0) {
        statusBayar = 'dp';
      } else {
        statusBayar = 'belum_lunas';
      }

      const pelangganId = pelangganMap[row.nama.trim().toUpperCase()];

      const penjualanData = {
        no_nota: row.noNota,
        pelanggan_id: pelangganId,
        sales_id: null,
        created_by: null,
        order_date: row.orderDate,
        biaya: 0,
        subtotal: row.total,
        bpjs: 0,
        total: row.total,
        dp: row.bayar,
        status_bayar: statusBayar,
      };

      const [penjualan] = await db('penjualan').insert(penjualanData).returning('*');
      console.log(`  [INSERT] ${row.noNota} | ${row.nama} | total=${row.total} | dp=${row.bayar} | status=${statusBayar} → id=${penjualan.id}`);
      insertedCount++;

      // Create payment record if bayar > 0
      if (row.bayar > 0) {
        await db('pembayaran_penjualan').insert({
          penjualan_id: penjualan.id,
          tanggal_bayar: row.orderDate,
          jumlah_bayar: row.bayar,
          keterangan: 'Down Payment (migrasi data lama)',
        });
        paymentCount++;
      }
    }

    console.log(`\n=== DONE ===`);
    console.log(`Pelanggan inserted/found: ${uniqueNames.length}`);
    console.log(`Penjualan inserted: ${insertedCount}`);
    console.log(`Penjualan skipped (already exists): ${skippedCount}`);
    console.log(`Payment records created: ${paymentCount}`);

  } catch (err) {
    console.error('Error:', err);
  }

  await db.destroy();
  process.exit(0);
}

run();
