/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = function(knex) {
  return knex.schema.alterTable('penjualan', (t) => {
    t.dropForeign('pelanggan_id');
    t.foreign('pelanggan_id').references('id').inTable('pelanggan').onDelete('RESTRICT');
  });
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = function(knex) {
  return knex.schema.alterTable('penjualan', (t) => {
    t.dropForeign('pelanggan_id');
    t.foreign('pelanggan_id').references('id').inTable('pelanggan').onDelete('SET NULL');
  });
};
