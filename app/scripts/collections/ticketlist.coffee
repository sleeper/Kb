class Kb.Collections.TicketList extends Backbone.Collection
  model: Kb.Models.Ticket

  url: () ->
    "/tickets/"
