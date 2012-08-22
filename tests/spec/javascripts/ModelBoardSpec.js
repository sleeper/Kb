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
    var board = new Kb.Models.Board({swimlanes:[ 'foo'], name: "board"});
    // how do we monitor changes of state?
    board.on('change', spy);
    // what would you need to do to force a change of state?
    board.set('name', 'new name' );
    expect(spy).toHaveBeenCalled();
  });

  it('Can contain custom validation rules, and will trigger an error event on failed validation.', function() {
    var errorCallback = jasmine.createSpy('-error event callback-');
    var board = new Kb.Models.Board({swimlanes:[ 'foo'], name: "name"});
    board.on('error', errorCallback);
    board.set({name:''});
    var errorArgs = errorCallback.mostRecentCall.args;
    expect(errorArgs).toBeDefined();
    expect(errorArgs[0]).toBe(board);
    expect(errorArgs[1]).toBe('Name must not be nil or empty');
  });

  it("url must be correctly set", function() {
    var board = new Kb.Models.Board({swimlanes:[ 'foo'], name: "name"});
    board.id = 42;
    expect(board.url()).toBe('/boards/'+board.id);

  });

});
