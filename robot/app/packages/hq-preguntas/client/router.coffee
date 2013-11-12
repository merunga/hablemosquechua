Router.map ->
  @route 'conjuntoPreguntasCreate',
    path: '/conjunto-preguntas/nuevo'
    template: 'conjuntoPreguntasEdit'
    after: ->
      Session.set 'conjuntoPreguntasId', undefined
    waitOn: ->
      [
        Subscriptions.begin 'diccionariosAutocomplete'
        Subscriptions.begin 'tags'
      ]

  @route 'conjuntoPreguntasEdit',
    path: '/conjunto-preguntas/:_id/editar'
    waitOn: ->
      [
        Subscriptions.begin 'conjuntoPreguntas', @params._id
        Subscriptions.begin 'diccionariosAutocomplete'
        Subscriptions.begin 'tags'
      ]
    after: ->
      Session.set 'conjuntoPreguntasId', @params._id

  @route 'conjuntoPreguntasList',
    path: '/conjunto-preguntas/listar'
    waitOn: ->
      Subscriptions.begin 'conjuntosPreguntas'
