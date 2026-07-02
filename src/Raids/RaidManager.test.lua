return function()
    _G.MockDataStore = {}
    local RaidMgr = require(script.Parent.RaidManager)
    local player = {UserId = 1, Resources = 0}
    RaidMgr.StartRaid(player, "PicnicBasket", 3)
    local raid = RaidMgr.ActiveRaids["PicnicBasket"]
    expect(#raid.Enemies).to.equal(3)
    expect(raid.Enemies[1].Type).to.be.a("string")
    expect(raid.Enemies[1].Health).to.be.a("number")
end