var data = [
  {id: 1, title: "Buy some bread", status: 'board', column: "backlog", swimlane: "projects", x: 60, y:60, user_id: 1, created_on: "2012-09-20 15:32:12", entered_on: "2012-09-22 09:23:21", comment:" This is a simple task just to check"},
  {id: 2, title: "Buy some milk", status: 'board', column: "in-progress", swimlane: "implementations", x:80, y: 60, user_id: 2, created_on: "2012-09-21 17:32:12", entered_on: "2012-09-23 19:13:11", comment:" This is a simple task just to check"},
  {id: 3, title: "Start working", status: 'board', column: "backlog", swimlane: "implementations", x:80, y: 60, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "2012-09-23 19:13:11", comment:"This is the most ennoying ticket ever written"},
  {id: 4, title: "Still thinking about it", status: 'backlog', column: "", swimlane: "", x:0, y:0, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "", comment:"This is the most ennoying ticket ever written"},
  {id: 5, title: "Are you sure ?", status: 'backlog', column: "", swimlane: "", x:0, y: 0, user_id: null, created_on: "2012-09-21 17:32:12", entered_on: "", comment:"This is the most ennoying ticket ever written"}
];

var dataset = new recline.Model.Dataset({ records: data });


var $el = $('#mygrid');
/*
var grid = new recline.View.SlickGrid({
  model: dataset,
  el: $el
});
*/
var grid = new recline.View.SlkGrid({
  model: dataset,
  el: $el,
  state: {
    gridOptions: {editable: true, autoEdit: true },
//    columnsWidth: [{column: "status", width: "120px"}],
    columnsEditor: [
      {column: "status", editor: Slick.Editors.YesNoSelect},
      {column: "entered_od", editor: Slick.Editors.Dataset}
    ]
  }
 // options: {
 //    editable: true,
 //    enableCellNavigation: true,
 //    autoEdit: true,
 //    columns: {
 //      status: {editor: Slick.Editors.YesNoSelect},
 //      entered_on: {editor: Slick.Editors.Date}
 //    }
 // }
});
/*
var grid = new recline.View.Grid({
  model: dataset,
  el: $el
});*/
grid.visible = true;
grid.render();

