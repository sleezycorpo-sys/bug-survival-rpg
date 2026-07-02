local Bug = {}
Bug.__index = Bug

function Bug.New(typeName)
    local self = setmetatable({}, Bug)
    self.Type = typeName
    self.Health = 100
    return self
end

return Bug
