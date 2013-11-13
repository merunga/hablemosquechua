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
            logger.info "Listening... #{currUser}"

            streams[u._id] = twitter.stream('statuses/filter', { track: currUser })
            streams[u._id].on 'tweet',  Meteor.bindEnvironment( (tweet)->
              sname = tweet.user.screen_name
              if p = PreguntasService.looksLikeOne u._id, tweet.text.replace("#{currUser} ",'')
                if t = DiccionariosService.traducir u._id, p.palabra.palabra, p.palabra.placeholder
                  tweet = HablemosQuechua.replaceVars p.pregunta.respuesta, t
                  dm = "DM @#{sname} #{tweet}"
                  twitter.post 'statuses/update', { status: dm }, Meteor.bindEnvironment( (err, response) ->
                    tweet =
                      preguntaId: p.pregunta._id
                      palabraId: t._id
                      fechaHora: new Date
                      userId: u._id
                    unless err
                      tweet.status = Tweets.STATUS.SUCCESS
                      tweet.twitterResponse = response
                    else
                      tweet.status = Tweets.STATUS.ERROR
                      tweet.twitterResponse = err
                      logger.error "Error al enviar DM"
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
