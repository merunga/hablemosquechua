Tweets = new Meteor.Collection2 'tweets',
  schema:
    userId:
      type: String
      optional: true
    fraseId:
      type: String
    rafagaIdx:
      type: Number
      optional: true
    palabraId:
      type:String
    tweet:
      type: String
    fechaHora:
      type: Date
    status:
      type: String
    twitterResponse:
      type: Object
      optional: true
    twitterError:
      type: Object
      optional: true

Tweets.STATUS =
  PENDING: 'pending'
  SUCCESS: 'success'
  ERROR:   'error'
