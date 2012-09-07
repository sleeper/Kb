class Kb.Raphael.Ticket
  width: 70
  height: 90
  fill_color: '223.19625301042-#f7ec9a:0-#f6ea8d:13.400906-#f5e98a:45.673525-#f8ed9d:80.933785-#f5e98a:100'

  class Avatar
    x_offset: 50
    y_offset: 70
    width: 30
    height: 30

    # Draw an avatar for a ticket with coordinate (tx, ty)
    constructor: (@paper, @img, tx, ty)->
      @x = tx + @x_offset
      @y = ty + @y_offset
      @el = @paper.image(@img, @x, @y, @width, @height)

    # Move to the right position, for a ticket which is at coordinate (x,y)
    move: (x, y)->
      @x = x + @x_offset
      @y = y + @y_offset
      @el.attr x: @x, y: @y


  class Title
    title_offset: 10

    # Resize the title font according to the size of
    # the foreignObject.
    resize: ()->
      original_height = @title_frame.getAttribute "height"
      original_width = @title_frame.getAttribute "width"
      title = $(@title)
      title_height = title.height()

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

    # Draw the title at coordinate (x,y) with a (width, height) size
    constructor: (@paper, @text, @x, @y, @width, @height)->
      @title_frame = document.createElementNS "http://www.w3.org/2000/svg","foreignObject"
      @title_frame.setAttribute "x", @x
      @title_frame.setAttribute "y", @y + @title_offset + 5
      @title_frame.setAttribute "width", @width - 5
      @title_frame.setAttribute "height", @height - @title_offset - 5
      body = document.createElement "body"
      @title_frame.appendChild body
      @title = document.createElement "div"
      body.appendChild @title
      $(@title).html( @text ) 
      @paper.canvas.appendChild @title_frame
      @resize()

    move: (@x,@y)->
      @title_frame.setAttribute "x", @x
      @title_frame.setAttribute "y", @y + @title_offset + 5


  constructor: (@board, @model)->
    @board.paper


  dragged: (dx, dy)=>
    @x = @ox + dx
    @y = @oy + dy
    @frame.attr x: @x, y: @y
    @title.move @x, @y
    @avatar.move @x, @y

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
        [@x, @y] = [ @ox, @oy]
        # If the user dropped the ticket on non-droppable
        # the model will be reset to its column and swimlane
        # but no change event will be fired.
        # So we do need to force the move
        force_move = true
    eve "cell.dropped", @el, @cur_col, @cur_sl
    @frame.animate({opacity: 1}, 500, ">");
    [x,y] = @board.compute_relative_coordinates @cur_col, @cur_sl, @x, @y
    @model.set column: @cur_col, swimlane: @cur_sl, x: x, y: y
    @move() if force_move

  move: ()->
    [@x,@y] = @board.compute_absolute_coordinates @model.get('column'), @model.get('swimlane'),@model.get('x'), @model.get('y')
    @frame.attr x: @x, y: @y
    @title.move @x, @y
    @avatar.move @x, @y


  draw_frame: ()->
    @frame = @board.paper.rect( @x, @y, @width, @height)
    @frame.attr({fill:@fill_color})
    @frame.node.setAttribute("class", "ticket")
    $(@frame.node).on("window:resized", ()=> @title.resize())
    filter1 = @board.paper.filterCreate("filter1");
    @frame.filterInstall(filter1); 
    blur1 = Raphael.filterOps.feGaussianBlur(
        {stdDeviation: "1.2", "in": "SourceAlpha", result: "blur1"});
    offset1 = Raphael.filterOps.feOffset(
        {"in": "blur1", dx: 2, dy: 2, result: "offsetBlur"});
    merge1 = Raphael.filterOps.feMerge(["offsetBlur", "SourceGraphic"]);
    filter1.appendOperation(blur1);
    filter1.appendOperation(offset1);
    filter1.appendOperation(merge1); 

  draw: ()->
    [@x,@y] = @board.compute_absolute_coordinates @model.get('column'), @model.get('swimlane'),@model.get('x'), @model.get('y')

    @draw_frame()
    @title = new Title(@board.paper, @model.get('title'), @x, @y, @width, @height)
    @avatar = new Avatar(@board.paper, "../assets/imgs/#{@model.get('avatar')}", @x, @y)

    @frame.drag(@dragged, @start, @up)
    @
