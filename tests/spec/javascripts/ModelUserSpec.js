describe("Tests for User", function() {
  it('Can be created with default values for its attributes.', function() { 
    var user = new Kb.Models.User();
    expect(user.get('name')).toBe("");
    expect(user.get('avatar')).toBe("Zombie.png");
  });

  it('will set passed attributes on the model instance when created.', function() { 
    var user = new Kb.Models.User({ name: 'fred' });
    expect(user.get('name')).toBe("fred");
  });

  it('Fires a custom event when the state changes.', function() {
    var spy = jasmine.createSpy('-change event callback-');
    var user = new Kb.Models.User();
    // how do we monitor changes of state?
    user.on('change', spy);
    // what would you need to do to force a change of state?
    user.set({ name: 'Fred' });
    expect(spy).toHaveBeenCalled();
  });

});
