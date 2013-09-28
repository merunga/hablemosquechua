currConjuntoFrases = -> ConjuntosFrases.findOne Session.get( 'conjuntoFrasesId' )

Template.conjuntoFrasesEdit.rendered = ->
  Tokenfield.init()
  if dicc = currConjuntoFrases()
    cols =  _.union ['_id'], dicc.variables, ['tags']
    
    frases = []
    Frases.find(
      { conjuntoFrasesId: Session.get 'conjuntoFrasesId' },
      { conjuntoFrasesId: 0 }
    ).forEach (p) ->
      _(['conjuntoFrasesId', 'userId', 'createdAt']).each (f) ->
        delete p[f]
      frases.push p

    if not frases or _(frases).isEmpty()
      obj = {}
      _(cols).each (c) -> obj[c] = ''
      frases = [obj]

    colWidths = [100].concat _(dicc.variables).collect (v) -> 180
    colWidths.push 300

    $("#frases-table").handsontable
      data: frases
      colHeaders: cols
      minSpareRows: 1
      colWidths: colWidths
      manualColumnResize: true
      outsideClickDeselects: false
      removeRowPlugin: true
      beforeRemoveRow: (index, amount) ->
        entrada = $('#frases-table').handsontable 'getDataAtRow', index
        if entrada._id
          Frases.remove entrada._id

Template.conjuntoFrasesEdit.helpers
  currConjuntoFrases: -> currConjuntoFrases()

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
            _(data).each (p, i) ->
              if p._id
                id = p._id
                delete p._id
                Frases.update id, {$set:p}, (err) ->
                  unless err
                    $( '#frases-table' ).handsontable( 'setDataAtCell', i, 0, id )
                  else
                    console.log err
              else
                delete p._id
                p.conjuntoFrasesId = Session.get 'conjuntoFrasesId'
                Frases.insert p, (err, result) ->
                  unless err
                    $( '#frases-table' ).handsontable( 'setDataAtCell', i, 0, result )
                  else
                    console.log err
    
  'change #variables': (e, tmpl) ->
    console.log e.currentTarget.value
