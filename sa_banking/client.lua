local bank = 0
local cash = 0

local atms = {
    {x = -95.02, y = 6456.69, z = 31.46},
    {x = -96.98, y = 6455.04, z = 31.46},
    {x = 174.40, y = 6637.71, z = 31.57},
    {x = 155.37, y = 6642.40, z = 31.62},
    {x = 1735.40, y = 6410.97, z = 35.04},
    {x = -283.45, y = 6225.91, z = 31.49},
    {x = -387.10, y = 6045.79, z = 31.50},
    {x = -133.72, y = 6366.06, z = 31.48},
    {x = 1702.76, y = 4933.09, z = 42.06},
    {x = 1687.75, y = 4815.86, z = 42.01},
    {x = 1967.97, y = 3743.95, z = 32.34},
    {x = 540.30, y = 2670.58, z = 42.16},
    {x = 1172.39, y = 2702.12, z = 38.17},
    {x = 1171.37, y = 2702.08, z = 38.18},
    {x = -1091.17, y = 2708.14, z = 18.97},
    {x = -3240.68, y = 996.81, z = 12.52},
    {x = -3240.78, y = 1008.73, z = 12.83},
    {x = -3144.09, y = 1127.36, z = 20.86},
    {x = -3044.06, y = 595.08, z = 7.74},
    {x = -3041.22, y = 593.05, z = 7.91},
    {x = -2975.48, y = 380.27, z = 15.00},
    {x = -2956.81, y = 488.28, z = 15.47},
    {x = -2958.83, y = 488.38, z = 15.47},
    {x = -2294.78, y = 358.40, z = 174.60}, -- Kortz
    {x = -2294.05, y = 356.72, z = 174.60}, -- Kortz
    {x = -2293.27, y = 354.95, z = 174.60}, -- Kortz
    {x = -1826.75, y = 785.27, z = 138.29},
    {x = 2559.28, y = 350.83, z = 108.62},
    {x = 2557.86, y = 389.65, z = 108.62},
    {x = 2565.21, y = 2584.91, z = 38.08},
    --[[ Mirror Park ]]--
    {x = 1077.80, y = -775.95, z = 58.22},
    {x = 1138.75, y = -469.10, z = 66.73},
    {x = 1166.80, y = -456.65, z = 66.79},
    {x = 1153.92, y = -326.79, z = 69.21}
}

Citizen.CreateThread(function()
    Citizen.InvokeNative(0x170F541E1CADD1DE, false)
    Citizen.InvokeNative(0x0772DF77852C2E30, 1, 1)
    TriggerServerEvent("sa:banking:requestBalance")
    for i = 1, #atms do
        blip = AddBlipForCoord(atms[i].x, atms[i].y, atms[i].z)
        SetBlipSprite(blip, 434)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("ATM")
        EndTextCommandSetBlipName(blip)
    end
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		--drawMoney(0.51, 0.50, 1.0, 1.0, 0.5, "cash $" .. round(cash,0), 0, 255, 0, 255)
		--drawMoney(0.51, 0.53, 1.0, 1.0, 0.5, "bank $" .. round(bank,0), 0, 255, 0, 255)
        for i = 1, #atms do
            if (GetDistanceBetweenCoords(pos, atms[i].x, atms[i].y, atms[i].z) < 10) then
                DrawMarker(1, atms[i].x, atms[i].y, atms[i].z-1.001, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 255, 0, 155, 0, 0, 2, 0, 0, 0, 0)
                if (GetDistanceBetweenCoords(pos, atms[i].x, atms[i].y, atms[i].z) < 1.0001) then
                    helptext("Use ATM ~INPUT_CONTEXT~")
                    if IsControlJustReleased(1, 86) then
                        EnableGui(true)
                    end
                end
            end
        end
	end
end)

RegisterNetEvent("sa:banking:escape")
AddEventHandler("sa:banking:escape", function()
    EnableGui(false)
end)

RegisterNetEvent("sa:banking:notify")
AddEventHandler("sa:banking:notify", function(message)
    local text = string.gsub(message, "%{BANK%}", tostring(bank))
    text = string.gsub(text, "%{CASH%}", tostring(cash))
	SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage('CHAR_BANK_FLEECA', 'CHAR_BANK_FLEECA', true, 9, "Fleeca Bank", "Financial Division")
    DrawNotification(true)
end)

RegisterNetEvent("sa:banking:notify1")
AddEventHandler("sa:banking:notify1", function(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(true)
end)

RegisterNetEvent("sa:banking:balance")
AddEventHandler("sa:banking:balance", function(cashb, bankb)
    Citizen.InvokeNative(0x170F541E1CADD1DE, true)
    local ncash = cashb - cash
    local nbank = bankb - bank
    Citizen.InvokeNative(0x0772DF77852C2E30, ncash, nbank)
    cash = round(cashb,0)
    bank = round(bankb,0)
    Citizen.InvokeNative(0x67C540AA08E4A6F5, -1, "COLLECTED", "HUD_AWARDS")
end)

function drawMoney(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(7)
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

RegisterNetEvent("sa:property:escape")
AddEventHandler("sa:property:escape", function()
    EnableGui(false)
end)