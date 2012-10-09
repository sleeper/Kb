class Kb.Views.ProductBacklogView extends Backbone.View

  # To be given:
  #   model: the model to use
  #   id: the id of the div to insert the board in 
  initialize: ()->
    @model.get('tickets').bind 'add', @addOne, this
    @model.get('tickets').bind 'reset', @addAll, this

  addOne: (ticket)->
    console.log "Ticket '#{ticket.get('title')}' to be displayed in table."
    $(@el).handsontable("setDataAtCell", data);


  addAll: ()->
    @model.get('tickets').each (t)=>
      console.log( "Adding ticket '" + t.get('title')+"'" )
      @addOne( t );

  toggle: () =>
    $(@el).toggle()

  render: =>
    console.log "Rendering product backlog"
    $(@el).handsontable
      rows: 5,
      cols: 5,
      minSpareCols: 1, #always keep at least 1 spare col at the right
      minSpareRows: 1  #always keep at least 1 spare row at the bottom

    data = @model.get('tickets').map (t)->t.toJSON()

    $(@el).handsontable("loadData", data);

