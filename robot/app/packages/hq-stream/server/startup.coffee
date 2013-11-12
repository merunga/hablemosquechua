Meteor.startup ->
  Twit = Npm.require 'twit'
  streams = {}
  serviceCredentials = Accounts.loginServiceConfiguration.findOne service: 'twitter'

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
        stream = twitter.stream('statuses/filter', { track: currUser })
        streams[u._id] = stream
        stream.on 'tweet', (tweet)->
          sname = tweet.user.screen_name
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
