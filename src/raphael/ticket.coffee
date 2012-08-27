class Kb.Raphael.Ticket
  width: 70
  height: 90

  constructor: (@board, @model)->
    @board.paper

  move: (dx, dy)=>
    @x = @ox + dx
    @y = @oy + dy
    @frame.attr({x: @x, y: @y});
    # We need to notify the cell we're entering in, as well
    # as the cell we're leaving
    #
    [col,sl] = @board.getColumnAndSwimlane @x,@y
    if col != @cur_col || sl != @cur_sl
      eve "cell.leaving", @el, @cur_col, @cur_sl
      eve "cell.entering", @el, col, sl
      [@cur_col, @cur_sl] = [col,sl]


  start: ()=>
    @frame.animate({opacity: .25}, 500, ">");
    @ox = @frame.attr("x");
    @oy = @frame.attr("y");
    # Get original cell we're in
    [@ocol, @osl] = @board.getColumnAndSwimlane @ox, @oy
    [@cur_col, @cur_sl] = [@ocol, @osl]

  up: ()=>
    @frame.animate({opacity: 1}, 500, ">");
    eve "cell.dropped", @el, @cur_col, @cur_sl


  draw: ()->
    [x,y] = @board.compute_absolute_coordinates @model.get('column'), @model.get('swimlane'),@model.get('x'), @model.get('y')
    @frame = @board.paper.rect( x, y, @width, @height)
    @frame.attr({fill: "#ffffff"})
    @frame.drag(@move, @start, @up)
