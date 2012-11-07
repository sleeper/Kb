window.Kanban = window.Kanban || {}

class Kanban.Cell
  hovered_color: "rgb(227,225,226)"
  background_color: "white"

  @center: (el)->
    x =  el.attr('x') + (el.attr('width')  / 2 )
    y =  el.attr('y') + (el.attr('height')  / 2 )
    [x,y]

  constructor: (@paper, @col_name, @sl_name, @x, @y, @width, @height)->
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
    @el.node.id = "cell #{@col_name}-#{@sl_name}"
    @el.attr({fill: @background_color, 'stroke-linejoin': "round", 'stroke-width': 3})
    @el.droppable = this
    @el


class Kanban.Column
  on_drop_start: (swimlane, column, ticket)=>
    console.log 'FIXME: On drop in a start column'

  on_drop_end: (swimlane, column, ticket)=>
    console.log 'FIXME: On drop in a end column'

  on_drop_onhold: (swimlane, column, ticket)=>
    console.log 'FIXME: On drop in a onhold column'

  draw_title: (paper, x, y)->
    t = paper.rect x, y, @width, @title_height
    t.node.id = "column #{@name} title"
    t.attr fill: "white", stroke: "none"
    [cx,cy] = Kanban.Cell.center t 
    text = paper.print cx, cy, @name, paper.getFont("Yanone Kaffeesatz Bold"), 40, "middle"
    bbox = text.getBBox()
    # Correct text position
    text.transform "t-#{bbox.width/2},-5"
    text.attr("fill", "black")


  constructor: (@name, @type, @width, @title_height)->
    callbacks= 
      start: @on_drop_start
      end: @on_drop_end
      onhold: @on_drop_onhold

    # FIXME: Check @type is "in range"
    @on_drop = callbacks[@type]

class Kanban.Swimlane
  constructor: (@name, @title_width, @height)->

  draw_title: (paper, x, y)->
    t = paper.rect x, y, @title_width, @height
    t.attr fill: "white", stroke: "none"
    t.node.id = "swimlane #{@name} title"
    [cx,cy] = Kanban.Cell.center t
    text = paper.print cx, cy, @name, paper.getFont("Yanone Kaffeesatz Bold"), 40, "middle"
    bbox = text.getBBox()
    # Correct text position
    text.transform "R-90T-#{bbox.width/2+10},0"
    text.attr("fill", "black");


class Kanban.CellCache
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
    for key,cell of @_cache
      cb(key,cell)

class Kanban.Layout

  class @Bundle
    constructor: (cfg, @sizes, @_cells)->
      @swimlanes = {}
      @columns = {}
      @nb_of_swimlanes = 0
      @nb_of_columns = 0

      # Check everything is fine with the input
      @check(cfg)

      @name = cfg.name

      for swimlane in cfg.swimlanes
        @nb_of_swimlanes += 1
        @swimlanes[swimlane] = new Kanban.Swimlane swimlane, @sizes.swimlane_title_width, @sizes.swimlane_height

      for column in cfg.columns
        @nb_of_columns += 1
        [name,type] = column.split(':')
        type ?= 'default'
        @columns[name] = new Kanban.Column name, type, @sizes.column_width, @sizes.column_title_height

    check: (cfg)->
      throw new TypeError('Missing name') unless cfg.name?
      throw new TypeError("Missing sizes") unless @sizes?
      throw new TypeError("Missing cell cache") unless @_cells? && (@_cells instanceof Kanban.CellCache)

      if cfg.cell
        if (typeof cfg.cell isnt 'string') && !(cfg.cell instanceof String)
          throw new TypeError('cell attribute must point to a String')
        # Let's normalize: we're looking only at the first element
        cell = cfg.cell
        delete cfg[cell]
        [name, type] = cell.split(':')
        cfg.columns = [ cell ]
        cfg.swimlanes = [ name ]

      if !cfg.columns? || !cfg.swimlanes?
        throw new TypeError( 'Bundle has not cell, columns or swimlanes attribute')

      if !(cfg.columns instanceof Array) || !(cfg.swimlanes instanceof Array)
        throw new TypeError( 'Bundle: columns and swimlanes attributes must be arrays')

      true
     
    size: ()->
      @width ?= @nb_of_columns * @sizes.column_width + @sizes.column_margin + @sizes.swimlane_title_width
      @height ?= @nb_of_swimlanes * @sizes.swimlane_height + @sizes.swimlane_margin + @sizes.column_title_height
      [@width, @height]

    draw: (paper)->
      # We need to draw the bundle starting at its positions (@x, @y)
      x = @x
      y = @y + @sizes.column_title_height
      for sl_name of @swimlanes
        sl = @swimlanes[sl_name] 
        sl.draw_title paper, x, y
        y += @sizes.swimlane_height

      cells = []
      x = @x + @sizes.swimlane_title_width 
      for cl_name of @columns
        y = @y
        cl = @columns[cl_name]
        cl.draw_title paper, x, y

        y += @sizes.column_title_height
        for sl_name of @swimlanes
          sl = @swimlanes[sl_name]
          c = new Kanban.Cell paper, cl_name, sl_name, x, y, @sizes.column_width, @sizes.swimlane_height
          c.draw()
          @_cells.put c
          y += @sizes.swimlane_height

        x += @sizes.column_width

  #
  # This object describes the layout of the Kanban board.
  # A board can be composed of several bundles, each of them representing either
  # a 'full board' (i.e. columns and swimlanes), or single cells ('trash bin' for example)
  # This constructor can be passed 2 parameters:
  # * the config (bundles and relative position of the bundles)
  # * the measurement to use for column width, swimlanes height, ... (optional)
  #
  # # Layout config
  #   The layout config gives the config of the various bundle plus their 
  #   relative positions.
  #   It is implemented as an object with 2 properties:
  #    * bundles: pointing to an array of the board's bundles
  #    * positions: pointing to an array of positions
  #  
  #  ## Bundles
  #    The bundles'configuration is represented as an array with on item per bundle
  #    Each of these items is an object that can have to following properties:
  #     * name: bundle name for reference in the positions array
  #     * swimlanes: Name of the swimlanes that composed this bundle
  #     * columns: the columns of the bundle
  #     * cell: shortcut when the bundle is composed of only 1 column and 1 swimlane
  # 
  #    Note that the `cell` and (`columns`, `swimlanes`) are mutualy exclusive.
  #    The swimlanes are represented by strings (the name of the swimlane).
  #    The columns are represented by strings, repesenting then name and optionally the 
  #    type of column. The name and optional type are separated by a `:`.
  #    For example, `foo:onhold` represents a column named `foo` with type `onhold`.
  #     
  #    Each column can have the following type:
  #      * start: this is where the tickets for the swimlane are starting. There can be only 
  #               1 start column per swimlane.
  #      * end: this is where the tickets for the swimlane are terminating (i.e. done). There can be only 
  #               1 end column per swimlane.
  #      * onhold: in this column, the tickets will be considered as 'on hold" and a 'wake up date' will
  #                be requested.
  #
  # # Measurements
  #
  #  FIXME
  #
  constructor: (cfg, meas={})->
    @sizes = 
        swimlane_height: 10
        column_width: 10
        swimlane_title_width: 10
        column_title_height: 10
        column_margin: 10
        swimlane_margin: 10
        bundle_margin: 10

    # Let's first check the consistency of the config: we should receive an Array
    # with a defined set of element
    # if !(cfg instanceof Array)
    throw new TypeError('Missing keys') unless cfg.bundles? && cfg.positions?
    throw new TypeError('Bundles is not an array') unless (cfg.bundles instanceof Array)
    throw new TypeError('Positions is not an array') unless (cfg.positions instanceof Array)
    throw new TypeError('Empty bundles') if cfg.bundles.length == 0

    @_cells = new Kanban.CellCache()

    # FIXME: extend measure_default with meas
    for prop of meas
      @sizes[prop] = meas[prop]

    # Look at items
    # Throws exceptions if layout is not valid
    # for item in cfg
    #   @check_item(item)

    # So now we can start creating the Layout
    @bundles = {} 
    for item in cfg.bundles
      kl = new Kanban.Layout.Bundle item, @sizes, @_cells
      @bundles[kl.name] = kl

    # Check position has the right format
    @positions = @create_positions(cfg.positions)

    @compute_bundles_location()

  get_cell: (col_name, sl_name)->
    @_cells.get col_name, sl_name

  # Return the cell that is under point x, y
  get_cell_by_point: (x, y)->
    cell = null
    @_cells.forEach (k, c)->
      if c.isPointInside(x,y)
        cell = c
        false
    cell


  compute_bundles_location: ()->
    @width = 0
    @height = 0

    lines_width = []

    for line in @positions
      lwidth = 0
      lheight = 0
      for name in line
        b = @bundles[name]
        b.x = lwidth
        b.y = @height
        [bw, bh] = b.size()
        lwidth += bw + @sizes.bundle_margin
        lheight = if bh > lheight then bh else lheight
      @height += lheight + @sizes.bundle_margin
      lines_width.push lwidth

    @width = Math.max.apply(null, lines_width)


  each_bundle: (cb)->
    for line in @positions
      for name in line
        cb( @bundles[name])

  create_positions: (pos)->
    # Positions are either array of strings (i.e. the name of the bundles, all on the same 'line')
    # or an array of arrays: each "subarray" represent a "line" of bundle
    # For example if I do want the following arrangement:
    #   
    #       A                             B
    #   +-----+-----+-----+-----+     +---------+
    #   |     |     |     |     |     |         |
    #   |     |     |     |     |     |         |
    #   +-----+-----+-----+-----+     +---------+
    #
    #      C
    #   +-----+
    #   |     |
    #   |     |
    #   +-----+
    # where A, B and C are the name of the bundles, we'll use the following positions:
    #  [ ['A', 'B'], ['C'] ]
    #

    # FIXME: Check that *all* the items are string ...
    if (typeof pos[0] is 'string') || (pos[0] instanceof String)
      # Mono line
      for name in pos
        # Look for the name in the list of Bundle
        throw new TypeError('Bundle does not exist') unless @bundles[name]
      # Normalize it
      pos = [ pos ]
    else if (pos[0] instanceof Array)
      # Multi-line ...
      # FIXME: Check all items of all the lines are strings
      for line in pos
        for name in line
          # Look for the name in the list of Bundle
          throw new TypeError('Bundle does not exist') unless @bundles[name]
    pos

  # # The size of a line is:
  # #  * the sum of the width of each of the line bundle (plus the bundle margin between each bundle)
  # #  * the maximum height of all of the line's bundles

  # line_size: (line)->
  #   # Compute the size of each bundle
  #   bundle_sizes = (@bundles[name].size() for name in line)


  #   width = bundle_sizes.reduce ((x,y)=> x + y[0] + @sizes.bundle_margin), 0
  #   width -= @sizes.bundle_margin
  #   list_of_height = (s[1] for s in bundle_sizes)
  #   height = Math.max.apply(null, list_of_height)
  #   [width, height]


  size: ()->
    return [@width, @height]
