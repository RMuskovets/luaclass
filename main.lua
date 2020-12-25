local magic = {
    init = '__init'
}

local function deepcopy(orig, copies)
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

---@class Class
---@field private __mt table
---@field private __template table
---@field public new fun(...):Object

---@class Object
---@field private __class Class
---@field private super table
---@field private __init fun(self:Object,...)

local _M = {}

function _M.static(smth)
    return { __static = true, obj = smth }
end

---@param cls table
---@param parent Class|nil
---@return Class
function _M.class(cls, parent)
    local class = { __mt = { __index = function (self, idx)
        -- return rawget(self, magic[idx])
        --     or (self.super and rawget(self.super, magic[idx]))
        --     or rawget(self, idx)
        if magic[idx] ~= nil then
            return rawget(getmetatable(self), magic[idx])
                or rawget(self.super, magic[idx])
        else
            return rawget(self, idx)
                or (self.super and rawget(self.super, idx) or nil)
        end
    end }, __template = {} } ---@type Class
    local class_mt = {}

    if parent ~= nil then
        class.__mt = parent.__mt
        class_mt.super = parent

        class.__template.super = parent.__template -- superclass methods/fields
        setmetatable(class.__template.super, parent.__mt)
    end

    class.__mt.__class = class

    for k, v in pairs(cls) do
        if type(v) == "table" and v.__static then -- static field or function
            if type(v.obj) == "function" then -- invoke with `res` as first param
                class[k] = function (...) return v.obj(class, ...) end
            else
                class[k] = v
            end
        else
            if magic[k] ~= nil then
                class.__mt[magic[k]] = v
            end
            class.__template[magic[k] or k] = v
        end
    end

    function class:new(...)
        local obj = setmetatable(deepcopy(class.__template), class.__mt) ---@type Object

        if cls.init ~= nil then
            cls.init(obj, ...)
        end

        return obj
    end
    class_mt.__call = function (...) return class:new(...) end

    return setmetatable(class, class_mt)
end

function _M.extend(parent) return function (cls) -- call like this: extend(parent) { ... }
    return _M.class(cls, parent)
end end

return setmetatable(_M, {
    __call = function (_, cls) return _M.class(cls) end
})
