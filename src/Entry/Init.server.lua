local Init = {}

function Init.Start()
    -- Require core managers to ensure they load
    require(script.Parent.Teams.TeamManager)
    require(script.Parent.Characters.BugCharacter)
    require(script.Parent.Gameplay.CrumbSpawner)
    -- Additional managers can be required here later
end

return Init