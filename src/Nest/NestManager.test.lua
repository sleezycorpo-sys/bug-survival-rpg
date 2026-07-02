return function()
    local NestMgr = require(script.Parent.NestManager)
    local player = {Resources = 10}
    NestMgr.Upgrade(player)
    expect(player.NestLevel).to.equal(2)
    expect(player.Resources).to.equal(0)
end
