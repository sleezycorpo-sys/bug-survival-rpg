local StoreManager = {}
local SKIN_COST = 20

function StoreManager.PurchaseSkin(player, skinName)
    if (player.Currency or 0) >= SKIN_COST then
        player.Currency = player.Currency - SKIN_COST
        player.OwnedSkins = player.OwnedSkins or {}
        player.OwnedSkins[skinName] = true
    end
end

return StoreManager