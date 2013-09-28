Router.map ->
  @route 'diccionarioCreate',
    path: '/diccionario/nuevo'
    template: 'diccionarioEdit'

  @route 'diccionarioEdit',
    path: '/diccionario/:id/editar'
    waitOn: ->
      Subscriptions.begin 'diccionario', @params.id
    onAfterRun: ->
      Session.set 'diccionarioId', @params.id

  @route 'diccionarioList',
    path: '/diccionario/listar'
