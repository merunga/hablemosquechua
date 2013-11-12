Package.describe({
  summary: 'stream para @hablemosquechua'
});

Npm.depends({'twit':'1.1.11'})

Package.on_use(function (api) {
  api.use(['standard-app-packages','coffeescript',
    'collection2','iron-router','pince']);
  api.use(['bootstrap','stylus','utils'],'client');

  api.add_files([
    'lib/logger.js'
  ])

  // api.add_files('client/router.coffee', 'client');
  // api.add_files([
  //   'client/views/programar.html',
  //   'client/views/programar.coffee',
  //   'client/views/calendar.html',
  //   'client/views/calendar.coffee'
  // ], 'client');
  
  api.add_files([
    'server/startup.coffee'
  ], 'server');

  // api.export('HablemosQuechua');
  // api.export('Tweets');
});
