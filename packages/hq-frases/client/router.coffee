Router.map ->
  @route 'conjuntoFrasesCreate',
    path: '/conjunto-frases/nuevo'
    template: 'conjuntoFrasesEdit'
    onAfterRun: ->
      Session.set 'conjuntoFrasesId', undefined
    waitOn: ->
      Subscriptions.begin 'diccionariosAutocomplete'

  @route 'conjuntoFrasesEdit',
    path: '/conjunto-frases/:id/editar'
    waitOn: ->
      [
        Subscriptions.begin 'conjuntoFrases', @params.id
        Subscriptions.begin 'diccionariosAutocomplete'
      ]
    onAfterRun: ->
      Session.set 'conjuntoFrasesId', @params.id

  @route 'conjuntoFrasesList',
    path: '/conjunto-frases/listar'
    waitOn: ->
      Subscriptions.begin 'conjuntosFrases'
