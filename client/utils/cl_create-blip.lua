function CreateBlip(coords, config)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

	SetBlipSprite(blip, config.Sprite)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, config.Scale)
	SetBlipColour(blip, config.Color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(config.Name)
	EndTextCommandSetBlipName(blip)

	return blip
end

return CreateBlip
