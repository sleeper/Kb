class Kb.Views.TicketDetailView extends Backbone.View
  #@events:
  #  "change": "render"

  # To be given:
  #   model
  #   boardview: the view of the enclosing board
  #  initialize:() ->

  render: =>
    overlay_tmpl = '<div id="overlay">&nbsp;</div>'
    detail_tmpl = "<div id=\"ticket_detail\">Details for ticket '#{@model.get('title')}'</div>"

    $(@el).html(overlay_tmpl + detail_tmpl)
    overlay = $('#overlay', $(@el))
    ticket_detail = $('#ticket_detail', $(@el))
    overlay.show()
    ticket_detail.show();
    # FIXME: the size of the ticket_detail i, for the time being, equal to 0
    # as it has not yet been drawn
    # We need to reposition it later, when it has been displayed... Event ?
    ticket_detail.css({
                position: 'absolute',
                left: ($(window).width() - ticket_detail.width()) / 2,
                top: ($(window).height() - ticket_detail.height()) / 2
            });
    @


