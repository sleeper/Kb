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

    # Add a space for the detailed information
    @add_details_container()

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
    @overlay.toggle()


  add_details_container: ()->
    # $('body').append('<div id="overlay">&nbsp;</div>')
    $(@el).append('<div id="overlay">&nbsp;</div>')
    @overlay = $('#overlay', @el)
    @overlay.hide()
    @overlay.on('click', @resume_overlay)
    $(@el).append("<div id=\"ticket_detail\"></div>")
    @ticket_detail = $('#ticket_detail', $(@el))
    # @resize()

  display_ticket_detail: (t)=>
    @overlay.toggle()
    @ticket_detail.append("<h1>#{t.record.get('title')}</h1>")
    @ticket_detail.append("<div class=\"date\"> #{t.record.get('created_on')} / #{t.record.get('entered_on')}</div>")
    @ticket_detail.append("<div class=\"comment\">#{t.record.get('comment')}</div>")

    # FIXME: Add the avatar of the user OR a button for the user to take care 
    #        of the ticket.

    img = "../assets/imgs/#{t.record.avatar}"
    @ticket_detail.append("<img class=\"avatar\" src=\"#{img}\">")
    # $('.avatar', @ticket_detail).on 'click', () => t.model.set('user_id', Kb.board.current_user.get('id'))
    @ticket_detail.css('opacity',1)
    @ticket_detail.show();    
    width = @ticket_detail.width()
    height = @ticket_detail.height()
    @ticket_detail.css
                position: 'fixed',
                left: ($(window).width() - width) / 2 
                top: ($(window).height() - height) / 2
  

  clear_tickets: ()->
    _.each @tickets, (t)=>
      t.clear()
    @tickets = []

  create_ticket: (r)->
    t = new Kanban.Ticket @board, r
    t.on 'dblclick', (t)=> 
      @display_ticket_detail(t)
    # t.on 'cell.dropped', (col,sl)=>
    #   console.log "FRED: Ticket dropped and generated event : (#{col}, #{sl})"

    t

  render_tickets: ()->
    this.model.records.each (record)=>
      # Keep only the ticket that are on board
      if record.get('status') == 'on board'
        t = @create_ticket record 
        t.draw()
        @tickets.push t

  render: ()->




