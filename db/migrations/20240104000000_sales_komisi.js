/**
 * @param { import("knex").Knex } knex
 */
exports.up = function (knex) {
  return knex.schema.alterTable('sales', (t) => {
    t.decimal('persentase_komisi', 5, 2).notNullable().defaultTo(0);
  });
};

/**
 * @param { import("knex").Knex } knex
 */
exports.down = function (knex) {
  return knex.schema.alterTable('sales', (t) => {
    t.dropColumn('persentase_komisi');
  });
};
