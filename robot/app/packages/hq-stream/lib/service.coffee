currUser = (u) ->
  u?.services?.twitter?.accessCredentials?.screenName

potencialPregunta = 

StreamService =
  ultimoTweetEsPregunta: (user) ->
    t = Tweets.findOne( {status:'success'}, { sort: { fechaHora: -1 }, limit: 1 } )
    return if t.esPregunta then t else false

  respuestaCorrecta: (user, tweetRecibido, ultimoTweet ) ->
    if palabra = PalabrasDiccionario.findOne ultimoTweet.palabraId
      if diccionario = Diccionarios.findOne palabra.diccionarioId
        for varname in diccionario.variables
          if tweetRecibido.match new RegExp ".*#{palabra[varname]}.*", 'i'
            logger.info "Respuesta correcta: #{palabra[varname]}"
            return varname
    logger.info "Respuesta incorrecta: #{tweetRecibido}"
    return false

  registrarRespuestaCorrecta: ( robotUser, userRespuesta, ultimoTweet, variable ) ->
    try
      RespuestasCorrectas.insert
        userRespuesta: userRespuesta
        fechaHora: new Date()
        palabraId: ultimoTweet.palabraId
        variable: variable
    catch e
      logger.error 'RespuestasCorrectas.insert '+e
      logger.error RespuestasCorrectas.namedContext('default').invalidKeys()

  esSolicitudDeTraduccion: ( user, tweetRecibido ) ->
    sname = tweetRecibido.user.screen_name
    logger.info "Mention de @#{sname}: #{tweetRecibido.text}"
    potencialPregunta = tweetRecibido.text.replace("#{currUser(user)} ",'')
    p = TraduccionesService.looksLikeOne user._id, potencialPregunta
    logger.info( "Pregunta de @#{sname}: #{potencialPregunta}" ) if p
    return p

  getRespuesta: (user, palabraObj) ->
    p = palabraObj
    u = user
    if t = DiccionariosService.traducir u._id, p.palabra.palabra, p.palabra.placeholder
      logger.info "Palabra encontrada: #{p.palabra.palabra}"
      tweet = HablemosQuechua.replaceVars p.traduccion.respuesta, t
    else
      logger.info "Palabra NO encontrada: #{p.palabra.palabra}"
      tweet = "lo siento, pero la traducción de \"#{p.palabra.palabra}\" todavía no me la "\
        + "enseñan... al final de cuentas sólo soy un robot"
    return tweet

  enviarTraduccion: (twitter, robotUser, twitterUser, tweetPregunta, tweetRespuesta, traduccion, mentionId)->
    u = twitterUser
    sname = u.screen_name
    t = traduccion
    dm = "DM @#{sname} #{tweetRespuesta}"
    twitter.post 'statuses/update', { status: dm }, Meteor.bindEnvironment( (err, response) ->
      tweet =
        traduccionId: t.traduccion._id
        fechaHora: new Date()
        userId: robotUser._id
        userPregunta: sname
        tweet: dm
      if t then tweet.palabraId = t.traduccion._id else tweet.palabra = traduccion.palabra.palabra
      unless err
        tweet.status = Tweets.STATUS.SUCCESS
        tweet.twitterResponse = response
        logger.info "Enviando respuesta a traduccion de @#{sname}: #{tweetPregunta}"
      else
        tweet.status = Tweets.STATUS.ERROR
        tweet.twitterError = err
        logger.error "Error al enviar respuesta a traduccion de @#{sname}: #{tweetPregunta}"
        logger.error err

      tweetId = Tweets._collection.insert tweet

      try
        TraduccionesSolicitadas.insert
          userId: robotUser._id
          mentionId: mentionId
          tweetRespuestaId: tweetId
      catch e
        logger.error 'TraduccionesSolicitadas.insert '+e
        logger.error TraduccionesSolicitadas.namedContext('default').invalidKeys()

    , (e) ->
      logger.error 'Exception on bindEnvironment status/update'
      logger.error e
    )
    
  dealWithMention: (twitter, robotUser, tweet) ->
    mention =
      userId: robotUser._id
      tweet: tweet.text
      twitterUser: tweet.user.screen_name
      tweetObject: tweet
    try
      mentionId = Mentions.insert mention
    catch e
      logger.error 'Mentions.insert '+e
      logger.error Mentions.namedContext('default').invalidKeys()

    if traduccion = StreamService.esSolicitudDeTraduccion robotUser, tweet
      tweetRespuesta = StreamService.getRespuesta robotUser, traduccion
      StreamService.enviarTraduccion twitter, robotUser, tweet.user, tweet.text, \
        tweetRespuesta, traduccion, mentionId
    else if ultimoTweet = StreamService.ultimoTweetEsPregunta( robotUser )
      if rc = StreamService.respuestaCorrecta( robotUser, tweet.text, ultimoTweet )
        StreamService.registrarRespuestaCorrecta( robotUser, tweet.user.screen_name, ultimoTweet, rc )
