createdAtAndUserId = (userId, doc) ->
  doc.createdAt = Date.now()
  doc.userId = userId unless doc.userId

Mentions._collection.before.insert createdAtAndUserId

isOwner = (userId, doc) ->
  doc.userId is userId

Mentions.allow
  insert: -> false
  update: -> false
  remove: -> false
