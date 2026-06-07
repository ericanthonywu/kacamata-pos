exports.up = function(knex) {
  return knex.schema.alterTable('barang', function(table) {
    table.dropColumn('axis_l');
    table.dropColumn('axis_r');
  });
};

exports.down = function(knex) {
  return knex.schema.alterTable('barang', function(table) {
    table.string('axis_l', 20);
    table.string('axis_r', 20);
  });
};
