Meteor.startup ->
  moment.lang 'es'

Utils =
  round: (num, decimals=2) ->
    return Math.round(num*Math.pow(10,decimals))/Math.pow(10,decimals)
  userIs: (role, userId=null) ->
    userId = Meteor.userId() unless userId
    Roles.userIsInRole userId, [role]
  failIfUserIsnt: (role) ->
    throw new Meteor.Error 'Forbidden' unless @userIs role
  currency: (value) ->
    accounting.formatMoney(value, "S/. ", 2, ".", ",")
  decimal: (value) ->
    accounting.formatMoney(value, "", 2, ".", ",")    
  moment: (date, format='L') ->
    moment( date ).format format
  now: (format='L') ->
    @moment Date.now(), format
  isDevelOrTest: ->
    if Meteor.isClient
      env = Session.get 'ENV'
    else if Meteor.isServer
      env = process.env.ENV
    return env is 'development' or env is 'test'
  constValues: (obj) ->
    _(_( obj ).values()).filter (it) -> typeof it is 'string'
  parseNumber: (num) ->
    if result = parseFloat num
      return result
    else
      return parseInt num

if Meteor.isClient
  Utils = _.extend Utils,
    setTitle: (titulo) ->
      if titulo
        document.title = titulo
      return undefined

    defaultEvents: 
      'click a[target=_blank]': (e,tmpl) ->
        e.preventDefault()
        url = $(e.currentTarget).attr 'href'
        window.open url
        return false

  Meteor.startup ->
    Meteor.call 'getENV', (error, result) ->
      console.log( error ) if error
      Session.set 'ENV', result
