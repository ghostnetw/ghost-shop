local Config = require("config.cfg_main")

---Checks if a specific framework is active based on configuration
---@param name string -- The name of the framework to check
---@param resource string -- The resource name to check if running
---@return boolean -- Returns true if the framework is active
function DetectFramework(name, resource)
	if Config.Framework == "auto" then return GetResourceState(resource) == "started" end
	return Config.Framework == name
end
