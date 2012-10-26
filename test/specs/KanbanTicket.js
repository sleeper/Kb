describe("Tests for Kanban tickets", function() {

		describe("init", function(){
		var el;
		var layout = {
			columns: [ 'backlog', 'in-progress', 'done' ],
    		swimlanes: [ 'projects', 'implementations']
		};

		it("should create a ticket", function(){
		    var board = new Kanban.Board(layout, el);
		    var t = new Kanban.Ticket( board, record );
		});
		
		it("should create the ticket as 'cleared'");
	});
});