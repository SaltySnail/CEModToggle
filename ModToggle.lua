--ModToggle by Julianstap, 2023

local M = {}
M.COBALT_VERSION = "1.7.5"

local copyTimeout = 2000

local ModToggleCommands = {
	modtoggle_help = {orginModule = "ModToggle", level = 5, arguments = 0, sourceLimited = 1, description = "Use to see the possible commands."},
	enable_mod = {orginModule = "ModToggle", level = 5, arguments = {"filename"}, sourceLimited = 1, description = "Enables the .zip with the filename specified."},
	disable_mod = {orginModule = "ModToggle", level = 5, arguments = {"filename"}, sourceLimited = 1, description = "Disables the .zip with the filename specified."}
}

local function applyStuff(targetDatabase, tables)
	local appliedTables = {}
	for tableName, table in pairs(tables) do
		if targetDatabase[tableName]:exists() == false then
			for key, value in pairs(table) do
				targetDatabase[tableName][key] = value
			end
			appliedTables[tableName] = tableName
		end
	end
	return appliedTables
end

--called whenever the extension is loaded
local function onInit(stateData)
	applyStuff(commands, ModToggleCommands)
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

local function modtoggle_help(player)
	CElog("modtoggle_help called")
	CElog(player.playerID)
	MP.SendChatMessage(player.playerID,"/disable_mod ModName - disable ModName.zip, make sure you have a folder in Client/ called deactivated (Client/deactivated/)")
	MP.SendChatMessage(player.playerID,"/enable_mod ModName - enables ModName.zip")
end

local function modtoggle_disable(player, filename)
	CElog("modtoggle_disable called")
	if filename == nil then
		return
	end
	if FS.Exists("Resources/Client/" .. filename .. ".zip") then
		FS.Copy("Resources/Client/" .. filename .. ".zip", "Resources/Client/deactivated/" .. filename .. ".zip")
		MP.Sleep(copyTimeout) 
		if FS.Exists("Resources/Client/deactivated/" .. filename .. ".zip") then
			FS.Remove("Resources/Client/" .. filename .. ".zip")
			MP.SendChatMessage(player.playerID,"Disabled the mod by moving it to: Resources/Client/deactivated/" .. filename .. ".zip")
		else 
			MP.SendChatMessage(player.playerID,"Copying the file:" .. "Resources/Client/deactivated/" .. filename .. ".zip took longer than " .. copyTimeout/1000.0 .. " seconds")
		end
	elseif FS.Exists("Resources/Client/" .. filename) then
		FS.Copy("Resources/Client/" .. filename, "Resources/Client/deactivated/" .. filename)
		MP.Sleep(copyTimeout) 
		if FS.Exists("Resources/Client/deactivated/" .. filename) then
			FS.Remove("Resources/Client/" .. filename)
			MP.SendChatMessage(player.playerID,"Disabled the mod by moving it to: Resources/Client/deactivated/" .. filename)
		else 
			MP.SendChatMessage(player.playerID,"Copying the file:" .. "Resources/Client/deactivated/" .. filename .. ".zip took longer than " .. copyTimeout/1000.0 .. " seconds")
		end
	else
		MP.SendChatMessage(player.playerID,"File didn't exist: " .. "Resources/Client/" .. filename .. ".zip")
		return
	end
end

local function modtoggle_enable(player, filename)
	CElog("modtoggle_enable called")
	if filename == nil then
		return
	end
	if FS.Exists("Resources/Client/deactivated/" .. filename .. ".zip") then
		FS.Copy("Resources/Client/deactivated/" .. filename .. ".zip", "Resources/Client/" .. filename .. ".zip")
		MP.Sleep(copyTimeout)
		if FS.Exists("Resources/Client/" .. filename .. ".zip") then
			FS.Remove("Resources/Client/deactivated/" .. filename .. ".zip")
			MP.SendChatMessage(player.playerID,"Enabled the mod by moving it to: Resources/Client/" .. filename .. ".zip")
		else 
			MP.SendChatMessage(player.playerID,"Copying the file:" .. "Resources/Client/" .. filename .. ".zip took longer than a second")
		end
	elseif FS.Exists("Resources/Client/deactivated/" .. filename) then
		FS.Copy("Resources/Client/deactivated/" .. filename, "Resources/Client/" .. filename)
		MP.Sleep(copyTimeout)
		if FS.Exists("Resources/Client/" .. filename) then
			FS.Remove("Resources/Client/deactivated/" .. filename)
			MP.SendChatMessage(player.playerID,"Enabled the mod by moving it to: Resources/Client/" .. filename)
		else 
			MP.SendChatMessage(player.playerID,"Copying the file:" .. "Resources/Client/" .. filename .. " took longer than a second")
		end
	else
		MP.SendChatMessage(player.playerID,"File didn't exist: " .. "Resources/Client/deactivated/" .. filename .. ".zip")
		return
	end
end

M.onInit = onInit

M.modtoggle_help = modtoggle_help
M.disable_mod = modtoggle_disable
M.enable_mod = modtoggle_enable

return M


