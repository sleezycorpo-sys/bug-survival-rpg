return function()
    -- Mock ReplicatedStorage
    _G.MockReplicatedStorage = {Events = {}}
    local Network = require(script.Parent.Network)
    local player = {UserId = 1, Resources = 10, Health = 100}
    Network.FireUpdate(player)
    local ev = _G.MockReplicatedStorage.Events.PlayerUpdate
    expect(ev).to.exist()
    expect(ev.payload).to.equal(player)
end