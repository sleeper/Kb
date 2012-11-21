class Kanban.Swimlane
  constructor: (@name, @title_width, @height)->

  draw_title: (paper, x, y)->
    t = paper.rect x, y, @title_width, @height
    t.attr fill: "white", stroke: "none"
    t.node.id = "swimlane #{@name} title"
    [cx,cy] = Kanban.Cell.center t
    text = paper.print cx, cy, @name, paper.getFont("Yanone Kaffeesatz Bold"), 40, "middle"
    bbox = text.getBBox()
    # Correct text position
    text.transform "R-90T-#{bbox.width/2+10},0"
    text.attr("fill", "black");

