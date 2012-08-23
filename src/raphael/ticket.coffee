class Kb.Raphael.Ticket
  width: 70
  height: 90

  constructor: (board, @model)->
    @paper = board.paper

  draw: ()->
    # FIXME: dummy first
    @paper.rect( 10, 10, @width, @height)

