/**
 * @param { import("knex").Knex } knex
 */
exports.up = function (knex) {
  return knex.schema
    .alterTable('penjualan', (t) => {
      // nullable for old data
      t.string('metode_bayar', 20).nullable().defaultTo(null);
    });
};

/**
 * @param { import("knex").Knex } knex
 */
exports.down = function (knex) {
  return knex.schema
    .alterTable('penjualan', (t) => {
      t.dropColumn('metode_bayar');
    });
};
