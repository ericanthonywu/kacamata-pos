window.userRole = '<%= currentUser.hak_akses %>';
var table;
$(function () {
  var expCols = window.userRole === 'admin' ? [0, 1, 2, 3, 4] : [0, 1, 2, 3];
  function newExportAction(e, dt, button, config) {
    var self = this;
    var oldStart = dt.settings()[0]._iDisplayStart;
    dt.one('preXhr', function (e, s, data) {
      data.start = 0;
      data.length = -1;
      dt.one('preDraw', function (e, settings) {
        if (button[0].className.indexOf('buttons-excel') >= 0) {
          $.fn.dataTable.ext.buttons.excelHtml5.available(dt, config) ?
            $.fn.dataTable.ext.buttons.excelHtml5.action.call(self, e, dt, button, config) : null;
        } else if (button[0].className.indexOf('buttons-csv') >= 0) {
          $.fn.dataTable.ext.buttons.csvHtml5.available(dt, config) ?
            $.fn.dataTable.ext.buttons.csvHtml5.action.call(self, e, dt, button, config) : null;
        }
        dt.one('preXhr', function (e, s, data) {
          settings._iDisplayStart = oldStart;
          data.start = oldStart;
        });
        setTimeout(dt.ajax.reload, 0);
        return false;
      });
    });
    dt.ajax.reload();
  }

  table = $('#tblPembelian').DataTable({
    serverSide: true,
    processing: true,
    ajax: {
      url: '/pembelian/dt',
      data: function (d) {
        d.start_date = $('#filterStartDate').val();
        d.end_date = $('#filterEndDate').val();
      }
    },
    order: [[1, 'desc']],
    lengthMenu: [[10, 50, 100, -1], [10, 50, 100, "All"]],
    layout: {
      topStart: {
        pageLength: {},
        buttons: {}
      },
      topEnd: 'search',
      bottomStart: 'info',
      bottomEnd: 'paging'
    },
    buttons: [
      {
        extend: 'excelHtml5',
        text: '<i class="bi bi-file-earmark-excel"></i> Excel',
        className: 'btn btn-success btn-sm',
        action: newExportAction,
        exportOptions: { columns: expCols, orthogonal: 'export' }
      },
      {
        extend: 'csvHtml5',
        text: '<i class="bi bi-filetype-csv"></i> CSV',
        className: 'btn btn-info btn-sm',
        action: newExportAction,
        exportOptions: { columns: expCols, orthogonal: 'export' }
      },
      {
        extend: 'print',
        text: '<i class="bi bi-printer"></i> Print',
        className: 'btn btn-secondary btn-sm',
        exportOptions: { columns: expCols, orthogonal: 'export' }
      }
    ],
    columns: [
      {
        data: 'kode_pembelian',
        render: function (data) { return '<span class="font-monospace text-info">' + escapeHtml(data) + '</span>'; }
      },
      {
        data: 'tanggal_pembelian',
        render: function (data) { return data ? new Date(data).toLocaleDateString('id-ID') : '-'; }
      },
      {
        data: 'supplier_nama',
        render: function (data) { return escapeHtml(data || '-'); }
      },
      <% if(currentUser.hak_akses === 'admin') { %>
  {
    data: 'total_harga',
    className: 'fw-bold',
    render: function (data) { return fmtRp(data); }
  },
      <% } %>
  {
    data: 'status_bayar',
    render: function (data, type, row) {
      if (type !== 'display') {
        return data === 'lunas' ? 'Lunas' : 'Belum Lunas';
      }
      if (data === 'lunas') return '<span class="badge bg-success">✅ Lunas</span>';
      return '<a href="/pembayaran-pembelian/bayar/' + row.id + '" class="badge bg-danger text-decoration-none">❌ Belum Lunas</a>';
    }
  },
  {
    data: null,
    orderable: false,
    render: function (data, type, row) {
      var html = '<div class="d-flex flex-wrap gap-1">';
      if (window.userRole === 'admin') {
        html += '<button class="btn btn-sm btn-outline-info" onclick="showDetail(' + row.id + ')"><i class="bi bi-eye"></i></button>';
      }
      html += '<div class="dropdown d-inline-block"><button class="btn btn-sm btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" title="Print Barcode"><i class="bi bi-upc-scan"></i></button>';
      html += '<ul class="dropdown-menu shadow-sm"><li><h6 class="dropdown-header">Pilih Format Label</h6></li>';
      html += '<li><a class="dropdown-item" href="#" onclick="event.preventDefault(); printBarcodes(' + row.id + ', &quot;double&quot;)"><i class="bi bi-layout-split"></i> Double (Kiri & Kanan)</a></li>';
      html += '<li><a class="dropdown-item" href="#" onclick="event.preventDefault(); printBarcodes(' + row.id + ', &quot;single&quot;)"><i class="bi bi-layout-sidebar"></i> Single (Kiri saja)</a></li></ul></div>';
      if (window.userRole === 'admin') {
        if (row.status_bayar !== 'lunas') {
          html += '<a href="/pembayaran-pembelian/bayar/' + row.id + '" class="btn btn-sm btn-outline-success" title="Bayar"><i class="bi bi-wallet2"></i></a>';
        }
        html += '<a href="/pembelian-retur/baru?pembelian_id=' + row.id + '" class="btn btn-sm btn-outline-warning" title="Retur"><i class="bi bi-arrow-return-left"></i></a>';
      }
      html += '</div>';
      return html;
    }
  }
    ],
  language: dtLanguageID
});
});

function reloadTable() {
  table.ajax.reload();
}

function resetFilter() {
  $('#filterStartDate').val('');
  $('#filterEndDate').val('');
  table.ajax.reload();
}

function showDetail(id) {
  $.get('/pembelian/' + id, function (res) {
    if (!res.success) return;
    var d = res.data;
    var html = '<table class="table table-sm mb-0">';
    html += '<tr><td class="text-muted">Kode</td><td class="font-monospace">' + d.kode_pembelian + '</td></tr>';
    html += '<tr><td class="text-muted">Tanggal</td><td>' + new Date(d.tanggal_pembelian).toLocaleDateString('id-ID') + '</td></tr>';
    html += '<tr><td class="text-muted">Supplier</td><td>' + (d.supplier_nama || '-') + '</td></tr>';
    html += '</table>';
    if (d.detail && d.detail.length > 0) {
      html += '<hr><h6 class="small fw-bold">Item Pembelian</h6>';
      html += '<table class="table table-sm mb-0"><thead><tr><th>Barang</th><th>Qty</th><th>Harga Beli</th><th>Subtotal</th></tr></thead><tbody>';
      d.detail.forEach(function (item) {
        var sub = (item.harga_beli || 0) * (item.jumlah || 1);
        html += '<tr><td>' + (item.nama_barang || '-') + '</td><td>' + item.jumlah + '</td><td>' + fmtRp(item.harga_beli) + '</td><td>' + fmtRp(sub) + '</td></tr>';
      });
      html += '</tbody></table>';
    }
    html += '<hr><div class="d-flex justify-content-between"><strong>Total</strong><strong class="text-success">' + fmtRp(d.total_harga) + '</strong></div>';
    $('#detailBody').html(html);
    new bootstrap.Modal('#detailModal').show();
  });
}

function printBarcodes(id, format) {
  format = format || 'double';
  $.get('/pembelian/' + id, function (res) {
    if (!res.success || !res.data.detail) return;
    var items = res.data.detail.filter(function (i) { return i.barcode_id; });
    if (items.length === 0) { showToast('Tidak ada item dengan barcode', 'warning'); return; }
    var w = window.open('', '_blank', 'width=600,height=400');
    var labels = '';
    items.forEach(function (item) {
      var priceStr = '- Rp ' + Number(item.harga_jual || 0).toLocaleString('id-ID');
      for (var q = 0; q < item.jumlah; q++) {
        var halfHtml =
          '  <div class="half">' +
          '    <div class="name">' + (item.nama_barang || '-') + '</div>' +
          '    <div class="bc-wrapper"><svg class="bc" data-code="' + item.barcode_id + '"></svg></div>' +
          '    <div class="bottom-info">' +
          '      <span>' + item.barcode_id + '</span>' +
          '      <span>' + priceStr + '</span>' +
          '    </div>' +
          '  </div>';

        labels += '<div class="label">';
        labels += halfHtml; // Kiri
        if (format === 'double') {
          labels += halfHtml; // Kanan (sama)
        } else {
          labels += '<div class="half"></div>'; // Kanan (kosong)
        }
        labels += '</div>';
      }
    });
    var html = [
      '<!DOCTYPE html>',
      '<html><head><title>Barcode Pembelian</title>',
      '<script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.6/dist/JsBarcode.all.min.js"><\/script>',
      '<style>',
      '@page { size: 35mm 15mm; margin: 0; }',
      '* { margin: 0; padding: 0; box-sizing: border-box; }',
      'body { background: #fff; color: #000; font-family: Arial, sans-serif; overflow: hidden; }',
      '.label { width: 35mm; height: 15mm; display: flex; page-break-after: always; overflow: hidden; }',
      '.half { width: 50%; height: 100%; display: flex; flex-direction: column; justify-content: center; padding: 0.3mm 0.5mm; }',
      '.name { font-size: 6pt; font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-transform: uppercase; margin-bottom: 0.3mm; text-align: center; }',
      '.bc-wrapper { display: flex; justify-content: center; align-items: center; margin-bottom: 0.3mm; }',
      'svg { display: block; width: 100%; }',
      '.bottom-info { display: flex; justify-content: space-between; font-size: 5pt; font-weight: normal; }',
      '</style></head><body>',
      labels,
      '<script>',
      'document.querySelectorAll(".bc").forEach(function(el) {',
      '  JsBarcode(el, el.dataset.code, { format: "CODE128", width: 1.2, height: 28, displayValue: false, margin: 0 });',
      '});',
      'window.onload = function() { setTimeout(function(){ window.print(); }, 500); };',
      '<\/script></body></html>'
    ].join('\n');
    w.document.write(html);
    w.document.close();
  });
}
</script >

<% - include('../partials/bottom') %>
