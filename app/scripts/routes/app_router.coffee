class Kb.Routers.AppRouter extends Backbone.Router
  initialize: (options)->
    @tickets = options.tickets

  routes:
    "tickets/:id": "ticketDetail",
    "*actions": "defaultRoute" # Backbone will try match the route above first

  ticketDetail: (id)->
    console.log "[DEBUG] We should create a new detailled view"
    #        this.wine = this.wineList.get(id);
    #    this.wineView = new WineView({model:this.wine});
    #    $('#content').html(this.wineView.render().el);

    # FIXME: 
    #   - Get the right Ticket model object
    #   - Remove the TicketDetailView if it already exists
    #   - Create the TicketDetailView passing it the mode
    #
    @ticket = @tickets.get(id)
    # FIXME: Treat the case the id is invalid

    details = $('#details', $(document))
    if details
      details.remove()
    $(document.body).append '<div id="details"></div>'
    details = $('#details', $(document))
    @ticket_detail_view = new Kb.Views.TicketDetailView({model: @ticket})
    dv = @ticket_detail_view.render().el
    details.append(dv)
    # Now the view is displayed, ensure it's perfectly displayed
    @ticket_detail_view.resize()

    # FIXME: Append it to the HTML document

    #    overlay = $('#overlay')
    #    ticket_detail = $('#ticket_detail')
    #    overlay.show()
    #    ticket_detail.css({
    #                position: 'absolute',
    #                left: ($(window).width() - $('#ticket_detail').width()) / 2,
    #                top: ($(window).height() - $('#ticket_detail').height()) / 2
    #            });
    #    ticket_detail.show();
#      var email = new Email({
#        id: id
#      });
#      this.emailView.remove() if this.emailView 
#      this.emailView = new EmailView({
#        model: email
#      });
#      email.fetch();
#    }

  defaultRoute: (actions)->
    #    overlay = $('#overlay')
    #overlay.hide()
    $('body').removeClass('dialog_open')
#    ticket_detail = $('#ticket_detail')
#    ticket_detail.hide();
    console.log "[DEBUG] Default route"

