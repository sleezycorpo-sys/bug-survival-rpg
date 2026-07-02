return function()
    local Persistence = require(script.Parent.Persistence)

    -- Set up a mock datastore for the test
    _G.MockDataStore = {}
    local userId = 123
    local default = Persistence.Load(userId)
    expect(default.Resources).to.equal(0)
    expect(default.NestLevel).to.equal(1)
    expect(default.Health).to.equal(100)

    local player = {UserId = userId, Resources = 42, NestLevel = 2, OwnedSkins = {RedWing = true}, Health = 90, Attack = 15}
    Persistence.Save(player)

    local loaded = Persistence.Load(userId)
    expect(loaded.Resources).to.equal(42)
    expect(loaded.NestLevel).to.equal(2)
    expect(loaded.OwnedSkins.RedWing).to.be.truthy()
    expect(loaded.Health).to.equal(90)
    expect(loaded.Attack).to.equal(15)
end