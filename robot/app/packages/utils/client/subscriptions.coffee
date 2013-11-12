Subscriptions = _.extend {},
  begin: () ->
    subsName = arguments[0]
    @[subsName] = Meteor.subscribe arguments...
    return @[subsName]
