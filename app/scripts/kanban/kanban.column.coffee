class Kanban.Column
  on_drop_start: (swimlane, ticket)=>
    ticket.record.set 
      swimlane: swimlane
      column: @name
      entered_on: new Date()
      x: ticket.xrel
      y: ticket.yrel
      wakeup_on: null


  on_drop_end: (swimlane, ticket)=>
    ticket.record.set 
      swimlane: swimlane
      column: @name
      finished_on: new Date()
      x: ticket.xrel
      y: ticket.yrel
      wakeup_on: null


  on_drop_onhold: (swimlane, ticket)=>
    # Let's request a wake-up date from user
    root = $(@paper.canvas.parentNode)
    so = new SimpleOverlay( root )
    so.dialog.append('<h1> Enter wake-up date </h1><p/><input type="text" id="datepicker"/>')
    date_input = $('#datepicker', so.dialog)
    so.overlay.on 'click', ()=> 
      # This is equivalent to cancel ...
      so.overlay.remove()
      so.dialog.remove()
      ticket.reset()

    so.show();
    $('#datepicker').pikaday
      bound: true
      minDate: new Date()
      firstDay: 1
      onSelect: ()=>
        ticket.record.set wakeup_on: new Date(date_input.val())
        ticket.record.set 
          column: @name
          onhold_on: new Date()
          x: ticket.xrel
          y: ticket.yrel
        so.overlay.remove()
        so.dialog.remove()


  on_drop_default: (swimlane, ticket)=>
    ticket.record.set
      swimlane: swimlane
      column: @name
      x: ticket.xrel
      y: ticket.yrel
      wakeup_on: null

  draw_title: (@paper, x, y)->
    t = @paper.rect x, y, @width, @title_height
    t.node.id = "column #{@name} title"
    t.attr fill: "white", stroke: "none"
    [cx,cy] = Kanban.Cell.center t 
    text = @paper.print cx, cy, @name, @paper.getFont("Yanone Kaffeesatz Bold"), 40, "middle"
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


