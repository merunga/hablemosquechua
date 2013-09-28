Package.describe({
  summary: 'Tokenfield'
});

Package.on_use(function (api) {
  api.use(['coffeescript','jquery','bootstrap'],'client');

  api.add_files([
  	'bootstrap-tokenfield.css',
    'bootstrap-tokenfield.js',
    'tokenfield.coffee'
  ], 'client');

  api.export('Tokenfield')
});
