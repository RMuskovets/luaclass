# luaclass
After thinking about OOP and Lua and trying to mod Factorio, I decided to make a library for easier OOP programming.
It shares the most principles with [this repository, which is also named luaclass](https://github.com/benglard/luaclass), but I kind of think that my one is better :)

# Examples
You may notice that this repository has a `examples/` folder with two files: `str.lua` and `list.lua`.
The first one has a wrapper class `Str` for Lua strings that has several features like multiplying by using `*`.
The second example is more complicated - it has a `List` class with many features:
* concatenation by using four methods (`a .. b`, `a + b`, `a:plus(b)`, `List.concat(a, b)`),
* multiplication,
* working `pairs` and `ipairs`,
* `at` function for getting an element by index - `__index` would interfere with the internal implementation,
* `tostring` function creating a string like `"[hello, world, !]"`.

# Usage
Okay, examples are good, but not everyone likes to only read code...
So here's some "documentation" for the library, and...
**MAGIC METHODS HAVE SYNONYMS! USE THE SYNONYMS!**

## class(class, parent?) -> table
This function creates a "class" using the data in `class` argument and (optionally) extends it from another class.
Example:
```lua
local foo
foo = class {
	constructor = function (self) print('foo::constructor()') end
}
foo:new() -- prints "foo::constructor()"
local bar
bar = class({
	constructor = function (self) print('bar::constructor()') end
}, foo)
bar:new() -- prints "bar::constructor()" but doesn't call superclass constructor!

local baz
baz = class({
	constructor = function (self)
		self.super.constructor(self) -- <== this calls the superclass constructor!
		print('baz::constructor()')
	end
}, foo)
baz:new() -- prints both "foo::constructor()" and "baz::constructor()"
```
## class:new(...) -> table
This function creates an instance of the class.
Example:
```lua
foo = class {
	constructor = function (self)
		print('created a foo object')
	end
}

local fooobj = foo:new()
```
## class:is(smth) -> boolean
This function checks is this value an instance of this class. Doesn't check for subclasses!
Example:
```lua
foo = class {}
bar = class ({}, foo)
baz = class ({}, bar)
print(bar:is(foo:new())) -- prints "false" because a `foo` object isn't a `bar` object
print(foo:is(bar:new())) -- prints "false" because as I said, it doesn't check for subclasses
print(baz:is(baz:new())) -- prints "true" because a `baz` object is a `baz` object
```
## object:constructor(...)
Just calls the constructor.

## object.\_\_class
This field is the class of this object.
