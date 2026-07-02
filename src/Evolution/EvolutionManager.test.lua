return function()
    local Evo = require(script.Parent.EvolutionManager)
    local bug = {Type = "Ant", Level = 1, Resources = 5}
    Evo.Evolve(bug, "Beetle")
    expect(bug.Type).to.equal("Beetle")
    expect(bug.Level).to.equal(2)
end
