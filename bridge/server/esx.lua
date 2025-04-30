if not DetectFramework("esx", "es_extended") then return end

local ESX = exports["es_extended"]:getSharedObject()

--- Returns the player object from the given source.
--- @param source number
--- @return table|nil
local function GetPlayerObject(source)
	if not source or source == 0 then return nil end
	return ESX.GetPlayerFromId(source)
end

--- Returns the player's job data.
--- @param source number
--- @return string|nil -- The job name
--- @return number|nil -- The job grade
local function GetJobData(source)
	local xPlayer = GetPlayerObject(source)
	if not xPlayer then return nil end

	local job = xPlayer.getJob()
	return job.name, job.grade
end
lib.callback.register("ghost-shop:server:GetJobData", GetJobData)

--- Checks if the player has the specific license.
---@param source number
---@param licenseType string
---@return boolean
local function HasLicense(source, licenseType)
	if not source or source == 0 then return false end
	if not licenseType then return false end

	local p = promise.new()
	TriggerEvent("esx_license:checkLicense", source, licenseType, function(hasLicense)
		p:resolve(hasLicense)
	end)

	local result = Citizen.Await(p)
	return result
end
lib.callback.register("ghost-shop:server:HasLicense", HasLicense)

--- Adds a license to the player
---@param source number
---@param licenseType string
function AddLicense(source, licenseType)
	if not source or source == 0 then return end
	if not licenseType then return end

	TriggerEvent("esx_license:addLicense", source, licenseType)
end

--- Checks if the player can carry the specified item and quantity.
---@param source number
---@param itemName string
---@param itemQuantity number
---@return boolean
function CanAddItem(source, itemName, itemQuantity)
	if GetResourceState("ox_inventory") == "started" then
		return exports.ox_inventory:CanCarryItem(source, itemName, itemQuantity)
	else
		local xPlayer = GetPlayerObject(source)
		if not xPlayer then return false end

		return xPlayer.canCarryItem(itemName, itemQuantity)
	end
end

--- Adds an item to the player's inventory.
---@param source number
---@param itemName string
---@param itemQuantity number
---@return boolean
function AddItem(source, itemName, itemQuantity)
	if GetResourceState("ox_inventory") == "started" then
		return exports.ox_inventory:AddItem(source, itemName, itemQuantity)
	else
		local xPlayer = GetPlayerObject(source)
		if not xPlayer then return false end

		return xPlayer.addInventoryItem(itemName, itemQuantity)
	end
end

--- Checks if the player already has the specified weapon.
---@param source number
---@param weaponName string
---@return boolean
function HasWeapon(source, weaponName)
	local xPlayer = GetPlayerObject(source)
	if not xPlayer then return false end

	return xPlayer.hasWeapon(weaponName)
end

--- Adds a weapon to the player.
---@param source number
---@param weaponName string
---@return boolean
function AddWeapon(source, weaponName)
	local xPlayer = GetPlayerObject(source)
	if not xPlayer then return false end

	return xPlayer.addWeapon(weaponName, 120)
end

--- Gets the player's money balance for the specified account type
---@param source number
---@param accountType string <"cash"|"bank">
---@return number|nil
function GetMoney(source, accountType)
	accountType = accountType == "cash" and "money" or "bank"

	local xPlayer = GetPlayerObject(source)
	if not xPlayer then return nil end

	return xPlayer.getAccount(accountType).money or 0
end

--- Removes money from the player's specified account
---@param source number
---@param accountType string <"cash"|"bank">
---@param amount number
function RemoveMoney(source, accountType, amount)
	accountType = accountType == "cash" and "money" or "bank"

	local xPlayer = GetPlayerObject(source)
	if not xPlayer then return end

	return xPlayer.removeAccountMoney(accountType, amount)
end
