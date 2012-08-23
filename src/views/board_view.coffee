class Kb.Views.BoardView extends Backbone.View

  # To be given:
  #   model: the model to use
  #   id: the id of the div to insert the board in 
  initialize: ()->
    @model.get('tickets').bind 'add', @addOne, this
    @model.get('tickets').bind 'reset', @addAll, this
    @model.get('tickets').bind 'all', @render, this
    @svgboard = new Kb.Raphael.Board @model, @el
    @svgboard.draw()
     #@render()

  addOne: ()->
    console.log "One ticket added. Render it"

  addAll: ()->
    @model.get('tickets').each (t)=>
      console.log( "Adding ticket '" + t.get('title')+"'" )
      view = new Kb.Views.TicketView model: t, boardview: this
      view.render()

  render: =>
    console.log "Rendering board"

