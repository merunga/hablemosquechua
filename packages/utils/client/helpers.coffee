register = Handlebars.registerHelper

register 'arrToString', (arrAsStr) ->
  arrAsStr.join ', '

register 'count', (cursor) ->
  return cursor.count() if cursor.count

register 'moment', (date, format='L') ->
  return moment( date ).format format

register 'momentDetail', (date) ->
  return moment( date ).format 'D [de] MMMM [de] YYYY, [a las] h:mm:ss a'

register 'currency', (value)->
  return Utils.currency value

register 'decimal', (value)->
  return Utils.decimal value

register 'log', (it) ->
  console.log it

register 'subs', (a, b) ->
  a - b

register 'print', (it) ->
  if it then it else ''

register 'render', (template, data) ->
  Template[template]( data or {} )

register '$eq', (one, another) ->
  return one is another

register '$in', (one, another) ->
  return _(another).contains one

register '$or', (one, another) ->
  return one or another

register '$eqOrIn', (one, another) ->
  unless _(another).isArray()
    return one is another
  else
    return _(another).contains one

register '$not', (that) ->
  not that

register 'defaultValue', (val, defaultVal) ->
  return if val then val else defaultVal

register 'modalLoginOpen', ->
  return Session.get('modalLoginOpen') or Session.get('loginPage')

meses = [
    {value: '', label: ''}
    {value: 1,  label: 'Enero'}
    {value: 2,  label: 'Febrero'}
    {value: 3,  label: 'Marzo'}
    {value: 4,  label: 'Abril'}
    {value: 5,  label: 'Mayo'}
    {value: 6,  label: 'Junio'}
    {value: 7,  label: 'Julio'}
    {value: 8,  label: 'Agosto'}
    {value: 9,  label: 'Setiembre'}
    {value: 10, label: 'Octubre'}
    {value: 11, label: 'Noviembre'}
    {value: 12, label: 'Diciembre'}
  ]

register 'meses', ->
  return meses

register 'mesStr', (numMes) ->
  if numMes
    r = _(meses).find (m) ->
      m.value is numMes
    r?.label

register 'random', ->
  Math.random()