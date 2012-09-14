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
