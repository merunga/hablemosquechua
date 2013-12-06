Followers = new Meteor.Collection2 'followers',
  schema:
    robotId:
      type: String
    screenName:
      type: String
      unique: true
    felicitacionesPublicas:
      type: Number
    respuestasCorrectas:
      type: Number

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
