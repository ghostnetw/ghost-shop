if not DetectFramework("custom", "your_framework") then return end

--- Returns the player object from the given source.
--- @param source number
--- @return table|nil
local function GetPlayerObject(source)
	---@diagnostic disable-next-line: return-type-mismatch
	if not source or source == 0 then return nil end
	return Your_Framework.GetPlayer(source) -- Example
end

--- Returns the player's job data.
--- @param source number
--- @return string|nil -- The job name
--- @return number|nil -- The job grade
local function GetJobData(source)
	local Player = GetPlayerObject(source)
	if not Player then return nil end

	local job = Player.GetJobData() -- Example
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

	local Player = GetPlayerObject(source)
	if not Player then return false end

	return Player.HasLicense(licenseType) -- Example
end
lib.callback.register("ghost-shop:server:HasLicense", HasLicense)

--- Adds a license to the player
---@param source number
---@param licenseType string
function AddLicense(source, licenseType)
	if not source or source == 0 then return end
	if not licenseType then return end

	local Player = GetPlayerObject(source)
	if not Player then return end

	Player.AddLicense(licenseType)
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
		local Player = GetPlayerObject(source)
		if not Player then return false end

		return Player.CanCarryItem(source, itemName, itemQuantity) -- Example
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
		local Player = GetPlayerObject(source)
		if not Player then return false end

		return Player.AddItem(source, itemName, itemQuantity) -- Example
	end
end

--- Checks if the player already has the specified weapon.
---@param source number
---@param weaponName string
---@return boolean
function HasWeapon(source, weaponName)
	if not source or source == 0 then return false end

	local Player = GetPlayerObject(source)
	if not Player then return false end

	return Player.HasWeapon(weaponName) -- Example
end

--- Adds a weapon to the player.
---@param source number
---@param weaponName string
---@return boolean
function AddWeapon(source, weaponName)
	if not source or source == 0 then return false end

	local Player = GetPlayerObject(source)
	if not Player then return false end

	return Player.AddWeapon(weaponName) -- Example
end

--- Gets the player's money balance for the specified account type
---@param source number
---@param accountType string <"cash"|"bank">
---@return number|nil
function GetMoney(source, accountType)
	local Player = GetPlayerObject(source)
	if not Player then return nil end

	return Player.GetMoney(accountType) or 0 -- Example
end

--- Removes money from the player's specified account
---@param source number
---@param accountType string <"cash"|"bank">
---@param amount number
function RemoveMoney(source, accountType, amount)
	local Player = GetPlayerObject(source)
	if not Player then return end

	return Player.RemoveMoney(accountType, amount) -- Example
end
