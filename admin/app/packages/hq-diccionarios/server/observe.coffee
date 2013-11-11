updateAggregationDiccionario = (userId, diccionarioId) ->
  aggr =
    diccionarioId: diccionarioId
    userId: userId
    countPalabras: PalabrasDiccionario.find( diccionarioId: diccionarioId ).count() or 0

  if aggrDicc = AggregationDiccionario.findOne( diccionarioId: diccionarioId )
    aggrDiccId = aggrDicc._id
    delete aggrDicc._id
    unless _(aggrDicc).isEqual aggr
      delete aggr.diccionarioId # XXX: cannot update a unique field
      try
        AggregationDiccionario.update aggrDiccId, $set: aggr, (err) ->
          console.log( err ) if err
      catch e 
        console.log e          
  else
    _(aggrDicc).isEqual aggr
    AggregationDiccionario.insert aggr

PalabrasDiccionario.find().observe
  added: (doc) ->
    updateAggregationDiccionario doc.userId, doc.diccionarioId
  changed: (newDoc, oldDoc) ->
    updateAggregationDiccionario newDoc.userId, newDoc.diccionarioId
  removed: (doc) ->
    updateAggregationDiccionario doc.userId, doc.diccionarioId

Diccionarios.find().observe
  added: (doc) ->
    updateAggregationDiccionario doc.userId, doc._id
  removed: (doc) ->
    AggregationDiccionario.remove diccionarioId: doc._id