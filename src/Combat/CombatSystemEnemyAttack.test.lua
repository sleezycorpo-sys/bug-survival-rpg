return function()
    local Combat = require(script.Parent.CombatSystem)
    local RaidMgr = require(script.Parent.RaidManager)
    local player = {UserId = 1, Resources = 0, Attack = 10, Health = 30}
    RaidMgr.StartRaid(player, "PicnicBasket", 1)
    Combat.EnemyAttack(player, "PicnicBasket", 1)
    expect(player.Health).to.be.below(30)
end