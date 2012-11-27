class Kanban.Bundle
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

  swimlane_names: ()->
    sl_names = []
    sl_names.push sl for sl, _ of @swimlanes
    sl_names

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

