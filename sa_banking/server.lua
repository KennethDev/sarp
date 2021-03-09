local cash = {}
local bank = {}
local dirty = {}

AddEventHandler("sa:banking:setBalance", function(id, cashx, bankx)
	cash[id] = tonumber(round(cashx,0))
	bank[id] = tonumber(round(bankx,0))
	dirty[id] = false
	TriggerEvent("sa:base:updateBalance", id, cash[id], bank[id])
	TriggerClientEvent("sa:banking:balance", id, cash[id], bank[id])
end)

RegisterServerEvent("sa:banking:requestBalance")
AddEventHandler("sa:banking:requestBalance", function()
	TriggerEvent("sa:base:getBalance", source, function(cash, bank)
		TriggerEvent("sa:banking:setBalance", source, tonumber(cash), tonumber(bank))
	end)
end)

RegisterServerEvent("sa:banking:deposit")
AddEventHandler("sa:banking:deposit", function(amount)
	if (dirty[source] == true) then
		ShowNotification1(source, "~r~Error: ~w~You just robbed someone. You should wait at least ~r~five minutes ~w~before depositing money.")
	else
		if (amount > cash[source]) then
			ShowNotification(source, "~r~Error: ~w~Insufficient Funds")
		elseif (amount < 1) then
			ShowNotification(source, "~r~Error: ~w~You must deposit at least ~g~$1")
		elseif not (isint(amount)) then
			ShowNotification(source, "~r~Error: ~w~You may only deposit whole numbers.")
		else
			TriggerEvent("sa:banking:setBalance", source, cash[source]-amount, bank[source]+amount)
			ShowNotification(source, "~g~Success: ~w~Deposit Complete\n~w~Cash: ~g~${CASH}\n~w~Bank: ~g~${BANK}")
		end
	end
end)

RegisterServerEvent("sa:banking:withdraw")
AddEventHandler("sa:banking:withdraw", function(amount)
	if (amount > bank[source]) then
		ShowNotification(source, "~r~Error: ~w~Insufficient Funds")
	elseif (amount < 1) then
		ShowNotification(source, "~r~Error: ~w~You must withdraw at least ~g~$1")
	elseif not (isint(amount)) then
		ShowNotification(source, "~r~Error: ~w~You may only withdraw whole numbers.")
	else
		TriggerEvent("sa:banking:setBalance", source, cash[source]+amount, bank[source]-amount)
		ShowNotification(source, "~g~Success: ~w~Withdrawal Complete\n~w~Cash: ~g~${CASH}\n~w~Bank: ~g~${BANK}")
	end
end)

RegisterServerEvent("sa:banking:charge")
AddEventHandler("sa:banking:charge", function(source, company, amount)
	TriggerEvent("sa:banking:setBalance", source, cash[source], bank[source]-amount)
	ShowNotification(source, "~g~" .. company .. " ~w~has charged you ~g~$" .. amount .. "\n~w~Cash: ~g~${CASH}\n~w~Bank: ~g~${BANK}")
end)

RegisterServerEvent("sa:banking:chargeme")
AddEventHandler("sa:banking:chargeme", function(company, amount)
	TriggerEvent("sa:banking:setBalance", source, cash[source], bank[source]-amount)
	ShowNotification(source, "~g~" .. company .. " ~w~has charged you ~g~$" .. amount .. "\n~w~Cash: ~g~${CASH}\n~w~Bank: ~g~${BANK}")
end)

RegisterServerEvent("sa:banking:recieve")
AddEventHandler("sa:banking:recieve", function(source, company, amount)
	TriggerEvent("sa:banking:setBalance", source, cash[source], bank[source]+amount)
	ShowNotification(source, "~g~" .. company .. " ~w~has sent you ~g~$" .. amount .. "\n~w~Cash: ~g~${CASH}\n~w~Bank: ~g~${BANK}")
end)

RegisterServerEvent("sa:banking:dirtyCash")
AddEventHandler("sa:banking:dirtyCash", function(source, company, amount)
	TriggerEvent("sa:banking:setBalance", source, cash[source]+amount, bank[source])
	ShowNotification1(source, "You stole ~g~$" .. amount .. " ~w~from ~r~" .. company .."~w~.")
	dirty[source] = true
	SetTimeout(5*60000, function()
		dirty[source] = false
	end)
end)

--[[ Constants ]]--
SCRIPT_NAME = "BANKING"
SCRIPT_PREFIX = "[BANKING] "

--[[ Command Registration ]]--
function registerCommands()
	print(SCRIPT_PREFIX .. "Registering Commands")
	TriggerEvent("sa:base:registerCommand", "bank", "Check how much money you have in the bank.", 0, function(source, args, player, character)
		TriggerEvent("sa:base:getPlayer", source, function(player, character)
			ShowNotification(source, "Your current checking account balance is ~g~$" .. character:getBankBalance())
		end)
	end)
	TriggerEvent("sa:base:registerCommand", "cash", "Check how much money you have in cash.", 0, function(source, args, player, character)
		TriggerEvent("sa:base:getPlayer", source, function(player, character)
			ShowNotification(source, "Your current cash balance is ~g~$" .. character:getCashBalance())
		end)
	end)
	TriggerEvent("sa:base:registerCommand", "givemoney", "Give a player money", 3, function(source, args, player, character)
		TriggerEvent("sa:base:getPlayer", source, function(player, character)
			TriggerEvent("sa:banking:recieve", tonumber(args[1]), "An Admin", tonumber(args[2]))
			ShowNotification(source, "Money added.")
		end)
	end)
	print(SCRIPT_PREFIX .. "Registered Commands")
end

registerCommands()

AddEventHandler("sa:base:requestCommands", function()
	SetTimeout(25, function()
		registerCommands()
	end)
end)

--[[ Useful Functions ]]--
function MessageClient(id, message)
	TriggerClientEvent("chatMessage", id, "", {0,0,0}, message)
end

function ShowNotification(id, message)
	TriggerClientEvent("sa:banking:notify", tonumber(id), message)
end

function ShowNotification1(id, message)
	TriggerClientEvent("sa:banking:notify1", tonumber(id), message)
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", tonumber(num)))
end

function isint(n)
	return n == math.floor(n)
end

--[[ Rescue Mode ]]--
AddEventHandler("rconCommand", function(name, args)
	if name:lower() == "escape" then
		TriggerClientEvent("sa:banking:escape", tonumber(args[1]))
		CancelEvent()
	end
end)

--[[ Wellfare ]]--
function welfare()
	for k,v in ipairs(bank) do
		TriggerEvent("sa:banking:recieve", k, "Government Welfare Service", 500)
	end
	SetTimeout(5*60000, function()
		welfare()
	end)
end
SetTimeout(500, welfare)