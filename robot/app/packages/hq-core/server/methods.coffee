utils = HablemosQuechua.Utils

Meteor.methods
  calcularTweetCount: (rules) ->
    weeks = utils.weeksBetween rules.desde, rules.hasta
    count = 0
    Schedules.find( { _id: { $in: rules.scheduleIds } } ).forEach (s) ->
      EntradasSchedule.find( scheduleId: s._id ).forEach (e) ->
        _(e.diasDeLaSemana).each (ddls) ->
          count += weeks[ddls].length * e.horas.length * e.minutos.length
    return count

  programarTweets: (rules) ->
    palabras = utils.getPalabras rules.scheduleIds
    frases   = utils.getFrases rules.scheduleIds
    preguntas  = utils.getPreguntas rules.scheduleIds
    horarios = utils.getHorarios rules
    plantillas = _(frases)?.union preguntas

    _( horarios ).each (h) ->
      p = utils.getOne palabras
      f = if plantillas then utils.getOne( plantillas ) else []
      while not( tweet = HablemosQuechua.newTweet p, f, h )
        p = utils.getOne palabras
        f = if plantillas then utils.getOne( plantillas ) else []
        tweet = HablemosQuechua.newTweet p, f, h

      unless _(tweet).isArray()
        Tweets.insert tweet
      else
        _(tweet).each (t) ->
          try
            Tweets.insert t
          catch e
            logger.error e
            logger.error Tweets.namedContext("default").invalidKeys()

  flushTweets: ->
    now = new Date()
    Tweets.remove
      userId: Meteor.userId()
      fechaHora: { $gt: now }
