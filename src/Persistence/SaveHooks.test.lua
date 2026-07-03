return function()
    -- Set up mock DataStore and ReplicatedStorage
    _G.MockDataStore = {}
    _G.MockReplicatedStorage = {Events = {}}
    local Persistence = require(script.Parent.Persistence)
    local RaidMgr = require(script.Parent.RaidManager)
    local NestMgr = require(script.Parent.NestManager)
    local Combat = require(script.Parent.CombatSystem)

    local player = {UserId = 1, Resources = 0, NestLevel = 1, Health = 100, Attack = 15, OwnedSkins = {}}

    -- Start raid (adds 5 resources, persists, fires network update)
    RaidMgr.StartRaid(player, "PicnicBasket", 1)
    expect(_G.MockDataStore[tostring(player.UserId)].Resources).to.be.above(0)
    expect(_G.MockReplicatedStorage.Events.PlayerUpdate.payload).to.equal(player)

    -- Give resources for upgrade and perform upgrade
    player.Resources = player.Resources + 10
    NestMgr.Upgrade(player)
    expect(_G.MockDataStore[tostring(player.UserId)].NestLevel).to.equal(2)
    expect(_G.MockReplicatedStorage.Events.PlayerUpdate.payload).to.equal(player)

    -- Combat: attack enemy, should grant kill reward, persist, fire network
    Combat.PlayerAttack(player, "PicnicBasket", 1)
    expect(_G.MockDataStore[tostring(player.UserId)].Resources).to.be.above(0)
    expect(_G.MockReplicatedStorage.Events.PlayerUpdate.payload).to.equal(player)
end