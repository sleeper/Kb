(function() {

  window.Kb = {
    Models: {},
    Collections: {},
    Views: {},
    Routers: {},
    Raphael: {},
    init: function() {
      var b, bview, container, tickets;
      b = new Kb.Models.Board({
        name: "myboard",
        columns: ['backlog', 'in-progress', 'done'],
        swimlanes: ['projects', 'implementations']
      });
      container = $('#board').get(0);
      tickets = new Kb.Collections.TicketList();
      b.set('tickets', tickets);
      bview = new Kb.Views.BoardView({
        model: b,
        el: container
      });
      bview.render();
      return tickets.reset([
        {
          title: "Buy some bread",
          column: "backlog",
          swimlane: "projects",
          x: 60,
          y: 60
        }, {
          title: "Buy some milk",
          column: "backlog",
          swimlane: "implementations",
          x: 80,
          y: 520
        }
      ]);
    }
  };

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Kb.Models.Board = (function(_super) {

    __extends(Board, _super);

    function Board() {
      return Board.__super__.constructor.apply(this, arguments);
    }

    Board.prototype.defaults = {
      swimlanes: [],
      columns: []
    };

    Board.prototype.url = function() {
      return "/boards/" + this.id;
    };

    Board.prototype.validate = function(attribs) {
      var name_empty;
      name_empty = !attribs.name;
      if (name_empty) {
        return "Name must not be nil or empty";
      } else {
        return null;
      }
    };

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
      swimlane: "",
      x: 0,
      y: 0
    };

    return Ticket;

  })(Backbone.Model);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Kb.Collections.TicketList = (function(_super) {

    __extends(TicketList, _super);

    function TicketList() {
      return TicketList.__super__.constructor.apply(this, arguments);
    }

    TicketList.prototype.model = Kb.Models.Ticket;

    TicketList.prototype.url = function() {
      return "/tickets/";
    };

    return TicketList;

  })(Backbone.Collection);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Kb.Raphael.Cell = (function() {

    function Cell() {}

    Cell.swimlane_height = 400;

    Cell.swimlane_title_width = 50;

    Cell.column_width = 400;

    Cell.column_title_height = 50;

    Cell.prototype.center = function(el) {
      var x, y;
      x = el.attr('x') + (el.attr('width') / 2);
      y = el.attr('y') + (el.attr('height') / 2);
      return [x, y];
    };

    return Cell;

  })();

  Kb.Raphael.DroppableCell = (function(_super) {

    __extends(DroppableCell, _super);

    DroppableCell.prototype.width = Kb.Raphael.Cell.column_width;

    DroppableCell.prototype.height = Kb.Raphael.Cell.swimlane_height;

    function DroppableCell(paper, col_name, sl_name, x, y) {
      this.paper = paper;
      this.col_name = col_name;
      this.sl_name = sl_name;
      this.x = x;
      this.y = y;
    }

    DroppableCell.prototype.compute_absolute_coordinates = function(rx, ry) {
      return [this.x + rx, this.y + ry];
    };

    DroppableCell.prototype.draw = function() {
      var c;
      c = this.paper.rect(this.x, this.y, this.width, this.height);
      c.attr({
        fill: "white"
      });
      c.droppable = this;
      return c;
    };

    return DroppableCell;

  })(Kb.Raphael.Cell);

  Kb.Raphael.SwimlaneTitle = (function(_super) {

    __extends(SwimlaneTitle, _super);

    SwimlaneTitle.prototype.width = Kb.Raphael.Cell.swimlane_title_width;

    SwimlaneTitle.prototype.height = Kb.Raphael.Cell.swimlane_height;

    function SwimlaneTitle(paper, sl_name, x, y) {
      this.paper = paper;
      this.sl_name = sl_name;
      this.x = x;
      this.y = y;
    }

    SwimlaneTitle.prototype.draw = function() {
      var cx, cy, t, text, _ref;
      t = this.paper.rect(this.x, this.y, this.width, this.height);
      t.attr({
        fill: "white"
      });
      _ref = this.center(t), cx = _ref[0], cy = _ref[1];
      text = this.paper.text(cx, cy, this.sl_name);
      text.attr({
        'font-size': 17,
        'font-family': 'FranklinGothicFSCondensed-1, FranklinGothicFSCondensed-2'
      });
      text.attr("fill", "black");
      return text.rotate(-90);
    };

    return SwimlaneTitle;

  })(Kb.Raphael.Cell);

  Kb.Raphael.ColumnTitle = (function(_super) {

    __extends(ColumnTitle, _super);

    ColumnTitle.prototype.width = Kb.Raphael.Cell.column_width;

    ColumnTitle.prototype.height = Kb.Raphael.Cell.column_title_height;

    function ColumnTitle(paper, name, x, y) {
      this.paper = paper;
      this.name = name;
      this.x = x;
      this.y = y;
    }

    ColumnTitle.prototype.draw = function() {
      var cx, cy, t, text, _ref;
      t = this.paper.rect(this.x, this.y, this.width, this.height);
      t.attr({
        fill: "white"
      });
      _ref = this.center(t), cx = _ref[0], cy = _ref[1];
      text = this.paper.text(cx, cy, this.name);
      text.attr({
        'font-size': 17,
        'font-family': 'FranklinGothicFSCondensed-1, FranklinGothicFSCondensed-2'
      });
      return text.attr("fill", "black");
    };

    return ColumnTitle;

  })(Kb.Raphael.Cell);

  Kb.Raphael.CellCache = (function() {

    function CellCache() {
      this._cache = {};
    }

    CellCache.prototype.hash = function(col_name, sl_name) {
      return "" + col_name + "-" + sl_name;
    };

    CellCache.prototype.put = function(droppable) {
      return this._cache[this.hash(droppable.col_name, droppable.sl_name)] = droppable;
    };

    CellCache.prototype.get = function(col_name, sl_name) {
      return this._cache[this.hash(col_name, sl_name)];
    };

    return CellCache;

  })();

  Kb.Raphael.Board = (function() {

    function Board(model, el) {
      var jnode, _ref;
      this.model = model;
      this.el = el;
      this._cells = new Kb.Raphael.CellCache();
      _ref = this.compute_sizes(), this.width = _ref[0], this.height = _ref[1];
      jnode = $(this.el);
      jnode.width(this.width);
      jnode.height(this.height);
      this.paper = Raphael(this.el, this.width, this.height);
    }

    Board.prototype.compute_sizes = function() {
      var cth, cw, height, sh, stw, width;
      cw = Kb.Raphael.Cell.column_width;
      stw = Kb.Raphael.Cell.swimlane_title_width;
      sh = Kb.Raphael.Cell.swimlane_height;
      cth = Kb.Raphael.Cell.column_title_height;
      width = this.model.get('columns').length * cw + stw + 2;
      height = this.model.get('swimlanes').length * sh + cth + 2;
      return [width, height];
    };

    Board.prototype.compute_absolute_coordinates = function(cl_name, sl_name, rx, ry) {
      var cell;
      cell = this._cells.get(cl_name, sl_name);
      return cell.compute_absolute_coordinates(rx, ry);
    };

    Board.prototype.drawCells = function() {
      var c, cells, cl, ctitle, sl, x, y, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _results;
      cells = [];
      x = Kb.Raphael.Cell.swimlane_title_width;
      _ref = this.model.get('columns');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cl = _ref[_i];
        y = 0;
        ctitle = new Kb.Raphael.ColumnTitle(this.paper, cl, x, y);
        ctitle.draw();
        y += Kb.Raphael.Cell.column_title_height;
        _ref1 = this.model.get('swimlanes');
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          sl = _ref1[_j];
          c = new Kb.Raphael.DroppableCell(this.paper, cl, sl, x, y);
          c.draw();
          this._cells.put(c);
          y += Kb.Raphael.Cell.swimlane_height;
        }
        x += Kb.Raphael.Cell.column_width;
      }
      x = 0;
      y = Kb.Raphael.Cell.column_title_height;
      _ref2 = this.model.get('swimlanes');
      _results = [];
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        sl = _ref2[_k];
        sl = new Kb.Raphael.SwimlaneTitle(this.paper, sl, x, y);
        sl.draw();
        _results.push(y += Kb.Raphael.Cell.swimlane_height);
      }
      return _results;
    };

    Board.prototype.draw = function() {
      return this.drawCells();
    };

    return Board;

  })();

}).call(this);
(function() {

  Kb.Raphael.Ticket = (function() {

    Ticket.prototype.width = 70;

    Ticket.prototype.height = 90;

    function Ticket(board, model) {
      this.model = model;
      this.paper = board.paper;
    }

    Ticket.prototype.draw = function() {
      console.log("Rendering ticket '" + (this.model.get('title')) + "'");
      return this.paper.rect(this.model.get('x'), this.model.get('y'), this.width, this.height);
    };

    return Ticket;

  })();

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Kb.Views.TicketView = (function(_super) {

    __extends(TicketView, _super);

    function TicketView() {
      this.render = __bind(this.render, this);
      return TicketView.__super__.constructor.apply(this, arguments);
    }

    TicketView.prototype.initialize = function() {
      this.boardview = this.options.boardview;
      return this.bind('change', this.render);
    };

    TicketView.prototype.render = function() {
      var t;
      t = new Kb.Raphael.Ticket(this.boardview.svgboard, this.model);
      return t.draw(this.el);
    };

    return TicketView;

  })(Backbone.View);

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
      this.model.get('tickets').bind('add', this.addOne, this);
      this.model.get('tickets').bind('reset', this.addAll, this);
      this.model.get('tickets').bind('all', this.render, this);
      this.svgboard = new Kb.Raphael.Board(this.model, this.el);
      return this.svgboard.draw();
    };

    BoardView.prototype.addOne = function() {
      return console.log("One ticket added. Render it");
    };

    BoardView.prototype.addAll = function() {
      var _this = this;
      return this.model.get('tickets').each(function(t) {
        var view;
        console.log("Adding ticket '" + t.get('title') + "'");
        view = new Kb.Views.TicketView({
          model: t,
          boardview: _this
        });
        return view.render();
      });
    };

    BoardView.prototype.render = function() {
      return console.log("Rendering board");
    };

    return BoardView;

  })(Backbone.View);

}).call(this);
