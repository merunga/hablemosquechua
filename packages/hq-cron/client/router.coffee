Router.map ->
  @route 'scheduleCreate',
    path: '/schedule/nuevo'
    template: 'scheduleEdit'
    onAfterRun: ->
      Session.set 'scheduleId', undefined
    waitOn: ->
      Subscriptions.begin 'conjuntosFrasesAutocomplete'

  @route 'scheduleEdit',
    path: '/schedule/:id/editar'
    waitOn: ->
      [
        Subscriptions.begin 'schedule', @params.id
        Subscriptions.begin 'conjuntosFrasesAutocomplete'
      ]
    onAfterRun: ->
      Session.set 'scheduleId', @params.id

  @route 'scheduleList',
    path: '/schedule/listar'
    waitOn: ->
      Subscriptions.begin 'schedules'