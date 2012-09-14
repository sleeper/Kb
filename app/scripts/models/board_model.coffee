class Kb.Models.Board extends Backbone.Model
  defaults:
    swimlanes: []
    columns: []

  url: ()->
    "/boards/#{this.id}"

  validate: (attribs)->
    name_empty = !attribs.name
    if name_empty
      "Name must not be nil or empty"
    else
      null

