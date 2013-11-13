Meteor.startup ->
  Twit = Npm.require 'twit'
  streams = {}
  
  serviceCredentials = Accounts.loginServiceConfiguration.findOne service: 'twitter'
  Deps.autorun ->
    if serviceCredentials
      Meteor.users.find( 'services.twitter': { $exists: true } ).observe
        added: (u) ->
          accessCredentials = u.services.twitter
          if accessCredentials
            twitter = new Twit
              consumer_key:        serviceCredentials.consumerKey
              consumer_secret:     serviceCredentials.secret
              access_token:        accessCredentials.accessToken
              access_token_secret: accessCredentials.accessTokenSecret

            currUser = "@#{accessCredentials.screenName}"
            logger.info "Soy #{currUser}, te escucho..."

            streams[u._id] = twitter.stream('statuses/filter', { track: currUser })
            streams[u._id].on 'tweet',  Meteor.bindEnvironment( (tweet)->
              sname = tweet.user.screen_name
              potencialPregunta = tweet.text.replace("#{currUser} ",'')
              if p = PreguntasService.looksLikeOne u._id, potencialPregunta
                logger.info "Pregunta de @#{sname}: #{potencialPregunta}"
                if t = DiccionariosService.traducir u._id, p.palabra.palabra, p.palabra.placeholder
                  logger.info "Palabra encontrada: #{p.palabra.palabra}"
                  tweet = HablemosQuechua.replaceVars p.pregunta.respuesta, t
                else
                  logger.info "Palabra NO encontrada: #{p.palabra.palabra}"
                  tweet = "lo siento, pero la traducción de \"#{p.palabra.palabra}\" todavía no me la "\
                    + "enseñan... al final de cuentas sólo soy un robot"

                dm = "DM @#{sname} #{tweet}"
                twitter.post 'statuses/update', { status: dm }, Meteor.bindEnvironment( (err, response) ->
                  tweet =
                    preguntaId: p.pregunta._id
                    fechaHora: new Date
                    userId: u._id
                  if t then tweet.palabraId = t._id else tweet.palabra = p.palabra.palabra
                  unless err
                    tweet.status = Tweets.STATUS.SUCCESS
                    tweet.twitterResponse = response
                    logger.info "Enviando respuesta a pregunta de @#{sname}: #{potencialPregunta}"
                  else
                    tweet.status = Tweets.STATUS.ERROR
                    tweet.twitterResponse = err
                    logger.info "Error al enviar respuesta a pregunta de @#{sname}: #{potencialPregunta}"
                  Tweets._collection.insert tweet
                , (e) ->
                  logger.error 'Exception on bindEnvironment status/update'
                  logger.error e
                )
            , (e) ->
              logger.error 'Exception on bindEnvironment statuses/filter'
              logger.error e
            )

              # if sname isnt accessCredentials.screenName
              #   if sname is admin
              #     if tweet is command
              #       exec tweet.text
              #   else if sname is moderador
              #     retweet tweet.text
              #   else if tweet.text like any preguntas?
              #     termino, idioma = extraer(tweet.text)
              #     if termino in diccionario?
              #       then tweet respuesta
              #     else
              #       retweet a la comunidad

        removed: (u) ->
          streams[u._id].stop()
          delete streams[u._id]
