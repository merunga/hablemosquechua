Router.map ->
  @route 'scheduleCreate',
    path: '/schedule/nuevo'
    template: 'scheduleEdit'
    after: ->
      Session.set 'scheduleId', undefined
    waitOn: ->
      [
        Subscriptions.begin 'conjuntosFrasesAutocomplete'
        Subscriptions.begin 'tags'
      ]

  @route 'scheduleEdit',
    path: '/schedule/:_id/editar'
    waitOn: ->
      [
        Subscriptions.begin 'schedule', @params._id
        Subscriptions.begin 'conjuntosFrasesAutocomplete'
        Subscriptions.begin 'tags'
      ]
    after: ->
      Session.set 'scheduleId', @params._id

  @route 'scheduleList',
    path: '/schedule/listar'
    waitOn: ->
      Subscriptions.begin 'schedules'
