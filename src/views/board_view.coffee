class Kb.Views.BoardView extends Backbone.View

  # To be given:
  #   model: the model to use
  #   id: the id of the div to insert the board in 
  initialize: ()->
    Kb.Collections.TicketList.bind 'add', @addOne, this
    Kb.Collections.TicketList.bind 'reset', @addAll, this
    Kb.Collections.TicketList.bind 'all', @render, this
    @render()

  addOne: ()->
    console.log "One ticket added. Render it"

  addAll: ()->
    @model.get('tickets').each (t)->
      console.log( "Adding ticket '" + t.get('title')+"'" )
      view = new Kb.Views.Ticket model: t, boardview: this
      view.render

  render: =>
    @svgboard = new Kb.Raphael.Board @model
    @svgboard.draw @el

