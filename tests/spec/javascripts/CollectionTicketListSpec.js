describe('Tests for TicketList', function() {
  it('Can add Model instances as objects and arrays.', function() {
    var tickets = new Kb.Collections.TicketList();
    expect(tickets.length).toBe(0);
    tickets.add({ title: 'Clean the kitchen' });
    // how many todos have been added so far?
    expect(tickets.length).toBe(1);
    tickets.add([
              { title: 'Do the laundry', swimlane: "foo" },
              { title: 'Go to the gym'}
    ]);
    // how many are there in total now?
    expect(tickets.length).toBe(3);
  });

  it('Can have a url property to define the basic url structure for all contained models.', function() {
    var tickets = new Kb.Collections.TicketList();
    // what has been specified as the url base in our model?
    expect(tickets.url).toBe('/tickets/'); });
});
