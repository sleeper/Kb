window.Kanban = window.Kanban || {}

class Kanban.Cell
  hovered_color: "rgb(227,225,226)"
  background_color: "white"

  @center: (el)->
    x =  el.attr('x') + (el.attr('width')  / 2 )
    y =  el.attr('y') + (el.attr('height')  / 2 )
    [x,y]

  constructor: (@paper, @col_name, @sl_name, @x, @y, @width, @height)->
    @scope = @
    eve.on "cell.leaving", @left
    eve.on 'cell.entering', @entered
    eve.on 'cell.dropped', @dropped

  # Return the absolute x and y coordinates from the relative ones
  compute_absolute_coordinates: (rx, ry)->
    [ @x + rx, @y + ry ]

  # Return the (x,y) relatives to this cell
  compute_relative_coordinates: (ax, ay)->
    [ ax - @x, ay - @y]

  isPointInside: (x,y)->
    @el.isPointInside(x,y)

  entered: (col, sl)=>
    if col == @col_name && sl == @sl_name
      @el.attr({fill: @hovered_color})

  left: (col, sl)=>
    if col == @col_name && sl == @sl_name
      @el.attr({fill: @background_color})

  dropped: (col,sl)=>
    if col == @col_name && sl == @sl_name
      @el.attr({fill: @background_color})

  draw: ()->
    @el = @paper.rect @x, @y, @width, @height
    @el.node.id = "cell #{@col_name}-#{@sl_name}"
    @el.attr({fill: @background_color, 'stroke-linejoin': "round", 'stroke-width': 3})
    @el.droppable = this
    @el

