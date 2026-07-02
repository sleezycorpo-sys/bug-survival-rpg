return function()
    local Persistence = require(script.Parent.Persistence)
    local Init = require(script.Parent.Init)
    local RaidMgr = require(script.Parent.RaidManager)
    local NestMgr = require(script.Parent.NestManager)
    local Combat = require(script.Parent.CombatSystem)
    local ResourceGenerator = require(script.Parent.Economy.ResourceGenerator)

    _G.MockDataStore = {}

    -- Initial player persisted with defaults
    local player = {UserId = 1}
    local loaded = Init.Start({player})
    local p = loaded[1]
    expect(p.Resources).to.equal(0)
    expect(p.NestLevel).to.equal(1)
    expect(p.Health).to.equal(100)

    -- First tick at base rate (1)
    ResourceGenerator.Tick({p}, NestMgr.GetGenerationRate(p))
    expect(p.Resources).to.equal(1)
    Persistence.Save(p)

    -- Give resources for upgrade and upgrade nest
    p.Resources = p.Resources + 10
    NestMgr.Upgrade(p)
    Persistence.Save(p)
    expect(p.NestLevel).to.equal(2)

    -- Second tick at increased rate (1.5)
    ResourceGenerator.Tick({p}, NestMgr.GetGenerationRate(p))
    expect(p.Resources).to.be.above(1 + 1.5)
    Persistence.Save(p)

    -- Start a raid and earn base reward
    RaidMgr.StartRaid(p, "PicnicBasket", 1)
    Persistence.Save(p)
    expect(p.Resources).to.be.above(0)

    -- Combat: kill enemy for extra reward
    Combat.PlayerAttack(p, "PicnicBasket", 1)
    Persistence.Save(p)
    expect(p.Resources).to.be.above(0)

    -- Load again from datastore and verify final state persists
    local final = Persistence.Load(p.UserId)
    expect(final.Resources).to.be.above(0)
    expect(final.NestLevel).to.equal(2)
    expect(final.Health).to.equal(100)
end