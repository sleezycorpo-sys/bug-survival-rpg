local CombatSystem = {}
local RaidMgr = require(script.Parent.RaidManager)

function CombatSystem.PlayerAttack(player, raidName, enemyIdx)
    local raid = RaidMgr.ActiveRaids[raidName]
    if not raid then return end
    local enemy = raid.Enemies[enemyIdx]
    if not enemy then return end
    enemy.Health = enemy.Health - (player.Attack or 0)
    if enemy.Health <= 0 then
        -- reward for kill
        player.Resources = (player.Resources or 0) + 2
        table.remove(raid.Enemies, enemyIdx)
    end
end

return CombatSystem