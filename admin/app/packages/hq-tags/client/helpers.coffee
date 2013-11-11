Handlebars.registerHelper 'tagsInputOptions', ->
  tags = []
  Tags.find().forEach (t) ->
    tags.push t.tag
  tags

Handlebars.registerHelper 'tagsInput', (args) ->
  new Handlebars.SafeString Template._tagsInput( args.hash )

TagsInput =
  init: (tmpl) ->
    $( tmpl.findAll 'select[data-extra="tags-input"]' ).each (i,s) ->
      $(s).chosen
        allow_custom_value: true
        search_contains: true
        width: $(s).data('width')
        allow_single_deselect: true
