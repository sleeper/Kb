class Kanban.Column
  on_drop_start: (swimlane, ticket)=>
    ticket.record.set 
      swimlane: swimlane
      column: @name
      started_on: new Date()

  on_drop_end: (swimlane, ticket)=>
    ticket.record.set 
      swimlane: swimlane
      column: @name
      finished_on: new Date()

  on_drop_onhold: (swimlane, ticket)=>
    ticket.record.set 
      column: @name
      onhold_on: new Date()

  on_drop_default: (swimlane, ticket)=>
    ticket.record.set
      swimlane: swimlane
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

  on_drop: (col, sl, ticket)=>
    callbacks= 
      start: @on_drop_start
      end: @on_drop_end
      onhold: @on_drop_onhold
      default: @on_drop_default

    return unless col == @name
    callbacks[@type](sl, ticket)

  constructor: (@name, @type, @width, @title_height)->
    eve.on 'column.dropped', @on_drop


