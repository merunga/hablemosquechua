Package.describe({
  summary: 'core de @hablemosquechua'
});

Npm.depends({'twit':'1.1.11'})

Package.on_use(function (api) {
  api.use(['standard-app-packages','coffeescript',
    'collection2','iron-router','hq-cron','cron-tick','pince']);
  api.use(['bootstrap','stylus','utils'],'client');

  api.add_files([
    'client/stylesheets/calendar.styl',
    'client/stylesheets/fullcalendar.css',
    'client/stylesheets/fullcalendar.print.css',
    'client/stylesheets/jquery-ui-1.10.3.custom.css'
  ], 'client');

  api.add_files('client/compatibility/fullcalendar.js',
    'client', {bare: true});
  api.add_files('client/compatibility/jquery-ui-1.10.3.custom.js',
    'client', {bare: true});


  api.add_files([
    'lib/logger.js',
    'lib/models.coffee'
  ])

  api.add_files('client/router.coffee', 'client');
  api.add_files([
    'client/views/programar.html',
    'client/views/programar.coffee',
    'client/views/calendar.html',
    'client/views/calendar.coffee',
    'client/core.styl',
  ], 'client');
  
  api.add_files([
    'server/startup.coffee',
    'server/models.coffee',
    'server/service.coffee',
    'server/methods.coffee',
    'server/publish.coffee'
  ], 'server');

  api.export('HablemosQuechua');
  api.export('Tweets');
});
