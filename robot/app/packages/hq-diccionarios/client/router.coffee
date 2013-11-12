Router.map ->
  @route 'diccionarioCreate',
    path: '/diccionario/nuevo'
    template: 'diccionarioEdit'
    waitOn: ->
      Subscriptions.begin 'tags'
    after: ->
      Session.set 'diccionarioId', undefined

  @route 'diccionarioEdit',
    path: '/diccionario/:_id/editar'
    waitOn: ->
      [
        Subscriptions.begin 'diccionario', @params._id
        Subscriptions.begin 'tags'
      ]
    after: ->
      Session.set 'diccionarioId', @params._id

  @route 'diccionarioList',
    path: '/diccionario/listar'
    waitOn: ->
      Subscriptions.begin 'diccionarios'
