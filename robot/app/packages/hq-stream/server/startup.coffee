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
          if tweet.user.screen_name isnt accessCredentials.screenName
            logger.info "------- from #{tweet.user.screen_name}"
            logger.info tweet.text

    removed: (u) ->
      streams[u._id].stop()
      delete streams[u._id]
