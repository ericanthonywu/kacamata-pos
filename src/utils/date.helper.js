/**
 * Shared date helpers to eliminate duplicated date formatting across controllers.
 */

/** Returns today as 'YYYY-MM-DD' in local time. */
function todayStr() {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

/** Returns the first day of the current month as 'YYYY-MM-DD' in local time. */
function firstDayOfMonth() {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  return `${year}-${month}-01`;
}

/**
 * Returns { from, to } for a given month/year.
 * @param {number} bulan - 1-based month
 * @param {number} tahun
 */
function getMonthRange(bulan, tahun) {
  const from = `${tahun}-${String(bulan).padStart(2, '0')}-01`;
  const lastDay = new Date(tahun, bulan, 0).getDate();
  const to = `${tahun}-${String(bulan).padStart(2, '0')}-${lastDay}`;
  return { from, to };
}

/** Returns today as 'YYYYMMDD' (no dashes) in local time. Used for nota/kode number generation. */
function todayCompact() {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${year}${month}${day}`;
}

module.exports = { todayStr, firstDayOfMonth, getMonthRange, todayCompact };
