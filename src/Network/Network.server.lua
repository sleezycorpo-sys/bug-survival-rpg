local Network = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Helper to get or create a mock RemoteEvent or real one
function Network._getEvent(name)
    if _G.MockReplicatedStorage then
        _G.MockReplicatedStorage.Events = _G.MockReplicatedStorage.Events or {}
        _G.MockReplicatedStorage.Events[name] = _G.MockReplicatedStorage.Events[name] or {}
        return _G.MockReplicatedStorage.Events[name]
    else
        local folder = ReplicatedStorage:FindFirstChild("Events")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "Events"
            folder.Parent = ReplicatedStorage
        end
        local ev = folder:FindFirstChild(name)
        if not ev then
            ev = Instance.new("RemoteEvent")
            ev.Name = name
            ev.Parent = folder
        end
        return ev
    end
end

function Network.FireUpdate(player)
    local ev = Network._getEvent("PlayerUpdate")
    -- In mock mode we simply store payload for test inspection
    if _G.MockReplicatedStorage then
        ev.payload = player
    else
        ev:FireAllClients(player)
    end
end

function Network.OnRequest(callback)
    local ev = Network._getEvent("RequestState")
    if _G.MockReplicatedStorage then
        ev.callback = callback
    else
        ev.OnServerEvent:Connect(callback)
    end
end

return Network