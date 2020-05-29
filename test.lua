local class = require "./main"

local Str

Str = class {

	static = {},

	constructor = function (self, s) self.__str = s end,

	plus = function (lhs, rhs) return Str:new(tostring(lhs) .. tostring(rhs)) end,
	times = function (lhs, rhs) return Str:new(string.rep(tostring(lhs), tonumber(rhs))) end,
	concat = function (lhs, rhs) return lhs + rhs end,

	length = function (self) return #self.__str end,

	tostring = function (self) return self.__str end
}

local s = Str:new("hello, world")
print(s)
print(tostring(s))
print(s + Str:new("hi"))
print(s * 3)

local s2 = Str:new("hi") + "!\n" .. "hmm..."
print(s2)

print(#s)
print(#s2)
