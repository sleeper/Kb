(function() {

  window.Kb = {
    Models: {},
    Collections: {},
    Views: {},
    Routers: {},
    Raphael: {},
    init: function() {
      var b;
      b = new Kb.Models.Board(['backlog', 'in-progress', 'done'], ['projects', 'implementations']);
      return new Kb.Views.BoardView({
        model: b
      });
    }
  };

}).call(this);
(function() {
  var b,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Kb.Models.Board = (function(_super) {

    __extends(Board, _super);

    Board.prototype.width = 1000;

    Board.prototype.height = 1000;

    function Board(columns, swimlanes) {
      this.columns = columns;
      this.swimlanes = swimlanes;
      this.on("change", function() {
        return console.log("Something changed");
      });
    }

    return Board;

  })(Backbone.Model);

  b = new Kb.Models.Board(['backlog', 'in-progress', 'done'], ['projects', 'implementations']);

}).call(this);
(function() {

  Kb.Raphael.Board = (function() {

    function Board() {}

    Board.prototype.swimlane_height = 400;

    Board.prototype.column_width = 400;

    Board.prototype.drawCell = function(column_name, swimlane_name, x, y, width, height) {
      var c;
      c = this.paper.rect(x, y, width, height);
      c.attr({
        fill: "white"
      });
      c.column = column_name;
      c.swimlane = swimlane_name;
      c.cell = true;
      this.cells.push(c);
      return c;
    };

    Board.prototype.draw = function(el, model) {
      var c, cl, height, sl, width, x, y, _i, _j, _len, _len1, _ref, _ref1, _results;
      this.model = model;
      width = this.model.columns.length * this.column_width;
      height = this.model.swimlanes.length * this.swimlane_height;
      this.paper = Raphael(0, 0, width, height);
      this.cells = [];
      x = 0;
      _ref = this.model.columns;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cl = _ref[_i];
        y = 0;
        _ref1 = this.model.swimlanes;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          sl = _ref1[_j];
          c = this.drawCell(cl, sl, x, y, this.column_width, this.swimlane_height);
          y += this.swimlane_height;
        }
        _results.push(x += this.column_width);
      }
      return _results;
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

    BoardView.prototype.el = $('#board');

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
