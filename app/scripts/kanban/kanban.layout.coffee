
class Kanban.Column
  on_drop_start: (swimlane, column, ticket)=>
    console.log 'FIXME: On drop in a start column'

  on_drop_end: (swimlane, column, ticket)=>
    console.log 'FIXME: On drop in a end column'

  on_drop_onhold: (swimlane, column, ticket)=>
    console.log 'FIXME: On drop in a onhold column'

  constructor: (@name, @type = 'default')->
    callbacks= 
      start: @on_drop_start
      end: @on_drop_end
      onhold: @on_drop_onhold

    # FIXME: Check @type is "in range"
    @on_drop = callbacks[@type]

class Kanban.Swimlane
  constructor: (@name)->

class Kanban.Layout

  class @Bundle
    constructor: (cfg, @sizes)->
      @swimlanes = {}
      @columns = {}
      @nb_of_swimlanes = 0
      @nb_of_columns = 0

      # Check everything is fine with the input
      @check(cfg)

      @name = cfg.name

      for swimlane in cfg.swimlanes
        @nb_of_swimlanes += 1
        @swimlanes[swimlane] = new Kanban.Swimlane swimlane

      for column in cfg.columns
        @nb_of_columns += 1
        [name,type] = column.split(':')
        @columns[name] = new Kanban.Column name, type

    check: (cfg)->
      throw new TypeError('Missing name') unless cfg.name?

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
    throw new TypeError('Missing keys') unless cfg.layout? && cfg.positions?
    throw new TypeError('Layout is not an array') unless (cfg.layout instanceof Array)
    throw new TypeError('Positions is not an array') unless (cfg.positions instanceof Array)
    throw new TypeError('Empty layout') if cfg.layout.length == 0

    # FIXME: extend measure_default with meas
    for prop in meas
      @sizes[prop] = meas[prop]

    # Look at items
    # Throws exceptions if layout is not valid
    # for item in cfg
    #   @check_item(item)

    # So now we can start creating the Layout
    @bundles = {} 
    for item in cfg.layout
      kl = new Kanban.Layout.Bundle item, @sizes
      @bundles[kl.name] = kl

    # Check position has the right format
    @positions = @check_positions(cfg.positions)


  check_positions: (pos)->
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

  # The size of a line is:
  #  * the sum of the width of each of the line bundle (plus the bundle margin between each bundle)
  #  * the maximum height of all of the line's bundles

  line_size: (line)->
    # Compute the size of each bundle
    bundle_sizes = (@bundles[name].size() for name in line)


    width = bundle_sizes.reduce ((x,y)=> x + y[0] + @sizes.bundle_margin), 0
    width -= @sizes.bundle_margin
    list_of_height = (s[1] for s in bundle_sizes)
    height = Math.max.apply(null, list_of_height)
    [width, height]


  compute_viewport_size: ()->
    @width = 0
    @height = 0

    # The with will be the maximum width for all the lines
    # The height will be the height of each line plus the bundle margin between each line
    # So let's compute the size of each line
    line_sizes = (@line_size(line) for line in @positions)

    @height = line_sizes.reduce ((x,y)=> x + y[1] + @sizes.bundle_margin),0
    @height -= @sizes.bundle_margin
    @width = Math.max.apply(null, ( s[0] for s in line_sizes))

    [@width, @height]



