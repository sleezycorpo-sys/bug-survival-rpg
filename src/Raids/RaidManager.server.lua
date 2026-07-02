local RaidManager = {}
RaidManager.ActiveRaids = {}
local EnemyData = require(script.Parent.EnemyData)
local Persistence = require(script.Parent.Parent.Persistence.Persistence)

function RaidManager.StartRaid(player, raidName, enemyCount)
    -- base reward
    player.Resources = (player.Resources or 0) + 5
    -- persist after reward
    Persistence.Save(player)
    local enemies = {}
    for i = 1, enemyCount do
        table.insert(enemies, EnemyData.New("Spider"))
    end
    RaidManager.ActiveRaids[raidName] = {Owner = player.UserId, Participants = {player}, Enemies = enemies}
end

return RaidManager