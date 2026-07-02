local NestManager = {}

local UPGRADE_COST = 10

function NestManager.Upgrade(player)
    if (player.Resources or 0) >= UPGRADE_COST then
        player.Resources = player.Resources - UPGRADE_COST
        player.NestLevel = (player.NestLevel or 1) + 1
    end
end

return NestManager
