Package.describe({
  summary: 'followers para @hablemosquechua'
});

Npm.depends({'twit':'1.1.11'})

Package.on_use(function (api) {
  api.use(['standard-app-packages','coffeescript',
    'collection2','collection-hooks','iron-router','pince']);
  api.use(['bootstrap','stylus','utils'],'client');

  api.add_files([
    'lib/logger.js',
    'lib/models.coffee'
  ])

  // api.add_files('client/router.coffee', 'client');
  // api.add_files([
  //   'client/views/programar.html',
  //   'client/views/programar.coffee',
  //   'client/views/calendar.html',
  //   'client/views/calendar.coffee'
  // ], 'client');
  
  api.add_files([
    'server/models.coffee',
    'server/observe.coffee'
  ], 'server');

  api.export([
    'Mentions','Followers'
  ]);
});
