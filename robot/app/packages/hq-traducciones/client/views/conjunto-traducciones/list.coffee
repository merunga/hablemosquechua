Template.conjuntoTraduccionesList.helpers
  conjuntosTraducciones: ->
    if ConjuntosTraducciones.find().count()
      ConjuntosTraducciones.find()
    else false
  diccionarios: ->
    AggregationConjuntoTraducciones.findOne( conjuntoId: @_id )?.diccionarios
  countTraducciones: ->
    AggregationConjuntoTraducciones.findOne( conjuntoId: @_id )?.countTraducciones
  countTraduccionesTotal: ->
    _( AggregationConjuntoTraducciones.find().fetch() ).reduce (count, v) ->
      count + ( v?.countTraducciones or 0 )
    , 0

Template.conjuntoTraduccionesList.events Utils.defaultEvents
Template.conjuntoTraduccionesList.events
  'click .acciones > .eliminar': (e) ->
    e.preventDefault()
    self = @
    bootbox.confirm 'Estás segur@ de que quieres eliminar este conjunto de traducciones?', (result) ->
      if result
        ConjuntosTraducciones.remove {_id: self._id}, (err, result2) ->
          if err
            logger.error err