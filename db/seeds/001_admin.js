const bcrypt = require('bcryptjs');

/**
 * @param { import("knex").Knex } knex
 */
exports.seed = async function (knex) {
  // Check if admin exists
  const existing = await knex('pengguna').where('username', 'admin').first();
  if (!existing) {
    const hash = await bcrypt.hash('admin123', 10);
    await knex('pengguna').insert({
      nama: 'Administrator',
      username: 'admin',
      password_hash: hash,
      hak_akses: 'admin',
    });
    console.log('✓ Admin user created (admin / admin123)');
  }

  // Seed default categories
  const catCount = await knex('kategori').count('id as cnt').first();
  if (parseInt(catCount.cnt) === 0) {
    await knex('kategori').insert([
      { nama: 'Frame' },
      { nama: 'Lensa' },
      { nama: 'Aksesoris' },
    ]);
    console.log('✓ Default categories created');
  }
};
