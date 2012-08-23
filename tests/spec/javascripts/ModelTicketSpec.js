describe("Tests for Ticket", function() {
  it('Can be created with default values for its attributes.', function() { 
    var ticket = new Kb.Models.Ticket();
    expect(ticket.get('title')).toBe("");
    expect(ticket.get('column')).toBe("");
    expect(ticket.get('swimlane')).toBe("");
    expect(ticket.get('x')).toBe(0);
    expect(ticket.get('y')).toBe(0);
  });

  it('Will set passed attributes on the model instance when created.', function() { 
    var ticket = new Kb.Models.Ticket({ title: 'Get oil change for car.' });
    expect(ticket.get('title')).toBe("Get oil change for car.");
    expect(ticket.get('column')).toBe("");
    expect(ticket.get('swimlane')).toBe("");
  });

  it('Fires a custom event when the state changes.', function() {
    var spy = jasmine.createSpy('-change event callback-');
    var ticket = new Kb.Models.Ticket();
    // how do we monitor changes of state?
    ticket.on('change', spy);
    // what would you need to do to force a change of state?
    ticket.set({ title: 'Get oil change for car.' });
    expect(spy).toHaveBeenCalled();
  });
});
