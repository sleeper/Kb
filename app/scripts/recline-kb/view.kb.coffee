# recline = recline || {}
# recline.View ||= {}

class recline.View.Board extends Backbone.View
  # Config notable keys:
  #
  #   * `model`: the dataset model to use
  #   * `el`: the element to use
  #   * `state`: state and configuration object for the view
  #
  # Beside "standard states values, the board configuration can be given through the key `kb`.
  # It should be associated to a hash that holds the board config.
  # The config options for the board are:
  # * `layout` : point to an hash with the current layout (i.e. columns, swimlanes, ...)
  #
  initialize: (config)->
    self = @
    @el = $(@el);
    @el.addClass('recline-board');
    _.bindAll(@, 'render');
    @model.records.bind('add', this.render);
    @model.records.bind('reset', this.render);
    @model.records.bind('remove', this.render);
    state = _.extend({
      layout: {}
      }, config.state
    );
    @state = new recline.Model.ObjectState(state);
    @board = new Kanban.Board @state.get('layout'), @el
    @board.draw()
    this.model.records.each (record)=>
      # Keep only the ticket that are on board
      if record.get('status') == 'board'
        t = new Kanban.Ticket @board, record
        t.draw()


  render: ()->




