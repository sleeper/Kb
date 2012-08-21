window.Kb = 
  Models:      {}
  Collections: {}
  Views:       {}
  Routers:     {}
  Raphael:     {}

  init: () ->
    b = new Kb.Models.Board
        columns: ['backlog', 'in-progress', 'done'],
        swimlanes: ['projects', 'implementations']

    container = $('#board').get(0)

    bview = new Kb.Views.BoardView( model: b, el: container )

