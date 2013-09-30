getWeekDaysCount = (d1, d2) ->
  aDay = 24 * 60 * 60 * 1000

  week = [] # day zerp remians empty
  _([0..7]).each (wd) ->
    week[wd] = 0

  d = undefined
  i = d1.getTime()
  n = d2.getTime()

  while i <= n
    d = new Date(i).getDay()
    week[d+1]++
    i += aDay

  return week

Meteor.methods
  'calcularTweetCount': (rules) ->
    weekDaysCount = getWeekDaysCount rules.desde, rules.hasta
    count = 0
    Schedules.find( { _id: { $in: rules.scheduleIds } } ).forEach (s) ->
      EntradasSchedule.find( scheduleId: s._id ).forEach (e) ->
        _(e.diasDeLaSemana).each (ddls) ->
          count += weekDaysCount[ddls] * e.horas.length * e.minutos.length
    return count
