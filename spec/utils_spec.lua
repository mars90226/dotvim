package.path = package.path .. ";./lua/?.lua"
local utils = require("vimrc.utils")

describe("vimrc.utils", function()
  describe("table_concat", function()
    it("concatenates two arrays", function()
      local t1 = {1, 2}
      local t2 = {3, 4}
      local result = utils.table_concat(t1, t2)
      assert.same({1, 2, 3, 4}, result)
    end)
  end)

  describe("table_map", function()
    it("maps values and returns new table", function()
      local t = {1, 2, 3}
      local mapped = utils.table_map(t, function(v)
        return v * 2
      end)
      assert.same({1, 2, 3}, t)
      assert.same({2, 4, 6}, mapped)
    end)
  end)

  describe("meta_fn_key", function()
    it("generates meta function key combos", function()
      assert.same({"<M-F1>", "<F49>"}, utils.meta_fn_key(1))
      assert.same({"<M-F12>", "<F60>"}, utils.meta_fn_key(12))
    end)
  end)
end)
