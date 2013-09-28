Meteor.publish 'diccionario', (id) ->
  [
    Diccionarios.find(_id: id),
    PalabrasDiccionario.find diccionarioId: id
  ]
