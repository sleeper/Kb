describe("Raphael.Board", function() {
  describe("compute_sizes", function() {
    it("should compute size right", function() {
      var m = new Kb.Models.Board({columns: ['backlog', 'done'], swimlanes: ['foo']});
      var b = new Kb.Raphael.Board(m, 'board');
      var tmp = b.compute_sizes();
      var width = tmp[0];
      var height = tmp[1];
      expect(width).toEqual(852);
      expect(height).toEqual(652);
    });
  });

  describe("draw", function() {

    it("should create a Raphael paper", function() {
      spyOn(window, 'Raphael').andCallThrough();
      var m = new Kb.Models.Board({columns: ['backlog', 'done'], swimlanes: ['foo']});
      var b = new Kb.Raphael.Board(m, 'board');
      b.draw();
      expect(window.Raphael).toHaveBeenCalled();
    });
  });

  describe("absolute coordinates computation", function() {
    it("should return the absolute x and y coordinates from relative ones", function(){
      var m = new Kb.Models.Board({columns: ['backlog', 'done'], swimlanes: ['foo']});
      var b = new Kb.Raphael.Board(m, 'board');
      b.draw();
      var xa,ya,_tmp;
      _tmp = b.compute_absolute_coordinates('done', 'foo', 10, 10);
      xa = _tmp[0];
      xb = _tmp[1];
      expect(xa).toBe(460);
      expect(xb).toBe(60);
    });
  });

  describe("relative coordinates computation", function() {
    it("should return the x and y coordinates relative to furnish cell", function(){
      var m = new Kb.Models.Board({columns: ['backlog', 'done'], swimlanes: ['foo']});
      var b = new Kb.Raphael.Board(m, 'board');
      b.draw();
      var xa,ya,_tmp;
      _tmp = b.compute_relative_coordinates('done', 'foo', 460, 60);
      xa = _tmp[0];
      xb = _tmp[1];
      expect(xa).toBe(10);
      expect(xb).toBe(10);
    });
  });

  describe("get the cell under the point", function() {
    it("should return the right droppable cell the furnished point is in", function() {
      var m = new Kb.Models.Board({columns: ['backlog', 'done'], swimlanes: ['foo']});
      var b = new Kb.Raphael.Board(m, 'board');
      b.draw();
      var c = b.getCellByPoint(100,100);
      expect(c.col_name).toBe('backlog');
      expect(c.sl_name).toBe('foo');

    });

    it("get the column and swimlane name under the point", function(){
      var m = new Kb.Models.Board({columns: ['backlog', 'done'], swimlanes: ['foo']});
      var b = new Kb.Raphael.Board(m, 'board');
      b.draw();
      var c = b.getColumnAndSwimlane(100,100);
      expect(c[0]).toBe('backlog');
      expect(c[1]).toBe('foo');
    });
  });

});
