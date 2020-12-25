# luaclass 2.0

"Vanilla" Lua doesn't have any mechanisms to do OOP-style programming.  
With this library, I'm trying to add them using a couple of functions: `class` and `extend`.  
These are pretty straightforward and I tried to write readable code.  

## Examples

* Simple class:
```lua
local class = require 'class'
local Foo = class {
    init = function (self) print 'Foo.init' end
}
local obj = Foo() -- outputs Foo.init
```

* Class with a field:
```lua
local class = require 'class'
local Foo = class {
    bar = 0,
    init = function (self) self.bar = 1 end
}
local obj = Foo()
print(obj.bar) -- outputs 1
```

* Class with a method:
```lua
local class = require 'class'
local Foo = class {
    bar = function (self) print 'Foo.bar' end
}
Foo():bar() -- outputs Foo.bar
```

* `Foo extends Bar`:
```lua
local class = require 'class'
local Foo = class {
    init = function (self) print 'Foo.init' end
}
local Bar = class.extend(Foo) {
    init = function (self) print 'Bar.init' end
}
Bar() -- outputs Bar.init
```

* Superclass constructor invocation:
```lua
local class = require 'class'
local class = require 'class'
local Foo = class {
    init = function (self) print 'Foo.init' end
}
local Bar = class.extend(Foo) {
    init = function (self) self.super.init() print 'Bar.init' end
}
Bar() -- outputs Foo.init<newline>Bar.init
```

## Docs (WIP)

### Module `class`
* **class(cls, parent?)** creates a class based on `cls`, optionally with superclass `parent`

* **extend(parent)** is a two-step `class(cls, parent)`: **`extend(Foo) {}` is the same as `class({}, Foo)`**

* **static(smth)** marks a field as static: `{ static_field = static(nil) }`
