class Kb.Routers.AppRouter extends Backbone.Router
  routes:
    "tickets/:id": "ticketDetail",
    "*actions": "defaultRoute" # Backbone will try match the route above first

  ticketDetail: (id)->
    console.log "[DEBUG] We should create a new detailled view"
    # FIXME: 
    #   - Get the right Ticket model object
    #   - Remove the TicketDetailView if it already exists
    #   - Create the TicketDetailView passing it the mode
    #
    overlay = $('#overlay')
    ticket_detail = $('#ticket_detail')
    overlay.show()
    ticket_detail.css({
                position: 'absolute',
                left: ($(window).width() - $('#ticket_detail').width()) / 2,
                top: ($(window).height() - $('#ticket_detail').height()) / 2
            });
    ticket_detail.show();
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
    console.log "[DEBUG] Default route"

