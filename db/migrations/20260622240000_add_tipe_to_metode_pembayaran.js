/**
 * @param { import("knex").Knex } knex
 */
exports.up = async function (knex) {
  await knex.schema.alterTable('metode_pembayaran', (t) => {
    t.string('tipe', 20).notNullable().defaultTo('transfer');
  });

  // Set Cash to 'cash' type
  await knex('metode_pembayaran')
    .whereRaw('LOWER(nama) = ?', ['cash'])
    .update({ tipe: 'cash' });
};

/**
 * @param { import("knex").Knex } knex
 */
exports.down = async function (knex) {
  await knex.schema.alterTable('metode_pembayaran', (t) => {
    t.dropColumn('tipe');
  });
};
