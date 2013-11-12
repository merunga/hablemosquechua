Template.conjuntoFrasesList.helpers
  conjuntosFrases: ->
    if ConjuntosFrases.find().count()
      ConjuntosFrases.find()
    else false
  diccionarios: ->
    AggregationConjuntoFrases.findOne( conjuntoId: @_id )?.diccionarios
  countFrases: ->
    AggregationConjuntoFrases.findOne( conjuntoId: @_id )?.countFrases
  countFrasesTotal: ->
    _( AggregationConjuntoFrases.find().fetch() ).reduce (count, v) ->
      count + ( v?.countFrases or 0 )
    , 0

Template.conjuntoFrasesList.events Utils.defaultEvents
Template.conjuntoFrasesList.events
  'click .acciones > .eliminar': (e) ->
    e.preventDefault()
    self = @
    bootbox.confirm 'Estás segur@ de que quieres eliminar este conjunto de frases?', (result) ->
      if result
        ConjuntosFrases.remove {_id: self._id}, (err, result2) ->
          if err
            console.log err