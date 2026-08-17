game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
local damages = true
local tweenservice = game:GetService("TweenService")

local ClaimModel = "https://github.com/eoyoustme/Endless-Doors/raw/main/Claim.rbxm"

function getgithubmodeL(url)
	if not (writefile and getcustomasset and request) then return nil end
	local fileName = string.match(url, "([^/]+)$") or "temp_model.rbxm"
	local response = request({Url = url, Method = "GET"})
	if response.StatusCode ~= 200 then return nil end
	writefile(fileName, response.Body)
	local assetId = getcustomasset(fileName)
	local success, result = pcall(function() return game:GetObjects(assetId)[1] end)
	return success and result or nil
end

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://9113601215"
sound.PlaybackSpeed = 0.53
sound.Parent = workspace
sound.Volume = 7
sound:Play()

wait(4)

local model = getgithubmodeL(ClaimModel).Claim
model.Parent = game.Workspace
model.CFrame = game.Workspace.CurrentRooms:GetChildren()[#game.Workspace.CurrentRooms:GetChildren() - 1].Parts.Floor.CFrame + Vector3.new(0,6,0)

task.wait(1)
task.spawn(function()
	while damages == true do
		task.wait(0.5)
		local ray = game.Workspace:Raycast(model.Position,game.Players.LocalPlayer.Character.HumanoidRootPart.Position - model.Position)
		if ray.Instance.Parent == game.Players.LocalPlayer.Character or ray.Instance.Parent.Parent == game.Players.LocalPlayer.Character then
			warn("parent")
			game.Players.LocalPlayer.Character.Humanoid:TakeDamage(1000)
			
			local sound1 = Instance.new("Sound")
			sound1.SoundId = "rbxassetid://5867708670"
			sound1.PlaybackSpeed = 1
			sound1.Parent = workspace
			sound1.Volume = 7
			sound1:Play()
			
			if game.Players.LocalPlayer.Character.Humanoid.Health <= 1 then
				damages = false
				firesignal(game.ReplicatedStorage.RemotesFolder.DeathHint.OnClientEvent, {"You died to who you call Claim...","He spawns in center of room","Find an object to hide behind!"},"Blue")
				game.ReplicatedStorage.GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Claim"
			end
		end
	end
end)

task.wait(10)

damages = false
model:Destroy()

task.wait(2)
local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()
	achievementGiver({
		Title = "Calim",
		Desc = "One wrong step...",
		Reason = "Encounter Claim",
		Image = ""
	})
