describe("Tests for User", function() {
  it('Can be created with default values for its attributes.', function() { 
    var user = new Kb.Models.User();
    user.get('name').should.equal("");
    user.get('avatar').should.equal("Zombie.png");
  });

  it('will set passed attributes on the model instance when created.', function() { 
    var user = new Kb.Models.User({ name: 'fred' });
    user.get('name').should.equal("fred");
  });

  it('Fires a custom event when the state changes.', function(done) {
    var user = new Kb.Models.User();
    // how do we monitor changes of state?
    user.on('change', function() { done();});
    // what would you need to do to force a change of state?
    user.set({ name: 'Fred' });
  });

});
