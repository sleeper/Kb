class Kb.Raphael.Ticket
  width: 70
  height: 90

  constructor: (@board, @model)->
    @board.paper

  move: (dx, dy)=>
    console.log("Ticket is moving")
    @frame.attr({x: this.ox + dx, y: this.oy + dy});
    # We need to notify the cell we're entering in, as well
    # as the cell we're leaving
    #
  # cell = board.getCellByPoint(this.attr("x"), this.attr("y"));
  # if (cell.name != this.cell.name) {
  #  this.cell.attr({fill: "white"});
  #  this.cell = cell;
  #  this.cell.attr({fill: "gray"});
  # }


  start: ()=>
    console.log("Ticket is going to move")
    @frame.animate({opacity: .25}, 500, ">");
    @ox = @frame.attr("x");
    @oy = @frame.attr("y");
    # We need to track the origin cell
    #
    # Get orig cell
    # this.orig_cell = board.getCellByPoint(this.ox, this.oy);
    # this.cell = this.orig_cell;

  up: ()=>
    console.log("Ticket is going to land")
    @frame.animate({opacity: 1}, 500, ">");
    # We need to notify the cell we're landing in it
  # this.cell.attr({fill: "white"});


  draw: ()->
    # FIXME: dummy first
    console.log "Rendering ticket '#{@model.get('title')}'"
    [x,y] = @board.compute_absolute_coordinates @model.get('column'), @model.get('swimlane'),@model.get('x'), @model.get('y')
    @frame = @board.paper.rect( x, y, @width, @height)
    @frame.attr({fill: "#ffffff"})
    @frame.drag(@move, @start, @up)
