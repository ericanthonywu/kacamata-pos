/* app.js — Shared jQuery utilities */

// DataTables Indonesian language
var dtLanguageID = {
  search: 'Cari:',
  lengthMenu: 'Tampilkan _MENU_ data',
  info: 'Menampilkan _START_ - _END_ dari _TOTAL_ data',
  infoEmpty: 'Tidak ada data',
  infoFiltered: '(difilter dari _MAX_ total data)',
  zeroRecords: 'Data tidak ditemukan',
  emptyTable: 'Tidak ada data tersedia',
  paginate: { first: 'Pertama', last: 'Terakhir', next: 'Berikutnya', previous: 'Sebelumnya' }
};

// Toast notification
function showToast(message, type) {
  type = type || 'success';
  var $toast = $('#appToast');
  $toast.removeClass('text-bg-success text-bg-danger text-bg-warning text-bg-info')
    .addClass('text-bg-' + type);
  $('#toastBody').text(message);
  var toast = bootstrap.Toast.getOrCreateInstance($toast[0], { delay: 3000 });
  toast.show();
}

// Confirm delete — used by all CRUD pages
var deleteUrl = null;
function confirmDelete(id, url) {
  deleteUrl = url;
  new bootstrap.Modal('#deleteModal').show();
}

$(function () {
  $('#deleteConfirmBtn').on('click', function () {
    if (!deleteUrl) return;
    $.ajax({
      url: deleteUrl,
      method: 'DELETE',
      success: function (res) {
        if (res.success) location.reload();
        else showToast(res.message || 'Gagal menghapus', 'danger');
      },
      error: function (xhr) {
        showToast(xhr.responseJSON?.message || 'Gagal menghapus', 'danger');
      },
    });
  });
});

// Format Rupiah
function fmtRp(value) {
  return 'Rp ' + Number(value || 0).toLocaleString('id-ID');
}

// Currency Input Handler
$(function() {
  function initCurrencyInput(input) {
    let name = input.attr('name');
    let hidden = input.siblings('.currency-hidden');
    if (name && hidden.length === 0) {
      input.removeAttr('name');
      hidden = $('<input type="hidden" class="currency-hidden" name="'+name+'">');
      input.after(hidden);
    }
    input.data('hidden-target', hidden);
    updateCurrencyInput(input);
  }

  function updateCurrencyInput(input) {
    let val = String(input.val() || '').replace(/[^0-9]/g, '');
    let hidden = input.data('hidden-target');
    
    if (val === '') {
      input.val('');
      if (hidden && hidden.length) hidden.val('0');
      input.data('raw-value', 0);
    } else {
      input.val(Number(val).toLocaleString('id-ID'));
      if (hidden && hidden.length) hidden.val(val);
      input.data('raw-value', val);
    }
  }

  // Init existing ones
  $('.input-currency').each(function() {
    initCurrencyInput($(this));
  });

  // Handle dynamic inputs and typing
  $(document).on('input', '.input-currency', function() {
    updateCurrencyInput($(this));
  });
});
