Package.describe({
  summary: 'diccionario para @hablemosquechua'
});

Package.on_use(function (api) {
  api.use(['standard-app-packages','coffeescript','iron-router','collection-hooks']);
  api.use(['bootstrap','tokenfield','handsontable','stylus','utils'],'client');

  api.add_files([
    'lib/models/diccionario.coffee'
  ], ['client','server'])

  api.add_files([
    'server/models/diccionario.coffee',
    'server/publish.coffee'
  ], 'server')

  api.add_files([
    'client/diccionario.styl',
    'client/router.coffee',
    'client/views/diccionario/edit.html',
    'client/views/diccionario/edit.coffee',
    'client/views/diccionario/list.html',
    'client/views/diccionario/list.coffee'
  ], 'client');

  api.export([
    'Diccionarios',
    'PalabrasDiccionario',
    'AggregationDiccionario'
  ], ['client', 'server'])
});
