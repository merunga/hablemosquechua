Template.diccionarioEdit.rendered = ->
  Tokenfield.init()


Template.diccionarioEdit.events
  'submit #editDiccionarioForm': (e) ->
    e.preventDefault()
    dicc = $(e.currentTarget).formToJSON()
    Diccionarios.insert dicc
    
  'change #variables': (e, tmpl) ->
    console.log e.currentTarget.value