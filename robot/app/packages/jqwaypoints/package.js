Package.describe({
  summary: 'jQuery Waypoints'
});

Package.on_use(function (api) {
  api.use(['coffeescript','stylus'], 'client');
  api.add_files([
    'client/waypoints.coffee',
    'client/shortcuts/waypoints-sticky.coffee',
    'client/waypoints.styl'
  ], 'client');
});
