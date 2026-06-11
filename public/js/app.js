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
  paginate: { first: 'Pertama', last: 'Terakhir', next: 'Berikutnya', previous: 'Sebelumnya' },
  buttons: {
    pageLength: {
      _: '%d baris',
      '-1': 'Semua data'
    }
  }
};

function escapeHtml(unsafe) {
  return (unsafe||'').toString()
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

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

function printNotaData(d) {
  var dFormatDate = function(dStr) {
    if (!dStr) return '';
    var dt = new Date(dStr);
    return ('0' + dt.getDate()).slice(-2) + '-' + ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][dt.getMonth()] + '-' + dt.getFullYear();
  };

  var orderDate = dFormatDate(d.order_date);
  var tglSelesai = dFormatDate(d.tanggal_selesai);
  
  var no = d.no_nota || '-';
  var nama = d.pelanggan_nama || '-';
  var telp = d.pelanggan_telp || '-';
  var sales = d.sales_nama || '-';

  var frameItem = (d.detail||[]).find(function(i) { return i.tipe === 'frame'; });
  var lensaRItem = (d.detail||[]).find(function(i) { return i.tipe === 'lensa_r'; });
  var lensaLItem = (d.detail||[]).find(function(i) { return i.tipe === 'lensa_l'; });

  var total = d.total || 0;
  var dp = d.dp || 0;
  var sisa = total - dp;
  if(d.status_bayar === 'lunas') {
    dp = total;
    sisa = 0;
  }

  // Helper to pad strings
  var padRight = function(str, length) { return (str + '                                                                                                    ').substring(0, length); };
  var padLeft = function(str, length) { return ('                                                                                                    ' + str).slice(-length); };
  var centerText = function(str, length) { 
    var pad = Math.max(0, Math.floor((length - str.length) / 2));
    return padRight('                                                                                                    '.substring(0, pad) + str, length);
  };

  var lines = [];
  
  lines.push('<div style="display: flex; justify-content: space-between; align-items: flex-start; width: 80ch; font-family: monospace; font-size: 13px; white-space: normal; line-height: 1.5; margin-bottom: 15px;">');
  lines.push('  <div style="font-size: 18px; font-weight: bold; width: 30%;">NO INVOICE:<br>' + no + '</div>');
  lines.push('  <div style="text-align: center; width: 40%;">');
  lines.push('    <strong style="font-size: 16px;">OPTIK SENTRAL</strong><br>');
  lines.push('    JL.R.SUPRAPTONO.NO.41 KETAPANG<br>');
  lines.push('    TELP : 085350509540');
  lines.push('  </div>');
  lines.push('  <div style="text-align: right; width: 30%;">dikirim<br>' + orderDate + '</div>');
  lines.push('</div>');
  var strTglSelesai = 'Tgl. Selesai : ' + tglSelesai;
  lines.push(padRight('Nama      : ' + nama, 80 - strTglSelesai.length) + strTglSelesai);
  lines.push('Telp      : ' + telp);
  lines.push('');
  lines.push('________________________________________________________________________________');
  lines.push('');
  
  var itemNum = 1;
  if (frameItem) {
    lines.push(padRight(itemNum + '. FRAME   : ' + (frameItem.nama_barang||'-'), 60) + padLeft('Rp ' + Number(frameItem.harga * frameItem.jumlah).toLocaleString('id-ID'), 20));
    itemNum++;
  }
  if (lensaRItem) {
    lines.push(padRight(itemNum + '. LENSA(R): ' + (lensaRItem.nama_barang||'-'), 60) + padLeft('Rp ' + Number(lensaRItem.harga * lensaRItem.jumlah).toLocaleString('id-ID'), 20));
    itemNum++;
  }
  if (lensaLItem) {
    lines.push(padRight(itemNum + '. LENSA(L): ' + (lensaLItem.nama_barang||'-'), 60) + padLeft('Rp ' + Number(lensaLItem.harga * lensaLItem.jumlah).toLocaleString('id-ID'), 20));
    itemNum++;
  }
  lines.push(padRight('', 40) + padRight('Jumlah', 20) + ': ' + padLeft('Rp ' + Number(total).toLocaleString('id-ID'), 18));
  if (d.bpjs > 0) {
    lines.push(padRight('', 40) + padRight('BPJS', 20) + ': ' + padLeft('- Rp ' + Number(d.bpjs).toLocaleString('id-ID'), 18));
  }
  lines.push(padRight('', 40) + padRight('Uang Muka', 20) + ': ' + padLeft('Rp ' + Number(dp).toLocaleString('id-ID'), 18));
  lines.push(padRight('', 40) + padRight('Sisa', 20) + ': ' + padLeft('Rp ' + Number(sisa).toLocaleString('id-ID'), 18));
  lines.push('--------------------------------------------------------------------------------');
  
  function makeRow(leftText, rightText) {
    // limit left side to 43 chars so it doesn't overflow to right side
    return padRight(leftText.substring(0, 43), 45) + rightText;
  }

  var frameText = 'Frame     : ' + (frameItem ? frameItem.nama_barang||'-' : '-');
  lines.push(makeRow(frameText, 'No.           : ' + no));

  var rResep = [d.sph_r?'SPH: '+d.sph_r:'', d.cyl_r?'CYL: '+d.cyl_r:'', d.add_r?'ADD: '+d.add_r:''].filter(Boolean).join(' ');
  var lensaRText = 'Lensa (R) : ' + (lensaRItem ? lensaRItem.nama_barang||'-' : '-') + (rResep ? ' (' + rResep + ')' : '');
  lines.push(makeRow(lensaRText, 'Sales         : ' + sales));

  var lResep = [d.sph_l?'SPH: '+d.sph_l:'', d.cyl_l?'CYL: '+d.cyl_l:'', d.add_l?'ADD: '+d.add_l:''].filter(Boolean).join(' ');
  var lensaLText = 'Lensa (L) : ' + (lensaLItem ? lensaLItem.nama_barang||'-' : '-') + (lResep ? ' (' + lResep + ')' : '');
  lines.push(makeRow(lensaLText, 'Tgl. Selesai  : ' + tglSelesai));

  lines.push('');

  var rSphStr = d.sph_r ? d.sph_r : '      ';
  var rCylStr = d.cyl_r ? d.cyl_r : '      ';
  var rAddStr = d.add_r ? d.add_r : '      ';
  var lSphStr = d.sph_l ? d.sph_l : '      ';
  var lCylStr = d.cyl_l ? d.cyl_l : '      ';
  var lAddStr = d.add_l ? d.add_l : '      ';

  if (d.sph_r || d.add_r || d.cyl_r || d.sph_l || d.add_l || d.cyl_l) {
    lines.push('SPHR: ' + padRight(rSphStr, 10) + ' CYLR: ' + padRight(rCylStr, 10) + ' ADDR: ' + rAddStr);
    lines.push('SPHL: ' + padRight(lSphStr, 10) + ' CYLL: ' + padRight(lCylStr, 10) + ' ADDL: ' + lAddStr);
    lines.push('');
  }

  var strDisetujui = 'Disetujui,';
  lines.push(padRight('', 80 - strDisetujui.length) + strDisetujui);
  lines.push('');
  lines.push('');
  var strTtd = '(...........)';
  lines.push(padRight('', 80 - strTtd.length) + strTtd);
  lines.push('');
  lines.push('SYARAT DAN KETENTUAN');
  lines.push('* KACAMATA YANG TIDAK DIAMBIL DALAM JANGKA WAKTU 2 BULAN MAKA UANG MUKA');
  lines.push('  AKAN DINYATAKAN HANGUS DAN DILUAR RESIKO KAMI');

  var w = window.open('','_blank','width=800,height=600');
  w.document.write('<html><head><title>Nota Continuous Form</title><style>@page { size: portrait; margin: 0; } body { font-family: monospace; font-size: 13px; white-space: pre; margin: 10mm; line-height: 1.2; transform: scale(0.75); transform-origin: top left; width: 133.33%; }</style></head><body>' + lines.join('\n') + '</body></html>');
  w.document.close();
  w.onload = function() { w.print(); };
}

// Print barcode labels — shared by pembelian & barang
// items: [{ barcode_id, nama_barang, harga_jual, jumlah }]
// format: 'double' (both halves filled) | 'single' (right half blank)
function printBarcodesFromItems(items, format) {
  format = format || 'double';
  var labels = '';
  items.forEach(function (item) {
    var priceStr = '- Rp ' + Number(item.harga_jual || 0).toLocaleString('id-ID');
    var halfHtml =
      '<div class="half">' +
      '<div class="name">' + escapeHtml(item.nama_barang || '-') + '</div>' +
      '<div class="bc-wrapper"><svg class="bc" data-code="' + escapeHtml(item.barcode_id) + '"></svg></div>' +
      '<div class="bottom-info">' +
      '<span>' + escapeHtml(item.barcode_id) + '</span>' +
      '<span>' + priceStr + '</span>' +
      '</div>' +
      '</div>';
    for (var q = 0; q < (item.jumlah || 1); q++) {
      labels += '<div class="label">';
      labels += halfHtml;
      labels += (format === 'double') ? halfHtml : '<div class="half"></div>';
      labels += '</div>';
    }
  });
  var w = window.open('', '_blank', 'width=600,height=400');
  var html = [
    '<!DOCTYPE html>',
    '<html><head><title>Barcode</title>',
    '<script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.6/dist/JsBarcode.all.min.js"><\/script>',
    '<style>',
    '@page { size: 73mm 19mm; margin: 0; }',
    '* { margin: 0; padding: 0; box-sizing: border-box; }',
    'body { background: #fff; color: #000; font-family: Arial, sans-serif; margin: 0;  margin-top: -2.5px; }',
    '.label { width: 100%; height: 100vh; display: flex; page-break-after: always; }',
    '.half { width: 48%; height: 100%; display: flex; flex-direction: column; justify-content: flex-start; padding: 0.5mm 2mm; overflow: hidden; }',
    '.label .half:first-child { margin-right: 4%; }',
    '.name { font-size: 6pt; font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-transform: uppercase; text-align: left; margin-bottom: 0.5mm; }',
    '.bc-wrapper { display: flex; justify-content: center; align-items: center; overflow: hidden; height: 2mm; width: 30%; margin: 0 auto; }',
    'svg { display: block; max-height: 100%; }',
    '.bottom-info { display: flex; justify-content: space-between; font-size: 5pt; font-weight: normal; margin-top: 0.5mm; }',
    '</style></head><body>',
    labels,
    '<script>',
    'document.querySelectorAll(".bc").forEach(function(el) {',
    '  JsBarcode(el, el.dataset.code, { format: "CODE128", width: 1, height: 30, displayValue: false, margin: 0 });',
    '  var w = parseFloat(el.getAttribute("width")), h = parseFloat(el.getAttribute("height"));',
    '  if (w && h) { el.setAttribute("viewBox", "0 0 " + w + " " + h); el.removeAttribute("width"); el.removeAttribute("height"); el.setAttribute("preserveAspectRatio", "none"); el.style.width = "100%"; el.style.height = "100%"; }',
    '});',
    'window.onload = function() { setTimeout(function(){ window.print(); }, 500); };',
    '<\/script></body></html>'
  ].join('\n');
  w.document.write(html);
  w.document.close();
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
