return function()
    local HUD = require(script.Parent.HUD)
    local player = {Resources = 5, NestLevel = 1}
    local frame = HUD.Create(player)
    expect(frame).to.be.instanceOf("Frame")
    expect(frame:FindFirstChild("ResourcesLabel").Text).to.equal("5")
end
