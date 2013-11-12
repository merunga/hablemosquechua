Package.describe({
  summary: 'tags para @hablemosquechua'
});

Package.on_use(function (api) {
  api.use(['coffeescript','underscore','collection2']);
  api.use(['templating','handlebars'],'client');
  api.use(
    [ 'utils', 'hq-diccionarios', 'hq-frases', 'hq-cron' ],
    [ 'client', 'server' ]
  )

  api.add_files('lib/models.coffee');
  api.add_files([
    'client/views.html',
    'client/helpers.coffee'
  ], 'client');
  api.add_files([
    'server/models.coffee',
    'server/publish.coffee',
    'server/observe.coffee'
  ], 'server');

  api.export( 'Tags' )
  api.export( 'TagsInput', 'client' )
});
