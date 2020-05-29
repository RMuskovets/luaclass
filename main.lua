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
	tostring = "__tostring"
}

return function (class)

	local new = class.constructor or function (self) end
	
	local nclass = {}
	nclass.__index = nclass

	for key, value in pairs(class) do
		if key ~= 'constructor' then
			nclass[OPS_TABLE[key] or key] = value
		end
	end

	function nclass:new(...)
		local obj = {}
		new(obj, ...)
		setmetatable(obj, self)
		return obj
	end

	return nclass
end