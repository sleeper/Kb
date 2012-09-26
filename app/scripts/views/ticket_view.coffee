class Kb.Views.TicketView extends Backbone.View
  #@events:
  #  "change": "render"

  # To be given:
  #   model
  #   boardview: the view of the enclosing board
  initialize:() ->
    @boardview = @options.boardview
    # Associate ticket and user
    if @model.get('user_id') != 0
      @model.user = Kb.board.get('users').get( @model.get('user_id'))

    t = new Kb.Raphael.Ticket @, @boardview.svgboard, @model
    @element = t.draw @el
    @setElement @element.node
    # FIXME: We'll probably need to be smarter, as
    # the ticket must be redraw if the title change
    # but just moved when the column or swimlane or position is juste changed


    @model.on 'change', ()=> @element.move()
    @model.on 'change:title', ()=> @element.update_title()


  dblclick: ()->
    # Navigate to this ticket
    Backbone.history.navigate('/tickets/'+@model.get('id'), true)

  render: =>
    @element.move()


