ConjuntosPreguntas = new Meteor.Collection2 'conjuntosPreguntas',
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

Preguntas = new Meteor.Collection2 'preguntas',
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

AggregationConjuntoPreguntas = new Meteor.Collection2 'aggregationConjutoPreguntas',
  schema:
    conjuntoId:
      type: String
      unique: true
    userId:
      type: String
    countPreguntas:
      type: Number
    diccionarios:
      type: [String]

RespuestasCorrectas = new Meteor.Collection2 'respuestasCorrectas',
  schema:
    userRespuesta:
      type: String
    fechaHora:
      type: String
    palabraId:
      type: String
    variable:
      type: String
