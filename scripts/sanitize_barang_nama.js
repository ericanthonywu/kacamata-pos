const knex = require('knex');
const config = require('../knexfile');
const db = knex(config);

async function run() {
  try {
    const barang = await db('barang').select('id', 'nama_barang');
    let count = 0;
    
    for (const b of barang) {
      if (b.nama_barang.includes('( SPH')) {
        const cleanName = b.nama_barang.split('( SPH')[0].trim();
        await db('barang').where({ id: b.id }).update({ nama_barang: cleanName });
        count++;
      } else if (b.nama_barang.includes('(SPH')) {
        const cleanName = b.nama_barang.split('(SPH')[0].trim();
        await db('barang').where({ id: b.id }).update({ nama_barang: cleanName });
        count++;
      }
    }
    
    console.log(`Successfully cleaned ${count} barang records.`);
  } catch (err) {
    console.error(err);
  } finally {
    db.destroy();
  }
}

run();
