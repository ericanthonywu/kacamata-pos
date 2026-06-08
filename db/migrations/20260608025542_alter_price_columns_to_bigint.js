exports.up = async function(knex) {
  const alterQuery = `
    ALTER TABLE barang ALTER COLUMN harga_jual TYPE bigint USING harga_jual::bigint;
    
    ALTER TABLE pembelian ALTER COLUMN total_harga TYPE bigint USING total_harga::bigint;
    ALTER TABLE pembelian_detail ALTER COLUMN harga_beli TYPE bigint USING harga_beli::bigint;
    
    ALTER TABLE penjualan ALTER COLUMN biaya TYPE bigint USING biaya::bigint;
    ALTER TABLE penjualan ALTER COLUMN subtotal TYPE bigint USING subtotal::bigint;
    ALTER TABLE penjualan ALTER COLUMN bpjs TYPE bigint USING bpjs::bigint;
    ALTER TABLE penjualan ALTER COLUMN total TYPE bigint USING total::bigint;
    ALTER TABLE penjualan ALTER COLUMN dp TYPE bigint USING dp::bigint;
    
    ALTER TABLE penjualan_detail ALTER COLUMN harga TYPE bigint USING harga::bigint;
    ALTER TABLE penjualan_detail ALTER COLUMN diskon TYPE bigint USING diskon::bigint;
    
    ALTER TABLE pembayaran_pembelian ALTER COLUMN jumlah_bayar TYPE bigint USING jumlah_bayar::bigint;
    ALTER TABLE pembayaran_penjualan ALTER COLUMN jumlah_bayar TYPE bigint USING jumlah_bayar::bigint;
    
    ALTER TABLE pembelian_retur ALTER COLUMN total_retur TYPE bigint USING total_retur::bigint;
    ALTER TABLE pembelian_retur_detail ALTER COLUMN harga_beli TYPE bigint USING harga_beli::bigint;
    
    ALTER TABLE penjualan_retur ALTER COLUMN total_retur TYPE bigint USING total_retur::bigint;
    ALTER TABLE penjualan_retur_detail ALTER COLUMN harga TYPE bigint USING harga::bigint;
  `;
  await knex.raw(alterQuery);
};

exports.down = async function(knex) {
  const alterQuery = `
    ALTER TABLE barang ALTER COLUMN harga_jual TYPE numeric(15,2) USING harga_jual::numeric;
    
    ALTER TABLE pembelian ALTER COLUMN total_harga TYPE numeric(15,2) USING total_harga::numeric;
    ALTER TABLE pembelian_detail ALTER COLUMN harga_beli TYPE numeric(15,2) USING harga_beli::numeric;
    
    ALTER TABLE penjualan ALTER COLUMN biaya TYPE numeric(15,2) USING biaya::numeric;
    ALTER TABLE penjualan ALTER COLUMN subtotal TYPE numeric(15,2) USING subtotal::numeric;
    ALTER TABLE penjualan ALTER COLUMN bpjs TYPE numeric(15,2) USING bpjs::numeric;
    ALTER TABLE penjualan ALTER COLUMN total TYPE numeric(15,2) USING total::numeric;
    ALTER TABLE penjualan ALTER COLUMN dp TYPE numeric(15,2) USING dp::numeric;
    
    ALTER TABLE penjualan_detail ALTER COLUMN harga TYPE numeric(15,2) USING harga::numeric;
    ALTER TABLE penjualan_detail ALTER COLUMN diskon TYPE numeric(15,2) USING diskon::numeric;
    
    ALTER TABLE pembayaran_pembelian ALTER COLUMN jumlah_bayar TYPE numeric(15,2) USING jumlah_bayar::numeric;
    ALTER TABLE pembayaran_penjualan ALTER COLUMN jumlah_bayar TYPE numeric(15,2) USING jumlah_bayar::numeric;
    
    ALTER TABLE pembelian_retur ALTER COLUMN total_retur TYPE numeric(15,2) USING total_retur::numeric;
    ALTER TABLE pembelian_retur_detail ALTER COLUMN harga_beli TYPE numeric(15,2) USING harga_beli::numeric;
    
    ALTER TABLE penjualan_retur ALTER COLUMN total_retur TYPE numeric(15,2) USING total_retur::numeric;
    ALTER TABLE penjualan_retur_detail ALTER COLUMN harga TYPE numeric(15,2) USING harga::numeric;
  `;
  await knex.raw(alterQuery);
};
