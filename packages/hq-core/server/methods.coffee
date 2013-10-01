utils = HablemosQuechua.Utils

Meteor.methods
  'calcularTweetCount': (rules) ->
    weeks = utils.weeksBetween rules.desde, rules.hasta
    count = 0
    Schedules.find( { _id: { $in: rules.scheduleIds } } ).forEach (s) ->
      EntradasSchedule.find( scheduleId: s._id ).forEach (e) ->
        _(e.diasDeLaSemana).each (ddls) ->
          count += weeks[ddls].length * e.horas.length * e.minutos.length
    return count

  'programarTweets': (rules) ->
    palabras = utils.getPalabras rules.scheduleId
    frases   = utils.getFrases rules.scheduleId
    horarios = utils.getHorarios rules

    _( horarios ).each (h) ->
      p = utils.getOne palabras
      f = utils.getOne frases
      while not( tweet = HablemosQuechua.newTweet p, f, h )
        p = utils.getOne palabras
        f = utils.getOne frases
        tweet = HablemosQuechua.newTweet p, f, h
      Tweets.insert tweet
