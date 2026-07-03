local Init = {}
local Persistence = require(script.Parent.Parent.Persistence.Persistence)

function Init.Start(players)
    local loaded = {}
    for _, p in ipairs(players or {}) do
        table.insert(loaded, Persistence.Load(p.UserId))
    end
    return loaded
end

return Init