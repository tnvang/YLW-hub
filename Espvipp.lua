--[[
    ================================================================
    DEBUG OVERLAY SYSTEM (BOX FIXED & OPTIMIZED) - ROBLOX STUDIO
    ================================================================
    Sửa lỗi:
    - Box Debug (Highlight) không bị mất sau thời gian dài hoặc khi tàng hình/respawn.
    - Quản lý Highlight tập trung, không vượt quá giới hạn 31 Highlight của Roblox.
    - Tự động phát hiện và gán lại Adornee nếu Character thay đổi Model.
    - Tối ưu bộ nhớ, ngắt kết nối hoàn toàn khi Character bị hủy/người chơi rời game.
    ================================================================
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--------------------------------------------------------------------------------
-- 1. CẤU HÌNH & TRẠNG THÁI (CONFIG & CACHE)
--------------------------------------------------------------------------------
local Config = {
	BoxEnabled = true,
	SkeletonEnabled = true,
	NameEnabled = true,
	HealthEnabled = true,
}

local Cache = {}

-- Folder chứa toàn bộ Highlight để tránh bị mất khi Character reset
local HighlightStorage = workspace:FindFirstChild("DebugHighlightStorage")
if not HighlightStorage then
	HighlightStorage = Instance.new("Folder")
	HighlightStorage.Name = "DebugHighlightStorage"
	HighlightStorage.Parent = workspace
end

--------------------------------------------------------------------------------
-- 2. RAINBOW WATERMARK
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- 3. HÀM DỌN DẸP BỘ NHỚ TRIỆT ĐỂ (CLEANUP)
--------------------------------------------------------------------------------
local function CleanPlayerESP(player)
	if Cache[player] then
		-- Ngắt tất cả các kết nối sự kiện
		if Cache[player].Connections then
			for _, conn in pairs(Cache[player].Connections) do
				if conn and conn.Connected then
					conn:Disconnect()
				end
			end
		end

		-- Hủy hoàn toàn các Instance đã tạo
		if Cache[player].Highlight then 
			Cache[player].Highlight:Destroy() 
		end
		if Cache[player].Billboard then 
			Cache[player].Billboard:Destroy() 
		end
		if Cache[player].SkeletonFolder then 
			Cache[player].SkeletonFolder:Destroy() 
		end

		Cache[player] = nil
	end
end

--------------------------------------------------------------------------------
-- 4. KHỞI TẠO & QUẢN LÝ ESP CHO NHÂN VẬT
--------------------------------------------------------------------------------
local function ApplyESP(player)
	if player == LocalPlayer then return end

	local function SetupCharacter(character)
		if not character then return end
		
		-- Dọn dẹp dữ liệu cũ của Player trước khi khởi tạo Character mới
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

		------------------------------------------------------------------------
		-- A. Box Debug (Cố định lỗi mất Highlight bằng HighlightStorage & Tracker)
		------------------------------------------------------------------------
		local highlight = Instance.new("Highlight")
		highlight.Name = "Debug_Box_" .. player.Name
		highlight.Adornee = character
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
		highlight.FillTransparency = 0.6
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.OutlineTransparency = 0.2
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Enabled = Config.BoxEnabled
		highlight.Parent = HighlightStorage -- Lưu vào Storage riêng để không bị xóa khi Character đổi Part
		data.Highlight = highlight

		-- Theo dõi liên tục tính hợp lệ của Highlight (Tránh bị đứt Adornee khi tàng hình/đổi Model)
		local highlightTracker = RunService.Heartbeat:Connect(function()
			if not character or not character.Parent or humanoid.Health <= 0 then
				if highlight then highlight.Enabled = false end
				return
			end

			if Config.BoxEnabled then
				if highlight.Adornee ~= character then
					highlight.Adornee = character
				end
				highlight.Enabled = true
			else
				highlight.Enabled = false
			end
		end)
		table.insert(data.Connections, highlightTracker)

		------------------------------------------------------------------------
		-- B. Name & Health Debug (BillboardGui)
		------------------------------------------------------------------------
		local bb = Instance.new("BillboardGui")
		bb.Name = "Debug_Info"
		bb.Adornee = head
		bb.Size = UDim2.new(0, 120, 0, 40)
		bb.StudsOffset = Vector3.new(0, 2.5, 0)
		bb.AlwaysOnTop = true
		bb.Parent = head
		data.Billboard = bb

		local container = Instance.new("Frame")
		container.Name = "Container"
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
			if not humanoid or humanoid.MaxHealth <= 0 then return end
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

		------------------------------------------------------------------------
		-- C. Skeleton Debug (Xương Khớp Màu Xanh Lá)
		------------------------------------------------------------------------
		local skelFolder = Instance.new("Folder")
		skelFolder.Name = "SkeletonLines"
		skelFolder.Parent = character
		data.SkeletonFolder = skelFolder

		local limbPairs = {
			-- R6
			{"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
			{"Torso", "Left Leg"}, {"Torso", "Right Leg"},
			-- R15
			{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
			{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
			{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
			{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
			{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
		}

		local lineHandles = {}

		local function InitSkeleton()
			for _, pair in ipairs(limbPairs) do
				local partA = character:FindFirstChild(pair[1])
				local partB = character:FindFirstChild(pair[2])

				if partA and partB then
					local handle = Instance.new("CylinderHandleAdornment")
					handle.Color3 = Color3.fromRGB(0, 255, 0)
					handle.AlwaysOnTop = true
					handle.ZIndex = 10
					handle.Transparency = 0.1
					handle.Radius = 0.035
					handle.Adornee = workspace
					handle.Visible = Config.SkeletonEnabled
					handle.Parent = skelFolder
					table.insert(lineHandles, {Handle = handle, PartA = partA, PartB = partB})
				end
			end
		end

		InitSkeleton()

		local skelConn = RunService.RenderStepped:Connect(function()
			if not character or not character.Parent or humanoid.Health <= 0 then return end

			if Config.SkeletonEnabled then
				for _, item in ipairs(lineHandles) do
					local partA = item.PartA
					local partB = item.PartB
					if partA and partB and partA.Parent and partB.Parent then
						local posA = partA.Position
						local posB = partB.Position
						local dist = (posA - posB).Magnitude

						item.Handle.Height = dist
						item.Handle.CFrame = CFrame.lookAt((posA + posB) / 2, posB) * CFrame.Angles(math.rad(90), 0, 0)
					end
				end
			end
		end)

		table.insert(data.Connections, skelConn)

		------------------------------------------------------------------------
		-- D. Lắng nghe sự kiện để Dọn dẹp/Khôi phục tự động
		------------------------------------------------------------------------
		table.insert(data.Connections, humanoid.Died:Connect(function()
			CleanPlayerESP(player)
		end))

		table.insert(data.Connections, character.AncestryChanged:Connect(function(_, parent)
			if not parent then
				CleanPlayerESP(player)
			end
		end))

		Cache[player] = data
	end

	if player.Character then
		SetupCharacter(player.Character)
	end

	local charConn = player.CharacterAdded:Connect(SetupCharacter)
	if not Cache[player] then Cache[player] = {Connections = {}} end
	table.insert(Cache[player].Connections, charConn)
end

--------------------------------------------------------------------------------
-- 5. CONTROL GUI (Dark Theme + Smooth Collapse/Expand)
--------------------------------------------------------------------------------
local function CreateControlGUI()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "DebugOverlayControlGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 180, 0, 170)
	MainFrame.Position = UDim2.new(0, 20, 0.4, 0)
	MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Active = true
	MainFrame.Parent = ScreenGui

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = MainFrame

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(1, 0, 0, 30)
	Title.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	Title.Text = "  DEBUG MENU"
	Title.TextColor3 = Color3.fromRGB(220, 220, 220)
	Title.Font = Enum.Font.SourceSansBold
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = MainFrame

	local TitleCorner = Instance.new("UICorner")
	TitleCorner.CornerRadius = UDim.new(0, 8)
	TitleCorner.Parent = Title

	local CollapseBtn = Instance.new("TextButton")
	CollapseBtn.Name = "CollapseBtn"
	CollapseBtn.Size = UDim2.new(0, 24, 0, 24)
	CollapseBtn.Position = UDim2.new(1, -27, 0, 3)
	CollapseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	CollapseBtn.Text = "-"
	CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CollapseBtn.Font = Enum.Font.SourceSansBold
	CollapseBtn.TextSize = 16
	CollapseBtn.Parent = Title

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 4)
	BtnCorner.Parent = CollapseBtn

	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Size = UDim2.new(1, 0, 1, -30)
	ContentContainer.Position = UDim2.new(0, 0, 0, 30)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Parent = MainFrame

	local isCollapsed = false
	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

	CollapseBtn.MouseButton1Click:Connect(function()
		isCollapsed = not isCollapsed
		CollapseBtn.Text = isCollapsed and "+" or "-"

		local targetSize = isCollapsed and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 170)
		TweenService:Create(MainFrame, tweenInfo, {Size = targetSize}):Play()
	end)

	local dragging, dragInput, dragStart, startPos
	Title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
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
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
		btn.Parent = ContentContainer

		local toggleCorner = Instance.new("UICorner")
		toggleCorner.CornerRadius = UDim.new(0, 4)
		toggleCorner.Parent = btn

		btn.MouseButton1Click:Connect(function()
			Config[stateKey] = not Config[stateKey]
			btn.Text = text .. ": " .. (Config[stateKey] and "ON" or "OFF")
			btn.BackgroundColor3 = Config[stateKey] and Color3.fromRGB(45, 125, 70) or Color3.fromRGB(60, 60, 70)
			callback(Config[stateKey])
		end)
	end

	CreateToggleButton("Box Debug", 8, "BoxEnabled", function(state)
		for _, data in pairs(Cache) do
			if data.Highlight then data.Highlight.Enabled = state end
		end
	end)

	CreateToggleButton("Skeleton Debug", 38, "SkeletonEnabled", function(state)
		for _, data in pairs(Cache) do
			if data.SkeletonFolder then
				for _, h in ipairs(data.SkeletonFolder:GetChildren()) do
					h.Visible = state
				end
			end
		end
	end)

	CreateToggleButton("Name Debug", 68, "NameEnabled", function(state)
		for _, data in pairs(Cache) do
			if data.Billboard and data.Billboard:FindFirstChild("Container") then
				local nameLabel = data.Billboard.Container:FindFirstChild("NameLabel")
				if nameLabel then nameLabel.Visible = state end
			end
		end
	end)

	CreateToggleButton("Health Debug", 98, "HealthEnabled", function(state)
		for _, data in pairs(Cache) do
			if data.Billboard and data.Billboard:FindFirstChild("Container") then
				local healthBg = data.Billboard.Container:FindFirstChild("HealthBg")
				if healthBg then healthBg.Visible = state end
			end
		end
	end)
end

--------------------------------------------------------------------------------
-- 6. KHỞI CHẠY HỆ THỐNG
--------------------------------------------------------------------------------
CreateWatermark()
CreateControlGUI()

for _, p in ipairs(Players:GetPlayers()) do
	ApplyESP(p)
end

Players.PlayerAdded:Connect(ApplyESP)
Players.PlayerRemoving:Connect(CleanPlayerESP)

