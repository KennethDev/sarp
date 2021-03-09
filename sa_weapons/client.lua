weapons = {
	"WEAPON_KNIFE", "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT", "WEAPON_GOLFCLUB",
	"WEAPON_CROWBAR", "WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_PISTOL50",
	"WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_ASSAULTSMG", "WEAPON_ASSAULTRIFLE",
	"WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE", "WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_PUMPSHOTGUN",
	"WEAPON_SAWNOFFSHOTGUN", "WEAPON_ASSAULTSHOTGUN", "WEAPON_BULLPUPSHOTGUN", "WEAPON_STUNGUN", "WEAPON_SNIPERRIFLE",
	"WEAPON_HEAVYSNIPER", "WEAPON_GRENADELAUNCHER", "WEAPON_GRENADELAUNCHER_SMOKE", "WEAPON_RPG", "WEAPON_MINIGUN",
	"WEAPON_GRENADE", "WEAPON_STICKYBOMB", "WEAPON_SMOKEGRENADE", "WEAPON_BZGAS", "WEAPON_MOLOTOV",
	"WEAPON_FIREEXTINGUISHER", "WEAPON_PETROLCAN", "WEAPON_FLARE", "WEAPON_SNSPISTOL", "WEAPON_SPECIALCARBINE",
	"WEAPON_HEAVYPISTOL", "WEAPON_BULLPUPRIFLE", "WEAPON_HOMINGLAUNCHER", "WEAPON_PROXMINE", "WEAPON_SNOWBALL",
	"WEAPON_VINTAGEPISTOL", "WEAPON_DAGGER", "WEAPON_FIREWORK", "WEAPON_MUSKET", "WEAPON_MARKSMANRIFLE",
	"WEAPON_HEAVYSHOTGUN", "WEAPON_GUSENBERG", "WEAPON_HATCHET", "WEAPON_RAILGUN", "WEAPON_COMBATPDW",
	"WEAPON_KNUCKLE", "WEAPON_MARKSMANPISTOL", "WEAPON_FLASHLIGHT", "WEAPON_MACHETE", "WEAPON_MACHINEPISTOL",
	"WEAPON_SWITCHBLADE", "WEAPON_REVOLVER", "WEAPON_COMPACTRIFLE", "WEAPON_DBSHOTGUN", "WEAPON_FLAREGUN",
	"WEAPON_AUTOSHOTGUN", "WEAPON_BATTLEAXE", "WEAPON_COMPACTLAUNCHER", "WEAPON_MINISMG", "WEAPON_PIPEBOMB",
	"WEAPON_POOLCUE", "WEAPON_SWEEPER", "WEAPON_WRENCH"
}

stores = {
	{x = 842.42, y = -1033.28, z = 28.19}
}

Citizen.CreateThread(function()
	Citizen.Wait(5000)
	TriggerServerEvent("sa:weapons:getWeapon", PlayerId())
	for i = 1, #stores do
        blip = AddBlipForCoord(stores[i].x, stores[i].y, stores[i].z)
        SetBlipSprite(blip, 110)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Ammunation")
        EndTextCommandSetBlipName(blip)
	end
	while true do
		Citizen.Wait(60000)
		local ped = GetPlayerPed(-1)
		local weaponsa = ""
		local weaponsaize = 1
		for i = 1, #weapons do
			if (HasPedGotWeapon(ped, GetHashKey(weapons[i]), false)) then
				if (weaponsaize == 1) then
					weaponsa = weapons[i] .. "." .. GetAmmoInPedWeapon(ped,GetHashKey(weapons[i])) 
				else
					weaponsa = weaponsa .. "," .. weapons[i] .. "." .. GetAmmoInPedWeapon(ped,GetHashKey(weapons[i])) 
				end
			end
			weaponsaize = weaponsaize + 1
		end
		TriggerServerEvent("sa:weapons:saveWeapons", weaponsa)
		notify("Weapons saved")
	end
end)

Citizen.CreateThread(function()
	for i = 1, #stores do
        blip = AddBlipForCoord(stores[i].x, stores[i].y, stores[i].z)
        SetBlipSprite(blip, 110)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Ammunation")
        EndTextCommandSetBlipName(blip)
	end
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		for i = 1, #stores do
			if (GetDistanceBetweenCoords(pos, stores[i].x, stores[i].y, stores[i].z) < 10) then
                DrawMarker(1, stores[i].x, stores[i].y, stores[i].z-1.001, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 255, 0, 155, 0, 0, 2, 0, 0, 0, 0)
                if (GetDistanceBetweenCoords(pos, stores[i].x, stores[i].y, stores[i].z) < 1.0001) then
                    helptext("Buy Weapons ~INPUT_CONTEXT~")
                    if IsControlJustReleased(1, 86) then
                        EnableGui(true)
                    end
                end
            end
        end
	end
end)

RegisterNetEvent("sa:weapons:giveWeapons")
AddEventHandler("sa:weapons:giveWeapons", function(newWeapons)
	local ped = GetPlayerPed(-1)
	RemoveAllPedWeapons(ped, false)
	local weas = split(newWeapons, ",")
	for i = 1, #weas do
		local weapon = split(weas[i], ".")
		GiveWeaponToPed(ped, GetHashKey(weapon[1]), tonumber(weapon[2]), false, false)
	end
end)

RegisterNetEvent("sa:weapons:giveWeapon")
AddEventHandler("sa:weapons:giveWeapon", function(weapon, ammo)
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weapon), ammo)
end)

RegisterNetEvent("sa:weapons:bought")
AddEventHandler("sa:weapons:bought", function(weapon, ammo, cost)
	local ped = GetPlayerPed(-1)
	if (HasPedGotWeapon(ped, GetHashKey(weapon), false)) then
		notify("You already have that weapon!")
	else
		TriggerServerEvent("sa:banking:chargeme", "Ammunation", cost)
		GiveWeaponToPed(ped, GetHashKey(weapon), ammo, false, false)
		Citizen.InvokeNative(0x67C540AA08E4A6F5, -1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET")
	end
end)

RegisterNetEvent("sa:weapons:escape")
AddEventHandler("sa:weapons:escape", function()
    EnableGui(false)
end)

RegisterNetEvent("sa:weapons:remove")
AddEventHandler("sa:weapons:remove", function()
    RemoveAllPedWeapons(GetPlayerPed(-1), false)
end)

--[[ Functions ]]--
function split(source, delimiters)
	local elements = {}
	local pattern = '([^'..delimiters..']+)'
	string.gsub(source, pattern, function(value) elements[#elements + 1] =     value;  end);
	return elements
end

function notify(string)
	SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true)
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function subtitle(message)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D, "STRING")
    Citizen.InvokeNative(0x6C188BE134E074AA, message)
    Citizen.InvokeNative(0x9D77056A530643F6, 10, true)
end

function helptext(message)
    Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") -- BEGIN_TEXT_COMMAND_DISPLAY_HELP
    Citizen.InvokeNative(0x5F68520888E69014, message) -- _ADD_TEXT_COMPONENT_SCALEFORM
    Citizen.InvokeNative(0x238FFE5C7B0498A6, 0,0,1,-1) -- END_TEXT_COMMAND_DISPLAY_HELP
end