window.Kb = 
  Models:      {}
  Collections: {}
  Views:       {}
  Routers:     {}
  Raphael:     {}

  init: () ->
    b = new Kb.Models.Board
        name: "myboard",
        columns: ['backlog', 'in-progress', 'done'],
        swimlanes: ['projects', 'implementations']

    container = $('#board').get(0)

    tickets = new Kb.Collections.TicketList();
    b.set('tickets', tickets)
    bview = new Kb.Views.BoardView( model: b, el: container )
    bview.render()
    tickets.reset [
      {title: "Buy some bread", column: "backlog", swimlane: "projects", x: 60, y:60 },
      {title: "Buy some milk", column: "in-progress", swimlane: "implementations", x:80, y: 60}
    ]
