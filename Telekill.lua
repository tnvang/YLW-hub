local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TelekillGui"
ScreenGui.ResetOnSpawn = false
local success, err = pcall(function()
	ScreenGui.Parent = CoreGui
end)
if not success then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0, 50, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.BorderColor3 = Color3.fromRGB(80, 80, 80)
ToggleButton.BorderSizePixel = 2
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = ToggleButton

local function createCornerLabel(pos)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 200, 0, 50)
	lbl.Position = pos
	lbl.BackgroundTransparency = 1
	lbl.Text = "Tn Vàn dz"
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextSize = 20
	lbl.Font = Enum.Font.SourceSansBold
	lbl.TextStrokeTransparency = 0.5
	lbl.Parent = ScreenGui
	return lbl
end

local labels = {
	createCornerLabel(UDim2.new(0, 20, 0, 20)),
	createCornerLabel(UDim2.new(1, -220, 0, 20)),
	createCornerLabel(UDim2.new(0, 20, 1, -70)),
	createCornerLabel(UDim2.new(1, -220, 1, -70))
}

local CenterLabel = Instance.new("TextLabel")
CenterLabel.Size = UDim2.new(0, 600, 0, 100)
CenterLabel.Position = UDim2.new(0.5, -300, 0.4, -50)
CenterLabel.BackgroundTransparency = 1
CenterLabel.Text = "Tn Vàn dz"
CenterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CenterLabel.TextSize = 50
CenterLabel.Font = Enum.Font.SourceSansBold
CenterLabel.TextStrokeTransparency = 0.3
CenterLabel.Visible = false
CenterLabel.Parent = ScreenGui

local isEnabled = false
local currentTarget = nil

ToggleButton.MouseButton1Click:Connect(function()
	isEnabled = not isEnabled
	if isEnabled then
		ToggleButton.Text = "ON"
		ToggleButton.TextColor3 = Color3.fromRGB(50, 255, 50)
		for _, lbl in ipairs(labels) do
			lbl.Visible = false
		end
		CenterLabel.Visible = true
	else
		ToggleButton.Text = "OFF"
		ToggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
		for _, lbl in ipairs(labels) do
			lbl.Visible = true
		end
		CenterLabel.Visible = false
		currentTarget = nil
	end
end)

RunService.RenderStepped:Connect(function()
	local tickVal = tick() * 2
	local rainbowColor = Color3.fromHSV(tickVal % 1, 1, 1)

	if not isEnabled then
		for _, lbl in ipairs(labels) do
			lbl.TextColor3 = rainbowColor
		end
	else
		CenterLabel.TextColor3 = rainbowColor
	end
end)

local function isValidTarget(player)
	if player == LocalPlayer then return false end
	if not player.Character then return false end
	
	local char = player.Character
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local rootPart = char:FindFirstChild("HumanoidRootPart")
	
	if not humanoid or humanoid.Health <= 0 then return false end
	if not rootPart then return false end
	
	if rootPart.Position.Y < -500 then return false end
	
	return true
end

local function getClosestTarget()
	local closestPlayer = nil
	local shortestDistance = math.huge
	local myChar = LocalPlayer.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
	local myRoot = myChar.HumanoidRootPart

	for _, player in ipairs(Players:GetPlayers()) do
		if isValidTarget(player) then
			local targetRoot = player.Character.HumanoidRootPart
			local distance = (targetRoot.Position - myRoot.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closestPlayer = player
			end
		end
	end

	return closestPlayer
end

RunService.Heartbeat:Connect(function()
	if not isEnabled then return end

	local myChar = LocalPlayer.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
	local myRoot = myChar.HumanoidRootPart
	local myHumanoid = myChar:FindFirstChildOfClass("Humanoid")
	if not myHumanoid or myHumanoid.Health <= 0 then return end

	if not isValidTarget(currentTarget) then
		currentTarget = getClosestTarget()
	end

	if currentTarget and currentTarget.Character then
		local targetRoot = currentTarget.Character:FindFirstChild("HumanoidRootPart")
		local targetHumanoid = currentTarget.Character:FindFirstChildOfClass("Humanoid")

		if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
			myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
			
			pcall(function()
				local tool = myChar:FindFirstChildOfClass("Tool")
				if tool then
					tool:Activate()
				end
			end)
		else
			currentTarget = nil
		end
	end
end)
p
