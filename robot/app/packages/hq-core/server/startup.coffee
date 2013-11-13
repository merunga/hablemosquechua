Twit = Npm.require 'twit'

Meteor.startup ->
  serviceCredentials = Accounts.loginServiceConfiguration.findOne service: 'twitter'
  Deps.autorun ->
    if serviceCredentials
      TweetCron = new Cron()
      TweetCron.addJob 1, -> # every minute
        date = moment()
        date.seconds 0
        date.milliseconds 0
        date.utc() # universal time
        date = moment date.format( 'YYYY-MM-DD HH:mm:ss.SSS' )
        fechaHora = date.toDate()

        tweets = Tweets.find( fechaHora: fechaHora ).fetch()
        if tweets and not _(tweets).isEmpty()
          _(tweets).each (t) ->
            accessCredentials = Meteor.users.findOne( t.userId )?.services?.twitter
            if accessCredentials
              logger.info 'INFO: tuitenado'
              logger.info t.tweet
              twitter = new Twit
                consumer_key:        serviceCredentials.consumerKey
                consumer_secret:     serviceCredentials.secret
                access_token:        accessCredentials.accessToken
                access_token_secret: accessCredentials.accessTokenSecret

              twitter.post 'statuses/update', { status: t.tweet },
                Meteor.bindEnvironment( (err, response) ->
                  if err
                    logger.error err
                    Tweets._collection.update t._id,
                      $set:
                        status: Tweets.STATUS.ERROR
                        twitterError: err

                  else if response
                    Tweets._collection.update t._id,
                      $set:
                        status: Tweets.STATUS.SUCCESS
                        twitterResponse: response
                , (e) ->
                  logger.error 'Exception on bindEnvironment'
                  logger.error e
                )
            else
              logger.error 'No access credentials found for user '+t.userId
