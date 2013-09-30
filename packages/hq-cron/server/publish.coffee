Meteor.publish 'schedule', (id) ->
  [
    Schedules.find( _id: id ),
    EntradasSchedule.find scheduleId: id
  ]

Meteor.publish 'schedules', ->
  [
    Schedules.find( { userId: @userId }, { sort: { createdAt: -1 } } ),
    AggregationSchedule.find userId: @userId
  ]

Meteor.publish 'schedulesAutocomplete', ->
  Schedules.find userId: @userId,
    sort: { nombre: 1 }
    fields: { nombre: 1 }