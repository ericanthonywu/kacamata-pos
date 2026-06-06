/**
 * @param { import("knex").Knex } knex
 */
exports.up = function (knex) {
  return knex.schema
    // --- Modify existing tables ---
    .alterTable('penjualan', (t) => {
      t.string('status_bayar', 20).notNullable().defaultTo('lunas');
      t.decimal('dp', 15, 2).notNullable().defaultTo(0);
    })
    .alterTable('pembelian', (t) => {
      t.string('status_bayar', 20).notNullable().defaultTo('belum_lunas');
    })
    // --- Pembelian Retur ---
    .createTable('pembelian_retur', (t) => {
      t.increments('id').primary();
      t.string('kode_retur', 30).notNullable().unique();
      t.integer('pembelian_id').unsigned().notNullable().references('id').inTable('pembelian').onDelete('CASCADE');
      t.date('tanggal_retur').notNullable().defaultTo(knex.fn.now());
      t.decimal('total_retur', 15, 2).notNullable().defaultTo(0);
      t.timestamp('created_at').defaultTo(knex.fn.now());
      t.index('pembelian_id');
    })
    .createTable('pembelian_retur_detail', (t) => {
      t.increments('id').primary();
      t.integer('pembelian_retur_id').unsigned().notNullable().references('id').inTable('pembelian_retur').onDelete('CASCADE');
      t.integer('barang_id').unsigned().references('id').inTable('barang').onDelete('SET NULL');
      t.integer('jumlah').notNullable().defaultTo(1);
      t.decimal('harga_beli', 15, 2).notNullable().defaultTo(0);
      t.index('pembelian_retur_id');
    })
    // --- Penjualan Retur ---
    .createTable('penjualan_retur', (t) => {
      t.increments('id').primary();
      t.string('kode_retur', 30).notNullable().unique();
      t.integer('penjualan_id').unsigned().notNullable().references('id').inTable('penjualan').onDelete('CASCADE');
      t.date('tanggal_retur').notNullable().defaultTo(knex.fn.now());
      t.decimal('total_retur', 15, 2).notNullable().defaultTo(0);
      t.timestamp('created_at').defaultTo(knex.fn.now());
      t.index('penjualan_id');
    })
    .createTable('penjualan_retur_detail', (t) => {
      t.increments('id').primary();
      t.integer('penjualan_retur_id').unsigned().notNullable().references('id').inTable('penjualan_retur').onDelete('CASCADE');
      t.integer('barang_id').unsigned().references('id').inTable('barang').onDelete('SET NULL');
      t.string('tipe', 20).notNullable();
      t.integer('jumlah').notNullable().defaultTo(1);
      t.decimal('harga', 15, 2).notNullable().defaultTo(0);
      t.index('penjualan_retur_id');
    })
    // --- Payment tables ---
    .createTable('pembayaran_pembelian', (t) => {
      t.increments('id').primary();
      t.integer('pembelian_id').unsigned().notNullable().references('id').inTable('pembelian').onDelete('CASCADE');
      t.date('tanggal_bayar').notNullable().defaultTo(knex.fn.now());
      t.decimal('jumlah_bayar', 15, 2).notNullable().defaultTo(0);
      t.text('keterangan').defaultTo('');
      t.timestamp('created_at').defaultTo(knex.fn.now());
      t.index('pembelian_id');
    })
    .createTable('pembayaran_penjualan', (t) => {
      t.increments('id').primary();
      t.integer('penjualan_id').unsigned().notNullable().references('id').inTable('penjualan').onDelete('CASCADE');
      t.date('tanggal_bayar').notNullable().defaultTo(knex.fn.now());
      t.decimal('jumlah_bayar', 15, 2).notNullable().defaultTo(0);
      t.text('keterangan').defaultTo('');
      t.timestamp('created_at').defaultTo(knex.fn.now());
      t.index('penjualan_id');
    });
};

/**
 * @param { import("knex").Knex } knex
 */
exports.down = function (knex) {
  return knex.schema
    .dropTableIfExists('pembayaran_penjualan')
    .dropTableIfExists('pembayaran_pembelian')
    .dropTableIfExists('penjualan_retur_detail')
    .dropTableIfExists('penjualan_retur')
    .dropTableIfExists('pembelian_retur_detail')
    .dropTableIfExists('pembelian_retur')
    .alterTable('pembelian', (t) => {
      t.dropColumn('status_bayar');
    })
    .alterTable('penjualan', (t) => {
      t.dropColumn('status_bayar');
      t.dropColumn('dp');
    });
};
