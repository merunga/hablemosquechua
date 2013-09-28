createdAtAndUserId = (userId, doc) ->
  doc.createdAt = Date.now()
  doc.userId = userId

Diccionarios._collection.before.insert createdAtAndUserId

PalabrasDiccionario.before.insert createdAtAndUserId

isOwner = (userId, doc) ->
  doc.userId is userId

Diccionarios.allow
  insert: -> true
  update: isOwner
  remove: isOwner

PalabrasDiccionario.allow
  insert: -> true
  update: isOwner
  remove: isOwner
