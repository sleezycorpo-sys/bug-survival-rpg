return function()
    local RaidMgr = require(script.Parent.RaidManager)
    local Combat = require(script.Parent.CombatSystem)
    local player = {UserId = 1, Resources = 0, Attack = 20, Health = 100}
    RaidMgr.StartRaid(player, "PicnicBasket", 2)
    while #RaidMgr.ActiveRaids["PicnicBasket"].Enemies > 0 do
        Combat.PlayerAttack(player, "PicnicBasket", 1)
    end
    expect(#RaidMgr.ActiveRaids["PicnicBasket"].Enemies).to.equal(0)
    expect(player.Resources).to.be.above(0)
end