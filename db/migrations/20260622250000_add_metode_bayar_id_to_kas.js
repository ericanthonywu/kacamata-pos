/**
 * @param { import("knex").Knex } knex
 */
exports.up = async function (knex) {
  await knex.schema.alterTable('pembayaran_penjualan', (t) => {
    t.integer('metode_bayar_id').unsigned().references('id').inTable('metode_pembayaran').onDelete('SET NULL');
  });

  await knex.schema.alterTable('kas', (t) => {
    t.integer('metode_bayar_id').unsigned().references('id').inTable('metode_pembayaran').onDelete('SET NULL');
  });
};

/**
 * @param { import("knex").Knex } knex
 */
exports.down = async function (knex) {
  await knex.schema.alterTable('kas', (t) => {
    t.dropColumn('metode_bayar_id');
  });
  await knex.schema.alterTable('pembayaran_penjualan', (t) => {
    t.dropColumn('metode_bayar_id');
  });
};
