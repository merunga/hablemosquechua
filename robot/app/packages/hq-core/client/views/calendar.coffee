Meteor.startup ->
  Session.set "calendarioTemplateRendered", false

Deps.autorun ->
  return if Session.equals("calendarioTemplateRendered", false) \
    or not Subscriptions['tweets']?.ready()

  entries = []
  Tweets.find().fetch().forEach (t) ->
    time = moment t.fechaHora
    time.local()
    entry =
      title: t.tweet
      id: t._id
      allDay: false
      start: time.toDate()
      end: time.toDate()
    className = (t) ->
      if t.status is Tweets.STATUS.SUCCESS
        return 'tweeted'
      else if t.status is Tweets.STATUS.ERROR
        return 'tweet-error'
      else if t.fechaHora < new Date()
        return 'tweet-viejo'
      else
        return 'tweet-to-be'
    entry.className = className t
    entries.push entry

  defaultView = 'agendaDay'

  $calendario = $("#calendario")
  $calendario.html("").fullCalendar
    firstDay: 1
    defaultView: Session.get( 'calendarView' ) or defaultView
    header:
      left: "prev,next today"
      center: "title"
      right: "month,agendaWeek,agendaDay"

    editable: false
    events: entries

    eventClick: (calEvent, jsEvent, view) ->
      return false
      
  steps = window.calendarSteps
  if steps and not window.calendarUpdatingSteps
    if steps < 0
      steps = steps*-1
      dir = 'prev'
    else
      dir = 'next'
    for i in [1..steps]
      window.calendarUpdatingSteps = true
      $calendario.fullCalendar(dir)
  window.calendarSteps = steps
  window.calendarUpdatingSteps = false

Template.calendario.rendered = ->
  Session.set "calendarioTemplateRendered", true

Template.calendario.events
  'click .flushBtn': (e, tmpl) ->
    bootbox.confirm 'Se eliminarán todos los tweets no twiteados '+\
      'a partir de ahora, estás segur@?', (result) ->
        if result
          Meteor.call 'flushTweets', (err, result) ->
            if err
              alert err
              logger.error err
