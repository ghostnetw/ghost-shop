-- Configuration
local Functions = require("config.cfg_functions")
local Locales = require("config.cfg_locales")

local function CheckJobRequirements(shopData)
	local jobName, jobGrade = lib.callback.await("ghost-shop:server:GetJobData", false)
	Print.Debug(("[CheckJobRequirements] Job Name: %s, Job Grade: %s"):format(jobName, jobGrade))

	if jobName ~= shopData.Requirement.Job.Name then
		Functions.Notify.Client({
			title = Locales.Notify.Requirement.Job.title,
			description = Locales.Notify.Requirement.Job.description:format(shopData.Requirement.Job.Label),
			type = Locales.Notify.Requirement.Job.type,
		})
		return false
	end

	if jobGrade < shopData.Requirement.Job.Grade then
		Functions.Notify.Client({
			title = Locales.Notify.Requirement.JobGrade.title,
			description = Locales.Notify.Requirement.JobGrade.description,
			type = Locales.Notify.Requirement.JobGrade.type,
		})
		return false
	end

	return true
end

return CheckJobRequirements
