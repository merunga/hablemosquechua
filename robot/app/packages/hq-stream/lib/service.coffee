currUser = (u) ->
  u?.services?.twitter?.accessCredentials?.screenName

potencialPregunta = 

StreamService =
  ultimoTweetEsPregunta: (user) ->
    return false

  respuestaCorrecta: (user, tweetRecibido ) ->

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

  enviarTraduccion: (twitter, robotUser, twitterUser, tweetPregunta, tweetRespuesta, traduccion)->
    u = twitterUser
    sname = u.screen_name
    t = traduccion
    dm = "DM @#{sname} #{tweetRespuesta}"
    twitter.post 'statuses/update', { status: dm }, Meteor.bindEnvironment( (err, response) ->
      console.log '-------'
      console.log robotUser._id
      tweet =
        traduccionId: t.traduccion._id
        fechaHora: new Date
        userId: robotUser._id
        userPregunta: sname
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
      Tweets._collection.insert tweet
    , (e) ->
      logger.error 'Exception on bindEnvironment status/update'
      logger.error e
    )
    