Package.describe({
  summary: 'diccionarios para @hablemosquechua'
});

Package.on_use(function (api) {
  api.use(['standard-app-packages','coffeescript',
    'iron-router','collection-hooks','pince']);
  api.use(['bootstrap','tokenfield','handsontable',
    'stylus','utils'],'client');
  api.use('hq-tags',['client','server'],{unordered:true})

  api.add_files([
    'lib/logger.js',
    'lib/models.coffee'
  ], ['client','server'])

  api.add_files([
    'lib/service.coffee'
  ], 'server')

  api.add_files([
    'server/models.coffee',
    'server/publish.coffee',
    'server/observe.coffee'
  ], 'server')

  api.add_files([
    'client/diccionarios.styl',
    'client/router.coffee',
    'client/views/diccionario/edit.html',
    'client/views/diccionario/edit.coffee',
    'client/views/diccionario/list.html',
    'client/views/diccionario/list.coffee'
  ], 'client');

  api.export([
    'Diccionarios',
    'PalabrasDiccionario',
    'AggregationDiccionario',
    'DiccionariosService'
  ], ['client', 'server'])
});
