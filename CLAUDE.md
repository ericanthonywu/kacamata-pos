# Kacamata POS — Project Context & Coding Rules

> **Optical shop (toko kacamata) Point-of-Sale admin panel.**
> Brand name shown in UI: **Optik**

---

## Tech Stack

| Layer | Technology |
|---|---|
| Runtime | Node.js |
| Framework | Express 4 + EJS views |
| Database | PostgreSQL via **Knex.js** |
| Auth | `express-session` + bcryptjs |
| Frontend | Bootstrap 5.3 (dark), jQuery 3.7, DataTables 2.x |
| Dev server | `npm run dev` → `nodemon src/app.js` on port 3000 |

### Key Dependencies
- `express`, `ejs`, `knex`, `pg`, `bcryptjs`, `express-session`, `connect-flash`, `dotenv`
- Dev dependency: `eslint` (Node 13 syntax guard — see **Deployment Target** below). Dev server uses `nodemon`.

---

## Deployment Target: Windows 7 / Node 13 (CRITICAL)

Production runs on **Windows 7**, whose last supported Node.js is **13.x**.
Development may use newer Node (e.g. v25), so modern syntax can "work locally"
and then **fail to start in production** — ES2020+ syntax is a parse-time
`SyntaxError` on Node 13.

- **Server code must stay ES2019-compatible.** Forbidden in `src/`, `db/`, `knexfile.js`:
  `?.` (optional chaining), `??` (nullish coalescing), `||=`/`&&=`/`??=` (logical
  assignment), `Promise.any`, `structuredClone`, `.at()`, `.replaceAll()`, top-level `await`.
- **Browser code in `public/` is exempt** — it runs in Chrome, not Node 13.
- **Enforced by `npm run lint`** (ESLint pinned to `ecmaVersion: 2019` in
  `eslint.config.js`). Run before every commit/deploy.
- **Dev server uses `nodemon`**, NOT `node --watch` (that flag is Node 18.11+).
- **`unhandledRejection` only warns on Node 13** (Node 15+ crashes) — handle
  promise errors explicitly; don't rely on the process crashing.
- **DB host failover:** `src/config/resolve-host.js` + the `connection` function
  in `knexfile.js` are a manual backport of Node 20's `autoSelectFamily`
  (Happy-Eyeballs IPv4/IPv6 selection). Delete both and revert to
  `host: process.env.DB_HOST` once the target moves to Node ≥ 20.

---

## Running the Project

```bash
cp .env.example .env      # fill in PostgreSQL credentials
npm install
npm run migrate            # knex migrate:latest
npm run seed               # creates admin user + default categories
npm run dev                # http://localhost:3000 — Default login: admin / admin123
```

---

## Project Structure

```
kacamata-pos/
├── src/
│   ├── app.js                         # Express entry point
│   ├── config/database.js             # Knex instance
│   ├── middleware/
│   │   ├── auth.js                    # Session-based auth guard
│   │   ├── rbac.js                    # Role check (requireAdmin)
│   │   └── errorHandler.js            # Global error handler
│   ├── controllers/                   # Route handlers (render views or JSON)
│   ├── services/                      # Business logic & transaction orchestration
│   ├── repositories/                  # Single-table Knex queries
│   ├── routes/                        # Express routers
│   └── utils/
│       ├── response.js                # ok() / fail() helpers
│       ├── komisi.helper.js           # buildKomisiRows() — shared komisi calc
│       └── date.helper.js             # todayStr(), firstDayOfMonth(), getMonthRange(), todayCompact()
├── views/                             # EJS templates
│   ├── partials/top.ejs, bottom.ejs, sidebar.ejs
│   └── {module}/index.ejs, form.ejs
├── db/
│   ├── migrations/                    # Knex migrations
│   └── seeds/001_admin.js             # Admin user + default categories
└── public/css/app.css, js/app.js
```

---

## Architecture: Strict Layer Rules

```
Routes → Controllers → Services → Repositories → PostgreSQL (Knex)
```

### Rule 1 — 1 Repository = 1 Table (CRITICAL)
Every repository file handles **exactly one** database table for write operations.
- ✅ `penjualan.repository.js` → only writes/reads `penjualan` table
- ❌ NEVER write to multiple tables in one repository
- Cross-table **reads** (JOINs) are acceptable in repositories for building result sets
- Multi-table **writes** (INSERT + UPDATE across tables) belong in **services** using `db.transaction()`

### Rule 2 — Services Own Business Logic
- All transaction orchestration lives in services, not repositories
- Repositories expose thin, trx-aware methods (`insert(trx, data)`, `update(trx, id, data)`, `deleteById(trx, id)`) for service-layer transactions
- Services call `db.transaction(async (trx) => { ... })` and pass `trx` down to repos

### Rule 3 — No Direct DB Access in Services (except `db.transaction`)
- Services MUST NOT import `db` for queries — only for starting transactions
- Services MUST NOT call `trx('table_name')` directly — always go through a repository method
- ❌ `const db = require('../config/database'); db('penjualan').select(...)` inside a service
- ✅ `const penjualanRepo = require('../repositories/penjualan.repository'); penjualanRepo.findAll()`

### Rule 4 — No Repo Imports in Controllers or Routes
- Controllers only import services
- Routes only import controllers and middleware
- ❌ `const repo = require('../repositories/laporan.repository')` in a route file

### Rule 5 — SELECT EXISTS over COUNT for Boolean Checks
When you only need to know **if data exists** (not how many), use:
```js
// ✅ CORRECT — short-circuits on first match
const result = await db.raw('SELECT EXISTS(SELECT 1 FROM penjualan WHERE pelanggan_id = ?) as exists', [id]);
return result.rows[0].exists;

// ❌ WRONG — scans all rows
const count = await db('penjualan').where('pelanggan_id', id).count('id as cnt').first();
```

### Rule 6 — DRY: No Duplicate Business Logic
- Shared calculations must be extracted into `src/utils/*.helper.js`
- `komisi.helper.js` contains `buildKomisiRows()` — do NOT copy-paste this logic elsewhere

### Rule 7 — Always Use Local WIB Time (NEVER UTC)
- **NEVER** use `new Date().toISOString()` anywhere — it returns UTC, which is wrong for GMT+7 users
- ✅ Always import from `src/utils/date.helper.js`:
  - `todayStr()` → `'YYYY-MM-DD'` in local time (for date fields, filters)
  - `todayCompact()` → `'YYYYMMDD'` in local time (for nota/kode number prefixes)
  - `firstDayOfMonth()` → first day of current month in local time
  - `getMonthRange(bulan, tahun)` → `{ from, to }` for a given month

---

## Repository Patterns

### Standard Single-Table Repo
```js
const db = require('../config/database');
const { todayCompact } = require('../utils/date.helper'); // only if generating codes
const TABLE = 'table_name';

// ── Read (non-trx) ──
exports.findAll = function () { return db(TABLE)...; };
exports.findById = function (id) { return db(TABLE).where('id', id).first(); };

// ── Read (trx-aware) ──
exports.findByIdWithTrx = function (trx, id) { return trx(TABLE).where('id', id).first(); };

// ── Write (always trx-aware) ──
exports.insert = function (trx, data) {
  return trx(TABLE).insert(data).returning('*').then(r => r[0]);
};
exports.update = function (trx, id, data) {
  return trx(TABLE).where('id', id).update(data);
};
exports.deleteById = function (trx, id) {
  return trx(TABLE).where('id', id).del();
};
```

### Reporting Repositories
`laporan.repository.js` may JOIN multiple tables for **read-only** queries — this is the only exception.

---

## Service Patterns

### Transaction Pattern
```js
const db = require('../config/database');
const { todayStr } = require('../utils/date.helper');
const tableARepo = require('../repositories/tableA.repository');
const tableBRepo = require('../repositories/tableB.repository');

exports.create = async function (data) {
  return db.transaction(async (trx) => {
    const a = await tableARepo.insert(trx, { date: data.date || todayStr(), ... });
    await tableBRepo.insert(trx, { related_id: a.id, ... });
    return a;
  });
};
```

### Error Pattern
```js
throw Object.assign(new Error('Human-readable message'), { status: 400 });
```

---

## File Map (Current State)

### Repositories (`src/repositories/`)
| File | Table |
|---|---|
| `barang.repository.js` | `barang` |
| `kategori.repository.js` | `kategori` |
| `pelanggan.repository.js` | `pelanggan` |
| `pengguna.repository.js` | `pengguna` |
| `sales.repository.js` | `sales` |
| `supplier.repository.js` | `supplier` |
| `metode-pembayaran.repository.js` | `metode_pembayaran` |
| `penjualan.repository.js` | `penjualan` |
| `penjualan-detail.repository.js` | `penjualan_detail` |
| `pembayaran-penjualan.repository.js` | `pembayaran_penjualan` |
| `kas.repository.js` | `kas` + reporting queries |
| `komisi-sales.repository.js` | `komisi_sales` |
| `penjualan-retur.repository.js` | `penjualan_retur` |
| `penjualan-retur-detail.repository.js` | `penjualan_retur_detail` |
| `pembelian.repository.js` | `pembelian` |
| `pembelian-detail.repository.js` | `pembelian_detail` |
| `pembayaran-pembelian.repository.js` | `pembayaran_pembelian` |
| `pembelian-retur.repository.js` | `pembelian_retur` |
| `pembelian-retur-detail.repository.js` | `pembelian_retur_detail` |
| `bukti-hitung-fisik.repository.js` | `bukti_hitung_fisik` |
| `laporan.repository.js` | read-only komisi reporting (multi-table JOINs OK) |

### Utilities (`src/utils/`)
| File | Purpose |
|---|---|
| `response.js` | `ok(res, data, status)` / `fail(res, err, status)` |
| `komisi.helper.js` | `buildKomisiRows(penjualanId, sales, detailItems)` |
| `date.helper.js` | `todayStr()`, `todayCompact()`, `firstDayOfMonth()`, `getMonthRange(bulan, tahun)` |

### Services — Transaction Ownership
| Service | Coordinates |
|---|---|
| `penjualan.service.js` | penjualan + detail + kas + pembayaran + komisi + stock |
| `pembelian.service.js` | pembelian + detail + pembayaran + stock |
| `pembayaran-penjualan.service.js` | pembayaran + kas + status update + komisi |
| `pembayaran-pembelian.service.js` | pembayaran + status update |
| `penjualan-retur.service.js` | retur + detail + stock + kas + komisi |
| `pembelian-retur.service.js` | retur + detail + stock |
| `bukti-hitung-fisik.service.js` | log + stock update |

---

## Database Schema

| Table | Key Columns |
|---|---|
| `kategori` | `id`, `nama` |
| `barang` | `id`, `nama_barang`, `kategori_id`, `qty`, `harga_jual`, `barcode_id` (`BRG-XXXXXX`), `deleted_at` (soft delete) |
| `supplier` | `id`, `nama` |
| `pelanggan` | `id`, `nama`, `no_telp` |
| `sales` | `id`, `nama`, `komisi_frame`, `komisi_lensa`, `tanggal_kerja`, `status` (`aktif`/`nonaktif`) |
| `pengguna` | `id`, `nama`, `username`, `password_hash`, `hak_akses` (`admin`/`kasir`) |
| `metode_pembayaran` | `id`, `nama` |
| `penjualan` | `id`, `no_nota` (`INV-YYYYMMDD-XXXX`/`B2B-YYYYMMDD-XXXX`), `pelanggan_id`, `sales_id`, `created_by`, `order_date`, `subtotal`, `bpjs`, `total`, `status_bayar`, `dp`, `metode_bayar_id`, `is_b2b` |
| `penjualan_detail` | `id`, `penjualan_id`, `tipe` (`frame`/`lensa_l`/`lensa_r`/`lain_lain`), `barang_id`, `harga`, `diskon`, `jumlah` |
| `pembayaran_penjualan` | `id`, `penjualan_id`, `tanggal_bayar`, `jumlah_bayar`, `metode_bayar_id` |
| `kas` | `id`, `tipe` (`masuk`/`keluar`), `kategori`, `jumlah`, `tanggal`, `referensi_id`, `referensi_tipe`, `penjualan_id`, `metode_bayar_id` |
| `komisi_sales` | `id`, `penjualan_id`, `sales_id`, `tipe_item`, `nominal_komisi` |
| `penjualan_retur` | `id`, `kode_retur` (`RJ-YYYYMMDD-XXXX`), `penjualan_id`, `tanggal_retur`, `total_retur` |
| `penjualan_retur_detail` | `id`, `retur_id`, `barang_id`, `jumlah`, `harga`, `subtotal` |
| `pembelian` | `id`, `kode_pembelian` (`PI-YYYYMMDD-XXXX`), `supplier_id`, `tanggal_pembelian`, `total_harga`, `status_bayar` |
| `pembelian_detail` | `id`, `pembelian_id`, `barang_id`, `jumlah`, `harga_beli` |
| `pembayaran_pembelian` | `id`, `pembelian_id`, `tanggal_bayar`, `jumlah_bayar` |
| `pembelian_retur` | `id`, `kode_retur` (`RPI-YYYYMMDD-XXXX`), `pembelian_id`, `tanggal_retur`, `total_retur` |
| `pembelian_retur_detail` | `id`, `retur_id`, `barang_id`, `jumlah`, `harga`, `subtotal` |
| `bukti_hitung_fisik` | `id`, `barang_id`, `nama_barang`, `barcode_id`, `qty_sebelum`, `qty_sesudah`, `selisih`, `diubah_oleh` |

---

## Frontend Conventions

- All pages: `top.ejs` → content → `bottom.ejs`. Login page is standalone.
- **jQuery** for all AJAX. `showToast(msg, type)`, `confirmDelete(id, url)`, `fmtRp(value)` are global.
- **DataTables** (server-side) for all list pages — AJAX to `/module/dt`
- `ok(res, data)` / `fail(res, err)` for all JSON API responses
- Error thrown in service → `{ status: 400 }` → picked up by `errorHandler.js`

---

## What NOT to Do

1. ❌ Do NOT add business logic to repositories
2. ❌ Do NOT call `db('table')` directly in services
3. ❌ Do NOT import repositories in controllers or routes
4. ❌ Do NOT use `new Date().toISOString()` anywhere — use `date.helper.js`
5. ❌ Do NOT use `COUNT` when `EXISTS` is sufficient
6. ❌ Do NOT duplicate komisi calculation — use `buildKomisiRows()` from `komisi.helper.js`
7. ❌ Do NOT create a repository that writes to more than one table
8. ❌ Do NOT use ES2020+ syntax in server code (`?.`, `??`, `||=`, `.at()`, `Promise.any`, …) — Node 13 target; run `npm run lint`

---

## Verification Commands

```bash
npm run dev           # start dev server (port 3000)
npm run migrate       # run pending migrations
npm run seed          # seed admin user + categories
npm run lint          # enforce Node 13 (ES2019) syntax on server code

# Verify all modules load without import errors:
node -e "require('./src/routes/index.routes')" && echo "OK"
```
