
class Kanban.Column
  constructor: (@name, @type = 'default')->

class Kanban.Swimlane
  constructor: (@name)->

class Kanban.Config

  class Bundle
    constructor: (cfg)->
      @swimlanes = {}
      @columns = {}

      for swimlane in cfg.swimlanes
        @swimlanes[swimlane] = new Kanban.Swimlane swimlane

      for column in cfg.columns
        [name,type] = column.split(':')
        @columns[name] = new Kanban.Column name, type

  #
  # FIXME: Document extensively the format of the config
  constructor: (cfg)->
    # Let's first check the consistency of the config: we should receive an Array
    # with a defined set of element
    # if !(cfg instanceof Array)
    throw new TypeError('layout is not ana array.') unless (cfg instanceof Array)
    throw new TypeError('empty layout') if cfg.length == 0

    # Look at items
    # Throws exceptions if layout is not valid
    for item in cfg
      @check_item(item)

    # So now we can start creating the config
    @bundles = []
    # $.each cfg, (i)=>
    for item in cfg
      @bundles.push new Bundle item


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



