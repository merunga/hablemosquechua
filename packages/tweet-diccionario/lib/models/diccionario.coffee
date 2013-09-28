Diccionarios = new Meteor.Collection2 'diccionarios',
  schema:
    userId:
      type: String
      optional: true # Nos es opcional, pero coll2 no funcion con hooks
    nombre:
      type: String
    variables:
      type: Array
    palabras:
      type: Array
      optional: true
