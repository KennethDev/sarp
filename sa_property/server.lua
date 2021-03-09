local properties = {}

TriggerEvent("sa:base:getProperties", "sa:property:saveProperties")

AddEventHandler("sa:property:saveProperties", function(new_properties)
	properties = new_properties
end)

AddEventHandler("sa:char:loadCallback", function(source)
	TriggerEvent("sa:property:getMyID", source)
end)

RegisterServerEvent("sa:property:getProperties")
AddEventHandler("sa:property:getProperties", function()
	TriggerClientEvent("sa:property:loadProperties", source, properties)
end)

AddEventHandler("sa:property:refreshProperties", function()
	TriggerClientEvent("sa:property:loadProperties", -1, properties)
end)

RegisterServerEvent("sa:property:spawnPersonalVehicle")
AddEventHandler("sa:property:spawnPersonalVehicle", function(x,y,z,h)
	TriggerEvent("sa:base:getPersonalVehicle", source, "sa:property:spawnPersonalVehicle_2", x, y, z, h)
end)

RegisterServerEvent("sa:property:getMyID")
AddEventHandler("sa:property:getMyID", function(source)
	TriggerEvent("sa:base:getPlayer", source, function(player,character)
		TriggerClientEvent("sa:property:loadMyID", source, character:getID())
	end)
end)

RegisterServerEvent("sa:property:buy")
AddEventHandler("sa:property:buy", function(id)
	TriggerEvent("sa:base:getPlayer", source, function(player, character)
		local name = split(character:getName(), " ")
		if (tonumber(properties[id].price) > tonumber(character:getBankBalance())) then
			TriggerClientEvent("sa:property:notify", source, "~w~Hello, ~y~" .. name[1] .. "~w~! I'm afraid you are ~r~$" .. (properties[id].price - character:getBankBalance()) .. " ~w~short of being able to afford this house. If you're sure that you had the money, be sure to put it in your ~y~checking account~w~.")
		else
			TriggerEvent("sa:banking:charge", source, "Dynasty 8", properties[id].price)
			TriggerEvent("sa:base:setPropertyOwnership", properties[id].id, character:getID())
			TriggerClientEvent("sa:property:notify", source, "~w~Hello, ~y~" .. name[1] .. "~w~! I've secured the deal on ~g~" .. properties[id].address .. " ~w~for you!")
		end
	end)
end)

RegisterServerEvent("sa:property:sell")
AddEventHandler("sa:property:sell", function(id)
	TriggerEvent("sa:base:getPlayer", source, function(player, character)
		local name = split(character:getName(), " ")
		TriggerEvent("sa:banking:recieve", source, "Dynasty 8", properties[id].price)
		TriggerEvent("sa:base:setPropertyOwnership", properties[id].id, 0)
		TriggerClientEvent("sa:property:notify", source, "~w~Hello, ~y~" .. name[1] .. "~w~! I've secured the deal on ~g~" .. properties[id].address .. " ~w~for you!")
	end)
end)

AddEventHandler("sa:property:spawnPersonalVehicle_2", function(source, cars, x, y, z, h)
	TriggerClientEvent("sa:property:menu:loadVehicles", source, cars, x, y, z, h)
	--TriggerClientEvent("sa:property:spawnVehicle", source, type, license_plate, color1, color2, x, y, z, h)
end)

--[[ Rescue Mode ]]--
AddEventHandler("rconCommand", function(name, args)
	if name:lower() == "escape1" then
		TriggerClientEvent("sa:property:escape", tonumber(args[1]))
		CancelEvent()
	elseif name:lower() == "load" then
		TriggerClientEvent("sa:property:loadMyID", tonumber(args[1]), tonumber(args[2]))
		CancelEvent()
	end
end)

function split(source, delimiters)
	local elements = {}
	local pattern = '([^'..delimiters..']+)'
	string.gsub(source, pattern, function(value) elements[#elements + 1] =     value;  end);
	return elements
end