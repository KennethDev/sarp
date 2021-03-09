AddEventHandler("sa:char:loadCallback", function(source)
	TriggerEvent("sa:weapons:getWeapons", source)
end)

RegisterServerEvent("sa:char:loadCallback1")
AddEventHandler("sa:char:loadCallback1", function()
	TriggerEvent("sa:weapons:getWeapons", source)
end)



RegisterServerEvent("sa:weapons:getWeapon")
AddEventHandler("sa:weapons:getWeapon", function()
	TriggerEvent("sa:base:getWeapons", source, "sa:weapons:weaponCallback")
end)

AddEventHandler("sa:weapons:getWeapons", function(source)
	TriggerEvent("sa:base:getWeapons", source, "sa:weapons:weaponCallback")
end)

AddEventHandler("sa:weapons:weaponCallback", function(source, weapons)
	TriggerClientEvent("sa:weapons:giveWeapons", source, weapons)
end)

RegisterServerEvent("sa:weapons:saveWeapons")
AddEventHandler("sa:weapons:saveWeapons", function(weapons)
	TriggerEvent("sa:base:saveWeapons", source, weapons)
end)

--[[ Rescue Mode ]]--
AddEventHandler("rconCommand", function(name, args)
	if name:lower() == "escape2" then
		TriggerClientEvent("sa:weapons:escape", tonumber(args[1]))
		CancelEvent()
	elseif name:lower() == "removeweapons" then
		TriggerClientEvent("sa:weapons:remove", tonumber(args[1]))
		CancelEvent()
	end
end)