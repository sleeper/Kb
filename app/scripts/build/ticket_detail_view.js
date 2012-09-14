var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Kb.Views.TicketDetailView = (function(_super) {

  __extends(TicketDetailView, _super);

  function TicketDetailView() {
    this.render = __bind(this.render, this);
    return TicketDetailView.__super__.constructor.apply(this, arguments);
  }

  TicketDetailView.prototype.initialize = function() {
    var t,
      _this = this;
    this.boardview = this.options.boardview;
    t = new Kb.Raphael.Ticket(this.boardview.svgboard, this.model);
    this.element = t.draw(this.el);
    this.setElement(this.element.node);
    this.model.on('change', function() {
      return _this.element.move();
    });
    return this.model.on('change:title', function() {
      return _this.element.update_title();
    });
  };

  TicketDetailView.prototype.render = function() {
    console.log("[DEBUG] TicketView.render called for " + (this.model.get('title')));
    console.log("[DEBUG] column = " + (this.model.get('column')));
    return this.element.move();
  };

  return TicketDetailView;

})(Backbone.View);
