local ResourceGenerator = {}

local DEFAULT_RATE = 1

function ResourceGenerator.Tick(players, rate)
    rate = rate or DEFAULT_RATE
    for _, p in ipairs(players) do
        p.Resources = (p.Resources or 0) + rate
    end
end

return ResourceGenerator