spots = {
	{
		id = 0,
		name = "24/7",
		icon = 52,
		x = 1159.95,
		y = -314.27,
		z = 69.21,
		robbed = false,
		robbing = false,
		maxdist = 12.499999,
		time = 1*60,
		robberyValid = false,
		blip = nil,
		take = 6000,
		robber = 0,
		cancelled = false,
	}
}

AddEventHandler("sa:char:loadCallback", function(source)
	TriggerClientEvent("sa:rob:sendPositions", source, spots)
end)

AddEventHandler("sa:rob:force", function(source)
	TriggerClientEvent("sa:rob:sendPositions", source, spots)
end)

RegisterServerEvent("sa:rob:start")
AddEventHandler("sa:rob:start", function(i)
	for id = 1, #spots do
		if (spots[id].id == i) then
			if (spots[id].robbed) then
				TriggerClientEvent("sa:rob:cancel", source)
			else
				spots[id].robbing = true
				spots[id].robber = source
				TriggerClientEvent("sa:rob:sendPositions", source, spots)
				TriggerClientEvent("sa:rob:approve", source, id)
				SetTimeout(spots[id].time*1000, function()
					if not (spots[id].cancelled) then
						spots[id].robberyValid = true
						print("Client can now claim the loot for a robbery.")
					end
				end)
			end
		end
	end
end)

RegisterServerEvent("sa:rob:cancel1")
AddEventHandler("sa:rob:cancel1", function(i)
	for id = 1, #spots do
		if (spots[id].id == i) then
			spots[id].robbed = false
			spots[id].robbing = false
			spots[id].robber = 0
			spots[id].robberyValid = false
			TriggerClientEvent("sa:rob:sendPositions", -1, spots)
		end
	end
end)

RegisterServerEvent("sa:rob:finish")
AddEventHandler("sa:rob:finish", function(id)
	if (spots[id].robbing == true and spots[id].robbed == false and spots[id].robberyValid and spots[id].robber == source) then
		TriggerEvent("sa:banking:dirtyCash", source, spots[id].name, tonumber(spots[id].take))
		spots[id].robbed = true
		spots[id].robbing = false
		spots[id].robberyValid = false
		spots[id].robber = 0
		TriggerClientEvent("sa:rob:complete", source)
		TriggerClientEvent("sa:rob:sendPositions", -1, spots)
		print("Client successfully robbed a store.")
	else
		print("Client robbed a store too quickly.")
	end
end)