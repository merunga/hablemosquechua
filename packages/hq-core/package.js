Package.describe({
  summary: 'core de @hablemosquechua'
});

Package.on_use(function (api) {
  api.use(['standard-app-packages','coffeescript',
    'collection2','iron-router','hq-cron']);
  api.use(['bootstrap','stylus','utils'],'client');


  api.add_files('lib/models.coffee')

  api.add_files('client/router.coffee', 'client');
  api.add_files([
    'client/views/programar.html',
    'client/views/programar.coffee',
    'client/views/show.html',
    'client/views/show.coffee'
  ], 'client');
  
  api.add_files([
    'server/models.coffee',
    'server/service.coffee',
    'server/methods.coffee'
  ], 'server');

  api.export('HablemosQuechua');
  api.export('Tweets');
});
