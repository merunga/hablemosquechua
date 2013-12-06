Meteor.publish 'followers', ->
  Followers.find( { robotId: @userId }, { sort: { respuestasCorrectas: -1 } } )
