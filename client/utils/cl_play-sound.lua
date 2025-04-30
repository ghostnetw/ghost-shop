-- Configuration
local Config = require("config.cfg_main")

local function PlayUiSound(audioName, audioRef)
	if not Config.UI.Sounds then return end
	PlaySoundFrontend(-1, audioName, audioRef, true)
end

return PlayUiSound
