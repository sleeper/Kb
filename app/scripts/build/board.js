var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Kb.Raphael.Cell = (function() {

  function Cell() {}

  Cell.swimlane_height = 600;

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

  DroppableCell.prototype.hovered_color = "rgb(227,225,226)";

  DroppableCell.prototype.background_color = "white";

  DroppableCell.prototype.width = Kb.Raphael.Cell.column_width;

  DroppableCell.prototype.height = Kb.Raphael.Cell.swimlane_height;

  function DroppableCell(paper, col_name, sl_name, x, y) {
    this.paper = paper;
    this.col_name = col_name;
    this.sl_name = sl_name;
    this.x = x;
    this.y = y;
    this.dropped = __bind(this.dropped, this);

    this.left = __bind(this.left, this);

    this.entered = __bind(this.entered, this);

    this.scope = this;
    eve.on("cell.leaving", this.left);
    eve.on('cell.entering', this.entered);
    eve.on('cell.dropped', this.dropped);
  }

  DroppableCell.prototype.compute_absolute_coordinates = function(rx, ry) {
    return [this.x + rx, this.y + ry];
  };

  DroppableCell.prototype.compute_relative_coordinates = function(ax, ay) {
    return [ax - this.x, ay - this.y];
  };

  DroppableCell.prototype.isPointInside = function(x, y) {
    return this.el.isPointInside(x, y);
  };

  DroppableCell.prototype.entered = function(col, sl) {
    if (col === this.col_name && sl === this.sl_name) {
      return this.el.attr({
        fill: this.hovered_color
      });
    }
  };

  DroppableCell.prototype.left = function(col, sl) {
    if (col === this.col_name && sl === this.sl_name) {
      return this.el.attr({
        fill: this.background_color
      });
    }
  };

  DroppableCell.prototype.dropped = function(col, sl) {
    if (col === this.col_name && sl === this.sl_name) {
      return this.el.attr({
        fill: this.background_color
      });
    }
  };

  DroppableCell.prototype.draw = function() {
    this.el = this.paper.rect(this.x, this.y, this.width, this.height);
    this.el.attr({
      fill: this.background_color,
      'stroke-linejoin': "round",
      'stroke-width': 3
    });
    this.el.droppable = this;
    return this.el;
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
    var bbox, cx, cy, t, text, _ref;
    t = this.paper.rect(this.x, this.y, this.width, this.height);
    t.attr({
      fill: "white",
      stroke: "none"
    });
    _ref = this.center(t), cx = _ref[0], cy = _ref[1];
    text = this.paper.print(cx, cy, this.sl_name, this.paper.getFont("Yanone Kaffeesatz Bold"), 40, "middle");
    bbox = text.getBBox();
    text.transform("R-90T-" + (bbox.width / 2 + 10) + ",0");
    return text.attr("fill", "black");
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
    var bbox, cx, cy, t, text, _ref;
    t = this.paper.rect(this.x, this.y, this.width, this.height);
    t.attr({
      fill: "white",
      stroke: "none"
    });
    _ref = this.center(t), cx = _ref[0], cy = _ref[1];
    text = this.paper.print(cx, cy, this.name, this.paper.getFont("Yanone Kaffeesatz Bold"), 40, "middle");
    bbox = text.getBBox();
    text.transform("t-" + (bbox.width / 2) + ",-5");
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

  CellCache.prototype.forEach = function(cb) {
    return $.each(this._cache, cb);
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
    $(window).resize(function() {
      return $('.ticket').trigger('window:resized');
    });
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

  Board.prototype.compute_relative_coordinates = function(cl_name, sl_name, ax, ay) {
    var cell;
    cell = this._cells.get(cl_name, sl_name);
    return cell.compute_relative_coordinates(ax, ay);
  };

  Board.prototype.getCellByPoint = function(x, y) {
    var cell;
    cell = null;
    this._cells.forEach(function(k, c) {
      if (c.isPointInside(x, y)) {
        cell = c;
        return false;
      }
    });
    return cell;
  };

  Board.prototype.getColumnAndSwimlane = function(x, y) {
    var cell, column, swimlane, _ref, _ref1;
    _ref = [null, null], column = _ref[0], swimlane = _ref[1];
    cell = this.getCellByPoint(x, y);
    if (cell !== null) {
      _ref1 = [cell.col_name, cell.sl_name], column = _ref1[0], swimlane = _ref1[1];
    }
    return [column, swimlane];
  };

  Board.prototype.drawCells = function() {
    var c, cells, cl, ctitle, sl, x, y, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _results;
    x = 0;
    y = Kb.Raphael.Cell.column_title_height;
    _ref = this.model.get('swimlanes');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      sl = _ref[_i];
      sl = new Kb.Raphael.SwimlaneTitle(this.paper, sl, x, y);
      sl.draw();
      y += Kb.Raphael.Cell.swimlane_height;
    }
    cells = [];
    x = Kb.Raphael.Cell.swimlane_title_width;
    _ref1 = this.model.get('columns');
    _results = [];
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      cl = _ref1[_j];
      y = 0;
      ctitle = new Kb.Raphael.ColumnTitle(this.paper, cl, x, y);
      ctitle.draw();
      y += Kb.Raphael.Cell.column_title_height;
      _ref2 = this.model.get('swimlanes');
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        sl = _ref2[_k];
        c = new Kb.Raphael.DroppableCell(this.paper, cl, sl, x, y);
        c.draw();
        this._cells.put(c);
        y += Kb.Raphael.Cell.swimlane_height;
      }
      _results.push(x += Kb.Raphael.Cell.column_width);
    }
    return _results;
  };

  Board.prototype.draw = function() {
    return this.drawCells();
  };

  return Board;

})();
