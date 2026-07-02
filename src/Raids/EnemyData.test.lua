return function()
    local EnemyData = require(script.Parent.EnemyData)
    local enemy = EnemyData.New("Spider")
    expect(enemy.Type).to.equal("Spider")
    expect(enemy.Health).to.be.a("number")
    expect(enemy.Attack).to.be.a("number")
end
