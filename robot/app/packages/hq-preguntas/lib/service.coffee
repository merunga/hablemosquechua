# PreguntasService =
#   looksLikeOne: (userId, tweet) ->
#     pregunta = null
#     palabra = null

#     ConjuntosPreguntas.find( {userId: userId} ).forEach (cp) ->
#       variables = []
#       Diccionarios.find( _id: { $in: cp.diccionarioIds } ).forEach (d) ->
#         _(d.variables).each (v) ->
#           variables.push v

#       Preguntas.find( conjuntoId: cp._id).forEach (p) ->
#         localAux = p.pregunta.replace /".*"/i, ""
#         externalAux = tweet.replace /".*"/i, ""

#         localAux = new RegExp(localAux,'i')
#         if localAux.match externalAux
#           pregunta = p
#           palabra =
#             palabra: tweet.match( /"(.*)"/i, "" )[1]
#             placeholder: p.pregunta.match( /"(.*)"/i, "" )[1].replace('{','').replace('}','')

#         return false
    
#     if pregunta
#       return {
#         pregunta: pregunta
#         palabra: palabra
#       }
#     else return false


      #_(variables).each (v) ->

# Meteor.startup ->
#   if p = PreguntasService.looksLikeOne 'iJpvsKrPFrcDYpp78', 'como se dice "piedra"?' 
#     if t = DiccionariosService.traducir 'iJpvsKrPFrcDYpp78', p.palabra.palabra, p.palabra.placeholder
#       logger.info HablemosQuechua.replaceVars p.pregunta.respuesta, t
