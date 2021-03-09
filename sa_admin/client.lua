moneyShown = false

Citizen.CreateThread(function()
	AddTextEntry("FE_THDR_GTAO", "~y~High Life ~r~Roleplay")
    AddTextEntry("PM_SCR_MAP", "State of San Andreas Map")
    AddTextEntry("PM_SCR_GAM", "Leave/Quit")
    AddTextEntry("PM_SCR_SET", "Settings")
    AddTextEntry("PM_SCR_RPL", "Rockstar Editor")
    AddTextEntry("PM_PANE_LEAVE", "Back to FiveM Server List")
    AddTextEntry("PM_PANE_QUIT", "Exit to Windows")
	for i = 1, 11 do
		Citizen.InvokeNative(0xDC0F817884CDD856, i, false) -- Disable all dispatching
	end
	Citizen.InvokeNative(0xDC0F817884CDD856, 12, true) -- Enable army
	Citizen.InvokeNative(0x1098355A16064BB3, false) -- disable mobile radio
	while true do
		Citizen.Wait(0)
		SetCanAttackFriendly(GetPlayerPed(-1), true, false)
		NetworkSetFriendlyFireOption(true)
		SetParkedVehicleDensityMultiplierThisFrame(0)
	end
end)

RegisterNetEvent("sa:admin:revive")
AddEventHandler("sa:admin:revive", function()
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		if not (IsEntityDead(ped)) then
			return
		end
		local x,y,z = table.unpack(GetEntityCoords(ped))
		ResurrectPed(ped)
		ReviveInjuredPed(ped)
		SetEntityCoords(ped, x,y,z+.15)
		ClearPedBloodDamage(ped)
		ClearPedLastDamageBone(ped)
		ClearPedWetness(ped)
	end)
end)

RegisterNetEvent("sa:admin:freeze")
AddEventHandler("sa:admin:freeze", function(state)
	Citizen.CreateThread(function()
		Citizen.Wait(500)
		local ped = GetPlayerPed(-1)
		local pla = PlayerId()
		FreezeEntityPosition(ped, state)
		SetPlayerInvincible(pla, state)
	end)
end)

RegisterNetEvent("sa:admin:getSkin")
AddEventHandler("sa:admin:getSkin", function()
	for i = 0, 11 do
		if (i == 0 or i == 2 or i == 3 or i == 4 or i == 6 or i == 8 or i == 11) then
			TriggerEvent("chatMessage", "", {0,0,0}, i .. " | " .. GetPedDrawableVariation(GetPlayerPed(-1), i) .. " | " .. GetPedTextureVariation(GetPlayerPed(-1), i))
		end
	end
end)

RegisterNetEvent("sa:admin:kar")
AddEventHandler("sa:admin:kar", function(kar)
	local myPed = GetPlayerPed(-1)
    local player = PlayerId()
    local vehicle = GetHashKey(kar)
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
        Wait(1)
    end
    local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
    local spawned_car = CreateVehicle(vehicle, coords, GetEntityHeading(myPed), true, false)
    SetVehicleOnGroundProperly(spawned_car)
    SetModelAsNoLongerNeeded(vehicle)
    Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(spawned_car))
end)

function showMoney()
    Citizen.InvokeNative(0xC2D15BEF167E27BC)
    Citizen.InvokeNative(0xDD21B55DF695CD0A)
    Citizen.Trace("Showing money.")
end

function hideMoney()
    Citizen.InvokeNative(0x95CF81BD06EE1887)
    Citizen.InvokeNative(0xC7C6789AA1CFEDD0)
    Citizen.Trace("Hiding money.")
end