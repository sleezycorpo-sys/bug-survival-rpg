local Network = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function Network._getEvent(name)
    if _G.MockReplicatedStorage then
        _G.MockReplicatedStorage.Events = _G.MockReplicatedStorage.Events or {}
        _G.MockReplicatedStorage.Events[name] = _G.MockReplicatedStorage.Events[name] or {}
        return _G.MockReplicatedStorage.Events[name]
    else
        local folder = ReplicatedStorage:FindFirstChild("Events")
        if not folder then return nil end
        return folder:FindFirstChild(name)
    end
end

function Network.ListenUpdate(callback)
    local ev = Network._getEvent("PlayerUpdate")
    if _G.MockReplicatedStorage then
        ev.clientCallback = callback
    else
        ev.OnClientEvent:Connect(callback)
    end
end

function Network.RequestState(callback)
    local ev = Network._getEvent("RequestState")
    if _G.MockReplicatedStorage then
        ev.requestCallback = callback
    else
        ev:FireServer()
        ev.OnClientEvent:Connect(callback)
    end
end

return Network