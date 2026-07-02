return function()
    local RaidMgr = require(script.Parent.RaidManager)
    local player = {UserId = 1, Resources = 0}
    RaidMgr.StartRaid(player, "PicnicBasket")
    expect(player.Resources).to.be.above(0)
    expect(RaidMgr.ActiveRaids["PicnicBasket"]).to.be.truthy()
end
