Package.describe({
  summary: 'programador de frases de @hablemosquechua'
});

Package.on_use(function (api) {
  api.use(['standard-app-packages','coffeescript','iron-router',
    'collection-hooks','hq-frases','pince']);
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
    'client/cron.styl',
    'client/router.coffee',
    'client/views/schedule/edit.html',
    'client/views/schedule/edit.coffee',
    'client/views/schedule/list.html',
    'client/views/schedule/list.coffee'
  ], 'client');

  api.export([
    'Schedules',
    'EntradasSchedule',
    'AggregationSchedule',
  ], ['client', 'server'])
});
