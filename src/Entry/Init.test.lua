return function()
    local Init = require(script.Parent.Init)
    local Persistence = require(script.Parent.Persistence)

    -- Mock datastore
    _G.MockDataStore = {}
    -- Prepare two players with persisted data
    Persistence.Save({UserId = 1, Resources = 10, NestLevel = 2, OwnedSkins = {}, Health = 80, Attack = 12})
    Persistence.Save({UserId = 2, Resources = 5, NestLevel = 1, OwnedSkins = {}, Health = 100, Attack = 5})

    local players = {{UserId = 1}, {UserId = 2}}
    local loaded = Init.Start(players)

    expect(loaded[1].Resources).to.equal(10)
    expect(loaded[1].NestLevel).to.equal(2)
    expect(loaded[1].Health).to.equal(80)
    expect(loaded[2].Resources).to.equal(5)
    expect(loaded[2].Health).to.equal(100)
end