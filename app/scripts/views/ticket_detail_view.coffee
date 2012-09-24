class Kb.Views.TicketDetailView extends Backbone.View
  # FIXME: must be changed on model change

  resize: ()->
    @width = @ticket_detail.width()
    @height = @ticket_detail.height()
    @ticket_detail.css({
                position: 'fixed',
                left: ($(window).width() - @width) / 2,
                top: ($(window).height() - @height) / 2
            });


  render: =>
    overlay_tmpl = '<div id="overlay">&nbsp;</div>'
    detail_tmpl = "<div id=\"ticket_detail\">Details for ticket '#{@model.get('title')}'</div>"

    $(@el).html(overlay_tmpl + detail_tmpl)
    overlay = $('#overlay', $(@el))
    @ticket_detail = $('#ticket_detail', $(@el))
    overlay.show()
    @ticket_detail.show();
    @resize()
    @


