weeksBetween = (d1, d2) ->
  aDay = 24 * 60 * 60 * 1000

  weeks = {}
  _([0..7]).each (wd) ->
    weeks[wd] = []

  d = undefined
  i = d1.getTime()
  n = d2.getTime()

  while i <= n
    date = new Date(i)
    d = date.getDay()
    # day zero remains empty: mon=1 ... sun=7
    if d is 0
      d = 7
    else
      d + 1 
    weeks[d].push date
    i += aDay

  return weeks

Meteor.methods
  'calcularTweetCount': (rules) ->
    weeks = weeksBetween rules.desde, rules.hasta
    console.log weeks
    count = 0
    Schedules.find( { _id: { $in: rules.scheduleIds } } ).forEach (s) ->
      EntradasSchedule.find( scheduleId: s._id ).forEach (e) ->
        _(e.diasDeLaSemana).each (ddls) ->
          count += weeks[ddls].length * e.horas.length * e.minutos.length
    return count
