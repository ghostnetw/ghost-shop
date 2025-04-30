-- Configuration
local Functions = require("config.cfg_functions")
local Locales = require("config.cfg_locales")

local function BuyLicense(source, shopData)
	if not source or source == 0 then return false, "Invalid source" end
	if not shopData then return false, "Invalid shop data" end
	if not inShop[source] then return false, "Not in shop state" end

	local licenseType = shopData.Requirement.License.Type
	local licenseLabel = shopData.Requirement.License.Label
	local licensePrice = shopData.Requirement.License.Price

	local cashAvailable = GetMoney(source, "cash")
	local bankAvailable = GetMoney(source, "bank")
	local accountType = nil

	if cashAvailable >= licensePrice then
		accountType = "cash"
	elseif bankAvailable >= licensePrice then
		accountType = "bank"
	else
		Functions.Notify.Server(source, {
			title = Locales.Notify.NoMoney.License.title,
			description = Locales.Notify.NoMoney.License.description:format(licenseLabel),
			type = Locales.Notify.NoMoney.License.type,
		})
		return false, "No money"
	end

	RemoveMoney(source, accountType, licensePrice)
	AddLicense(source, licenseType)

	Functions.Notify.Server(source, {
		title = Locales.Notify.PaymentSuccess.License.title,
		description = Locales.Notify.PaymentSuccess.License.description:format(licenseLabel, licensePrice),
		type = Locales.Notify.PaymentSuccess.License.type,
	})
	return true, "Successfully bought license"
end
lib.callback.register("ghost-shop:server:BuyLicense", BuyLicense)
