describe("Raphael.Board", function() {
  describe("draw", function() {

    it("should create a Raphael paper", function() {
      spyOn(window, 'Raphael').andCallThrough();
      var b = new Kb.Raphael.Board();
      b.draw('board', {columns: ['backlog', 'done'], swimlanes: ['foo']});
      expect(window.Raphael).toHaveBeenCalled();
    });
  });
});
