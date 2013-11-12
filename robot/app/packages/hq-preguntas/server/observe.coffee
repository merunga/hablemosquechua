updateAggregationConjunto = (userId, conjuntoId) ->
  conjunto = ConjuntosPreguntas.findOne conjuntoId
  diccionarios = []
  Diccionarios.find( _id: {$in: conjunto.diccionarioIds} ).forEach (d) ->
    diccionarios.push d.nombre
  aggr =
    conjuntoId: conjuntoId
    userId: userId
    countPreguntas: Preguntas.find( conjuntoId: conjuntoId ).count() or 0
    diccionarios: diccionarios

  if aggrConj = AggregationConjuntoPreguntas.findOne( conjuntoId: conjuntoId )
    aggrConjId = aggrConj._id
    delete aggrConj._id
    unless _(aggrConj).isEqual aggr
      delete aggr.conjuntoId # XXX: cannot update a unique field
      try
        AggregationConjuntoPreguntas.update aggrConjId, $set: aggr, (err) ->
          logger.error( err ) if err
      catch e 
        logger.error e
        logger.error AggregationConjuntoPreguntas.namedContext("default").invalidKeys()
  else
    _(aggrConj).isEqual aggr
    try
      AggregationConjuntoPreguntas.insert aggr
    catch e 
      logger.error e
      logger.error AggregationConjuntoPreguntas.namedContext("default").invalidKeys()   

Preguntas.find().observe
  added: (doc) ->
    updateAggregationConjunto doc.userId, doc.conjuntoId
  changed: (newDoc, oldDoc) ->
    updateAggregationConjunto newDoc.userId, newDoc.conjuntoId
  removed: (doc) ->
    updateAggregationConjunto doc.userId, doc.conjuntoId

ConjuntosPreguntas.find().observe
  added: (doc) ->
    updateAggregationConjunto doc.userId, doc._id
  changed: (newDoc, oldDoc) ->
    updateAggregationConjunto newDoc.userId, newDoc._id
  removed: (doc) ->
    AggregationConjuntoPreguntas.remove conjuntoId: doc._id
