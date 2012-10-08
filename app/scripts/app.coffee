class App
  config =
    name: "myboard",
    el: 'board',
    columns: [ 'backlog', 'in-progress', 'done' ],
    swimlanes: ['projects', 'implementations']

  constructor: ()->
    Kb.init config
    Kb.board.get('users').reset [
      {id: 1, name: "fred", avatar: 'Iron Man Mark VI-01.png'},
      {id: 2, name: "joe", avatar: 'Vampire.png'},
      {id: 3, name: "boozie", avatar: 'Ghoul.png'},
    ]
    Kb.board.get('tickets').reset [
        {id: 1, title: "Buy some bread", status: 'board', column: "backlog", swimlane: "projects", x: 60, y:60, user_id: 1, created_on: "2012-09-20 15:32:12", entered_on: "2012-09-22 09:23:21", comment:" This is a simple task just to check"},
        {id: 2, title: "Buy some milk", status: 'board', column: "in-progress", swimlane: "implementations", x:80, y: 60, user_id: 2, created_on: "2012-09-21 17:32:12", entered_on: "2012-09-23 19:13:11", comment:" This is a simple task just to check"}
        {id: 3, title: "Start working", status: 'board', column: "backlog", swimlane: "implementations", x:80, y: 60, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "2012-09-23 19:13:11", comment:"This is the most ennoying ticket ever written"}
        {id: 4, title: "Still thinking about it", status: 'backlog', column: "", swimlane: "", x:0, y:0, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "", comment:"This is the most ennoying ticket ever written"}
        {id: 5, title: "Are you sure ?", status: 'backlog', column: "", swimlane: "", x:0, y: 0, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "", comment:"This is the most ennoying ticket ever written"}
      ]
    Kb.board.current_user = Kb.board.get('users').get(3)

    # Instantiate the router
    app_router = new Kb.Routers.AppRouter({tickets: Kb.board.get('tickets')})
    # Start Backbone history a neccesary step for bookmarkable URL's
#    Backbone.history.start({pushState: true, root: "/index.html"})
    Backbone.history.start({root: "/index.html"})

new App

