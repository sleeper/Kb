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