var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Kb.Views.BoardView = (function(_super) {

  __extends(BoardView, _super);

  function BoardView() {
    this.render = __bind(this.render, this);
    return BoardView.__super__.constructor.apply(this, arguments);
  }

  BoardView.prototype.initialize = function() {
    this.model.get('tickets').bind('add', this.addOne, this);
    this.model.get('tickets').bind('reset', this.addAll, this);
    this.model.get('tickets').bind('all', this.render, this);
    this.svgboard = new Kb.Raphael.Board(this.model, this.el);
    return this.svgboard.draw();
  };

  BoardView.prototype.addOne = function(ticket) {
    var view;
    console.log("Ticket '" + (ticket.get('title')) + "' added. Let's render it");
    view = new Kb.Views.TicketView({
      model: ticket,
      boardview: this
    });
    return view.render();
  };

  BoardView.prototype.addAll = function() {
    var _this = this;
    return this.model.get('tickets').each(function(t) {
      console.log("Adding ticket '" + t.get('title') + "'");
      return _this.addOne(t);
    });
  };

  BoardView.prototype.render = function() {
    return console.log("Rendering board");
  };

  return BoardView;

})(Backbone.View);
