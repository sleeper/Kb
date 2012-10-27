describe("Tests for Kanban layout", function() {

	describe("constructor", function(){

		it("should work for simple layout", function(){
			var layout = [
			{ 
				columns: ['backlog', 'wip', 'done'],
				swimlanes: ['projects', 'ptrs']
			}
			];
			var cfg = new Kanban.Layout(layout);
			cfg.should.be.an.instanceof(Kanban.Layout);
		});

		describe("should reject", function() {
			it("non array layout", function(){
				var t = function() { new Kanban.Layout( 1 );}
				t.should.throw( TypeError );
			});
			it("empty layout", function(){
				var t = function() { new Kanban.Layout( [] );}
				t.should.throw( TypeError );
			});
			it("invalid bundle", function() {
				var t = function() { new Kanban.Layout( [{foo: 'bar'}] );}
				t.should.throw( TypeError );
			});
			it("non-array swimlanes", function() {
				var t = function() { new Kanban.Layout( [{swimlanes:1, columns:[]}] );}
				t.should.throw( TypeError );
			});
			it("non-array columns", function() {
				var t = function() { new Kanban.Layout( [{columns: 1, swimlanes:[]}] );}
				t.should.throw( TypeError );
			});
			it("non-string cell", function() {
				var t = function() { new Kanban.Layout( [{cell: 1}] );}
				t.should.throw( TypeError );
			});
		});

		it("should accept 'cell'", function() {
			var cfg = new Kanban.Layout([{cell: 'fred'}]);
			cfg.bundles[0].should.have.property('swimlanes');
			cfg.bundles[0].should.have.property('columns');
		});

		it("should accept typed column");
		
	});
});