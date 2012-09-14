var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Kb.Routers.AppRouter = (function(_super) {

  __extends(AppRouter, _super);

  function AppRouter() {
    return AppRouter.__super__.constructor.apply(this, arguments);
  }

  AppRouter.prototype.routes = {
    "/tickets/:id": "ticketDetail",
    "*actions": "defaultRoute"
  };

  AppRouter.prototype.ticketDetail = function(id) {
    return console.log("[DEBUG] We should create a new detailled view");
  };

  AppRouter.prototype.defaultRoute = function(actions) {
    return console.log("[DEBUG] Default route");
  };

  return AppRouter;

})(Backbone.Router);
