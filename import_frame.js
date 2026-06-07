const xlsx = require('xlsx');
const knex = require('knex');
const knexConfig = require('./knexfile.js');

const db = knex(knexConfig);

async function run() {
  try {
    console.log('Loading XLS file...');
    const workbook = xlsx.readFile('import/frame test.xls');
    const sheetName = workbook.SheetNames[0];
    const data = xlsx.utils.sheet_to_json(workbook.Sheets[sheetName]);

    console.log(`Parsed ${data.length} rows. Example first row:`, data[0]);

    // Check or create kategori
    let cat = await db('kategori').where('nama', 'ilike', 'Frame').first();
    if (!cat) {
      console.log('Kategori "Frame" not found, creating...');
      const [newId] = await db('kategori').insert({ nama: 'Frame', deskripsi: 'Imported Frame' }).returning('id');
      cat = { id: newId.id || newId };
    }
    const catId = cat.id;

    let insertedCount = 0;
    let batch = [];
    const dedupedMap = new Map();

    for (const row of data) {
      // Find column names dynamically by checking properties if there's casing mismatch
      // Let's assume standard names as in lenses, but we'll adapt them.
      // E.g., namabarang, Qty K, HJ, barcode
      const getVal = (keys) => {
        for (const k of keys) {
          for (const key in row) {
            if (key.trim().toLowerCase() === k.toLowerCase()) return row[key];
          }
        }
        return undefined;
      };

      let barcode = getVal(['barcode', 'barcode_id']);
      if (!barcode) continue;
      barcode = String(barcode).trim();

      const rawName = String(getVal(['namabarang', 'nama barang', 'nama']) || '').trim();
      const qtyRaw = getVal(['Qty K', 'qty', 'quantity']);
      const qty = (qtyRaw === '' || qtyRaw === undefined || qtyRaw === null) ? null : parseInt(qtyRaw, 10);
      
      const hjRaw = getVal(['HJ', 'harga jual', 'harga_jual', 'harga']);
      let hargaJual = 0;
      if (typeof hjRaw === 'string') {
        hargaJual = parseFloat(hjRaw.replace(/,/g, '')) || 0;
      } else if (typeof hjRaw === 'number') {
        hargaJual = hjRaw;
      }

      dedupedMap.set(barcode, {
        nama_barang: rawName,
        barcode_id: barcode,
        kategori_id: catId,
        harga_jual: hargaJual,
        qty: Number.isNaN(qty) ? 0 : qty, // fallback to 0 if NaN, or null if null
        // Null for prescription fields
        sph_r: null, sph_l: null, cyl_r: null, cyl_l: null, add_r: null, add_l: null
      });
    }

    const finalResults = Array.from(dedupedMap.values());
    console.log(`Deduplicated to ${finalResults.length} unique frames to insert.`);

    for (const item of finalResults) {
      batch.push(item);
      if (batch.length === 100) {
        await db('barang').insert(batch).onConflict('barcode_id').merge();
        insertedCount += batch.length;
        batch = [];
      }
    }

    if (batch.length > 0) {
      await db('barang').insert(batch).onConflict('barcode_id').merge();
      insertedCount += batch.length;
    }

    console.log(`Import completed! Inserted/Updated ${insertedCount} items.`);
    process.exit(0);

  } catch (error) {
    console.error('Error importing:', error);
    process.exit(1);
  }
}

run();
