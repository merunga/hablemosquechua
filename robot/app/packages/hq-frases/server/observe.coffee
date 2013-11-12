updateAggregationConjunto = (userId, conjuntoId) ->
  conjunto = ConjuntosFrases.findOne conjuntoId
  diccionarios = []
  Diccionarios.find( _id: {$in: conjunto.diccionarioIds} ).forEach (d) ->
    diccionarios.push d.nombre
  aggr =
    conjuntoId: conjuntoId
    userId: userId
    countFrases: Frases.find( conjuntoId: conjuntoId ).count() or 0
    diccionarios: diccionarios

  if aggrConj = AggregationConjuntoFrases.findOne( conjuntoId: conjuntoId )
    aggrConjId = aggrConj._id
    delete aggrConj._id
    unless _(aggrConj).isEqual aggr
      delete aggr.conjuntoId # XXX: cannot update a unique field
      try
        AggregationConjuntoFrases.update aggrConjId, $set: aggr, (err) ->
          logger.error( err ) if err
      catch e 
        logger.error e
        logger.error AggregationConjuntoFrases.namedContext("default").invalidKeys()
  else
    _(aggrConj).isEqual aggr
    try
      AggregationConjuntoFrases.insert aggr
    catch e 
      logger.error e
      logger.error AggregationConjuntoFrases.namedContext("default").invalidKeys()   

Frases.find().observe
  added: (doc) ->
    updateAggregationConjunto doc.userId, doc.conjuntoId
  changed: (newDoc, oldDoc) ->
    updateAggregationConjunto newDoc.userId, newDoc.conjuntoId
  removed: (doc) ->
    updateAggregationConjunto doc.userId, doc.conjuntoId

ConjuntosFrases.find().observe
  added: (doc) ->
    updateAggregationConjunto doc.userId, doc._id
  changed: (newDoc, oldDoc) ->
    updateAggregationConjunto newDoc.userId, newDoc._id
  removed: (doc) ->
    AggregationConjuntoFrases.remove conjuntoId: doc._id
