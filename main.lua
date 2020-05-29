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

return function (class, parent)

  local new = class.constructor or function (self) end
  
  local nclass = { super = parent }
  nclass.__index = nclass

  for k, v in pairs(parent or {}) do
    if k ~= "new" and k ~= "super" then
      nclass[k] = v
    end
  end

  for key, value in pairs(class) do
    -- nclass[OPS_TABLE[key] or key] = value
    if OPS_TABLE[key] then
      nclass[OPS_TABLE[key]] = value
    end
    nclass[key] = value
  end

  function nclass:new(...)
    local obj = { __class = nclass, super = parent }
    new(obj, ...)
    setmetatable(obj, nclass)
    return obj
  end

  return nclass
end