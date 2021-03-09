--[[ Temporary ]]--
-- This will soon be replaced by a database. I just want to get the basic car spawning material in.
garages = {
	[1] = {
		stand = {x = 1037.74, y = -761.06, z = 57.78},
		car = {
			[1] = {x = 1031.06, y = -752.72, z = 57.18, h = 323.53},
		}
	},
	[2] = {
		stand = {x = 300.03, y = -191.19, z = 61.57},
		car = {
			[1] = {x = 299.72, y = -196.99, z = 61.10, h = 247.39},
			[2] = {x = 298.89, y = -200.55, z = 61.10, h = 69.15}
		}
	},
	[3] = {
		stand = {x = 215.02, y = -806.47, z = 30.81},
		car = {
			[1] = {x = 216.25, y = -801.81, z = 30.49, h = 70.02},
			[2] = {x = 217.35, y = -799.39, z = 30.47, h = 247.30}
		}
	},
	[4] = {
		stand = {x = 387.08, y = -1680.74, z = 32.53},
		car = {
			[1] = {x = 384.00, y = -1673.18, z = 32.10, h = 50.80},
			[2] = {x = 396.15, y = -1661.52, z = 32.10, h = 140.43}
		}
	},
	[5] = {
		stand = {x = 598.21, y = 89.48, z =92.81},
		car = {{x = 605.71, y = 92.29, z = 92.81, h = 186.85}}
	}
}

--[[ Load JSON Library ]]--

local properties = {}
local blips = {}

local myid = 0

last_car = nil
last_blip = nil
spawnable = true

Citizen.CreateThread(function()
	TriggerServerEvent("sa:property:getProperties")
	for i = 1, #garages do
		blip = AddBlipForCoord(garages[i].stand.x, garages[i].stand.y, garages[i].stand.z)
		SetBlipSprite(blip, 50)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Garage")
		EndTextCommandSetBlipName(blip)
	end
	while true do
		Citizen.Wait(0)
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		for i = 1, #garages do
			if (GetDistanceBetweenCoords(x,y,z,garages[i].stand.x,garages[i].stand.y,garages[i].stand.z) < 10) then
				DrawMarker(1, garages[i].stand.x,garages[i].stand.y,garages[i].stand.z-1.001, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 255, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if (GetDistanceBetweenCoords(x,y,z,garages[i].stand.x,garages[i].stand.y,garages[i].stand.z) < 1.0001) then
					helptext("Spawn Vehicle ~INPUT_CONTEXT~")
					if (IsControlJustReleased(1, 86)) then
						local spot = math.random(1,#garages[i].car)
						Citizen.Trace(garages[i].car[spot].x .. " " .. garages[i].car[spot].y .. " " .. garages[i].car[spot].z .. " " .. garages[i].car[spot].h)
						TriggerServerEvent("sa:property:spawnPersonalVehicle", garages[i].car[spot].x, garages[i].car[spot].y, garages[i].car[spot].z, garages[i].car[spot].h)
					end
				end
			end
		end
	end
end)

RegisterNetEvent("sa:property:loadMyID")
AddEventHandler("sa:property:loadMyID", function(id)
	myid = id
	TriggerEvent("sa:property:loadProperties", properties)
end)

RegisterNetEvent("sa:property:garage")
AddEventHandler("sa:property:garage", function(id)
	local property = properties[id]
	local car_spawns = split(property.cars, "|")
	local spot = car_spawns[math.random(1,#car_spawns)]
	local pos = split(spot,",")
	TriggerServerEvent("sa:property:spawnPersonalVehicle", tonumber(pos[1]),tonumber(pos[2]),tonumber(pos[3]),tonumber(pos[4]))
end)

RegisterNetEvent("sa:property:loadProperties")
AddEventHandler("sa:property:loadProperties", function(new_properties)
	for k in pairs (blips) do
		RemoveBlip(blips[k])
	    blips[k] = nil
	end
	properties = new_properties
	for i = 1, #properties do
		local m = properties[i].marker
		local marker = split(m, ",")
		blip = AddBlipForCoord(tonumber(marker[1]), tonumber(marker[2]), tonumber(marker[3]))
		if (properties[i].type == 0) then
			SetBlipSprite(blip, 40)
		else
			SetBlipSprite(blip, 475)
		end
		if (properties[i].owner == 0) then
			SetBlipColour(blip, 2)
		elseif (properties[i].owner == myid) then
			SetBlipColour(blip, 3)
		end
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		if (properties[i].type == 0) then
			if (properties[i].owner == 0) then
				AddTextComponentString("House for Sale")
			elseif (properties[i].owner == myid) then
				AddTextComponentString("Your House")
			elseif (properties[i].owner ~= myid and properties[i].owner ~= 0) then
				AddTextComponentString("House")
			end
		else
			AddTextComponentString(properties[i].name)
		end
		EndTextCommandSetBlipName(blip)
		blips[i] = blip
		if (properties[i].extra ~= "none") then
			local extrapos = split(properties[i].extra, ",")
			Citizen.InvokeNative(0x2CA429C029CCF247, Citizen.InvokeNative(0xB0F7F8663821D9C3, extrapos[1], extrapos[2], extrapos[3]), true)
		end
	end
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		for i = 1, #properties do
			local owner = properties[i].owner
			local ownerd = false
			if (owner ~= 0) then
				owned = true
			end
			local m = properties[i].marker
			local marker = split(m, ",")
			local c = properties[i].cars
			local cars = split(c,"|")
			for i = 1, #cars do
				cars[i] = split(cars[i],",")
			end
			if (GetDistanceBetweenCoords(pos, tonumber(marker[1]), tonumber(marker[2]), tonumber(marker[3])) < 25) then
				if (owned and owner == myid) then
					DrawMarker(1, tonumber(marker[1]), tonumber(marker[2]), tonumber(marker[3])-1.001, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 93, 180, 223, 155, 0, 0, 2, 0, 0, 0, 0)
				elseif (owner == 0) then
					DrawMarker(1, tonumber(marker[1]), tonumber(marker[2]), tonumber(marker[3])-1.001, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 255, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				else
					DrawMarker(1, tonumber(marker[1]), tonumber(marker[2]), tonumber(marker[3])-1.001, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 155, 0, 0, 2, 0, 0, 0, 0)
				end
				if (properties[i].extra ~= "none") then
					local extrapos = split(properties[i].extra, ",")
					DrawMarker(1, tonumber(extrapos[1]), tonumber(extrapos[2]), tonumber(extrapos[3])-1.001, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 93, 180, 223, 155, 0, 0, 2, 0, 0, 0, 0)
					if (GetDistanceBetweenCoords(pos, tonumber(extrapos[1]), tonumber(extrapos[2]), tonumber(extrapos[3])) < 1.001) then
						helptext("Go Outside ~INPUT_CONTEXT~")
						if (IsControlJustReleased(1, 86)) then
							DoScreenFadeOut(1000)
							Citizen.Wait(1000)
							TriggerEvent("sa:char:teleport", tonumber(marker[1]), tonumber(marker[2]), tonumber(marker[3]), tonumber(marker[4]))
							Citizen.Wait(1000)
							DoScreenFadeIn(1000)
						end
					end
				end
				if (GetDistanceBetweenCoords(pos, tonumber(marker[1]), tonumber(marker[2]), tonumber(marker[3])) < 1.001) then
					if (owner == myid) then
						subtitle("~y~" .. properties[i].address)
						helptext("Interact With Property ~INPUT_CONTEXT~")
						if (IsControlJustReleased(1, 86)) then
							local theproperty = properties[i]
							EnableGui(true, theproperty, true)
						end
					elseif (owner == 0) then
						subtitle("~y~" .. properties[i].address)
						helptext("Show Property Details ~INPUT_CONTEXT~")
						if (IsControlJustReleased(1, 86)) then
							local theproperty = properties[i]
							EnableGui(true, theproperty, false)
						end
					else
						subtitle("~y~" .. properties[i].address .. "\n~r~Owned")
					end
				end
			end
		end
	end
end)

RegisterNetEvent("sa:property:spawnVehicle")
AddEventHandler("sa:property:spawnVehicle", function(type, license_plate, color1, color2, x, y, z, h)
	local vehicle = GetHashKey(type)
	RequestModel(vehicle)
	while not HasModelLoaded(vehicle) do
		Citizen.Wait(1)
	end
	local spawned_car = CreateVehicle(vehicle, x, y, z, h, true, false)
	SetVehicleColours(spawned_car, color1, color2)
	SetVehicleExtraColours(spawned_car, color2, 0)
	SetVehicleNumberPlateText(spawned_car, license_plate)
	SetVehicleOnGroundProperly(spawned_car)
	SetEntityAsMissionEntity(spawned_car, true, true)
	SetVehicleHasBeenOwnedByPlayer(spawned_car, true)
	SetVehicleNeedsToBeHotwired(spawned_car, false)
	SetVehRadioStation(spawned_car, 'OFF')
	SetVehicleDirtLevel(spawned_car, 0)
	blip = AddBlipForEntity(spawned_car)
	SetBlipSprite(blip, 225)
	SetBlipColour(blip, 36)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Personal Vehicle")
	EndTextCommandSetBlipName(blip)
	SetModelAsNoLongerNeeded(vehicle)
	Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(spawned_car))
	if (last_car) then
		RemoveBlip(GetBlipFromEntity(last_car))
		RemoveBlip(last_blip)
		SetEntityAsNoLongerNeeded(last_car)
		SetVehicleAsNoLongerNeeded(last_car)
		SetEntityAsMissionEntity(last_car, true, true)
		DeleteVehicle(Citizen.PointerValueIntInitialized(last_car))
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(last_car))
	end
	last_car = spawned_car
	last_blip = blip
end)

RegisterNetEvent("sa:property:notify")
AddEventHandler("sa:property:notify", function(message)
	SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    SetNotificationMessage('CHAR_MP_BRUCIE', 'CHAR_MP_BRUCIE', true, 1, "Dynasty 8", "Agent")
    DrawNotification(true)
end)

function subtitle(message)
	Citizen.InvokeNative(0xB87A37EEB7FAA67D, "STRING")
	Citizen.InvokeNative(0x6C188BE134E074AA, message)
	Citizen.InvokeNative(0x9D77056A530643F6, 10, true)
end

function helptext(message)
	Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") -- BEGIN_TEXT_COMMAND_DISPLAY_HELP
	Citizen.InvokeNative(0x5F68520888E69014, message) -- _ADD_TEXT_COMPONENT_SCALEFORM
	Citizen.InvokeNative(0x238FFE5C7B0498A6, 0,false,true,-1) -- END_TEXT_COMMAND_DISPLAY_HELP
end

--[[ Functions ]]--
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
--[[ Functions ]]--
function split(source, delimiters)
	local elements = {}
	local pattern = '([^'..delimiters..']+)'
	string.gsub(source, pattern, function(value) elements[#elements + 1] =     value;  end);
	return elements
end

function convert(n)
    if n >= 2 ^ 31 then
        return n - 2 ^ 32
    end
    return n
end