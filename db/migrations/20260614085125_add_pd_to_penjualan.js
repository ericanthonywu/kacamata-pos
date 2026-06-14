exports.up = function(knex) {
  return knex.schema.alterTable('penjualan', function(table) {
    table.string('pd', 20).nullable();
  });
};

exports.down = function(knex) {
  return knex.schema.alterTable('penjualan', function(table) {
    table.dropColumn('pd');
  });
};
