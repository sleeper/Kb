describe("Tests for Model.Board", function() {
  it('Can be created with default values for its attributes.', function() { 
    var board = new Kb.Models.Board();
    expect(board.get('swimlanes').length).toBe(0);
    expect(board.get('columns').length).toBe(0);
  });

  it('Will set passed attributes on the model instance when created.', function() { 
    var board = new Kb.Models.Board({swimlanes:[ 'foo'], name: "board"});
    expect(board.get('name')).toBe("board");
    expect(board.get('swimlanes').length).toBe(1);
    expect(board.get('swimlanes')).toContain('foo');
  });

  it('Fires a custom event when the state changes.', function() {
    var spy = jasmine.createSpy('-change event callback-');
    var board = new Kb.Models.Ticket();
    // how do we monitor changes of state?
    board.on('change', spy);
    // what would you need to do to force a change of state?
    board.set({ name: 'new name' });
    expect(spy).toHaveBeenCalled();
  });
  
});
