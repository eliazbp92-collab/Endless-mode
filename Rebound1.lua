local rng = Random.new()
local ai = rng:NextInteger(35, 50)

function light(tim, color0, color1)
	local tweenservice = game:GetService("TweenService")
	local info = TweenInfo.new(tim, Enum.EasingStyle.Linear)
	for _, lightObj in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
		if lightObj:IsA("Light") or lightObj:IsA("SurfaceLight") or lightObj:IsA("SpotLight") then
			local target = {Color = color1}
			local anim = tweenservice:Create(lightObj, info, target)
			anim:Play()
		end
		if lightObj:IsA("MeshPart") and lightObj.Material == Enum.Material.Neon and lightObj.Name ~= "Skybox" then
			local target1 = {Color = color0}
			local anim2 = tweenservice:Create(lightObj, info, target1)
			anim2:Play()
		end
	end
end

local spawnSound = Instance.new("Sound")
spawnSound.Parent = game.Workspace
spawnSound.Name = "Spawn"
spawnSound.SoundId = "rbxassetid://9114221327"
spawnSound.Volume = 10
spawnSound:Play()

local delayTime = Random.new():NextInteger(0.01 , 2)

---====== Load spawner ======---

local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/DOORS-Entity-Spawner-V2/main/init.luau"))()

---====== Create entity ======---

local entity = Spawner:Create({
	Entity = {
		Name = "Rebound1",
		Asset = "https://github.com/eliazbp92-collab/Endless-mode/blob/main/Rebound%20endless%20doors%20remake.rbxm?raw=true",
		HeightOffset = 1
	},
	Lights = {
		Flicker = {
			Enabled = false,
			Duration = 1
		},
		Shatter = false,
		Repair = false
	},
	Earthquake = {
		Enabled = false
	},
	CameraShake = {
		Enabled = true,
		Range = 100,
		Values = {5, 15, 0.1, 1}
	},
	Movement = {
		Speed = ai,
		Delay = delayTime, -- Sửa thành số nguyên
		Reversed = true
	},
	Rebounding = {
		Enabled = false,
		Type = "Ambush",
		Min = 1,
		Max = 1,
		Delay = 2
	},
	Damage = {
		Enabled = true,
		Range = 10,
		Amount = 100
	},
	Crucifixion = {
		Enabled = true,
		Range = 40,
		Resist = false,
		Break = true
	},
	Death = {
		Type = "Guiding",
		Hints = {"Death", "Hints", "Go", "Here"},
		Cause = ""
	}
})

---====== Debug entity ======---

entity:SetCallback("OnSpawned", function()
	print("Entity has spawned")

	light(2, Color3.fromRGB(85, 170, 255), Color3.fromRGB(65, 138, 255))

	-- Tìm Rebound an toàn bằng WaitForChild để tránh lỗi nil
	local reboundModel = game.Workspace:WaitForChild("Rebound1", 5)
	local reboundRoot = reboundModel and reboundModel:WaitForChild("Root", 3)

	local function GetGitSound(GithubSnd, SoundName)
		local filePath = SoundName .. ".mp3"
		if not isfile(filePath) then
			writefile(filePath, game:HttpGet(GithubSnd))
		end
		local sound = Instance.new("Sound")
		sound.SoundId = (getcustomasset or getsynasset)(filePath)
		return sound
	end

	pcall(function()
		local Jumpscare = GetGitSound("https://github.com/check78/worldcuuuup/blob/main/DoomBegin.mp3?raw=true", "Riririririiriri")
		Jumpscare.Parent = reboundRoot or reboundModel or game.Workspace
		Jumpscare.Volume = 2
		Jumpscare.RollOffMinDistance = 100
		Jumpscare.RollOffMaxDistance = 200
		Jumpscare.Name = "am"
		Jumpscare.PlaybackSpeed = 1
		Jumpscare:Play()
	end)
end)

entity:SetCallback("OnStartMoving", function()
	print("Entity has started moving")
	game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/eliazbp92-collab/Endless-mode/refs/heads/main/Rebound2.lua"))()
end)

entity:SetCallback("OnEnterRoom", function(room: Model, firstTime: boolean)
	if firstTime then
		print("Entity has entered room: ".. room.Name.. " for the first time")
		if ai >= 700 then
			local RunService = game:GetService("RunService")
			local TweenService = game:GetService("TweenService")

			local entityModel = workspace:FindFirstChild("Rebound1")
			local entityRoot = entityModel and (entityModel:FindFirstChild("HumanoidRootPart") or entityModel:FindFirstChildWhichIsA("BasePart")) 

			if entityRoot then
				local freezeConnection
				local doorFreezePos = entityRoot.CFrame

				freezeConnection = RunService.Heartbeat:Connect(function()
					if entityModel and entityModel.Parent and entityRoot then
						entityRoot.Anchored = true
						entityRoot.CFrame = doorFreezePos
						entityRoot.AssemblyLinearVelocity = Vector3.zero
						entityRoot.AssemblyAngularVelocity = Vector3.zero
					end
				end)
				
				wait(1)
				
				if freezeConnection then
					freezeConnection:Disconnect()
				end
				end

		end
	else
		print("Entity has entered room: ".. room.Name.. " again")
	end
end)

entity:SetCallback("OnLookAt", function(lineOfSight: boolean)
	if lineOfSight then
		print("Player is looking at entity")
	else
		print("Player view is obstructed by something")
	end
end)

entity:SetCallback("OnRebounding", function(startOfRebound: boolean)
	if startOfRebound then
		print("Entity has started rebounding")
	else
		print("Entity has finished rebounding")
	end
end)

entity:SetCallback("OnDespawning", function()
	print("Entity is despawning")
end)

entity:SetCallback("OnDespawned", function()
	print("Entity has despawned")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth: number)
	if newHealth <= 0 then
		print("Entity has killed the player")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Endless-Doors/refs/heads/main/Rebound%20jumpscare"))()
	else
		print("Entity has damaged the player")
	end
end)

---====== Run entity ======---

entity:Run(true)
