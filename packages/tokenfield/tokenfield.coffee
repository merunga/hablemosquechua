Tokenfield =
  init: (sel) ->
    $tf = if sel then $(sel) else $('[data-widgettype=tokenfield]')
    $tf.tokenfield()