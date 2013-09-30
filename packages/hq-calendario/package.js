Package.describe({
  summary: 'calendario de tuiteo para @hablemosquechua'
});

Package.on_use(function (api) {
  api.use(['standard-app-packages','coffeescript','iron-router','hq-cron']);
  api.use(['bootstrap','stylus','utils'],'client');

  api.add_files('client/router.coffee', 'client');
  
  api.add_files([
    'client/views/programar.html',
    'client/views/programar.coffee',
    'client/views/show.html',
    'client/views/show.coffee'
  ], 'client');
  
  api.add_files('server/methods.coffee', 'server');
});
