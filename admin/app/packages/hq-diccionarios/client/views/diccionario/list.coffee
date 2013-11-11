Template.diccionarioList.helpers
  diccionarios: ->
    if Diccionarios.find().count()
      Diccionarios.find()
    else false
  countPalabras: ->
    AggregationDiccionario.findOne( diccionarioId: @_id )?.countPalabras
  countPalabrasTotal: ->
    _( AggregationDiccionario.find().fetch() ).reduce (count, v) ->
      count + ( v?.countPalabras or 0 )
    , 0

Template.diccionarioList.events Utils.defaultEvents
Template.diccionarioList.events
  'click .acciones > .eliminar': (e) ->
    e.preventDefault()
    self = @
    bootbox.confirm 'Estás segur@ de que quieres eliminar este diccionario?', (result) ->
      if result
        Diccionarios.remove {_id: self._id}, (err, result2) ->
          if err
            alert err