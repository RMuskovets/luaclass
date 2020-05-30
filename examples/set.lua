local class = require './main'
local List = require './examples/list'

local Set = {
  constructor = function (self, items)
    self.super.constructor(self, items)
    self:remove_if(function (x) return self:count_of(x) > 1 end)
  end,

  add = function (self, elem)
    if self:count_of(elem) == 0 then
      table.insert(self.__items, elem)
    end
  end
}

Set = class(Set, List)

local s = Set:new({ 'hello', 'world' })
print(s)
print(s + Set:new({ 'hello' }))
print(s + Set:new({ 'World' }))