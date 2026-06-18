/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = function(knex) {
  return knex.schema.alterTable('penjualan', function(table) {
    table.boolean('is_b2b').notNullable().defaultTo(false);
    table.index('is_b2b');
  });
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = function(knex) {
  return knex.schema.alterTable('penjualan', function(table) {
    table.dropIndex('is_b2b');
    table.dropColumn('is_b2b');
  });
};
