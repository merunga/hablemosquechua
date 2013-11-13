DiccionariosService =
  traducir: (userId, palabra, varName) ->
    filter =
      userId: userId
    filter[varName] = palabra
    return PalabrasDiccionario.findOne filter
