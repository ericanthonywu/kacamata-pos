/**
 * @param { import("knex").Knex } knex
 */
exports.up = async function (knex) {
  await knex.schema.alterTable('metode_pembayaran', (t) => {
    t.datetime('deleted_at').nullable();
  });
};

/**
 * @param { import("knex").Knex } knex
 */
exports.down = async function (knex) {
  await knex.schema.alterTable('metode_pembayaran', (t) => {
    t.dropColumn('deleted_at');
  });
};
