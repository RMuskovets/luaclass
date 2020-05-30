local OPS_TABLE = {
  plus = "__add",
  minus = "__sub",
  times = "__mul",
  divide = "__div",
  power = "__pow",
  modulo = "__mod",
  idivide = "__idiv",
  equals = "__eq",
  lessthan = "__lt",
  lesseqthan = "__le",

  binand = "__band",
  binor = "__bor",
  binxor = "__bxor",
  binnot = "__bnot",
  shiftl = "__bshl",
  shiftr = "__bshr",

  length = "__len",
  concat = "__concat",

  call = "__call",
  tostring = "__tostring",

  pairs = "__pairs",
  ipairs = "__ipairs"
}

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

return function (class, parent)

  local new = class.constructor or function (self) end
  local parent = deepcopy(parent or {})
  
  local nclass = {}
  nclass.__index = nclass

  for k, v in pairs(parent or {}) do
    if k ~= "new" and k ~= "super" and k ~= "__class" then
      -- nclass[k] = (class[k] == nil) and v or class[k]
      if class[k] ~= nil then
        nclass[k] = class[k]
        if k ~= "constructor" then
          parent[k] = class[k]
        end
      else
        nclass[k] = v
      end
    end
  end

  for key, value in pairs(class) do
    if OPS_TABLE[key] then
      nclass[OPS_TABLE[key]] = value
    end
    nclass[key] = value
  end

  function nclass:new(...)
    local obj = { __class = nclass, super = parent }
    setmetatable(obj, nclass)
    new(obj, ...)
    return obj
  end

  function nclass:is(smth)
    if type(smth) ~= 'table' then
      return false
    elseif smth.__class ~= self then
      return false
    else
      return true
    end
  end

  return nclass
end