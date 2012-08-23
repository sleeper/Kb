class Kb.Views.TicketView extends Backbone.View

  # To be given:
  #   model
  #   boardview: the view of the enclosing board
  initialize:() ->
    bind 'change', @render

  render: =>
    t = new Kb.Raphael.Ticket @boardview.svgboard, @model
    t.draw @el

