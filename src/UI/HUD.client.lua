local HUD = {}

function HUD.Create(player)
    local frame = Instance.new("Frame")
    local resLabel = Instance.new("TextLabel")
    resLabel.Name = "ResourcesLabel"
    resLabel.Text = tostring(player.Resources or 0)
    resLabel.Parent = frame
    return frame
end

return HUD