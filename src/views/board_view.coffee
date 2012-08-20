class Kb.Views.BoardView extends Backbone.View

  # To be given:
  #   model: the model to use
  #   id: the id of the div to insert the board in 
  initialize: ->
    @render()

  render: =>
    b = new Kb.Raphael.Board
    b.draw @el, @model

