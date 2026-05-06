-- =============================================================================
-- TNVANGPREMIUM HUB - OPEN IMMEDIATELY EDITION (2026)
-- =============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Xóa Hub cũ nếu có để tránh trùng lặp
if player.PlayerGui:FindFirstChild("TnvangpremiumHub") then
	player.PlayerGui.TnvangpremiumHub:Destroy()
end

-- Tạo ScreenGui chính
local gui = Instance.new("ScreenGui")
gui.Name = "TnvangpremiumHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Variables quản lý trạng thái hệ thống
local currentSliderValue = 250
local flyEnabled = false
local flySpeed = 50
local godModeEnabled = false
local aimlockEnabled = false
local espEnabled = false
local selectedPlayerToTeleport = nil
local shieldForceField = nil
local bgMusic = nil
local espObjects = {}
local togglesList = {}

-- ==========================================
-- 1. GIAO DIỆN MENU CHÍNH (HIỆN NGAY LÚC CHẠY)
-- ==========================================
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 340, 0, 450)
menu.Position = UDim2.new(0.5, -170, 0.5, -225)
menu.BackgroundColor3 = Color3.fromRGB(20, 25, 35) -- Màu nền tối hiện đại giống ảnh mẫu
menu.Active = true
menu.Draggable = true -- Cho phép bạn kéo di chuyển vị trí trên màn hình cho đỡ vướng
menu.Parent = gui

local menuCorner = Instance.new("UICorner", menu)
menuCorner.CornerRadius = UDim.new(0, 12)

-- Viền màu xanh biển nhạt chuẩn yêu cầu
local stroke = Instance.new("UIStroke", menu)
stroke.Color = Color3.fromRGB(100, 200, 255)
stroke.Thickness = 3

-- Thanh tiêu đề hồng/đỏ bo góc như ảnh bạn thích
local header = Instance.new("Frame", menu)
header.Size = UDim2.new(1, -20, 0, 40)
header.Position = UDim2.new(0, 10, 0, 10)
header.BackgroundColor3 = Color3.fromRGB(240, 90, 120) -- Màu hồng đỏ giống ảnh mẫu
local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Tnvangpremium Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left

-- Nút Thu Nhỏ / Ẩn nhanh (-) ở góc thanh tiêu đề
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.Text = "-"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 24
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.BackgroundTransparency = 0.6
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Khung chứa nội dung cuộn bên dưới thanh tiêu đề
local container = Instance.new("ScrollingFrame", menu)
container.Size = UDim2.new(1, -20, 1, -70)
container.Position = UDim2.new(0, 10, 0, 60)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 980)
container.ScrollBarThickness = 5

local layout = Instance.new("UIListLayout", container)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)

-- Logic nút Thu Nhỏ menu ẩn/hiện
local menuOpen = true
closeBtn.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	if menuOpen then
		menu:TweenSize(UDim2.new(0, 340, 0, 450), "Out", "Quad", 0.3, true)
		container.Visible = true
		closeBtn.Text = "-"
	else
		menu:TweenSize(UDim2.new(0, 340, 0, 60), "Out", "Quad", 0.3, true)
		container.Visible = false
		closeBtn.Text = "+"
	end
end)

-- ==========================================
-- 2. HÀM TẠO TOGGLE & THANH KÉO SLIDER
-- ==========================================
local function createToggle(text, order, callback)
	local btn = Instance.new("TextButton", container)
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.Text = text .. " : OFF"
	btn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
	btn.TextColor3 = Color3.fromRGB(180, 190, 200)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 15
	btn.LayoutOrder = order
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	local toggleState = {Enabled = false}
	
	local function updateUI()
		if toggleState.Enabled then
			btn.Text = text .. " : ON"
			btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			btn.Text = text .. " : OFF"
			btn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
			btn.TextColor3 = Color3.fromRGB(180, 190, 200)
		end
	end
	
	btn.MouseButton1Click:Connect(function()
		toggleState.Enabled = not toggleState.Enabled
		updateUI()
		callback(toggleState.Enabled)
	end)
	
	toggleState.Reset = function()
		if toggleState.Enabled then
			toggleState.Enabled = false
			updateUI()
			callback(false)
		end
	end
	
	table.insert(togglesList, toggleState)
	return btn
end

-- Nút Reset tất cả đặt lên hàng đầu
local resetAllBtn = Instance.new("TextButton", container)
resetAllBtn.Size = UDim2.new(1, 0, 0, 35)
resetAllBtn.Text = "🔄 Reset Tất Cả Chức Năng (Sửa Lỗi)"
resetAllBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
resetAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetAllBtn.Font = Enum.Font.SourceSansBold
resetAllBtn.TextSize = 15
resetAllBtn.LayoutOrder = 0
Instance.new("UICorner", resetAllBtn).CornerRadius = UDim.new(0, 6)

-- Hệ thống thanh kéo Slider (1 - 500)
local sliderFrame = Instance.new("Frame", container)
sliderFrame.Size = UDim2.new(1, 0, 0, 60)
sliderFrame.BackgroundTransparency = 1
sliderFrame.LayoutOrder = 1

local sliderTitle = Instance.new("TextLabel", sliderFrame)
sliderTitle.Size = UDim2.new(1, 0, 0, 20)
sliderTitle.Text = "Thanh chỉnh giá trị chung (1 - 500): 250"
sliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderTitle.TextSize = 14
sliderTitle.BackgroundTransparency = 1

local sliderBar = Instance.new("Frame", sliderFrame)
sliderBar.Size = UDim2.new(1, -20, 0, 10)
sliderBar.Position = UDim2.new(0, 10, 0, 30)
sliderBar.BackgroundColor3 = Color3.fromRGB(50, 55, 65)
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)

local knob = Instance.new("Frame", sliderBar)
knob.Size = UDim2.new(0, 16, 0, 16)
knob.Position = UDim2.new(0.5, -8, 0.5, -8)
knob.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

local isDragging = false
local function updateSlider(input)
	local relativeX = input.Position.X - sliderBar.AbsolutePosition.X
	local percentage = math.clamp(relativeX / sliderBar.AbsoluteSize.X, 0, 1)
	knob.Position = UDim2.new(percentage, -knob.Size.X.Offset/2, 0.5, -knob.Size.Y.Offset/2)
	currentSliderValue = math.max(1, math.floor(percentage * 500))
	sliderTitle.Text = "Thanh chỉnh giá trị chung (1 - 500): " .. tostring(currentSliderValue)
end

sliderBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = true
		updateSlider(input)
		local moveCon, endCon
		moveCon = UserInputService.InputChanged:Connect(function(changed)
			if isDragging and (changed.UserInputType == Enum.UserInputType.MouseMovement or changed.UserInputType == Enum.UserInputType.Touch) then
				updateSlider(changed)
			end
		end)
		endCon = UserInputService.InputEnded:Connect(function(ended)
			if ended.UserInputType == Enum.UserInputType.MouseButton1 or ended.UserInputType == Enum.UserInputType.Touch then
				isDragging = false
				moveCon:Disconnect()
				endCon:Disconnect()
			end
		end)
	end
end)

-- ==========================================
-- 3. TRIỂN KHAI LOGIC TOÀN BỘ CHỨC NĂNG
-- ==========================================

createToggle("Áp dụng Hitbox khủng", 2, function(state)
	_G.HitboxLoop = state
	task.spawn(function()
		while _G.HitboxLoop do
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					p.Character.HumanoidRootPart.Size = Vector3.new(currentSliderValue/10, currentSliderValue/10, currentSliderValue/10)
					p.Character.HumanoidRootPart.Transparency = 0.7
					p.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
					p.Character.HumanoidRootPart.CanCollide = false
				end
			end
			for _, v in pairs(Workspace:GetDescendants()) do
				if v:IsA("Humanoid") and v.Parent ~= player.Character and not Players:GetPlayerFromCharacter(v.Parent) then
					local hrp = v.Parent:FindFirstChild("HumanoidRootPart") or v.Parent:FindFirstChild("Head")
					if hrp then
						hrp.Size = Vector3.new(currentSliderValue/10, currentSliderValue/10, currentSliderValue/10)
						hrp.Transparency = 0.7
					end
				end
			end
			task.wait(1)
		end
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
				p.Character.HumanoidRootPart.Transparency = 1
			end
		end
	end)
end)

createToggle("Kích hoạt Chạy Nhanh", 3, function(state)
	_G.SpeedLoop = state
	task.spawn(function()
		while _G.SpeedLoop do
			if player.Character and player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid.WalkSpeed = currentSliderValue
			end
			task.wait(0.1)
		end
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = 16
		end
	end)
end)

createToggle("Kích hoạt Nhảy Cao", 4, function(state)
	_G.JumpLoop = state
	task.spawn(function()
		while _G.JumpLoop do
			if player.Character and player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid.JumpPower = currentSliderValue
				player.Character.Humanoid.UseJumpPower = true
			end
			task.wait(0.1)
		end
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.JumpPower = 50
		end
	end)
end)

createToggle("Nút Bay (Fly Mode)", 5, function(state)
	flyEnabled = state
	if flyEnabled then
		task.spawn(function()
			local torso = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
			if not torso then return end
			local bv = Instance.new("BodyVelocity", torso)
			bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bv.Velocity = Vector3.new(0,0,0)
			
			while flyEnabled and torso and torso.Parent do
				flySpeed = currentSliderValue
				local camCF = camera.CFrame
				local vel = Vector3.new(0,0,0)
				
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + camCF.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - camCF.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - camCF.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + camCF.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,1,0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0,1,0) end
				
				bv.Velocity = vel.Unit * flySpeed
				if vel == Vector3.new(0,0,0) then bv.Velocity = Vector3.new(0,0.1,0) end
				task.wait()
			end
			if bv then bv:Destroy() end
		end)
	end
end)

-- Khung chọn người chơi Teleport
local tpFrame = Instance.new("Frame", container)
tpFrame.Size = UDim2.new(1, 0, 0, 75)
tpFrame.BackgroundTransparency = 1
tpFrame.LayoutOrder = 6

local selectPlayerBtn = Instance.new("TextButton", tpFrame)
selectPlayerBtn.Size = UDim2.new(1, 0, 0, 30)
selectPlayerBtn.Text = "Chọn người chơi: [Bấm đổi tên]"
selectPlayerBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
selectPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", selectPlayerBtn).CornerRadius = UDim.new(0, 6)

local tpBtn = Instance.new("TextButton", tpFrame)
tpBtn.Size = UDim2.new(1, 0, 0, 35)
tpBtn.Position = UDim2.new(0, 0, 0, 38)
tpBtn.Text = "⚡ Bay Đến Người Chơi Này"
tpBtn.BackgroundColor3 = Color3.fromRGB(230, 140, 10)
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

selectPlayerBtn.MouseButton1Click:Connect(function()
	local allPlayers = Players:GetPlayers()
	if #allPlayers <= 1 then selectPlayerBtn.Text = "Server trống trơn!" return end
	local currentIndex = 1
	for i, p in ipairs(allPlayers) do if p == selectedPlayerToTeleport then currentIndex = i break end end
	local nextIndex = currentIndex + 1
	if nextIndex > #allPlayers then nextIndex = 1 end
	if allPlayers[nextIndex] == player then nextIndex = nextIndex + 1 end
	if nextIndex > #allPlayers then nextIndex = 1 end
	selectedPlayerToTeleport = allPlayers[nextIndex]
	if selectedPlayerToTeleport then selectPlayerBtn.Text = "Mục tiêu: " .. selectedPlayerToTeleport.Name end
end)

tpBtn.MouseButton1Click:Connect(function()
	if selectedPlayerToTeleport and selectedPlayerToTeleport.Character and selectedPlayerToTeleport.Character:FindFirstChild("HumanoidRootPart") then
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.CFrame = selectedPlayerToTeleport.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
		end
	end
end)

createToggle("Nút Bảo Vệ (Bật Khiên Ảo)", 7, function(state)
	godModeEnabled = state
	if godModeEnabled then
		task.spawn(function()
			while godModeEnabled do
				if player.Character and not player.Character:FindFirstChildOfClass("ForceField") then
					shieldForceField = Instance.new("ForceField", player.Character)
					shieldForceField.Visible = true
				end
				task.wait(0.5)
			end
		end)
	else
		if shieldForceField then shieldForceField:Destroy() end
		if player.Character and player.Character:FindFirstChildOfClass("ForceField") then
			player.Character:FindFirstChildOfClass("ForceField"):Destroy()
		end
	end
end)

local function getClosestTarget()
	local closestTarget = nil
	local shortestDistance = math.huge
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
			local pos, onScreen = camera:WorldToViewportPoint(p.Character.Head.Position)
			if onScreen then
				local mousePos = UserInputService:GetMouseLocation()
				local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
				if distance < shortestDistance then closestTarget = p.Character.Head shortestDistance = distance end
			end
		end
	end
	for _, v in pairs(Workspace:GetDescendants()) do
		if v:IsA("Humanoid") and v.Parent ~= player.Character and not Players:GetPlayerFromCharacter(v.Parent) then
			local head = v.Parent:FindFirstChild("Head")
			if head then
				local pos, onScreen = camera:WorldToViewportPoint(head.Position)
				if onScreen then
					local mousePos = UserInputService:GetMouseLocation()
					local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
					if distance < shortestDistance then closestTarget = head shortestDistance = distance end
				end
			end
		end
	end
	return closestTarget
end

createToggle("Nút Aim Ghim Đầu (Aimlock)", 8, function(state)
	aimlockEnabled = state
	if aimlockEnabled then
		RunService:BindToRenderStep("TnvangpremiumAim", Enum.RenderPriority.Camera.Value, function()
			if aimlockEnabled then
				local target = getClosestTarget()
				if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) end
			end
		end)
	else
		RunService:UnbindFromRenderStep("TnvangpremiumAim")
	end
end)

local function createESP(p)
	if p == player then return end
	p.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		if not espEnabled then return end
		local head = char:WaitForChild("Head", 5)
		if head and not head:FindFirstChild("ESPTag") then
			local bb = Instance.new("BillboardGui", head)
			bb.Name = "ESPTag"
			bb.AlwaysOnTop = true
			bb.Size = UDim2.new(0, 100, 0, 30)
			bb.StudsOffset = Vector3.new(0, 2, 0)
			local txt = Instance.new("TextLabel", bb)
			txt.Size = UDim2.new(1, 0, 1, 0)
			txt.BackgroundTransparency = 1
			txt.Text = p.Name
			txt.TextColor3 = Color3.fromRGB(255, 255, 255)
			txt.Font = Enum.Font.SourceSansBold
			txt.TextSize = 14
			table.insert(espObjects, bb)
		end
	end)
end

createToggle("Nút Hiện ESP Tên (Màu Trắng)", 9, function(state)
	espEnabled = state
	if espEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
				local head = p.Character.Head
				if not head:FindFirstChild("ESPTag") then
					local bb = Instance.new("BillboardGui", head)
					bb.Name = "ESPTag"
					bb.AlwaysOnTop = true
					bb.Size = UDim2.new(0, 100, 0, 30)
					bb.StudsOffset = Vector3.new(0, 2, 0)
					local txt = Instance.new("TextLabel", bb)
					txt.Size = UDim2.new(1, 0, 1, 0)
					txt.BackgroundTransparency = 1
					txt.Text = p.Name
					txt.TextColor3 = Color3.fromRGB(255, 255, 255)
					txt.Font = Enum.Font.SourceSansBold
					txt.TextSize = 14
					table.insert(espObjects, bb)
				end
			end
			createESP(p)
		end
		Players.PlayerAdded:Connect(createESP)
	else
		for _, obj in pairs(espObjects) do if obj then obj:Destroy() end end
		espObjects = {}
		for _, p in pairs(Players:GetPlayers()) do
			if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESPTag") then
				p.Character.Head.ESPTag:Destroy()
			end
		end
	end
end)

createToggle("Bật/Tắt Nhạc Nền", 10, function(state)
	if state then
		if not bgMusic then
			bgMusic = Instance.new("Sound", SoundService)
			bgMusic.SoundId = "rbxassetid://1837879717"
			bgMusic.Volume = 0.4
			bgMusic.Looped = true
		end
		bgMusic:Play()
	else
		if bgMusic then bgMusic:Stop() end
	end
end)

createToggle("Hiện Bảng Điểm Map", 11, function(state)
	pcall(function()
		local scoreboard = player.PlayerGui:FindFirstChild("Scoreboard", true) or player.PlayerGui:FindFirstChild("Leaderboard", true)
		if scoreboard then scoreboard.Enabled = state end
	end)
end)

createToggle("Đổi Màu Nhân Vật (Neon)", 12, function(state)
	_G.ColorLoop = state
	task.spawn(function()
		while _G.ColorLoop do
			if player.Character then
				for _, part in pairs(player.Character:GetChildren()) do
					if part:IsA("BasePart") then part.Color = Color3.fromRGB(0, 255, 120) part.Material = Enum.Material.Neon end
				end
			end
			task.wait(0.5)
		end
		if player.Character then
			for _, part in pairs(player.Character:GetChildren()) do
				if part:IsA("BasePart") then part.Color = Color3.fromRGB(255, 255, 255) part.Material = Enum.Material.Plastic end
			end
		end
	end)
end)

createToggle("Kích hoạt Anti-Ban (Bypass)", 13, function(state)
	_G.AntiBanEnabled = state
	if state then
		pcall(function()
			local namecall
			namecall = hookmetamethod(game, "__namecall", function(self, ...)
				local method = getnamecallmethod()
				if _G.AntiBanEnabled and (string.find(string.lower(method), "kick") or string.find(string.lower(method), "ban") or string.find(string.lower(method), "report") or string.find(string.lower(method), "log")) then return nil end
				return namecall(self, ...)
			end)
			local index
			index = hookmetamethod(game, "__index", function(self, key)
				if _G.AntiBanEnabled and not checkcaller() and self:IsA("Humanoid") then
					if key == "WalkSpeed" then return 16 elseif key == "JumpPower" then return 50 end
				end
				return index(self, key)
			end)
		end)
	end
end)

-- ==========================================
-- 4. LOGIC RESET TẤT CẢ CHỨC NĂNG
-- ==========================================
resetAllBtn.MouseButton1Click:Connect(function()
	for _, toggle in pairs(togglesList) do toggle.Reset() end
	pcall(function()
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			local hum = p Rằng
