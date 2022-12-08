local mt = {
    __index = {
        items = {},
        costume = {},
        trinket = {},
        card = {},
        pill = {},
        charge = {},
        name = ""
    }
}
function mt.__index:AddItem(id, costume)
    costume = costume or false
    table.insert(self.items, {id, costume})
end

local stats = {default = {}, tainted = {}}
setmetatable(stats.default, mt)
setmetatable(stats.tainted, mt)
local character = stats.default
local tainted = stats.tainted

character.items = {}
tainted.items = {}


character.name = "Madoka" 

character.stats = {
    damage = -1.50,
    firedelay = -1,
    shotspeed = 0.00,
    range = 3.81,
    speed = -0.20,
    tearflags = TearFlags.TEAR_NORMAL,
    tearcolor = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0),
    flying = false,
    luck = 1.00
}

character.costume = "character_madoka_hair"

character:AddItem(48, true)
character:AddItem(368, true)

character.trinket = TrinketType.TRINKET_NULL

character.card = Card.CARD_NULL

character.pill = false

character.charge = -1


tainted.enabled = true -- set this to false if you don't want a tainted character.

tainted.name = "Madoka"
tainted.stats = {
    damage = 1,
    firedelay = 2.00,
    shotspeed = -0.50,
    range = 3.81,
    speed = 0,
    tearflags = TearFlags.TEAR_NORMAL,
    tearcolor = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0),
    flying = false,
    luck = -3.00
}

tainted.costume = "character_madoka_hair_b"

tainted.trinket = TrinketType.TRINKET_NULL

tainted.card = Card.CARD_NULL

tainted.pill = false

tainted.charge = -1

--tainted:SetPocketActiveItem(CollectibleType.COLLECTIBLE_MADOKA_SOUL_GEM, ActiveSlot.SLOT_POCKET, false)



return stats
