Package.describe({
  summary: 'Tweets dictionary'
});

Package.on_use(function (api) {
  api.use(['standard-app-packages','coffeescript','iron-router','collection-hooks']);
  api.use(['bootstrap','tokenfield','handsometable'],'client');

  api.add_files([
    'lib/models/diccionario.coffee'
  ], ['client','server'])

  api.add_files([
    'server/models/diccionario.coffee'
  ], 'server')

  api.add_files([
    'client/router.coffee',
    'client/views/diccionario.html',
    'client/views/diccionario.coffee'
  ], 'client');

  api.export('Diccionarios', ['client', 'server'])
});
