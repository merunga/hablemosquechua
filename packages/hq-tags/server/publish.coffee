Meteor.publish 'tags', ->
  Tags.find { userId: @userId }, sort: { nombre:1 }
