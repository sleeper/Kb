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

  describe("forEach", function(){
    it("must iterate over all cells", function(){
      var c = new Kb.Raphael.CellCache()
      c.put({col_name: "foo", sl_name: "bar", value: "fred"})
      c.put({col_name: "bar", sl_name: "bar", value: "fred"})
      var s = "";
      c.forEach(function(k,c) { 
        s+= c.col_name;
      });
      expect(s).toBe("foobar");
    });

    it("must stop iterating when callback returns false", function(){
      var c = new Kb.Raphael.CellCache()
      c.put({col_name: "foo", sl_name: "bar", value: "fred"})
      c.put({col_name: "bar", sl_name: "bar", value: "fred"})
      var s = "";
      c.forEach(function(k,c) { 
        if (c.col_name == "bar") {
          return false;
        }
        s+= c.col_name;
      });
      expect(s).toBe("foo");

    });

  });
});
