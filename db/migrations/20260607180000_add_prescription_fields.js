exports.up = function(knex) {
  return knex.schema
    .alterTable('barang', function(table) {
      table.string('sph_r', 20).nullable();
      table.string('sph_l', 20).nullable();
      table.string('cyl_r', 20).nullable();
      table.string('cyl_l', 20).nullable();
      table.string('axis_r', 20).nullable();
      table.string('axis_l', 20).nullable();
      table.string('add_r', 20).nullable();
      table.string('add_l', 20).nullable();
    })
    .alterTable('penjualan', function(table) {
      table.string('sph_r', 20).nullable();
      table.string('sph_l', 20).nullable();
      table.string('cyl_r', 20).nullable();
      table.string('cyl_l', 20).nullable();
      table.string('axis_r', 20).nullable();
      table.string('axis_l', 20).nullable();
      table.string('add_r', 20).nullable();
      table.string('add_l', 20).nullable();
    });
};

exports.down = function(knex) {
  return knex.schema
    .alterTable('barang', function(table) {
      table.dropColumns('sph_r', 'sph_l', 'cyl_r', 'cyl_l', 'axis_r', 'axis_l', 'add_r', 'add_l');
    })
    .alterTable('penjualan', function(table) {
      table.dropColumns('sph_r', 'sph_l', 'cyl_r', 'cyl_l', 'axis_r', 'axis_l', 'add_r', 'add_l');
    });
};
