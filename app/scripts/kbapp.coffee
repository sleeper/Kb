data = [
  {id: 1, title: "Buy some bread", status: 'board', column: "backlog", swimlane: "projects", x: 60, y:60, user_id: 1, created_on: "2012-09-20 15:32:12", entered_on: "2012-09-22 09:23:21", comment:" This is a simple task just to check"},
  {id: 2, title: "Buy some milk", status: 'board', column: "in-progress", swimlane: "implementations", x:80, y: 60, user_id: 2, created_on: "2012-09-21 17:32:12", entered_on: "2012-09-23 19:13:11", comment:" This is a simple task just to check"},
  {id: 3, title: "Start working", status: 'board', column: "backlog", swimlane: "implementations", x:80, y: 60, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "2012-09-23 19:13:11", comment:"This is the most ennoying ticket ever written"},
  {id: 4, title: "Still thinking about it", status: 'backlog', column: "", swimlane: "", x:0, y:0, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "", comment:"This is the most ennoying ticket ever written"},
  {id: 5, title: "Are you sure ?", status: 'backlog', column: "", swimlane: "", x:0, y: 0, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "", comment:"This is the most ennoying ticket ever written"}
]
fields = [
        {id: 'id', label: 'ID'},
        {id: 'title', label: 'Title'},
        {id: 'created_on', type: 'date', label: "Creation"},
        {id: 'entered_on', type: 'date', label: "Entered board"},
        {id: 'swimlane', label: 'Swimlane'},
        {id: 'status', label: 'Status'},
        {id: 'user_id', label: 'User'},
        {id: 'comment', label: 'Comment'}
]

state = {
      gridOptions: {
        editable: true, 
        autoEdit: false, 
        forceFitColumns: true, 
        showHeaderRow: true, 
        enableCellNavigation: true,
        autoHeight: true
      },
      columnsEditor: [
        { column: 'title', editor: Slick.Editors.Text }
      ]
}


dataset = new recline.Model.Dataset { records: data, fields: fields}

$el = $('#mygrid')
grid = new recline.View.SlickGrid({ model:dataset, state: state })

kanbansystem = new recline.View.MultiView
  model: dataset
  el: $el
  views: [
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


