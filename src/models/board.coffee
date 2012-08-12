class Kb.Models.Board extends Backbone.Model

  constructor: (@columns, @swimlanes) ->
    @on "change", ()-> console.log("Something changed")



