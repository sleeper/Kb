class Kanban.Column
  on_drop_start: (swimlane, ticket)=>
    ticket.record.set 
      swimlane: swimlane
      column: @name
      started_on: new Date(),
      x: ticket.xrel,
      y: ticket.yrel

  on_drop_end: (swimlane, ticket)=>
    ticket.record.set 
      swimlane: swimlane
      column: @name
      finished_on: new Date(),
      x: ticket.xrel,
      y: ticket.yrel

  on_drop_onhold: (swimlane, ticket)=>
    # FIXME: We need to get a wake-up date from user and save it
    #        Ticket as-well should have its opacity reduced

    # Get dirty: we already know that view.kb.coffee has created
    # an #overlay element : let's us it an put our form on top of it
    # overlay = $('#overlay');
    # Remove it if it exists
    # overlay.remove() if overlay.length > 0

    root = $(@paper.canvas.parentNode)
    so = new SimpleOverlay( root )
    so.dialog.append('<h1> Enter wake-up date </h1><input type="text" id="datepicker"/>')
    # so.overlay = 
    # root.append('<div id="overlay">&nbsp;</div>')
    # overlay = $('#overlay', root)
    # overlay.hide()
    # overlay.toggle();
    # root.append '<div id="onhold"><h1> Enter wake-up date </h1><input type="text" id="datepicker"/></div>' 
    # ohe = $('#onhold')
    so.overlay.on 'click', ()=> 
      so.overlay.remove()
      so.dialog.remove();

    # Place it 
    # $('.avatar', @ticket_detail).on 'click', () => t.model.set('user_id', Kb.board.current_user.get('id'))
    # ohe.css('opacity',1)
    # ohe.show();    
    # width = ohe.width()
    # height = ohe.height()
    # ohe.css
    #       position: 'fixed',
    #       left: ($(window).width() - width) / 2 
    #       top: ($(window).height() - height) / 2
    so.dialog.show();
    so.center_dialog()
    $('#datepicker').pikaday({ bound: true, firstDay: 1 });

    ticket.record.set 
      column: @name
      onhold_on: new Date(),
      x: ticket.xrel,
      y: ticket.yrel

  on_drop_default: (swimlane, ticket)=>
    ticket.record.set
      swimlane: swimlane
      column: @name,
      x: ticket.xrel,
      y: ticket.yrel

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


