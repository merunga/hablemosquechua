createdAtAndUserId = (userId, doc) ->
  doc.createdAt = Date.now()
  doc.userId = userId

ConjuntosPreguntas._collection.before.insert createdAtAndUserId
Preguntas._collection.before.insert createdAtAndUserId

isOwner = (userId, doc) ->
  doc.userId is userId

ConjuntosPreguntas.allow
  insert: -> true
  update: isOwner
  remove: isOwner

Preguntas.allow
  insert: -> true
  update: isOwner
  remove: isOwner

AggregationConjuntoPreguntas.allow
  insert: -> false
  update: -> false
  remove: -> false
