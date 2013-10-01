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
                  if tweetTime.isAfter rules.desde and tweetTime.isBefore rules.hasta
                    horarios.push tweetTime.toDate()
      horarios

    getFrases: (scheduleId) ->
      frases = []
      conjuntoFrasesIds = Schedules.findOne( scheduleId ).conjuntoFrasesIds
      ConjuntosFrases.find( _id: { $in: conjuntoFrasesIds } ).forEach (cf) ->
        frases = _.union frases, Frases.find(
          { conjuntoId: cf._id },
          { fields: { frase: 1, rafaga: 1 } }
        ).fetch()
      frases

    getPalabras: (scheduleId) ->
      palabras = []
      conjuntoFrasesIds = Schedules.findOne( scheduleId ).conjuntoFrasesIds
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

  newTweet: (palabra, frase, horario) ->
    tweet =
      fraseId: frase._id
      palabraId: palabra._id
      fechaHora: horario

    fraseStr = frase.frase
    vars = _(palabra).keys()
    _(vars).each (varName) ->
      fraseStr = fraseStr.replace '{'+varName+'}', palabra[varName]

    if fraseStr.length <= 140
      tweet.tweet = fraseStr
      return tweet
