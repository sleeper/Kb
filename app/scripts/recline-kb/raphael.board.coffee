class recline.View.Kanban.Cell
  @swimlane_height: 600
  @swimlane_title_width: 50
  @column_width: 400
  @column_title_height: 50


  # Return the center of the passed Raphael element
  center: (el)->
    x =  el.attr('x') + (el.attr('width')  / 2 )
    y =  el.attr('y') + (el.attr('height')  / 2 )
    [x,y]


class recline.View.Kanban.DroppableCell extends recline.View.Kanban.Cell
  #hovered_color: "grey"
  hovered_color: "rgb(227,225,226)"
  background_color: "white"
  width: recline.View.Kanban.Cell.column_width
  height: recline.View.Kanban.Cell.swimlane_height

  constructor: (@paper, @col_name, @sl_name, @x, @y)->
    @scope = @
    eve.on "cell.leaving", @left
    eve.on 'cell.entering', @entered
    eve.on 'cell.dropped', @dropped

  # Return the absolute x and y coordinates from the relative ones
  compute_absolute_coordinates: (rx, ry)->
    [ @x + rx, @y + ry ]

  # Return the (x,y) relatives to this cell
  compute_relative_coordinates: (ax, ay)->
    [ ax - @x, ay - @y]

  isPointInside: (x,y)->
    @el.isPointInside(x,y)

  entered: (col, sl)=>
    if col == @col_name && sl == @sl_name
      @el.attr({fill: @hovered_color})

  left: (col, sl)=>
    if col == @col_name && sl == @sl_name
      @el.attr({fill: @background_color})

  dropped: (col,sl)=>
    if col == @col_name && sl == @sl_name
      @el.attr({fill: @background_color})

  draw: ()->
    @el = @paper.rect @x, @y, @width, @height
    @el.attr({fill: @background_color, 'stroke-linejoin': "round", 'stroke-width': 3})
    @el.droppable = this
    @el

class recline.View.Kanban.SwimlaneTitle extends recline.View.Kanban.Cell
  width: recline.View.Kanban.Cell.swimlane_title_width
  height: recline.View.Kanban.Cell.swimlane_height

  constructor: (@paper, @sl_name, @x, @y)->

  draw: ()->
    t = @paper.rect @x, @y, @width, @height
    t.attr fill: "white", stroke: "none"
    [cx,cy] = @center t
    text = @paper.print cx, cy, @sl_name, @paper.getFont("Yanone Kaffeesatz Bold"), 40, "middle"
    bbox = text.getBBox()
    # Correct text position
    text.transform "R-90T-#{bbox.width/2+10},0"
    text.attr("fill", "black");

class recline.View.Kanban.ColumnTitle extends recline.View.Kanban.Cell
  width: recline.View.Kanban.Cell.column_width
  height: recline.View.Kanban.Cell.column_title_height

  constructor: (@paper, @name, @x, @y)->

  draw: ()->
    t = @paper.rect @x, @y, @width, @height
    t.attr fill: "white", stroke: "none"
    [cx,cy] = @center t 
    text = @paper.print cx, cy, @name, @paper.getFont("Yanone Kaffeesatz Bold"), 40, "middle"
    bbox = text.getBBox()
    # Correct text position
    text.transform "t-#{bbox.width/2},-5"
    text.attr("fill", "black")

#
# A basic cache for droppable cells, allowing to retrieve
# them by column_name and swimlane_name
#
class recline.View.Kanban.CellCache
  constructor: ()-> @_cache = {}
  hash: (col_name, sl_name)-> "#{col_name}-#{sl_name}"
  put: (droppable)-> @_cache[@hash(droppable.col_name, droppable.sl_name)] = droppable
  get: (col_name, sl_name)-> @_cache[@hash(col_name, sl_name)]

  # Iterates over the cached elements
  # The callback will receive 2 parameters:
  #   - the key
  #   - the cell
  #
  forEach: (cb)->
    $.each @_cache, cb


class recline.View.Kanban.Board

  # Takes in:
  #  * config: with the columns, swimlanes
  #  * el: where we should hang the board
  # 
  constructor: (@config, @el) ->
    @_cells = new recline.View.Kanban.CellCache()
    [@width, @height] = @compute_sizes()

    # Size correctly the container
    jnode = $(@el);
    jnode.width(@width)
    jnode.height(@height)

    $(window).resize ()-> 
      $('.ticket').trigger('window:resized')

    @paper = Raphael @el, @width, @height

  compute_sizes: () ->
    cw = recline.View.Kanban.Cell.column_width
    stw = recline.View.Kanban.Cell.swimlane_title_width
    sh = recline.View.Kanban.Cell.swimlane_height
    cth = recline.View.Kanban.Cell.column_title_height
    width = @config.columns.length * cw + stw + 2
    height = @config.swimlanes.length * sh + cth + 2
    [width, height]

  # Each ticket on the board has a x and y coordinate, relative to 
  # the cell it is placed in.
  # This method allows for computation of the absolute x and y
  compute_absolute_coordinates: (cl_name, sl_name, rx, ry)->
    cell = @_cells.get(cl_name, sl_name)
    # FIXME: handle the case cell is empty
    # delegate to cell
    cell.compute_absolute_coordinates(rx, ry)

  compute_relative_coordinates: (cl_name, sl_name, ax, ay)->
    cell = @_cells.get(cl_name, sl_name)
    cell.compute_relative_coordinates(ax, ay)

  # Return the cell that is under point x, y
  getCellByPoint: (x, y)->
    cell = null
    @_cells.forEach (k, c)->
      if c.isPointInside(x,y)
        cell = c
        false
    cell

  getColumnAndSwimlane: (x,y)->
    [column,swimlane] = [null,null]
    cell = @getCellByPoint(x,y)
    [column,swimlane] = [cell.col_name, cell.sl_name] if cell != null
    [column,swimlane]

  drawCells: () ->
    # Add swimlane titles
    x = 0
    y = recline.View.Kanban.Cell.column_title_height
    for sl in @config.swimlanes
      sl = new recline.View.Kanban.SwimlaneTitle @paper, sl, x, y
      sl.draw()
      y += recline.View.Kanban.Cell.swimlane_height

    cells = []
    x = recline.View.Kanban.Cell.swimlane_title_width 
    for cl in @config.columns
      y = 0
      ctitle = new recline.View.Kanban.ColumnTitle @paper, cl, x, y
      ctitle.draw()

      y += recline.View.Kanban.Cell.column_title_height
      for sl in @config.swimlanes
        c = new recline.View.Kanban.DroppableCell @paper, cl, sl, x, y
        c.draw()
        @_cells.put c
        y += recline.View.Kanban.Cell.swimlane_height

      x += recline.View.Kanban.Cell.column_width


  draw: () ->
    # Let's draw cells
    @drawCells()

