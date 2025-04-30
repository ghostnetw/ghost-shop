local function GetInteractDistance(shopData)
	if shopData.Interaction.HelpText.Enabled then
		return shopData.Interaction.HelpText.Distance
	elseif shopData.Interaction.FloatingText.Enabled then
		return shopData.Interaction.FloatingText.Distance
	end
	return nil
end

return GetInteractDistance
