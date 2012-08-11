window.Kb = 
  Models:      {}
  Collections: {}
  Views:       {}
  Routers:     {}
  Raphael:     {}

  init: () ->
    b = new Kb.Models.Board ['backlog', 'in-progress', 'done'],
                            ['projects', 'implementations']
    new Kb.Views.BoardView( model: b )

