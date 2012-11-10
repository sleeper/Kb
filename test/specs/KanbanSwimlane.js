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
		$('svg', bel).remove();
	});
});

