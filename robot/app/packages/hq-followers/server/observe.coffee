createFollower = (mention) ->
  unless f = Followers.findOne {screenName: mention.twitterUser}
    logger.info "Creando follower #{mention.twitterUser}"
    try
      Followers.insert
        robotId: mention.userId
        screenName: mention.twitterUser
        felicitacionesPublicas: 0
        respuestasCorrectas: 0
    catch e
      logger.error e
      logger.error Followers.namedContext('default').invalidKeys()

Mentions.find().observe
  added: (doc) ->
    createFollower doc
