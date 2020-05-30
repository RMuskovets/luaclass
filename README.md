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

# "Magic" methods

## Arithmetic

### `plus`
A method to get the sum of the two objects.

### `minus`
A method to subtract B from A.

### `times`
A method to multiply A by B.

### `divide`
A method to divide A by B.

### `power`
A method to get the "B"-th power of "A".

### `modulo`
A method to modulo this object by another one.

### `idivide`

## Comparison

### `equals`
A method to check the equality between two objects (`a == b`). `a ~= b` is generated from this one.

### `lessthan`
A method to check that `a < b`. `a > b` is generated from this one.

### `lesseqthan`
A method to check that `a <= b`. `a >= b` is generated from this one.

## Bitwise "magic"

### `binand`
A method to do a binary AND operation between two objects (`binand(a, b)`).

### `binor`
A method to do a binary OR operation between two objects (`binor(a, b)`).

### `binxor`
A method to do a XOR operation between two objects (`binxor(a, b)`).

### `binnot`
A method to negate (`~`) this object.

### `shiftl`
A method to bitwise shift this object left by N bits.

### `shiftr`
A method to bitwise shift this object right by N bits.

## Iteration

### `pairs`
A method that returns a alternative implementation of the `pairs` iterator for this object.

### `ipairs`
A method that returns a alternative implementation of the `ipairs` iterator for this object.

## Other

### `tostring`
A method to convert this object to string. `tostring(x)` = `x:tostring()`.

### `concat`
A method for concatenating objects. `a .. b` = `concat(a, b)`.

### `length`
If some code gets the length of this object by using `#object`, this method is invoked.

### `call`
If this object is invoked as a function, the `call` method is invoked with the arguments given.