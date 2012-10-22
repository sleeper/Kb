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
    @tickets = []
    @model.records.bind('add', this.render);
    @model.records.bind('remove', this.render);
    state = _.extend({
      layout: {}
      }, config.state
    );
    @state = new recline.Model.ObjectState(state);
    @board = new Kanban.Board @state.get('layout'), @el
    @board.draw()

    @model.records.on 'reset', ()=>
      @clear_tickets()
      @render_tickets()

    @model.records.on 'change', (r)=>
      # Let's find which ticket must be changed
      ticket = _.find @tickets, (t)-> t.record.get('id') == r.get('id')

      if !ticket
        # Let's creste a new one !
        ticket = @create_ticket r

      # If ticket is not supposed to be on board, remove it
      if !r.get('on_board')
        ticket.clear()
      else
        ticket.update()

    @model.records.on 'details', (r)=>
      console.log "FRED: details requested on record " + r.get('id')
      # FIXME: display detailled view for given ticket

    @render_tickets()

  clear_tickets: ()->
    _.each @tickets, (t)=>
      t.clear()
    @tickets = []

  create_ticket: (r)->
    t = new Kanban.Ticket @board, r
    t.on 'dblclick', (t)=> console.log "FRED: ticket for record " + t.record.get('id') + " is double-clicked !!!!"
    t

  render_tickets: ()->
    this.model.records.each (record)=>
      # Keep only the ticket that are on board
      if record.get('on_board')
        t = @create_ticket record 
        t.draw()
        @tickets.push t

  render: ()->




