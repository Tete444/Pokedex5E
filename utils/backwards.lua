local profiles = require "pokedex.profiles"
local storage = require "pokedex.storage"
local defsave = require "defsave.defsave"
local flow = require "utils.flow"
local metadata = require "utils.metadata"
local M = {}

local function from_0_1_to_0_2()
	local p = profiles.add("Red", 1)
	profiles.set_active(p.slot)
	storage.init()
	profiles.update(p.slot, {file_name="pokedex5e"})

	-- Need to wait for the file to load in
	timer.delay(0.5, false, function()
		local index = 0
		for x in pairs(storage.list_of_ids_in_storage()) do
			index = index + 1
		end
		for x in pairs(storage.list_of_ids_in_inventory()) do
			index = index + 1
		end
		profiles.update(p.slot, {caught=index})
	end)
end

function M.convert()
	metadata.load()
	local app_version = metadata.get("app_version")
	-- Check for 0.1.0
	if profiles.is_new_game() then
		-- Could be 0.1.0
		if defsave.file_exists("pokedex5e") then
			from_0_1_to_0_2()
		end
	end
	
	metadata.save()
end

return M