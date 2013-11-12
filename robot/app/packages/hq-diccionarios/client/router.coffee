Router.map ->
  @route 'diccionarioCreate',
    path: '/diccionario/nuevo'
    template: 'diccionarioEdit'
    waitOn: ->
      Subscriptions.begin 'tags'
    onAfterRun: ->
      Session.set 'diccionarioId', undefined

  @route 'diccionarioEdit',
    path: '/diccionario/:id/editar'
    waitOn: ->
      [
        Subscriptions.begin 'diccionario', @params.id
        Subscriptions.begin 'tags'
      ]
    onAfterRun: ->
      Session.set 'diccionarioId', @params.id

  @route 'diccionarioList',
    path: '/diccionario/listar'
    waitOn: ->
      Subscriptions.begin 'diccionarios'
