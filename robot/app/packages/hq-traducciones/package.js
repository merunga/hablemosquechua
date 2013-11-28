Package.describe({
  summary: 'traducciones solicitadas por los usuarios a @hablemosquechua'
});

Package.on_use(function (api) {
  api.use(['standard-app-packages','coffeescript','iron-router',
    'collection-hooks','hq-diccionarios','pince']);
  api.use(['bootstrap','stylus','utils','tokenfield'],'client');
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
    'client/traducciones.styl',
    'client/router.coffee',
    'client/views/conjunto-traducciones/edit.html',
    'client/views/conjunto-traducciones/edit.coffee',
    'client/views/conjunto-traducciones/list.html',
    'client/views/conjunto-traducciones/list.coffee'
  ], 'client');

  api.export([
    'ConjuntosTraducciones',
    'Traducciones',
    'AggregationConjuntoTraducciones',
    'TraduccionesSolicitadas',
    'TraduccionesService'
  ], ['client', 'server'])
});
