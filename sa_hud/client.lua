zones = {["AIRP"] = "Los Santos International Airport ",["ALAMO"] = "Alamo Sea ",["ALTA"] = "Alta ",["ARMYB"] = "Fort Zancudo ",["BANHAMC"] = "Banham Canyon Dr ",["BANNING"] = "Banning ",["BEACH"] = "Vespucci Beach ",["BHAMCA"] = "Banham Canyon ",["BRADP"] = "Braddock Pass ",["BRADT"] = "Braddock Tunnel ",["BURTON"] = "Burton ",["CALAFB"] = "Calafia Bridge ",["CANNY"] = "Raton Canyon ",["CCREAK"] = "Cassidy Creek ",["CHAMH"] = "Chamberlain Hills ",["CHIL"] = "Vinewood Hills ",["CHU"] = "Chumash ",["CMSW"] = "Chiliad Mountain State Wilderness ",["CYPRE"] = "Cypress Flats ",["DAVIS"] = "Davis ",["DELBE"] = "Del Perro Beach ",["DELPE"] = "Del Perro ",["DELSOL"] = "La Puerta ",["DESRT"] = "Grand Senora Desert ",["DOWNT"] = "Downtown ",["DTVINE"] = "Downtown Vinewood ",["EAST_V"] = "East Vinewood ",["EBURO"] = "El Burro Heights ",["ELGORL"] = "El Gordo Lighthouse ",["ELYSIAN"] = "Elysian Island ",["GALFISH"] = "Galilee ",["GOLF"] = "GWC and Golfing Society ",	["GRAPES"] = "Grapeseed ",["GREATC"] = "Great Chaparral ",["HARMO"] = "Harmony ",["HAWICK"] = "Hawick ",["HORS"] = "Vinewood Racetrack ",["HUMLAB"] = "Humane Labs and Research ",["JAIL"] = "Bolingbroke Penitentiary ",["KOREAT"] = "Little Seoul ",["LACT"] = "Land Act Reservoir ",["LAGO"] = "Lago Zancudo ",["LDAM"] = "Land Act Dam ",["LEGSQU"] = "Legion Square ",["LMESA"] = "La Mesa ",["LOSPUER"] = "La Puerta ",["MIRR"] = "Mirror Park ",["MORN"] = "Morningwood ",["MOVIE"] = "Richards Majestic ",["MTCHIL"] = "Mount Chiliad ",["MTGORDO"] = "Mount Gordo ",["MTJOSE"] = "Mount Josiah ",["MURRI"] = "Murrieta Heights ",["NCHU"] = "North Chumash ",["NOOSE"] = "N.O.O.S.E ",["OCEANA"] = "Pacific Ocean ",["PALCOV"] = "Paleto Cove ",["PALETO"] = "Paleto Bay ",["PALFOR"] = "Paleto Forest ",["PALHIGH"] = "Palomino Highlands ",["PALMPOW"] = "Palmer-Taylor Power Station ",["PBLUFF"] = "Pacific Bluffs ",["PBOX"] = "Pillbox Hill ",["PROCOB"] = "Procopio Beach ",["RANCHO"] = "Rancho ",["RGLEN"] = "Richman Glen ",["RICHM"] = "Richman ",["ROCKF"] = "Rockford Hills ",["RTRAK"] = "Redwood Lights Track ",["SANAND"] = "San Andreas ",["SANCHIA"] = "San Chianski Mountain Range ",["SANDY"] = "Sandy Shores ",["SKID"] = "Mission Row ",["SLAB"] = "Stab City ",["STAD"] = "Maze Bank Arena ",["STRAW"] = "Strawberry ",["TATAMO"] = "Tataviam Mountains ",["TERMINA"] = "Terminal ",["TEXTI"] = "Textile City ",["TONGVAH"] = "Tongva Hills ",["TONGVAV"] = "Tongva Valley ",["VCANA"] = "Vespucci Canals ",["VESP"] = "Vespucci ",["VINE"] = "Vinewood ",["WINDF"] = "Ron Alternates Wind Farm ",["WVINE"] = "West Vinewood ",["ZANCUDO"] = "Zancudo River ",["ZP_ORT"] = "Port of South Los Santos ",["ZQ_UAR"] = "Davis Quartz",}

areas = {
	[-289320599] = ", Metro Los Santos",
	[2072609373] = ", Los Santos County",
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local vehicle = GetVehiclePedIsIn(ped, false)
		if not (IsEntityDead(ped)) then
			if (IsPedInAnyVehicle(ped) and Citizen.InvokeNative(0xAE31E7DF9B5B132E, vehicle)) then
				DisplayRadar(true)
				-- Lt.Caine's PLD Port to FiveM --
				local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, x, y, z,Citizen.PointerValueInt(),Citizen.PointerValueInt())
				local compass = getCardinalDirectionFromHeading(GetEntityHeading(ped))
				s1 = GetStreetNameFromHashKey(s1)
				s2 = GetStreetNameFromHashKey(s2)
				local street = ""
				if (s2 == "") then
					street = s1
				else
					street = s1 .. " / ~y~" .. s2
				end
				drawTxt(0.66, 1.43, 1.0, 1.0, 0.8, "~m~| ~w~" .. compass .. " ~m~|", 255, 255, 255, 255)
				drawTxt(0.693, 1.435, 1.0, 1.0, 0.35, street, 255, 255, 255, 255)
				drawTxt(0.693, 1.453, 1.0, 1.0, 0.35, getZone(GetNameOfZone(x, y, z)) .. getArea(GetHashOfMapAreaAtCoords(x, y, z)), 255, 255, 255, 255)
				-- Lt.Caine's PLD Port to FiveM --
				-- Speedometer --
				local speed = GetEntitySpeed(vehicle) * 2.236936
				drawTxt(0.628, 1.431, 1.0, 1.0, 0.43, "~w~" .. round(speed,0) .."mph", 255, 255, 255, 255)
				-- Speedometer --
				-- Vehicle Information --
				drawTxt(0.66, 1.30, 1.0, 1.0, 0.5, "Vehicle: " .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))), 255, 255, 255, 255)
				drawTxt(0.66, 1.325, 1.0, 1.0, 0.5, "Plate: " .. GetVehicleNumberPlateText(vehicle), 255, 255, 255, 255)
				-- Vehicle Information --
			else
				if (GetInteriorFromEntity(ped) == 0) then
					DisplayRadar(false)
				else
					DisplayRadar(true)
				end
				drawTxt(0.66, 1.45, 1.0, 1.0, 0.5, "x: " .. round(x,2) .. " y: " .. round(y,2) .. " z: " .. round(z,2) .. " heading: " .. round(GetEntityHeading(ped),2), 255, 255, 255, 255)
			end
		else
			drawTxt1(0.92,0.90, 1.0,1.0,1.0, "~r~You Died!", 255, 255, 255, 255)
			drawTxt(0.91,0.96,1.0,1.0,0.5,"Please wait for a medic to revive you!", 255,255,255,255)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait( 1 )
		for id = 0, 64 do
			if NetworkIsPlayerActive( id ) and GetPlayerPed(id) ~= GetPlayerPed(-1) then
				ped = GetPlayerPed( id )
				blip = GetBlipFromEntity( ped )
				local px,py,pz
				local pos
				local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
				if (IsPedInAnyVehicle(ped)) then
					px, py, pz = table.unpack(GetEntityCoords(GetVehiclePedIsIn(ped)))
					pz = pz + 1.0;
				else
					px, py, pz = table.unpack(GetEntityCoords(ped))
				end
				if (GetDistanceBetweenCoords(x,y,z,px,py,pz) < 20) then
					if (IsEntityDead(ped) and not NetworkIsPlayerTalking(id)) then
						DrawMarker(2, tonumber(px), tonumber(py), tonumber(pz)+1.0, 0, 0, 0, 0, 0, 0, 0.25,0.25,-0.25, 255, 0, 0, 155, 0, 1, 1, 0, 0, 0, 0)
					elseif (NetworkIsPlayerTalking(id)) then
						DrawMarker(2, tonumber(px), tonumber(py), tonumber(pz)+1.0, 0, 0, 0, 0, 0, 0, 0.25,0.25,-0.25, 0, 0, 255, 90, 0, 1, 1, 0, 0, 0, 0)
					else
						DrawMarker(2, tonumber(px), tonumber(py), tonumber(pz)+1.0, 0, 0, 0, 0, 0, 0, 0.25,0.25,-0.25, 256, 244, 66, 15, 0, 1, 1, 0, 0, 0, 0)
					end
				end
			end
		end
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawTxt1(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function getCardinalDirectionFromHeading(heading)
    if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
        return "N"
    elseif (heading >= 45 and heading < 135) then
        return "W"
    elseif (heading >=135 and heading < 225) then
        return "S"
    elseif (heading >= 225 and heading < 315) then
        return "E"
    end
end

function getArea(areaHash)
	if (areas[areaHash]) then
		return areas[areaHash]
	else
		return areaHash
	end
end
function getZone(zoneHash)
	if (zones[zoneHash]) then
		return zones[zoneHash]
	else
		return zoneHash
	end
end