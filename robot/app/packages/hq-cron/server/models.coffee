createdAtAndUserId = (userId, doc) ->
  doc.createdAt = Date.now()
  doc.userId = userId

Schedules._collection.before.insert createdAtAndUserId
EntradasSchedule._collection.before.insert createdAtAndUserId

isOwner = (userId, doc) ->
  doc.userId is userId

Schedules.allow
  insert: -> true
  update: isOwner
  remove: isOwner

EntradasSchedule.allow
  insert: -> true
  update: isOwner
  remove: isOwner

AggregationSchedule.allow
  insert: -> false
  update: -> false
  remove: -> false
