
class Kanban.Column
  constructor: (@name, @type = 'default')->

class Kanban.Swimlane
  constructor: (@name)->

class Kanban.Config

  class Bundle
    constructor: (cfg)->
      @swimlanes = {}
      @columns = {}

      for swimlane in swimlanes
        @swimlanes[swimlane] = new Kanban.Swimlane swimlane

      for column in columns
        [name,type] = column.split(':')
        @columns[name] = new Kanban.Column name, type

  #
  # FIXME: Document extensively the format of the config
  constructor: (cfg)->
    # Let's first check the consistency of the config: we should receive an Array
    # with a defined set of element
    if !(cfg instanceof Array)
      # FIXME: We should yelll out LOUD !
      console.log "ERROR: Cfg is not en array !"
      return

    # Look at items
    #$.each cfg, (i)=> 
    for item in cfg
      if !@check_item(item)
        return {}

    # So now we can start creating the config
    @bundles = []
    # $.each cfg, (i)=>
    for item in cfg
      @bundles.push new Kanban.Config.Bundle item


  check_item: (item)->
    # Items should either have 2 keys (columns/swimlanes) or only one (cell)
    # in which case we're normalizing it.
    if item.cell
      # Let's normalize: we're looking only at the first element
      cell = item.cell[0]
      delete item[cell]
      [name, type] = cell.split(':')
      item.columns = [ cell ]
      item.swimlanes = [ name ]

    if !item.columns? || !item.swimlanes?
      # FIXME: Shout really LOUD
      console.log "ERROR: The item must have both columns and swimlanes defined"
      return false

    if !(item.columns instanceof Array) || !(item.swimlanes instanceof Array)
      # FIXME: Shout really LOUD3yy
      console.log "ERROR: item's columns and swimlanes must be Arrays"
      return false



