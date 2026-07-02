return function()
    local TeamMgr = require(script.Parent.TeamManager)
    local player = {UserId = 123}
    TeamMgr.AssignTeam(player, "Bee")
    expect(TeamMgr.GetTeam(player.UserId)).to.equal("Bee")
end
