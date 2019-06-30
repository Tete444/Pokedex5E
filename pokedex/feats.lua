local file = require "utils.file"
local utils = require "utils.utils"
local log = require "utils.log"

local M = {}

local feats

local initialized = false

local function list_of_feats()
	local d = {}
	for name, description in pairs(feats) do 
		table.insert(d, name)
	end
	return d
end

function M.init()
	if not initialized then
		feats = file.load_json_from_resource("/assets/datafiles/feats.json")
		M.list = list_of_feats()
		initialized = true
	end
end


function M.get_feat_description(name)
	if feats[name] then
		return feats[name].Description
	else
		local e = string.format("Can not find Feat: '%s'", tostring(name)) ..  "\n" .. debug.traceback()
		gameanalytics.addErrorEvent {
			severity = "Error",
			message = e
		}
		log.error(e)
		return "This is an error, the app couldn't find the feat"
	end
end

return M