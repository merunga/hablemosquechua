currDiccionario = -> Diccionarios.findOne Session.get( 'diccionarioId' )

Template.diccionarioEdit.rendered = ->
  Tokenfield.init()
  TagsInput.init @

  if dicc = currDiccionario()
    # Deps.autorun ->
    cols =  _.union ['_id'], dicc.variables
    palabras = []
    PalabrasDiccionario.find( diccionarioId: Session.get 'diccionarioId' ).forEach (p) ->
      _(['diccionarioId', 'userId', 'createdAt']).each (f) ->
        delete p[f]
      palabras.push p

    if not palabras or _(palabras).isEmpty()
      obj = {}
      _(cols).each (c) -> obj[c] = ''
      palabras = [obj]

    colWidths = [100].concat _(dicc.variables).collect (v) -> 180

    $("#palabras-table").handsontable
      data: palabras
      colHeaders: cols
      minSpareRows: 1
      colWidths: colWidths
      manualColumnResize: true
      outsideClickDeselects: false
      removeRowPlugin: true
      beforeRemoveRow: (index, amount) ->
        entrada = $('#palabras-table').handsontable 'getDataAtRow', index
        if entrada._id
          PalabrasDiccionario.remove entrada._id

Template.diccionarioEdit.helpers
  currDiccionario: -> currDiccionario()

Template.diccionarioEdit.events
  'submit #editDiccionarioForm': (e) ->
    e.preventDefault()
    dicc = $(e.currentTarget).formToJSON()

    unless currDiccionario()
      Diccionarios.insert dicc, (err, result) ->
        unless err
          Router.go 'diccionarioEdit', _id: result
        else
          logger.error err
          logger.error Diccionarios.namedContext("default").invalidKeys()
    else
      Diccionarios.update Session.get( 'diccionarioId' ), {$set: dicc}, (err) ->
        if err
          logger.error err
          logger.error Diccionarios.namedContext("default").invalidKeys()
        else
          data = $( '#palabras-table' ).handsontable( 'getData' ).slice 0, -1
          if data
            _(data).each (p, i) ->
              if p._id
                id = p._id
                delete p._id
                PalabrasDiccionario.update id, {$set:p}, (err) ->
                  unless err
                    $( '#palabras-table' ).handsontable( 'setDataAtCell', i, 0, id )
                  else
                    logger.error err
              else
                delete p._id
                p.diccionarioId = Session.get 'diccionarioId'
                PalabrasDiccionario.insert p, (err, result) ->
                  unless err
                    $( '#palabras-table' ).handsontable( 'setDataAtCell', i, 0, result )
                  else
                    logger.error err
    
  'change #variables': (e, tmpl) ->
    logger.info g e.currentTarget.value
