/**
 * Make barang.qty NOT NULL with DEFAULT 0.
 * 1. Backfill any existing NULL qty values to 0.
 * 2. Set column to NOT NULL with DEFAULT 0.
 *
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = async function(knex) {
  // 1. Backfill NULL → 0
  await knex('barang').whereNull('qty').update({ qty: 0 });

  // 2. Alter column to NOT NULL with default 0
  await knex.schema.alterTable('barang', function(table) {
    table.integer('qty').notNullable().defaultTo(0).alter();
  });
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = function(knex) {
  return knex.schema.alterTable('barang', function(table) {
    table.integer('qty').nullable().alter();
  });
};
