local EvolutionManager = {}

local EVOLUTION_COST = 5

function EvolutionManager.Evolve(bug, newType)
    if (bug.Resources or 0) >= EVOLUTION_COST then
        bug.Resources = bug.Resources - EVOLUTION_COST
        bug.Type = newType
        bug.Level = (bug.Level or 1) + 1
    end
end

return EvolutionManager