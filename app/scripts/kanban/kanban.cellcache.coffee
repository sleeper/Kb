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

