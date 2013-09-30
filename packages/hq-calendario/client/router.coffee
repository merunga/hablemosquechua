Router.map ->
  @route 'calendarioProgramar',
    path: '/calendario/programar'
    waitOn: ->
      [
        Subscriptions.begin 'schedulesAutocomplete'
        Subscriptions.begin 'tags'
      ]

  @route 'calendarioShow',
    path: '/calendario/ver'
