createdAtAndUserId = (userId, doc) ->
  doc.createdAt = Date.now()
  doc.userId = userId

ConjuntosTraducciones._collection.before.insert createdAtAndUserId
Traducciones._collection.before.insert createdAtAndUserId

isOwner = (userId, doc) ->
  doc.userId is userId

ConjuntosTraducciones.allow
  insert: -> true
  update: isOwner
  remove: isOwner

Traducciones.allow
  insert: -> true
  update: isOwner
  remove: isOwner

AggregationConjuntoTraducciones.allow
  insert: -> false
  update: -> false
  remove: -> false
