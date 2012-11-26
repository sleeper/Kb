class Kanban.AppRouter extends Backbone.Router
    routes:
        "board": "board",
        "grid": "grid",
        "*actions": "defaultRoute" # Backbone will try match the route above first

    defaultRoute: (actions)->
        console.log "[DEBUG] Default route"

