-- vars
local useCustomErrorChecker = true -- should the custom error checker be used?

-- file loc
local _, err = pcall(require, "")
local modName = err:match("/mods/(.*)/%.lua")
local path = "mods/" .. modName .. "/"

local function require(loc, ...)
    return assert(require(path .. loc .. ".lua"))(...)
end

local _, ogerr = pcall(function()
    local stats = require("mod/stats")
    local stats = require("mod/stats")
    local imports = require("mod/imports")
    require("mod/MainMod",
             {modName, path, require, stats, imports, useCustomErrorChecker})
end)

--Costume Protector
Madoka_Character = RegisterMod("Madoka_Character", 1)
local costumeProtector = include("lib/characterCostumeProtector.lua")
costumeProtector:Init(Madoka_Character)

local PLAYER_MADOKA = Isaac.GetPlayerTypeByName("Madoka", false)
local PLAYER_MADOKA_B = Isaac.GetPlayerTypeByName("Madoka", true)

function Madoka_Character:PlayerInit(player)
	local playerType = player:GetPlayerType()
	
	costumeProtector:AddPlayer(
    player,
    PLAYER_MADOKA,
    "gfx/characters/costumes/character_madoka.png",
    67, --A separate costume that is added for all cases that you ever gain flight.
    "gfx/characters/costumes/character_madoka.png", --Your character's spritesheet, but customized to have your flight costume.
    Isaac.GetCostumeIdByPath("gfx/characters/character_madoka_hair.anm2") --Your character's additional costume. Hair, ears, whatever.
  )
	costumeProtector:ItemCostumeWhitelist(
    PLAYER_MADOKA,
    {
    [CollectibleType.COLLECTIBLE_TRANSCENDENCE] = true,
	[CollectibleType.COLLECTIBLE_PONY] = true,
	[CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION] = true
    }
	)
	
	costumeProtector:NullItemIDWhitelist(
    PLAYER_MADOKA,
    {
    [NullItemID.ID_LOST_CURSE] = true,
    [NullItemID.ID_SPIRIT_SHACKLES_SOUL] = true
    }
	)
	
	costumeProtector:AddPlayer(
    player,
    PLAYER_MADOKA_B,
    "gfx/characters/costumes/character_madoka_b.png",
    67, --A separate costume that is added for all cases that you ever gain flight.
    "gfx/characters/costumes/character_madoka_b.png", --Your character's spritesheet, but customized to have your flight costume.
    Isaac.GetCostumeIdByPath("gfx/characters/character_madoka_hair_b.anm2") --Your character's additional costume. Hair, ears, whatever.
  )
	costumeProtector:ItemCostumeWhitelist(
    PLAYER_MADOKA_B,
    {
    [CollectibleType.COLLECTIBLE_TRANSCENDENCE] = true,
	[CollectibleType.COLLECTIBLE_PONY] = true,
	[CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION] = true
    }
	)
	
	costumeProtector:NullItemIDWhitelist(
    PLAYER_MADOKA_B,
    {
    [NullItemID.ID_LOST_CURSE] = true,
    [NullItemID.ID_SPIRIT_SHACKLES_SOUL] = true
    }
	)
end
Madoka_Character:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Madoka_Character.PlayerInit)
--Costume Protector End

--Active Item Start
include('scripts.items.madokasoulgem')
--Active Item End

if EID then
EID:setModIndicatorName("Madoka")
include('scripts.EID.descriptions')
end


if (ogerr) then
    if (useCustomErrorChecker) then
        local errorChecker = require("lib/cerror")
        errorChecker.registerError()

        errorChecker.mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED,
                                     function(_, IsContin)
            local room = Game():GetRoom()

            for i = 0, 8 do room:RemoveDoor(i) end
        end)

        local str = errorChecker.formatError(ogerr)

        if (str) then
            local file = str:match("%w+%.lua")
            local line = str:match(":(%d+):")
            local err = str:match(":%d+: (.*)")
            errorChecker.setMod(modName)
            errorChecker.setFile(file)
            errorChecker.setLine(line)
            errorChecker.printError("Error:", err)
            errorChecker.printError("")
            errorChecker.printError("For full error report, open log.txt")
            errorChecker.printError("")
            errorChecker.printError("Log Root: C:\\Users\\<YOUR USER>\\Documents\\My Games\\Binding of Isaac Repentance\\log.txt")
            errorChecker.printError("")
            errorChecker.printError("Reload the mod, then start a new run, Holding R works")
        else
            errorChecker.printError("Unexpected error occured, please open log.txt!")
            errorChecker.printError("Log Root: C:\\Users\\<YOUR USER>\\Documents\\My Games\\Binding of Isaac Repentance\\log.txt")
            errorChecker.printError("")
            errorChecker.printError(ogerr)
        end
        Isaac.DebugString("-- START OF " .. modName:upper() .. " ERROR --")
        Isaac.DebugString(ogerr)
        Isaac.DebugString("-- END OF " .. modName:upper() .. " ERROR --")

        local room = Game():GetRoom()

        for i = 0, 8 do room:RemoveDoor(i) end

        error()
    else
        Isaac.ConsoleOutput(modName ..
                                " has hit an error, see Log.txt for more info\n")
        Isaac.ConsoleOutput(
            "Log Root: C:\\Users\\<YOUR USER>\\Documents\\My Games\\Binding of Isaac Repentance\\log.txt")
        Isaac.DebugString("-- START OF " .. modName:upper() .. " ERROR --")
        Isaac.DebugString(ogerr)
        Isaac.DebugString("-- END OF " .. modName:upper() .. " ERROR --")
        error()
    end
end
