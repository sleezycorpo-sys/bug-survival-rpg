return function()
    local Combat = require(script.Parent.CombatSystem)
    local RaidMgr = require(script.Parent.RaidManager)
    local player = {UserId = 1, Resources = 0, Attack = 15, Health = 100}
    RaidMgr.StartRaid(player, "PicnicBasket", 1)
    local beforeHealth = RaidMgr.ActiveRaids["PicnicBasket"].Enemies[1].Health
    Combat.PlayerAttack(player, "PicnicBasket", 1)
    local afterHealth = RaidMgr.ActiveRaids["PicnicBasket"].Enemies[1].Health
    expect(afterHealth).to.equal(beforeHealth - player.Attack)
end