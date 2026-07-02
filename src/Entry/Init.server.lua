local Init = {}
local Persistence = require(script.Parent.Persistence)

-- Start the game loop (placeholder) and load player data if a list is provided.
function Init.Start(players)
    -- Load each player's persisted state
    local loaded = {}
    for _, p in ipairs(players or {}) do
        table.insert(loaded, Persistence.Load(p.UserId))
    end
    return loaded
end

return Init