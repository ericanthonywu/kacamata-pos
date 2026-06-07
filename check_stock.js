const fs = require('fs');
const csv = require('csv-parser');
const knex = require('knex');
const knexConfig = require('./knexfile.js');

const db = knex(knexConfig);

async function run() {
  const csvStock = new Map();
  fs.createReadStream('import/lensa test.csv')
    .pipe(csv())
    .on('data', (row) => {
      // The script before didn't parse parsedName correctly for matching if the user wanted full names.
      // But now we kept rawName for nama_barang. So we just match by rawName!
      const name = (row.namabarang || '').trim();
      const qty = parseInt(row['Qty K'], 10) || 0;
      csvStock.set(name, qty);
    })
    .on('end', async () => {
      console.log('Comparing CSV stock vs DB stock by exact name...');
      let mismatchCount = 0;
      const dbItems = await db('barang').select('nama_barang', 'qty');
      
      for (const item of dbItems) {
        const dbName = item.nama_barang;
        const dbQty = item.qty;
        if (csvStock.has(dbName)) {
          const csvQty = csvStock.get(dbName);
          if (dbQty !== csvQty) {
            console.log(`Mismatch: "${dbName}" | DB Qty: ${dbQty} | CSV Qty: ${csvQty}`);
            mismatchCount++;
          }
        } else {
          // console.log(`Not found in CSV: "${dbName}"`);
        }
      }
      
      console.log(`\nFound ${mismatchCount} mismatches.`);
      process.exit(0);
    });
}
run();
