class Kb.Views.TicketDetailView extends Backbone.View
  # FIXME: must be updated on model change

  resume: ()->
    # Navigate to this ticket
    Backbone.history.navigate('/tickets', true)

  resize: ()->
    @width = @ticket_detail.width()
    @height = @ticket_detail.height()
    @ticket_detail.css({
                position: 'fixed',
                left: ($(window).width() - @width) / 2,
                top: ($(window).height() - @height) / 2
            });

  add_overlay: ()->
    $(@el).append('<div id="overlay">&nbsp;</div>')
    @overlay = $('#overlay', $(@el))
    @overlay.show()
    @overlay.on('click', @resume)

  add_details: ()->
    #    $(@el).append("<div id=\"ticket_detail\">Details for ticket '#{@model.get('title')}'</div>")
    $(@el).append("<div id=\"ticket_detail\"></div>")
    @ticket_detail = $('#ticket_detail', $(@el))
    @ticket_detail.append("<h1>#{@model.get('title')}</h1>")
    @ticket_detail.append("<div class=\"date\"> #{@model.get('created_on').toDateString()} / #{@model.get('entered_on').toDateString()}</div>")
    @ticket_detail.append("<div class=\"comment\">#{@model.get('comment')}</div>")

    # FIXME: Add the avatar of the user OR a button for the user to take care 
    #        of the ticket.

    @ticket_detail.show();
    @resize()


  render: =>
    @add_overlay()
    @add_details()
    @


