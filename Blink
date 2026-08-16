game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local BlinkModel = "https://github.com/eoyoustme/Endless-Doors/raw/main/BLink.rbxm"
local Close = nil

local gameData = ReplicatedStorage:WaitForChild("GameData")
local latestRoomValue = gameData:WaitForChild("LatestRoom")
local currentLoadedRoom = Workspace.CurrentRooms[latestRoomValue.Value]

-- 1. TỰ ĐỘNG XÓA MODEL BLINK CŨ NẾU ĐÃ TỒN TẠI TRONG WORKSPACE
local oldBlink = Workspace:FindFirstChild("Blink")
if oldBlink then
	oldBlink:Destroy()
end

local CameraShaker = require(game.ReplicatedStorage:WaitForChild("CameraShaker"))
local camera = game.Workspace.CurrentCamera
local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end)

-- Hàm tải model từ GitHub
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

local Blink = getgithubmodeL(BlinkModel)
if not Blink then return end

Blink.Parent = Workspace
Blink.Name = "Blink"

local part = Blink:FindFirstChild("Blink") or Blink:FindFirstChildWhichIsA("BasePart") or Blink
local BlinkSoundischange = false
local damge = true

part.Sparkles.Size = NumberSequence.new(7)
part.Attachment.MainParticle.Size = NumberSequence.new(4)
part.Attachment.AttackParticle.Size = NumberSequence.new(4)

local num = 0
if currentLoadedRoom:FindFirstChild("Nodes") then
	local nodes = currentLoadedRoom.Nodes:GetChildren()
	num = math.floor(#nodes / 2)
	local targetNode = nodes[num] or currentLoadedRoom:FindFirstChild(currentLoadedRoom.Name)
	if targetNode then
		local targetCFrame = targetNode.CFrame + Vector3.new(0, 1.6, 0)
		if Blink:IsA("Model") then
			Blink:PivotTo(targetCFrame)
		else
			part.CFrame = targetCFrame
		end
	end
else
	local entrance = currentLoadedRoom:FindFirstChild("RoomEntrance")
	if entrance then
		part.CFrame = entrance.CFrame * CFrame.new(0, 1.6, -20)
	end
end

part.Spawn:Play()
part.Spawn.Volume = 7

-- Âm thanh ở Dạng Tấn Công (thay đổi tốc độ & vị trí ngẫu nhiên)
local function startBlinkSoundLoop()
	task.spawn(function()
		BlinkSoundischange = true
		local Whisper = part:FindFirstChild("Whisper")
		while BlinkSoundischange and part and part.Parent do
			if Whisper then
				Whisper.PlaybackSpeed = Random.new():NextNumber(1, 4.5)
				Whisper.TimePosition = Random.new():NextNumber(2, 7)
			end
			task.wait(0.45)
			camShake:Start()
			camShake:ShakeOnce(5, 15, 0.1, 1)
		end
	end)
end


local function playNormalSound()
	BlinkSoundischange = false
	local Whisper = part:FindFirstChild("Whisper")
	if Whisper then
		Whisper.PlaybackSpeed = 4.5 
		if not Whisper.IsPlaying then
			Whisper:Play()
		end
	end
end

local roomConnection
roomConnection = latestRoomValue.Changed:Connect(function()
	damge = false
	BlinkSoundischange = false
	if roomConnection then roomConnection:Disconnect() end
	if Blink and Blink.Parent then
		Blink:Destroy()
	end
end)

local particleold = part.Attachment.MainParticle
local particlenew = part.Attachment.AttackParticle

Close = task.spawn(function()
	local sound = part:FindFirstChild("Spawn")
	if sound then sound:Play() end

	while damge do
		if particleold then particleold.Enabled = true end
		if particlenew then particlenew.Enabled = false end

		playNormalSound() -- Bật âm thanh chuẩn

		task.wait(Random.new():NextInteger(3, 6))
		if not damge then break end

		if particleold then particleold.Enabled = false end
		if particlenew then particlenew.Enabled = true end

		part.Blink:Play()
		part.BlinkForeshadow:Play()

		startBlinkSoundLoop() 

		local character = LocalPlayer.Character
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local lastPos = hrp and hrp.Position or Vector3.new()

		local attackDuration = Random.new():NextNumber(3, 6)
		local startTime = tick()

		while (tick() - startTime < attackDuration) and damge do
			task.wait(0.75)

			character = LocalPlayer.Character
			hrp = character and character:FindFirstChild("HumanoidRootPart")
			humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if character and hrp and humanoid and humanoid.Health > 0 then
				local currentPos = hrp.Position
				if (currentPos - lastPos).Magnitude > 0.9 then
					humanoid:TakeDamage(10000)
					local death1 = Instance.new("Sound")
					death1.Parent = workspace
					death1.Name = "BlinkDie"
					death1.SoundId = "rbxassetid://5867708670"
					death1.Volume = 0.7
					death1.Pitch = 2
					local distort = Instance.new("DistortionSoundEffect")
					distort.Level = 0.9
					distort.Parent = death1
					local eq = Instance.new("EqualizerSoundEffect")
					eq.HighGain = -60
					eq.MidGain = 0
					eq.LowGain = 0
					eq.Parent = death1
					death1:Play()
					game:GetService("ReplicatedStorage").GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Blink"
					break
				end
				lastPos = currentPos
			end
		end
	end
end)
