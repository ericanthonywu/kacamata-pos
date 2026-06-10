--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Homebrew)
-- Dumped by pg_dump version 14.18 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: barang; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.barang (
    id integer NOT NULL,
    nama_barang character varying(200) NOT NULL,
    kategori_id integer,
    qty integer,
    harga_jual bigint DEFAULT '0'::numeric NOT NULL,
    barcode_id character varying(50),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    sph_r character varying(20),
    sph_l character varying(20),
    cyl_r character varying(20),
    cyl_l character varying(20),
    add_r character varying(20),
    add_l character varying(20)
);


ALTER TABLE public.barang OWNER TO ericanthony;

--
-- Name: barang_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.barang_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.barang_id_seq OWNER TO ericanthony;

--
-- Name: barang_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.barang_id_seq OWNED BY public.barang.id;


--
-- Name: kategori; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.kategori (
    id integer NOT NULL,
    nama character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.kategori OWNER TO ericanthony;

--
-- Name: kategori_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.kategori_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kategori_id_seq OWNER TO ericanthony;

--
-- Name: kategori_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.kategori_id_seq OWNED BY public.kategori.id;


--
-- Name: knex_migrations; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.knex_migrations (
    id integer NOT NULL,
    name character varying(255),
    batch integer,
    migration_time timestamp with time zone
);


ALTER TABLE public.knex_migrations OWNER TO ericanthony;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.knex_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knex_migrations_id_seq OWNER TO ericanthony;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.knex_migrations_id_seq OWNED BY public.knex_migrations.id;


--
-- Name: knex_migrations_lock; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.knex_migrations_lock (
    index integer NOT NULL,
    is_locked integer
);


ALTER TABLE public.knex_migrations_lock OWNER TO ericanthony;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.knex_migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knex_migrations_lock_index_seq OWNER TO ericanthony;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNED BY public.knex_migrations_lock.index;


--
-- Name: komisi_sales; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.komisi_sales (
    id integer NOT NULL,
    penjualan_id integer,
    sales_id integer,
    tipe character varying(20) DEFAULT 'frame'::character varying,
    persentase numeric(5,2) DEFAULT '0'::numeric,
    nominal_komisi numeric(15,2) DEFAULT '0'::numeric,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.komisi_sales OWNER TO ericanthony;

--
-- Name: komisi_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.komisi_sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.komisi_sales_id_seq OWNER TO ericanthony;

--
-- Name: komisi_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.komisi_sales_id_seq OWNED BY public.komisi_sales.id;


--
-- Name: pelanggan; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.pelanggan (
    id integer NOT NULL,
    nama character varying(200) NOT NULL,
    no_telp character varying(20),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.pelanggan OWNER TO ericanthony;

--
-- Name: pelanggan_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.pelanggan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pelanggan_id_seq OWNER TO ericanthony;

--
-- Name: pelanggan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.pelanggan_id_seq OWNED BY public.pelanggan.id;


--
-- Name: pembayaran_pembelian; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.pembayaran_pembelian (
    id integer NOT NULL,
    pembelian_id integer NOT NULL,
    tanggal_bayar date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    jumlah_bayar bigint DEFAULT '0'::numeric NOT NULL,
    keterangan text DEFAULT ''::text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.pembayaran_pembelian OWNER TO ericanthony;

--
-- Name: pembayaran_pembelian_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.pembayaran_pembelian_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pembayaran_pembelian_id_seq OWNER TO ericanthony;

--
-- Name: pembayaran_pembelian_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.pembayaran_pembelian_id_seq OWNED BY public.pembayaran_pembelian.id;


--
-- Name: pembayaran_penjualan; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.pembayaran_penjualan (
    id integer NOT NULL,
    penjualan_id integer NOT NULL,
    tanggal_bayar date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    jumlah_bayar bigint DEFAULT '0'::numeric NOT NULL,
    keterangan text DEFAULT ''::text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.pembayaran_penjualan OWNER TO ericanthony;

--
-- Name: pembayaran_penjualan_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.pembayaran_penjualan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pembayaran_penjualan_id_seq OWNER TO ericanthony;

--
-- Name: pembayaran_penjualan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.pembayaran_penjualan_id_seq OWNED BY public.pembayaran_penjualan.id;


--
-- Name: pembelian; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.pembelian (
    id integer NOT NULL,
    kode_pembelian character varying(30) NOT NULL,
    tanggal_pembelian date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    supplier_id integer,
    total_harga bigint DEFAULT '0'::numeric NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status_bayar character varying(20) DEFAULT 'belum_lunas'::character varying NOT NULL
);


ALTER TABLE public.pembelian OWNER TO ericanthony;

--
-- Name: pembelian_detail; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.pembelian_detail (
    id integer NOT NULL,
    pembelian_id integer NOT NULL,
    barang_id integer,
    jumlah integer DEFAULT 1 NOT NULL,
    harga_beli bigint DEFAULT '0'::numeric NOT NULL
);


ALTER TABLE public.pembelian_detail OWNER TO ericanthony;

--
-- Name: pembelian_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.pembelian_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pembelian_detail_id_seq OWNER TO ericanthony;

--
-- Name: pembelian_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.pembelian_detail_id_seq OWNED BY public.pembelian_detail.id;


--
-- Name: pembelian_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.pembelian_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pembelian_id_seq OWNER TO ericanthony;

--
-- Name: pembelian_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.pembelian_id_seq OWNED BY public.pembelian.id;


--
-- Name: pembelian_retur; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.pembelian_retur (
    id integer NOT NULL,
    kode_retur character varying(30) NOT NULL,
    pembelian_id integer NOT NULL,
    tanggal_retur date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total_retur bigint DEFAULT '0'::numeric NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.pembelian_retur OWNER TO ericanthony;

--
-- Name: pembelian_retur_detail; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.pembelian_retur_detail (
    id integer NOT NULL,
    pembelian_retur_id integer NOT NULL,
    barang_id integer,
    jumlah integer DEFAULT 1 NOT NULL,
    harga_beli bigint DEFAULT '0'::numeric NOT NULL
);


ALTER TABLE public.pembelian_retur_detail OWNER TO ericanthony;

--
-- Name: pembelian_retur_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.pembelian_retur_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pembelian_retur_detail_id_seq OWNER TO ericanthony;

--
-- Name: pembelian_retur_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.pembelian_retur_detail_id_seq OWNED BY public.pembelian_retur_detail.id;


--
-- Name: pembelian_retur_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.pembelian_retur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pembelian_retur_id_seq OWNER TO ericanthony;

--
-- Name: pembelian_retur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.pembelian_retur_id_seq OWNED BY public.pembelian_retur.id;


--
-- Name: pengguna; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.pengguna (
    id integer NOT NULL,
    nama character varying(200) NOT NULL,
    username character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    hak_akses character varying(50) DEFAULT 'kasir'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.pengguna OWNER TO ericanthony;

--
-- Name: pengguna_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.pengguna_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pengguna_id_seq OWNER TO ericanthony;

--
-- Name: pengguna_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.pengguna_id_seq OWNED BY public.pengguna.id;


--
-- Name: penjualan; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.penjualan (
    id integer NOT NULL,
    no_nota character varying(30) NOT NULL,
    pelanggan_id integer,
    sales_id integer,
    created_by integer,
    order_date date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    biaya bigint DEFAULT '0'::numeric NOT NULL,
    subtotal bigint DEFAULT '0'::numeric NOT NULL,
    bpjs bigint DEFAULT 0,
    total bigint DEFAULT '0'::numeric NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status_bayar character varying(20) DEFAULT 'lunas'::character varying NOT NULL,
    dp bigint DEFAULT '0'::numeric NOT NULL,
    tanggal_selesai date,
    sph_r character varying(20),
    sph_l character varying(20),
    cyl_r character varying(20),
    cyl_l character varying(20),
    axis_r character varying(20),
    axis_l character varying(20),
    add_r character varying(20),
    add_l character varying(20)
);


ALTER TABLE public.penjualan OWNER TO ericanthony;

--
-- Name: penjualan_detail; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.penjualan_detail (
    id integer NOT NULL,
    penjualan_id integer NOT NULL,
    tipe character varying(20) NOT NULL,
    barang_id integer,
    harga bigint DEFAULT '0'::numeric NOT NULL,
    diskon bigint DEFAULT '0'::numeric NOT NULL,
    jumlah integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.penjualan_detail OWNER TO ericanthony;

--
-- Name: penjualan_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.penjualan_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.penjualan_detail_id_seq OWNER TO ericanthony;

--
-- Name: penjualan_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.penjualan_detail_id_seq OWNED BY public.penjualan_detail.id;


--
-- Name: penjualan_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.penjualan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.penjualan_id_seq OWNER TO ericanthony;

--
-- Name: penjualan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.penjualan_id_seq OWNED BY public.penjualan.id;


--
-- Name: penjualan_retur; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.penjualan_retur (
    id integer NOT NULL,
    kode_retur character varying(30) NOT NULL,
    penjualan_id integer NOT NULL,
    tanggal_retur date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total_retur bigint DEFAULT '0'::numeric NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.penjualan_retur OWNER TO ericanthony;

--
-- Name: penjualan_retur_detail; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.penjualan_retur_detail (
    id integer NOT NULL,
    penjualan_retur_id integer NOT NULL,
    barang_id integer,
    tipe character varying(20) NOT NULL,
    jumlah integer DEFAULT 1 NOT NULL,
    harga bigint DEFAULT '0'::numeric NOT NULL
);


ALTER TABLE public.penjualan_retur_detail OWNER TO ericanthony;

--
-- Name: penjualan_retur_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.penjualan_retur_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.penjualan_retur_detail_id_seq OWNER TO ericanthony;

--
-- Name: penjualan_retur_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.penjualan_retur_detail_id_seq OWNED BY public.penjualan_retur_detail.id;


--
-- Name: penjualan_retur_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.penjualan_retur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.penjualan_retur_id_seq OWNER TO ericanthony;

--
-- Name: penjualan_retur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.penjualan_retur_id_seq OWNED BY public.penjualan_retur.id;


--
-- Name: sales; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.sales (
    id integer NOT NULL,
    nama character varying(200) NOT NULL,
    tanggal_kerja date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status character varying(20) DEFAULT 'aktif'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    komisi_frame numeric(5,2) DEFAULT '0'::numeric NOT NULL,
    komisi_lensa numeric(5,2) DEFAULT '0'::numeric
);


ALTER TABLE public.sales OWNER TO ericanthony;

--
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_id_seq OWNER TO ericanthony;

--
-- Name: sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;


--
-- Name: supplier; Type: TABLE; Schema: public; Owner: ericanthony
--

CREATE TABLE public.supplier (
    id integer NOT NULL,
    nama character varying(200) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.supplier OWNER TO ericanthony;

--
-- Name: supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: ericanthony
--

CREATE SEQUENCE public.supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supplier_id_seq OWNER TO ericanthony;

--
-- Name: supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ericanthony
--

ALTER SEQUENCE public.supplier_id_seq OWNED BY public.supplier.id;


--
-- Name: barang id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.barang ALTER COLUMN id SET DEFAULT nextval('public.barang_id_seq'::regclass);


--
-- Name: kategori id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.kategori ALTER COLUMN id SET DEFAULT nextval('public.kategori_id_seq'::regclass);


--
-- Name: knex_migrations id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.knex_migrations ALTER COLUMN id SET DEFAULT nextval('public.knex_migrations_id_seq'::regclass);


--
-- Name: knex_migrations_lock index; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.knex_migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.knex_migrations_lock_index_seq'::regclass);


--
-- Name: komisi_sales id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.komisi_sales ALTER COLUMN id SET DEFAULT nextval('public.komisi_sales_id_seq'::regclass);


--
-- Name: pelanggan id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pelanggan ALTER COLUMN id SET DEFAULT nextval('public.pelanggan_id_seq'::regclass);


--
-- Name: pembayaran_pembelian id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembayaran_pembelian ALTER COLUMN id SET DEFAULT nextval('public.pembayaran_pembelian_id_seq'::regclass);


--
-- Name: pembayaran_penjualan id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembayaran_penjualan ALTER COLUMN id SET DEFAULT nextval('public.pembayaran_penjualan_id_seq'::regclass);


--
-- Name: pembelian id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian ALTER COLUMN id SET DEFAULT nextval('public.pembelian_id_seq'::regclass);


--
-- Name: pembelian_detail id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian_detail ALTER COLUMN id SET DEFAULT nextval('public.pembelian_detail_id_seq'::regclass);


--
-- Name: pembelian_retur id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian_retur ALTER COLUMN id SET DEFAULT nextval('public.pembelian_retur_id_seq'::regclass);


--
-- Name: pembelian_retur_detail id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian_retur_detail ALTER COLUMN id SET DEFAULT nextval('public.pembelian_retur_detail_id_seq'::regclass);


--
-- Name: pengguna id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pengguna ALTER COLUMN id SET DEFAULT nextval('public.pengguna_id_seq'::regclass);


--
-- Name: penjualan id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan ALTER COLUMN id SET DEFAULT nextval('public.penjualan_id_seq'::regclass);


--
-- Name: penjualan_detail id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan_detail ALTER COLUMN id SET DEFAULT nextval('public.penjualan_detail_id_seq'::regclass);


--
-- Name: penjualan_retur id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan_retur ALTER COLUMN id SET DEFAULT nextval('public.penjualan_retur_id_seq'::regclass);


--
-- Name: penjualan_retur_detail id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan_retur_detail ALTER COLUMN id SET DEFAULT nextval('public.penjualan_retur_detail_id_seq'::regclass);


--
-- Name: sales id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);


--
-- Name: supplier id; Type: DEFAULT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.supplier ALTER COLUMN id SET DEFAULT nextval('public.supplier_id_seq'::regclass);


--
-- Data for Name: barang; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (66, 'HELLEN KELLER', 1, 1, 1435000, 'B00217', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (67, 'LEINZ BS', 1, 1, 1575000, 'B00218', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (68, 'LONG JEANS', 1, 7, 450000, 'B00219', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3175, 'PACIFIC PV1164', 1, 1, 570000, 'B00004', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3176, 'PAUL FRANK TR', 1, 2, 350000, 'B00003', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3177, 'I GALLERY', 1, 1, 420000, 'B00005', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (84, 'CANOBI', 1, 1, 1100000, 'B00235', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3178, 'TOM TERRY T3614', 1, 1, 490000, 'B00012', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3179, 'TOO INCH T2 2115', 1, 1, 600000, 'B00013', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3180, 'CARO CR2890', 1, 1, 375000, 'B00016', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3181, 'MONALISA MT183', 1, 1, 1200000, 'B00024', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3182, 'TED LAPIDUS TL900', 1, 1, 1950000, 'B00025', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3183, 'REGENCY 929', 1, 1, 2200000, 'B00026', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3184, 'LE TANNUER LE771', 1, 1, 2250000, 'B00028', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3185, 'CHARMANT CH104222', 1, 1, 2175000, 'B00029', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3186, 'RODENSTOCK D135', 1, 1, 2640000, 'B00030', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3187, 'TJAPAN TJ 152', 1, 1, 1000000, 'B00031', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3188, 'DARIO MARTINI DM 128', 1, 1, 1950000, 'B00034', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3189, 'EVISU EVH 8051', 1, 1, 1135000, 'B00036', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (6, 'BLUECROMIC', 2, 4, 550000, 'B00124', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '150', '150', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (7, 'BLUECROMIC', 2, 5, 550000, 'B00125', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-150', '-150', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (8, 'BLUECROMIC', 2, 4, 550000, 'B00126', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-150', '-150', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (9, 'BLUECROMIC', 2, 6, 550000, 'B00157', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-250', '-250', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (10, 'BLUECROMIC', 2, 5, 550000, 'B00158', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-250', '-250', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (11, 'BLUECROMIC', 2, 6, 550000, 'B00159', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-275', '-275', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (12, 'BLUECROMIC', 2, 6, 550000, 'B00160', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-275', '-275', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (13, 'BLUECROMIC', 2, 8, 550000, 'B00161', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-275', '-275', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (14, 'BLUECROMIC', 2, 7, 550000, 'B00162', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-275', '-275', '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (15, 'BLUECROMIC', 2, 8, 550000, 'B00128', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-175', '-175', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (17, 'BLUECROMIC', 2, 7, 550000, 'B00132', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-175', '-175', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (61, 'CR KRYTOP PUTIH MC', 2, 8, 125000, 'B00212', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+150', '+150', '0', '0', '+200', '+200');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (62, 'CR KRYTOP PUTIH MC', 2, 5, 125000, 'B00213', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+150', '+150', '0', '0', '+225', '+225');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (63, 'CR KRYTOP PUTIH MC', 2, 3, 125000, 'B00214', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+150', '+150', '0', '0', '+275', '+275');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (64, 'CR KRYTOP PUTIH MC', 2, 6, 125000, 'B00215', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+150', '+150', '0', '0', '+300', '+300');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (65, 'CR KRYTOP PUTIH MC', 2, 7, 125000, 'B00216', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+175', '+175', '0', '0', '+225', '+225');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (69, 'CR KRYTOP PUTIH MC', 2, -1, 125000, 'B00220', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+200', '+200', '0', '0', '+250', '+250');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (70, 'CR KRYTOP PUTIH MC', 2, 5, 125000, 'B00221', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+200', '+200', '0', '0', '+275', '+275');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (71, 'CR KRYTOP PUTIH MC', 2, 3, 125000, 'B00222', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+200', '+200', '0', '0', '+300', '+300');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (72, 'CR KRYTOP PUTIH MC', 2, 13, 125000, 'B00223', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '0', '0', '0', '0', '+150', '+150');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (80, 'CR PUTIH MC', 2, 6, 125000, 'B00231', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-1.75', '-1.75', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (81, 'CR PUTIH MC', 2, 4, 125000, 'B00232', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-2', '-2', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (82, 'CR PUTIH MC', 2, 6, 125000, 'B00233', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-2.25', '-2.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (83, 'CR PUTIH MC', 2, 4, 125000, 'B00234', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-2.5', '-2.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (85, 'CR PUTIH MC', 2, 5, 125000, 'B00236', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-3', '-3', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (86, 'CR PUTIH MC', 2, 6, 125000, 'B00237', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-3.25', '-3.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (87, 'CR PUTIH MC', 2, 6, 125000, 'B00238', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-3.5', '-3.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (88, 'CR PUTIH MC', 2, 13, 125000, 'B00239', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-3.75', '-3.75', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (89, 'CR PUTIH MC', 2, 6, 125000, 'B00240', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-4', '-4', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (90, 'CR PUTIH MC', 2, 6, 125000, 'B00241', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-4.25', '-4.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (91, 'CR PUTIH MC', 2, 6, 125000, 'B00242', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-4.5', '-4.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (92, 'CR PUTIH MC', 2, 6, 125000, 'B00243', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-4.75', '-4.75', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (96, 'CR PUTIH MC', 2, 5, 125000, 'B00247', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-5.75', '-5.75', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (97, 'CR PUTIH MC', 2, 1, 125000, 'B00248', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-6', '-6', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3190, 'SHISEIDO SH 2049', 1, 1, 1775000, 'B00038', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (658, 'POLICE V8570J', 1, 1, 2090000, 'B00052', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (659, 'ALAIN DELON M307760', 1, 1, 675000, 'B00053', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (665, 'NIKON NK7001', 1, 1, 1750000, 'B00060', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (669, 'RODENSTOCK R2128', 1, 1, 2400000, 'B00064', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (682, 'PORCHE DESIGN P8115', 1, 1, 3400000, 'B00077', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (686, 'AXARA AX1003', 1, 1, 430000, 'B00081', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (689, 'BEARBRICK BBX7601', 1, 1, 825000, 'B00084', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (690, 'HEROIC HR 6181', 1, 1, 825000, 'B00085', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (691, 'LOLLIPOP LP005', 1, 2, 550000, 'B00086', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (692, 'HEROIC HR 6117', 1, 1, 825000, 'B00087', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (693, 'LOLLIPOP LP006', 1, 1, 550000, 'B00088', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (695, 'BLACK GALLERY  BG 5027', 1, 1, 2600000, 'B00090', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (698, 'DAVIDOFF 95605', 1, 1, 2800000, 'B00093', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (699, 'REGENCY 838', 1, 1, 2200000, 'B00094', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3213, 'PLAYYBOY SHIELD,GEOMETRIC,CHIP', 1, 1, 2660000, 'B00560', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3214, 'NIKE 7046,3822,3507', 1, 1, 470000, 'B00758', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3215, 'HMC MA', 1, 1, 700000, 'B00776', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3217, 'CAZAL', 1, 1, 915000, 'B00902', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3218, 'NB 9385', 1, 1, 2620000, 'B00954', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3219, 'TR 90 9004', 1, 1, 470000, 'B01049', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3220, 'MONALISA MT 179', 1, 1, 1680000, 'B01032', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3221, 'IDECO 1055', 1, 1, 1290000, 'B01112', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3222, 'ALAIN DELON 8902', 1, 1, 675000, 'B00006', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3223, 'CHANNEL 53.15', 1, 1, 335000, 'B00850', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3224, 'SPY TRAVIS', 1, 1, 2650000, 'B01180', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3225, 'RAYBAN 5228F', 1, 1, 2380000, 'B01244', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3226, 'CALVIN K', 1, 3, 165000, 'B01261', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (73, 'CR PUTIH MC', 2, 5, 125000, 'B00224', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '0', '0', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (98, 'CR PUTIH MC', 2, 7, 175000, 'B00249', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-6.25', '-6.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (99, 'CR PUTIH MC', 2, 5, 175000, 'B00250', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-6.5', '-6.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (100, 'CR PUTIH MC', 2, 5, 175000, 'B00251', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-6.75', '-6.75', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (101, 'CR PUTIH MC', 2, 5, 175000, 'B00252', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-7', '-7', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (103, 'CR PUTIH MC', 2, 4, 175000, 'B00254', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-7.5', '-7.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (104, 'CR PUTIH MC', 2, 2, 175000, 'B00255', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-7.75', '-7.75', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (106, 'CR PUTIH MC', 2, 2, 175000, 'B00257', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-8.25', '-8.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (107, 'CR PUTIH MC', 2, 3, 175000, 'B00258', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-8.5', '-8.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (108, 'CR PUTIH MC', 2, 2, 175000, 'B00259', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-8.75', '-8.75', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (109, 'CR PUTIH MC', 2, 2, 175000, 'B00260', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-9', '-9', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (110, 'CR PUTIH MC', 2, 5, 125000, 'B00261', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '0', '0', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (111, 'CR PUTIH MC', 2, 4, 125000, 'B00262', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '0', '0', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (112, 'CR PUTIH MC', 2, 4, 125000, 'B00263', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '0', '0', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (113, 'CR PUTIH MC', 2, 3, 125000, 'B00264', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '0', '0', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (114, 'CR PUTIH MC', 2, 6, 125000, 'B00265', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '0', '0', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (115, 'CR PUTIH MC', 2, 7, 125000, 'B00266', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '0', '0', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (116, 'CR PHOTOGREY MC', 2, 6, 225000, 'B00267', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.25', '-0.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (117, 'CR PHOTOGREY MC', 2, 6, 225000, 'B00268', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.50', '-0.50', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (118, 'CR PHOTOGREY MC', 2, 6, 225000, 'B00269', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.75', '-0.75', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (119, 'CR PHOTOGREY MC', 2, 7, 225000, 'B00270', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.00', '-1.00', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (120, 'CR PHOTOGREY MC', 2, 5, 225000, 'B00271', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.25', '-1.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (121, 'CR PHOTOGREY MC', 2, 4, 225000, 'B00272', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.50', '-1.50', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (122, 'CR PHOTOGREY MC', 2, 6, 225000, 'B00273', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.75', '-1.75', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (123, 'CR PHOTOGREY MC', 2, 6, 225000, 'B00274', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.00', '-2.00', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (124, 'CR PUTIH MC', 2, 4, 125000, 'B00275', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.25', '-0.25', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (143, 'CR PUTIH MC', 2, 5, 125000, 'B00295', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.75', '-0.75', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (144, 'CR PUTIH MC', 2, 6, 125000, 'B00296', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.75', '-0.75', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (145, 'CR PUTIH MC', 2, 5, 125000, 'B00297', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.75', '-0.75', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (147, 'CR PUTIH MC', 2, 6, 125000, 'B00299', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1', '-1', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (148, 'CR PUTIH MC', 2, 3, 125000, 'B00300', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1', '-1', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (149, 'CR PUTIH MC', 2, 5, 125000, 'B00301', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1', '-1', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (150, 'CR PUTIH MC', 2, 5, 125000, 'B00303', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1', '-1', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3227, 'DEEL PRAT', 1, 2, 440000, 'B00723', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (151, 'CR PUTIH MC', 2, 4, 125000, 'B00304', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1', '-1', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (152, 'CR PUTIH MC', 2, 5, 125000, 'B00305', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1', '-1', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (153, 'CR PUTIH MC', 2, 5, 125000, 'B00306', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1', '-1', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (154, 'CR PUTIH MC', 2, 2, 125000, 'B00307', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.25', '-1.25', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (155, 'CR PUTIH MC', 2, 5, 125000, 'B00308', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.25', '-1.25', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (156, 'CR PUTIH MC', 2, 4, 125000, 'B00309', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.25', '-1.25', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (157, 'CR PUTIH MC', 2, 5, 125000, 'B00310', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.25', '-1.25', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (158, 'CR PUTIH MC', 2, 4, 125000, 'B00311', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.25', '-1.25', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (159, 'CR PUTIH MC', 2, 5, 125000, 'B00312', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.25', '-1.25', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (160, 'CR PUTIH MC', 2, 5, 125500, 'B00313', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.25', '-1.25', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (161, 'CR PUTIH MC', 2, 3, 125000, 'B00314', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.25', '-1.25', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (162, 'CR PUTIH MC', 2, 5, 125000, 'B00315', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.5', '-1.5', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (164, 'CR PUTIH MC', 2, 5, 125000, 'B00317', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.5', '-1.5', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (167, 'CR PUTIH MC', 2, 5, 125000, 'B00320', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.5', '-1.5', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (168, 'CR PUTIH MC', 2, 4, 125000, 'B00321', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.5', '-1.5', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (169, 'CR PUTIH MC', 2, 5, 125000, 'B00323', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.5', '-1.5', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (170, 'CR PUTIH MC', 2, 5, 125000, 'B00324', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2', '-2', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (171, 'CR PUTIH MC', 2, 5, 125000, 'B00325', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2', '-2', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (172, 'CR PUTIH MC', 2, 6, 125000, 'B00326', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2', '-2', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (173, 'CR PUTIH MC', 2, 4, 125000, 'B00327', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2', '-2', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (174, 'CR PUTIH MC', 2, 5, 125000, 'B00328', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2', '-2', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (175, 'CR PUTIH MC', 2, 5, 125000, 'B00329', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2', '-2', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (176, 'CR PUTIH MC', 2, 5, 125000, 'B00330', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2', '-2', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (177, 'CR PUTIH MC', 2, 4, 125000, 'B00331', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2', '-2', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (178, 'CR PUTIH MC', 2, 5, 125000, 'B00332', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.25', '-2.25', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (179, 'CR PUTIH MC', 2, 7, 125000, 'B00333', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.25', '-2.25', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (180, 'CR PUTIH MC', 2, 7, 125000, 'B00334', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.25', '-2.25', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (181, 'CR PUTIH MC', 2, 6, 125000, 'B00335', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.25', '-2.25', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (182, 'CR PUTIH MC', 2, 5, 125000, 'B00336', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.25', '-2.25', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (183, 'CR PUTIH MC', 2, 7, 125000, 'B00337', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.25', '-2.25', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (184, 'CR PUTIH MC', 2, 7, 125000, 'B00338', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.25', '-2.25', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (185, 'CR PUTIH MC', 2, 5, 125000, 'B00339', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.25', '-2.25', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (186, 'CR PUTIH MC', 2, 5, 125000, 'B00340', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.5', '-2.5', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (187, 'CR PUTIH MC', 2, 6, 125000, 'B00341', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.5', '-2.5', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (188, 'CR PUTIH MC', 2, 4, 125000, 'B00343', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.5', '-2.5', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (189, 'CR PUTIH MC', 2, 7, 125000, 'B00344', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.5', '-2.5', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (190, 'CR PUTIH MC', 2, 4, 125000, 'B00345', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.5', '-2.5', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (191, 'CR PUTIH MC', 2, 5, 125000, 'B00347', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.5', '-2.5', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (192, 'CR PUTIH MC', 2, 2, 125000, 'B00348', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.5', '-2.5', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (193, 'CR PUTIH MC', 2, 5, 125000, 'B00349', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.5', '-2.5', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (194, 'CR PUTIH MC', 2, 5, 125000, 'B00350', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.75', '-2.75', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (195, 'CR PUTIH MC', 2, 4, 125000, 'B00351', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.75', '-2.75', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (198, 'CR PUTIH MC', 2, 6, 125000, 'B00354', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.75', '-2.75', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (199, 'CR PUTIH MC', 2, 5, 125000, 'B00355', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.75', '-2.75', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (200, 'CR PUTIH MC', 2, 4, 125000, 'B00356', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.75', '-2.75', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (201, 'CR PUTIH MC', 2, 4, 125000, 'B00357', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.75', '-2.75', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3228, 'SEMBONIA', 1, 3, 2160000, 'B00757', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3229, 'KUTOO TI', 1, 3, 2380000, 'B00681', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3230, 'SAINT LUX', 1, 13, 480000, 'B00552', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3231, 'REAL MADRID DHC', 1, 3, 1485000, 'B00900', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3232, 'BELLA R GO', 1, 11, 700000, 'B00908', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3233, 'ASHLAN KAR', 1, 2, 490000, 'B00738', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3234, 'PKT BPJS 3', 1, 58, 165000, 'B00769', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3235, 'TUMI 013', 1, 1, 2575000, 'B00816', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3236, 'F.ANAK M1112', 1, 1, 450000, 'B00871', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3237, 'PAUL FRANK', 1, 1, 1500000, 'B01165', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3238, 'NB NEW', 1, 1, 2360000, 'B00837', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3239, 'ESPRIT DPM', 1, 2, 1850000, 'B00854', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3240, 'CONVERSE', 1, 1, 1660000, 'B00563', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3241, 'GINO BS', 1, 7, 660000, 'B00760', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3242, 'POLICE 503', 1, 1, 2470000, 'B00773', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3244, 'STING', 1, 1, 1860000, 'B00770', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3245, 'GF FERRE', 1, 1, 1850000, 'B00785', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3246, 'VILLETE', 1, 1, 390000, 'B00928', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3247, 'CHARMANT 330', 1, 1, 3253500, 'B01153', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3248, 'PAOLO G', 1, 3, 1280000, 'B01162', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (202, 'CR PUTIH MC', 2, 6, 125000, 'B00358', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.75', '-1.75', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (203, 'CR PUTIH MC', 2, 7, 125000, 'B00359', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.75', '-1.75', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (204, 'CR PUTIH MC', 2, 7, 125000, 'B00360', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.75', '-1.75', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (205, 'CR PUTIH MC', 2, 5, 125000, 'B00361', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-1.75', '-1.75', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (206, 'CR PUTIH MC', 2, 6, 125000, 'B00363', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-1.75', '-1.75', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (207, 'CR PUTIH MC', 2, 5, 125000, 'B00364', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-1.75', '-1.75', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (208, 'CR PUTIH MC', 2, 5, 125000, 'B00365', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-1.75', '-1.75', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (209, 'CR PUTIH MC', 2, 4, 125000, 'B00366', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-1.75', '-1.75', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (210, 'CR PUTIH MC', 2, 5, 125000, 'B00367', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3', '-3', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (211, 'CR PUTIH MC', 2, 5, 125000, 'B00368', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3', '-3', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (213, 'CR PUTIH MC', 2, 5, 125000, 'B00370', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3', '-3', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (214, 'CR PUTIH MC', 2, 6, 125000, 'B00371', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3', '-3', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (215, 'CR PUTIH MC', 2, 1, 125000, 'B00372', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3', '-3', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (216, 'CR PUTIH MC', 2, 4, 125000, 'B00373', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3', '-3', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (217, 'CR PUTIH MC', 2, 4, 125000, 'B00374', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3', '-3', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (259, 'CR PUTIH MC', 2, 4, 125000, 'B00418', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.5', '-4.5', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (261, 'CR PUTIH MC', 2, 4, 125000, 'B00420', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.5', '-4.5', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (262, 'CR PUTIH MC', 2, 4, 125000, 'B00421', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.5', '-4.5', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (263, 'CR PUTIH MC', 2, 4, 125000, 'B00423', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.5', '-4.5', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (264, 'CR PUTIH MC', 2, 3, 125000, 'B00424', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.5', '-4.5', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (265, 'CR PUTIH MC', 2, 4, 125000, 'B00425', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.5', '-4.5', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (266, 'CR PUTIH MC', 2, 6, 125000, 'B00426', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.75', '-4.75', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (267, 'CR PUTIH MC', 2, 4, 125000, 'B00427', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.75', '-4.75', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (268, 'CR PUTIH MC', 2, 5, 125000, 'B00428', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.75', '-4.75', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (269, 'CR PUTIH MC', 2, 5, 125000, 'B00429', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.75', '-4.75', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (270, 'CR PUTIH MC', 2, 6, 125000, 'B00430', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.75', '-4.75', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (271, 'CR PUTIH MC', 2, 7, 125000, 'B00431', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.75', '-4.75', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (272, 'CR PUTIH MC', 2, 4, 125000, 'B00432', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.75', '-4.75', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (273, 'BLUE RAY', 2, 3, 150000, 'B00433', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '+075', '+075', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (274, 'CR PUTIH MC', 2, 6, 125000, 'B00434', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5', '-5', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (275, 'CR PUTIH MC', 2, 4, 125000, 'B00435', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5', '-5', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (276, 'PROG BLUECROMIC MC GOSOK', 2, -4, 1050000, 'B00436', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (277, 'PROG BLUERAY MC GOSOK', 2, -2, 750000, 'B00437', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (278, 'CR PUTIH MC', 2, 8, 125000, 'B00438', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5', '-5', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (279, 'CR PUTIH MC', 2, 2, 125000, 'B00439', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5', '-5', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (280, 'CR PUTIH MC', 2, 5, 125000, 'B00440', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5', '-5', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (281, 'CR PUTIH MC', 2, 4, 125000, 'B00441', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5', '-5', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3250, 'AGNES B 70116', 1, 1, 3590000, 'B00690', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3251, 'KUGY', 1, 1, 300000, 'B01305', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3252, 'MOE', 1, 5, 350000, 'B01308', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3253, 'ELLE 329', 1, 2, 1740000, 'B00789', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3254, 'CHARMANT NEW', 1, 1, 2570000, 'B00923', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3255, 'TJAPAN NEW', 1, 2, 2485000, 'B00282', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3256, 'ATTITUDE', 1, 1, 600000, 'B00569', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3257, 'CHOPARD', 1, 1, 825000, 'B00720', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3258, 'V.TECH', 1, 14, 800000, 'B00779', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3259, 'ARTISEE', 1, 1, 300000, 'B00788', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3261, 'H.M', 1, 4, 650000, 'B00808', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3262, 'LEVIS JS', 1, 1, 165000, 'B00946', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3263, 'GUCCI', 1, 1, 390000, 'B01144', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3264, 'TAGHEUER 3149', 1, 1, 350000, 'B00814', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3265, 'ELLE SUNGGLASS', 1, 1, 1280000, 'B00873', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3266, 'RAY BAN 8056 MAX10%', 1, 1, 3425000, 'B01169', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3267, 'MONALISA NEW', 1, 1, 1880000, 'B01200', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3268, 'FIVE STAR', 1, 2, 250000, 'B01196', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3269, 'SKY ARMANI', 1, 16, 600000, 'B01218', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3270, 'HAMMER', 1, 13, 580000, 'B01219', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3271, 'EXCELENT', 1, 3, 330000, 'B01222', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3272, 'DUVALI', 1, 11, 250000, 'B01232', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3273, 'MOVE DHC', 1, 2, 1130000, 'B00009', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3276, 'BELIEVE', 1, 5, 700000, 'B00550', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3277, 'LONGCHAMP', 1, 1, 2265000, 'B00565', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3278, 'FILANO NEW', 1, 3, 420000, 'B01229', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3279, 'EIGHTEEN', 1, 2, 490000, 'B01259', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3280, 'KALE', 1, 2, 315000, 'B01263', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (283, 'CR PUTIH MC', 2, 5, 125000, 'B00444', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.25', '-5.25', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (284, 'CR PUTIH MC', 2, 5, 125000, 'B00445', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.25', '-5.25', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (285, 'CR PUTIH MC', 2, 5, 125000, 'B00446', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.25', '-5.25', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (286, 'CR PUTIH MC', 2, 6, 125000, 'B00447', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.25', '-5.25', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (287, 'CR PUTIH MC', 2, 5, 125000, 'B00448', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.25', '-5.25', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (288, 'CR PUTIH MC', 2, 4, 125000, 'B00449', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.25', '-5.25', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (289, 'CR PUTIH MC', 2, 6, 125000, 'B00450', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.25', '-5.25', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (290, 'CR PUTIH MC', 2, 4, 125000, 'B00451', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.5', '-5.5', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (291, 'CR PUTIH MC', 2, 5, 125000, 'B00452', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.5', '-5.5', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (292, 'CR PUTIH MC', 2, 4, 125000, 'B00453', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.5', '-5.5', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (293, 'CR PUTIH MC', 2, 4, 125000, 'B00454', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.5', '-5.5', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (294, 'CR PUTIH MC', 2, 4, 125000, 'B00455', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.5', '-5.5', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (295, 'CR PUTIH MC', 2, 4, 125000, 'B00456', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.5', '-5.5', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (296, 'CR PUTIH MC', 2, 5, 125000, 'B00457', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.5', '-5.5', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (297, 'CR PUTIH MC', 2, 4, 125000, 'B00458', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.5', '-5.5', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (298, 'CR PUTIH MC', 2, 4, 125000, 'B00459', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.75', '-5.75', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (299, 'CR PUTIH MC', 2, 5, 125000, 'B00460', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.75', '-5.75', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (300, 'CR PUTIH MC', 2, 7, 125000, 'B00461', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.75', '-5.75', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (301, 'CR PUTIH MC', 2, 5, 125000, 'B00463', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.75', '-5.75', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (302, 'CR PUTIH MC', 2, 4, 125000, 'B00464', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.75', '-5.75', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (303, 'CR PUTIH MC', 2, 6, 125000, 'B00465', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.75', '-5.75', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (304, 'CR PUTIH MC', 2, 4, 125000, 'B00466', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.75', '-5.75', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (305, 'CR PUTIH MC', 2, 5, 125000, 'B00467', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-5.75', '-5.75', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (306, 'CR PUTIH MC', 2, 4, 125000, 'B00468', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '-6', '-6', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (307, 'CR PUTIH MC', 2, 5, 125000, 'B00469', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '-6', '-6', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (308, 'CR PUTIH MC', 2, 4, 125000, 'B00470', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '-6', '-6', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (309, 'CR PUTIH MC', 2, 5, 125000, 'B00471', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '-6', '-6', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (311, 'CR PUTIH MC', 2, 4, 125000, 'B00473', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '-6', '-6', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (312, 'CR PUTIH MC', 2, 4, 125000, 'B00474', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '-6', '-6', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (313, 'CR PUTIH MC', 2, 4, 125000, 'B00475', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '-6', '-6', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (314, 'CR PROG MC R', 2, 7, 240000, 'B00476', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+1.00', '+1.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (316, 'CR PROG MC R', 2, 9, 240000, 'B00478', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+1.25', '+1.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (317, 'CR PROG MC L', 2, 9, 240000, 'B00479', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+1.25', '+1.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (451, 'NEW BALANCE 5301', 1, 1, 2330000, 'B00761', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (456, 'KYOTO TI', 1, 9, 1260000, 'B00965', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (457, 'OAKLEY', 1, 1, 3675000, 'B00966', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (460, 'VIVIANNE', 1, 4, 1225000, 'B00978', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (464, 'TUSCANY', 1, 1, 525000, 'B00982', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (318, 'CR PROG MC R', 2, 6, 240000, 'B00480', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+1.50', '+1.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (319, 'CR PROG MC L', 2, 8, 240000, 'B00481', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+1.50', '+1.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (320, 'CR PROG MC R', 2, 11, 240000, 'B00483', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+1.75', '+1.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (321, 'CR PROG MC L', 2, 12, 240000, 'B00484', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+1.75', '+1.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (322, 'CR PROG MC R', 2, 9, 240000, 'B00485', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+2.00', '+2.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (323, 'CR PROG MC L', 2, 8, 240000, 'B00486', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+2.00', '+2.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (324, 'CR PROG MC R', 2, 9, 240000, 'B00487', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+2.25', '+2.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (325, 'CR PROG MC L', 2, 7, 240000, 'B00488', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+2.25', '+2.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (359, 'CR PROG MC R', 2, 2, 240000, 'B00602', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+050', '+050', '0', '0', '+1.25', '+1.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (360, 'CR PROG MC L', 2, 3, 240000, 'B00603', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+050', '+050', '0', '0', '+1.25', '+1.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (361, 'CR PROG MC R', 2, 1, 240000, 'B00604', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+050', '+050', '0', '0', '+1.50', '+1.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (362, 'CR PROG MC L', 2, 2, 240000, 'B00605', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+050', '+050', '0', '0', '+1.50', '+1.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (385, 'PROG BLUE RAY MC R', 2, 2, 400000, 'B00628', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+100', '+100');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (386, 'PROG BLUE RAY MC R', 2, 2, 400000, 'B00630', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+125', '+125');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (387, 'PROG BLUE RAY MC L', 2, 2, 400000, 'B00631', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+125', '+125');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (388, 'PROG BLUE RAY MC R', 2, 2, 400000, 'B00632', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+150', '+150');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (389, 'PROG BLUE RAY MC L', 2, 3, 400000, 'B00633', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+150', '+150');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (390, 'CR PROG MC L', 2, 1, 240000, 'B00634', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+100', '+100', '0', '0', '+2.00', '+2.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (391, 'PROG BLUE RAY MC R', 2, 3, 400000, 'B00635', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+175', '+175');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (392, 'PROG BLUE RAY MC L', 2, 3, 400000, 'B00636', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+175', '+175');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (393, 'PROG BLUE RAY MC R', 2, 2, 400000, 'B00637', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+200', '+200');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (394, 'PROG BLUE RAY MC L', 2, 2, 400000, 'B00638', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+200', '+200');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (395, 'PROG BLUE RAY MC R', 2, 3, 400000, 'B00639', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+225', '+225');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (396, 'PROG BLUE RAY MC L', 2, 3, 400000, 'B00640', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+225', '+225');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (397, 'PROG BLUE RAY MC R', 2, 2, 400000, 'B00641', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+250', '+250');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (398, 'PROG BLUE RAY MC L', 2, 2, 400000, 'B00642', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+250', '+250');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (399, 'PROG BLUE RAY MC L', 2, 2, 400000, 'B00644', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+275', '+275');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (400, 'PROG BLUE RAY MC R', 2, 1, 400000, 'B00645', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+300', '+300');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (401, 'PROG BLUE RAY MC L', 2, 1, 400000, 'B00646', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', NULL, NULL, '+300', '+300');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (402, 'CR PROG MC R', 2, 2, 240000, 'B00647', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+125', '+125', '0', '0', '+2.50', '+2.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (403, 'CR PROG MC L', 2, 2, 240000, 'B00648', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+125', '+125', '0', '0', '+2.50', '+2.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (404, 'CR PROG MC R', 2, 2, 240000, 'B00650', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+150', '+150', '0', '0', '+1.75', '+1.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (405, 'CR PROG MC L', 2, 2, 240000, 'B00651', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+150', '+150', '0', '0', '+1.75', '+1.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (447, 'CR PROG MC L', 2, 2, 240000, 'B00799', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+050', '+050', NULL, NULL, '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (448, 'CR PROG MC L', 2, 2, 240000, 'B01225', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+175', '+175', '0', '0', '+2.50', '+2.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (449, 'CR PROG MC R', 2, 2, 240000, 'B01246', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+150', '+150', '0', '0', '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (450, 'CR PROG MC L', 2, 2, 240000, 'B01247', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+150', '+150', '0', '0', '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (452, 'CR PROG MC R', 2, 2, 240000, 'B00867', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+150', '+150', NULL, NULL, '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (453, 'BLUE RAY', 2, 6, 150000, 'B00962', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-025', '-025', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (454, 'BLUE RAY', 2, 3, 190000, 'B00963', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-050', '-050', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (455, 'BLUE RAY', 2, 6, 190000, 'B00964', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-075', '-075', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (458, 'BLUE RAY', 2, 7, 190000, 'B00967', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-150', '-150', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (459, 'BLUE RAY', 2, 5, 190000, 'B00977', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-175', '-175', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (461, 'BLUE RAY', 2, 4, 190000, 'B00979', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-225', '-225', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (462, 'BLUE RAY', 2, 5, 190000, 'B00980', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-250', '-250', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (465, 'BLUE RAY', 2, 7, 190000, 'B00983', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-325', '-325', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (472, 'BLUE RAY', 2, 7, 190000, 'B00990', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-500', '-500', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (484, 'BLUE RAY', 2, 3, 190000, 'B00930', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '-200', '-200', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3281, 'NIKE', 1, 1, 575000, 'B01264', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3282, 'TIMES NEW', 1, 3, 650000, 'B01278', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3283, 'URBAN HERO', 1, 5, 650000, 'B01284', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3284, 'DUGO KLIP', 1, 6, 950000, 'B01291', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3285, 'YOUNG FREE TITAN', 1, 1, 560000, 'B01298', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3286, 'AMAYA', 1, 2, 520000, 'B00056', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3288, 'TUSCANI', 1, 1, 350000, 'B01303', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3289, 'ELEMENT', 1, 12, 600000, 'B00008', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3290, 'SAPPORO', 1, 2, 250000, 'B00032', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3291, 'HORIEN', 1, 10, 785000, 'B00046', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (93, 'MARRAUDER KLIP', 1, 1, 960000, 'B00244', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (94, 'BPJS 2', 1, 63, 220000, 'B00245', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (475, 'SUNGLASS GNA', 1, 2, 885000, 'B00874', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (477, 'SMOOTH TI', 1, 3, 1575000, 'B00898', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (478, 'NEW BALANCE 53', 1, 1, 1605000, 'B00905', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (482, 'ICHIRO', 1, 1, 260000, 'B00909', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (480, 'LANCOME', 1, 6, 2025000, 'B00910', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (483, 'BCG', 1, 1, 350000, 'B00924', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (490, 'VINTAGE', 1, 2, 350000, 'B00941', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (491, 'AGNES B 4022', 1, 2, 3255000, 'B00949', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (492, 'NB 9386', 1, 1, 2620000, 'B00955', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (407, 'CR PROG MC L', 2, 2, 240000, 'B00653', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+150', '+150', '0', '0', '+2.00', '+2.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (468, 'BLUE RAY', 2, 8, 190000, 'B00986', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-400', '-400', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (471, 'BLUE RAY', 2, 7, 190000, 'B00989', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-475', '-475', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (473, 'BLUE RAY', 2, 8, 190000, 'B00821', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-550', '-550', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (474, 'CR PROG MC L', 2, 2, 220000, 'B00795', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+050', '+050', NULL, NULL, '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (476, 'CR PROG MC R', 2, 1, 240000, 'B00885', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+125', '+125', NULL, NULL, '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (409, 'CR PROG MC L', 2, 0, 240000, 'B00655', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+150', '+150', '0', '0', '+2.25', '+2.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (479, 'BLUE RAY', 2, 2, 190000, 'B00907', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '-075', '-075', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (481, 'BLUE RAY', 2, 8, 190000, 'B00915', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '-125', '-125', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (485, 'BLUE RAY', 2, 4, 150000, 'B00931', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-025', '-025', '-025', '-025', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (486, 'BLUE RAY', 2, 6, 150000, 'B00932', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-025', '-025', '-050', '-050', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (487, 'BLUE RAY', 2, 5, 150000, 'B00933', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-025', '-025', '-075', '-075', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (488, 'BLUE RAY', 2, 4, 150000, 'B00939', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-025', '-025', '-100', '-100', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (489, 'BLUE RAY', 2, 6, 150000, 'B00940', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-025', '-025', '-125', '-125', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (493, 'BLUE RAY', 2, 4, 150000, 'B00968', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-050', '-050', '-025', '-025', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (494, 'BLUE RAY', 2, 6, 150000, 'B00970', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-050', '-050', '-050', '-050', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (495, 'BLUE RAY', 2, 4, 150000, 'B00971', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-050', '-050', '-075', '-075', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (497, 'BLUE RAY', 2, 6, 190000, 'B00973', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-050', '-050', '-125', '-125', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (500, 'BLUE RAY', 2, 3, 190000, 'B00976', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-050', '-050', '-200', '-200', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (95, 'BPJS 1', 1, 56, 330000, 'B00246', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (102, 'FRAME PAKET', 1, 9, 180000, 'B00253', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (105, 'GRASS', 1, 2, 250000, 'B00256', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (146, 'OX 3184 TR', 1, 1, 3575000, 'B00298', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (163, 'ELITE NEW', 1, 1, 500000, 'B00316', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (165, 'TOUCH', 1, 1, 885000, 'B00318', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (166, 'AMAZING', 1, 1, 450000, 'B00319', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3306, 'SD EYE 2', 1, 5, 220000, 'B00342', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (196, 'I.SAW', 1, 1, 350000, 'B00352', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (197, 'TR ANAK.N', 1, 4, 300000, 'B00353', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3309, 'RB 3293 OR', 1, 1, 2695000, 'B00362', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (212, 'LEE COOL', 1, 7, 585000, 'B00369', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (218, 'DOLPIN ANAK', 1, 1, 470000, 'B00375', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (260, 'ELEGANT', 1, 9, 300000, 'B00419', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (282, 'BONIA 30025', 1, 3, 2040000, 'B00443', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (506, 'BLUE RAY', 2, 5, 190000, 'B00998', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-075', '-075', '-150', '-150', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (507, 'BLUE RAY', 2, 7, 190000, 'B00999', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-075', '-075', '-175', '-175', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (509, 'BLUE RAY', 2, 4, 190000, 'B01001', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-100', '-100', '-025', '-025', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (511, 'BLUE RAY', 2, 7, 190000, 'B01003', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-100', '-100', '-075', '-075', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (514, 'BLUE RAY', 2, 6, 190000, 'B01006', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-100', '-100', '-150', '-150', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (524, 'BLUE RAY', 2, 5, 190000, 'B01017', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-125', '-125', '-200', '-200', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (526, 'BLUE RAY', 2, 5, 190000, 'B01019', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-150', '-150', '-050', '-050', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (527, 'BLUE RAY', 2, 5, 190000, 'B01021', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-150', '-150', '-075', '-075', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (528, 'BLUE RAY', 2, 2, 190000, 'B01022', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-150', '-150', '-100', '-100', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (530, 'BLUE RAY', 2, 6, 190000, 'B01024', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-150', '-150', '-150', '-150', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (531, 'BLUE RAY', 2, 5, 190000, 'B01025', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-150', '-150', '-175', '-175', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (533, 'BLUE RAY', 2, 3, 190000, 'B01027', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-175', '-175', '-025', '-025', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (535, 'BLUE RAY', 2, 5, 190000, 'B01029', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-175', '-175', '-075', '-075', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (537, 'BLUE RAY', 2, 6, 190000, 'B01031', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-175', '-175', '-125', '-125', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (538, 'BLUE RAY', 2, 5, 190000, 'B01033', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-175', '-175', '-150', '-150', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (543, 'BLUE RAY', 2, 1, 190000, 'B01038', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-200', '-200', '-075', '-075', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (545, 'BLUE RAY', 2, 5, 190000, 'B01040', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-200', '-200', '-125', '-125', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (550, 'BLUE RAY', 2, 5, 190000, 'B01045', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-225', '-225', '-050', '-050', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (553, 'BLUE RAY', 2, 5, 190000, 'B01048', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-225', '-225', '-125', '-125', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (554, 'BLUE RAY', 2, 4, 190000, 'B01050', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-225', '-225', '-150', '-150', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (555, 'BLUE RAY', 2, 3, 190000, 'B01051', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-225', '-225', '-175', '-175', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (556, 'BLUE RAY', 2, 7, 190000, 'B01052', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-225', '-225', '-200', '-200', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (561, 'BLUE RAY', 2, 5, 190000, 'B01057', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-250', '-250', '-125', '-125', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (564, 'YOUTH TREND', 1, 9, 250000, 'B01061', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (565, 'BONIA 40473', 1, 1, 2685000, 'B01062', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (566, 'BONIA 30064', 1, 1, 2490000, 'B01063', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (567, 'BONIA 20395', 1, 2, 2690000, 'B01064', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (569, 'BONIA 30057', 1, 2, 2490000, 'B01066', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (570, 'BONIA 30053', 1, 2, 2850000, 'B01067', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (571, 'BONIA 40474', 1, 1, 2690000, 'B01068', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (575, 'OPT', 1, 1, 525000, 'B01072', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (563, 'BLUE RAY', 2, 4, 190000, 'B01059', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-250', '-250', '-175', '-175', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (568, 'BLUE RAY', 2, 4, 190000, 'B01065', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-275', '-275', '-100', '-100', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (572, 'BLUE RAY', 2, 5, 190000, 'B01069', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-275', '-275', '-200', '-200', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (579, 'BLUE RAY', 2, 6, 190000, 'B01076', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-300', '-300', '-175', '-175', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (580, 'BLUE RAY', 2, 3, 190000, 'B01077', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-300', '-300', '-200', '-200', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (588, 'BLUE RAY', 2, 5, 190000, 'B01089', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-325', '-325', '-200', '-200', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (591, 'BLUE RAY', 2, 3, 190000, 'B01092', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-350', '-350', '-075', '-075', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (595, 'BLUE RAY', 2, 2, 190000, 'B01096', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-350', '-350', '-175', '-175', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (598, 'BLUE RAY', 2, 6, 190000, 'B01099', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-375', '-375', '-050', '-050', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (631, 'BLUE RAY', 2, 6, 190000, 'B00820', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-475', '-475', '-100', '-100', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (633, 'BLUE RAY', 2, 6, 190000, 'B00825', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-475', '-475', '-150', '-150', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (634, 'BLUE RAY', 2, 5, 190000, 'B00826', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-475', '-475', '-175', '-175', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (637, 'BLUE RAY', 2, 4, 190000, 'B00836', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-500', '-500', '-050', '-050', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (638, 'BLUE RAY', 2, 7, 150000, 'B00839', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '+050', '+050', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (640, 'CR KRYTOP PHOTOCROMIC', 2, 5, 275000, 'B00845', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '0.00', '0.00', NULL, NULL, '+200', '+200');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (641, 'CR KRYTOP PHOTOCROMIC', 2, 6, 275000, 'B00846', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '0.00', '0.00', NULL, NULL, '+225', '+225');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (656, 'LE TANNUER LE 11', 1, 1, 2580000, 'B00050', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (680, 'TR ANAK', 1, 7, 280000, 'B00075', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (310, 'BRAUN BF NEW', 1, 4, 1695000, 'B00472', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (315, 'SCARLETT', 1, 1, 350000, 'B00477', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (326, 'RB 3362', 1, 1, 3490000, 'B00489', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3321, 'ST BAKER PLS', 1, 9, 1100000, 'B00497', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3322, 'FERRARO', 1, 8, 800000, 'B00500', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3323, 'JOANNA', 1, 7, 650000, 'B00507', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3324, 'TRY ME', 1, 1, 350000, 'B00508', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3325, 'COOL', 1, 3, 350000, 'B00513', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3326, 'LUNA', 1, 9, 560000, 'B00514', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3327, 'BLACK SPADE KLIP', 1, 3, 885000, 'B00519', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3328, 'BLACK SPADE', 1, 1, 570000, 'B00520', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3329, 'PLAYMAKER', 1, 2, 475000, 'B00522', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3330, 'BONIA 30017', 1, 1, 2215000, 'B00525', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3332, 'ACK BPJS 1', 1, 1, 330000, 'B00559', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3333, 'CALVIN KLIEN NEW', 1, 1, 2070000, 'B00566', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3336, 'KATE SPADE NEW', 1, 1, 650000, 'B00577', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3340, 'MONCADA', 1, 4, 670000, 'B00590', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3341, 'LACOSTE SPORT', 1, 3, 620000, 'B00592', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3342, 'KIYOWO', 1, 1, 300000, 'B00594', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3343, 'ARCHER', 1, 1, 300000, 'B00598', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (357, 'BONIA 30051', 1, 2, 2555000, 'B00600', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (358, 'BONIA 5022', 1, 1, 2555000, 'B00601', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (648, 'PROJECT V', 1, 6, 1190000, 'B00858', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (642, 'BLUE RAY', 2, 3, 190000, 'B00851', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-500', '-500', '-175', '-175', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (643, 'BLUE RAY', 2, 4, 190000, 'B00853', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-500', '-500', '-200', '-200', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (644, 'BLUE RAY GOSOK', 2, -3, 310000, 'B00901', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (645, 'BLUE RAY', 2, 6, 190000, 'B01134', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-375', '-375', '-075', '-075', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (646, 'BLUE RAY', 2, 5, 190000, 'B01142', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-425', '-425', '-150', '-150', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (647, 'BLUE RAY', 2, 8, 150000, 'B00855', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '+125', '+125', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (649, 'CR PROG MC R', 2, 3, 240000, 'B00869', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '+175', '+175', NULL, NULL, '+2.25', '+2.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (650, 'CR PROG MC L', 2, 2, 240000, 'B00894', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '+200', '+200', NULL, NULL, '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (651, 'BLUE RAY', 2, 8, 150000, 'B00912', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '+225', '+225', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (652, 'BLUE RAY', 2, 12, 150000, 'B00942', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '+275', '+275', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (653, 'BLUE RAY', 2, 4, 150000, 'B00956', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '+100', '+100', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (654, 'BLUE RAY', 2, 6, 150000, 'B01262', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '+300', '+300', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (655, 'BLUECROMIC', 2, 8, 550000, 'B00049', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '0.00', '0.00', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (657, 'BLUECROMIC', 2, 9, 550000, 'B00051', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-050', '-050', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (660, 'BLUECROMIC', 2, 3, 550000, 'B00054', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-125', '-125', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (661, 'BLUECROMIC', 2, 2, 550000, 'B00055', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-150', '-150', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (662, 'BLUECROMIC', 2, 2, 550000, 'B00057', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-175', '-175', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (663, 'BLUECROMIC', 2, 1, 550000, 'B00058', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-200', '-200', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (664, 'BLUECROMIC', 2, 7, 550000, 'B00059', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-225', '-225', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (666, 'BLUECROMIC', 2, 7, 550000, 'B00061', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-275', '-275', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (667, 'BLUECROMIC', 2, 4, 550000, 'B00062', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-300', '-300', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (668, 'BLUECROMIC', 2, 6, 550000, 'B00063', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-325', '-325', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (670, 'BLUECROMIC', 2, 4, 550000, 'B00065', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-375', '-375', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (671, 'BLUECROMIC', 2, 7, 550000, 'B00066', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-400', '-400', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (672, 'BLUECROMIC', 2, 6, 550000, 'B00067', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-425', '-425', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (673, 'BLUECROMIC', 2, 6, 550000, 'B00068', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-450', '-450', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (674, 'BLUECROMIC', 2, 5, 550000, 'B00069', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-475', '-475', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (675, 'BLUECROMIC', 2, 5, 550000, 'B00070', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-500', '-500', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (676, 'BLUECROMIC', 2, 6, 550000, 'B00071', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (677, 'BLUECROMIC', 2, 2, 550000, 'B00072', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (678, 'BLUECROMIC', 2, 4, 550000, 'B00073', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (679, 'BLUECROMIC', 2, 2, 550000, 'B00074', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (681, 'BLUECROMIC', 2, 5, 550000, 'B00076', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (683, 'BLUECROMIC', 2, 5, 550000, 'B00078', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (684, 'BLUECROMIC', 2, 6, 550000, 'B00079', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-025', '-025', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (685, 'BLUECROMIC', 2, 5, 550000, 'B00080', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-025', '-025', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (687, 'BLUECROMIC', 2, 4, 550000, 'B00082', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-025', '-025', '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (688, 'BLUECROMIC', 2, 3, 550000, 'B00083', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-025', '-025', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (694, 'BLUECROMIC', 2, 7, 550000, 'B00089', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-050', '-050', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (696, 'BLUECROMIC', 2, 4, 550000, 'B00091', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-050', '-050', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (697, 'BLUECROMIC', 2, 5, 550000, 'B00092', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-050', '-050', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (700, 'MONALISA MH1003', 1, 1, 1870000, 'B00095', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (703, 'FERRARI FR2002', 1, 1, 340000, 'B00098', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (704, 'IDECO', 1, 1, 610000, 'B00099', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (705, 'ESPRIT ET14137', 1, 1, 1860000, 'B00100', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (406, 'T.MATSUDA 6004', 1, 1, 1990000, 'B00652', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (410, 'TULIP', 1, 1, 350000, 'B00656', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (411, 'MANHATTAN', 1, 1, 315000, 'B00657', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (412, 'FIRST SENSE', 1, 1, 615000, 'B00658', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (413, 'NEW FACE', 1, 18, 350000, 'B00659', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3355, 'KENZIE LENS', 1, 3, 470000, 'B00670', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3356, 'F.PROMO', 1, 2, 0, 'B00671', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3357, 'HORIEN TI', 1, 2, 1135000, 'B00676', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3358, 'MODO 4094', 1, 1, 3320000, 'B00679', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3359, 'KUTOO', 1, 6, 850000, 'B00680', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3360, 'PASPORT NEW', 1, 1, 620000, 'B00684', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3361, 'COPS', 1, 4, 1180000, 'B00686', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3362, 'IN', 1, 1, 890000, 'B00688', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3363, 'NEW BALANCE 05281', 1, 1, 1900000, 'B00691', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3368, 'LEIX1713', 1, 1, 2100000, 'B00716', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3369, 'KEN Z', 1, 2, 650000, 'B00725', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3370, 'OAKLEY SATIN SMOKE', 1, 1, 3050000, 'B00731', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3373, 'NBA', 1, 1, 820000, 'B00740', '2026-06-07 22:10:28.553472+07', '2026-06-07 22:10:28.553472+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3374, 'NB 5299', 1, 1, 2230000, 'B00743', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3375, 'NB 7042', 1, 2, 2400000, 'B00746', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3376, 'MANAKO', 1, 2, 680000, 'B00754', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (16, 'BLUECROMIC', 2, 6, 550000, 'B00129', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-175', '-175', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (18, 'BLUECROMIC', 2, 4, 550000, 'B00133', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-175', '-175', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (19, 'BLUECROMIC', 2, 4, 550000, 'B00137', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-200', '-200', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (20, 'BLUECROMIC', 2, 4, 550000, 'B00138', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-200', '-200', '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (21, 'BLUECROMIC', 2, 6, 550000, 'B00168', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-300', '-300', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (22, 'BLUECROMIC', 2, 5, 550000, 'B00172', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-300', '-300', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (23, 'BLUECROMIC', 2, 6, 550000, 'B00173', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-300', '-300', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (24, 'BLUECROMIC', 2, 3, 550000, 'B00174', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-300', '-300', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (25, 'BLUECROMIC', 2, 6, 550000, 'B00176', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-325', '-325', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (26, 'BLUECROMIC', 2, 6, 550000, 'B00177', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-325', '-325', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (27, 'BLUECROMIC', 2, 5, 550000, 'B00178', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-325', '-325', '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (28, 'BLUECROMIC', 2, 4, 550000, 'B00175', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-325', '-325', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (29, 'BLUECROMIC', 2, 4, 550000, 'B00179', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-325', '-325', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (30, 'BLUECROMIC', 2, 6, 550000, 'B00180', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-325', '-325', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (31, 'BLUECROMIC', 2, 4, 550000, 'B00181', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-325', '-325', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (32, 'BLUECROMIC', 2, 4, 550000, 'B00182', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-325', '-325', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (33, 'BLUECROMIC', 2, 5, 550000, 'B00183', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-350', '-350', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (701, 'BLUECROMIC', 2, 5, 550000, 'B00096', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-075', '-075', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (702, 'BLUECROMIC', 2, 1, 550000, 'B00097', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-075', '-075', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2308, 'PROG BLUECROMIC MC L', 2, 4, 675000, 'B00382', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '00', '00', NULL, NULL, '+100', '+100');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2309, 'PROG PHOTOGRAY MC R', 2, 3, 450000, 'B00528', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+100', '+100');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2310, 'PROG PHOTOGRAY MC L', 2, 3, 450000, 'B00529', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+100', '+100');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2311, 'PROG PHOTOGRAY MC R', 2, 3, 450000, 'B00530', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+125', '+125');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2312, 'PROG PHOTOGGRAY MC L', 2, 3, 450000, 'B00531', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+125', '+125');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2313, 'PROG PHOTOGRAY MC R', 2, 5, 450000, 'B00532', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+150', '+150');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2314, 'PROG PHOTOGRAY MC L', 2, 5, 450000, 'B00533', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+150', '+150');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2315, 'PROG PHOTOGRAY MC L', 2, 4, 450000, 'B00537', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+200', '+200');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2316, 'PROG PHOTOGRAY MC R', 2, 2, 450000, 'B00538', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+225', '+225');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2317, 'PROG PHOTOGRAY MC L', 2, 3, 450000, 'B00539', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+225', '+225');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2318, 'PROG PHOTOGRAY MC R', 2, 4, 450000, 'B00540', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+250', '+250');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2319, 'PROG PHOTOGRAY MC L', 2, 4, 450000, 'B00541', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+250', '+250');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2320, 'PROG PHOTOGRAY MC R', 2, 3, 450000, 'B00542', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+275', '+275');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2321, 'PROG PHOTOGRAY MC L', 2, 3, 450000, 'B00543', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+275', '+275');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2322, 'PROG PHOTOGRAY MC R', 2, 2, 450000, 'B00544', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', '0', '0', '+300', '+300');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2323, 'CR PHOTOGRAY MC', 2, 6, 225000, 'B00546', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '-425', '-425', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2336, 'AC', 1, 1, 1250000, 'B00807', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2330, 'APD', 1, 2, 35000, 'B00796', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3378, 'SUNGLASS FASHION', 1, 3, 200000, 'B00765', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3379, 'BONIA', 1, 13, 2555000, 'B00766', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3380, 'RAYBAN 7186', 1, 1, 3240000, 'B00768', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3383, 'NEW BALANCE 9340', 1, 1, 2980000, 'B00787', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3384, 'JAGUAR 33122', 1, 1, 4850000, 'B00793', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3385, 'AMAZING NEW', 1, 4, 550000, 'B00811', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3387, 'TUMI 018', 1, 1, 2450000, 'B00817', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3388, 'TMATSUDA 6019', 1, 1, 2120000, 'B00822', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (632, 'HILX', 1, 3, 1970000, 'B00823', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3390, 'ULCOOL', 1, 9, 330000, 'B00828', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3391, 'AGNES B 60', 1, 1, 3315000, 'B00829', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (635, 'DICKIES', 1, 2, 1195000, 'B00832', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3393, 'MINSEO', 1, 2, 450000, 'B00833', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (636, 'BASIC', 1, 6, 150000, 'B00834', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (639, 'RB 5154', 1, 1, 2700000, 'B00840', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3397, 'IZZUE', 1, 1, 1530000, 'B00860', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3398, 'SUNGLASS', 1, 4, 180000, 'B00866', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3399, 'F.ANAK 80', 1, 7, 320000, 'B00872', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3401, 'V.RUDY 23603', 1, 3, 1585000, 'B00875', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3402, 'V.RUDY 238', 1, 4, 3040000, 'B00876', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3403, 'JIROO BS', 1, 1, 400000, 'B00878', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (50, 'BLUECROMIC', 2, 6, 550000, 'B00201', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-400', '-400', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (51, 'BLUECROMIC', 2, 7, 550000, 'B00202', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-400', '-400', '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (52, 'BLUECROMIC', 2, 4, 550000, 'B00203', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-400', '-400', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (53, 'BLUECROMIC', 2, 5, 550000, 'B00204', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-400', '-400', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (54, 'BLUECROMIC', 2, 2, 550000, 'B00205', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-400', '-400', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (55, 'BLUECROMIC', 2, 4, 550000, 'B00206', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-400', '-400', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (56, 'CR KRYTOP PUTIH MC', 2, 7, 125000, 'B00207', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+125', '+125', '0', '0', '+200', '+200');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (57, 'CR KRYTOP PUTIH MC', 2, 5, 125000, 'B00208', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+125', '+125', '0', '0', '+225', '+225');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (58, 'CR KRYTOP PUTIH MC', 2, 2, 125000, 'B00209', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+125', '+125', '0', '0', '+250', '+250');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (59, 'CR KRYTOP PUTIH MC', 2, 4, 125000, 'B00210', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+125', '+125', '0', '0', '+275', '+275');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (74, 'CR PUTIH MC', 2, 5, 125000, 'B00225', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-0.25', '-0.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (75, 'CR PUTIH MC', 2, 4, 125000, 'B00226', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-0.5', '-0.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (76, 'CR PUTIH MC', 2, 5, 125000, 'B00227', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-0.75', '-0.75', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (77, 'CR PUTIH MC', 2, 6, 125000, 'B00228', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-1', '-1', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (78, 'CR PUTIH MC', 2, 4, 125000, 'B00229', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-1.25', '-1.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (79, 'CR PUTIH MC', 2, 4, 125000, 'B00230', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-1.5', '-1.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2324, 'CR PHOTOGRAY MC', 2, 6, 225000, 'B00547', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '-450', '-450', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2325, 'CR PHOTOGRAY MC', 2, 6, 225000, 'B00548', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '-475', '-475', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2326, 'CR PHOTOGRAY MC', 2, 5, 225000, 'B00549', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '-500', '-500', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2327, 'PROG BLUE RAY MC L', 2, 2, 400000, 'B00629', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', NULL, NULL, '+100', '+100');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2328, 'PROG BLUE RAY MC R', 2, 2, 400000, 'B00643', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0', '0', NULL, NULL, '+275', '+275');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2329, 'CR PROG MC R', 2, 2, 220000, 'B00794', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+050', '+050', NULL, NULL, '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2331, 'CR PROG MC L', 2, 2, 220000, 'B00797', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+075', '+075', NULL, NULL, '+1.00', '+1.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2332, 'CR PROG MC R', 2, 2, 240000, 'B00798', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+050', '+050', NULL, NULL, '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2333, 'CR PROG MC R', 2, 2, 240000, 'B00804', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+075', '+075', NULL, NULL, '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2334, 'CR PROG MC L', 2, 2, 240000, 'B00805', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+075', '+075', NULL, NULL, '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2335, 'CR PROG MC R', 2, 2, 240000, 'B00806', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+075', '+075', NULL, NULL, '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2337, 'CR KRYTOP PHOTOCROMIC', 2, 2, 275000, 'B00841', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0.00', '0.00', NULL, NULL, '+100', '+100');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2338, 'CR KRYTOP PHOTOCROMIC', 2, 2, 275000, 'B00842', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0.00', '0.00', NULL, NULL, '+125', '+125');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2339, 'CR KRYTOP PHOTOCROMIC', 2, 2, 275000, 'B00843', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0.00', '0.00', NULL, NULL, '+150', '+150');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2340, 'CR KRYTOP PHOTOCROMIC', 2, 4, 275000, 'B00844', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0.00', '0.00', NULL, NULL, '+175', '+175');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2341, 'CR KRYTOP PHOTOCROMIC', 2, 4, 275000, 'B00847', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0.00', '0.00', NULL, NULL, '+250', '+250');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2342, 'CR KRYTOP PHOTOCROMIC', 2, 2, 275000, 'B00848', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0.00', '0.00', NULL, NULL, '+275', '+275');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2343, 'CR KRYTOP PHOTOCROMIC', 2, 4, 275000, 'B00849', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '0.00', '0.00', NULL, NULL, '+300', '+300');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2344, 'CR PROG MC L', 2, 2, 240000, 'B00868', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+150', '+150', NULL, NULL, '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2345, 'CR PROG MC L', 2, 2, 240000, 'B00870', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+175', '+175', NULL, NULL, '+2.25', '+2.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2346, 'CR PROG MC R', 2, 2, 240000, 'B00879', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+175', '+175', NULL, NULL, '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2347, 'CR PROG MC L', 2, 3, 240000, 'B00880', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+175', '+175', NULL, NULL, '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (541, 'AGNES B 6094', 1, 0, 3385000, 'B01036', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3404, 'HALIWSA', 1, 12, 400000, 'B00897', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3406, 'FILA', 1, 1, 1700000, 'B00899', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3407, 'NEW BALANCE 70', 1, 2, 2685000, 'B00904', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3411, 'POLICE', 1, 1, 2485000, 'B00922', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3413, 'BCW', 1, 4, 350000, 'B00925', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3414, 'EQUITON', 1, 1, 350000, 'B00926', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3415, 'STYL RODNEY', 1, 1, 390000, 'B00927', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3416, 'PANDORA', 1, 1, 350000, 'B00934', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3417, 'SOUL', 1, 3, 650000, 'B00935', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3419, 'BURBERRY', 1, 1, 5058900, 'B00945', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3420, 'AGNES HOM 65014', 1, 1, 4150000, 'B00947', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3424, 'NB 7059', 1, 1, 3055000, 'B00958', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3425, 'NB 7055', 1, 2, 3055000, 'B00959', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (496, 'LONGCHAMP 2707', 1, 2, 2070000, 'B00972', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (498, 'CALVIN KLEIN 22645', 1, 1, 2000000, 'B00974', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (499, 'CALVIN KLEIN 20102', 1, 1, 2000000, 'B00975', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (467, 'URBAN SUNGLASS', 1, 1, 1155000, 'B00985', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (469, 'LUMOUS KLIP', 1, 4, 805000, 'B00987', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (470, 'LEVIS 7149', 1, 1, 2670000, 'B00988', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (501, 'JEEP', 1, 2, 2900000, 'B00992', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (502, 'VALENTINO R', 1, 1, 2900000, 'B00993', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (503, 'LEIX 1729', 1, 1, 1985000, 'B00994', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (504, 'FRANSMULLER TI', 1, 4, 1995000, 'B00995', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (505, 'NIGATA TI', 1, 8, 1260000, 'B00996', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3441, 'NIGATA', 1, 2, 1155000, 'B00997', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (508, 'KITOYA TI', 1, 8, 2940000, 'B01000', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (510, 'NEW HORIZON', 1, 4, 350000, 'B01002', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (512, 'TRINITY', 1, 12, 580000, 'B01004', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (513, 'SHAVATO', 1, 20, 770000, 'B01005', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3446, 'BONIA 30061', 1, 1, 2300000, 'B01007', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (525, 'YONG SOO', 1, 1, 410000, 'B01018', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (529, 'LIFE LOVE', 1, 1, 350000, 'B01023', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (532, 'GOOD STUFF', 1, 1, 350000, 'B01026', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (534, 'FRAME 58007', 1, 1, 300000, 'B01028', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (539, 'PAUL HUEMAN', 1, 5, 2265000, 'B01034', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (540, 'LANCEL', 1, 2, 4025000, 'B01035', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (542, 'AGNES B 7014', 1, 1, 3450000, 'B01037', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (544, 'TMATSUDA GINZA', 1, 1, 2425000, 'B01039', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (546, 'LILAC', 1, 8, 685000, 'B01041', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (547, 'SEIKO', 1, 2, 3220000, 'B01042', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (548, 'JAGUAR 32010', 1, 1, 5340000, 'B01043', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (549, 'JAGUAR 39602', 1, 1, 3170000, 'B01044', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (551, 'LEVIS 7222', 1, 1, 2945000, 'B01046', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (552, 'LEVIS 7245', 1, 2, 2945000, 'B01047', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (557, 'INK', 1, 9, 950000, 'B01053', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (558, 'KYOTO HB', 1, 5, 1120000, 'B01054', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (559, 'LEE COOL SPORT', 1, 2, 590000, 'B01055', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (560, 'CEIDION', 1, 15, 1050000, 'B01056', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (562, 'TMATSUDA SHINJUKU', 1, 1, 2350000, 'B01058', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3473, 'TMATSUDA KARAFURU', 1, 1, 2080000, 'B01060', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (573, 'BONIA 50054', 1, 1, 2690000, 'B01070', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (574, 'ATTITUDE KLIP', 1, 2, 1180000, 'B01071', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (576, 'UPGRADE', 1, 1, 525000, 'B01073', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (577, 'MAX SPORT', 1, 1, 790000, 'B01074', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (578, 'NB 9432', 1, 1, 2950000, 'B01075', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (581, 'NB 7057', 1, 1, 3190000, 'B01078', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (582, 'NB 9401X', 1, 1, 2290000, 'B01079', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (583, 'NB 7047', 1, 1, 3195000, 'B01080', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (584, 'NB 7055', 1, 1, 3190000, 'B01081', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (585, 'MARRY QUEEN NEW', 1, 3, 525000, 'B01082', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (586, 'TOM FORD', 1, 1, 965000, 'B01083', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3493, 'COACH', 1, 1, 650000, 'B01084', '2026-06-07 22:10:28.567135+07', '2026-06-07 22:10:28.567135+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3495, 'CRIVELLI', 1, 2, 650000, 'B01087', '2026-06-07 22:10:28.567135+07', '2026-06-07 22:10:28.567135+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (587, 'DIOOR', 1, 5, 650000, 'B01088', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (589, 'MARX STUDIO', 1, 5, 435000, 'B01090', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (590, 'TOP MODEL NEW', 1, 2, 630000, 'B01091', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (592, 'JAGUAR 31708', 1, 1, 4400000, 'B01093', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (593, 'CAPTURE', 1, 13, 580000, 'B01094', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (594, 'MAWELL', 1, 6, 790000, 'B01095', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (596, 'PROFESSE', 1, 6, 500000, 'B01097', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (597, 'DAVIDOF 5131', 1, 1, 2660000, 'B01098', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (599, 'HTK /HITAKI', 1, 2, 475000, 'B01100', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (600, 'NB 9304', 1, 1, 1915000, 'B01101', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3506, 'NB 9434', 1, 1, 2825000, 'B01103', '2026-06-07 22:10:28.567135+07', '2026-06-07 22:10:28.567135+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (601, 'NB 9425', 1, 1, 2825000, 'B01104', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (126, 'CR PHOTOGREY MC', 2, 7, 225000, 'B00277', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.50', '-2.50', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (127, 'CR PHOTOGREY MC', 2, 6, 225000, 'B00279', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-3.00', '-3.00', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2348, 'CR PROG MC R', 2, 2, 240000, 'B00881', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+175', '+175', NULL, NULL, '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2349, 'CR PROG MC L', 2, 3, 240000, 'B00882', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+175', '+175', NULL, NULL, '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2350, 'CR PROG MC R', 2, 2, 240000, 'B00883', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+100', '+100', NULL, NULL, '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2351, 'CR PROG MC L', 2, 2, 240000, 'B00884', '2026-06-07 21:23:09.395246+07', '2026-06-07 21:23:09.395246+07', '+100', '+100', NULL, NULL, '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (602, 'ZENETECHAND', 1, 4, 615000, 'B01105', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (603, 'ZOGAMI', 1, 3, 750000, 'B01106', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (604, 'MAX CLIP ON', 1, 3, 960000, 'B01107', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (605, 'MONALIZA', 1, 39, 230000, 'B01108', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (219, 'CR PUTIH MC', 2, 5, 125000, 'B00376', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3.25', '-3.25', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (220, 'CR PUTIH MC', 2, 6, 125000, 'B00377', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3.25', '-3.25', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (221, 'CR PUTIH MC', 2, 5, 125000, 'B00378', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3.25', '-3.25', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (222, 'CR PUTIH MC', 2, 6, 125000, 'B00379', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3.25', '-3.25', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (223, 'PROG BLUECROMIC MC R', 2, 3, 675000, 'B00380', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+150', '+150');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (224, 'PROG BLUECROMIC MC R', 2, 4, 675000, 'B00381', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+100', '+100');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (225, 'PROG BLUECROMIC MC L', 2, 2, 675000, 'B00383', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+150', '+150');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (226, 'PROG BLUECROMIC MC L', 2, 3, 675000, 'B00384', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+125', '+125');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (227, 'PROG BLUECROMIC MC R', 2, 3, 675000, 'B00385', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+125', '+125');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (228, 'CR PUTIH MC', 2, 5, 125000, 'B00386', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3.5', '-3.5', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (229, 'PROG BLUECROMIC MC R', 2, 1, 675000, 'B00387', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+175', '+175');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (230, 'PROG BLUECROMIC MC L', 2, 1, 675000, 'B00388', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+175', '+175');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (231, 'PROG BLUECRIMIC MC R', 2, 1, 675000, 'B00389', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+200', '+200');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (232, 'PROG BLUECROMIC MC L', 2, 1, 675000, 'B00390', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+200', '+200');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (233, 'PROG BLUECROMIC MC R', 2, 3, 675000, 'B00391', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+225', '+225');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (234, 'PROG BLUECROMIC MC L', 2, 3, 675000, 'B00392', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+225', '+225');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (330, 'ST BAKER NEW', 1, 3, 775000, 'B00493', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (338, 'ORIENTAL NEW', 1, 15, 525000, 'B00555', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (339, 'FILANO BS', 1, 6, 700000, 'B00568', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (342, 'ROCK DUCATI', 1, 5, 785000, 'B00572', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (347, 'GIARDANO ARMANI', 1, 1, 250000, 'B00579', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (349, 'RB 3604 CR', 1, 1, 4750000, 'B00581', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (350, 'RB 3267 OR', 1, 1, 2695000, 'B00583', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (125, 'CR PHOTOGREY MC', 2, 8, 225000, 'B00276', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.25', '-2.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (331, 'CR PROG MC L', 2, 6, 240000, 'B00494', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (332, 'PROG PHOTOGRAY MC L', 2, 3, 450000, 'B00535', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+175', '+175');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (333, 'PROG PHOTOGRAY MC R', 2, 3, 450000, 'B00536', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+200', '+200');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (334, 'PROG PHOTOGRAY MC R', 2, 3, 450000, 'B00534', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+175', '+175');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (335, 'CR KRYTOP PUTIH MC', 2, 8, 125000, 'B00346', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+100', '+100', '0', '0', '+125', '+125');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (336, 'PROG PHOTOGRAY MC L', 2, 2, 450000, 'B00545', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+300', '+300');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (337, 'CR KRYTOP PUTIH MC', 2, 6, 125000, 'B00553', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+175', '+175', '0', '0', '+200', '+200');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (340, 'CR PUTIH MC', 2, 5, 125000, 'B00570', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+1.25', '+1.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (341, 'CR PUTIH MC', 2, 4, 125000, 'B00571', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+1.5', '+1.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (343, 'CR PUTIH MC', 2, 5, 125000, 'B00573', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+2', '+2', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (344, 'CR PUTIH MC', 2, 4, 125000, 'B00574', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+2.25', '+2.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (345, 'CR PUTIH MC', 2, 10, 125000, 'B00575', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+2.5', '+2.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (346, 'CR PUTIH', 2, 3, 125000, 'B00578', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+1', '+1', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (348, 'CR PUTIH', 2, 10, 125000, 'B00580', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+1.5', '+1.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (351, 'CR PUTIH', 2, 13, 125000, 'B00584', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+2.25', '+2.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (352, 'BLUECROMIC', 2, 5, 275000, 'B00585', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '-525', '-525', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (353, 'BLUECROMIC', 2, 6, 275000, 'B00586', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '-550', '-550', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (354, 'BLUECROMIC', 2, 5, 275000, 'B00587', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '-575', '-575', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (355, 'CR PUTIH MC', 2, 4, 125000, 'B00582', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+0.5', '+0.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (356, 'BLUECROMIC', 2, 5, 275000, 'B00588', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '-600', '-600', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (422, 'BONIA 20261', 1, 1, 2210000, 'B00696', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (418, 'NIKE 8136', 1, 1, 2430000, 'B00699', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (426, 'TOUCH NEW', 1, 2, 785000, 'B00706', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (435, 'W.MORIS BLACK', 1, 1, 2850000, 'B00715', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (414, 'KACA RAYBAN HITAM', 2, 1, 90000, 'B00660', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (415, 'CR KRYTOP PUTIH MC', 2, 8, 90000, 'B00694', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+100', '+100', '0', '0', '+125', '+125');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (416, 'CR KRYTOP PUTIH', 2, 1, 90000, 'B00697', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+1.25', '+1.25', '0', '0', '+1.25', '+1.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (417, 'CR FLATTOP PUTIH R', 2, 7, 90000, 'B00698', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+1', '+1');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (419, 'CR FLATTOP PUTIH R', 2, 2, 90000, 'B00700', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+1.25', '+1.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (420, 'CR FLATTOP PUTIH L', 2, 2, 90000, 'B00701', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+1.25', '+1.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (421, 'CR FLATTOP PUTIH R', 2, 3, 90000, 'B00702', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+1.5', '+1.5');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (423, 'CR FLATTOP PUTIH R', 2, 3, 90000, 'B00703', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+1.75', '+1.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (424, 'CR FLATTOP PUTIH L', 2, 4, 90000, 'B00704', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+1.75', '+1.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (425, 'CR FLATTOP PUTIH R', 2, 6, 90000, 'B00705', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+2', '+2');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (427, 'CR FLATTOP PUTIH R', 2, 7, 90000, 'B00707', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+2.25', '+2.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (428, 'CR FLATTOP PUTIH L', 2, 7, 90000, 'B00708', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+2.25', '+2.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (429, 'CR FLATTOP PUTIH R', 2, 5, 90000, 'B00709', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (430, 'CR FLATTOP PUTIH L', 2, 4, 90000, 'B00710', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (431, 'CR FLATTOP PUTIH R', 2, 3, 90000, 'B00711', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+3', '+3');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (432, 'CR FLATTOP PUTIH L', 2, 2, 90000, 'B00712', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+3', '+3');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (433, 'CR FLATTOP MC R', 2, 1, 90000, 'B00713', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+1.5', '+1.5');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (434, 'CR FLATTOP MC  L', 2, 1, 90000, 'B00714', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+1.5', '+1.5');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (436, 'CR FLATTOP MC L', 2, 2, 90000, 'B00717', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+2', '+2');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (536, 'JEJU', 1, 1, 350000, 'B01030', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (606, 'ULYSSE', 1, 2, 1050000, 'B01109', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1433, '8998 1478', 1, 2, 650000, 'B00104', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1435, 'FACEON F 0336', 1, 1, 420000, 'B00106', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1436, 'I-THEORY IT7504', 1, 1, 700000, 'B00107', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1437, 'DUGO BS', 1, 2, 650000, 'B00108', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1443, 'SAMIER NEW', 1, 3, 380000, 'B00114', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1430, 'BLUECROMIC', 2, 7, 550000, 'B00101', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-075', '-075', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1431, 'BLUECROMIC', 2, 3, 550000, 'B00102', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-075', '-075', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1432, 'BLUECROMIC', 2, 3, 550000, 'B00103', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-100', '-100', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1434, 'BLUECROMIC', 2, 6, 550000, 'B00105', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-100', '-100', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1438, 'BLUECROMIC', 2, 4, 550000, 'B00109', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-100', '-100', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1439, 'BLUECROMIC', 2, 5, 550000, 'B00110', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-100', '-100', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1440, 'BLUECROMIC', 2, 4, 550000, 'B00111', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-125', '-125', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1441, 'BLUECROMIC', 2, 8, 550000, 'B00112', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-125', '-125', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1442, 'BLUECROMIC', 2, 7, 550000, 'B00113', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-125', '-125', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1444, 'BLUECROMIC', 2, 6, 550000, 'B00115', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-125', '-125', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1445, 'BLUECROMIC', 2, 3, 550000, 'B00116', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-125', '-125', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1446, 'BLUECROMIC', 2, 4, 550000, 'B00117', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-125', '-125', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1447, 'BLUECROMIC', 2, 5, 550000, 'B00118', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-125', '-125', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1448, 'BLUECROMIC', 2, 4, 550000, 'B00119', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-150', '-150', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1449, 'BLUECROMIC', 2, 8, 550000, 'B00120', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-150', '-150', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1450, 'BLUECROMIC', 2, 8, 550000, 'B00121', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-150', '-150', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1451, 'BLUECROMIC', 2, 7, 550000, 'B00122', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-150', '-150', '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1452, 'BLUECROMIC', 2, 7, 550000, 'B00123', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-150', '-150', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1456, 'BLUECROMIC', 2, 4, 550000, 'B00127', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-175', '-175', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1459, 'BLUECROMIC', 2, 6, 550000, 'B00130', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-175', '-175', '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1460, 'BLUECROMIC', 2, 4, 550000, 'B00131', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-175', '-175', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (34, 'BLUECROMIC', 2, 7, 550000, 'B00185', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-350', '-350', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (35, 'BLUECROMIC', 2, 7, 550000, 'B00186', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-350', '-350', '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (36, 'BLUECROMIC', 2, 5, 550000, 'B00187', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-350', '-350', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (37, 'BLUECROMIC', 2, 5, 550000, 'B00188', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-350', '-350', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (38, 'BLUECROMIC', 2, 6, 550000, 'B00189', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-350', '-350', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (39, 'BLUECROMIC', 2, 4, 550000, 'B00190', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-350', '-350', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (40, 'BLUECROMIC', 2, 6, 550000, 'B00191', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-375', '-375', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1482, 'BLUECROMIC', 2, 7, 550000, 'B00153', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-250', '-250', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1483, 'BLUECROMIC', 2, 5, 550000, 'B00154', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-250', '-250', '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1484, 'BLUECROMIC', 2, 5, 550000, 'B00155', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-250', '-250', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1485, 'BLUECROMIC', 2, 3, 550000, 'B00156', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-250', '-250', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1492, 'BLUECROMIC', 2, 6, 550000, 'B00163', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-275', '-275', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1493, 'BLUECROMIC', 2, 4, 550000, 'B00164', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-275', '-275', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1494, 'BLUECROMIC', 2, 6, 550000, 'B00165', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-275', '-275', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1495, 'BLUECROMIC', 2, 5, 550000, 'B00166', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-275', '-275', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1496, 'BLUECROMIC', 2, 5, 550000, 'B00167', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-300', '-300', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1498, 'BLUECROMIC', 2, 6, 550000, 'B00169', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-300', '-300', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1499, 'BLUECROMIC', 2, 7, 550000, 'B00170', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-300', '-300', '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1500, 'BLUECROMIC', 2, 7, 550000, 'B00171', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-300', '-300', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1513, 'BLUECROMIC', 2, 5, 550000, 'B00184', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-350', '-350', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (41, 'BLUECROMIC', 2, 6, 550000, 'B00192', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-375', '-375', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (42, 'BLUECROMIC', 2, 6, 550000, 'B00193', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-375', '-375', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (43, 'BLUECROMIC', 2, 5, 550000, 'B00194', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-375', '-375', '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (44, 'BLUECROMIC', 2, 5, 550000, 'B00195', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-375', '-375', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (45, 'BLUECROMIC', 2, 5, 550000, 'B00196', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-375', '-375', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (46, 'BLUECROMIC', 2, 6, 550000, 'B00197', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-375', '-375', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (47, 'BLUECROMIC', 2, 5, 550000, 'B00198', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-375', '-375', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (48, 'BLUECROMIC', 2, 5, 550000, 'B00199', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-400', '-400', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (49, 'BLUECROMIC', 2, 6, 550000, 'B00200', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '-400', '-400', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (60, 'CR KRYTOP PUTIH MC', 2, 5, 125000, 'B00211', '2026-06-07 21:22:32.137737+07', '2026-06-07 21:22:32.137737+07', '+125', '+125', '0', '0', '+300', '+300');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (134, 'FRAME PROMO', 1, 3, 0, 'B00287', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (128, 'CR PHOTOGREY MC', 2, 7, 225000, 'B00280', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-3.25', '-3.25', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (129, 'CR PHOTOGREY MC', 2, 6, 225000, 'B00281', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-3.50', '-3.50', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (130, 'CR PHOTOGREY MC', 2, 7, 225000, 'B00283', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-3.75', '-3.75', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (131, 'CR PHOTOGREY MC', 2, 5, 225000, 'B00284', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-4.00', '-4.00', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (132, 'CR PUTIH MC', 2, 2, 175000, 'B00285', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-10.00', '-10.00', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (133, 'CR PUTIH MC', 2, 5, 125000, 'B00286', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.5', '-0.5', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (135, 'CR PUTIH MC', 2, 5, 125000, 'B00288', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.5', '-0.5', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (136, 'CR PUTIH MC', 2, 4, 125000, 'B00289', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.5', '-0.5', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (137, 'CR PUTIH MC', 2, 4, 125000, 'B00290', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.5', '-0.5', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (138, 'CR PHOTOGREY MC', 2, 8, 225000, 'B00278', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-2.75', '-2.75', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (139, 'CR PUTIH MC', 2, 6, 125000, 'B00291', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.75', '-0.75', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (140, 'CR PUTIH MC', 2, 8, 125000, 'B00292', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.75', '-0.75', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (141, 'CR PUTIH MC', 2, 5, 125000, 'B00293', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.75', '-0.75', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (142, 'CR PUTIH MC', 2, 4, 125000, 'B00294', '2026-06-07 21:22:32.170864+07', '2026-06-07 21:22:32.170864+07', '-0.75', '-0.75', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (244, 'MAGIC', 1, 1, 480000, 'B00404', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (248, 'ROMANO', 1, 2, 650000, 'B00409', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (257, 'ANGELS', 1, 1, 400000, 'B00416', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (235, 'PROG BLUECROMIC MC R', 2, 3, 675000, 'B00393', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+250', '+250');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (236, 'PROG BLUECROMIC MC L', 2, 3, 675000, 'B00394', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+250', '+250');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (237, 'PROG BLUECROMIC MC R', 2, 3, 675000, 'B00395', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+275', '+275');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (238, 'PROG BLUECROMIC MC L', 2, 3, 675000, 'B00396', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+275', '+275');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (239, 'PROG BLUECROMIC MC R', 2, 2, 675000, 'B00397', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+300', '+300');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (240, 'CR PUTIH MC', 2, 4, 125000, 'B00399', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3.75', '-3.75', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (241, 'CR PUTIH MC', 2, 5, 125000, 'B00400', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-3.75', '-3.75', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (242, 'CR PUTIH MC', 2, 5, 125000, 'B00401', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4', '-4', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (243, 'CR PUTIH MC', 2, 6, 125000, 'B00403', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4', '-4', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (245, 'CR PUTIH MC', 2, 5, 125000, 'B00405', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4', '-4', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (246, 'CR PUTIH MC', 2, 5, 125000, 'B00406', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4', '-4', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (247, 'CR PUTIH MC', 2, 5, 125000, 'B00408', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4', '-4', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (249, 'CR PUTIH MC', 2, 4, 125000, 'B00410', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4', '-4', '-2', '-2', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (250, 'PROG BLUECROMIC MC L', 2, 2, 675000, 'B00398', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '00', '00', NULL, NULL, '+300', '+300');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (251, 'CR PUTIH MC', 2, 4, 125000, 'B00407', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.25', '-4.25', '-0.5', '-0.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (252, 'CR PUTIH MC', 2, 5, 125000, 'B00411', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.25', '-4.25', '-0.75', '-0.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (253, 'CR PUTIH MC', 2, 4, 125000, 'B00412', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.25', '-4.25', '-1', '-1', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (254, 'CR PUTIH MC', 2, 4, 125000, 'B00413', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.25', '-4.25', '-1.25', '-1.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (255, 'CR PUTIH MC', 2, 4, 125000, 'B00414', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.25', '-4.25', '-1.5', '-1.5', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (256, 'CR PUTIH MC', 2, 4, 125000, 'B00415', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.25', '-4.25', '-1.75', '-1.75', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (258, 'CR PUTIH MC', 2, 4, 125000, 'B00417', '2026-06-07 21:22:32.181185+07', '2026-06-07 21:22:32.181185+07', '-4.5', '-4.5', '-0.25', '-0.25', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (368, 'NEW BALANCE 7034', 1, 1, 2550000, 'B00611', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (370, 'LUMOUS', 1, 4, 680000, 'B00613', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (373, 'HIMAWACHI', 1, 3, 470000, 'B00616', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (383, 'FIT', 1, 2, 990000, 'B00626', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (327, 'CR PROG MC L', 2, 11, 240000, 'B00490', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+2.50', '+2.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (328, 'CR PROG MC R', 2, 6, 240000, 'B00491', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (329, 'CR PROG MC L', 2, 7, 240000, 'B00492', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '0', '0', '0', '0', '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (363, 'CR PROG MC R', 2, 3, 240000, 'B00606', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+050', '+050', '0', '0', '+1.75', '+1.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (364, 'CR PROG MC L', 2, 1, 240000, 'B00607', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+050', '+050', '0', '0', '+1.75', '+1.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (365, 'CR PROG MC R', 2, 1, 240000, 'B00608', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+050', '+050', '0', '0', '+2.00', '+2.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (366, 'CR PROG MC L', 2, 2, 240000, 'B00609', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+050', '+050', '0', '0', '+2.00', '+2.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (367, 'CR PROG MC R', 2, 2, 240000, 'B00610', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+050', '+050', '0', '0', '+2.25', '+2.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (369, 'CR PROG MC R', 2, 2, 240000, 'B00612', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+050', '+050', '0', '0', '+2.50', '+2.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (371, 'CR PROG MC R', 2, 3, 240000, 'B00614', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+075', '+075', '0', '0', '+1.25', '+1.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (372, 'CR PROG MC L', 2, 4, 240000, 'B00615', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+075', '+075', '0', '0', '+1.25', '+1.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (374, 'CR PROG MC L', 2, 2, 240000, 'B00617', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+075', '+075', '0', '0', '+1.50', '+1.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (375, 'CR PROG MC R', 2, 2, 240000, 'B00618', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+075', '+075', '0', '0', '+1.75', '+1.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (376, 'CR PROG MC L', 2, 2, 240000, 'B00619', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+075', '+075', '0', '0', '+1.75', '+1.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (377, 'CR PROG MC R', 2, 1, 240000, 'B00620', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+075', '+075', '0', '0', '+2.00', '+2.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (378, 'CR PROG MC L', 2, 1, 240000, 'B00621', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+075', '+075', '0', '0', '+2.00', '+2.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (379, 'CR PROG MC R', 2, 3, 240000, 'B00622', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+075', '+075', '0', '0', '+2.25', '+2.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (380, 'CR PROG MC L', 2, 5, 240000, 'B00623', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+075', '+075', '0', '0', '+2.25', '+2.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (381, 'CR PROG MC R', 2, 3, 240000, 'B00624', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+075', '+075', '0', '0', '+2.50', '+2.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (382, 'CR PROG MC L', 2, 3, 240000, 'B00625', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+075', '+075', '0', '0', '+2.50', '+2.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (384, 'CR PROG MC L', 2, 3, 240000, 'B00627', '2026-06-07 21:22:32.187935+07', '2026-06-07 21:22:32.187935+07', '+100', '+100', '0', '0', '+1.25', '+1.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (441, 'ATTITUDE NEW', 1, 11, 895000, 'B00735', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (444, 'SAFILO', 1, 3, 300000, 'B01086', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (437, 'CR FLATTOP MC R', 2, 2, 90000, 'B00718', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (438, 'CR FLATTOP MC L', 2, 1, 90000, 'B00719', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '0', '0', '0', '0', '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (439, 'CR KRYTOP MC GOSOK', 2, -4, 200000, 'B00722', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (440, 'CR KRYTOP PUTIH MC', 2, 6, 125000, 'B00734', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+150', '+150', '0', '0', '+175', '+175');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (442, 'CR FLATTOP GOSOK', 2, -2, 200000, 'B00035', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (443, 'KACA MC', 2, 4, 90000, 'B00042', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-2.5', '-2.5', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (445, 'CR PROG MC R', 2, 2, 240000, 'B01163', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+100', '+100', '0', '0', '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (446, 'CR PROG MC L', 2, 2, 240000, 'B01164', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+100', '+100', '0', '0', '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (516, 'BONIA 3052', 1, 1, 2450000, 'B01009', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (517, 'BONIA 3060', 1, 2, 2300000, 'B01010', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (519, 'BONIA 3056', 1, 1, 2300000, 'B01012', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (521, 'SALVIO', 1, 1, 600000, 'B01014', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (523, 'VIVO NEW', 1, 1, 890000, 'B01016', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (515, 'BLUE RAY', 2, 4, 190000, 'B01008', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-100', '-100', '-175', '-175', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (518, 'BLUE RAY', 2, 8, 190000, 'B01011', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-125', '-125', '-050', '-050', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (520, 'BLUE RAY', 2, 7, 190000, 'B01013', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-125', '-125', '-100', '-100', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (522, 'BLUE RAY', 2, 5, 190000, 'B01015', '2026-06-07 21:22:32.202246+07', '2026-06-07 21:22:32.202246+07', '-125', '-125', '-150', '-150', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (623, 'N.BALANCE 93', 1, 1, 2245000, 'B00732', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (627, 'NIKE 7404 IU', 1, 2, 2560000, 'B00781', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (628, 'NEW BALANCE 72', 1, 1, 2050000, 'B00786', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (630, 'TUMI 078', 1, 1, 3625000, 'B00815', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (607, 'OLIVER PEOPLE', 1, 1, 960000, 'B01110', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (608, 'ROTH CHILD', 1, 2, 1050000, 'B01111', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (609, 'BLUE RAY', 2, 6, 190000, 'B01113', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-400', '-400', '-150', '-150', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (610, 'BLUE RAY', 2, 5, 190000, 'B01114', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-400', '-400', '-175', '-175', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (611, 'BLUE RAY', 2, 6, 190000, 'B01115', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-400', '-400', '-200', '-200', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (612, 'BLUE RAY', 2, 9, 190000, 'B01116', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-425', '-425', '-025', '-025', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (613, 'BLUE RAY', 2, 6, 190000, 'B01117', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-425', '-425', '-050', '-050', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (614, 'BLUE RAY', 2, 6, 190000, 'B01118', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-425', '-425', '-075', '-075', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (615, 'BLUE RAY', 2, 6, 190000, 'B01119', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-425', '-425', '-100', '-100', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (616, 'BLUE RAY', 2, 4, 190000, 'B01120', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-425', '-425', '-125', '-125', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (617, 'BLUE RAY', 2, 4, 190000, 'B01121', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-425', '-425', '-150', '-150', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (618, 'BLUE RAY', 2, 7, 190000, 'B01122', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-425', '-425', '-175', '-175', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (619, 'BLUE RAY', 2, 4, 190000, 'B01123', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-425', '-425', '-200', '-200', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (620, 'BLUE RAY', 2, 5, 190000, 'B00554', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-450', '-450', '-025', '-025', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (621, 'BLUE RAY', 2, 6, 190000, 'B00677', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-450', '-450', '-050', '-050', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (622, 'BLUE RAY', 2, 6, 190000, 'B00678', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-450', '-450', '-075', '-075', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (624, 'BLUE RAY', 2, 2, 190000, 'B00736', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-450', '-450', '-125', '-125', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (625, 'BLUE RAY', 2, 3, 190000, 'B00742', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-450', '-450', '-150', '-150', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (626, 'BLUE RAY', 2, 4, 190000, 'B00778', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-450', '-450', '-175', '-175', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (629, 'BLUE RAY', 2, 5, 190000, 'B00802', '2026-06-07 21:22:32.207568+07', '2026-06-07 21:22:32.207568+07', '-475', '-475', '-050', '-050', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1463, 'BLUECROMIC', 2, 4, 550000, 'B00134', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-175', '-175', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1464, 'BLUECROMIC', 2, 5, 550000, 'B00135', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-200', '-200', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1465, 'BLUECROMIC', 2, 8, 550000, 'B00136', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-200', '-200', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1468, 'BLUECROMIC', 2, 6, 550000, 'B00139', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-200', '-200', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1469, 'BLUECROMIC', 2, 5, 550000, 'B00140', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-200', '-200', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1470, 'BLUECROMIC', 2, 5, 550000, 'B00141', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-200', '-200', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1471, 'BLUECROMIC', 2, 4, 550000, 'B00142', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-200', '-200', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1472, 'BLUECROMIC', 2, 4, 550000, 'B00143', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-225', '-225', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1473, 'BLUECROMIC', 2, 7, 550000, 'B00144', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-225', '-225', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1474, 'BLUECROMIC', 2, 8, 550000, 'B00145', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-225', '-225', '-075', '-075', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1475, 'BLUECROMIC', 2, 7, 550000, 'B00146', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-225', '-225', '-100', '-100', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2354, 'GUESS 2538', 1, 1, 2380000, 'B00888', '2026-06-07 21:23:09.402551+07', '2026-06-07 21:23:09.402551+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1476, 'BLUECROMIC', 2, 5, 550000, 'B00147', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-225', '-225', '-125', '-125', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1477, 'BLUECROMIC', 2, 8, 550000, 'B00148', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-225', '-225', '-150', '-150', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1478, 'BLUECROMIC', 2, 9, 550000, 'B00149', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-225', '-225', '-175', '-175', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1479, 'BLUECROMIC', 2, 9, 550000, 'B00150', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-225', '-225', '-200', '-200', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1480, 'BLUECROMIC', 2, 6, 550000, 'B00151', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-250', '-250', '-025', '-025', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (1481, 'BLUECROMIC', 2, 7, 550000, 'B00152', '2026-06-07 21:22:49.571808+07', '2026-06-07 21:22:49.571808+07', '-250', '-250', '-050', '-050', NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2352, 'CR PROG MC L', 2, 1, 240000, 'B00886', '2026-06-07 21:23:09.402551+07', '2026-06-07 21:23:09.402551+07', '+125', '+125', NULL, NULL, '+2.75', '+2.75');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2353, 'CR PROG MC R', 2, 2, 240000, 'B00887', '2026-06-07 21:23:09.402551+07', '2026-06-07 21:23:09.402551+07', '+125', '+125', NULL, NULL, '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2355, 'CR PROG MC R', 2, 2, 240000, 'B00889', '2026-06-07 21:23:09.402551+07', '2026-06-07 21:23:09.402551+07', '+200', '+200', NULL, NULL, '+2.25', '+2.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2356, 'CR PROG MC L', 2, 3, 240000, 'B00890', '2026-06-07 21:23:09.402551+07', '2026-06-07 21:23:09.402551+07', '+200', '+200', NULL, NULL, '+2.25', '+2.25');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2357, 'CR PROG MC R', 2, 2, 240000, 'B00891', '2026-06-07 21:23:09.402551+07', '2026-06-07 21:23:09.402551+07', '+200', '+200', NULL, NULL, '+2.50', '+2.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2358, 'CR PROG MC L', 2, 1, 240000, 'B00892', '2026-06-07 21:23:09.402551+07', '2026-06-07 21:23:09.402551+07', '+200', '+200', NULL, NULL, '+2.50', '+2.50');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2359, 'CR PROG MC R', 2, 2, 240000, 'B00895', '2026-06-07 21:23:09.402551+07', '2026-06-07 21:23:09.402551+07', '+200', '+200', NULL, NULL, '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2360, 'CR PROG MC L', 2, 1, 240000, 'B00896', '2026-06-07 21:23:09.402551+07', '2026-06-07 21:23:09.402551+07', '+200', '+200', NULL, NULL, '+3.00', '+3.00');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (2361, 'CR PUTIH MC', 2, 2, 110000, 'B01020', '2026-06-07 21:23:09.402551+07', '2026-06-07 21:23:09.402551+07', '-9.50', '-9.50', NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3174, '8998 PLASTIK', 1, 3, 1170000, 'B00001', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3422, 'AGNES HOM 65019', 1, 0, 4150000, 'B00950', '2026-06-07 22:10:28.559493+07', '2026-06-07 22:10:28.559493+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (466, 'BLUE RAY', 2, 4, 190000, 'B00984', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-350', '-350', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (463, 'BLUE RAY', 2, 5, 190000, 'B00981', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '-275', '-275', '0', '0', '0', '0');
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (3249, 'ELITE', 1, 62, 700000, 'B00687', '2026-06-07 22:10:28.537349+07', '2026-06-07 22:10:28.537349+07', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.barang (id, nama_barang, kategori_id, qty, harga_jual, barcode_id, created_at, updated_at, sph_r, sph_l, cyl_r, cyl_l, add_r, add_l) VALUES (408, 'CR PROG MC R', 2, 0, 240000, 'B00654', '2026-06-07 21:22:32.193393+07', '2026-06-07 21:22:32.193393+07', '+150', '+150', '0', '0', '+2.25', '+2.25');


--
-- Data for Name: kategori; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.kategori (id, nama, created_at) VALUES (1, 'Frame', '2026-06-04 23:38:20.210614+07');
INSERT INTO public.kategori (id, nama, created_at) VALUES (2, 'Lensa', '2026-06-04 23:38:20.210614+07');
INSERT INTO public.kategori (id, nama, created_at) VALUES (3, 'Aksesoris', '2026-06-04 23:38:20.210614+07');


--
-- Data for Name: knex_migrations; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.knex_migrations (id, name, batch, migration_time) VALUES (1, '20240101000000_initial.js', 1, '2026-06-04 23:37:37.347+07');
INSERT INTO public.knex_migrations (id, name, batch, migration_time) VALUES (2, '20240102000000_pembelian.js', 2, '2026-06-06 13:53:25.327+07');
INSERT INTO public.knex_migrations (id, name, batch, migration_time) VALUES (3, '20240103000000_retur_payments.js', 3, '2026-06-06 14:48:05.854+07');
INSERT INTO public.knex_migrations (id, name, batch, migration_time) VALUES (4, '20240104000000_sales_komisi.js', 4, '2026-06-07 13:22:24.684+07');
INSERT INTO public.knex_migrations (id, name, batch, migration_time) VALUES (5, '20260607082918_update_penjualan_bpjs_tanggal.js', 5, '2026-06-07 15:30:02.91+07');
INSERT INTO public.knex_migrations (id, name, batch, migration_time) VALUES (7, '20260607085000_komisi_sales_table.js', 6, '2026-06-07 15:53:51.299+07');
INSERT INTO public.knex_migrations (id, name, batch, migration_time) VALUES (8, '20260607180000_add_prescription_fields.js', 7, '2026-06-07 17:35:12.839+07');
INSERT INTO public.knex_migrations (id, name, batch, migration_time) VALUES (9, '20260607190000_split_sales_komisi.js', 8, '2026-06-07 17:42:17.76+07');
INSERT INTO public.knex_migrations (id, name, batch, migration_time) VALUES (11, '20260607145724_alter_barang_qty_nullable.js', 9, '2026-06-07 21:57:38.396+07');
INSERT INTO public.knex_migrations (id, name, batch, migration_time) VALUES (12, '20260607154022_remove_axis_from_barang.js', 10, '2026-06-07 22:40:46.861+07');
INSERT INTO public.knex_migrations (id, name, batch, migration_time) VALUES (13, '20260608025542_alter_price_columns_to_bigint.js', 11, '2026-06-08 09:56:04.584+07');


--
-- Data for Name: knex_migrations_lock; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.knex_migrations_lock (index, is_locked) VALUES (1, 0);


--
-- Data for Name: komisi_sales; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (1, 1, 1, 'frame', 0.80, 80.00, '2026-06-04 23:55:15.608+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (2, 1, 1, 'lensa', 0.80, 160.00, '2026-06-04 23:55:15.608+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (3, 2, 1, 'lensa', 0.80, 1744.00, '2026-06-05 18:49:05.793+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (4, 5, 1, 'frame', 0.80, 872.00, '2026-06-07 14:56:19.499+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (5, 5, 1, 'lensa', 0.80, 1744.00, '2026-06-07 14:56:19.499+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (6, 6, 2, 'frame', 1.00, 1000.00, '2026-06-07 15:04:21.084+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (7, 6, 2, 'lensa', 1.00, 1190.00, '2026-06-07 15:04:21.084+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (8, 7, 2, 'frame', 1.00, 1000.00, '2026-06-07 15:05:11.711+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (9, 7, 2, 'lensa', 1.00, 1190.00, '2026-06-07 15:05:11.711+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (10, 8, 1, 'frame', 0.80, 800.00, '2026-06-07 15:27:43.562+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (11, 8, 1, 'lensa', 0.80, 1600.00, '2026-06-07 15:27:43.562+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (12, 9, 1, 'frame', 0.80, 800.00, '2026-06-07 15:32:34.414+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (13, 9, 1, 'lensa', 0.80, 1600.00, '2026-06-07 15:32:34.414+07', '2026-06-07 15:53:51.249575+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (14, 11, 2, 'frame', 1.00, 1000.00, '2026-06-07 17:42:10.662323+07', '2026-06-07 17:42:10.662323+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (15, 11, 2, 'lensa', 1.00, 2000.00, '2026-06-07 17:42:10.662323+07', '2026-06-07 17:42:10.662323+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (16, 13, 2, 'frame', 1.00, 1000.00, '2026-06-07 17:49:37.066881+07', '2026-06-07 17:49:37.066881+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (17, 14, 1, 'frame', 0.80, 800.00, '2026-06-07 17:56:36.389169+07', '2026-06-07 17:56:36.389169+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (18, 15, 2, 'frame', 1.00, 1000.00, '2026-06-07 18:05:04.784719+07', '2026-06-07 18:05:04.784719+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (19, 15, 2, 'lensa', 0.20, 400.00, '2026-06-07 18:05:04.784719+07', '2026-06-07 18:05:04.784719+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (20, 16, 2, 'frame', 1.00, 1000.00, '2026-06-07 18:09:24.076017+07', '2026-06-07 18:09:24.076017+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (21, 16, 2, 'lensa', 0.20, 400.00, '2026-06-07 18:09:24.076017+07', '2026-06-07 18:09:24.076017+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (22, 17, 3, 'frame', 0.80, 800.00, '2026-06-07 18:09:55.064361+07', '2026-06-07 18:09:55.064361+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (23, 17, 3, 'lensa', 0.20, 418.00, '2026-06-07 18:09:55.064361+07', '2026-06-07 18:09:55.064361+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (24, 18, 2, 'frame', 1.00, 33850.00, '2026-06-08 09:49:11.308297+07', '2026-06-08 09:49:11.308297+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (25, 18, 2, 'lensa', 0.20, 760.00, '2026-06-08 09:49:11.308297+07', '2026-06-08 09:49:11.308297+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (26, 19, 6, 'frame', 1.00, 41500.00, '2026-06-08 11:25:27.161253+07', '2026-06-08 11:25:27.161253+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (27, 20, 5, 'frame', 1.00, 7000.00, '2026-06-08 11:27:37.784211+07', '2026-06-08 11:27:37.784211+07');
INSERT INTO public.komisi_sales (id, penjualan_id, sales_id, tipe, persentase, nominal_komisi, created_at, updated_at) VALUES (28, 21, 3, 'lensa', 0.20, 760.00, '2026-06-08 12:42:38.310346+07', '2026-06-08 12:42:38.310346+07');


--
-- Data for Name: pelanggan; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.pelanggan (id, nama, no_telp, created_at) VALUES (1, 'Vivian Halim', '62812345123', '2026-06-04 23:41:05.410213+07');
INSERT INTO public.pelanggan (id, nama, no_telp, created_at) VALUES (2, 'Apr', '0123456', '2026-06-07 15:22:06.464133+07');
INSERT INTO public.pelanggan (id, nama, no_telp, created_at) VALUES (3, 'test tambah pelanggan langsung', NULL, '2026-06-07 18:08:23.721337+07');


--
-- Data for Name: pembayaran_pembelian; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.pembayaran_pembelian (id, pembelian_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (1, 2, '2026-06-07', 109000, '', '2026-06-07 14:49:38.567443+07');
INSERT INTO public.pembayaran_pembelian (id, pembelian_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (2, 3, '2026-06-07', 109000, 'Pembayaran lunas (saat nota dibuat)', '2026-06-07 14:54:00.994029+07');
INSERT INTO public.pembayaran_pembelian (id, pembelian_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (3, 4, '2026-06-07', 1000000, '', '2026-06-07 14:57:34.798521+07');
INSERT INTO public.pembayaran_pembelian (id, pembelian_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (5, 5, '2026-06-08', 220000, '', '2026-06-08 09:52:35.314563+07');


--
-- Data for Name: pembayaran_penjualan; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (1, 4, '2026-06-07', 327000, 'Pembayaran lunas', '2026-06-07 14:48:48.100598+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (2, 5, '2026-06-07', 327000, 'Pembayaran lunas', '2026-06-07 14:56:19.499168+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (3, 6, '2026-06-07', 219000, 'Pembayaran lunas', '2026-06-07 15:04:21.084051+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (4, 7, '2026-06-07', 50000, 'Down Payment', '2026-06-07 15:05:11.711998+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (5, 7, '2026-06-07', 169000, '', '2026-06-07 15:05:41.866695+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (6, 8, '2026-06-07', 150000, 'Down Payment', '2026-06-07 15:27:43.562596+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (7, 9, '2026-06-07', 50000, 'Down Payment', '2026-06-07 15:32:34.414507+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (8, 10, '2026-06-07', 150000, 'Down Payment', '2026-06-07 15:42:51.133035+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (9, 11, '2026-06-07', 300000, 'Pembayaran lunas', '2026-06-07 17:42:10.662323+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (10, 12, '2026-06-07', 219000, 'Pembayaran lunas', '2026-06-07 17:49:08.639602+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (11, 13, '2026-06-07', 300000, 'Pembayaran lunas', '2026-06-07 17:49:37.066881+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (12, 14, '2026-06-07', 300000, 'Pembayaran lunas', '2026-06-07 17:56:36.389169+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (13, 15, '2026-06-07', 300000, 'Pembayaran lunas', '2026-06-07 18:05:04.784719+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (14, 16, '2026-06-07', 300000, 'Pembayaran lunas', '2026-06-07 18:09:24.076017+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (15, 17, '2026-06-07', 309000, 'Pembayaran lunas', '2026-06-07 18:09:55.064361+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (16, 18, '2026-06-08', 300000, 'Down Payment', '2026-06-08 09:49:11.308297+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (17, 19, '2026-06-08', 4530000, 'Pembayaran lunas', '2026-06-08 11:25:27.161253+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (18, 20, '2026-06-08', 500000, 'Down Payment', '2026-06-08 11:27:37.784211+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (19, 18, '2026-06-08', 3300000, '', '2026-06-08 11:32:44.605318+07');
INSERT INTO public.pembayaran_penjualan (id, penjualan_id, tanggal_bayar, jumlah_bayar, keterangan, created_at) VALUES (20, 21, '2026-06-08', 380000, 'Pembayaran lunas', '2026-06-08 12:42:38.310346+07');


--
-- Data for Name: pembelian; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.pembelian (id, kode_pembelian, tanggal_pembelian, supplier_id, total_harga, created_at, updated_at, status_bayar) VALUES (1, 'PI-20260606-0001', '2026-06-06', 1, 192012, '2026-06-06 14:00:04.199801+07', '2026-06-06 14:00:04.199801+07', 'belum_lunas');
INSERT INTO public.pembelian (id, kode_pembelian, tanggal_pembelian, supplier_id, total_harga, created_at, updated_at, status_bayar) VALUES (2, 'PI-20260607-0001', '2026-06-07', 1, 109000, '2026-06-07 14:49:30.828036+07', '2026-06-07 14:49:38.573+07', 'lunas');
INSERT INTO public.pembelian (id, kode_pembelian, tanggal_pembelian, supplier_id, total_harga, created_at, updated_at, status_bayar) VALUES (3, 'PI-20260607-0002', '2026-06-07', 1, 109000, '2026-06-07 14:54:00.994029+07', '2026-06-07 14:54:00.994029+07', 'lunas');
INSERT INTO public.pembelian (id, kode_pembelian, tanggal_pembelian, supplier_id, total_harga, created_at, updated_at, status_bayar) VALUES (4, 'PI-20260607-0003', '2026-06-07', 1, 1000000, '2026-06-07 14:57:31.176627+07', '2026-06-07 14:57:34.803+07', 'lunas');
INSERT INTO public.pembelian (id, kode_pembelian, tanggal_pembelian, supplier_id, total_harga, created_at, updated_at, status_bayar) VALUES (5, 'PI-20260607-0004', '2026-06-07', 1, 220000, '2026-06-07 17:10:45.426368+07', '2026-06-08 09:52:35.317+07', 'lunas');
INSERT INTO public.pembelian (id, kode_pembelian, tanggal_pembelian, supplier_id, total_harga, created_at, updated_at, status_bayar) VALUES (6, 'PI-20260608-0001', '2026-06-08', 1, 1170000, '2026-06-08 10:32:37.777378+07', '2026-06-08 10:32:37.777378+07', 'belum_lunas');


--
-- Data for Name: pembelian_detail; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.pembelian_detail (id, pembelian_id, barang_id, jumlah, harga_beli) VALUES (6, 5, NULL, 1, 100000);
INSERT INTO public.pembelian_detail (id, pembelian_id, barang_id, jumlah, harga_beli) VALUES (4, 4, NULL, 100, 10000);
INSERT INTO public.pembelian_detail (id, pembelian_id, barang_id, jumlah, harga_beli) VALUES (7, 5, NULL, 1, 10000);
INSERT INTO public.pembelian_detail (id, pembelian_id, barang_id, jumlah, harga_beli) VALUES (8, 5, NULL, 1, 10000);
INSERT INTO public.pembelian_detail (id, pembelian_id, barang_id, jumlah, harga_beli) VALUES (1, 1, NULL, 1, 192012);
INSERT INTO public.pembelian_detail (id, pembelian_id, barang_id, jumlah, harga_beli) VALUES (2, 2, NULL, 1, 109000);
INSERT INTO public.pembelian_detail (id, pembelian_id, barang_id, jumlah, harga_beli) VALUES (3, 3, NULL, 1, 109000);
INSERT INTO public.pembelian_detail (id, pembelian_id, barang_id, jumlah, harga_beli) VALUES (5, 5, NULL, 1, 100000);
INSERT INTO public.pembelian_detail (id, pembelian_id, barang_id, jumlah, harga_beli) VALUES (9, 6, 3174, 1, 1170000);


--
-- Data for Name: pembelian_retur; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.pembelian_retur (id, kode_retur, pembelian_id, tanggal_retur, total_retur, created_at) VALUES (1, 'RPI-20260607-0001', 2, '2026-06-07', 109000, '2026-06-07 15:09:58.707583+07');


--
-- Data for Name: pembelian_retur_detail; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.pembelian_retur_detail (id, pembelian_retur_id, barang_id, jumlah, harga_beli) VALUES (1, 1, NULL, 1, 109000);


--
-- Data for Name: pengguna; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.pengguna (id, nama, username, password_hash, hak_akses, created_at) VALUES (1, 'Administrator', 'admin', '$2a$10$oyU3QUs5CEuxBrJ/L9Z8PeBAy.7/TDjNcu.wh/OFuezuk2HJTlwCK', 'admin', '2026-06-04 23:38:20.167068+07');
INSERT INTO public.pengguna (id, nama, username, password_hash, hak_akses, created_at) VALUES (2, 'kasir 1', 'kasir', '$2a$10$dIcczIzqKiSd5F70JxKbM.JWtMZTRhkhz.djqFljr78nfEGLn.Fx.', 'kasir', '2026-06-08 11:57:02.022149+07');


--
-- Data for Name: penjualan; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (1, 'INV-20260604-0001', 1, 1, 1, '2026-06-04', 0, 30000, NULL, 30000, '2026-06-04 23:55:15.608372+07', 'lunas', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (2, 'INV-20260605-0001', 1, 1, 1, '2026-06-05', 100, 218000, 123123, 218100, '2026-06-05 18:49:05.793921+07', 'lunas', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (3, 'INV-20260605-0002', NULL, NULL, 1, '2026-06-05', 0, 218000, NULL, 218000, '2026-06-05 18:49:15.354135+07', 'lunas', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (4, 'INV-20260607-0001', NULL, NULL, 1, '2026-06-07', 0, 327000, NULL, 327000, '2026-06-07 14:48:48.100598+07', 'lunas', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (5, 'INV-20260607-0002', 1, 1, 1, '2026-06-07', 0, 327000, NULL, 327000, '2026-06-07 14:56:19.499168+07', 'lunas', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (6, 'INV-20260607-0003', 1, 2, 1, '2026-06-07', 0, 219000, NULL, 219000, '2026-06-07 15:04:21.084051+07', 'lunas', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (7, 'INV-20260607-0004', 1, 2, 1, '2026-06-07', 0, 219000, NULL, 219000, '2026-06-07 15:05:11.711998+07', 'lunas', 50000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (8, 'INV-20260607-0005', 2, 1, 1, '2026-06-07', 0, 300000, 150000, 300000, '2026-06-07 15:27:43.562596+07', 'dp', 150000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (9, 'INV-20260607-0006', 2, 1, 1, '2026-06-07', 0, 300000, 0, 300000, '2026-06-07 15:32:34.414507+07', 'dp', 50000, '2026-06-09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (10, 'INV-20260607-0007', NULL, NULL, 1, '2026-06-07', 0, 200000, 50000, 150000, '2026-06-07 15:42:51.133035+07', 'dp', 150000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (11, 'INV-20260607-0008', 1, 2, 1, '2026-06-07', 0, 300000, 0, 300000, '2026-06-07 17:42:10.662323+07', 'lunas', 0, NULL, '123', '123', '123', '123123', '123', '123', '123', '123');
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (12, 'INV-20260607-0009', NULL, NULL, 1, '2026-06-07', 0, 219000, 0, 219000, '2026-06-07 17:49:08.639602+07', 'lunas', 0, NULL, '123', '12', '12', '12', '12', '12', '12', '12');
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (13, 'INV-20260607-0010', 2, 2, 1, '2026-06-07', 0, 300000, 0, 300000, '2026-06-07 17:49:37.066881+07', 'lunas', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (14, 'INV-20260607-0011', 2, 1, 1, '2026-06-07', 0, 300000, 0, 300000, '2026-06-07 17:56:36.389169+07', 'lunas', 0, '2026-02-04', '123', '123', '123', '123', '123', '123', '123', '123');
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (15, 'INV-20260607-0012', 2, 2, 1, '2026-06-07', 0, 300000, 0, 300000, '2026-06-07 18:05:04.784719+07', 'lunas', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (16, 'INV-20260607-0013', 3, 2, 1, '2026-06-07', 0, 300000, 0, 300000, '2026-06-07 18:09:24.076017+07', 'lunas', 0, '2026-06-10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (17, 'INV-20260607-0014', 3, 3, 1, '2026-06-07', 0, 309000, 0, 309000, '2026-06-07 18:09:55.064361+07', 'lunas', 0, '2026-06-11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (19, 'INV-20260608-0002', 3, 6, 1, '2026-06-08', 0, 4530000, 0, 4530000, '2026-06-08 11:25:27.161253+07', 'lunas', 0, NULL, '-275', '-350', '0', '0', NULL, NULL, '0', '0');
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (20, 'INV-20260608-0003', 1, 5, 1, '2026-06-08', 0, 1180000, 330000, 850000, '2026-06-08 11:27:37.784211+07', 'dp', 500000, '2026-06-22', '+150', '+150', '0', '0', NULL, NULL, '+2.25', '+2.25');
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (18, 'INV-20260608-0001', 2, 2, 1, '2026-06-08', 0, 3765000, 165000, 3600000, '2026-06-08 09:49:11.308297+07', 'lunas', 300000, '2026-06-15', '0', '-500', '-200', '0', '10', NULL, NULL, NULL);
INSERT INTO public.penjualan (id, no_nota, pelanggan_id, sales_id, created_by, order_date, biaya, subtotal, bpjs, total, created_at, status_bayar, dp, tanggal_selesai, sph_r, sph_l, cyl_r, cyl_l, axis_r, axis_l, add_r, add_l) VALUES (21, 'INV-20260608-0004', 1, 3, 2, '2026-06-08', 0, 380000, 0, 380000, '2026-06-08 12:42:38.310346+07', 'lunas', 0, NULL, '0', '0', '-075', '-075', NULL, NULL, '0', '0');


--
-- Data for Name: penjualan_detail; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (1, 1, 'frame', NULL, 10000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (2, 1, 'lensa_l', NULL, 10000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (3, 1, 'lensa_r', NULL, 10000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (14, 6, 'frame', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (17, 7, 'frame', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (20, 8, 'frame', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (23, 9, 'frame', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (26, 10, 'frame', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (31, 12, 'frame', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (34, 13, 'frame', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (37, 14, 'frame', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (40, 15, 'frame', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (43, 16, 'frame', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (46, 17, 'frame', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (16, 6, 'lensa_r', NULL, 10000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (19, 7, 'lensa_r', NULL, 10000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (33, 12, 'lensa_r', NULL, 10000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (4, 2, 'lensa_l', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (5, 2, 'lensa_r', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (6, 3, 'lensa_l', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (7, 3, 'lensa_r', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (8, 4, 'frame', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (9, 4, 'lensa_l', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (10, 4, 'lensa_r', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (11, 5, 'frame', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (12, 5, 'lensa_l', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (13, 5, 'lensa_r', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (15, 6, 'lensa_l', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (18, 7, 'lensa_l', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (32, 12, 'lensa_l', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (47, 17, 'lensa_l', NULL, 109000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (21, 8, 'lensa_l', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (22, 8, 'lensa_r', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (24, 9, 'lensa_l', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (25, 9, 'lensa_r', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (27, 10, 'lensa_r', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (28, 11, 'frame', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (29, 11, 'lensa_l', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (30, 11, 'lensa_r', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (35, 13, 'lensa_l', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (36, 13, 'lensa_r', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (38, 14, 'lensa_l', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (39, 14, 'lensa_r', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (41, 15, 'lensa_l', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (42, 15, 'lensa_r', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (44, 16, 'lensa_l', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (45, 16, 'lensa_r', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (48, 17, 'lensa_r', NULL, 100000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (49, 18, 'frame', 541, 3385000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (50, 18, 'lensa_l', 472, 190000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (51, 18, 'lensa_r', 484, 190000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (52, 19, 'frame', 3422, 4150000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (53, 19, 'lensa_l', 466, 190000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (54, 19, 'lensa_r', 463, 190000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (55, 20, 'frame', 3249, 700000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (56, 20, 'lensa_l', 409, 240000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (57, 20, 'lensa_r', 408, 240000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (58, 21, 'lensa_l', 479, 190000, 0, 1);
INSERT INTO public.penjualan_detail (id, penjualan_id, tipe, barang_id, harga, diskon, jumlah) VALUES (59, 21, 'lensa_r', 479, 190000, 0, 1);


--
-- Data for Name: penjualan_retur; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.penjualan_retur (id, kode_retur, penjualan_id, tanggal_retur, total_retur, created_at) VALUES (1, 'RJ-20260607-0001', 10, '2026-06-07', 200000, '2026-06-07 15:43:08.012885+07');


--
-- Data for Name: penjualan_retur_detail; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.penjualan_retur_detail (id, penjualan_retur_id, barang_id, tipe, jumlah, harga) VALUES (1, 1, NULL, 'frame', 1, 100000);
INSERT INTO public.penjualan_retur_detail (id, penjualan_retur_id, barang_id, tipe, jumlah, harga) VALUES (2, 1, NULL, 'lensa_r', 1, 100000);


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.sales (id, nama, tanggal_kerja, status, created_at, komisi_frame, komisi_lensa) VALUES (1, 'sales test', '2026-02-02', 'aktif', '2026-06-04 23:48:22.378656+07', 0.80, 0.80);
INSERT INTO public.sales (id, nama, tanggal_kerja, status, created_at, komisi_frame, komisi_lensa) VALUES (3, 'sales komisi nol koma delapan persen', '2026-06-05', 'aktif', '2026-06-07 15:02:25.572576+07', 0.80, 0.20);
INSERT INTO public.sales (id, nama, tanggal_kerja, status, created_at, komisi_frame, komisi_lensa) VALUES (2, 'sales komisi satu persen', '2026-06-05', 'aktif', '2026-06-07 15:02:11.056585+07', 1.00, 0.20);
INSERT INTO public.sales (id, nama, tanggal_kerja, status, created_at, komisi_frame, komisi_lensa) VALUES (4, 'via', '2026-06-08', 'aktif', '2026-06-08 11:24:29.966316+07', 1.00, 0.00);
INSERT INTO public.sales (id, nama, tanggal_kerja, status, created_at, komisi_frame, komisi_lensa) VALUES (5, 'tika', '2026-06-08', 'aktif', '2026-06-08 11:24:42.523121+07', 1.00, 0.00);
INSERT INTO public.sales (id, nama, tanggal_kerja, status, created_at, komisi_frame, komisi_lensa) VALUES (6, 'khori', '2026-06-08', 'aktif', '2026-06-08 11:24:52.125166+07', 1.00, 0.00);


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: ericanthony
--

INSERT INTO public.supplier (id, nama, created_at) VALUES (1, 'supplier pt a', '2026-06-06 13:59:40.913702+07');


--
-- Name: barang_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.barang_id_seq', 3514, true);


--
-- Name: kategori_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.kategori_id_seq', 3, true);


--
-- Name: knex_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.knex_migrations_id_seq', 13, true);


--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.knex_migrations_lock_index_seq', 1, true);


--
-- Name: komisi_sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.komisi_sales_id_seq', 28, true);


--
-- Name: pelanggan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.pelanggan_id_seq', 4, true);


--
-- Name: pembayaran_pembelian_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.pembayaran_pembelian_id_seq', 5, true);


--
-- Name: pembayaran_penjualan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.pembayaran_penjualan_id_seq', 20, true);


--
-- Name: pembelian_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.pembelian_detail_id_seq', 9, true);


--
-- Name: pembelian_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.pembelian_id_seq', 6, true);


--
-- Name: pembelian_retur_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.pembelian_retur_detail_id_seq', 1, true);


--
-- Name: pembelian_retur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.pembelian_retur_id_seq', 1, true);


--
-- Name: pengguna_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.pengguna_id_seq', 2, true);


--
-- Name: penjualan_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.penjualan_detail_id_seq', 59, true);


--
-- Name: penjualan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.penjualan_id_seq', 21, true);


--
-- Name: penjualan_retur_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.penjualan_retur_detail_id_seq', 2, true);


--
-- Name: penjualan_retur_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.penjualan_retur_id_seq', 1, true);


--
-- Name: sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.sales_id_seq', 6, true);


--
-- Name: supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ericanthony
--

SELECT pg_catalog.setval('public.supplier_id_seq', 1, true);


--
-- Name: barang barang_barcode_id_unique; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.barang
    ADD CONSTRAINT barang_barcode_id_unique UNIQUE (barcode_id);


--
-- Name: barang barang_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.barang
    ADD CONSTRAINT barang_pkey PRIMARY KEY (id);


--
-- Name: kategori kategori_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.kategori
    ADD CONSTRAINT kategori_pkey PRIMARY KEY (id);


--
-- Name: knex_migrations_lock knex_migrations_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.knex_migrations_lock
    ADD CONSTRAINT knex_migrations_lock_pkey PRIMARY KEY (index);


--
-- Name: knex_migrations knex_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.knex_migrations
    ADD CONSTRAINT knex_migrations_pkey PRIMARY KEY (id);


--
-- Name: komisi_sales komisi_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.komisi_sales
    ADD CONSTRAINT komisi_sales_pkey PRIMARY KEY (id);


--
-- Name: pelanggan pelanggan_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pelanggan
    ADD CONSTRAINT pelanggan_pkey PRIMARY KEY (id);


--
-- Name: pembayaran_pembelian pembayaran_pembelian_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembayaran_pembelian
    ADD CONSTRAINT pembayaran_pembelian_pkey PRIMARY KEY (id);


--
-- Name: pembayaran_penjualan pembayaran_penjualan_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembayaran_penjualan
    ADD CONSTRAINT pembayaran_penjualan_pkey PRIMARY KEY (id);


--
-- Name: pembelian_detail pembelian_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian_detail
    ADD CONSTRAINT pembelian_detail_pkey PRIMARY KEY (id);


--
-- Name: pembelian pembelian_kode_pembelian_unique; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian
    ADD CONSTRAINT pembelian_kode_pembelian_unique UNIQUE (kode_pembelian);


--
-- Name: pembelian pembelian_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian
    ADD CONSTRAINT pembelian_pkey PRIMARY KEY (id);


--
-- Name: pembelian_retur_detail pembelian_retur_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian_retur_detail
    ADD CONSTRAINT pembelian_retur_detail_pkey PRIMARY KEY (id);


--
-- Name: pembelian_retur pembelian_retur_kode_retur_unique; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian_retur
    ADD CONSTRAINT pembelian_retur_kode_retur_unique UNIQUE (kode_retur);


--
-- Name: pembelian_retur pembelian_retur_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian_retur
    ADD CONSTRAINT pembelian_retur_pkey PRIMARY KEY (id);


--
-- Name: pengguna pengguna_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pengguna
    ADD CONSTRAINT pengguna_pkey PRIMARY KEY (id);


--
-- Name: pengguna pengguna_username_unique; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pengguna
    ADD CONSTRAINT pengguna_username_unique UNIQUE (username);


--
-- Name: penjualan_detail penjualan_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan_detail
    ADD CONSTRAINT penjualan_detail_pkey PRIMARY KEY (id);


--
-- Name: penjualan penjualan_no_nota_unique; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan
    ADD CONSTRAINT penjualan_no_nota_unique UNIQUE (no_nota);


--
-- Name: penjualan penjualan_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan
    ADD CONSTRAINT penjualan_pkey PRIMARY KEY (id);


--
-- Name: penjualan_retur_detail penjualan_retur_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan_retur_detail
    ADD CONSTRAINT penjualan_retur_detail_pkey PRIMARY KEY (id);


--
-- Name: penjualan_retur penjualan_retur_kode_retur_unique; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan_retur
    ADD CONSTRAINT penjualan_retur_kode_retur_unique UNIQUE (kode_retur);


--
-- Name: penjualan_retur penjualan_retur_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan_retur
    ADD CONSTRAINT penjualan_retur_pkey PRIMARY KEY (id);


--
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (id);


--
-- Name: barang_kategori_id_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX barang_kategori_id_index ON public.barang USING btree (kategori_id);


--
-- Name: barang_nama_barang_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX barang_nama_barang_index ON public.barang USING btree (nama_barang);


--
-- Name: pelanggan_nama_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX pelanggan_nama_index ON public.pelanggan USING btree (nama);


--
-- Name: pembayaran_pembelian_pembelian_id_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX pembayaran_pembelian_pembelian_id_index ON public.pembayaran_pembelian USING btree (pembelian_id);


--
-- Name: pembayaran_penjualan_penjualan_id_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX pembayaran_penjualan_penjualan_id_index ON public.pembayaran_penjualan USING btree (penjualan_id);


--
-- Name: pembelian_detail_pembelian_id_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX pembelian_detail_pembelian_id_index ON public.pembelian_detail USING btree (pembelian_id);


--
-- Name: pembelian_retur_detail_pembelian_retur_id_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX pembelian_retur_detail_pembelian_retur_id_index ON public.pembelian_retur_detail USING btree (pembelian_retur_id);


--
-- Name: pembelian_retur_pembelian_id_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX pembelian_retur_pembelian_id_index ON public.pembelian_retur USING btree (pembelian_id);


--
-- Name: pembelian_supplier_id_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX pembelian_supplier_id_index ON public.pembelian USING btree (supplier_id);


--
-- Name: pembelian_tanggal_pembelian_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX pembelian_tanggal_pembelian_index ON public.pembelian USING btree (tanggal_pembelian);


--
-- Name: penjualan_detail_penjualan_id_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX penjualan_detail_penjualan_id_index ON public.penjualan_detail USING btree (penjualan_id);


--
-- Name: penjualan_order_date_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX penjualan_order_date_index ON public.penjualan USING btree (order_date);


--
-- Name: penjualan_pelanggan_id_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX penjualan_pelanggan_id_index ON public.penjualan USING btree (pelanggan_id);


--
-- Name: penjualan_retur_detail_penjualan_retur_id_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX penjualan_retur_detail_penjualan_retur_id_index ON public.penjualan_retur_detail USING btree (penjualan_retur_id);


--
-- Name: penjualan_retur_penjualan_id_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX penjualan_retur_penjualan_id_index ON public.penjualan_retur USING btree (penjualan_id);


--
-- Name: penjualan_sales_id_index; Type: INDEX; Schema: public; Owner: ericanthony
--

CREATE INDEX penjualan_sales_id_index ON public.penjualan USING btree (sales_id);


--
-- Name: barang barang_kategori_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.barang
    ADD CONSTRAINT barang_kategori_id_foreign FOREIGN KEY (kategori_id) REFERENCES public.kategori(id) ON DELETE SET NULL;


--
-- Name: komisi_sales komisi_sales_penjualan_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.komisi_sales
    ADD CONSTRAINT komisi_sales_penjualan_id_foreign FOREIGN KEY (penjualan_id) REFERENCES public.penjualan(id) ON DELETE CASCADE;


--
-- Name: komisi_sales komisi_sales_sales_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.komisi_sales
    ADD CONSTRAINT komisi_sales_sales_id_foreign FOREIGN KEY (sales_id) REFERENCES public.sales(id) ON DELETE CASCADE;


--
-- Name: pembayaran_pembelian pembayaran_pembelian_pembelian_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembayaran_pembelian
    ADD CONSTRAINT pembayaran_pembelian_pembelian_id_foreign FOREIGN KEY (pembelian_id) REFERENCES public.pembelian(id) ON DELETE CASCADE;


--
-- Name: pembayaran_penjualan pembayaran_penjualan_penjualan_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembayaran_penjualan
    ADD CONSTRAINT pembayaran_penjualan_penjualan_id_foreign FOREIGN KEY (penjualan_id) REFERENCES public.penjualan(id) ON DELETE CASCADE;


--
-- Name: pembelian_detail pembelian_detail_barang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian_detail
    ADD CONSTRAINT pembelian_detail_barang_id_foreign FOREIGN KEY (barang_id) REFERENCES public.barang(id) ON DELETE SET NULL;


--
-- Name: pembelian_detail pembelian_detail_pembelian_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian_detail
    ADD CONSTRAINT pembelian_detail_pembelian_id_foreign FOREIGN KEY (pembelian_id) REFERENCES public.pembelian(id) ON DELETE CASCADE;


--
-- Name: pembelian_retur_detail pembelian_retur_detail_barang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian_retur_detail
    ADD CONSTRAINT pembelian_retur_detail_barang_id_foreign FOREIGN KEY (barang_id) REFERENCES public.barang(id) ON DELETE SET NULL;


--
-- Name: pembelian_retur_detail pembelian_retur_detail_pembelian_retur_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian_retur_detail
    ADD CONSTRAINT pembelian_retur_detail_pembelian_retur_id_foreign FOREIGN KEY (pembelian_retur_id) REFERENCES public.pembelian_retur(id) ON DELETE CASCADE;


--
-- Name: pembelian_retur pembelian_retur_pembelian_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian_retur
    ADD CONSTRAINT pembelian_retur_pembelian_id_foreign FOREIGN KEY (pembelian_id) REFERENCES public.pembelian(id) ON DELETE CASCADE;


--
-- Name: pembelian pembelian_supplier_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.pembelian
    ADD CONSTRAINT pembelian_supplier_id_foreign FOREIGN KEY (supplier_id) REFERENCES public.supplier(id) ON DELETE SET NULL;


--
-- Name: penjualan penjualan_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan
    ADD CONSTRAINT penjualan_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.pengguna(id) ON DELETE SET NULL;


--
-- Name: penjualan_detail penjualan_detail_barang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan_detail
    ADD CONSTRAINT penjualan_detail_barang_id_foreign FOREIGN KEY (barang_id) REFERENCES public.barang(id) ON DELETE SET NULL;


--
-- Name: penjualan_detail penjualan_detail_penjualan_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan_detail
    ADD CONSTRAINT penjualan_detail_penjualan_id_foreign FOREIGN KEY (penjualan_id) REFERENCES public.penjualan(id) ON DELETE CASCADE;


--
-- Name: penjualan penjualan_pelanggan_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan
    ADD CONSTRAINT penjualan_pelanggan_id_foreign FOREIGN KEY (pelanggan_id) REFERENCES public.pelanggan(id) ON DELETE SET NULL;


--
-- Name: penjualan_retur_detail penjualan_retur_detail_barang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan_retur_detail
    ADD CONSTRAINT penjualan_retur_detail_barang_id_foreign FOREIGN KEY (barang_id) REFERENCES public.barang(id) ON DELETE SET NULL;


--
-- Name: penjualan_retur_detail penjualan_retur_detail_penjualan_retur_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan_retur_detail
    ADD CONSTRAINT penjualan_retur_detail_penjualan_retur_id_foreign FOREIGN KEY (penjualan_retur_id) REFERENCES public.penjualan_retur(id) ON DELETE CASCADE;


--
-- Name: penjualan_retur penjualan_retur_penjualan_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan_retur
    ADD CONSTRAINT penjualan_retur_penjualan_id_foreign FOREIGN KEY (penjualan_id) REFERENCES public.penjualan(id) ON DELETE CASCADE;


--
-- Name: penjualan penjualan_sales_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: ericanthony
--

ALTER TABLE ONLY public.penjualan
    ADD CONSTRAINT penjualan_sales_id_foreign FOREIGN KEY (sales_id) REFERENCES public.sales(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

