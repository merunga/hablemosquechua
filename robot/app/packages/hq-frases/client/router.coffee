Router.map ->
  @route 'conjuntoFrasesCreate',
    path: '/conjunto-frases/nuevo'
    template: 'conjuntoFrasesEdit'
    after: ->
      Session.set 'conjuntoFrasesId', undefined
    waitOn: ->
      [
        Subscriptions.begin 'diccionariosAutocomplete'
        Subscriptions.begin 'tags'
      ]

  @route 'conjuntoFrasesEdit',
    path: '/conjunto-frases/:_id/editar'
    waitOn: ->
      [
        Subscriptions.begin 'conjuntoFrases', @params._id
        Subscriptions.begin 'diccionariosAutocomplete'
        Subscriptions.begin 'tags'
      ]
    after: ->
      Session.set 'conjuntoFrasesId', @params._id

  @route 'conjuntoFrasesList',
    path: '/conjunto-frases/listar'
    waitOn: ->
      Subscriptions.begin 'conjuntosFrases'
