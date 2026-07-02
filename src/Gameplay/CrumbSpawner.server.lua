local CrumbSpawner = {}

function CrumbSpawner.Spawn(count)
    local crumbs = {}
    for i = 1, count do
        table.insert(crumbs, {Id = i, Value = 1})
    end
    return crumbs
end

return CrumbSpawner
