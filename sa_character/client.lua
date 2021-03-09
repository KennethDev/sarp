Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			Citizen.Wait(1000)
			TriggerServerEvent("sa:char:joined")
			return
		end
	end
end)

RegisterNetEvent("sa:char:create")
AddEventHandler("sa:char:create", function()
	EnableGui(true)
end)

RegisterNetEvent("sa:char:restoreOutfit")
AddEventHandler("sa:char:restoreOutfit", function(gender, outfit)
	Citizen.CreateThread(function()
		Citizen.Wait(250)
		local model = ""
		if (gender == 0) then
			model = "mp_m_freemode_01"
		else
			model = "mp_f_freemode_01"
		end
		local hash = GetHashKey(model)
		RequestModel(hash)
		while not (HasModelLoaded(hash)) do
			Citizen.Wait(0)
			RequestModel(hash)
		end
		SetPlayerModel(PlayerId(), hash)
		SetModelAsNoLongerNeeded(hash)
		Citizen.Wait(10)
		SetPedDefaultComponentVariation(GetPlayerPed(-1))
		SetPedComponentVariation(GetPlayerPed(-1), 0, tonumber(outfit.face), 0, 2) -- Face
		SetPedComponentVariation(GetPlayerPed(-1), 2, tonumber(outfit.hair), tonumber(outfit.haircolor), 2) -- Hair
		SetPedComponentVariation(GetPlayerPed(-1), 3, tonumber(outfit.torso), tonumber(outfit.torsotexture), 2) -- Torso
		SetPedComponentVariation(GetPlayerPed(-1), 4, tonumber(outfit.pants), tonumber(outfit.pantscolor), 2) -- Pants
		SetPedComponentVariation(GetPlayerPed(-1), 6, tonumber(outfit.shoes), tonumber(outfit.shoescolor), 2) -- Shoes
		SetPedComponentVariation(GetPlayerPed(-1), 8, tonumber(outfit.undershirt), 0, 2) -- Undershirt
		SetPedComponentVariation(GetPlayerPed(-1), 11, tonumber(outfit.torsoextra), tonumber(outfit.torsoextratexture), 2) -- Torso Extras
		TriggerServerEvent("sa:char:loadCallback1")
	end)
end)

RegisterNetEvent("sa:char:teleport")
AddEventHandler("sa:char:teleport", function(x, y, z, h)
	local ped = GetPlayerPed(-1)
	SetEntityCoords(ped, x, y, z)
	SetEntityHeading(ped, h)
end)

RegisterNetEvent("sa:char:getOutfit")
AddEventHandler("sa:char:getOutfit", function()
	local outfit = {}
	local ped = GetPlayerPed(-1)
	for i = 0, 11 do
		if (i == 1) then
			outfit.face = GetPedDrawableVariation(ped, i)
		elseif (i == 2) then
			outfit.hair = GetPedDrawableVariation(ped, i)
			outfit.haircolor = GetPedTextureVariation(ped, i)
		elseif (i == 3) then
			outfit.torso = GetPedDrawableVariation(ped, i)
			outfit.torsotexture = GetPedTextureVariation(ped, i)
		elseif (i == 4) then
			outfit.pants = GetPedDrawableVariation(ped, i)
			outfit.pantscolor = GetPedTextureVariation(ped, i)
		elseif (i == 6) then
			outfit.shoes = GetPedDrawableVariation(ped, i)
			outfit.shoescolor = GetPedTextureVariation(ped, i)
		elseif (i == 8) then
			outfit.undershirt = GetPedDrawableVariation(ped, i)
		elseif (i == 11) then
			outfit.torsoextra = GetPedDrawableVariation(ped, i)
			outfit.torsoextratexture = GetPedTextureVariation(ped, i)
		end
	end
	TriggerServerEvent("sa:base:updateOutfit", outfit)
end)