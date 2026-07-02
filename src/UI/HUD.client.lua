local HUD = {}

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

return HUD