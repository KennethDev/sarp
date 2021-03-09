RegisterServerEvent("sa:char:joined")
AddEventHandler("sa:char:joined", function()
	TriggerEvent("sa:char:refresh", source)
end)

RegisterServerEvent("sa:char:refresh")
AddEventHandler("sa:char:refresh", function(source)
	TriggerEvent("sa:base:getPlayerOnly", source, function(player)
		local chars = player:getCharacters()
		if (player:getPermissions() >= 3) then
			TriggerClientEvent("sa:hud:asdjk", source)
		end
		print("Character Array: " .. chars)
		if (#chars < 1) then
			TriggerClientEvent("sa:admin:freeze", source, true)
			TriggerClientEvent("sa:char:create", source)
		else
			TriggerEvent("sa:base:setCharacter", source, chars[1])
			TriggerEvent("sa:banking:setBalance", source, player:getCharacter():getCashBalance(), player:getCharacter():getBankBalance())
			TriggerClientEvent("sa:factions:setFaction", source, player:getCharacter():getFaction(), player:getCharacter():getFactionRank())
			TriggerClientEvent("sa:admin:freeze", source, false)
			TriggerEvent("sa:char:engage", source)
			TriggerEvent("sa:char:spawn", source, 1064.20, -718.02, 57.17, 128.91)
			MessageClient(source, "^7Welcome to San Andreas Roleplay!")
			MessageClient(source, "^7Do ^2/help ^7for a list of commands.")
			MessageClient(source, "^7Do ^2/info ^7for server information including the teamspeak ip, developers, etc.")
			MessageClient(source, "^7Do ^2/outfit ^7for information on customizing your character.")
			TriggerEvent("sa:char:loadCallback", source)
		end
	end)
end)

RegisterServerEvent("sa:char:createCharacter")
AddEventHandler("sa:char:createCharacter", function(fn, ln, g, dob, race)
	TriggerEvent("sa:base:createCharacter", source, fn, ln, g, dob, race)
end)

AddEventHandler("sa:char:engage", function(id)
	TriggerEvent("sa:base:getPlayer", id, function(player, character)
		TriggerClientEvent("sa:char:restoreOutfit", id, character:getGender(), character:getOutfit())
	end)
end)

AddEventHandler("sa:char:spawn", function(source, x, y, z, h)
	TriggerClientEvent("sa:char:teleport", source, x, y, z, h)
end)

--[[ Constants ]]--
SCRIPT_NAME = "CHARACTER"
SCRIPT_PREFIX = "[CHARACTER] "

--[[ Command Registration ]]--
function registerCommands()
	print(SCRIPT_PREFIX .. "Registering Commands")
	TriggerEvent("sa:base:registerCommand", "outfit", "Learn about customizing your character.", 0, function(source, args, player, character)
		MessageClient(source, "^3-------------------------------------------")
		MessageClient(source, "^7To customize your character, press the ^2F5 ^7key (default) on your keyboard.")
		MessageClient(source, "^7After that, run ^2/saveoutfit ^7to save your outfit.")
		MessageClient(source, "^3-------------------------------------------")
	end)
	TriggerEvent("sa:base:registerCommand", "saveoutfit", "Save your character/outfit.", 0, function(source, args, player, character)
		TriggerClientEvent("sa:char:getOutfit", source)
	end)
	print(SCRIPT_PREFIX .. "Registered Commands")
end

registerCommands()

AddEventHandler("sa:base:requestCommands", function()
	SetTimeout(25, function()
		registerCommands()
	end)
end)

--[[ Functions ]]--
function MessageClient(id, message)
	TriggerClientEvent("chatMessage", id, "", {0,0,0}, message)
end