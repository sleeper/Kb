
class Kanban.Column
  constructor: (@name, @type = 'default')->

class Kanban.Swimlane
  constructor: (@name)->

class Kanban.Layout

  class @Bundle
    constructor: (cfg, @sizes)->
      @swimlanes = {}
      @columns = {}
      @nb_of_swimlanes = 0
      @nb_of_columns = 0

      for swimlane in cfg.swimlanes
        @nb_of_swimlanes += 1
        @swimlanes[swimlane] = new Kanban.Swimlane swimlane

      for column in cfg.columns
        @nb_of_columns += 1
        [name,type] = column.split(':')
        @columns[name] = new Kanban.Column name, type

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
    sizes = 
        swimlane_height: 10
        column_width: 10
        swimlane_title_width: 10
        column_title_height: 10
        column_margin: 10
        swimlane_margin: 10

    # Let's first check the consistency of the config: we should receive an Array
    # with a defined set of element
    # if !(cfg instanceof Array)
    throw new TypeError('Missing keys') unless cfg.layout? && cfg.positions?
    throw new TypeError('Layout is not an array') unless (cfg.layout instanceof Array)
    throw new TypeError('Positions is not an array') unless (cfg.positions instanceof Array)
    throw new TypeError('Empty layout') if cfg.layout.length == 0

    # FIXME: extend measure_default with meas
    for prop in meas
      sizes[prop] = meas[prop]

    # Look at items
    # Throws exceptions if layout is not valid
    for item in cfg
      @check_item(item)

    # So now we can start creating the Layout
    @bundles = []
    # $.each cfg, (i)=>
    for item in cfg
      @bundles.push new Kanban.Layout.Bundle item, sizes

    # Check position has the right format
    for name in cfg.positions
      # Look for the name in the list of Bundle
      b = (bundle for bundle in @bundles when bundle.name is name)
      throw new TypeError(name +'bundle does not exist') if b.length == 0


  check_item: (item)->
    # Items should either have 2 keys (columns/swimlanes) or only one (cell)
    # in which case we're normalizing it.
    if item.cell
      if (typeof item.cell isnt 'string') && !(item.cell instanceof String)
        throw new TypeError('cell attribute must point to a String')
      # Let's normalize: we're looking only at the first element
      cell = item.cell
      delete item[cell]
      [name, type] = cell.split(':')
      item.columns = [ cell ]
      item.swimlanes = [ name ]

    if !item.columns? || !item.swimlanes?
      throw new TypeError( item + ' has not cell, columns or swimlanes attribute')

    if !(item.columns instanceof Array) || !(item.swimlanes instanceof Array)
      throw new TypeError( item + ': columns and swimlanes attributes must be arrays')

    true

  compute_view_port_size: ()->
    console.log "FRED: FIXME"



