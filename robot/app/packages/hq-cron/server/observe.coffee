updateAggregationSchedule = (userId, scheduleId) ->
  conjunto = Schedules.findOne scheduleId

  conjuntosFrases = []
  if conjunto.conjuntoFrasesIds
    ConjuntosFrases.find( _id: {$in: conjunto.conjuntoFrasesIds} ).forEach (cf) ->
      conjuntosFrases.push cf.nombre
  conjuntosFrases = null if _(conjuntosFrases).isEmpty()

  aggr =
    scheduleId: scheduleId
    userId: userId
    countEntradas: EntradasSchedule.find( scheduleId: scheduleId ).count() or 0
    conjuntosFrases: conjuntosFrases

  if aggrSched = AggregationSchedule.findOne( scheduleId: scheduleId )
    aggrSchedId = aggrSched._id
    delete aggrSched._id
    unless _(aggrSched).isEqual aggr
      delete aggr.scheduleId # XXX: cannot update a unique field
      try
        AggregationSchedule.update aggrSchedId, $set: aggr, (err) ->
          logger.error( err ) if err
      catch e 
        logger.error e          
  else
    _(aggrSched).isEqual aggr
    AggregationSchedule.insert aggr

EntradasSchedule.find().observe
  added: (doc) ->
    updateAggregationSchedule doc.userId, doc.scheduleId
  changed: (newDoc, oldDoc) ->
    updateAggregationSchedule newDoc.userId, newDoc.scheduleId
  removed: (doc) ->
    updateAggregationSchedule doc.userId, doc.scheduleId

Schedules.find().observe
  added: (doc) ->
    updateAggregationSchedule doc.userId, doc._id
  changed: (newDoc, oldDoc) ->
    updateAggregationSchedule newDoc.userId, newDoc._id
  removed: (doc) ->
    AggregationSchedule.remove scheduleId: doc._id
