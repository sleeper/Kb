
window.Kb = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  Raphael: {},
  init: function(cfg) {
    var bview, container, tickets;
    Kb.board = new Kb.Models.Board({
      name: cfg.name,
      columns: cfg.columns,
      swimlanes: cfg.swimlanes
    });
    container = $('#' + cfg.el).get(0);
    tickets = new Kb.Collections.TicketList();
    Kb.board.set('tickets', tickets);
    bview = new Kb.Views.BoardView({
      model: Kb.board,
      el: container
    });
    return bview.render();
  }
};
