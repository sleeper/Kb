config = 
  name: "myboard",
  el: 'board',
  columns: [ 'backlog', 'in-progress', 'done' ],
  swimlanes: ['projects', 'implementations']

Kb.init config
Kb.board.get('tickets').reset [
      {title: "Buy some bread", column: "backlog", swimlane: "projects", x: 60, y:60, avatar: "Skull 2.png" },
      {title: "Buy some milk", column: "in-progress", swimlane: "implementations", x:80, y: 60, avatar: "Hulk-01.png"}
    ]

