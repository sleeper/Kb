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
    tickets.reset [
      {title: "Buy some bread", column: "backlog", swimlane: "projects"},
      {title: "Buy some milk", column: "backlog", swimlane: "implementations"}
    ]
    b.set('tickets', tickets)
    bview = new Kb.Views.BoardView( model: b, el: container )

