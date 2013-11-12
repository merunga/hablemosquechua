Diccionarios = new Meteor.Collection2 'diccionarios',
  schema:
    userId:
      type: String
      optional: true # Nos es opcional, pero coll2 no funciona con hooks
    nombre:
      type: String
    variables:
      type: [String]
    tags:
      type: [String]
      optional: true

PalabrasDiccionario = new Meteor.Collection 'palabrasDiccionario'

AggregationDiccionario = new Meteor.Collection2 'aggregationDiccionario',
  schema:
    diccionarioId:
      type: String
      unique: true
    userId:
      type: String
    countPalabras:
      type: Number
