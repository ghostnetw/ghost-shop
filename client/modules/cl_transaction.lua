-- Utils
local PlayUiSound = require("client.utils.cl_play-sound")

local function HandleTransaction(transactionType, cartArray)
	local success, reason = lib.callback.await("ghost-shop:server:ProcessTransaction", false, transactionType, cartArray)

	if reason then Print.Debug("[HandleTransaction]", reason) end

	local sound = success and "ROBBERY_MONEY_TOTAL" or "CHECKPOINT_MISSED"
	local soundSet = success and "HUD_FRONTEND_CUSTOM_SOUNDSET" or "HUD_MINI_GAME_SOUNDSET"
	PlayUiSound(sound, soundSet)

	return success
end

return HandleTransaction
