Twit = Npm.require 'twit'

Meteor.startup ->
  serviceCredentials = Accounts.loginServiceConfiguration.findOne service: 'twitter'

  TweetCron = new Cron()
  TweetCron.addJob 1, -> # every minute
    date = moment()
    date.seconds 0
    date.milliseconds 0
    fechaHora = date.toDate()

    tweets = Tweets.find( fechaHora: fechaHora ).fetch()
    if tweets and not _(tweets).isEmpty()
      _(tweets).each (t) ->
        console.log 'inicio tweet '+t.tweet
        accessCredentials = Meteor.users.findOne( t.userId )?.services?.twitter
        if accessCredentials
          twitter = new Twit
            consumer_key:        serviceCredentials.consumerKey
            consumer_secret:     serviceCredentials.secret
            access_token:        accessCredentials.accessToken
            access_token_secret: accessCredentials.accessTokenSecret

          twitter.post 'statuses/update', { status: t.tweet },
            Meteor.bindEnvironment( (err, response) ->
              if err
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
              console.log 'Exception on bindEnvironment'
              console.log e
            )
        else
          console.log 'ERROR: No access credentials found for user '+t.userId
