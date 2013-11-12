Meteor.publish 'tweets', ->
  Tweets.find userId: @userId
