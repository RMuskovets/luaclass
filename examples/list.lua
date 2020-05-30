local class = require '../main'

function deepcopy(orig, copies)
  copies = copies or {}
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    if copies[orig] then
      copy = copies[orig]
    else
      copy = {}
      copies[orig] = copy
      for orig_key, orig_value in next, orig, nil do
        copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
      end
      setmetatable(copy, deepcopy(getmetatable(orig), copies))
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

local List

List = class {
  constructor = function (self, items)
    items = (items == nil) and {} or items
    if List:is(items) then
      self.__items = items:items()
    elseif type(items) == 'table' then
      self.__items = items
    else
      self.__items = { items }
    end
  end,

  plus = function (lhs, rhs)
    if lhs.__class:is(rhs) or List:is(rhs) then -- this is a List of elements
      return lhs + rhs:items()
    elseif type(rhs) == 'table' then -- this is a table ("array") of elements
      local newList = lhs.__class:new(deepcopy(lhs:items()))
      for _, v in pairs(rhs) do
        newList:add(v)
      end
      return newList
    else -- this is a single element
      local newList = lhs.__class:new(deepcopy(lhs:items()))
      newList:add(rhs)
      return newList
    end end,
  concat = function (lhs, rhs) return lhs + rhs end,

  times = function (self, times)
    local newList = List:new(deepcopy(self, items))
    for i = 1, times do
      newList = newList + self
    end
    return newList
  end,

  length = function (self) return #self:items() end,

  tostring = function (self)
    local s = '[' .. tostring(self:at(1))
    for i = 2, #self do
      local e = self:at(i)
      s = s .. ', ' .. tostring(e)
    end
    return s .. ']'
  end,

  pairs = function (self) return pairs(self:items()) end,
  ipairs = function (self) return ipairs(self:items()) end,

  items = function (self) return self.__items end,
  at = function (self, i) return self.__items[i] end,

  add = function (self, elem)
    table.insert(self.__items, elem)
  end,

  map = function (self, f)
    local newList = List:new()
    for i, e in pairs(self) do
      newList:add(f(e))
    end
    return newList
  end,

  filter = function (self, f)
    local newList = List:new()
    for i, e in pairs(self) do
      if f(e) then newList:add(e) end
    end
    return newList
  end,

  count_of = function (self, e)
    local count = 0
    for i, E in pairs(self) do
      if e == E then count = count + 1 end
    end
    return count
  end,

  remove_if = function (self, f)
    self.__items = self:filter(function (x) return not f(x) end).__items
  end,

  remove = function (self, i)
    table.remove(self.__items, i)
  end
}

local l = List:new{ 'hello', 'world' }

print(tostring(l))
print(tostring(l + List:new{ '!' }))
print(l:tostring())

for key, elem in pairs(l) do
  print(key, elem)
end

local l2 = List:new{ 1, 2, 3 }
print(l2)
print(l2 + List:new{ 4, 5, 6 })

for i = 4, 10 do
  l2:add(i)
end

print(l2)

print(l2:map(function (x) return x * 2 end))
print(l2:filter(function (x) return x % 2 == 0 end))

l2:remove_if(function (x) return x % 2 == 0 end)
print(l2)

print(l2[1])
print(l2[2])
print(l2.__items)

return List