local CrumbCollector = {}

function CrumbCollector.Collect(player, crumb)
    -- placeholder: award player 1 resource point
    player.Resources = (player.Resources or 0) + crumb.Value
end

return CrumbCollector
