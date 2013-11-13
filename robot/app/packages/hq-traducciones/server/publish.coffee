Meteor.publish 'conjuntoTraducciones', (id) ->
  [
    ConjuntosTraducciones.find( _id: id ),
    Traducciones.find conjuntoId: id
  ]

Meteor.publish 'conjuntosTraducciones', ->
  [
    ConjuntosTraducciones.find( { userId: @userId }, { sort: { createdAt: -1 } } ),
    AggregationConjuntoTraducciones.find userId: @userId
  ]

Meteor.publish 'conjuntosTraduccionesAutocomplete', ->
  ConjuntosTraducciones.find userId: @userId,
    sort: { nombre: 1 }
    fields: { nombre: 1 }
