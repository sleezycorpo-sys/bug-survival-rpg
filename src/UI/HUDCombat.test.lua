return function()
    local HUD = require(script.Parent.HUD)
    local player = {Resources = 5, Health = 40}
    local raid = {Enemies = {{Type = "Spider", Health = 50}, {Type = "Bee", Health = 40}}}
    local frame = HUD.CreateCombat(player, raid)
    expect(frame:FindFirstChild("PlayerHealth").Text).to.equal("40")
    expect(#frame:FindFirstChild("Enemies"):GetChildren()).to.equal(2)
end