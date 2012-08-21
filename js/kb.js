(function() {

  window.Kb = {
    Models: {},
    Collections: {},
    Views: {},
    Routers: {},
    Raphael: {},
    init: function() {
      var b, bview, container;
      b = new Kb.Models.Board(['backlog', 'in-progress', 'done'], ['projects', 'implementations']);
      container = $('#board').get(0);
      return bview = new Kb.Views.BoardView({
        model: b,
        el: container
      });
    }
  };

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Kb.Collections.TicketList = (function(_super) {

    __extends(TicketList, _super);

    function TicketList() {
      return TicketList.__super__.constructor.apply(this, arguments);
    }

    TicketList.prototype.url = '/tickets/';

    return TicketList;

  })(Backbone.Collection);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Kb.Models.Board = (function(_super) {

    __extends(Board, _super);

    function Board(columns, swimlanes) {
      this.columns = columns;
      this.swimlanes = swimlanes;
      this.on("change", function() {
        return console.log("Something changed");
      });
    }

    return Board;

  })(Backbone.Model);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Kb.Models.Ticket = (function(_super) {

    __extends(Ticket, _super);

    function Ticket() {
      return Ticket.__super__.constructor.apply(this, arguments);
    }

    Ticket.prototype.defaults = {
      title: "",
      column: "",
      swimlane: ""
    };

    return Ticket;

  })(Backbone.Model);

}).call(this);
(function() {

  Kb.Raphael.Board = (function() {

    function Board() {}

    Board.prototype.swimlane_height = 400;

    Board.prototype.swimlane_title_width = 50;

    Board.prototype.column_width = 400;

    Board.prototype.column_title_height = 50;

    Board.prototype.drawCell = function(column_name, swimlane_name, x, y) {
      var c;
      c = this.paper.rect(x, y, this.column_width, this.swimlane_height);
      c.attr({
        fill: "white"
      });
      c.column = column_name;
      c.swimlane = swimlane_name;
      c.cell = true;
      return c;
    };

    Board.prototype.compute_sizes = function() {
      var height, width;
      width = this.model.columns.length * this.column_width + this.swimlane_title_width + 2;
      height = this.model.swimlanes.length * this.swimlane_height + this.column_title_height + 2;
      return [width, height];
    };

    Board.prototype.center = function(el) {
      var x, y;
      x = el.attr('x') + (el.attr('width') / 2);
      y = el.attr('y') + (el.attr('height') / 2);
      return [x, y];
    };

    Board.prototype.drawSwimlaneTitle = function(sl, x, y) {
      var cx, cy, t, text, _ref;
      t = this.paper.rect(x, y, this.swimlane_title_width, this.swimlane_height);
      t.attr({
        fill: "white"
      });
      _ref = this.center(t), cx = _ref[0], cy = _ref[1];
      text = this.paper.text(cx, cy, sl);
      text.attr({
        'font-size': 17,
        'font-family': 'FranklinGothicFSCondensed-1, FranklinGothicFSCondensed-2'
      });
      text.attr("fill", "black");
      return text.rotate(-90);
    };

    Board.prototype.drawColumnTitle = function(cl, x, y) {
      var cx, cy, t, text, _ref;
      t = this.paper.rect(x, y, this.column_width, this.column_title_height);
      t.attr({
        fill: "white"
      });
      _ref = this.center(t), cx = _ref[0], cy = _ref[1];
      text = this.paper.text(cx, cy, cl);
      text.attr({
        'font-size': 17,
        'font-family': 'FranklinGothicFSCondensed-1, FranklinGothicFSCondensed-2'
      });
      return text.attr("fill", "black");
    };

    Board.prototype.drawCells = function() {
      var c, cells, cl, sl, x, y, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      cells = [];
      x = this.swimlane_title_width;
      _ref = this.model.columns;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cl = _ref[_i];
        y = 0;
        this.drawColumnTitle(cl, x, y);
        y += this.column_title_height;
        _ref1 = this.model.swimlanes;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          sl = _ref1[_j];
          c = this.drawCell(cl, sl, x, y);
          cells.push(c);
          y += this.swimlane_height;
        }
        x += this.column_width;
      }
      x = 0;
      y = this.column_title_height;
      _ref2 = this.model.swimlanes;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        sl = _ref2[_k];
        this.drawSwimlaneTitle(sl, x, y);
        y += this.swimlane_height;
      }
      return cells;
    };

    Board.prototype.draw = function(el, model) {
      var height, jnode, width, _ref;
      this.model = model;
      _ref = this.compute_sizes(), width = _ref[0], height = _ref[1];
      jnode = $(el);
      jnode.width(width);
      jnode.height(height);
      this.paper = Raphael(el, width, height);
      return this.cells = this.drawCells();
    };

    return Board;

  })();

}).call(this);
(function() {
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
      return this.render();
    };

    BoardView.prototype.render = function() {
      var b;
      b = new Kb.Raphael.Board;
      return b.draw(this.el, this.model);
    };

    return BoardView;

  })(Backbone.View);

}).call(this);
