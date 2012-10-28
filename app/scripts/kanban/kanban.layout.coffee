
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
  # FIXME: Document extensively the format of the config
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
    throw new TypeError('layout is not ana array.') unless (cfg instanceof Array)
    throw new TypeError('empty layout') if cfg.length == 0

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



