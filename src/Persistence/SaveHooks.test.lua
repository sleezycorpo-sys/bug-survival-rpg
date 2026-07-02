return function()
    local Persistence = require(script.Parent.Persistence)
    local RaidMgr = require(script.Parent.RaidManager)
    local NestMgr = require(script.Parent.NestManager)
    local Combat = require(script.Parent.CombatSystem)

    _G.MockDataStore = {}
    local player = {UserId = 1, Resources = 0, NestLevel = 1, Health = 100, Attack = 15, OwnedSkins = {}}

    -- Start raid (adds 5 resources, persists)
    RaidMgr.StartRaid(player, "PicnicBasket", 1)
    expect(_G.MockDataStore[tostring(player.UserId)].Resources).to.be.above(0)

    -- Give resources for upgrade and perform upgrade
    player.Resources = player.Resources + 10
    NestMgr.Upgrade(player)
    expect(_G.MockDataStore[tostring(player.UserId)].NestLevel).to.equal(2)

    -- Combat: attack enemy, should grant kill reward and persist
    Combat.PlayerAttack(player, "PicnicBasket", 1)
    expect(_G.MockDataStore[tostring(player.UserId)].Resources).to.be.above(0)
end