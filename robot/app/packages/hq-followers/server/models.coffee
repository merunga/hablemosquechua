createdAt = (doc) ->
  doc.createdAt = Date.now()

createdAtAndUserId = (userId, doc) ->
  createdAt doc
  doc.userId = userId unless doc.userId

Mentions._collection.before.insert createdAtAndUserId
#Followers._collection.before.insert createdAt

isOwner = (userId, doc) ->
  doc.userId is userId

Followers.allow
  insert: -> false
  update: -> false
  remove: -> false

Mentions.allow
  insert: -> false
  update: -> false
  remove: -> false
