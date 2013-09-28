Package.describe({
  summary: 'Handsometable'
});

Package.on_use(function (api) {
  api.add_files('client/lib/jquery.handsontable.full.css', 'client');
  api.add_files('client/lib/jquery.handsontable.full.js', 'client');
});
