class Kb.Views.BoardView extends Backbone.View

  # To be given:
  #   model: the model to use
  #   id: the id of the div to insert the board in 
  initialize: ->
    @render()

  render: =>
    b = new Kb.Raphael.Board @model
    b.draw @el
    # Now let's draw all the current tickets
    @model.get('tickets').each (t)->
      console.log( t.get('title') )

