positions = {}
timeleft = 0

zblip = nil

RegisterNetEvent("sa:rob:sendPositions")
AddEventHandler("sa:rob:sendPositions", function(spots)
	if (#positions > 0) then
		for i = 1, #positions do
			RemoveBlip(positions[i].blip)
			positions[i].blip = nil
		end
	end
	positions = spots
	for i = 1, #positions do
		if (positions[i].robbed == false) then
			blip = AddBlipForCoord(positions[i].x, positions[i].y, positions[i].z)
	        SetBlipSprite(blip, tonumber(positions[i].icon))
	        SetBlipColour(blip, 2)
	        SetBlipAsShortRange(blip, true)
	        BeginTextCommandSetBlipName("STRING")
	        AddTextComponentString(positions[i].name)
	        EndTextCommandSetBlipName(blip)
	        positions[i].blip = blip
		else
			blip = AddBlipForCoord(positions[i].x, positions[i].y, positions[i].z)
	        SetBlipSprite(blip, positions[i].icon)
	        SetBlipAsShortRange(blip, true)
	        BeginTextCommandSetBlipName("STRING")
	        AddTextComponentString(positions[i].name)
	        EndTextCommandSetBlipName(blip)
	        positions[i].blip = blip
		end
	end
	Citizen.Trace("Recieved updated positions and states.")
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if (#positions < 1) then
			Citizen.Wait(1)
		else
			local pos = GetEntityCoords(GetPlayerPed(-1))
			for i = 1, #positions do
				if not (positions[i].robbing or positions[i].robbed) then
					if (GetDistanceBetweenCoords(pos, positions[i].x, positions[i].y, positions[i].z) < 20) then
						DrawMarker(1, positions[i].x, positions[i].y, positions[i].z-1.001, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 155, 0, 0, 2, 0, 0, 0, 0)
						if (GetDistanceBetweenCoords(pos, positions[i].x, positions[i].y, positions[i].z) < 1.0001) then
							helptext("Rob " .. positions[i].name .. " ~INPUT_CONTEXT~")
							if (IsControlJustReleased(1, 51)) then
								TriggerServerEvent("sa:rob:start", positions[i].id)
							end
						end
					end
				end
			end
		end
	end
end)

RegisterNetEvent("sa:rob:approve")
AddEventHandler("sa:rob:approve", function(id)
	timeleft = positions[id].time
	Citizen.CreateThread(function()
		zblip = AddBlipForRadius(positions[id].x, positions[id].y, positions[id].z, positions[id].maxdist)
		SetBlipSprite(zblip, 4)
		while true do
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), positions[id].x, positions[id].y, positions[id].z) > positions[id].maxdist or IsEntityDead(GetPlayerPed(-1)) then
				timeleft = 0
				TriggerServerEvent("sa:rob:cancel1", id)
				RemoveBlip(zblip)
				positions[id].robbed = false
				positions[id].robbing = false
				positions[id].robber = 0
				zblip = nil
				local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
				while not HasScaleformMovieLoaded(scaleform) do
					Citizen.Wait(1)
				end
				PushScaleformMovieFunction(scaleform, "SHOW_MISSION_PASSED_MESSAGE")
				BeginTextComponent("STRING")
				AddTextComponentString("~y~Robbery Cancelled")
				EndTextComponent()
				PopScaleformMovieFunctionVoid()
				RemoveBlip(zblip)
				zblip = nil
				Citizen.Wait(250)
				local seconds = 100
				while seconds > 0 do
			    	DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
					Citizen.Wait(1)
					seconds = seconds - 1
			    end
			end
			timeleft = timeleft - 1
			if (timeleft < 0) then
				TriggerServerEvent("sa:rob:finish", id)
				timeleft = 0
				break
			end
			Citizen.Wait(1000)
		end
		Citizen.Trace("Robbery Completed")
	end)
end)

RegisterNetEvent("sa:rob:complete")
AddEventHandler("sa:rob:complete", function()
	Citizen.CreateThread(function()
		local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(1)
		end
		PushScaleformMovieFunction(scaleform, "SHOW_MISSION_PASSED_MESSAGE")
		BeginTextComponent("STRING")
		AddTextComponentString("~y~Robbery Completed")
		EndTextComponent()
		PopScaleformMovieFunctionVoid()
		RemoveBlip(zblip)
		zblip = nil
		Citizen.Wait(250)
		local seconds = 500
		while seconds > 0 do
	    	DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			Citizen.Wait(1)
			seconds = seconds - 1
	    end
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if (timeleft ~= 0) then
			local time = round(timeleft/60,1)
			if (time > 1) then
				time = time .. " minutes"
			else
				time = timeleft .. " seconds"
			end
			drawTxt(0.66, 1.45, 1.0, 1.0, 0.5, "Robbery: ~r~" .. time .. " ~w~remaining. Stay in the area.", 255, 255, 255, 255)
		end
	end
end)

function helptext(message)
    Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") -- BEGIN_TEXT_COMMAND_DISPLAY_HELP
    Citizen.InvokeNative(0x5F68520888E69014, message) -- _ADD_TEXT_COMPONENT_SCALEFORM
    Citizen.InvokeNative(0x238FFE5C7B0498A6, 0,0,1,-1) -- END_TEXT_COMMAND_DISPLAY_HELP
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

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

function notify(string)
	SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true)
end