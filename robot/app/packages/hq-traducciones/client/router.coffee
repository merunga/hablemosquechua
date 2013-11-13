Router.map ->
  @route 'conjuntoTraduccionesCreate',
    path: '/conjunto-traducciones/nuevo'
    template: 'conjuntoTraduccionesEdit'
    after: ->
      Session.set 'conjuntoTraduccionesId', undefined
    waitOn: ->
      [
        Subscriptions.begin 'diccionariosAutocomplete'
        Subscriptions.begin 'tags'
      ]

  @route 'conjuntoTraduccionesEdit',
    path: '/conjunto-traducciones/:_id/editar'
    waitOn: ->
      [
        Subscriptions.begin 'conjuntoTraducciones', @params._id
        Subscriptions.begin 'diccionariosAutocomplete'
        Subscriptions.begin 'tags'
      ]
    after: ->
      Session.set 'conjuntoTraduccionesId', @params._id

  @route 'conjuntoTraduccionesList',
    path: '/conjunto-traducciones/listar'
    waitOn: ->
      Subscriptions.begin 'conjuntosTraducciones'
