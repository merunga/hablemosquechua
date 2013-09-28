Diccionarios._collection.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.userId = userId

isOwner = (userId, doc) ->
  doc.userId is userId

Diccionarios._collection.allow
  insert: -> true
  update: isOwner
  remove: isOwner
