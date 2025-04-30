local peds = {}

local function SpawnPed(shopData, shopCoords)
	local pedConfig = shopData.Indicator.Ped
	local pedPos = shopCoords
	local pedModel = pedConfig.Model
	local pedScenario = pedConfig.Scenario

	if not IsModelInCdimage(pedModel) or not IsModelAPed(pedModel) then
		Print.Error("[SpawnPed] Ped hash is not valid, failed to spawn ped.")
		return nil
	end

	lib.requestModel(pedModel)
	local ped = CreatePed(0, pedModel, pedPos.x, pedPos.y, pedPos.z - 1, pedPos.w, false, false)
	SetModelAsNoLongerNeeded(pedModel)

	ped = lib.waitFor(function()
		if DoesEntityExist(ped) and ped ~= 0 then return ped end
	end, "[SpawnPed] Could not create ped in time.", 3000)

	if not ped or ped == 0 then
		Print.Error("[SpawnPed] Ped creation failed or timed out.")
		return nil
	end

	SetPedFleeAttributes(ped, 0, false)
	SetBlockingOfNonTemporaryEvents(ped, true)
	SetEntityInvincible(ped, true)
	FreezeEntityPosition(ped, true)
	TaskStartScenarioInPlace(ped, pedScenario, 0, true)

	peds[#peds + 1] = { ped = ped, pos = pedPos }
	return ped
end

local function GetNearestPed()
	local playerPos = GetEntityCoords(cache.ped)
	for i = 1, #peds do
		local ped, pedPos = peds[i].ped, peds[i].pos

		if not DoesEntityExist(ped) then
			Print.Error("[GetNearestPed] Ped does not exist.")
			return nil
		end

		local distance = #(vector3(pedPos.x, pedPos.y, pedPos.z) - playerPos)
		if distance <= 15.0 then return ped end
	end
	Print.Error("[GetNearestPed] No valid peds found within 15.0 units.")
	return nil
end

local function RemovePed(ped)
	if not DoesEntityExist(ped) then return end
	DeletePed(ped)

	for i = 1, #peds do
		local shopPed = peds[i].ped
		if shopPed == ped then
			peds[i] = peds[#peds]
			peds[#peds] = nil
			break
		end
	end
end

local function RemoveAllPeds()
	for i = 1, #peds do
		local ped = peds[i].ped
		if DoesEntityExist(ped) then DeletePed(ped) end
	end
	peds = {}
end

local function ApplySpeechToPed(speechName, speechParam)
	local shopPed = GetNearestPed()
	if not shopPed then
		Print.Error("[ApplySpeechToPed] No valid ped found within 15.0 units to apply speech.")
		return
	end

	if IsAmbientSpeechPlaying(shopPed) then StopCurrentPlayingAmbientSpeech(shopPed) end
	PlayPedAmbientSpeechNative(shopPed, speechName, speechParam)
end

return {
	Spawn = SpawnPed,
	GetNearest = GetNearestPed,
	Delete = RemovePed,
	DeleteAll = RemoveAllPeds,
	ApplySpeech = ApplySpeechToPed,
}
