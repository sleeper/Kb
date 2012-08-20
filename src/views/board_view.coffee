class Kb.Views.BoardView extends Backbone.View
  el: $('#board')

  initialize: ->
    @render()

  render: =>
    b = new Kb.Raphael.Board
    b.draw @el.id, @model

