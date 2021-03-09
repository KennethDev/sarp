local guiEnabled = false


RegisterNUICallback('deposit', function(data, cb)
	if (tonumber(data.amount) < 0) then
		TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^1Error: ^7Less than zero")
	else
		TriggerServerEvent('sa:banking:deposit', tonumber(data.amount))
		cb('ok')
	end
end)

RegisterNUICallback('withdraw', function(data, cb)
	if (tonumber(data.amount) < 0) then
		TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^1Error: ^7Less than zero")
	else
		TriggerServerEvent('sa:banking:withdraw', tonumber(data.amount))
		cb('ok')
	end
end)

RegisterNUICallback('transfer', function(data, cb)
	TriggerEvent("sa:banking:notify", "~r~Error: ~w~Direct transfers are coming soon!")
end)

RegisterNUICallback('escape', function(data, cb)
	EnableGui(false)
	cb('ok')
end)

-- Util function stuff
function stringsplit(self, delimiter)
	local a = self:Split(delimiter)
	local t = {}

	for i = 0, #a - 1 do
		table.insert(t, a[i])
	end

	return t
end

function EnableGui(enable)
	SetNuiFocus(enable)
	guiEnabled = enable

	SendNUIMessage({
		type = "enableatm",
		enable = enable
	})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if guiEnabled then
			DisableControlAction(1, 18, true)
			DisableControlAction(1, 24, true)
			DisableControlAction(1, 69, true)
			DisableControlAction(1, 92, true)
			DisableControlAction(1, 106, true)
			DisableControlAction(1, 122, true)
			DisableControlAction(1, 135, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 144, true)
			DisableControlAction(1, 176, true)
			DisableControlAction(1, 223, true)
			DisableControlAction(1, 229, true)
			DisableControlAction(1, 237, true)
			DisableControlAction(1, 257, true)
			DisableControlAction(1, 329, true)
		
			DisableControlAction(1, 14, true)
			DisableControlAction(1, 16, true)
			DisableControlAction(1, 41, true)
			DisableControlAction(1, 43, true)
			DisableControlAction(1, 81, true)
			DisableControlAction(1, 97, true)
			DisableControlAction(1, 180, true)
			DisableControlAction(1, 198, true)
			DisableControlAction(1, 39, true)
			DisableControlAction(1, 50, true)
			
			DisableControlAction(1, 22, true)
			DisableControlAction(1, 55, true)
			DisableControlAction(1, 76, true)
			DisableControlAction(1, 102, true)
			DisableControlAction(1, 114, true)
			DisableControlAction(1, 143, true)
			DisableControlAction(1, 179, true)
			DisableControlAction(1, 193, true)
			DisableControlAction(1, 203, true)
			DisableControlAction(1, 216, true)
			DisableControlAction(1, 255, true)
			DisableControlAction(1, 298, true)
			DisableControlAction(1, 321, true)
			DisableControlAction(1, 328, true)
			DisableControlAction(1, 331, true)
			DisableControlAction(0, 1, active) -- LookLeftRight
		    DisableControlAction(0, 2, active) -- LookUpDown
		    DisableControlAction(0, 24, active) -- Attack
		    DisablePlayerFiring(ply, true) -- Disable weapon firing
		    DisableControlAction(0, 142, active) -- MeleeAttackAlternate
		    DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
			if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
				SendNUIMessage({
					type = "click"
				})
			end
		end
	end
end)

EnableGui(false)