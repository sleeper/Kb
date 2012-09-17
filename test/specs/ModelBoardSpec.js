
describe("Tests for Model.Board", function() {
  it('Can be created with default values for its attributes.', function() { 
    var board = new Kb.Models.Board();
    board.get('swimlanes').should.have.length(0);
    board.get('columns').should.have.length(0);
  });

  it('Will set passed attributes on the model instance when created.', function() { 
    var board = new Kb.Models.Board({swimlanes:[ 'foo'], name: "board"});
    board.get('name').should.equal('board');
    board.get('swimlanes').should.have.length(1);
    board.get('swimlanes').should.include('foo');
  });

  it('Fires a custom event when the state changes.', function(done) {
    var board = new Kb.Models.Board({swimlanes:[ 'foo'], name: "board"});
    // how do we monitor changes of state?
    board.on('change', function() { done();});
    // what would you need to do to force a change of state?
    board.set('name', 'new name' );
  });

  it('Can contain custom validation rules, and will trigger an error event on failed validation.', function(done) {
    var board = new Kb.Models.Board({swimlanes:[ 'foo'], name: "name"});
    board.on('error', function(b,error) {
      error.should.equal('Name must not be nil or empty');
      done();
    });
    board.set({name:''});
  });

  it("url must be correctly set", function() {
    var board = new Kb.Models.Board({swimlanes:[ 'foo'], name: "name"});
    board.id = 42;
    board.url().should.equal('/boards/'+ board.id );

  });

});
