Meteor.publish 'conjuntoPreguntas', (id) ->
  [
    ConjuntosPreguntas.find( _id: id ),
    Preguntas.find conjuntoId: id
  ]

Meteor.publish 'conjuntosPreguntas', ->
  [
    ConjuntosPreguntas.find( { userId: @userId }, { sort: { createdAt: -1 } } ),
    AggregationConjuntoPreguntas.find userId: @userId
  ]
