Mentions = new Meteor.Collection2 'mentions',
  schema:
    userId:
      type: String
    twitterUser:
      type: String
    tweet:
      type: String
    tweetObject:
      type: Object
      optional: true
