currConjuntoPreguntas = -> ConjuntosPreguntas.findOne Session.get( 'conjuntoPreguntasId' )

Template.conjuntoPreguntasEdit.rendered = ->
  Tokenfield.init()
  TagsInput.init @

  $( @findAll 'select.chosen:not([data-combobox])[multiple]' )
    .each (i,s) ->
      $(s).chosen
        search_contains: true
        width: $(s).data('width')

  if conjPr = currConjuntoPreguntas()
    cols =  ['_id']
    extraColsLength = 2
    
    preguntas = []
    Preguntas.find( conjuntoId: Session.get 'conjuntoPreguntasId' ).forEach (p) ->
      preguntasAux = [p._id]
      preguntasAux.push p.pregunta
      preguntasAux.push p.respuesta
      preguntas.push preguntasAux

    if not preguntas or _(preguntas).isEmpty()
      preguntas = [['','','']]
    
    colWidths = [100, 250, 250]

    $("#preguntas-table").handsontable
      colHeaders: ['_id', 'pregunta','resuesta']
      data: preguntas
      minSpareRows: 1
      colWidths: colWidths
      manualColumnResize: true
      outsideClickDeselects: false
      removeRowPlugin: true
      beforeRemoveRow: (index, amount) ->
        entrada = $('#preguntas-table').handsontable 'getDataAtRow', index
        if entrada[0]
          Preguntas.remove entrada[0]

Template.conjuntoPreguntasEdit.helpers
  currConjuntoPreguntas: -> currConjuntoPreguntas()
  diccionarios: -> Diccionarios.find()

Template.conjuntoPreguntasEdit.events
  'submit #editConjuntoPreguntasForm': (e) ->
    e.preventDefault()
    conjPr = $(e.currentTarget).formToJSON()
    console.log conjPr

    unless currConjuntoPreguntas()
      ConjuntosPreguntas.insert conjPr, (err, result) ->
        unless err
          Router.go 'conjuntoPreguntasEdit', _id: result
        else
          logger.error err
          logger.error ConjuntosPreguntas.namedContext("default").invalidKeys()
    else
      ConjuntosPreguntas.update Session.get( 'conjuntoPreguntasId' ), {$set: conjPr}, (err) ->
        if err
          logger.error err
          logger.error ConjuntosPreguntas.namedContext("default").invalidKeys()
        else
          data = $( '#preguntas-table' ).handsontable( 'getData' ).slice 0, -1
          if data
            _(data).each (p, i) ->
              pregunta =
                pregunta: p[1]
                respuesta: p[2]
              if p[0]
                id = p[0]
                Preguntas.update id, { $set: pregunta }, (err) ->
                  unless err
                    $( '#preguntas-table' ).handsontable( 'setDataAtCell', i, 0, id )
                    Router.go 'conjuntoPreguntasEdit', _id: Session.get( 'conjuntoPreguntasId' )
                  else
                    logger.error err
                    logger.error Preguntas.namedContext("default").invalidKeys()
              else
                pregunta.conjuntoId = Session.get 'conjuntoPreguntasId'
                Preguntas.insert pregunta, (err, result) ->
                  unless err
                    $( '#preguntas-table' ).handsontable( 'setDataAtCell', i, 0, result )
                    Router.go 'conjuntoPreguntasEdit', _id: Session.get( 'conjuntoPreguntasId' )
                  else
                    logger.error err
                    logger.error Preguntas.namedContext("default").invalidKeys()
    
  'change #variables': (e, tmpl) ->
    logger.info e.currentTarget.value
