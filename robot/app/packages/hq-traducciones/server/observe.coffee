updateAggregationConjunto = (userId, conjuntoId) ->
  conjunto = ConjuntosTraducciones.findOne conjuntoId
  diccionarios = []
  Diccionarios.find( _id: {$in: conjunto.diccionarioIds} ).forEach (d) ->
    diccionarios.push d.nombre
  aggr =
    conjuntoId: conjuntoId
    userId: userId
    countTraducciones: Traducciones.find( conjuntoId: conjuntoId ).count() or 0
    diccionarios: diccionarios

  if aggrConj = AggregationConjuntoTraducciones.findOne( conjuntoId: conjuntoId )
    aggrConjId = aggrConj._id
    delete aggrConj._id
    unless _(aggrConj).isEqual aggr
      delete aggr.conjuntoId # XXX: cannot update a unique field
      try
        AggregationConjuntoTraducciones.update aggrConjId, $set: aggr, (err) ->
          logger.error( err ) if err
      catch e 
        logger.error e
        logger.error AggregationConjuntoTraducciones.namedContext("default").invalidKeys()
  else
    _(aggrConj).isEqual aggr
    try
      AggregationConjuntoTraducciones.insert aggr
    catch e 
      logger.error e
      logger.error AggregationConjuntoTraducciones.namedContext("default").invalidKeys()   

Traducciones.find().observe
  added: (doc) ->
    updateAggregationConjunto doc.userId, doc.conjuntoId
  changed: (newDoc, oldDoc) ->
    updateAggregationConjunto newDoc.userId, newDoc.conjuntoId
  removed: (doc) ->
    updateAggregationConjunto doc.userId, doc.conjuntoId

ConjuntosTraducciones.find().observe
  added: (doc) ->
    updateAggregationConjunto doc.userId, doc._id
  changed: (newDoc, oldDoc) ->
    updateAggregationConjunto newDoc.userId, newDoc._id
  removed: (doc) ->
    AggregationConjuntoTraducciones.remove conjuntoId: doc._id
