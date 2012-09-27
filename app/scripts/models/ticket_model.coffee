# The following fields are available for this model:
#  - title (string): the is the title of the ticket
#  - column (string): this is the column name the current ticket is in
#  - swimlane (string): this is the swimlane name the current ticket is in
#  - x, y : the position *relative*( to the cell the ticket is in.
#  - user_id (int): ID of the user currently in charge of this ticket
#  - creation_time: the date and time of thie ticket creation
#  - entered_time: the date and time this ticket has entered the board
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
    creation_time: ""
    entered_time: ""
    comment: ""
