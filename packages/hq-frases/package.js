Package.describe({
  summary: 'frases para @hablemosquechua'
});

Package.on_use(function (api) {
  api.use(['standard-app-packages','coffeescript','iron-router',
    'collection-hooks','hq-diccionarios']);
  api.use(['bootstrap','stylus','utils','tokenfield'],'client');
  api.use('hq-tags',['client','server'],{unordered:true})

  api.add_files([
    'lib/models.coffee'
  ], ['client','server'])

  api.add_files([
    'server/models.coffee',
    'server/publish.coffee',
    'server/observe.coffee'
  ], 'server')

  api.add_files([
    'client/frases.styl',
    'client/router.coffee',
    'client/views/conjunto-frases/edit.html',
    'client/views/conjunto-frases/edit.coffee',
    'client/views/conjunto-frases/list.html',
    'client/views/conjunto-frases/list.coffee'
  ], 'client');

  api.export([
    'ConjuntosFrases',
    'Frases',
    'AggregationConjuntoFrases',
  ], ['client', 'server'])
});
