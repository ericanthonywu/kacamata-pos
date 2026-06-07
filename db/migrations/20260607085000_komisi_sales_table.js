exports.up = async function (knex) {
  // Create table
  await knex.schema.createTable('komisi_sales', table => {
    table.increments('id').primary();
    table.integer('penjualan_id').unsigned().references('id').inTable('penjualan').onDelete('CASCADE');
    table.integer('sales_id').unsigned().references('id').inTable('sales').onDelete('CASCADE');
    table.string('tipe', 20).defaultTo('frame'); // 'frame' or 'lensa'
    table.decimal('persentase', 5, 2).defaultTo(0);
    table.decimal('nominal_komisi', 15, 2).defaultTo(0);
    table.timestamps(true, true);
  });

  // Migrate existing data based on current percentage
  const penjualanList = await knex('penjualan').whereNotNull('sales_id');
  for (const p of penjualanList) {
    const sales = await knex('sales').where('id', p.sales_id).first();
    if (!sales || parseFloat(sales.persentase_komisi) <= 0) continue;

    // Calculate total frame
    const details = await knex('penjualan_detail').where('penjualan_id', p.id);
    let frameTotal = 0;
    let lensaTotal = 0;
    
    for (const d of details) {
      const lineTotal = (parseFloat(d.harga || 0) - parseFloat(d.diskon || 0)) * parseInt(d.jumlah || 1);
      if (d.tipe === 'frame') frameTotal += lineTotal;
      else if (d.tipe === 'lensa_r' || d.tipe === 'lensa_l') lensaTotal += lineTotal;
    }
    
    if (frameTotal > 0) {
      const nominal = frameTotal * parseFloat(sales.persentase_komisi) / 100;
      await knex('komisi_sales').insert({
        penjualan_id: p.id, sales_id: p.sales_id, tipe: 'frame',
        persentase: sales.persentase_komisi, nominal_komisi: nominal,
        created_at: p.created_at, updated_at: p.updated_at
      });
    }

    if (lensaTotal > 0) {
      const nominal = lensaTotal * parseFloat(sales.persentase_komisi) / 100;
      await knex('komisi_sales').insert({
        penjualan_id: p.id, sales_id: p.sales_id, tipe: 'lensa',
        persentase: sales.persentase_komisi, nominal_komisi: nominal,
        created_at: p.created_at, updated_at: p.updated_at
      });
    }
  }
};

exports.down = function (knex) {
  return knex.schema.dropTableIfExists('komisi_sales');
};
