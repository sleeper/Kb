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

  # Each ticket on the board has a x and y coordinate, relative to 
  # the cell it is placed in.
  # This method allows for computation of the absolute x and y
  compute_absolute_coordinates: (cl_name, sl_name, rx, ry)->
    cell = @layout.get_cell(cl_name, sl_name)
    # FIXME: handle the case cell is empty
    # delegate to cell
    cell.compute_absolute_coordinates(rx, ry)

  compute_relative_coordinates: (cl_name, sl_name, ax, ay)->
    cell = @layout.get_cell(cl_name, sl_name)
    cell.compute_relative_coordinates(ax, ay)

  getColumnAndSwimlane: (x,y)->
    [column,swimlane] = [null,null]
    cell = @layout.get_cell_by_point(x,y)
    [column,swimlane] = [cell.col_name, cell.sl_name] if cell != null
    [column,swimlane]

  draw: () ->
    # Let's draw cells
    @layout.each_bundle (bundle)=> bundle.draw @paper 


