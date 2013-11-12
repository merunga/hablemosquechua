Template.conjuntoPreguntasList.helpers
  conjuntosPreguntas: ->
    if ConjuntosPreguntas.find().count()
      ConjuntosPreguntas.find()
    else false
  diccionarios: ->
    AggregationConjuntoPreguntas.findOne( conjuntoId: @_id )?.diccionarios
  countPreguntas: ->
    AggregationConjuntoPreguntas.findOne( conjuntoId: @_id )?.countPreguntas
  countPreguntasTotal: ->
    _( AggregationConjuntoPreguntas.find().fetch() ).reduce (count, v) ->
      count + ( v?.countPreguntas or 0 )
    , 0

Template.conjuntoPreguntasList.events Utils.defaultEvents
Template.conjuntoPreguntasList.events
  'click .acciones > .eliminar': (e) ->
    e.preventDefault()
    self = @
    bootbox.confirm 'Estás segur@ de que quieres eliminar este conjunto de preguntas?', (result) ->
      if result
        ConjuntosPreguntas.remove {_id: self._id}, (err, result2) ->
          if err
            logger.error err