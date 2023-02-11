local Mod = RegisterMod("Madoka_Character", 1) -- Change the part in quotes to match your mod name
Madoka_Character = RegisterMod("Madoka_Character", 1)

local Madoka = { --Normal Madoka stat editing
    DAMAGE = -1.5, -- These are all relative to Isaac's base stats.
	MAXFIREDELAY = -1, 
	SHOTSPEED = 0,
    SPEED = -0.2,
    TEARHEIGHT = 3.81,
    TEARFALLINGSPEED = -1,
    LUCK = 1,
    FLYING = false,                                  
    TEARFLAG = 0, -- 0 is default
    TEARCOLOR = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)  -- Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0) is default
}

local TMadoka = { --Tainted Madoka stat editing
	DAMAGE = 1, -- These are all relative to Isaac's base stats.
	MAXFIREDELAY = 2, 
	SHOTSPEED = -0.5,
    SPEED = 0,
    TEARHEIGHT = 3.81,
    TEARFALLINGSPEED = -1,
    LUCK = -3,
    FLYING = false,                                  
    TEARFLAG = 0, -- 0 is default
    TEARCOLOR = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)  -- Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0) is default
}
 
function Madoka:onCache(player, cacheFlag)
    if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Madoka", false) then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + Madoka.DAMAGE
        end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay + Madoka.MAXFIREDELAY
		end
        if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + Madoka.SHOTSPEED
        end
        if cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearHeight = player.TearHeight - Madoka.TEARHEIGHT
            player.TearFallingSpeed = player.TearFallingSpeed + Madoka.TEARFALLINGSPEED
        end
        if cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + Madoka.SPEED
        end
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + Madoka.LUCK
        end
        if cacheFlag == CacheFlag.CACHE_FLYING and Madoka.FLYING then
            player.CanFly = true
        end
        if cacheFlag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | Madoka.TEARFLAG
        end
        if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = Madoka.TEARCOLOR
        end
    end
	
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Madoka", true) then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + TMadoka.DAMAGE
        end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay + TMadoka.MAXFIREDELAY
		end
        if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + TMadoka.SHOTSPEED
        end
        if cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearHeight = player.TearHeight - TMadoka.TEARHEIGHT
            player.TearFallingSpeed = player.TearFallingSpeed + TMadoka.TEARFALLINGSPEED
        end
        if cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + TMadoka.SPEED
        end
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + TMadoka.LUCK
        end
        if cacheFlag == CacheFlag.CACHE_FLYING and TMadoka.FLYING then
            player.CanFly = true
        end
        if cacheFlag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | TMadoka.TEARFLAG
        end
        if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = TMadoka.TEARCOLOR
        end
    end
	
end

Madoka.HAIR_ID_A = Isaac.GetCostumeIdByPath("gfx/characters/character_madoka_hair.anm2")
Madoka.HAIR_ID_B = Isaac.GetCostumeIdByPath("gfx/characters/character_madoka_hair_b.anm2")

function Madoka:onUpdate(player)
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Madoka", false) then
	player:AddNullCostume(Madoka.HAIR_ID_A);
	end
	if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Madoka", true) then
	player:AddNullCostume(Madoka.HAIR_ID_B);
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Madoka.onUpdate)

--Active Item Start
include('scripts.items.madokasoulgem')
--Active Item End

if EID then
EID:setModIndicatorName("Madoka")
include('scripts.EID.descriptions')
end
 
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Madoka.onCache)