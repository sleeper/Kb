class App
  config =
    name: "myboard",
    el: 'board',
    columns: [ 'backlog', 'in-progress', 'done' ],
    swimlanes: ['projects', 'implementations']

  constructor: ()->
    Kb.init config
    Kb.board.get('tickets').reset [
        {id: 1, title: "Buy some bread", column: "backlog", swimlane: "projects", x: 60, y:60, avatar: "Skull 2.png" },
        {id: 2, title: "Buy some milk", column: "in-progress", swimlane: "implementations", x:80, y: 60, avatar: "Hulk-01.png"}
      ]
    # Instantiate the router
    app_router = new Kb.Routers.AppRouter
    # Start Backbone history a neccesary step for bookmarkable URL's
#    Backbone.history.start({pushState: true, root: "/index.html"})
    Backbone.history.start({root: "/index.html"})

new App

