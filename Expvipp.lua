local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Config = {
	BoxEnabled = true,
	SkeletonEnabled = true,
	NameEnabled = true,
	HealthEnabled = true,
}

local Cache = {}

local function CreateWatermark()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "DebugWatermarkGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 999
	ScreenGui.Parent = PlayerGui

	local Label = Instance.new("TextLabel")
	Label.Name = "Watermark"
	Label.Size = UDim2.new(0, 150, 0, 25)
	Label.Position = UDim2.new(1, -160, 0, 10)
	Label.BackgroundTransparency = 1
	Label.Text = "Tn Vàn dz"
	Label.Font = Enum.Font.FredokaOne
	Label.TextSize = 16
	Label.TextXAlignment = Enum.TextXAlignment.Right
	Label.Parent = ScreenGui

	local hue = 0
	RunService.RenderStepped:Connect(function(delta)
		hue = (hue + delta * 0.3) % 1
		Label.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
	end)
end

local function CleanPlayerESP(player)
	if Cache[player] then
		if Cache[player].Highlight then Cache[player].Highlight:Destroy() end
		if Cache[player].Billboard then Cache[player].Billboard:Destroy() end
		if Cache[player].SkeletonFolder then Cache[player].SkeletonFolder:Destroy() end
		if Cache[player].Connections then
			for _, conn in pairs(Cache[player].Connections) do
				conn:Disconnect()
			end
		end
		Cache[player] = nil
	end
end

local function ApplyESP(player)
	if player == LocalPlayer then return end

	local function SetupCharacter(character)
		if not character then return end
		CleanPlayerESP(player)

		local humanoid = character:WaitForChild("Humanoid", 5)
		local rootPart = character:WaitForChild("HumanoidRootPart", 5)
		local head = character:WaitForChild("Head", 5)

		if not humanoid or not rootPart or not head then return end

		local data = {
			Connections = {},
			Highlight = nil,
			Billboard = nil,
			SkeletonFolder = nil,
		}

		local highlight = Instance.new("Highlight")
		highlight.Name = "Debug_Box"
		highlight.Adornee = character
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
		highlight.FillTransparency = 0.6
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.OutlineTransparency = 0.2
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Enabled = Config.BoxEnabled
		highlight.Parent = character
		data.Highlight = highlight

		local bb = Instance.new("BillboardGui")
		bb.Name = "Debug_Info"
		bb.Adornee = head
		bb.Size = UDim2.new(0, 120, 0, 40)
		bb.StudsOffset = Vector3.new(0, 2.5, 0)
		bb.AlwaysOnTop = true
		bb.Parent = head
		data.Billboard = bb

		local container = Instance.new("Frame")
		container.Size = UDim2.new(1, 0, 1, 0)
		container.BackgroundTransparency = 1
		container.Parent = bb

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Name = "NameLabel"
		nameLabel.Size = UDim2.new(1, 0, 0, 18)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = player.DisplayName
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.TextStrokeTransparency = 0.2
		nameLabel.Font = Enum.Font.SourceSansBold
		nameLabel.TextSize = 13
		nameLabel.Visible = Config.NameEnabled
		nameLabel.Parent = container

		local healthBg = Instance.new("Frame")
		healthBg.Name = "HealthBg"
		healthBg.Size = UDim2.new(0, 80, 0, 5)
		healthBg.Position = UDim2.new(0.5, -40, 0, 20)
		healthBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		healthBg.BorderSizePixel = 0
		healthBg.Visible = Config.HealthEnabled
		healthBg.Parent = container

		local healthBgCorner = Instance.new("UICorner")
		healthBgCorner.CornerRadius = UDim.new(0, 2)
		healthBgCorner.Parent = healthBg

		local healthBar = Instance.new("Frame")
		healthBar.Name = "HealthBar"
		healthBar.Size = UDim2.new(1, 0, 1, 0)
		healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		healthBar.BorderSizePixel = 0
		healthBar.Parent = healthBg

		local healthBarCorner = Instance.new("UICorner")
		healthBarCorner.CornerRadius = UDim.new(0, 2)
		healthBarCorner.Parent = healthBar

		local function UpdateHealth()
			local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
			healthBar.Size = UDim2.new(percent, 0, 1, 0)

			if percent > 0.5 then
				healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0):Lerp(Color3.fromRGB(255, 255, 0), (1 - percent) * 2)
			else
				healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0):Lerp(Color3.fromRGB(255, 0, 0), (0.5 - percent) * 2)
			end
		end

		table.insert(data.Connections, humanoid.HealthChanged:Connect(UpdateHealth))
		UpdateHealth()

		local skelFolder = Instance.new("Folder")
		skelFolder.Name = "SkeletonLines"
		skelFolder.Parent = character
		data.SkeletonFolder = skelFolder

		local limbPairs = {
			{"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
			{"Torso", "Left Leg"}, {"Torso", "Right Leg"},
			{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
			{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
			{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
			{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
			{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
		}

		local lineHandles = {}

		local function CreateSkeleton()
			for _, pair in ipairs(limbPairs) do
				local partA = character:FindFirstChild(pair[1])
				local partB = character:FindFirstChild(pair[2])

				if partA and partB then
					local handle = Instance.new("CylinderHandleAdornment")
					handle.Color3 = Color3.fromRGB(0, 255, 0)
					handle.AlwaysOnTop = true
					handle.Transparency = 0.2
					handle.Radius = 0.08
					handle.Adornee = workspace
					handle.Visible = Config.SkeletonEnabled
					handle.Parent = skelFolder
					table.insert(lineHandles, {Handle = handle, PartA = partA, PartB = partB})
				end
			end
		end

		CreateSkeleton()

		local skelConn = RunService.RenderStepped:Connect(function()
			if not character or not character.Parent or humanoid.Health <= 0 then return end
			
			if Config.SkeletonEnabled then
				for _, item in ipairs(lineHandles) do
					if item.PartA and item.PartB then
						local posA = item.PartA.Position
						local posB = item.PartB.Position
						local dist = (posA - posB).Magnitude

						item.Handle.Height = dist
						item.Handle.CFrame = CFrame.lookAt((posA + posB) / 2, posB) * CFrame.Angles(math.rad(90), 0, 0)
					end
				end
			end
		end)

		table.insert(data.Connections, skelConn)
		Cache[player] = data
	end

	if player.Character then
		SetupCharacter(player.Character)
	end
	player.CharacterAdded:Connect(SetupCharacter)
end

local function CreateControlGUI()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "DebugOverlayControlGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	local Frame = Instance.new("Frame")
	Frame.Name = "MainFrame"
	Frame.Size = UDim2.new(0, 180, 0, 170)
	Frame.Position = UDim2.new(0, 20, 0.4, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Parent = ScreenGui

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Frame

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, 0, 0, 30)
	Title.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	Title.Text = "DEBUG MENU"
	Title.TextColor3 = Color3.fromRGB(220, 220, 220)
	Title.Font = Enum.Font.SourceSansBold
	Title.TextSize = 14
	Title.Parent = Frame

	local TitleCorner = Instance.new("UICorner")
	TitleCorner.CornerRadius = UDim.new(0, 8)
	TitleCorner.Parent = Title

	local dragging, dragInput, dragStart, startPos
	Title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	Title.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local function CreateToggleButton(text, posY, stateKey, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.9, 0, 0, 25)
		btn.Position = UDim2.new(0.05, 0, 0, posY)
		btn.BackgroundColor3 = Config[stateKey] and Color3.fromRGB(45, 125, 70) or Color3.fromRGB(60, 60, 70)
		btn.Text = text .. ": " .. (Config[stateKey] and "ON" or "OFF")
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Font = Enum.Font.SourceSansSemibold
		btn.TextSize = 13
		btn.Parent = Frame

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 4)
		btnCorner.Parent = btn

		btn.MouseButton1Click:Connect(function()
			Config[stateKey] = not Config[stateKey]
			btn.Text = text .. ": " .. (Config[stateKey] and "ON" or "OFF")
			btn.BackgroundColor3 = Config[stateKey] and Color3.fromRGB(45, 125, 70) or Color3.fromRGB(60, 60, 70)
			callback(Config[stateKey])
		end)
	end

	CreateToggleButton("Box Debug", 38, "BoxEnabled", function(state)
		for _, data in pairs(Cache) do
			if data.Highlight then data.Highlight.Enabled = state end
		end
	end)

	CreateToggleButton("Skeleton Debug", 68, "SkeletonEnabled", function(state)
		for _, data in pairs(Cache) do
			if data.SkeletonFolder then
				for _, h in ipairs(data.SkeletonFolder:GetChildren()) do
					h.Visible = state
				end
			end
		end
	end)

	CreateToggleButton("Name Debug", 98, "NameEnabled", function(state)
		for _, data in pairs(Cache) do
			if data.Billboard and data.Billboard:FindFirstChild("Frame") then
				local nameLabel = data.Billboard.Frame:FindFirstChild("NameLabel")
				if nameLabel then nameLabel.Visible = state end
			end
		end
	end)

	CreateToggleButton("Health Debug", 128, "HealthEnabled", function(state)
		for _, data in pairs(Cache) do
			if data.Billboard and data.Billboard:FindFirstChild("Frame") then
				local healthBg = data.Billboard.Frame:FindFirstChild("HealthBg")
				if healthBg then healthBg.Visible = state end
			end
		end
	end)
end

CreateWatermark()
CreateControlGUI()

for _, p in ipairs(Players:GetPlayers()) do
	ApplyESP(p)
end

Players.PlayerAdded:Connect(ApplyESP)
Players.PlayerRemoving:Connect(CleanPlayerESP)

