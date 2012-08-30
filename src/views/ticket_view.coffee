class Kb.Views.TicketView extends Backbone.View
  #@events:
  #  "change": "render"

  # To be given:
  #   model
  #   boardview: the view of the enclosing board
  initialize:() ->
    @boardview = @options.boardview
#    @bind 'change', @render
    t = new Kb.Raphael.Ticket @boardview.svgboard, @model
    @element = t.draw @el
    @setElement @element.node
    # FIXME: We'll probably need to be smarter, as
    # the ticket must be redraw if the title change
    # but just moved when the column or swimlane or position is juste changed

#    @delegateEvents(@events);

    @model.on 'change', @render

  render: =>
    console.log "[DEBUG] TicketView.render called for #{@model.get('title')}"
    console.log "[DEBUG] column = #{@model.get('column')}"
#    t = new Kb.Raphael.Ticket @boardview.svgboard, @model
#    t.draw @el
    @element.move()


