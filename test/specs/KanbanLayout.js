describe("Tests for Kanban.Layout.Bundle", function(){
	describe("constructor", function() {
		it("should work", function() {
			var b = new Kanban.Layout.Bundle({name: 'fred', swimlanes:[ 'foo', 'bar'], columns: ['backlog', 'wip', 'done']});
			b.should.be.an.instanceof(Kanban.Layout.Bundle);
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
				var t = function() { new Kanban.Layout.Bundle( {foo: 'bar'} );}
				t.should.throw( TypeError );
			});
			it("missing name", function() {
				var t = function() { new Kanban.Layout.Bundle( {swimlanes:[], columns:[]} );}
				t.should.throw( TypeError );
			});

			it("non-array swimlanes", function() {
				var t = function() { new Kanban.Layout.Bundle( {name: 'fred', swimlanes:1, columns:[]} );}
				t.should.throw( TypeError );
			});
			it("non-array columns", function() {
				var t = function() { new Kanban.Layout.Bundle( {name: "fred", columns: 1, swimlanes:[]} );}
				t.should.throw( TypeError );
			});
			it("non-string cell", function() {
				var t = function() { new Kanban.Layout.Bundle( {name: "fred", cell: 1} );}
				t.should.throw( TypeError );
			});
		});
	});

	describe("size", function() {
		it("should return the size of the bundle", function() {
			var cfg = { swimlane_height: 10, column_width: 10, swimlane_title_width: 10, column_title_height: 10, column_margin: 10, swimlane_margin: 10};
			var b = new Kanban.Layout.Bundle({name: 'fred', swimlanes:[ 'foo', 'bar'], columns: ['backlog', 'wip', 'done']}, cfg);
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
			var layout = {
				layout: [ 
				{ 
					name: 'board',
					columns: ['backlog', 'wip', 'done'],
					swimlanes: ['projects', 'ptrs']
				}
				],
				positions: ['board']
		};
			var cfg = new Kanban.Layout(layout);
			cfg.should.be.an.instanceof(Kanban.Layout);
		});

		describe("should reject", function() {

			it("object with missing keys", function() {
				var t = function() { new Kanban.Layout( {layout: ['foo']} );}
				t.should.throw( TypeError );
			});

			it("non-array layout", function(){
				var t = function() { new Kanban.Layout( {layout:{}, positions:[]} );}
				t.should.throw( TypeError );
			});

			it("non-array positions", function(){
				var t = function() { new Kanban.Layout( {layout:[], positions:{}} );}
				t.should.throw( TypeError );
			});

			it("empty layout", function(){
				var t = function() { new Kanban.Layout( {layout:[], positions: []} );}
				t.should.throw( TypeError );
			});

			it("empty positions", function() {
				var t = function() { new Kanban.Layout( {layout: [{name: 'fred', cell: 'prj'}]} );}
				t.should.throw( TypeError );
			});

			it("positions with invalid format", function() {
				var t = function() { new Kanban.Layout( {layout: [{name: 'fred', cell: 'prj'}], positions: 'foo'} );}
				t.should.throw( TypeError );
			});

			it("positions with invalid content", function() {
				var t = function() { new Kanban.Layout( {layout: [{name: 'fred', cell: 'prj'}], positions: ['foo']} );}
				t.should.throw( TypeError );
			});

		});

		it("should accept 'cell'", function() {
			var layout = {
				layout: [ 
				{ 
					name: 'board',
					cell: 'projects'
				}
				],
				positions: ['board']
		};

			var cfg = new Kanban.Layout(layout);
			cfg.bundles[0].should.have.property('swimlanes');
			cfg.bundles[0].should.have.property('columns');
		});

		it("should accept typed column");
		
	});

	describe("compute_viewport_size", function(){
		var sizes = { swimlane_height: 10, 
					  column_width: 10, 
					  swimlane_title_width: 10, 
					  column_title_height: 10, 
					  column_margin: 10, 
					  swimlane_margin: 10,
					  bundle_margin: 10
					};

		it("should work when there's only 1 bundle", function(){
			var layout = {
				layout: [ 
				{ 
					name: 'board',
					columns: ['backlog', 'wip', 'done'],
					swimlanes: ['projects', 'ptrs']
				}
				],
				positions: ['board']
			};
			
			var cfg = new Kanban.Layout(layout);
			var bsize = cfg.bundles[0].size();
			var size = cfg.compute_viewport_size();
			size.should.eql( bsize );
		});

		it("should work for several bundle on a line", function() {
			var layout = {
				layout: [ 
				{ 
					name: 'board',
					columns: ['backlog', 'wip', 'done'],
					swimlanes: ['projects', 'ptrs']
				},
				{ name: 'onhold', cell: 'On Old'}
				],
				positions: ['board', 'onhold']
			};
			
			var cfg = new Kanban.Layout(layout);
			var size = cfg.compute_viewport_size();
			// var bsize = (bundle.size() for bundle in cfg.bundles).reduce (x,y)-> x + sizes.bundle_margin;
			var bsize = [0,0];
			cfg.bundles.forEach(function(b) {
				var s =  b.size();
				bsize[0] += s[0] + sizes.bundle_margin;
				bsize[1] += s[1];
			});
			bsize[0] -= sizes.bundle_margin;

			size.should.eql( bsize );
		});

		it("should work for several bundle on lines and columns");
	});
});