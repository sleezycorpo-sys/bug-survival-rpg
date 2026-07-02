local NestManager = {}
local UPGRADE_COST = 10
local Persistence = require(script.Parent.Parent.Persistence.Persistence)

function NestManager.Upgrade(player)
    if (player.Resources or 0) >= UPGRADE_COST then
        player.Resources = player.Resources - UPGRADE_COST
        player.NestLevel = (player.NestLevel or 1) + 1
        -- persist after upgrade
        Persistence.Save(player)
    end
end

function NestManager.GetGenerationRate(player)
    local level = player.NestLevel or 1
    return 1 + (level - 1) * 0.5
end

return NestManager