local TeamMgr = {}
local playerTeams = {}

function TeamMgr.AssignTeam(player, teamName)
    playerTeams[player.UserId] = teamName
end

function TeamMgr.GetTeam(userId)
    return playerTeams[userId]
end

return TeamMgr
