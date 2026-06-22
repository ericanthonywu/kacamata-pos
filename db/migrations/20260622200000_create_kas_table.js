/**
 * Creates the `kas` table as a unified cashflow ledger.
 * Populates it with existing data from pembayaran_penjualan and penjualan_retur.
 *
 * @param { import("knex").Knex } knex
 */
exports.up = function (knex) {
  return knex.schema
    .createTable('kas', (t) => {
      t.increments('id').primary();
      t.string('tipe', 10).notNullable();          // 'masuk' or 'keluar'
      t.string('kategori', 30).notNullable();       // 'pembayaran_lunas', 'down_payment', 'pelunasan', 'retur_penjualan'
      t.decimal('jumlah', 15, 2).notNullable().defaultTo(0);
      t.date('tanggal').notNullable();
      t.integer('referensi_id').unsigned().notNullable();
      t.string('referensi_tipe', 30).notNullable(); // 'pembayaran_penjualan' or 'penjualan_retur'
      t.integer('penjualan_id').unsigned().references('id').inTable('penjualan').onDelete('CASCADE');
      t.string('no_referensi', 30).defaultTo('');   // no_nota or kode_retur
      t.text('keterangan').defaultTo('');
      t.timestamp('created_at').defaultTo(knex.fn.now());
      t.index('penjualan_id');
      t.index('tanggal');
      t.index('tipe');
      t.index(['referensi_id', 'referensi_tipe']);
    })
    .then(() => {
      // Migrate existing pembayaran_penjualan data → kas (cash in)
      return knex.raw(`
        INSERT INTO kas (tipe, kategori, jumlah, tanggal, referensi_id, referensi_tipe, penjualan_id, no_referensi, keterangan, created_at)
        SELECT
          'masuk',
          CASE
            WHEN pp.keterangan = 'Pembayaran lunas' THEN 'pembayaran_lunas'
            WHEN pp.keterangan = 'Down Payment' THEN 'down_payment'
            ELSE 'pelunasan'
          END,
          pp.jumlah_bayar,
          pp.tanggal_bayar,
          pp.id,
          'pembayaran_penjualan',
          pp.penjualan_id,
          p.no_nota,
          pp.keterangan,
          pp.created_at
        FROM pembayaran_penjualan pp
        INNER JOIN penjualan p ON pp.penjualan_id = p.id
      `);
    })
    .then(() => {
      // Migrate existing penjualan_retur data → kas (cash out)
      return knex.raw(`
        INSERT INTO kas (tipe, kategori, jumlah, tanggal, referensi_id, referensi_tipe, penjualan_id, no_referensi, keterangan, created_at)
        SELECT
          'keluar',
          'retur_penjualan',
          pr.total_retur,
          pr.tanggal_retur,
          pr.id,
          'penjualan_retur',
          pr.penjualan_id,
          pr.kode_retur,
          'Retur Penjualan',
          pr.created_at
        FROM penjualan_retur pr
      `);
    });
};

/**
 * @param { import("knex").Knex } knex
 */
exports.down = function (knex) {
  return knex.schema.dropTableIfExists('kas');
};
