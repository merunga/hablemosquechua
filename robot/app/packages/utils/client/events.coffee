@Events = _.extend {},
  listenTo: ( evtName ) ->
    Session.get evtName

  emit: ( evtName ) ->
    Session.set evtName, 'event-'+Math.random()

  on: ( evtName, cb ) ->
  	Events.listenTo evtName
  	cb()