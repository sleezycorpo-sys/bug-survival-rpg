local CombatSystem = {}
local RaidMgr = require(script.Parent.RaidManager)

function CombatSystem.PlayerAttack(player, raidName, enemyIdx)
    local raid = RaidMgr.ActiveRaids[raidName]
    if not raid then return end
    local enemy = raid.Enemies[enemyIdx]
    if not enemy then return end
    enemy.Health = enemy.Health - (player.Attack or 0)
    if enemy.Health <= 0 then
        player.Resources = (player.Resources or 0) + 2
        table.remove(raid.Enemies, enemyIdx)
    end
end

function CombatSystem.EnemyAttack(player, raidName, enemyIdx)
    local raid = RaidMgr.ActiveRaids[raidName]
    if not raid then return end
    local enemy = raid.Enemies[enemyIdx]
    if not enemy then return end
    player.Health = (player.Health or 0) - (enemy.Attack or 0)
    if player.Health <= 0 then
        player.Health = 0
        -- future: flag defeat
    end
end

return CombatSystem