return function()
    local Store = require(script.Parent.StoreManager)
    local player = {Currency = 100}
    Store.PurchaseSkin(player, "RedWing")
    expect(player.OwnedSkins).to.contain("RedWing")
    expect(player.Currency).to.equal(80) -- assume skin costs 20
end
