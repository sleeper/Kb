class Kanban.Column
  on_drop_start: (swimlane, ticket)=>

  on_drop_end: (swimlane, ticket)=>
    ticket.record.set 
      swimlane: swimlane.name
      column: @name
      finished_on: new Date()

  on_drop_onhold: (swimlane, ticket)=>
    ticket.record.set 
      column: @name
      onhold_on: new Date()

  on_drop_default: (swimlane, ticket)=>
    ticket.record.set
      swimlane: swimlane.name
      column: @name

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
      default: @on_drop_default

    # FIXME: Check @type is "in range"
    @on_drop = callbacks[@type]

