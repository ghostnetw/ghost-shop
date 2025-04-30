-- Configuration
local Config = require("config.cfg_main")
local Functions = require("config.cfg_functions")
local Locales = require("config.cfg_locales")

-- Modules
local Interaction = require("client.modules.cl_interaction")
local ShopPeds = require("client.modules.cl_shop-ped")
local HandleTransaction = require("client.modules.cl_transaction")

-- Utils
local CreateBlip = require("client.utils.cl_create-blip")
local GetInteractDistance = require("client.utils.cl_interact-dist")
local PlayUiSound = require("client.utils.cl_play-sound")

LocalPlayer.state.inShop = false
LocalPlayer.state.currentShop = nil

--[[ INITIALIZATION ]]

local function CreatePoints(shopKey, shopData, shopCoords)
	local shopPoint = lib.points.new({
		coords = shopCoords,
		distance = shopData.PointRadius,
		interactDistance = GetInteractDistance(shopData),
		ped = nil,
	})

	function shopPoint:onEnter()
		if shopData.Indicator.Ped.Enabled then self.ped = ShopPeds.Spawn(shopData, shopCoords) end
	end
	function shopPoint:onExit()
		if shopData.Indicator.Ped.Enabled then ShopPeds.Delete(self.ped) end
	end

	function shopPoint:nearby()
		if not LocalPlayer.state.inShop then
			if shopData.Indicator.Marker.Enabled then
				local markerConfig = shopData.Indicator.Marker
				---@diagnostic disable-next-line: missing-parameter
				DrawMarker(markerConfig.Type, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerConfig.Size.x, markerConfig.Size.y, markerConfig.Size.z, markerConfig.Color[1], markerConfig.Color[2], markerConfig.Color[3], markerConfig.Color[4], markerConfig.BobUpAndDown, markerConfig.FaceCamera, 2, markerConfig.Rotate)
			end
		end

		if shopData.Interaction.HelpText.Enabled or shopData.Interaction.FloatingText.Enabled then
			if self.isClosest and self.currentDistance <= self.interactDistance then
				if IsPlayerDead(cache.playerId) or IsPedInAnyVehicle(cache.ped, false) then return end

				if not LocalPlayer.state.inShop then
					if shopData.Interaction.HelpText.Enabled then Functions.Interact.HelpText(Locales.Interaction.HelpText) end
					if shopData.Interaction.FloatingText.Enabled then Functions.Interact.FloatingHelpText(Locales.Interaction.FloatingText, self.ped, self.coords) end
				end

				if IsControlJustReleased(0, shopData.Interaction.OpenKey) then Interaction.Open(shopKey, shopData) end
			end
		end
	end
end

for shopKey, shopData in pairs(Config.Shops) do
	for i = 1, #shopData.Locations do
		local shopCoords = shopData.Locations[i]

		if shopData.Blip.Enabled then CreateBlip(shopCoords, shopData.Blip) end
		CreatePoints(shopKey, shopData, shopCoords)
		if shopData.Interaction.Target.Enabled then Functions.Interact.AddTarget(shopKey, shopData, shopCoords, Interaction.Open) end
	end
end

--[[ NUI CALLBACK ]]

RegisterNuiCallback("shop:fetchData", function(data, cb)
	if not type(data.label) == "string" then return end

	local shopData = Config.Shops[LocalPlayer.state.currentShop]

	local actions = {
		closeShop = function()
			local success = pcall(Interaction.Close)
			cb(success)
		end,

		selectCategory = function()
			PlayUiSound("SELECT", "HUD_FREEMODE_SOUNDSET")
			cb(true)
		end,
		addToCart = function()
			PlayUiSound("Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
			cb(true)
		end,
		removeFromCart = function()
			PlayUiSound("Pin_Bad", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
			cb(true)
		end,

		payCart = function()
			Print.Info("[NUI:payCart] Payment Type:", data.type, "Cart Array:", json.encode(data.cart))

			local success = HandleTransaction(data.type, data.cart)
			if success then ShopPeds.ApplySpeech("Generic_Thanks", "Speech_Params_Force_Shouted_Critical") end
			cb(success)
		end,

		getCategories = function()
			cb({ categories = shopData.Categories })
		end,
		getItems = function()
			cb({ items = shopData.Items })
		end,
		getLocales = function()
			Locales.UI.main.header = shopData.Locales.MainHeader
			Locales.UI.cart.header = shopData.Locales.CartHeader
			cb({ imagePath = Config.Inventory.ImagePath, locales = Locales.UI })
		end,
	}

	local action = actions[data.label]
	if action then action() end
end)

-- [[ CLEAN UP ]]

local function CleanUp()
	Interaction.CloseUI()
	ShopPeds.DeleteAll()
end

AddEventHandler("onResourceStop", function(resource)
	if resource ~= cache.resource then return end
	CleanUp()
end)

AddEventHandler("gameEventTriggered", function(event, data)
	if event ~= "CEventNetworkEntityDamage" then return end
	if not LocalPlayer.state.inShop then return end

	local playerId, playerDead = data[1], data[4]
	if not IsPedAPlayer(playerId) then return end

	local currentPlayer = cache.playerId
	if playerDead and NetworkGetPlayerIndexFromPed(playerId) == currentPlayer and IsPlayerDead(currentPlayer) then Interaction.CloseUI() end
end)
