/**
 * @param { import("knex").Knex } knex
 */
exports.up = async function (knex) {
  // 1. Create table cabang
  const hasCabang = await knex.schema.hasTable('cabang');
  if (!hasCabang) {
    await knex.schema.createTable('cabang', (t) => {
      t.increments('id').primary();
      t.string('nama', 100).notNullable();
      t.text('alamat').nullable();
      t.string('no_telp', 50).nullable();
      t.timestamp('created_at').defaultTo(knex.fn.now());
    });

    // Seed default branch (Cabang Utama id = 1) for existing production data
    await knex('cabang').insert({
      id: 1,
      nama: 'Cabang Utama',
      alamat: 'Pusat',
      no_telp: '-',
    });
  }

  const tablesToUpdate = [
    'pengguna',
    'kategori',
    'barang',
    'supplier',
    'pelanggan',
    'sales',
    'metode_pembayaran',
    'penjualan',
    'penjualan_detail',
    'pembayaran_penjualan',
    'kas',
    'komisi_sales',
    'penjualan_retur',
    'penjualan_retur_detail',
    'pembelian',
    'pembelian_detail',
    'pembayaran_pembelian',
    'pembelian_retur',
    'pembelian_retur_detail',
    'bukti_hitung_fisik',
  ];

  for (let i = 0; i < tablesToUpdate.length; i++) {
    const table = tablesToUpdate[i];
    const hasCol = await knex.schema.hasColumn(table, 'cabang_id');
    if (!hasCol) {
      await knex.schema.table(table, (t) => {
        t.integer('cabang_id').unsigned().references('id').inTable('cabang').defaultTo(1);
        t.index('cabang_id');
      });
      // Ensure all existing rows have cabang_id = 1
      await knex(table).whereNull('cabang_id').update({ cabang_id: 1 });
    }
  }

  // Update unique constraint on pengguna: change unique(username) to unique(username, cabang_id)
  await knex.schema.table('pengguna', (t) => {
    t.dropUnique(['username']);
    t.unique(['username', 'cabang_id']);
  });

  // 3. Create transfer_stock table
  const hasTransferStock = await knex.schema.hasTable('transfer_stock');
  if (!hasTransferStock) {
    await knex.schema.createTable('transfer_stock', (t) => {
      t.increments('id').primary();
      t.string('kode_transfer', 50).notNullable().unique();
      t.integer('dari_cabang_id').unsigned().notNullable().references('id').inTable('cabang');
      t.integer('ke_cabang_id').unsigned().notNullable().references('id').inTable('cabang');
      t.integer('barang_id_asal').unsigned().notNullable().references('id').inTable('barang');
      t.integer('barang_id_tujuan').unsigned().notNullable().references('id').inTable('barang');
      t.integer('jumlah').notNullable();
      t.text('catatan').nullable();
      t.integer('created_by').unsigned().references('id').inTable('pengguna').onDelete('SET NULL');
      t.timestamp('created_at').defaultTo(knex.fn.now());

      t.index('dari_cabang_id');
      t.index('ke_cabang_id');
      t.index('barang_id_asal');
      t.index('barang_id_tujuan');
    });
  }
};

/**
 * @param { import("knex").Knex } knex
 */
exports.down = async function (knex) {
  await knex.schema.dropTableIfExists('transfer_stock');

  const tablesToUpdate = [
    'pengguna',
    'kategori',
    'barang',
    'supplier',
    'pelanggan',
    'sales',
    'metode_pembayaran',
    'penjualan',
    'penjualan_detail',
    'pembayaran_penjualan',
    'kas',
    'komisi_sales',
    'penjualan_retur',
    'penjualan_retur_detail',
    'pembelian',
    'pembelian_detail',
    'pembayaran_pembelian',
    'pembelian_retur',
    'pembelian_retur_detail',
    'bukti_hitung_fisik',
  ];

  for (let i = 0; i < tablesToUpdate.length; i++) {
    const table = tablesToUpdate[i];
    const hasCol = await knex.schema.hasColumn(table, 'cabang_id');
    if (hasCol) {
      if (table === 'pengguna') {
        await knex.schema.table('pengguna', (t) => {
          t.dropUnique(['username', 'cabang_id']);
          t.unique(['username']);
        });
      }
      await knex.schema.table(table, (t) => {
        t.dropColumn('cabang_id');
      });
    }
  }

  await knex.schema.dropTableIfExists('cabang');
};
