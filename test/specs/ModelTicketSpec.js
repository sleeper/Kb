describe("Tests for Ticket", function() {
  it('Can be created with default values for its attributes.', function() { 
    var ticket = new Kb.Models.Ticket();
    ticket.get('title').should.equal("");
    ticket.get('column').should.equal("");
    ticket.get('swimlane').should.equal("");
    ticket.get('x').should.equal(0);
    ticket.get('y').should.equal(0);
  });

  it('Will set passed attributes on the model instance when created.', function() { 
    var ticket = new Kb.Models.Ticket({ title: 'Get oil change for car.' });
    ticket.get('title').should.equal("Get oil change for car.");
    ticket.get('column').should.equal("");
    ticket.get('swimlane').should.equal("");
  });

  it('Fires a custom event when the state changes.', function(done) {
    var ticket = new Kb.Models.Ticket();
    // how do we monitor changes of state?
    ticket.on('change', function(){ done();});
    // what would you need to do to force a change of state?
    ticket.set({ title: 'Get oil change for car.' });
  });
});
