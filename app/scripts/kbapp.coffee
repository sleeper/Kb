data = [
  {id: 1, project: 'sles 9 decom', title: "Buy some bread", poc: 'fatma', status: 'on board', priority: 200, column: "backlog", swimlane: "projects", x: 60, y:60, user_id: 1, created_on: "2012-09-20 15:32:12", entered_on: "2012-09-22 09:23:21", comment:" This is a simple task just to check"},
  {id: 2, project: 'feed my fridge', title: "Buy some milk", poc: 'vincent', status: 'on board', priority: 300, column: "in-progress", swimlane: "implementations", x:80, y: 60, user_id: 2, created_on: "2012-09-21 17:32:12", entered_on: "2012-09-23 19:13:11", comment:" This is a simple task just to check"},
  {id: 3, project: 'feed my fridge', title: "Start working", poc: 'fred', status: 'on board', priority: 300, column: "backlog", swimlane: "implementations", x:80, y: 60, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "2012-09-23 19:13:11", comment:"This is the most ennoying ticket ever written"},
  {id: 4, project: 'sles 9 decom', title: "Still thinking about it", poc: 'fatma', status: 'product backlog', priority: 200, column: "backlog", swimlane: "implementations", x:0, y:0, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "", comment:"This is the most ennoying ticket ever written"},
  {id: 5, project: 'sles 9 decom', title: "Are you sure ?", poc: 'vincent', status: 'product backlog', priority: 400, column: "backlog", swimlane: "projects", x:0, y: 0, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "", comment:"This is the most ennoying ticket ever written"}
]
fields = [
        {id: 'id', label: 'ID'},
        {id: 'project', lable: 'Project'}
        {id: 'title', label: 'Title'},
        {id: 'comment', label: 'Comment'},
        {id: 'priority', label: 'Priority'},
        {id: 'created_on', type: 'date', label: "Creation"},
        {id: 'status', label: 'status'},
        {id: 'entered_on', type: 'date', label: "Entered board"},
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

board_state =
  layout:
    columns: [ 'backlog', 'in-progress', 'done' ]
    swimlanes: [ 'projects', 'implementations']

dataset = new recline.Model.Dataset { records: data, fields: fields}

$el = $('#mygrid')
grid = new recline.View.SlickGrid({ model:dataset, state: grid_state })
board = new recline.View.Board
  model: dataset,
  state: board_state


kanbansystem = new recline.View.MultiView
  model: dataset
  el: $el
  views: [
    {
      id: 'board',
      label: 'Board',
      view: board
    },
    { 
      id: 'grid',
      label: 'Grid',
      view: grid
    }
  ]
  sidebarViews: [
    id: 'filterEditor',
    label: 'Filters',
    view: new recline.View.FilterEditor({ model: dataset })
  ]


