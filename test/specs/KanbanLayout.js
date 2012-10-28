describe("Tests for Kanban.Layout.Bundle", function(){
	describe("constructor", function() {
		it("should work", function() {
			var b = new Kanban.Layout.Bundle({swimlanes:[ 'foo', 'bar'], columns: ['backlog', 'wip', 'done']});
			b.should.be.an.instanceof(Kanban.Layout.Bundle);
			b.swimlanes['foo'].should.exist;
			b.swimlanes['bar'].should.exist;
			b.swimlanes['bar'].should.be.an.instanceof(Kanban.Swimlane);
			b.columns['wip'].should.exist;
			b.columns['wip'].should.be.an.instanceof(Kanban.Column);
		});
	});

	describe("size", function() {
		it("should return the size of the bundle", function() {
			cfg = { swimlane_height: 10, column_width: 10, swimlane_title_width: 10, column_title_height: 10, column_margin: 10, swimlane_margin: 10};
			var b = new Kanban.Layout.Bundle({swimlanes:[ 'foo', 'bar'], columns: ['backlog', 'wip', 'done']}, cfg);
			var width = 3 * cfg.column_width + cfg.swimlane_title_width + cfg.column_margin;
			var height = 2 * cfg.swimlane_height + cfg.column_title_height + cfg.swimlane_margin;
			var size = b.size();
			size[0].should.equal(width);
			size[1].should.equal(height);
		});
	});
});

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

	describe("compute_viewport_size", function(){

	});
});