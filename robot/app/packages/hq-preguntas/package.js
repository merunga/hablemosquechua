Package.describe({
  summary: 'preguntas para @hablemosquechua'
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
    'server/models.coffee',
    'server/publish.coffee',
    'server/observe.coffee'
  ], 'server')

  api.add_files([
    'client/preguntas.styl',
    'client/router.coffee',
    'client/views/conjunto-preguntas/edit.html',
    'client/views/conjunto-preguntas/edit.coffee',
    'client/views/conjunto-preguntas/list.html',
    'client/views/conjunto-preguntas/list.coffee'
  ], 'client');

  api.export([
    'ConjuntosPreguntas',
    'Preguntas',
    'AggregationConjuntoPreguntas',
  ], ['client', 'server'])
});
