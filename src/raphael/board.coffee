class Kb.Raphael.Cell
  @swimlane_height: 400
  @swimlane_title_width: 50
  @column_width: 400
  @column_title_height: 50

  # Return the center of the passed Raphael element
  center: (el)->
    x =  el.attr('x') + (el.attr('width')  / 2 )
    y =  el.attr('y') + (el.attr('height')  / 2 )
    [x,y]


class Kb.Raphael.DroppableCell extends Kb.Raphael.Cell
  width: Kb.Raphael.Cell.column_width
  height: Kb.Raphael.Cell.swimlane_height

  constructor: (@paper, @col_name, @sl_name, @x, @y)->

  draw: ()->
    c = @paper.rect @x, @y, @width, @height
    c.attr fill: "white"
    c.droppable = this
    c

class Kb.Raphael.SwimlaneTitle extends Kb.Raphael.Cell
  width: Kb.Raphael.Cell.swimlane_title_width
  height: Kb.Raphael.Cell.swimlane_height

  constructor: (@paper, @sl_name, @x, @y)->

  draw: ()->
    t = @paper.rect @x, @y, @width, @height
    t.attr fill: "white"
    [cx,cy] = @center t
    text = @paper.text cx, cy, @sl_name
    text.attr({'font-size': 17, 'font-family': 'FranklinGothicFSCondensed-1, FranklinGothicFSCondensed-2'});
    text.attr("fill", "black");
    text.rotate(-90);

class Kb.Raphael.ColumnTitle extends Kb.Raphael.Cell
  width: Kb.Raphael.Cell.column_width
  height: Kb.Raphael.Cell.column_title_height

  constructor: (@paper, @name, @x, @y)->

  draw: ()->
    t = @paper.rect @x, @y, @width, @height
    t.attr fill: "white"
    [cx,cy] = @center t 
    text = @paper.text cx, cy, @name
    text.attr({'font-size': 17, 'font-family': 'FranklinGothicFSCondensed-1, FranklinGothicFSCondensed-2'});
    text.attr("fill", "black");

#
# A basic cache for droppable cells, allowing to retrieve
# them by column_name and swimlane_name
#
class Kb.Raphael.CellCache
  constructor: ()-> @_cache = {}
  hash: (col_name, sl_name)-> "#{col_name}-#{sl_name}"
  put: (droppable)-> @_cache[@hash(droppable.col_name, droppable.sl_name)] = droppable
  get: (col_name, sl_name)-> @_cache[@hash(col_name, sl_name)]


class Kb.Raphael.Board

  constructor: (@model, @el) ->
    @_cells = new Kb.Raphael.CellCache()
    [@width, @height] = @compute_sizes()

    # Size correctly the container
    jnode = $(@el);
    jnode.width(@width)
    jnode.height(@height)

    @paper = Raphael @el, @width, @height

  compute_sizes: () ->
    cw = Kb.Raphael.Cell.column_width
    stw = Kb.Raphael.Cell.swimlane_title_width
    sh = Kb.Raphael.Cell.swimlane_height
    cth = Kb.Raphael.Cell.column_title_height
    width = @model.get('columns').length * cw + stw + 2
    height = @model.get('swimlanes').length * sh + cth + 2
    [width, height]

  drawCells: () ->
    cells = []
    x = Kb.Raphael.Cell.swimlane_title_width 
    for cl in @model.get('columns')
      y = 0
      ctitle = new Kb.Raphael.ColumnTitle @paper, cl, x, y
      ctitle.draw()

      y += Kb.Raphael.Cell.column_title_height
      for sl in @model.get('swimlanes')
        c = new Kb.Raphael.DroppableCell @paper, cl, sl, x, y
        c.draw()
        @_cells.put c
        y += Kb.Raphael.Cell.swimlane_height

      x += Kb.Raphael.Cell.column_width

    # Add swimlane titles
    x = 0
    y = Kb.Raphael.Cell.column_title_height
    for sl in @model.get('swimlanes')
      sl = new Kb.Raphael.SwimlaneTitle @paper, sl, x, y
      sl.draw()
      y += Kb.Raphael.Cell.swimlane_height

  draw: () ->
    # Let's draw cells
    @drawCells()

