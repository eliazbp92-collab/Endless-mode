game.Lighting.MainColorCorrection.TintColor = Color3.fromRGB(212, 255, 0)
game.Lighting.MainColorCorrection.Contrast = 0.3
local tween = game:GetService("TweenService")
tween:Create(game.Lighting.MainColorCorrection, TweenInfo.new(0.5), {Contrast = 0}):Play()
local TweenService = game:GetService("TweenService")
local TW = TweenService:Create(game.Lighting.MainColorCorrection, TweenInfo.new(0.5),{TintColor = Color3.fromRGB(255, 255, 255)})
TW:Play()

local roast = Instance.new("Sound")
roast.Parent = workspace
roast.Name = "roast"
roast.SoundId = "rbxassetid://9125936117"
roast.Volume = 10
roast.Pitch = 3
roast:Play()

wait(0.6)

roast:Destroy()

local delayTime = Random.new():NextInteger(0.01 , 2)

---====== Load spawner ======---

local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Endless-Doors/refs/heads/main/Endless%20Doors%20Spawner"))()

---====== Create entity ======---

local entity = Spawner:Create({
	Entity = {
		Name = "Matcher",
		Asset = "https://github.com/eliazbp92-collab/Endless-mode/blob/main/Matcherdude.rbxm?raw=true",
		HeightOffset = 0.5
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
		Speed = 105,
		Delay = delayTime, 
		Reversed = false
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
		Range = 33,
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
		Hints = {"You die to...", "Uhmm Matcher", "Hide when hear his sound", "Goodbye"},
		Cause = ""
	}
})

---====== Debug entity ======---

entity:SetCallback("OnSpawned", function()
	print("Entity has spawned")
end)

entity:SetCallback("OnStartMoving", function()
	print("Entity has started moving")
end)

entity:SetCallback("OnEnterRoom", function(room: Model, firstTime: boolean)
	if firstTime then
		print("Entity has entered room: ".. room.Name.. " for the first time")
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
		local cue2 = Instance.new("Sound")
		cue2.Parent = game.Workspace
		cue2.Name = "Spawn"
		cue2.SoundId = "rbxassetid://74885373257467"
		cue2.Volume = 10
		cue2.TimePosition = 0
		cue2.PlaybackSpeed = 0.82
		cue2:Play()

		local pitch = Instance.new('PitchShiftSoundEffect')
		pitch.Octave = 0.605
		pitch.Parent = cue2

		local dis = Instance.new("DistortionSoundEffect")
		dis.Parent = cue2

		local eq = Instance.new("EqualizerSoundEffect")
		eq.HighGain = 10
		eq.LowGain = 3.7
		eq.MidGain = 10
		eq.Parent = cue2

		local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "FlashOverlay"
		screenGui.IgnoreGuiInset = true -- Fills the whole screen
		screenGui.Parent = playerGui

		-- Create the Frame
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame.BackgroundTransparency = 0 -- Start invisible
		frame.BorderSizePixel = 0
		frame.Parent = screenGui



		local Smiler = Instance.new("ImageLabel")
		Smiler.Image = "rbxassetid://17193117170"
		Smiler.Size = UDim2.new(0, 60, 0, 60)
		Smiler.Position = UDim2.new(0.5, 0,0.5, 0)
		Smiler.ImageColor3 = Color3.fromRGB(255, 35, 35)
		Smiler.AnchorPoint = Vector2.new(0.5, 0.5)
		Smiler.Parent = screenGui
		Smiler.BackgroundTransparency = 1
		Smiler.ResampleMode = Enum.ResamplerMode.Pixelated
		Smiler.ImageTransparency = 0
		Smiler.ZIndex = 1000
		Smiler.Rotation = 0


		local a = task.spawn(function()
			while true do
				frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				wait(0)
				frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
				wait(0)
			end
		end)

		local rng = Random.new()
		local origin = Smiler.Position

		local b = task.spawn(function()
			while true do
				Smiler.ImageColor3 = Color3.fromRGB(math.random(245, 255), math.random(245, 255), math.random(245, 255))
				Smiler.Rotation = math.random(-15, 15)
				Smiler.ImageTransparency = math.random(0, 50) / 100
				Smiler.Position = origin + UDim2.new(0, math.random(-60, 60), 0, math.random(-60, 60))
				wait(0.002380952380952381)
			end
		end)

		local TweenService = game:GetService("TweenService")
		local rng = Random.new() 
		local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		game.TweenService:Create(Smiler, tweenInfo, {

			Size = UDim2.new(0,3000,0,2500)
		}):Play()

		wait(0.7)
		screenGui:Destroy()		
		cue2:Destroy()
	else
		print("Entity has damaged the player")
	end
end)

---====== Run entity ======---

entity:Run(true)
