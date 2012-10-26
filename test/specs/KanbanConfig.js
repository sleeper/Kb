describe("Tests for Kanban config", function() {

	describe("constructor", function(){

		it("should work for simple config", function(){
			var layout = [
			{ 
				columns: ['backlog', 'wip', 'done'],
				swimlanes: ['projects', 'ptrs']
			}
			];
			var cfg = new Kanban.Config(layout);
			assert( cfg instanceof Kanban.Config);
		});
		
	});
});