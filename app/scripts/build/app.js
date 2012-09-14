var App;

App = (function() {
  var config;

  config = {
    name: "myboard",
    el: 'board',
    columns: ['backlog', 'in-progress', 'done'],
    swimlanes: ['projects', 'implementations']
  };

  function App() {
    var app_router;
    Kb.init(config);
    Kb.board.get('tickets').reset([
      {
        title: "Buy some bread",
        column: "backlog",
        swimlane: "projects",
        x: 60,
        y: 60,
        avatar: "Skull 2.png"
      }, {
        title: "Buy some milk",
        column: "in-progress",
        swimlane: "implementations",
        x: 80,
        y: 60,
        avatar: "Hulk-01.png"
      }
    ]);
    app_router = new Kb.Routers.AppRouter;
    Backbone.history.start({
      pushState: true,
      root: "/index.html"
    });
  }

  return App;

})();

new App;
