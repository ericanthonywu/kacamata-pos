/**
 * Creates the `bukti_hitung_fisik` table for logging physical stock count adjustments.
 *
 * @param { import("knex").Knex } knex
 */
exports.up = function (knex) {
  return knex.schema.createTable('bukti_hitung_fisik', (t) => {
    t.increments('id').primary();
    t.integer('barang_id').unsigned().references('id').inTable('barang').onDelete('SET NULL');
    t.string('nama_barang').notNullable();
    t.string('barcode_id').defaultTo('');
    t.integer('qty_sebelum').notNullable().defaultTo(0);
    t.integer('qty_sesudah').notNullable().defaultTo(0);
    t.integer('selisih').notNullable().defaultTo(0);
    t.string('diubah_oleh').notNullable().defaultTo('');
    t.timestamp('created_at').defaultTo(knex.fn.now());

    t.index('barang_id');
    t.index('created_at');
  });
};

/**
 * @param { import("knex").Knex } knex
 */
exports.down = function (knex) {
  return knex.schema.dropTableIfExists('bukti_hitung_fisik');
};
