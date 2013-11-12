Router.configure
  layoutTemplate: 'layout'
  notFoundTemplate: 'notFound'
  loadingTemplate: 'loading'
  before: ->
    routeName = @route.name
    publicRoutes = [
      'login'
    ]
  
    return  if _(publicRoutes).include routeName

    user = Meteor.user()
    unless user
      if Meteor.loggingIn()
        @render @loadingTemplate
      else
        Router.go 'login'
      @stop()

Router.map ->
  @route "home",
    path: "/"
    before: ->
      @redirect 'diccionarioList'

  @route "login",
    path: "/login"
    after: ->
      if Meteor.user()
        @redirect 'home'
