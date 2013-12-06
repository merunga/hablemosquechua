Router.map ->
  @route 'followerList',
    path: '/follower/listar'
    waitOn: ->
      Subscriptions.begin 'followers'