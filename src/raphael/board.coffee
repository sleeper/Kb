class Kb.Raphael.Board
  swimlane_height: 400
  swimlane_title_width: 50
  column_width: 400
  column_title_height: 50

  drawCell: (column_name, swimlane_name, x, y) ->
    c = @paper.rect x, y, @column_width, @swimlane_height
    c.attr fill: "white"
    c.column = column_name
    c.swimlane = swimlane_name
    c.cell = true
    c

  compute_sizes: () ->
    width = @model.get('columns').length * @column_width + @swimlane_title_width + 2
    height = @model.get('swimlanes').length * @swimlane_height + @column_title_height + 2
    [width, height]

  center: (el) ->
    x =  el.attr('x') + (el.attr('width')  / 2 )
    y =  el.attr('y') + (el.attr('height')  / 2 )
    [x,y]

  drawSwimlaneTitle: (sl, x, y) ->
    t = @paper.rect x, y, @swimlane_title_width, @swimlane_height
    t.attr fill: "white"
    [cx,cy] = @center t
    text = @paper.text cx, cy, sl
    text.attr({'font-size': 17, 'font-family': 'FranklinGothicFSCondensed-1, FranklinGothicFSCondensed-2'});
    text.attr("fill", "black");
    text.rotate(-90);

  drawColumnTitle: (cl, x, y) ->
    t = @paper.rect x, y, @column_width, @column_title_height
    t.attr fill: "white"
    [cx,cy] = @center t 
    text = @paper.text cx, cy, cl
    text.attr({'font-size': 17, 'font-family': 'FranklinGothicFSCondensed-1, FranklinGothicFSCondensed-2'});
    text.attr("fill", "black");

  drawCells: () ->
    cells = []
    x = @swimlane_title_width 
    for cl in @model.get('columns')
      y = 0
      @drawColumnTitle cl, x , y
      y += @column_title_height
      for sl in @model.get('swimlanes')
        c = @drawCell cl, sl, x, y
        cells.push c
        y += @swimlane_height
      x += @column_width

    # Add swimlane titles
    x = 0
    y = @column_title_height
    for sl in @model.get('swimlanes')
      @drawSwimlaneTitle sl, x, y
      y += @swimlane_height

    cells

  draw: (el, @model) ->
    [width, height] = @compute_sizes()

    # Size correctly the container
    jnode = $(el);
    jnode.width(width)
    jnode.height(height)

    @paper = Raphael el, width, height

    # Let's draw cells
    @cells = @drawCells()

