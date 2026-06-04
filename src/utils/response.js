/**
 * Standardized API response helpers.
 * Usage:
 *   const { ok, fail, paginate } = require('../utils/response');
 *   ok(res, data);               // 200 { success: true, data }
 *   ok(res, data, 201);          // 201 { success: true, data }
 *   fail(res, err);              // auto-status { success: false, message }
 *   fail(res, 'custom msg', 422);
 */

exports.ok = function (res, data, status) {
  return res.status(status || 200).json({
    success: true,
    data: data !== undefined ? data : null,
  });
};

exports.fail = function (res, err, status) {
  const message = typeof err === 'string' ? err : (err.message || 'Terjadi kesalahan');
  const code = status || (typeof err === 'object' && err.status) || 500;
  return res.status(code).json({
    success: false,
    message,
  });
};
