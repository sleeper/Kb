describe("Raphael.Board", function() {
  describe("compute_sizes", function() {
    it("should compute size right", function() {
      var b = new Kb.Raphael.Board();
      var m = new Kb.Models.Board({columns: ['backlog', 'done'], swimlanes: ['foo']});
      b.model = m;
      var tmp = b.compute_sizes();
      var width = tmp[0];
      var height = tmp[1];
      expect(width).toEqual(852);
      expect(height).toEqual(452);
    });
  });
  describe("draw", function() {

    it("should create a Raphael paper", function() {
      spyOn(window, 'Raphael').andCallThrough();
      var b = new Kb.Raphael.Board();
      var m = new Kb.Models.Board({columns: ['backlog', 'done'], swimlanes: ['foo']});
      b.draw('board', m);
      expect(window.Raphael).toHaveBeenCalled();
    });
  });
});
