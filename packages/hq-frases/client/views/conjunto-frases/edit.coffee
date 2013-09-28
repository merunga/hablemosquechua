currConjuntoFrases = -> ConjuntosFrases.findOne Session.get( 'conjuntoFrasesId' )

Template.conjuntoFrasesEdit.rendered = ->
  Tokenfield.init()
  $( @findAll 'select[required].chosen:not([data-combobox])[multiple]' )
    .each (i,s) ->
      $(s).chosen
        search_contains: true
        width: $(s).data('width')
  if dicc = currConjuntoFrases()
    cols =  ['_id']
    extraColsLength = 2
    
    frases = []
    Frases.find( conjuntoId: Session.get 'conjuntoFrasesId' ).forEach (f) ->
      frasesAux = [f._id]
      extraColsLength = f.rafaga.length if f.rafaga?.length > extraColsLength
      frasesAux.push f.frase
      _(f.rafaga).each (r) ->
        frasesAux.push r
      frases.push frasesAux

    if not frases or _(frases).isEmpty()
      frases = [['','']]
    
    colWidths = [100].concat _((num for num in [1..extraColsLength])).collect (v) -> 250

    $("#frases-table").handsontable
      colHeaders: ['_id', 'frase','rafagas ->']
      data: frases
      minSpareRows: 1
      minSpareCols: 2
      colWidths: colWidths
      manualColumnResize: true
      outsideClickDeselects: false
      removeRowPlugin: true
      beforeRemoveRow: (index, amount) ->
        entrada = $('#frases-table').handsontable 'getDataAtRow', index
        if entrada[0]
          Frases.remove entrada[0]

Template.conjuntoFrasesEdit.helpers
  currConjuntoFrases: -> currConjuntoFrases()
  diccionarios: -> Diccionarios.find()

Template.conjuntoFrasesEdit.events
  'submit #editConjuntoFrasesForm': (e) ->
    e.preventDefault()
    dicc = $(e.currentTarget).formToJSON()

    unless currConjuntoFrases()
      ConjuntosFrases.insert dicc, (err, result) ->
        unless err
          Router.go 'conjuntoFrasesEdit', id: result
        else
          console.log err
    else
      ConjuntosFrases.update Session.get( 'conjuntoFrasesId' ), {$set: dicc}, (err) ->
        if err
          console.log( err ) 
        else
          data = $( '#frases-table' ).handsontable( 'getData' ).slice 0, -1
          if data
            _(data).each (f, i) ->
              rafaga = _(f.splice 2).without null
              rafaga = null if _(rafaga).isEmpty()
              frase =
                frase: f[1]
                rafaga: rafaga
              if f[0]
                id = f[0]
                Frases.update id, { $set: frase }, (err) ->
                  unless err
                    $( '#frases-table' ).handsontable( 'setDataAtCell', i, 0, id )
                    Router.go 'conjuntoFrasesEdit', id: Session.get( 'conjuntoFrasesId' )
                  else
                    console.log err
              else
                frase.conjuntoId = Session.get 'conjuntoFrasesId'
                Frases.insert frase, (err, result) ->
                  unless err
                    $( '#frases-table' ).handsontable( 'setDataAtCell', i, 0, result )
                    Router.go 'conjuntoFrasesEdit', id: Session.get( 'conjuntoFrasesId' )
                  else
                    console.log err
    
  'change #variables': (e, tmpl) ->
    console.log e.currentTarget.value
