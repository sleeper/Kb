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
			cfg.should.be.an.instanceof(Kanban.Config);
		});

		describe("should reject", function() {
			it("non array layout", function(){
				var t = function() { new Kanban.Config( 1 );}
				t.should.throw( TypeError );
			});
			it("empty layout", function(){
				var t = function() { new Kanban.Config( [] );}
				t.should.throw( TypeError );
			});
			it("invalid bundle", function() {
				var t = function() { new Kanban.Config( [{foo: 'bar'}] );}
				t.should.throw( TypeError );
			});
			it("non-array swimlanes", function() {
				var t = function() { new Kanban.Config( [{swimlanes:1, columns:[]}] );}
				t.should.throw( TypeError );
			});
			it("non-array columns", function() {
				var t = function() { new Kanban.Config( [{columns: 1, swimlanes:[]}] );}
				t.should.throw( TypeError );
			});
			it("non-string cell", function() {
				var t = function() { new Kanban.Config( [{cell: 1}] );}
				t.should.throw( TypeError );
			});
		});

		it("should accept 'cell'", function() {
			var cfg = new Kanban.Config([{cell: 'fred'}]);
			cfg.bundles[0].should.have.property('swimlanes');
			cfg.bundles[0].should.have.property('columns');
		});

		it("should accept typed column");
		
	});
});