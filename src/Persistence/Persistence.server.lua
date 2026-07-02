local Persistence = {}

local DS_NAME = "BugSurvivalRPG"

local function getDataStore()
    -- In tests we can inject a mock via the global _G.MockDataStore table
    if _G.MockDataStore then
        return {
            GetAsync = function(_, key) return _G.MockDataStore[key] end,
            SetAsync = function(_, key, value) _G.MockDataStore[key] = value end,
        }
    else
        local DataStoreService = game:GetService("DataStoreService")
        return DataStoreService:GetDataStore(DS_NAME)
    end
end

local function defaultPlayer(userId)
    return {
        UserId = userId,
        Resources = 0,
        NestLevel = 1,
        OwnedSkins = {},
        Health = 100,
        Attack = 5,
    }
end

function Persistence.Load(userId)
    local ds = getDataStore()
    local data = ds:GetAsync(tostring(userId))
    if data then
        return data
    else
        return defaultPlayer(userId)
    end
end

function Persistence.Save(player)
    local ds = getDataStore()
    ds:SetAsync(tostring(player.UserId), player)
end

return Persistence