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

  if aggrDicc = AggregationConjuntoFrases.findOne( conjuntoId: conjuntoId )
    aggrDiccId = aggrDicc._id
    delete aggrDicc._id
    unless _(aggrDicc).isEqual aggr
      delete aggr.conjuntoId # XXX: cannot update a unique field
      try
        AggregationConjuntoFrases.update aggrDiccId, $set: aggr, (err) ->
          console.log( err ) if err
      catch e 
        console.log e          
  else
    _(aggrDicc).isEqual aggr
    AggregationConjuntoFrases.insert aggr

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

Meteor.publish 'conjuntoFrases', (id) ->
  [
    ConjuntosFrases.find( _id: id ),
    Frases.find conjuntoId: id
  ]

Meteor.publish 'conjuntosFrases', ->
  [
    ConjuntosFrases.find( { userId: @userId }, { sort: { createdAt: -1 } } ),
    AggregationConjuntoFrases.find userId: @userId
  ]
