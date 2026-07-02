local HUD = {}

local Network = require(script.Parent.Parent.Network.Network)
local currentFrame = nil

function HUD.Create(player)
    local frame = Instance.new("Frame")
    local resLabel = Instance.new("TextLabel")
    resLabel.Name = "ResourcesLabel"
    resLabel.Text = tostring(player.Resources or 0)
    resLabel.Parent = frame
    return frame
end

-- Combat HUD: shows player health and enemy list
function HUD.CreateCombat(player, raid)
    local frame = Instance.new("Frame")
    local pHealth = Instance.new("TextLabel")
    pHealth.Name = "PlayerHealth"
    pHealth.Text = tostring(player.Health or 0)
    pHealth.Parent = frame

    local enemiesFolder = Instance.new("Folder")
    enemiesFolder.Name = "Enemies"
    enemiesFolder.Parent = frame
    for _, enemy in ipairs(raid.Enemies or {}) do
        local eLabel = Instance.new("TextLabel")
        eLabel.Name = enemy.Type .. "Health"
        eLabel.Text = tostring(enemy.Health)
        eLabel.Parent = enemiesFolder
    end
    return frame
end

-- Apply a full player data update to an existing HUD frame
function HUD.ApplyUpdate(frame, data)
    local resLabel = frame:FindFirstChild("ResourcesLabel")
    if resLabel then
        resLabel.Text = tostring(data.Resources or 0)
    end
    local healthLabel = frame:FindFirstChild("PlayerHealth")
    if healthLabel then
        healthLabel.Text = tostring(data.Health or 0)
    end
    -- If the frame has an Enemies folder, update each enemy health label
    local enemiesFolder = frame:FindFirstChild("Enemies")
    if enemiesFolder and data.Enemies then
        for _, enemy in ipairs(data.Enemies) do
            local label = enemiesFolder:FindFirstChild(enemy.Type .. "Health")
            if label then
                label.Text = tostring(enemy.Health)
            end
        end
    end
end

function HUD.Bind(frame)
    currentFrame = frame
    Network.ListenUpdate(function(data)
        HUD.ApplyUpdate(frame, data)
    end)
end

return HUD