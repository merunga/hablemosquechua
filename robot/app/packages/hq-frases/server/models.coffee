createdAtAndUserId = (userId, doc) ->
  doc.createdAt = Date.now()
  doc.userId = userId

ConjuntosFrases._collection.before.insert createdAtAndUserId
Frases._collection.before.insert createdAtAndUserId

isOwner = (userId, doc) ->
  doc.userId is userId

ConjuntosFrases.allow
  insert: -> true
  update: isOwner
  remove: isOwner

Frases.allow
  insert: -> true
  update: isOwner
  remove: isOwner

AggregationConjuntoFrases.allow
  insert: -> false
  update: -> false
  remove: -> false
