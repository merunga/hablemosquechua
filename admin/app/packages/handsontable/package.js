Package.describe({
  summary: 'HandsOnTable'
});

Package.on_use(function (api) {
  api.add_files('client/compatibility/jquery.handsontable.full.css', 'client');
  api.add_files('client/compatibility/jquery.handsontable.full.js', 'client');
  api.add_files('client/compatibility/jquery.handsontable.removeRow.css', 'client');
  api.add_files('client/compatibility/jquery.handsontable.removeRow.js', 'client');
});
