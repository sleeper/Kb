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
