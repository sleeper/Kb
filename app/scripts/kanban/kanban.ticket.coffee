class Kanban.Ticket
  width: 70
  height: 90
  fill_color:
    default: '223.19625301042-#f7ec9a:0-#f6ea8d:13.400906-#f5e98a:45.673525-#f8ed9d:80.933785-#f5e98a:100'
    help_needed: '#f00'


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

    update: (@img) ->
      @el.remove()
      @el = @paper.image(@img, @x, @y, @width, @height)

    remove: ()->
      @el.remove()

  class Title
    y_offset: 10
    x_offset: 5

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
      @title_frame.setAttribute "x", @x + @x_offset
      @title_frame.setAttribute "y", @y + @y_offset + 5
      @title_frame.setAttribute "width", @width - @x_offset - 5
      @title_frame.setAttribute "height", @height - @y_offset - 5
      body = document.createElement "body"
      @title_frame.appendChild body
      @title = document.createElement "div"
      body.appendChild @title
      $(@title).html( @text )
      @paper.canvas.appendChild @title_frame
      @resize()

    move: (@x,@y)->
      @title_frame.setAttribute "x", @x + @x_offset
      @title_frame.setAttribute "y", @y + @y_offset + 5

    update_title: (@text)->
      $(@title).html( @text )
      @resize()

    remove: ()->
      if @title_frame.parentNode
        @title_frame.parentNode.removeChild(@title_frame);

  # This is our Ticket constructor.
  # You have to pass it the board object as well
  # as the record the new Kanban ticket
  # is supposed to represent.
  #
  constructor: (@board, @record)->
    @cleared = true
    @events = {}
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

    @frame.animate({opacity: 1}, 500, ">");
    @cell = @board.get_cell_by_point @x, @y
    [ @xrel, @yrel ] = @cell.to_rel @x, @y

    # Let's broadcast the fact we've land ...
    eve "cell.dropped", @el, @cur_col, @cur_sl, @
    eve "column.dropped", @el, @cur_col, @cur_sl, @

    # ... and launch handlers if there's any registered
    # for these events
    for evt in ['cell.dropped', 'column.dropped']
      # The callbacks needs to be called in the context of the current Ticket
      @events[evt].apply(@, [@cur_col, @cur_sl]) if @events[evt]

    @move() if force_move

  # reset the ticket to the swimlane, column, x and y
  # stored in the Record
  reset: ()->
    @ocol = @cur_col = @record.get('column')
    @osl = @cur_sl = @record.get('swimlane')
    @ox = @x = @record.get('x')
    @oy = @y = @record.get('y')
    @cell = @board.get_cell @osl, @ocol
    @move @x, @y

  move: ()->
    [@x, @y] = @cell.to_absolute @record.get('x'), @record.get('y')
    @frame.attr x: @x, y: @y
    @title.move @x, @y
    @avatar.move @x, @y

  setup_events: (e)->
    # Handle Raphaeljs own events
    for evt in ['click', 'dblclick']
      if @events[evt]
        e[evt] ()=> @events[evt](@)

  get_fill_color: ()->
    if @record.get('help_needed')
      @fill_color['help_needed']
    else
      @fill_color['default']

  draw_frame: ()->
    @frame = @board.paper.rect( @x, @y, @width, @height)
    @frame.attr({fill:@get_fill_color()})
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
    @setup_events( @frame )

  update_frame: ()->
    @frame.attr({fill:@get_fill_color()})

  update_title: ()->
    @title.update_title @record.get('title')

  update_avatar: ()->
    # img = "../assets/imgs/#{@record.avatar}"
    @avatar.update @record.avatar()

  clear: ()->
    @cleared = true
    @title.remove()
    @avatar.remove()
    @frame.remove()

  # Update the ticket position and representation following
  # a change in the record
  update: ()->
    if @cleared
      @draw()
    else
      @update_frame()
      @update_title()
      @update_avatar()
      @move()

  on: (evt, callback)=>
    @events[evt] = callback

  draw: ()->
    @cleared = false
    rx = @record.get 'x'
    ry = @record.get 'y'
    @cell = @board.get_cell @record.get('swimlane'), @record.get('column')
    [@x, @y] = @cell.to_absolute @record.get('x'), @record.get('y')

    @draw_frame()
    @title = new Title(@board.paper, @record.get('title'), @x, @y, @width, @height)

    @avatar = new Avatar(@board.paper, @record.avatar(), @x, @y)

    @frame.drag(@dragged, @start, @up)
    @
