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
      html += '<ul class="dropdown-menu shadow-sm">';
      html += '<li><h6 class="dropdown-header">Label Lensa</h6></li>';
      html += '<li><a class="dropdown-item" href="#" onclick="event.preventDefault(); printBarcodes(' + row.id + ', &quot;double&quot;)"><i class="bi bi-layout-split me-2"></i>Double (Kiri & Kanan)</a></li>';
      html += '<li><a class="dropdown-item" href="#" onclick="event.preventDefault(); printBarcodes(' + row.id + ', &quot;single&quot;)"><i class="bi bi-layout-sidebar me-2"></i>Single (Kiri saja)</a></li>';
      html += '<li><hr class="dropdown-divider"></li>';
      html += '<li><h6 class="dropdown-header">Label Biasa</h6></li>';
      html += '<li><a class="dropdown-item" href="#" onclick="event.preventDefault(); printBarcodesRegular(' + row.id + ', &quot;normal_double&quot;)"><i class="bi bi-grid me-2"></i>Normal (Kiri & Kanan)</a></li>';
      html += '<li><a class="dropdown-item" href="#" onclick="event.preventDefault(); printBarcodesRegular(' + row.id + ', &quot;normal_single&quot;)"><i class="bi bi-layout-sidebar me-2"></i>Normal (Kiri saja)</a></li>';
      html += '</ul></div>';
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
  $.get('/pembelian/' + id, function (res) {
    if (!res.success || !res.data.detail) return;
    var items = res.data.detail.filter(function (i) { return i.barcode_id; });
    if (items.length === 0) { showToast('Tidak ada item dengan barcode', 'warning'); return; }
    printBarcodesFromItems(items, format);
  });
}

function printBarcodesRegular(id, format) {
  format = format || 'normal_double';
  $.get('/pembelian/' + id, function (res) {
    if (!res.success || !res.data.detail) return;
    var items = res.data.detail.filter(function (i) { return i.barcode_id; });
    if (items.length === 0) { showToast('Tidak ada item dengan barcode', 'warning'); return; }
    printBarcodesNormal(items, format);
  });
}
</script >

<% - include('../partials/bottom') %>
