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
		it("should check that a given swimlane belongs to only one bundle");
		it("should work for simple layout", function(){
			var layout = {
				bundles: [ 
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

			describe("positions can be:", function() {
				it("an array with only bundle names -- one line of bundles", function() {
					var layout = {
						bundles: [ 
						{ 
							name: 'board',
							columns: ['backlog', 'wip', 'done'],
							swimlanes: ['projects', 'ptrs']
						}
						],
						positions: ['board']
					};
					var l = new Kanban.Layout( layout );
					l.should.be.an.instanceof( Kanban.Layout);
				});

				it("an array with a collection of arrays -- bundle on several lines", function() {
					var layout = {
						bundles: [ 
						{ 
							name: 'board',
							columns: ['backlog', 'wip', 'done'],
							swimlanes: ['projects', 'ptrs']
						}, {
							name: 'onhold',
							cell: 'On Hold'
						}
						],
						positions: [['board'],['onhold']]
					};
					var l = new Kanban.Layout( layout );
					l.should.be.an.instanceof( Kanban.Layout);					
				});
			});

		});

		it("should accept 'cell'", function() {
			var layout = {
				bundles: [ 
				{ 
					name: 'board',
					cell: 'projects'
				}
				],
				positions: ['board']
		};

			var cfg = new Kanban.Layout(layout);
			cfg.bundles['board'].should.have.property('swimlanes');
			cfg.bundles['board'].should.have.property('columns');
		});

		describe("Typed columns", function() {
			before(function(){
				this.layout = {
					bundles: [ 
					{ 
						name: 'board',
						columns: ['backlog:start', 'in progress', 'done:end'],
						swimlanes: ['projects']
					},
					{
						name: 'aside',
						cell: 'On Hold:onhold'
					}
					],
					positions: ['board', 'aside']
				};
			});

			it("should accept start column", function() {
				var cfg = new Kanban.Layout(this.layout);
				var col = cfg.bundles['board'].columns['backlog'];
				col.type.should.equal('start');
				col.on_drop.should.not.be.null;

			});

			it("should accept end column", function() {
				var cfg = new Kanban.Layout(this.layout);
				var col = cfg.bundles['board'].columns['done'];
				col.type.should.equal('end');
				col.on_drop.should.not.be.null;
			});

			it("should accept nohold column", function() {
				var cfg = new Kanban.Layout(this.layout);
				var col = cfg.bundles['aside'].columns['On Hold'];
				col.type.should.equal('onhold');
				col.on_drop.should.not.be.null;
			});

			it("should check that there's only one start command by bundle");
			it("should check that there's only one end command by bundle");

		});
		
	});

	describe("each", function(){
		it("should iterate over bundles, line by line", function() {
			var layout = {
				bundles: [ 
				{ 
					name: 'board',
					columns: ['backlog', 'in progress', 'done'],
					swimlanes: ['projects']
				},
				{
					name: 'trash',
					cell: 'Trash'
				},
				{
					name: 'bellow',
					cell: 'On Hold:onhold'
				}
				],
				positions: [['board', 'trash'], ['bellow']]
		};
		var acc = "";
		var cfg = new Kanban.Layout(layout);
		cfg.each_bundle(function(b) {
			acc += b.name + " ";
		})
		acc.should.equal("board trash bellow ");
		})
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
				bundles: [ 
				{ 
					name: 'board',
					columns: ['backlog', 'wip', 'done'],
					swimlanes: ['projects', 'ptrs']
				}
				],
				positions: ['board']
			};
			
			var cfg = new Kanban.Layout(layout);
			var bsize = cfg.bundles['board'].size();
			var size = cfg.compute_viewport_size();
			size.should.eql( bsize );
		});

		it("should work for several bundle on a line", function() {
			var layout = {
				bundles: [ 
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
			var bsize = [90,40];
			size.should.eql( bsize );
		});

		it("should work for several bundle on lines and columns", function() {
			var layout = {
				bundles: [ 
				{ 
					name: 'board',
					columns: ['backlog', 'wip', 'done'],
					swimlanes: ['projects', 'ptrs']
				},
				{ name: 'onhold', cell: 'On Old'}
				],
				positions: [['board'], ['onhold']]
			};
			var cfg = new Kanban.Layout(layout);
			var size = cfg.compute_viewport_size();
			var bsize = [50,80];
			size.should.eql( bsize );
		});
	});
});