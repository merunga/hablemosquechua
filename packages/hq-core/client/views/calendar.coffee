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
    entry.id = t._id
    entry.allDay = false
    entry.start = time.toDate()
    entry.end = time.toDate()
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
