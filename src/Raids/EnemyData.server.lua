local EnemyData = {}
EnemyData.__index = EnemyData

local ENEMY_STATS = {
    Ant = {Health = 30, Attack = 5},
    Bee = {Health = 40, Attack = 7},
    Spider = {Health = 50, Attack = 10},
    Beetle = {Health = 60, Attack = 12},
    Dragonfly = {Health = 80, Attack = 15},
}

function EnemyData.New(typeName)
    local stats = ENEMY_STATS[typeName] or {Health = 30, Attack = 5}
    return {Type = typeName, Health = stats.Health, Attack = stats.Attack}
end

return EnemyData