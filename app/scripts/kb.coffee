window.Kb = 
  Models:      {}
  Collections: {}
  Views:       {}
  Routers:     {}
  Raphael:     {}


  # Initialize our board
  # The furnished object contains the configuration to be used
  #  name: the name of the board
  #  el: id of the DOM element to attach the board to
  #  columns: an array of the columns of our board
  #  swimlanes: an array of the swimlane of our board
  init: (cfg) ->
    # FIXME: Validate all needed cfg items are present
    Kb.board = new Kb.Models.Board
        name: cfg.name,
        columns: cfg.columns,
        swimlanes: cfg.swimlanes

    container = $('#'+cfg.el).get(0)

    tickets = new Kb.Collections.TicketList();
    users = new Kb.Collections.UserList();
    Kb.board.set('tickets', tickets)
    Kb.board.set('users', users)
    bview = new Kb.Views.BoardView( model: Kb.board, el: container )
    bview.render()
    pbview = new Kb.Views.ProductBacklogView( model: Kb.board, el: $('#product_backlog'))
    pbview.render()
    pbview.toggle()
    $('#toggle_mode').on 'click', () => 
      bview.toggle()
      pbview.toggle()


