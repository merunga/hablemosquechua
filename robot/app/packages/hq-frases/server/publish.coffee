Meteor.publish 'conjuntoFrases', (id) ->
  [
    ConjuntosFrases.find( _id: id ),
    Frases.find conjuntoId: id
  ]

Meteor.publish 'conjuntosFrases', ->
  [
    ConjuntosFrases.find( { userId: @userId }, { sort: { createdAt: -1 } } ),
    AggregationConjuntoFrases.find userId: @userId
  ]

Meteor.publish 'conjuntosFrasesAutocomplete', ->
  ConjuntosFrases.find userId: @userId,
    sort: { nombre: 1 }
    fields: { nombre: 1 }

Meteor.publish 'conjuntosPreguntasAutocomplete', ->
  ConjuntosPreguntas.find userId: @userId,
    sort: { nombre: 1 }
    fields: { nombre: 1 }
