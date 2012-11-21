describe("Tests for Kanban.Column", function() {
	it("should remember its name and type", function() {
		var cl = new Kanban.Column("fred", "default", 10 , 10);
		cl.name.should.equal("fred");
		cl.type.should.equal("default");
	});

	it("should be able to draw its title", function() {
		var cl = new Kanban.Column("fred", "default", 10, 10);
		var bel = $('#board');
		var paper = Raphael(bel[0], 200, 200);
		cl.draw_title(paper, 0, 0);
		$('svg path', bel).length.should.not.equal(0);
		$('svg', bel).remove();
	});

	it("should reject invalid type");

	describe("on_drop behaviours", function(){
		var create_ticket = function( set_fn ) {
			return { record: { set: set_fn } };
		};

		describe("'start' columns", function() {
			it("should record the date/time, as well as swimlane and column name", function(done) {
				var cl = new Kanban.Column("fred", "start", 10, 10);
				var t = create_ticket( function(attributes) {
						attributes.should.have.property('entered_on');
						attributes.should.have.property('swimlane', "swimlane");
						attributes.should.have.property('column', "fred");
						done();
				});
				cl.on_drop('fred', 'swimlane', t );
			});
		});

		describe("'end' columns", function() {
			it("should record the date/time, as well as swimlane and column name", function(done) {
				var cl = new Kanban.Column("fred", "end", 10, 10);
				var t = create_ticket( function(attributes) {
						attributes.should.have.property('finished_on');
						attributes.should.have.property('swimlane', "swimlane");
						attributes.should.have.property('column', "fred");
						done();
				});
				cl.on_drop('fred', 'swimlane', t );
			});
		});

		describe("'onhold' columns", function() {
			it("should not change the swimlane name", function(done) {
				var cl = new Kanban.Column("fred", "onhold", 10, 10);
				t = create_ticket(function(attributes) {
						attributes.should.not.have.property('swimlane');
						attributes.should.have.property('column', "fred");
						done();
					});
				cl.on_drop('fred', 'swimlane', t  );
			});
			it("should record the date it has been placed on hold", function(done) {
				var cl = new Kanban.Column("fred", "onhold", 10, 10);
				t = create_ticket(function(attributes) {
						attributes.should.have.property('onhold_on');
						done();
					});
				cl.on_drop('fred', 'swimlane', t  );
			});
			it("should request a 'wake up' date");
			it("should save the wake-up date");
		});

		describe("'default' columns", function() {
			it("should save the column and swimlane names", function(done) {
				var cl = new Kanban.Column("fred", "default", 10, 10);
				t = create_ticket(function(attributes) {
						attributes.should.have.property('swimlane', "swimlane");
						attributes.should.have.property('column', "fred");
						done();
					});
				cl.on_drop('fred', 'swimlane', t  );
			});
		});
	});
});
