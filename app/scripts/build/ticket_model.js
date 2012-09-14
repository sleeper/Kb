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
    y: 0,
    avatar: "Jack O Lantern.png"
  };

  return Ticket;

})(Backbone.Model);
