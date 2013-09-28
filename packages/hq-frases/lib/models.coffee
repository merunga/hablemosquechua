ConjuntosFrases = new Meteor.Collection2 'conjuntosFrases',
  schema:
    userId:
      type: String
      optional: true # Nos es opcional, pero coll2 no funciona con hooks
    nombre:
      type: String
    tags:
      type: [String]
      optional: true

Frases = new Meteor.Collection2 'frases',
  schema:
    userId:
      type: String
      optional: true # Nos es opcional, pero coll2 no funciona con hooks
    conjuntoId:
      type: String
    frase:
      type: String
      optional: true
    rafaga:
      type: [String]
      optional: true

AggregationConjuntoFrases = new Meteor.Collection2 'aggregationConjutoFrases',
  schema:
    conjuntoId:
      type: String
      unique: true
    userId:
      type: String
    countFrases:
      type: Number
