/**
 * @param { import("knex").Knex } knex
 */
exports.up = function (knex) {
  return knex.schema
    .createTable('kategori', (t) => {
      t.increments('id').primary();
      t.string('nama', 100).notNullable();
      t.timestamp('created_at').defaultTo(knex.fn.now());
    })
    .createTable('barang', (t) => {
      t.increments('id').primary();
      t.string('nama_barang', 200).notNullable();
      t.integer('kategori_id').unsigned().references('id').inTable('kategori').onDelete('SET NULL');
      t.integer('qty').notNullable().defaultTo(0);
      t.decimal('harga_jual', 15, 2).notNullable().defaultTo(0);
      t.string('barcode_id', 50).unique();
      t.timestamp('created_at').defaultTo(knex.fn.now());
      t.timestamp('updated_at').defaultTo(knex.fn.now());
      t.index('kategori_id');
      t.index('nama_barang');
    })
    .createTable('supplier', (t) => {
      t.increments('id').primary();
      t.string('nama', 200).notNullable();
      t.timestamp('created_at').defaultTo(knex.fn.now());
    })
    .createTable('pelanggan', (t) => {
      t.increments('id').primary();
      t.string('nama', 200).notNullable();
      t.string('no_telp', 20);
      t.timestamp('created_at').defaultTo(knex.fn.now());
      t.index('nama');
    })
    .createTable('sales', (t) => {
      t.increments('id').primary();
      t.string('nama', 200).notNullable();
      t.date('tanggal_kerja').notNullable().defaultTo(knex.fn.now());
      t.string('status', 20).notNullable().defaultTo('aktif');
      t.timestamp('created_at').defaultTo(knex.fn.now());
    })
    .createTable('pengguna', (t) => {
      t.increments('id').primary();
      t.string('nama', 200).notNullable();
      t.string('username', 100).notNullable().unique();
      t.string('password_hash', 255).notNullable();
      t.string('hak_akses', 50).notNullable().defaultTo('kasir');
      t.timestamp('created_at').defaultTo(knex.fn.now());
    })
    .createTable('penjualan', (t) => {
      t.increments('id').primary();
      t.string('no_nota', 30).notNullable().unique();
      t.integer('pelanggan_id').unsigned().references('id').inTable('pelanggan').onDelete('SET NULL');
      t.integer('sales_id').unsigned().references('id').inTable('sales').onDelete('SET NULL');
      t.integer('created_by').unsigned().references('id').inTable('pengguna').onDelete('SET NULL');
      t.date('order_date').notNullable().defaultTo(knex.fn.now());
      t.decimal('biaya', 15, 2).notNullable().defaultTo(0);
      t.decimal('subtotal', 15, 2).notNullable().defaultTo(0);
      t.string('bpjs', 200).defaultTo('');
      t.decimal('total', 15, 2).notNullable().defaultTo(0);
      t.timestamp('created_at').defaultTo(knex.fn.now());
      t.index('pelanggan_id');
      t.index('sales_id');
      t.index('order_date');
    })
    .createTable('penjualan_detail', (t) => {
      t.increments('id').primary();
      t.integer('penjualan_id').unsigned().notNullable().references('id').inTable('penjualan').onDelete('CASCADE');
      t.string('tipe', 20).notNullable(); // frame, lensa_l, lensa_r
      t.integer('barang_id').unsigned().references('id').inTable('barang').onDelete('SET NULL');
      t.decimal('harga', 15, 2).notNullable().defaultTo(0);
      t.decimal('diskon', 15, 2).notNullable().defaultTo(0);
      t.integer('jumlah').notNullable().defaultTo(1);
      t.index('penjualan_id');
    });
};

/**
 * @param { import("knex").Knex } knex
 */
exports.down = function (knex) {
  return knex.schema
    .dropTableIfExists('penjualan_detail')
    .dropTableIfExists('penjualan')
    .dropTableIfExists('pengguna')
    .dropTableIfExists('sales')
    .dropTableIfExists('pelanggan')
    .dropTableIfExists('supplier')
    .dropTableIfExists('barang')
    .dropTableIfExists('kategori');
};
