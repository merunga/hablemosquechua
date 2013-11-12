Handlebars.registerHelper 'autocomplete', (args) ->
  new Handlebars.SafeString Template._autocomplete(args.hash)

Template._autocomplete.helpers
  label: (it) ->
    if _(it).isObject()
      return it.label
    else
      return it

  value: (it) ->
    if _(it).isObject()
      return it.value
    else
      return it