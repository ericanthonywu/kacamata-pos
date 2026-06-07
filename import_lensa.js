const fs = require('fs');
const csv = require('csv-parser');
const knex = require('knex');
const knexConfig = require('./knexfile.js');

const db = knex(knexConfig);

async function run() {
  try {
    // Check or create kategori
    let cat = await db('kategori').where('nama', 'ilike', 'Lensa').first();
    if (!cat) {
      console.log('Kategori "Lensa" not found, creating...');
      const [newId] = await db('kategori').insert({ nama: 'Lensa', deskripsi: 'Imported Lensa' }).returning('id');
      cat = { id: newId.id || newId };
    }
    
    const catId = cat.id;

    const results = [];
    fs.createReadStream('import/lensa test.csv')
      .pipe(csv())
      .on('data', (data) => results.push(data))
      .on('end', async () => {
        console.log(`Parsed ${results.length} rows from CSV.`);

        let insertedCount = 0;
        let batch = [];
        
        // Deduplicate in memory
        const dedupedMap = new Map();
        for (const row of results) {
          const barcode = row.barcode || null;
          const rawName = (row.namabarang || '').trim();
          let parsedName = rawName;
          let sph = null;
          let cyl = null;
          let add = null;

          const match = rawName.match(/(.*?)\(\s*SPH\s*:\s*(.*?)\s*CYL\s*:\s*(.*?)\s*ADD\s*:\s*(.*?)\s*\)/i);
          if (match) {
            sph = match[2].trim() || null;
            cyl = match[3].trim() || null;
            add = match[4].trim() || null;
          }

          const qty = parseInt(row['Qty K'], 10) || 0;
          const rawHarga = (row.HJ || '').replace(/,/g, '');
          const hargaJual = parseFloat(rawHarga) || 0;

          dedupedMap.set(barcode, {
            nama_barang: parsedName,
            barcode_id: barcode,
            kategori_id: catId,
            harga_jual: hargaJual,
            qty: qty,
            sph_r: sph,
            sph_l: sph,
            cyl_r: cyl,
            cyl_l: cyl,
            add_r: add,
            add_l: add
          });
        }

        const finalResults = Array.from(dedupedMap.values());
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

        console.log(`Import completed! Inserted ${insertedCount} items.`);
        process.exit(0);
      });
  } catch (error) {
    console.error('Error importing:', error);
    process.exit(1);
  }
}

run();
