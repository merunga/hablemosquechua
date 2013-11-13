TraduccionesService =
  looksLikeOne: (userId, tweet) ->
    traduccion = null
    palabra = null

    ConjuntosTraducciones.find( {userId: userId} ).forEach (cp) ->
      variables = []
      Diccionarios.find( _id: { $in: cp.diccionarioIds } ).forEach (d) ->
        _(d.variables).each (v) ->
          variables.push v

      Traducciones.find( conjuntoId: cp._id).forEach (p) ->
        localAux = p.traduccion.replace /".*"/i, ""
        externalAux = tweet.replace /".*"/i, ""

        if localAux is externalAux
          traduccion = p
          palabra =
            palabra: tweet.match( /"(.*)"/i, "" )[1]
            placeholder: p.traduccion.match( /"(.*)"/i, "" )[1].replace('{','').replace('}','')
    
    if traduccion
      return {
        traduccion: traduccion
        palabra: palabra
      }
    else return false


      #_(variables).each (v) ->

# Meteor.startup ->
#   if p = TraduccionesService.looksLikeOne 'iJpvsKrPFrcDYpp78', 'como se dice "piedra"?' 
#     if t = DiccionariosService.traducir 'iJpvsKrPFrcDYpp78', p.palabra.palabra, p.palabra.placeholder
#       logger.info HablemosQuechua.replaceVars p.traduccion.respuesta, t
