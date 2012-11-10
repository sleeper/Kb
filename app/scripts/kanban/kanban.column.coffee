class Kanban.Column
  on_drop_start: (swimlane, column, ticket)=>
    console.log 'FIXME: On drop in a start column'

  on_drop_end: (swimlane, column, ticket)=>
    console.log 'FIXME: On drop in a end column'

  on_drop_onhold: (swimlane, column, ticket)=>
    console.log 'FIXME: On drop in a onhold column'

  draw_title: (paper, x, y)->
    t = paper.rect x, y, @width, @title_height
    t.node.id = "column #{@name} title"
    t.attr fill: "white", stroke: "none"
    [cx,cy] = Kanban.Cell.center t 
    text = paper.print cx, cy, @name, paper.getFont("Yanone Kaffeesatz Bold"), 40, "middle"
    bbox = text.getBBox()
    # Correct text position
    text.transform "t-#{bbox.width/2},-5"
    text.attr("fill", "black")


  constructor: (@name, @type, @width, @title_height)->
    callbacks= 
      start: @on_drop_start
      end: @on_drop_end
      onhold: @on_drop_onhold

    # FIXME: Check @type is "in range"
    @on_drop = callbacks[@type]

