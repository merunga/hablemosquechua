Tweets = new Meteor.Collection2 'tweets',
  schema:
    userId:
      type: String
      optional: true
    fraseId:
      type: String
    palabraId:
      type:String
    tweet:
      type: String
    fechaHora:
      type: Date
    status:
      type: String
      optional: true
    twitterResponse:
      type: Object
      optional: true