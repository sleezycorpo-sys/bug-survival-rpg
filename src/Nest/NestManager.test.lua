return function()
    _G.MockDataStore = {}
    local NestMgr = require(script.Parent.NestManager)
    local Persistence = require(script.Parent.Parent.Persistence.Persistence)
    local player = {Resources = 10, UserId = 1}
    NestMgr.Upgrade(player)
    expect(player.NestLevel).to.equal(2)
    expect(player.Resources).to.equal(0)
    -- Verify that the persisted data matches the upgraded player
    local loaded = Persistence.Load(player.UserId)
    expect(loaded.NestLevel).to.equal(2)
    expect(loaded.Resources).to.equal(0)
end