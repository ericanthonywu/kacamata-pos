require('dotenv').config();
const knex = require('knex')(require('../knexfile'));

// Parse "( SPH : +050 CYL : -025 ADD : 0 )" → { sph, cyl, add }
// Returns null values for empty fields
function parseRx(namaBarang) {
  const match = namaBarang.match(
    /\(\s*SPH\s*:\s*([^C]*?)\s*CYL\s*:\s*([^A]*?)\s*ADD\s*:\s*([^)]*?)\s*\)/i
  );
  if (!match) return null;

  const clean = (v) => {
    const s = v.trim();
    return s === '' || s === '-' ? null : s;
  };

  return {
    sph: clean(match[1]),
    cyl: clean(match[2]),
    add: clean(match[3]),
  };
}

// Remove the "(SPH ... ADD ...)" block and clean up name
function cleanName(namaBarang) {
  return namaBarang
    .replace(/\(\s*SPH\s*:.*?ADD\s*:[^)]*\)/i, '')
    .replace(/\s{2,}/g, ' ')
    .trim();
}

// Detect if name has an explicit L or R side marker before the "("
// e.g. "CR PROG MC L ( SPH..." → 'L', "CR PROG MC R ( SPH..." → 'R', else null
function detectSide(namaBarang) {
  const match = namaBarang.match(/\b([LR])\s*\(\s*SPH/i);
  return match ? match[1].toUpperCase() : null;
}

async function run() {
  const rows = await knex('barang')
    .whereRaw("nama_barang ILIKE '%SPH%'")
    .select('id', 'nama_barang');

  console.log(`Processing ${rows.length} rows...`);

  let updated = 0;
  let skipped = 0;

  for (const row of rows) {
    const rx = parseRx(row.nama_barang);
    if (!rx) { skipped++; continue; }

    const side = detectSide(row.nama_barang);
    const newName = cleanName(row.nama_barang);

    const patch = { nama_barang: newName, sph_l: null, sph_r: null, cyl_l: null, cyl_r: null, add_l: null, add_r: null };

    if (side === 'L') {
      patch.sph_l = rx.sph; patch.cyl_l = rx.cyl; patch.add_l = rx.add;
    } else if (side === 'R') {
      patch.sph_r = rx.sph; patch.cyl_r = rx.cyl; patch.add_r = rx.add;
    } else {
      patch.sph_l = rx.sph; patch.sph_r = rx.sph;
      patch.cyl_l = rx.cyl; patch.cyl_r = rx.cyl;
      patch.add_l = rx.add; patch.add_r = rx.add;
    }

    await knex('barang').where({ id: row.id }).update(patch);
    updated++;
  }

  console.log(`Updated: ${updated}, skipped: ${skipped}`);

  // Spot-check a few
  const samples = await knex('barang')
    .whereNotNull('sph_l')
    .orWhereNotNull('sph_r')
    .select('nama_barang', 'sph_l', 'sph_r', 'cyl_l', 'cyl_r', 'add_l', 'add_r')
    .limit(5);
  console.log('\nSample results:');
  samples.forEach(r => console.log(r));

  await knex.destroy();
}

run().catch(e => { console.error(e.message); process.exit(1); });
