Tokenfield =
  init: (sel) ->
    $tf = if sel then $(sel) else $('[data-widgettype=tokenfield]')
    if $tf.attr( 'disabled' )
      $tf.tokenfield 'disable'
    else
      $tf.tokenfield()
