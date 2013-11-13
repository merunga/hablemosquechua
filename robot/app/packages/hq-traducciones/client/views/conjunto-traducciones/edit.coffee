currConjuntoTraducciones = -> ConjuntosTraducciones.findOne Session.get( 'conjuntoTraduccionesId' )

Template.conjuntoTraduccionesEdit.rendered = ->
  Tokenfield.init()
  TagsInput.init @

  $( @findAll 'select.chosen:not([data-combobox])[multiple]' )
    .each (i,s) ->
      $(s).chosen
        search_contains: true
        width: $(s).data('width')

  if conjPr = currConjuntoTraducciones()
    cols =  ['_id']
    extraColsLength = 2
    
    traducciones = []
    Traducciones.find( conjuntoId: Session.get 'conjuntoTraduccionesId' ).forEach (p) ->
      traduccionesAux = [p._id]
      traduccionesAux.push p.traduccion
      traduccionesAux.push p.respuesta
      traducciones.push traduccionesAux

    if not traducciones or _(traducciones).isEmpty()
      traducciones = [['','','']]
    
    colWidths = [100, 250, 250]

    $("#traducciones-table").handsontable
      colHeaders: ['_id', 'traduccion','respuesta']
      data: traducciones
      minSpareRows: 1
      colWidths: colWidths
      manualColumnResize: true
      outsideClickDeselects: false
      removeRowPlugin: true
      beforeRemoveRow: (index, amount) ->
        entrada = $('#traducciones-table').handsontable 'getDataAtRow', index
        if entrada[0]
          Traducciones.remove entrada[0]

Template.conjuntoTraduccionesEdit.helpers
  currConjuntoTraducciones: -> currConjuntoTraducciones()
  diccionarios: -> Diccionarios.find()

Template.conjuntoTraduccionesEdit.events
  'submit #editConjuntoTraduccionesForm': (e) ->
    e.preventDefault()
    conjPr = $(e.currentTarget).formToJSON()
    console.log conjPr

    unless currConjuntoTraducciones()
      ConjuntosTraducciones.insert conjPr, (err, result) ->
        unless err
          Router.go 'conjuntoTraduccionesEdit', _id: result
        else
          logger.error err
          logger.error ConjuntosTraducciones.namedContext("default").invalidKeys()
    else
      ConjuntosTraducciones.update Session.get( 'conjuntoTraduccionesId' ), {$set: conjPr}, (err) ->
        if err
          logger.error err
          logger.error ConjuntosTraducciones.namedContext("default").invalidKeys()
        else
          data = $( '#traducciones-table' ).handsontable( 'getData' ).slice 0, -1
          if data
            _(data).each (p, i) ->
              traduccion =
                traduccion: p[1]
                respuesta: p[2]
              if p[0]
                id = p[0]
                Traducciones.update id, { $set: traduccion }, (err) ->
                  unless err
                    $( '#traducciones-table' ).handsontable( 'setDataAtCell', i, 0, id )
                    Router.go 'conjuntoTraduccionesEdit', _id: Session.get( 'conjuntoTraduccionesId' )
                  else
                    logger.error err
                    logger.error Traducciones.namedContext("default").invalidKeys()
              else
                traduccion.conjuntoId = Session.get 'conjuntoTraduccionesId'
                Traducciones.insert traduccion, (err, result) ->
                  unless err
                    $( '#traducciones-table' ).handsontable( 'setDataAtCell', i, 0, result )
                    Router.go 'conjuntoTraduccionesEdit', _id: Session.get( 'conjuntoTraduccionesId' )
                  else
                    logger.error err
                    logger.error Traducciones.namedContext("default").invalidKeys()
    
  'change #variables': (e, tmpl) ->
    logger.info e.currentTarget.value
