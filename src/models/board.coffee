class Kb.Models.Board extends Backbone.Model
  width: 1000
  height: 1000

  constructor: (@columns, @swimlanes) ->
    @on "change", ()-> console.log("Something changed")


b = new Kb.Models.Board ['backlog', 'in-progress', 'done'],
                        ['projects', 'implementations']

