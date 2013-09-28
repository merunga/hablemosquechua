Router.configure
  layout: 'layout'
  notFoundTemplate: 'notFound'
  loadingTemplate: 'loading'
  before: ->
    routeName = @context.route.name
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
    onBeforeRun: ->
      @redirect 'diccionarioList'

  @route "login",
    path: "/login"
    onAfterRun: ->
      if Meteor.user()
        @redirect 'home'
