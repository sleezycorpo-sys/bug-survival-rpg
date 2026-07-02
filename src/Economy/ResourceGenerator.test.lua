return function()
    local RG = require(script.Parent.ResourceGenerator)
    local players = {
        {UserId = 1, Resources = 0},
        {UserId = 2, Resources = 5},
    }
    RG.Tick(players)  -- default generationRate = 1
    expect(players[1].Resources).to.equal(1)
    expect(players[2].Resources).to.equal(6)
end