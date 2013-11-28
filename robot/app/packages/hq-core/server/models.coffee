createdAtAndUserId = (userId, doc) ->
  doc.createdAt = Date.now()
  doc.userId = userId unless doc.userId

Tweets._collection.before.insert createdAtAndUserId

isOwner = (userId, doc) ->
  doc.userId is userId

Tweets.allow
  insert: -> true
  update: isOwner
  remove: isOwner
