local ds = game:GetService("DataStoreService")
local mainData = ds:GetDataStore("MainData")
local flib = require(script.MPDFunctions)
local ms = game:GetService("MarketplaceService")
local repStorage = game.ReplicatedStorage
local dir = repStorage.PlayerData
local DataTemplate = {
	CurrencyData = {
		Cash = 50,
	},
	OtherData = {
		VIPTrial = {
			Enabled = false,
			StartTime = 1
		},
		StaffData = {
			Points = 0	
		},
	}
}




game.Players.PlayerAdded:Connect(function(plr)
	local data
	local key = flib.createKey(plr.UserId)
	repeat wait() until plr.Character
	local succ, err = pcall(function()
		data = mainData:GetAsync(key)
	end)
	if succ then
		if data == nil then
			data = DataTemplate
			print(data)
		else
			print(data)
			data = flib.combineTable(data,DataTemplate)
			print(data)
		end
	end
	flib.createDirectoryFromTable(data,key,dir)
	local dir = game.ReplicatedStorage.PlayerData:WaitForChild(key)
end)

local function plrLeft(plr)
	local dir = game.ReplicatedStorage.PlayerData:FindFirstChild("main-data-"..plr.UserId)
	local dt = flib.createTableFromDirectory(dir)
	local key = flib.createKey(plr.UserId)
	local succ, err = pcall(function()
		mainData:SetAsync(key,dt)
	end)
	wait(5)
	dir:Destroy()
end

game.Players.PlayerRemoving:Connect(function(plr)
	plrLeft(plr)
end)
game:BindToClose(function()
	for i,v in pairs(game.Players:GetPlayers()) do
		plrLeft(v)
	end
end)
