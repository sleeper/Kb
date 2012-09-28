# The following fields are available for this model:
#  - title (string): the is the title of the ticket
#  - column (string): this is the column name the current ticket is in
#  - swimlane (string): this is the swimlane name the current ticket is in
#  - x, y : the position *relative*( to the cell the ticket is in.
#  - user_id (int): ID of the user currently in charge of this ticket
#  - created_on: the date and time of thie ticket creation
#  - entered_on: the date and time this ticket has entered the board
#  - comment (string): additional comment/content for the ticket
#
class Kb.Models.Ticket extends Backbone.Model
  defaults:
    title: ""
    column: ""
    swimlane: ""
    user_id: 0
    x: 0
    y: 0
    created_on: null
    entered_on: null
    comment: ""

  #
  # Change the type of the furnished attribute (if it is not null)
  # to a date
  # If the parse is failing, set date to beginning of Universe
  #
  toDate: (attr)->
    return unless @orig_options[attr]

    milli = Date.parse( @orig_options[attr] )
    if isNaN(milli) 
      milli = 0
    @set(attr, new Date( milli))

  initialize: (@orig_options={})->
    @toDate('created_on')
    @toDate('entered_on')
