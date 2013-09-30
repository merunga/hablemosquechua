Template.calendarioProgramar.rendered = ->
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
      console.log e.date

Template.calendarioProgramar.helpers
  schedules: -> Schedules.find()

Template.calendarioProgramar.events
  'submit #programarForm': (e) ->
    e.preventDefault()

    data = $('#programarForm').formToJSON()
    data.desde = $('#desde').data('datetimepicker').getDate()
    data.hasta = $('#hasta').data('datetimepicker').getDate()

    console.log data

    Meteor.call 'calcularTweetCount', data, (err, result) ->
      console.log( err ) if err
      Session.set( 'tweetCount', result) if result

  'click button.programar': (e) ->
    e.preventDefault()
    data = $('#programarForm').formToJSON()