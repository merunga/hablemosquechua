deepen = (o) ->
  oo = {}
  t = undefined
  parts = undefined
  part = undefined
  for k of o
    t = oo
    parts = k.split(".")
    key = parts.pop()
    while parts.length
      part = parts.shift()
      t = t[part] = t[part] or {}
    t[key] = o[k]
  oo

$.fn.formToJSON = ->
  unindexed_array = $(this).serializeArray()
  indexed_array = {}
  self = this
  $.map unindexed_array, (n, i) ->
    currVal = indexed_array[n['name']]

    value = n['value']
    name = n['name']
    if $(self).find( "[name='#{name}'][type=number]" ).length
      try
        value = parseFloat n['value']
      catch e1
        try 
          value = parseInt n['value']
        catch e2
          value = value

    if $(self).find( "[name='#{name}'][data-asarray]" ).length
      value = n['value'].split ', '

    unless currVal
      indexed_array[n['name']] = value
    else
      unless _(indexed_array[n['name']]).isArray()
        indexed_array[n['name']] = [currVal]
      if _(value).isArray()
        indexed_array[n['name']] = _(value).union indexed_array[n['name']]
      else
        indexed_array[n['name']].push value

  return deepen indexed_array
