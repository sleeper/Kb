class TicketDetailView
    constructor: (@el, @ticket)->
        @so = new SimpleOverlay $(@el)
        @so.overlay.on 'click', @resume_overlay
        @so.dialog.append "<div id=\"ticket_detail\"></div>"
        @ticket_detail = $('#ticket_detail', $(@el))
        @ticket_detail.hide()

        @ticket_detail.append("<h1>#{@ticket.record.get('title')}</h1>")
        @ticket_detail.append("<div class=\"date\"> #{@ticket.record.get('created_on')} / #{@ticket.record.get('entered_on')}</div>")
        @ticket_detail.append("<div class=\"comment\">#{@ticket.record.get('comment')}</div>")
        if @ticket.record.get('help_needed')
            @ticket_detail.append("<button id='help' class=\"btn btn-success help-no-more-needed\">Help no more needed</button>")
        else
            @ticket_detail.append("<button id='help' class=\"btn btn-danger help-needed\">Help needed !</button>")


        @ticket_detail.append("<img class=\"avatar\" src=\"#{@ticket.record.avatar()}\">")
        @avatar = $('.avatar', @ticket_detail)
        @help_needed = $('#help', @ticket_detail)

    show: ()->
        @so.show()
        @ticket_detail.show()

    help_needed_toggle: ()->
        if @help_needed.hasClass('help-needed')
            @help_needed.removeClass 'help-needed btn-danger'
            @help_needed.addClass 'help-no-more-needed btn-success'
            @help_needed.html('Help no more needed.')
        else
            @help_needed.addClass 'help-needed btn-danger'
            @help_needed.removeClass 'help-no-more-needed btn-success'
            @help_needed.html('Help needed!')

    update_avatar: (src)->
        @avatar.attr('src', src)

    on_avatar_click: (cb)->
        @avatar.on 'click', ()-> cb()

    on_help_click: (cb)->
        @help_needed.on 'click', ()=>
            @help_needed_toggle()
            cb()

    resume_overlay: ()=>
      @ticket_detail.hide()
      @ticket_detail.remove()
      @so.overlay.remove()
      @so.dialog.remove()

window.TicketDetailView = TicketDetailView
