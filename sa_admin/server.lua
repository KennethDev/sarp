--[[ Constants ]]--
SCRIPT_NAME = "ADMIN"
SCRIPT_PREFIX = "[ADMIN] "

--[[ Command Registration ]]--
function registerCommands()
	print(SCRIPT_PREFIX .. "Registering Commands")
	TriggerEvent("sa:base:registerCommand", "setlevel", "Set the permission level of a user.", 3, function(source, args, player, character)
		if (tonumber(args[1]) and tonumber(args[2])) then
			TriggerEvent("sa:base:setPermissionLevel", tonumber(args[1]), tonumber(args[2]))
		else
			MessageClient(source, "^1Usage: ^7/setlevel <id> <level>")
		end
	end)
	TriggerEvent("sa:base:registerCommand", "revive", "Revive a player", 2, function(source, args, player, character)
		if (args[1] ~= nil) then
			MessageClient(args[1], "^7You have been revived by an admin.")
			TriggerClientEvent("sa:admin:revive", args[1])
		else
			MessageClient(source, "^7You have been revived by an admin.")
			TriggerClientEvent("sa:admin:revive", source)
		end
	end)
	TriggerEvent("sa:base:registerCommand", "getskin", "Retrieve your current skin.", 3, function(source, args, player, character)
		TriggerClientEvent("sa:admin:getSkin", source)
	end)
	TriggerEvent("sa:base:registerCommand", "unfreeze", "Unfreeze yourself.", 3, function(source, args, player, character)
		TriggerClientEvent("sa:admin:freeze", source, false)
	end)
	TriggerEvent("sa:base:registerCommand", "kar", "Spawn Car", 3, function(source, args, player, character)
		TriggerClientEvent("sa:admin:kar", source, args[1])
	end)
	TriggerEvent("sa:base:registerCommand", "rob", "Force Rob", 3, function(source, args, player, character)
		TriggerEvent("sa:rob:force", -1)
	end)
	print(SCRIPT_PREFIX .. "Registered Commands")
end

registerCommands()

AddEventHandler("sa:base:requestCommands", function()
	SetTimeout(25, function()
		registerCommands()
	end)
end)

--[[ Useful Functions ]]--
function MessageClient(id, message)
	TriggerClientEvent("chatMessage", id, "", {0,0,0}, message)
end