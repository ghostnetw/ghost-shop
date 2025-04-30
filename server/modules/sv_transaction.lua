-- Configuration
local Config = require("config.cfg_main")
local Functions = require("config.cfg_functions")
local Locales = require("config.cfg_locales")

local function IsItemAWeapon(itemName)
	return itemName:sub(1, 7):lower() == "weapon_" and not Config.Inventory.WeaponAsItem and not GetResourceState("ox_inventory") == "started"
end

local function ProcessTransaction(source, type, cartArray)
	if not source or source == 0 then return false, "Invalid source." end
	if not cartArray or #cartArray == 0 then return false, "Invalid or empty cart array." end
	if not inShop[source] then return false, "Not in shop state." end

	local accountType = type == "bank" and "bank" or "cash"
	local totalCartPrice = 0

	for i = 1, #cartArray do
		local item = cartArray[i]

		local availableMoney = GetMoney(source, accountType)
		local totalItemPrice = (item.price * item.quantity) or 0

		if availableMoney >= totalItemPrice then
			if IsItemAWeapon(item.name) then
				if not HasWeapon(source, item.name) then
					RemoveMoney(source, accountType, totalItemPrice)
					AddWeapon(source, item.name)
					totalCartPrice = totalCartPrice + totalItemPrice
				else
					Functions.Notify.Server(source, {
						title = Locales.Notify.CantCarry.Weapons.title,
						description = Locales.Notify.CantCarry.Weapons.description:format(item.label),
						type = Locales.Notify.CantCarry.Weapons.type,
					})
				end
			else
				if CanAddItem(source, item.name, item.quantity) then
					RemoveMoney(source, accountType, totalItemPrice)
					AddItem(source, item.name, item.quantity)
					totalCartPrice = totalCartPrice + totalItemPrice
				else
					Functions.Notify.Server(source, {
						title = Locales.Notify.CantCarry.Item.title,
						description = Locales.Notify.CantCarry.Item.description:format(item.label),
						type = Locales.Notify.CantCarry.Item.type,
					})
				end
			end
		else
			Functions.Notify.Server(source, {
				title = Locales.Notify.NoMoney.Shop.title,
				description = Locales.Notify.NoMoney.Shop.description:format(item.label),
				type = Locales.Notify.NoMoney.Shop.type,
			})
		end
	end

	if totalCartPrice > 0 then
		Functions.Notify.Server(source, {
			title = Locales.Notify.PaymentSuccess.Shop.title,
			description = Locales.Notify.PaymentSuccess.Shop.description:format(totalCartPrice),
			type = Locales.Notify.PaymentSuccess.Shop.type,
		})
		return true, ("Purchased item(s) for $%s."):format(totalCartPrice)
	end
	return false, "Transaction failed."
end
lib.callback.register("ghost-shop:server:ProcessTransaction", ProcessTransaction)
