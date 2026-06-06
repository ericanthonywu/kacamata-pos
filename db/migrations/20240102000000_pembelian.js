/**
 * @param { import("knex").Knex } knex
 */
exports.up = function (knex) {
  return knex.schema
    .createTable('pembelian', (t) => {
      t.increments('id').primary();
      t.string('kode_pembelian', 30).notNullable().unique();
      t.date('tanggal_pembelian').notNullable().defaultTo(knex.fn.now());
      t.integer('supplier_id').unsigned().references('id').inTable('supplier').onDelete('SET NULL');
      t.decimal('total_harga', 15, 2).notNullable().defaultTo(0);
      t.timestamp('created_at').defaultTo(knex.fn.now());
      t.timestamp('updated_at').defaultTo(knex.fn.now());
      t.index('supplier_id');
      t.index('tanggal_pembelian');
    })
    .createTable('pembelian_detail', (t) => {
      t.increments('id').primary();
      t.integer('pembelian_id').unsigned().notNullable().references('id').inTable('pembelian').onDelete('CASCADE');
      t.integer('barang_id').unsigned().references('id').inTable('barang').onDelete('SET NULL');
      t.integer('jumlah').notNullable().defaultTo(1);
      t.decimal('harga_beli', 15, 2).notNullable().defaultTo(0);
      t.index('pembelian_id');
    });
};

/**
 * @param { import("knex").Knex } knex
 */
exports.down = function (knex) {
  return knex.schema
    .dropTableIfExists('pembelian_detail')
    .dropTableIfExists('pembelian');
};
