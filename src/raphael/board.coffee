class Kb.Raphael.Board
  swimlane_height: 400
  column_width: 400

  drawCell: (column_name, swimlane_name, x, y, width, height) ->
    c = @paper.rect x, y, width, height
    c.attr fill: "white"
    c.column = column_name
    c.swimlane = swimlane_name
    c.cell = true
    @cells.push c
    c

  draw: (el, @model) ->
    width = @model.columns.length * @column_width
    height = @model.swimlanes.length * @swimlane_height

    @paper = Raphael 0, 0, width, height
    @cells = []
    x = 0
    for cl in @model.columns
      y = 0
      for sl in @model.swimlanes
        c = @drawCell cl, sl, x, y, @column_width, @swimlane_height
        y += @swimlane_height
      x += @column_width

