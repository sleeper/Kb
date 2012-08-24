describe("Raphael.CellCache", function() {
  describe("basic put/get", function() {
    it("must work", function() {
      var c = new Kb.Raphael.CellCache()
      c.put({col_name: "foo", sl_name: "bar", value: "fred"})
      var d = c.get("foo", "bar")
      expect(d.col_name).toBe("foo")
      expect(d.sl_name).toBe("bar")
      expect(d.value).toBe("fred")
    });
  });
});
