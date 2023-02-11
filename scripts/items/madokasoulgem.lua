Madoka_Character.COLLECTIBLE_MADOKA_SOUL_GEM = Isaac.GetItemIdByName("Madoka's Soul Gem")
local game = Game()

local Madoka_Soul_Gem = {
	Active=false,
	Direction = Direction.NO_DIRECTION,
	DirectionStart = 1,
	EntityVariant = Isaac.GetEntityVariantByName("Madoka's Soul Gem"),
	Sprite = nil,
	Entity = nil,
	HueWidth = 240
	}

local corruption = 0

function Madoka_Character:onUpdate(player, useFlags)
local data = player:GetData()
	if Game():GetFrameCount() == 1 then
		Madoka_Character.HasMadokaSoulGem = false
		if player:GetPlayerType() ~= Isaac.GetPlayerTypeByName("Madoka", true) then return end
		player:SetPocketActiveItem(Isaac.GetItemIdByName("Madoka's Soul Gem"), SLOT_POCKET, false)
		corruption = 0
	end
	
	
	if Madoka_Soul_Gem.Active then --when item is used...
		--Animation part start
		player:AnimateCollectible(Madoka_Character.COLLECTIBLE_MADOKA_SOUL_GEM, "UseItem", "PlayerPickup")
		--Animation end. Should play the animation where you raise the item like you do with other active items
		
		if data.SoulPoints <= 2100 then --If player tries to use the item when Soul Points are less than 2100...
		Game():GetHUD():ShowFortuneText("You overclocked", "the Soul Gem...")
		SFXManager():Play(SoundEffect.SOUND_DEVILROOM_DEAL)
		player:AddBrokenHearts(12) --End the player's run by giving MAX broken hearts
		corruption = 1 --turn on corruption mark to deactivate revival
		end
		player:AddHearts(6)             --Heal 3 red hearts
		Madoka_Soul_Gem.Active = false  --deactivate item
		Madoka_Soul_Gem.Entity:Remove() --deactivate entity
		data.SoulPoints = data.SoulPoints - 2100 --Spend 2100 from Soul Points
		data.SoulGemTimer = 90 -- game updates in 30 fps so multiply seconds of the buff by 30
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY + CacheFlag.CACHE_SHOTSPEED)
		player:EvaluateItems()
	end

	if data.SoulGemTimer and data.SoulGemTimer > 0 then
	-- Timer is >0, tick down by 1.
		data.SoulGemTimer = data.SoulGemTimer - 1
		-- If we just hit 0, recalculate stats.
	if data.SoulGemTimer == 0 then
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY + CacheFlag.CACHE_SHOTSPEED)
		player:EvaluateItems()
		end
	end	

--Soul Points Start
	for playerNum = 0, Game():GetNumPlayers() - 1 do
		local player = Game():GetPlayer(playerNum)
			if player:HasCollectible(Madoka_Character.COLLECTIBLE_MADOKA_SOUL_GEM) then --does the player have the collectible?
				if not Madoka_Character.HasMadokaSoulGem then --when getting it for the first time
					data.SoulPoints = 30000 --Counter starts at 30000
					data.MAXSoulPoints = 30000 --Set a maximum value
					data.DrainCounter = 10 --30 frame per second
					Madoka_Character.HasMadokaSoulGem = true --tell the game you got the gem
				end
			
			if data.DrainCounter and data.DrainCounter > 0 then
				data.DrainCounter = data.DrainCounter - 1 --DrainCounter goes down per frame
				if data.SoulPoints and data.SoulPoints > 0 and data.DrainCounter <= 0 then --Apply the following when Counter is at 0
					--Soul Points are > 0...
					data.SoulPoints = data.SoulPoints - (1 + (player:GetEffectiveMaxHearts() - player:GetHearts())/2) -- drain by 1, increase value per empty container
					data.DrainCounter = 10  --reset drain timer back, speed up drain for each empty heart container
				if data.SoulPoints <= 0 then
					--When Soul Points hits 0...
					player:AddBrokenHearts(12) --End the player's run by giving MAX broken hearts
					corruption = 1 --turn on corruption mark to deactivate revival
					Game():GetHUD():ShowFortuneText("Your Soul Gem was", "completely corrupted...")
					SFXManager():Play(SoundEffect.SOUND_DEVILROOM_DEAL)
					end
				end
			end
			
			
		end	
	end

--Soul Points End

	if player:IsDead() then
	Madoka_Character:Soul_Revive()
	end

end 
Madoka_Character:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Madoka_Character.onUpdate)

local animationTimer = 0
local maxAnimationTime = 56
local immunityTimer = 0
local maxImmunityTime = 136
local playingAnimation = false
local immuneToDamage = false
local revive_hearts = 0
local cost = 0

--Revive part start	
function Madoka_Character:Soul_Revive()

local player = Isaac.GetPlayer()
local data = player:GetData()


	if player:IsDead() and Madoka_Character.HasMadokaSoulGem and corruption == 0 and player:GetExtraLives() == 0 then
	--If the player took a fatal damage, has the Soul gem, corruption trigger is off and no extra lives...
			player:ResetDamageCooldown()
			playingAnimation = true
			immuneToDamage = true
			SFXManager():Play(SoundEffect.SOUND_ISAACDIES)
			player.Friction = 0
			player.ControlsEnabled = false
			player:GetSprite():Play("Death", 1)
			player:Revive()     
			player:ResetDamageCooldown()
			player:SetMinDamageCooldown(120)
			
		revive_hearts = player:GetMaxHearts() --get current red heart containers
		if revive_hearts == 0 then  --if none, spend by default 2000
			cost = 2000
			playingAnimation = true
			immuneToDamage = true
		else
			cost = revive_hearts/2 * 750
			playingAnimation = true
			immuneToDamage = true
		end
	end

	if animationTimer > maxAnimationTime then
		animationTimer = 0
		playingAnimation = false
		player.ControlsEnabled = true
		if data.SoulPoints > cost then
			data.SoulPoints = data.SoulPoints - cost
			SFXManager():Play(SoundEffect.SOUND_SUPERHOLY)
			
			Game():GetHUD():ShowFortuneText(cost .. " Soul Points", "Spent")
				if player:GetMaxHearts() == 0 then  --no red heart containers, revive with 2 soul
					player:AddSoulHearts(3)
				else        --otherwise full red health
					player:AddHearts(revive_hearts)
				end
			player:AnimateCollectible(Madoka_Character.COLLECTIBLE_MADOKA_SOUL_GEM, "Pickup", "PlayerPickupSparkle")
		else if data.SoulPoints < cost then
			data.SoulPoints = data.SoulPoints - cost
			player:AddBrokenHearts(12)
			corruption = 1 --turn on corruption mark to deactivate revival
			Game():GetHUD():ShowFortuneText("Your Soul Gem was", "completely corrupted...")
			SFXManager():Play(SoundEffect.SOUND_DEVILROOM_DEAL)
			end
		end
	end
	
	if playingAnimation then --increase Timer if the death animation is playing
		animationTimer = animationTimer + 1
	else
		animationTimer = 0
	end
	
	if immunityTimer > maxImmunityTime then --upon immunity timer is at peak...
		immunityTimer = 0
		immuneToDamage = false --turn off immunity
	end
	
	if immuneToDamage then --if immunity is on
		immunityTimer = immunityTimer + 1
	end
	
end
--Revive part end
Madoka_Character:AddCallback(ModCallbacks.MC_POST_UPDATE, Madoka_Character.Soul_Revive, EntityType.ENTITY_PLAYER)


function Madoka_Character:immune() -- Immune to damage (during revival)
	if immuneToDamage then
		return false --returning false in entity take damage callback ignores damage
	end
end
Madoka_Character:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Madoka_Character.immune, EntityType.ENTITY_PLAYER)

function onRender(t)
for i = 0, game:GetNumPlayers() - 1, 1 do
	local player = game:GetPlayer(i)
		if Madoka_Character.HasMadokaSoulGem then --does the player have the collectible?
			local data = player:GetData()
			Isaac.RenderText("Soul Points: " .. data.SoulPoints, 60, 40, 1, 1, 1, 255)
			--Isaac.RenderText("Next revival cost: " .. cost, 60, 50, 1, 1, 1, 255)
		end
	end
end

Madoka_Character:AddCallback(ModCallbacks.MC_POST_RENDER, onRender)

function bossClear()
for i = 0, game:GetNumPlayers() - 1, 1 do
	local player = game:GetPlayer(i)
		local data = player:GetData()
		local room = Game():GetRoom()  --Get the current room
		
		if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Madoka", true) then
			if room:GetType() == RoomType.ROOM_BOSS and player:GetPlayerType() == Isaac.GetPlayerTypeByName("Madoka", true) then  --Is the room a boss room? Is the player playing as Tainted Madoka?
				data.SoulPoints = data.SoulPoints + 1000  --Add Soul Points
				SFXManager():Play(SoundEffect.SOUND_SOUL_PICKUP)
			end
			if data.SoulPoints > data.MAXSoulPoints and player:GetPlayerType() == Isaac.GetPlayerTypeByName("Madoka", true) then  --Reduce overloaded points if went higher
				data.SoulPoints = data.MAXSoulPoints
			end
		else end
	end
	
end
Madoka_Character:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, bossClear)


function Madoka_Character:updateCache(player, cacheFlag)
	local data = player:GetData()
		if data.SoulGemTimer and data.SoulGemTimer > 0 then --modify the stats to gain here
			if cacheFlag == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = player.MaxFireDelay - 12 -- or something, I forget the correct variable to change since repentance updated the formulas
			elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
				player.ShotSpeed = player.ShotSpeed + 2
			end
		end
	end
Madoka_Character:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Madoka_Character.updateCache)

function Madoka_Character:ActivateMadokaSoulGem(_Type, RNG)
	Madoka_Soul_Gem.Active = true
	local player = Isaac.GetPlayer(0)
	Madoka_Soul_Gem.Entity = Isaac.Spawn(EntityType.ENTITY_EFFECT, Madoka_Soul_Gem.EntityVariant, 0, player.Position, Vector (0,0), player)
end
Madoka_Character:AddCallback(ModCallbacks.MC_USE_ITEM, Madoka_Character.ActivateMadokaSoulGem, Madoka_Character.COLLECTIBLE_MADOKA_SOUL_GEM)
