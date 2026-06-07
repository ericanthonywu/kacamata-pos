/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = async function(knex) {
  // Add tanggal_selesai
  const hasCol = await knex.schema.hasColumn('penjualan', 'tanggal_selesai');
  if (!hasCol) {
    await knex.schema.alterTable('penjualan', (table) => {
      table.date('tanggal_selesai');
    });
  }

  // Convert bpjs to numeric
  await knex.raw("ALTER TABLE penjualan ALTER COLUMN bpjs DROP DEFAULT");
  await knex.raw("ALTER TABLE penjualan ALTER COLUMN bpjs TYPE numeric(15,2) USING NULLIF(bpjs, '')::numeric");
  await knex.raw("ALTER TABLE penjualan ALTER COLUMN bpjs SET DEFAULT 0");
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = async function(knex) {
  await knex.raw("ALTER TABLE penjualan ALTER COLUMN bpjs DROP DEFAULT");
  await knex.raw("ALTER TABLE penjualan ALTER COLUMN bpjs TYPE varchar(200) USING bpjs::varchar");
  await knex.raw("ALTER TABLE penjualan ALTER COLUMN bpjs SET DEFAULT ''");
  
  await knex.schema.alterTable('penjualan', (table) => {
    table.dropColumn('tanggal_selesai');
  });
};
