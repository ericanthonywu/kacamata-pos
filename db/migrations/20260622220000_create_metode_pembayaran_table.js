/**
 * @param { import("knex").Knex } knex
 */
exports.up = async function (knex) {
  await knex.schema.createTable('metode_pembayaran', (t) => {
    t.increments('id').primary();
    t.string('nama', 50).notNullable();
  });

  await knex('metode_pembayaran').insert([
    { nama: 'Cash' },
    { nama: 'Transfer BCA' },
    { nama: 'Transfer BNI' },
    { nama: 'Transfer BRI' },
    { nama: 'Transfer Mandiri' },
    { nama: 'Transfer Sinarmas' }
  ]);

  // If the previous string column exists, drop it
  const hasColumn = await knex.schema.hasColumn('penjualan', 'metode_bayar');
  if (hasColumn) {
    await knex.schema.alterTable('penjualan', (t) => {
      t.dropColumn('metode_bayar');
    });
  }

  await knex.schema.alterTable('penjualan', (t) => {
    t.integer('metode_bayar_id').unsigned().references('id').inTable('metode_pembayaran').onDelete('SET NULL');
  });
};

/**
 * @param { import("knex").Knex } knex
 */
exports.down = async function (knex) {
  await knex.schema.alterTable('penjualan', (t) => {
    t.dropColumn('metode_bayar_id');
    t.string('metode_bayar', 20).nullable();
  });
  await knex.schema.dropTableIfExists('metode_pembayaran');
};
