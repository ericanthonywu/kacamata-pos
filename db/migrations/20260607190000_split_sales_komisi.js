exports.up = function(knex) {
  return knex.schema.alterTable('sales', function(table) {
    table.renameColumn('persentase_komisi', 'komisi_frame');
    table.decimal('komisi_lensa', 5, 2).defaultTo(0);
  });
};

exports.down = function(knex) {
  return knex.schema.alterTable('sales', function(table) {
    table.dropColumn('komisi_lensa');
    table.renameColumn('komisi_frame', 'persentase_komisi');
  });
};
