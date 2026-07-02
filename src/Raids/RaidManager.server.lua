local RaidManager = {}
RaidManager.ActiveRaids = {}
local EnemyData = require(script.Parent.EnemyData)

function RaidManager.StartRaid(player, raidName, enemyCount)
    -- base reward
    player.Resources = (player.Resources or 0) + 5
    local enemies = {}
    for i = 1, enemyCount do
        table.insert(enemies, EnemyData.New("Spider"))
    end
    RaidManager.ActiveRaids[raidName] = {Owner = player.UserId, Participants = {player}, Enemies = enemies}
end

return RaidManager