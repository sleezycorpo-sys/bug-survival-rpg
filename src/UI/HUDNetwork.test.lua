return function()
    -- Mock ReplicatedStorage
    _G.MockReplicatedStorage = {Events = {}}
    local HUD = require(script.Parent.HUD)
    local player = {Resources = 5, Health = 100, UserId = 1}
    local frame = HUD.Create(player)
    HUD.Bind(frame)
    -- Simulate a network update
    local updated = {Resources = 12, Health = 80, UserId = 1}
    local ev = _G.MockReplicatedStorage.Events.PlayerUpdate
    expect(ev).to.exist()
    ev.clientCallback(updated)
    expect(frame:FindFirstChild("ResourcesLabel").Text).to.equal("12")
end