describe("Tests for Ticket", function() {
  it('Can be created with default values for its attributes.', function() { 
    var ticket = new Kb.Models.Ticket();
    ticket.get('title').should.equal("");
    ticket.get('column').should.equal("");
    ticket.get('swimlane').should.equal("");
    ticket.get('x').should.equal(0);
    ticket.get('y').should.equal(0);
  });

  it("Set invalid date to beginning of Universe", function() {
    var ticket = new Kb.Models.Ticket({created_on: "foo"});
    ticket.get('created_on').toString().should.equal("Thu Jan 01 1970 01:00:00 GMT+0100 (CET)")
  });

  it("Convert date string to date object for relevant attributes", function() {
    var ticket = new Kb.Models.Ticket({created_on: "2012-09-21 12:34:45", entered_on: "2012-09-22 12:45:56"});
    ticket.get('created_on').should.be.an.instanceof(Date);
    ticket.get('entered_on').should.be.an.instanceof(Date);
  });

  it("Should convert relevant attribute to Date when they change", function() {
    var ticket = new Kb.Models.Ticket({created_on: "2012-09-21 12:34:45", entered_on: "2012-09-22 12:45:56"});
    ticket.set('created_on', "2012-07-22 22:30:21")
    ticket.set('entered_on', "2012-07-22 22:30:21")
    ticket.get('created_on').should.be.an.instanceof(Date);
    ticket.get('entered_on').should.be.an.instanceof(Date);
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
