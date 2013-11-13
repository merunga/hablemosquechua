HablemosQuechua =
  Utils:
    weeksBetween: (d1, d2) ->
      aDay = 24 * 60 * 60 * 1000

      weeks = {}
      _([0..7]).each (wd) ->
        weeks[wd] = []

      d = undefined
      i = d1.getTime()
      n = d2.getTime()

      while i <= n
        date = new Date(i)
        d = date.getDay()
        # day zero remains empty: mon=1 ... sun=7
        if d is 0
          d = 7
        else
          d + 1

        weeks[d].push date
        i += aDay

      return weeks

    getHorarios: (rules) ->
      weeks = HablemosQuechua.Utils.weeksBetween rules.desde, rules.hasta
      horarios = []
      Schedules.find( { _id: { $in: rules.scheduleIds } } ).forEach (s) ->
        EntradasSchedule.find( scheduleId: s._id ).forEach (e) ->
          _(e.diasDeLaSemana).each (ddls) ->
            _(weeks[ddls]).each (dia) ->
              _(e.horas).each (hora) ->
                _(e.minutos).each (mins) ->
                  tweetTime = moment dia
                  tweetTime.hour hora
                  tweetTime.minutes mins
                  tweetTime = moment tweetTime.format( 'YYYY-MM-DD HH:mm:ss.SSS' )
                  tweetTime.seconds 0
                  tweetTime.milliseconds 0
                  if tweetTime.isAfter rules.desde and tweetTime.isBefore rules.hasta
                    horarios.push tweetTime.toDate()
      horarios

    getFrases: (scheduleIds) ->
      frases = []
      conjuntoFrasesIds = Schedules.findOne( _id: { $in: scheduleIds } ).conjuntoFrasesIds
      ConjuntosFrases.find( _id: { $in: conjuntoFrasesIds } ).forEach (cf) ->
        frases = _.union frases, Frases.find(
          { conjuntoId: cf._id },
          { fields: { frase: 1, rafaga: 1 } }
        ).fetch()
      frases

    getPalabras: (scheduleIds) ->
      palabras = []
      conjuntoFrasesIds = Schedules.findOne( _id: { $in: scheduleIds } ).conjuntoFrasesIds
      ConjuntosFrases.find( _id: { $in: conjuntoFrasesIds } ).forEach (cf) ->
        Diccionarios.find( _id: { $in: cf.diccionarioIds } ).forEach (d) ->
          palabras = _.union palabras, PalabrasDiccionario.find(
            { diccionarioId: d._id },
            { fields: { createdAt: 0, userId: 0, diccionarioId: 0 } }
          ).fetch()
      palabras

    getOne: (array) ->
      index = _.random array.length - 1
      array[index]

  replaceVars: (frase, palabra) ->
    vars = _(palabra).keys()
    _(vars).each (varName) ->
      frase = frase.replace '{'+varName+'}', palabra[varName]
    return frase


  newTweet: (palabra, frase, horario) ->
    tweet =
      fraseId: frase._id
      palabraId: palabra._id
      fechaHora: horario
      status: Tweets.STATUS.PENDING

    fraseStr = HablemosQuechua.replaceVars frase.frase, palabra
    if fraseStr.length <= 140
      tweet.tweet = fraseStr
      if frase.rafaga and not _( _(frase.rafaga).without null, '' ).isEmpty()
        tweets = [tweet]
        _( _(frase.rafaga).without null, '' ).each (r, i) ->
          horarioR = moment horario
          horarioR.add 'minutes', 3
          rafaga =
            fraseId: frase._id
            palabraId: palabra._id
            fechaHora: horarioR.toDate()
            status: Tweets.STATUS.PENDING
            rafagaIdx: i
          rafaga.tweet = HablemosQuechua.replaceVars r, palabra
          tweets.push rafaga
        return tweets
      else
        return tweet
