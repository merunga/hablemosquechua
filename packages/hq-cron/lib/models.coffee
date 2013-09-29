Schedules = new Meteor.Collection2 'schedules',
  schema:
    userId:
      type: String
      optional: true # Nos es opcional, pero coll2 no funciona con hooks
    nombre:
      type: String
    conjuntoFrasesIds:
      type: [String]
      optional: true
    tagsAUsar:
      type: [String]
      optional: true

EntradasSchedule = new Meteor.Collection2 'entradasSchedule',
  schema:
    userId:
      type: String
      optional: true # Nos es opcional, pero coll2 no funciona con hooks
    scheduleId:
      type: String
    diasDeLaSemana:
      type: [Number]
    horas:
      type: [Number]
    minutos:
      type: [Number]

AggregationSchedule = new Meteor.Collection2 'aggregationSchedule',
  schema:
    scheduleId:
      type: String
      unique: true
    userId:
      type: String
    countEntradas:
      type: Number
    conjuntosFrases:
      type: [String]
      optional: true
