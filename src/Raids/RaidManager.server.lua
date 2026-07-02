local RaidManager = {}
RaidManager.ActiveRaids = {}

function RaidManager.StartRaid(player, raidName)
    -- grant a fixed reward for prototype
    player.Resources = (player.Resources or 0) + 5
    RaidManager.ActiveRaids[raidName] = {Owner = player.UserId, Participants = {player}}
end

return RaidManager
