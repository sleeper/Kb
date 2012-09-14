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
