describe("Tests for Kanban.Bundle", function(){
	var gsizes = { swimlane_height: 10, column_width: 10, swimlane_title_width: 10, column_title_height: 10, column_margin: 10, swimlane_margin: 10};
	var cells = new Kanban.CellCache();

	describe("constructor", function() {

		it("should work", function() {
			var b = new Kanban.Bundle({name: 'fred', swimlanes:[ 'foo', 'bar'], columns: ['backlog', 'wip', 'done']}, gsizes, cells);
			b.should.be.an.instanceof(Kanban.Bundle);
			b.swimlanes['foo'].should.exist;
			b.swimlanes['bar'].should.exist;
			b.swimlanes['bar'].should.be.an.instanceof(Kanban.Swimlane);
			b.columns['wip'].should.exist;
			b.columns['wip'].should.be.an.instanceof(Kanban.Column);
			b.name.should.exist;
			b.name.should.equal('fred');
		});

		describe("it shoud reject ", function() {
			it("invalid bundle", function() {
				var t = function() { new Kanban.Bundle( {foo: 'bar'}, gsizes, cells );}
				t.should.throw( TypeError );
			});
			it("missing name", function() {
				var t = function() { new Kanban.Bundle( {swimlanes:[], columns:[]}, gsizes, cells );}
				t.should.throw( TypeError );
			});

			it("non-array swimlanes", function() {
				var t = function() { new Kanban.Bundle( {name: 'fred', swimlanes:1, columns:[]}, gsizes, cells );}
				t.should.throw( TypeError );
			});
			it("non-array columns", function() {
				var t = function() { new Kanban.Bundle( {name: "fred", columns: 1, swimlanes:[]}, gsizes, cells );}
				t.should.throw( TypeError );
			});
			it("non-string cell", function() {
				var t = function() { new Kanban.Bundle( {name: "fred", cell: 1}, gsizes, cells );}
				t.should.throw( TypeError );
			});
			it("missing sizes", function() {
				var t = function() { new Kanban.Bundle( {name: "fred", cell: 'onhold'} );}
				t.should.throw( TypeError );
			});
			it("missing cell cache", function() {
				var t = function() { new Kanban.Bundle( {name: "fred", cell: 'onhold'}, gsizes );}
				t.should.throw( TypeError );
			})
		});
	});

	describe("size", function() {
		it("should return the size of the bundle", function() {
			var b = new Kanban.Bundle({name: 'fred', swimlanes:[ 'foo', 'bar'], columns: ['backlog', 'wip', 'done']}, gsizes, cells);
			var width = 3 * gsizes.column_width + gsizes.swimlane_title_width + gsizes.column_margin;
			var height = 2 * gsizes.swimlane_height + gsizes.column_title_height + gsizes.swimlane_margin;
			var size = b.size();
			size[0].should.equal(width);
			size[1].should.equal(height);
		});
	});

	describe("draw()", function(){
		it("should draw itself at the right position", function() {
			var cfg = { swimlane_height: 10, column_width: 10, swimlane_title_width: 10, column_title_height: 10, column_margin: 10, swimlane_margin: 10};
			var cells = new Kanban.CellCache();
			var b = new Kanban.Bundle({name: 'fred', swimlanes:[ 'foo', 'bar'], columns: ['backlog', 'wip', 'done']}, cfg, cells);
			var bel = $('#board');
			var paper = Raphael(bel[0], 1000, 1000);
			b.draw( paper );
			// As we have 2 swimlanes and 3 columns we must found 11 rect object
			$('svg rect', bel).length.should.equal(11);
			$('svg', bel).remove();
		});
	});
});

