Notificaciones = new Meteor.Collection 'notificaciones'
  
Notificaciones.allow
  remove: -> false
  insert: -> true
  update: -> false