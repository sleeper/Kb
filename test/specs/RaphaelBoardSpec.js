describe("Raphael.Board", function() {
  describe("compute_sizes", function() {
    it("should compute size right", function() {
      var m = new Kb.Models.Board({columns: ['backlog', 'done'], swimlanes: ['foo']});
      var b = new Kb.Raphael.Board(m, 'board');
      var tmp = b.compute_sizes();
      var width = tmp[0];
      var height = tmp[1];
      height.should.equal(652);
      width.should.equal(852);
    });
  });

  describe("draw", function() {

    it("should create a Raphael paper", function() {
      var m = new Kb.Models.Board({columns: ['backlog', 'done'], swimlanes: ['foo']});
      var b = new Kb.Raphael.Board(m, 'board');
      b.draw();
      $('#board').children().should.not.have.length(0);
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
      xb.should.equal(60);
      xa.should.equal(460);
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
      xb.should.equal(10);
      xa.should.equal(10);
    });
  });

  describe("get the cell under the point", function() {
    it("should return the right droppable cell the furnished point is in", function() {
      var m = new Kb.Models.Board({columns: ['backlog', 'done'], swimlanes: ['foo']});
      var b = new Kb.Raphael.Board(m, 'board');
      b.draw();
      var c = b.getCellByPoint(100,100);
      c.col_name.should.equal('backlog');
      c.sl_name.should.equal('foo');

    });

    it("get the column and swimlane name under the point", function(){
      var m = new Kb.Models.Board({columns: ['backlog', 'done'], swimlanes: ['foo']});
      var b = new Kb.Raphael.Board(m, 'board');
      b.draw();
      var c = b.getColumnAndSwimlane(100,100);
      c[0].should.equal('backlog');
      c[1].should.equal('foo');
    });
  });

});
