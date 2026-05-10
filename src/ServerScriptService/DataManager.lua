-- DataManager.lua
local ProfileService = require(game.ServerScriptService.ProfileService)

local TEMPLATE = {
	Money = 100,
	Gems = 0,
	Plants = {},
	Pets = {},
	Plots = {Unlocked = {1}},
	LastSave = os.time()
}

local ProfileStore = ProfileService.GetProfileStore("BrainrotGardenV1", TEMPLATE)

local Profiles = {}

game.Players.PlayerAdded:Connect(function(player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile then
		profile:AddUserId(player.UserId)
		profile:ListenToHopReady()
		Profiles[player] = profile
		print(player.Name .. " data loaded")
	else
		player:Kick("Failed to load data")
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	local profile = Profiles[player]
	if profile then
		profile:Release()
		Profiles[player] = nil
	end
end)

return Profiles