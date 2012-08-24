class Kb.Raphael.Ticket
  width: 70
  height: 90

  constructor: (@board, @model)->
    @board.paper

  draw: ()->
    # FIXME: dummy first
    console.log "Rendering ticket '#{@model.get('title')}'"
    [x,y] = @board.compute_absolute_coordinates @model.get('column'), @model.get('swimlane'),@model.get('x'), @model.get('y')
    @board.paper.rect( x, y, @width, @height)

