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
    @title_frame.setAttribute "x", @x
    @title_frame.setAttribute "y", @y + @header_height + 5

    # We need to notify the cell we're entering in, as well
    # as the cell we're leaving
    #
    [col,sl] = @board.getColumnAndSwimlane @x,@y
    if col != @cur_col || sl != @cur_sl
      eve "cell.leaving", @el, @cur_col, @cur_sl
      if col? && sl?
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
    # If we're not on a droppable .. move back to original
    if !@cur_col? || !@cur_sl?
        @cur_col = @ocol
        @cur_sl = @osl
        # If the user dropped the ticket on non-droppable
        # the model will be reset to its column and swimlane
        # but no change event will be fired.
        # So we do need to force the move
        force_move = true
    eve "cell.dropped", @el, @cur_col, @cur_sl
    @frame.animate({opacity: 1}, 500, ">");
    [x,y] = @board.compute_relative_coordinates @cur_col, @cur_sl, @x, @y
    @model.set column: @cur_col, swimlane: @cur_sl, x: x, y: y
    @move if force_move

  move: ()->
    [@x,@y] = @board.compute_absolute_coordinates @model.get('column'), @model.get('swimlane'),@model.get('x'), @model.get('y')
    @frame.attr x: @x, y: @y
    @header.attr x: @x, y: @y
    @title_frame.setAttribute "x", @x
    @title_frame.setAttribute "y", @y + @header_height + 5

  # Resize the title font according to the size of
  # the foreignObject.
  resize_title: ()->
    original_height = @title_frame.getAttribute "height"
    original_width = @title_frame.getAttribute "width"
    title = $(@title)
    title_height = title.height()
    if !original_width || !original_height
      console.info("Set static width/height for your foreignObject") if window.console?

    if title_height <= original_height
     return

    font_size = parseInt title.css("font-size"), 10
    upper = font_size
    lower = 2 # Min font size
    while (upper-lower) > 1
      middle = (upper + lower) / 2
      title.css "font-size", middle
      height = title.height()
      if height == original_height
        break
      else if height > original_height
        upper = middle
      else
        lower = middle

  draw_title: ()->
    @title_frame = document.createElementNS "http://www.w3.org/2000/svg","foreignObject"
    @title_frame.setAttribute "x", @x
    @title_frame.setAttribute "y", @y + @header_height + 5
    @title_frame.setAttribute "width", @width - 5
    @title_frame.setAttribute "height", @height - @header_height - 5
    body = document.createElement "body"
    @title_frame.appendChild body
    @title = document.createElement "div"
    body.appendChild @title
    @title.innerHTML = @model.get 'title'
    @board.paper.canvas.appendChild @title_frame
    @resize_title()


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
