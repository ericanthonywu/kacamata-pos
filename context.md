# Kacamata POS — Project Context

> **Optical shop (toko kacamata) Point-of-Sale admin panel.**
> Brand name shown in UI: **Sentral Optik**

---

## Tech Stack

| Layer        | Technology                                                                 |
|-------------|---------------------------------------------------------------------------|
| Runtime      | Node.js                                                                   |
| Framework    | Express 4 (with EJS view engine)                                          |
| Database     | PostgreSQL (via Knex.js query builder)                                    |
| Auth         | Session-based (`express-session`) + bcryptjs for password hashing         |
| Frontend     | Bootstrap 5.3 (dark theme), jQuery 3.7, DataTables 2.0, Bootstrap Icons   |
| Barcode      | JsBarcode (client-side barcode rendering)                                 |
| Dev server   | `node --watch src/app.js` (no bundler)                                    |

### Key Dependencies (package.json)
- `express`, `ejs`, `knex`, `pg`, `bcryptjs`, `express-session`, `connect-flash`, `dotenv`
- **No dev dependencies** — uses Node's built-in `--watch` flag

---

## Running the Project

```bash
# 1. Setup environment
cp .env.example .env
# Edit .env with your PostgreSQL credentials

# 2. Install & migrate
npm install
npm run migrate    # knex migrate:latest
npm run seed       # creates admin user + default categories

# 3. Start dev server
npm run dev        # node --watch src/app.js → http://localhost:3000

# Default login: admin / admin123
```

---

## Project Structure

```
kacamata-pos/
├── src/
│   ├── app.js                    # Express entry point, route mounting, middleware
│   ├── config/
│   │   ├── database.js           # Knex instance (imports knexfile.js)
│   │   └── session.js            # express-session config (24h cookie)
│   ├── middleware/
│   │   ├── auth.js               # Session-based auth guard (redirect to /login)
│   │   └── errorHandler.js       # Global error handler (JSON for AJAX, flash+redirect for pages)
│   ├── controllers/              # Route handlers — render views or return JSON
│   │   ├── auth.controller.js
│   │   ├── barang.controller.js
│   │   ├── kategori.controller.js
│   │   ├── laporan.controller.js
│   │   ├── pelanggan.controller.js
│   │   ├── pengguna.controller.js
│   │   ├── penjualan.controller.js
│   │   ├── sales.controller.js
│   │   └── supplier.controller.js
│   ├── services/                 # Business logic & validation
│   │   ├── barang.service.js
│   │   ├── kategori.service.js
│   │   ├── laporan.service.js
│   │   ├── pelanggan.service.js
│   │   ├── pengguna.service.js
│   │   ├── penjualan.service.js
│   │   ├── sales.service.js
│   │   └── supplier.service.js
│   ├── repositories/             # Database queries (Knex)
│   │   ├── barang.repository.js
│   │   ├── kategori.repository.js
│   │   ├── laporan.repository.js
│   │   ├── pelanggan.repository.js
│   │   ├── pengguna.repository.js
│   │   ├── penjualan.repository.js
│   │   ├── sales.repository.js
│   │   └── supplier.repository.js
│   ├── routes/                   # Express routers (all routes behind auth middleware)
│   │   ├── auth.routes.js        # /login, /logout (NO auth)
│   │   ├── barang.routes.js
│   │   ├── kategori.routes.js
│   │   ├── laporan.routes.js
│   │   ├── pelanggan.routes.js
│   │   ├── pengguna.routes.js
│   │   ├── penjualan.routes.js
│   │   ├── sales.routes.js
│   │   └── supplier.routes.js
│   └── utils/
│       └── response.js           # ok(res, data, status) / fail(res, err, status)
├── views/
│   ├── partials/
│   │   ├── top.ejs               # HTML head, CDN links, opens <body> + app-wrapper
│   │   ├── bottom.ejs            # Closes layout, toast container, delete modal
│   │   ├── sidebar.ejs           # Navigation sidebar
│   │   ├── header.ejs            # Page header area (minimal)
│   │   └── delete-modal.ejs      # Reusable Bootstrap confirmation modal
│   ├── auth/login.ejs            # Standalone login page (no sidebar layout)
│   ├── dashboard.ejs             # Quick links (Penjualan, Barang, Pelanggan, Laporan)
│   ├── barang/                   # CRUD views for products
│   ├── kategori/                 # CRUD views for categories
│   ├── pelanggan/                # CRUD views for customers
│   ├── pengguna/                 # CRUD views for users
│   ├── penjualan/
│   │   ├── index.ejs             # Sales list with DataTable + detail modal + void
│   │   └── form.ejs              # New sale form (frame + lensa L + lensa R)
│   ├── sales/                    # CRUD views for salespeople
│   ├── stock-gudang/             # Read-only stock view (reuses barang data)
│   ├── supplier/                 # CRUD views for suppliers
│   └── laporan/
│       └── kas.ejs               # Cash report with date/sales filters + summary stats
├── public/
│   ├── css/app.css               # Custom styles (sidebar, stat cards, dark theme)
│   └── js/app.js                 # Shared utilities (showToast, confirmDelete, fmtRp)
├── db/
│   ├── migrations/
│   │   └── 20240101000000_initial.js   # Creates all 8 tables
│   └── seeds/
│       └── 001_admin.js                # Admin user + default categories
├── knexfile.js                   # Knex configuration (PostgreSQL)
├── .env / .env.example           # Environment variables
└── package.json
```

---

## Architecture Pattern

```
Routes → (auth middleware) → Controllers → Services → Repositories → PostgreSQL
                                   ↓
                             Views (EJS)
```

- **Controllers**: Thin — call services, render EJS views (for pages) or return JSON via `ok()`/`fail()` (for API/AJAX).
- **Services**: Business logic, input validation, data transformation. Errors are thrown as `Error` objects with a `.status` property (e.g., `{ status: 400 }`).
- **Repositories**: Pure Knex queries. No validation logic.
- **Views**: Server-rendered EJS. Page layout is `top.ejs` → content → `bottom.ejs`. Inline `<script>` blocks for page-specific JS (jQuery-based).

### Response Helpers (`src/utils/response.js`)
```js
ok(res, data, status)     // { success: true, data }
fail(res, err, status)    // { success: false, message }
```

### Error Handling (`src/middleware/errorHandler.js`)
- AJAX requests → JSON response with error status
- Page requests → `req.flash('error', message)` + redirect back

### Auth Flow
- Session stored in memory (no Redis/store)
- User object stored in `req.session.user` = `{ id, nama, username, hak_akses }`
- `res.locals.currentUser` available in all templates
- `hak_akses` field exists (`admin` / `kasir`) but **no role-based access control** is implemented yet

---

## Database Schema

All tables created in a single migration: `db/migrations/20240101000000_initial.js`

### Tables

| Table | Description | Key Columns |
|-------|-------------|-------------|
| `kategori` | Product categories | `id`, `nama` |
| `barang` | Products/items | `id`, `nama_barang`, `kategori_id` (FK→kategori), `qty` (stock), `harga_jual`, `barcode_id` (unique, auto-generated as `BRG-XXXXXX`) |
| `supplier` | Suppliers | `id`, `nama` |
| `pelanggan` | Customers | `id`, `nama`, `no_telp` |
| `sales` | Salespeople | `id`, `nama`, `tanggal_kerja`, `status` (`aktif`/`nonaktif`) |
| `pengguna` | System users | `id`, `nama`, `username` (unique), `password_hash`, `hak_akses` (`admin`/`kasir`) |
| `penjualan` | Sales transactions | `id`, `no_nota` (unique, format: `INV-YYYYMMDD-XXXX`), `pelanggan_id` (FK), `sales_id` (FK), `created_by` (FK→pengguna), `order_date`, `biaya` (additional fee), `subtotal`, `bpjs`, `total` |
| `penjualan_detail` | Sale line items | `id`, `penjualan_id` (FK, CASCADE delete), `tipe` (`frame`/`lensa_l`/`lensa_r`), `barang_id` (FK→barang), `harga`, `diskon`, `jumlah` |

### Relationships
```
kategori ←──── barang (kategori_id, SET NULL on delete)
pelanggan ←──── penjualan (pelanggan_id, SET NULL)
sales ←──── penjualan (sales_id, SET NULL)
pengguna ←──── penjualan (created_by, SET NULL)
barang ←──── penjualan_detail (barang_id, SET NULL)
penjualan ←──── penjualan_detail (penjualan_id, CASCADE)
```

### Seed Data
- Admin user: `admin` / `admin123` (hak_akses: `admin`)
- Default categories: `Frame`, `Lensa`, `Aksesoris`

---

## Module Details

### Penjualan (Sales) — Core Module

This is the main business flow of the application.

**Creating a sale** (`POST /penjualan`):
1. Form at `/penjualan/baru` allows selecting up to 3 items: **Frame**, **Lensa (L)**, **Lensa (R)**
2. Each item: select a `barang` → auto-fills `harga_jual` → user can adjust `harga`, `diskon`, `jumlah`
3. Summary shows `subtotal` + `biaya` (additional fee) = `total`
4. Optional: `pelanggan`, `sales`, `order_date`, `bpjs` number
5. Submit via AJAX (`savePenjualan()`) → can optionally print receipt (`printNotaData()`)

**Stock behavior**:
- On sale creation: stock (`barang.qty`) is **decremented** for each item (in `penjualan.repository.js` within a transaction)
- On sale deletion (void): stock is **incremented** back (restored)
- **Stock validation** is in place — service layer checks available qty before allowing sale. Frontend also validates client-side using `data-qty` attributes on `<option>` elements
- Nota number: auto-generated as `INV-YYYYMMDD-XXXX` (sequential per day)

**Voiding a sale** (`DELETE /penjualan/:id`):
- Restores stock for all items
- Deletes the sale and all detail records (CASCADE)

### Barang (Products)
- CRUD with auto-generated `barcode_id` (format: `BRG-XXXXXX`)
- `qty` is managed via direct edit and auto-adjusted by sales
- Has search endpoint (`GET /barang/search?q=`) for typeahead (used by `ilike` on `nama_barang` and `barcode_id`)

### Stock Gudang (Warehouse Stock)
- **Read-only view** — same data as Barang but displayed without edit controls
- Defined inline in `app.js` (no dedicated controller/service)

### Laporan Kas (Cash Report)
- Filterable by date range (`from`/`to`) and `sales_id`
- Summary: total transactions, subtotal, biaya, total penjualan
- Transaction list table

### Other Master Data (standard CRUD)
- **Kategori**: name only
- **Supplier**: name only (no purchase module yet)
- **Pelanggan**: name + phone number
- **Sales**: name + `tanggal_kerja` (start date) + `status` (aktif/nonaktif)
- **Pengguna**: name + username + password (hashed) + `hak_akses`

---

## Frontend Conventions

### Layout
- All pages use `top.ejs` → page content → `bottom.ejs`
- Exception: login page has standalone layout (`layout: false`)
- Sidebar navigation with sections: Menu Utama, Master Data, Pengaturan
- Dark theme (`data-bs-theme="dark"` on `<html>`)

### JavaScript Patterns
- jQuery is the primary JS library
- `showToast(message, type)` — global toast notification (success/danger/warning/info)
- `confirmDelete(id, url)` — opens Bootstrap modal, AJAX DELETE on confirm
- `fmtRp(value)` — format as Indonesian Rupiah (`Rp 1.000.000`)
- Page-specific logic is in inline `<script>` blocks within EJS templates
- DataTables for all list pages
- AJAX for all create/update/delete operations (no full page form submissions)

### CSS
- Single `public/css/app.css` — custom styles for sidebar, stat cards, layout wrapper
- Bootstrap 5.3 provides the design system

### CDN Libraries (loaded in top.ejs)
- Bootstrap 5.3.3 (CSS + JS bundle)
- Bootstrap Icons 1.11.3
- jQuery 3.7.1
- DataTables 2.0.8 (core + Bootstrap 5 integration)
- JsBarcode 3.11.6

---

## Environment Variables

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=kacamata_pos
DB_USER=postgres
DB_PASSWORD=yourpassword
SESSION_SECRET=change-this-secret
PORT=3000
```

---

## Important Patterns & Conventions

1. **Error throwing pattern**: Services throw errors as `Object.assign(new Error('message'), { status: 400 })` — the error handler and `fail()` helper pick up the `.status` property.

2. **Controllers** call services and never access repositories directly.

3. **All routes** (except auth) are protected by the `auth` middleware.

4. **AJAX pattern**: Forms use jQuery `$.ajax()` for submission. Success → redirect or reload. Error → `showToast()` with error message from `xhr.responseJSON.message`.

5. **No role-based access control**: The `hak_akses` field exists but is not enforced on any route. All authenticated users have full access.

6. **No purchase/procurement module**: Supplier entity exists but there's no purchase order or stock-in flow. Stock is managed by directly editing `barang.qty`.

7. **No pagination**: All list queries return full dataset. DataTables handles client-side pagination.

8. **Transactions**: Only used in `penjualan.repository.js` for creating and deleting sales (to ensure stock adjustments are atomic).

---

## What's NOT Implemented Yet

- Role-based access control (admin vs kasir restrictions)
- Purchase orders / stock-in from suppliers
- Audit trail / activity log
- API token authentication
- Pagination on backend queries
- Payment tracking (e.g., paid/unpaid status, payment methods)
- Edit existing sale (only create and void/delete)
