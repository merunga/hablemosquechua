Template.followerList.helpers
  followers: ->
    if Followers.find().count()
      Followers.find()
    else false
