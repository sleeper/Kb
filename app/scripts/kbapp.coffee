data = [
  {id: 1, project: 'sles 9 decom', title: "Buy some bread", poc: 'fatma', status: 'on board', help_needed: false, priority: 200, column: "backlog", swimlane: "projects", x: 60, y:60, user_id: 1, created_on: "2012-09-20 15:32:12", entered_on: "2012-09-22 09:23:21", comment:" This is a simple task just to check"},
  {id: 2, project: 'feed my fridge', title: "Buy some milk", poc: 'vincent', status: 'on board', help_needed: false, priority: 300, column: "in-progress", swimlane: "implementations", x:80, y: 60, user_id: 2, created_on: "2012-09-21 17:32:12", entered_on: "2012-09-23 19:13:11", comment:" This is a simple task just to check"},
  {id: 3, project: 'feed my fridge', title: "Start working", poc: 'fred', status: 'on board', help_needed: false, priority: 300, column: "backlog", swimlane: "implementations", x:80, y: 60, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "2012-09-23 19:13:11", comment:"This is the most ennoying ticket ever written"},
  {id: 4, project: 'sles 9 decom', title: "Still thinking about it", poc: 'fatma', status: 'product backlog', help_needed: false, priority: 200, column: "backlog", swimlane: "implementations", x:1, y:1, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "", comment:"This is the most ennoying ticket ever written"},
  {id: 5, project: 'sles 9 decom', title: "Are you sure ?", poc: 'vincent', status: 'product backlog', help_needed: false, priority: 400, column: "backlog", swimlane: "projects", x:1, y: 1, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "", comment:"This is the most ennoying ticket ever written"}
]

ticket_id = 6

user_data = [
  {id: 1, name: "fred", avatar: "/images/Hulk-01.png"},
  {id: 2, name: "fatma", avatar: "/images/Voodoo\ Doll.png"},
  {id: 3, name: "vincent", avatar: "/images/Iron\ Man-01.png"}
]

fields = [
        {id: 'id', label: 'ID'},
        {id: 'project', lable: 'Project'},
        {id: 'title', label: 'Title'},
        {id: 'comment', label: 'Comment'},
        {id: 'priority', label: 'Priority'},
        {id: 'created_on', type: 'date', label: "Creation"},
        {id: 'status', label: 'status'},
        {id: 'entered_on', type: 'date', label: "Entered board"},
        {id: 'target_date', type: 'date', label: "Target date"},
        {id: 'help_needed', type: 'boolean', label: "Help needed"},
        {id: 'swimlane', label: 'Swimlane'},
        {id: 'column', label: 'Column'},
        {id: 'poc', label: 'POC'}
]

grid_state = {
      gridOptions: {
        editable: true,
        autoEdit: false,
        forceFitColumns: true,
        enableCellNavigation: true,
        enableAddRow: false,
        autoHeight: true
      },
      columnsEditor: [
        { column: 'title', editor: Slick.Editors.Text },
        { column: 'status', editor: Slick.Editors.Text },
        { column: 'comment', editor: Slick.Editors.LongText },
        { column: 'project', editor: Slick.Editors.Text }
      ]
}

users = new Kanban.UserList();
users.reset( user_data );

users.current_user = users.get(1)

# The board (or we should say boards) layout is an array composed of several boards
# or individual cells (i.e. degraded board)
# Each item of the array is either:
#  * a hash: with 2 different keys: columns and swimlanes. Each of these columns
#    is associated to an array value which is the list of columns and swimlanes
#    Note that the name of a column (plain string) can be postfixed by the type of
#    the column, preceded by ':' (e.g. 'backlog:done'). The type of a column can be:
#       - start: entry for this swimlane
#       - end: output for the swimlane (i.e. 'done')
#       - onhold: ticket placed in this cell/column will be put on hold (i.e. no more displayed
#            on the board, and associated with a wake-up date)

board_state =
  layout: {
    bundles: [
      {
        name: 'board',
        columns: [ 'backlog:start', 'in-progress', 'done:end' ],
        swimlanes: [ 'projects', 'implementations']
      },
      {
        name: 'on hold',
        cell: 'On hold:onhold'
      }
    ],
    positions: [
      [ 'board', 'on hold']
    ]
  }
  measures:
        swimlane_height: 600
        column_width: 400
        swimlane_title_width: 50
        column_title_height: 50
        column_margin: 20
        swimlane_margin: 20
        bundle_margin: 20
  users: users


dataset = new recline.Model.Dataset { records: data, fields: fields}

$el = $('#kanban')
$el.append '<div id="grid"></div>'
$el.append '<div id="board"></div>'
$kb = $("#board", $el)
$grid = $("#grid", $el)


grid = new recline.View.SlickGrid({ model:dataset, state: grid_state })
board = new recline.View.Board
  model: dataset,
  state: board_state

grid.render()
$grid.append grid.el
$grid.append '<button id="new" class="btn btn-primary btn-large">New item</button>'

$('#new').click ()=>
  nif = new ItemForm $('body')
  nif.show()
  nif.on_submit ()->
    # For the time being:
    #   - check the parameters
    #   - add it to the items
    ticket_data = nif.data()
    # FIXME: Here we should do a first set of checks, then add it to the collection
    # where it will be sent over the line to the server to get a real ID
    # Let's fake the idea for now
    ticket_data.id = ticket_id
    ticket_id += 1
    ticket_data.created_on = new Date()
    ticket_data.x = 1
    ticket_data.y = 1
    ticket_data.help_needed = false
    ticket_data.status = "product backlog"
    ticket_data.column ?= "backlog"
    dataset.records.add [ ticket_data]
    console.log "FRED: New item submitted"

board.render()
$kb.append board.el

router = new Kanban.AppRouter()

router.on 'route:grid', ()=>
  console.log "FRED: Grid"
  board.hide()
  $grid.show()
  grid.el.show()
  grid.show()

router.on 'route:board', ()=>
  console.log "FRED: Board"
  board.show()
  $grid.hide()
  grid.hide()
  grid.el.hide()


Backbone.history.start()
router.navigate("/board")

# To be moved elsewhere

$('.navbar li').click (e)->
  $('.navbar li').removeClass('active')
  $el = $(@)
  if !$el.hasClass('active')
    $el.addClass 'active'
  # e.preventDefault()

# kanbansystem = new recline.View.MultiView
#   model: dataset
#   el: $el
#   views: [
#     {
#       id: 'board',
#       label: 'Board',
#       view: board
#     },
#     {
#       id: 'grid',
#       label: 'Grid',
#       view: grid
#     }
#   ]
#   sidebarViews: [
#     id: 'filterEditor',
#     label: 'Filters',
#     view: new recline.View.FilterEditor({ model: dataset })
#   ]


