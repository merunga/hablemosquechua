populateTags = (userId, tags) ->
  _( tags ).each (t) ->
    if t
      tag = { tag: t, userId: userId }
      unless Tags.findOne tag
        Tags.insert tag

observe = (coll, tagField='tags') ->
  coll.find().observe
    added: (doc) ->
      populateTags doc.userId, doc[tagField]
    changed: (newDoc, oldDoc) ->
      populateTags newDoc.userId, newDoc[tagField]

observe Diccionarios
observe ConjuntosFrases
observe Schedules, 'tagsAUsar'
