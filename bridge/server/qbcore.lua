if not DetectFramework("qbcore", "qb-core") or DetectFramework("qbox", "qbx_core") then return end

local DoesExportExist = require("shared.utils.sh_export-check")

local QBCore = exports["qb-core"]:GetCoreObject()

--- Returns the player object from the given source.
--- @param source number
--- @return table|nil
local function GetPlayerObject(source)
	if not source or source == 0 then return nil end
	return QBCore.Functions.GetPlayer(source)
end

--- Returns the player's job data.
--- @param source number
--- @return string|nil -- The job name
--- @return number|nil -- The job grade
local function GetJobData(source)
	local Player = GetPlayerObject(source)
	if not Player then return nil end

	local job = Player.PlayerData.job or { name = "unknown", grade = { level = 0 } }
	local gang = Player.PlayerData.gang or { name = "none", label = "unknown", grade = { level = 0 } }

	-- If player has both gang and job, prioritize job info
	if gang.name ~= "none" and job.name ~= "unemployed" then return job.name, job.grade.level end

	-- Otherwise, use gang if exists, fallback to job
	return gang.name ~= "none" and gang.label or job.name, gang.name ~= "none" and gang.grade.level or job.grade.level
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

	return Player.PlayerData.metadata.licences[licenseType]
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

	local licenseTable = Player.PlayerData.metadata.licences
	licenseTable[licenseType] = true
	Player.Functions.SetMetaData("licences", licenseTable)
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
		if not DoesExportExist("qb-inventory", "CanAddItem") then
			Print.Warn("[CanAddItem] Could not find qb-inventory:CanAddItem export, assuming true")
			Print.Info("[CanAddItem] Update your qb-inventory version to 2.0.0 or higher to use this export")
			return true
		end
		return exports["qb-inventory"]:CanAddItem(source, itemName, itemQuantity)
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
		local isWeapon = itemName:sub(1, 7):lower() == "weapon_"
		if isWeapon then return exports["qb-inventory"]:AddItem(source, itemName, itemQuantity, false, { quality = 100 }, "ghost-shop:AddWeapon") end
		return exports["qb-inventory"]:AddItem(source, itemName, itemQuantity, false, false, "ghost-shop:AddItem")
	end
end

--- Checks if the player already has the specified weapon.
---@param source number
---@param weaponName string
---@return boolean
function HasWeapon(source, weaponName)
	-- Add your custom logic here
	return false
end

--- Adds a weapon to the player.
---@param source number
---@param weaponName string
---@return boolean
function AddWeapon(source, weaponName)
	-- Add your custom logic here
	return true
end

--- Gets the player's money balance for the specified account type
---@param source number
---@param accountType string <"cash"|"bank">
---@return number|nil
function GetMoney(source, accountType)
	local Player = GetPlayerObject(source)
	if not Player then return nil end

	return Player.Functions.GetMoney(accountType) or 0
end

--- Removes money from the player's specified account
---@param source number
---@param accountType string <"cash"|"bank">
---@param amount number
function RemoveMoney(source, accountType, amount)
	local Player = GetPlayerObject(source)
	if not Player then return end

	return Player.Functions.RemoveMoney(accountType, amount)
end
