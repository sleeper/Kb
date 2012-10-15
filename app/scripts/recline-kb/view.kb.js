/*jshint multistr:true */

this.recline = this.recline || {};
this.recline.View = this.recline.View || {};

(function($, my) {
  // Config notable keys:
  // 
  // * `model`: the dataset model to use
  // * `el`: the element to use
  // * `state`: state and configuration object for the view
  // 
  // Beside "standard states values, the board configuration can be given through the key `kb`.
  // It should be associated to a hash that holds the board config.
  // The config options for the board are:
  // * `layout` : point to an hash with the current layout (i.e. columns, swimlanes, ...)
 
my.KanbanBoard = Backbone.View.extend({
  initialize: function(config) {
    var self = this;
    this.el = $(this.el);
    this.el.addClass('recline-slickgrid');
    _.bindAll(this, 'render');
    this.model.records.bind('add', this.render);
    this.model.records.bind('reset', this.render);
    this.model.records.bind('remove', this.render);

     state = _.extend({
      layout: {}
      }, config.state
    );

    this.state = new recline.Model.ObjectState(state);
  },

  events: {
  },

  render: function() {
    var self = this;

    var options = _.extend({
    }, self.state.get('gridOptions'));

    if (self.visible){
      self.grid.init();
      self.rendered = true;
    } else {
      // Defer rendering until the view is visible
      self.rendered = false;
    }

    return this;
 }	
});
})(jQuery, recline.View);
