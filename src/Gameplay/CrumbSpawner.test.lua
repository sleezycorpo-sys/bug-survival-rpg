return function()
    local Spawner = require(script.Parent.CrumbSpawner)
    local crumbs = Spawner.Spawn(5)
    expect(#crumbs).to.equal(5)
end
