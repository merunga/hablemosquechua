Package.describe({
  summary: 'stream para @hablemosquechua'
});

Npm.depends({'twit':'1.1.11'})

Package.on_use(function (api) {
  api.use(['standard-app-packages','coffeescript',
    'collection2','collection-hooks','iron-router','pince']);
  api.use(['bootstrap','stylus','utils'],'client');

  api.add_files([
    'lib/logger.js',
    'lib/service.coffee'
  ])
  
  api.add_files([
    'server/startup.coffee'
  ], 'server');

  api.export('StreamService');
});
