Twit = Npm.require 'twit'

Meteor.startup ->
  serviceCredentials = Accounts.loginServiceConfiguration.findOne service: 'twitter'

  accessCredentials = Meteor.users.findOne( t.userId )?.services?.twitter
  # if accessCredentials
  #   twitter = new Twit
  #     consumer_key:        serviceCredentials.consumerKey
  #     consumer_secret:     serviceCredentials.secret
  #     access_token:        accessCredentials.accessToken
  #     access_token_secret: accessCredentials.accessTokenSecret

  #   twitter.post 'statuses/update', { status: t.tweet },
  #     Meteor.bindEnvironment( (err, response) ->
  #       if err
  #         logger.error err
  #         Tweets._collection.update t._id,
  #           $set:
  #             status: Tweets.STATUS.ERROR
  #             twitterError: err

  #       else if response
  #         Tweets._collection.update t._id,
  #           $set:
  #             status: Tweets.STATUS.SUCCESS
  #             twitterResponse: response