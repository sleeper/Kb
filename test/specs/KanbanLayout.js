describe("Tests for Kanban.Swimlane", function() {
	it("should remember its name", function() {
		var sl = new Kanban.Swimlane("fred", 10 , 10);
		sl.name.should.equal("fred");
	});

	it("should be able to draw its title", function() {
		var sl = new Kanban.Swimlane("fred", 10, 10);
		var bel = $('#board');
		var paper = Raphael(bel[0], 200, 200);
		sl.draw_title(paper, 0, 0);
		$('svg path', bel).length.should.not.equal(0);
	});
});

describe("Tests for Kanban.Column", function() {
	it("should remember its name and type", function() {
		var cl = new Kanban.Column("fred", "default", 10 , 10);
		cl.name.should.equal("fred");
		cl.type.should.equal("default");
	});

	it("should be able to draw its title", function() {
		var cl = new Kanban.Column("fred", 10, 10);
		var bel = $('#board');
		var paper = Raphael(bel[0], 200, 200);
		cl.draw_title(paper, 0, 0);
		$('svg path', bel).length.should.not.equal(0);
		$('svg', bel).remove();
	});
});

describe("Tests for Kanban.Layout.Bundle", function(){
	var gsizes = { swimlane_height: 10, column_width: 10, swimlane_title_width: 10, column_title_height: 10, column_margin: 10, swimlane_margin: 10};
	var cells = new Kanban.CellCache();

	describe("constructor", function() {

		it("should work", function() {
			var b = new Kanban.Layout.Bundle({name: 'fred', swimlanes:[ 'foo', 'bar'], columns: ['backlog', 'wip', 'done']}, gsizes, cells);
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
				var t = function() { new Kanban.Layout.Bundle( {foo: 'bar'}, gsizes, cells );}
				t.should.throw( TypeError );
			});
			it("missing name", function() {
				var t = function() { new Kanban.Layout.Bundle( {swimlanes:[], columns:[]}, gsizes, cells );}
				t.should.throw( TypeError );
			});

			it("non-array swimlanes", function() {
				var t = function() { new Kanban.Layout.Bundle( {name: 'fred', swimlanes:1, columns:[]}, gsizes, cells );}
				t.should.throw( TypeError );
			});
			it("non-array columns", function() {
				var t = function() { new Kanban.Layout.Bundle( {name: "fred", columns: 1, swimlanes:[]}, gsizes, cells );}
				t.should.throw( TypeError );
			});
			it("non-string cell", function() {
				var t = function() { new Kanban.Layout.Bundle( {name: "fred", cell: 1}, gsizes, cells );}
				t.should.throw( TypeError );
			});
			it("missing sizes", function() {
				var t = function() { new Kanban.Layout.Bundle( {name: "fred", cell: 'onhold'} );}
				t.should.throw( TypeError );
			});
			it("missing cell cache", function() {
				var t = function() { new Kanban.Layout.Bundle( {name: "fred", cell: 'onhold'}, gsizes );}
				t.should.throw( TypeError );
			})
		});
	});

	describe("size", function() {
		it("should return the size of the bundle", function() {
			var b = new Kanban.Layout.Bundle({name: 'fred', swimlanes:[ 'foo', 'bar'], columns: ['backlog', 'wip', 'done']}, gsizes, cells);
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
			var b = new Kanban.Layout.Bundle({name: 'fred', swimlanes:[ 'foo', 'bar'], columns: ['backlog', 'wip', 'done']}, cfg, cells);
			var bel = $('#board');
			var paper = Raphael(bel[0], 1000, 1000);
			b.draw( paper );
			// As we have 2 swimlanes and 3 columns we must found 11 rect object
			$('svg rect', bel).length.should.equal(11);
			$('svg', bel).remove();
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

		it("should assign bundles positions", function(){
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
		var cfg = new Kanban.Layout(layout);
		cfg.bundles['board'].x.should.equal(0);
		cfg.bundles['board'].y.should.equal(0);
		cfg.bundles['trash'].x.should.equal(60);
		cfg.bundles['trash'].y.should.equal(0);
		cfg.bundles['bellow'].x.should.equal(0);
		cfg.bundles['bellow'].y.should.equal(40);

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

	describe("layout size", function(){
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
			var bsize = [60, 50]
			var size = cfg.size();
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
			var size = cfg.size();
			var bsize = [100,50];
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
			var size = cfg.size();
			var bsize = [60,90];
			size.should.eql( bsize );
		});
	});

});