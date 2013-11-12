Template.tweetsProgramar.rendered = ->
  TagsInput.init @

  $( @findAll 'select.chosen:not([data-combobox])[multiple]' )
    .each (i,s) ->
      $(s).chosen
        search_contains: true
        width: $(s).data('width')

  $( @findAll '.datetime-picker' ).datetimepicker(
      language: 'es'
      pick12HourFormat: true
    ).on 'changeDate', (e) ->
      logger.info e.date

Template.tweetsProgramar.helpers
  schedules: -> Schedules.find()

getRules = ->
  data = $('#programarForm').formToJSON()
  data.desde = $('#desde').data('datetimepicker').getLocalDate()
  data.hasta = $('#hasta').data('datetimepicker').getLocalDate()
  data

Template.tweetsProgramar.events
  'submit #programarForm': (e) ->
    e.preventDefault()
    data = getRules()

    Meteor.call 'calcularTweetCount', data, (err, result) ->
      logger.error( err ) if err
      Session.set( 'tweetCount', result) if result

  'click button.programar': (e) ->
    e.preventDefault()
    data = getRules()

    Meteor.call 'programarTweets', data, (err, result) ->
      if err
        alert err
      else
        Router.go 'calendarioShow'