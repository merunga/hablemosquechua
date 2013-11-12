Package.describe({
  summary: 'Meteor Utils'
});

// Npm.depends(
//   {mongodb: '1.3.17'}
// );

Package.on_use(function (api) {
  api.use(['coffeescript','standard-app-packages','email']);
  api.use(['http','roles'], ['client', 'server']);
  api.use(['templating'], 'client');

  api.add_files('lib/moment.js', ['client','server']);
  api.add_files('lib/moment.lang.es.js', ['client','server']);
  api.add_files('lib/accounting.js', ['client','server']);
  api.add_files('lib/utils.coffee', ['client','server']);
  api.add_files('lib/underscore.string.js', ['client','server']);
  api.add_files('lib/underscore.inflection.js', ['client','server']);
  api.add_files('lib/inflector.coffee', ['client','server']);
  api.add_files('lib/models.coffee', ['client','server']);
  api.add_files('server/publish-with-relations.coffee', 'server');
  api.add_files('server/methods.coffee', 'server');

  api.add_files('client/styles/jquery-ui-slider-bootstrap.css', 'client');

  api.add_files([
    'client/lib/bootstrap-datetimepicker/bootstrap-datetimepicker.min.css',
    'client/lib/bootstrap-datetimepicker/bootstrap-datetimepicker.min.js'
  ], 'client');

  api.add_files([
    'client/lib/chosen/chosen-sprite.png', 
    'client/lib/chosen/chosen.jquery.js',
    'client/lib/chosen/chosen.css',
    'client/lib/chosen/chosen-sprite@2x.png'
  ], 'client');

  api.add_files('client/widgets/autocomplete.html', 'client');
  api.add_files('client/widgets/autocomplete.coffee', 'client');
  
  api.add_files('client/events.coffee', 'client');
  api.add_files('client/subscriptions.coffee', 'client');
  api.add_files('client/helpers.coffee', 'client');
  api.add_files('client/utils.coffee', 'client');

  api.export('Utils', [ 'client', 'server' ])
  api.export('Subscriptions', 'client')
  api.export('Notificaciones', 'client')
});
