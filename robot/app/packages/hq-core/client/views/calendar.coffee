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
      tweetId: t._id
      title: t.tweet
      id: t._id
      allDay: false
      start: time.toDate()
      end: time.toDate()

      fechaHora: t.fechaHora
      status: t.status
      tweet: t.tweet

    if t.twitterResponse?.id_str
      entry.link = "http://twitter.com/#{t.twitterResponse.user.screen_name}/status/#{t.twitterResponse?.id_str}"

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
      left: "month,agendaWeek,agendaDay"
      center: "title"
      right: "prev,next today"

    editable: false
    events: entries

    eventClick: (calEvent, jsEvent, view) ->
      ce = calEvent
      tweet =
        _id: ce.tweetId
        fechaHora: ce.fechaHora
        status: ce.status
        tweet: ce.tweet
        link: ce.link
        className: ce.className

      $modal = $("#event-details-modal")
      $modal.html Template.tweetDetalle selectedTweet: tweet
      $modal.modal 'show'
      
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

Template.tweetDetalle.pending = (tweet) ->
  if tweet.status is Tweets.STATUS.PENDING
    return true
  return false

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

@eliminarTweet = (id) ->
  tweet = Tweets.findOne id
  bootbox.confirm "Se eliminará el tweet #{tweet.tweet}", (result) ->
    if result
      Tweets.remove id, (err) ->
        if err
          alert err
          logger.error err
        else
          $('.modal').modal 'hide'
    return true