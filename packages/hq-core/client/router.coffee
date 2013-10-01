Router.map ->
  @route 'tweetsProgramar',
    path: '/tweets/programar'
    waitOn: ->
      [
        Subscriptions.begin 'schedulesAutocomplete'
        Subscriptions.begin 'tags'
      ]

  @route 'calendarioShow',
    path: '/calendario/ver'
