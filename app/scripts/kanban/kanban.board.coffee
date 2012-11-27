window.Kanban = window.Kanban || {}

class Kanban.Board

  constructor: (cfg, @el, @measures) ->
    # @_cells = new Kanban.CellCache()
    @layout = new Kanban.Layout(cfg, @measures)
    [@width, @height] = @layout.size()

    # Size correctly the container
    jnode = $(@el);
    jnode.width(@width)
    jnode.height(@height)

    $(window).resize ()->
      $('.ticket').trigger('window:resized')

    @paper = Raphael jnode[0], @width, @height

  getColumnAndSwimlane: (x,y)->
    [column,swimlane] = [null,null]
    cell = @layout.get_cell_by_point(x,y)
    [column,swimlane] = [cell.col_name, cell.sl_name] if cell != null
    [column,swimlane]

  get_cell_by_point: (x,y)->
    @layout.get_cell_by_point(x,y)

  get_cell: (sl_name, cl_name)->
    @layout.get_cell(cl_name, sl_name)

  # Return all swimlanes name
  swimlanes: ()->
    @layout.swimlane_names()

  draw: () ->
    # Let's draw cells
    @layout.each_bundle (bundle)=> bundle.draw @paper


