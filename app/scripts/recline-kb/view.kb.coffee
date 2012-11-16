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
    @board = new Kanban.Board @state.get('layout'), @el, @state.get('measures')
    @board.draw()

    @bind_events()
    @render_tickets()


  bind_events: ()->
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
      if r.get('status') == 'on board'
        ticket.update()
      else
        ticket.clear()


  resume_overlay: ()=>
    @ticket_detail.empty()
    @ticket_detail.hide()
    # @overlay.toggle()
    @so.overlay.remove()
    @so.dialog.remove()

  display_ticket_detail: (t)=>
    @so = new SimpleOverlay $(@el)
    @so.overlay.on 'click', @resume_overlay
    @so.dialog.append "<div id=\"ticket_detail\"></div>"
    @ticket_detail = $('#ticket_detail', $(@el))

    # @overlay.toggle()
    @ticket_detail.append("<h1>#{t.record.get('title')}</h1>")
    @ticket_detail.append("<div class=\"date\"> #{t.record.get('created_on')} / #{t.record.get('entered_on')}</div>")
    @ticket_detail.append("<div class=\"comment\">#{t.record.get('comment')}</div>")

    # FIXME: Add the avatar of the user OR a button for the user to take care 
    #        of the ticket.

    # img = "../assets/imgs/#{t.record.avatar}"
    @ticket_detail.append("<img class=\"avatar\" src=\"#{t.record.avatar}\">")
    @so.show()  

  clear_tickets: ()->
    _.each @tickets, (t)=>
      t.clear()
    @tickets = []

  setup_user: (r)->
    return if r.user? && r.avatar?
    r.user = @state.get('users').get( r.get('user_id') )
    if r.user
      r.avatar = r.user.get('avatar')
    else
      r.avatar = "/images/question-mark-icon.png"


  create_ticket: (r)->
    @setup_user( r )
    t = new Kanban.Ticket @board, r
    t.on 'dblclick', (t)=> 
      @display_ticket_detail(t)
    @tickets.push t
    t

  render_tickets: ()->
    this.model.records.each (record)=>
      # Keep only the ticket that are on board
      if record.get('status') == 'on board'
        t = @create_ticket record 
        t.draw()

  render: ()->
    console.log "FRED"




