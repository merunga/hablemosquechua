Template.scheduleList.helpers
  schedules: ->
    if Schedules.find().count()
      Schedules.find()
    else false
  conjuntosFrases: ->
    AggregationSchedule.findOne( scheduleId: @_id )?.conjuntosFrases
  conjuntosPreguntas: ->
    AggregationSchedule.findOne( scheduleId: @_id )?.conjuntosPreguntas
  countEntradas: ->
    AggregationSchedule.findOne( scheduleId: @_id )?.countEntradas
  countEntradasTotal: ->
    _( AggregationSchedule.find().fetch() ).reduce (count, v) ->
      count + ( v?.countEntradas or 0 )
    , 0

Template.scheduleList.events Utils.defaultEvents
Template.scheduleList.events
  'click .acciones > .eliminar': (e) ->
    e.preventDefault()
    self = @
    bootbox.confirm 'Estás segur@ de que quieres eliminar este schedule?', (result) ->
      if result
        Schedules.remove {_id: self._id}, (err, result2) ->
          if err
            logger.error err