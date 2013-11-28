ConjuntosTraducciones = new Meteor.Collection2 'conjuntosTraducciones',
  schema:
    userId:
      type: String
      optional: true # Nos es opcional, pero coll2 no funciona con hooks
    nombre:
      type: String
    diccionarioIds:
      type: [String]
    tags:
      type: [String]
      optional: true

Traducciones = new Meteor.Collection2 'traducciones',
  schema:
    userId:
      type: String
      optional: true # Nos es opcional, pero coll2 no funciona con hooks
    conjuntoId:
      type: String
    pregunta:
      type: String
    respuesta:
      type: String

AggregationConjuntoTraducciones = new Meteor.Collection2 'aggregationConjutoTraducciones',
  schema:
    conjuntoId:
      type: String
      unique: true
    userId:
      type: String
    countTraducciones:
      type: Number
    diccionarios:
      type: [String]

TraduccionesSolicitadas = new Meteor.Collection2 'traduccionesSolicitadas',
  schema:
    userId:
      type: String
      optional: true # Nos es opcional, pero coll2 no funciona con hooks
    tweetRespuestaId:
      type: String
      optional: true
    mentionId:
      type: String
