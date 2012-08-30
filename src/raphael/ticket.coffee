class Kb.Raphael.Ticket
  width: 70
  height: 90
  header_height: 20

  constructor: (@board, @model)->
    @board.paper

  dragged: (dx, dy)=>
    @x = @ox + dx
    @y = @oy + dy
    @frame.attr x: @x, y: @y
    @header.attr x: @x, y: @y
    @title.setAttribute "x", @x
    @title.setAttribute "y", @y + @header_height + 5

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

  move: ()->
    [@x,@y] = @board.compute_absolute_coordinates @model.get('column'), @model.get('swimlane'),@model.get('x'), @model.get('y')
    @frame.attr x: @x, y: @y
    @header.attr x: @x, y: @y
    @title.setAttribute "x", @x
    @title.setAttribute "y", @y + @header_height + 5


  draw_title: ()->
    @title = document.createElementNS "http://www.w3.org/2000/svg","foreignObject"
    @title.setAttribute "x", @x
    @title.setAttribute "y", @y + @header_height + 5
    @title.setAttribute "width", @width - 5
    @title.setAttribute "height", @height - @header_height - 5
    body = document.createElement "body"
    @title.appendChild body
    div = document.createElement "div"
    body.appendChild div
    div.innerHTML = @model.get 'title'
    # $(div).quickfit();
    @board.paper.canvas.appendChild @title
    $(div).rsize()

  draw_header: ()->
    @header = @board.paper.rect(@x, @y, @width, @header_height)

  draw: ()->
    [@x,@y] = @board.compute_absolute_coordinates @model.get('column'), @model.get('swimlane'),@model.get('x'), @model.get('y')
    @frame = @board.paper.rect( @x, @y, @width, @height)
    @frame.attr({fill: "#ffffff"})
    # Let's add the title
    @draw_header()
    @draw_title()
    @frame.drag(@dragged, @start, @up)
    @
