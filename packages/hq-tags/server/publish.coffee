Meteor.publish 'tags', ->
  Tags.find { userId: @userId }, sort: { tag: 1 }
