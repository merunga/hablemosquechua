Meteor.publish 'diccionario', (id) ->
  [
    Diccionarios.find(_id: id),
    PalabrasDiccionario.find diccionarioId: id
  ]

Meteor.publish 'diccionarios', ->
  [
    Diccionarios.find( { userId: @userId }, { sort: { createdAt: -1 } } ),
    AggregationDiccionario.find userId: @userId
  ]

Meteor.publish 'diccionariosAutocomplete', ->
  Diccionarios.find userId: @userId,
    sort: { nombre: 1 }
    fields: { nombre: 1 }
