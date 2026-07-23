-- ========================================================
-- 1. CHẠY NGẦM ĐOẠN MÃ CORNER TEXT
-- ========================================================
task.spawn(function()
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	-- Kiểm tra nếu đã tồn tại thì xóa cái cũ để tránh trùng lặp
	if playerGui:FindFirstChild("CornerText") then
		playerGui.CornerText:Destroy()
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "CornerText"
	gui.ResetOnSpawn = false
	gui.Parent = playerGui

	local corners = {
		UDim2.new(0, 8, 0, 8),
		UDim2.new(1, -8, 0, 8),
		UDim2.new(0, 8, 1, -28),
		UDim2.new(1, -8, 1, -28)
	}

	for i, pos in ipairs(corners) do
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0, 100, 0, 18)
		label.Position = pos
		label.AnchorPoint = Vector2.new((i == 2 or i == 4) and 1 or 0, 0)
		label.BackgroundTransparency = 1
		label.Text = "Nhân gay sitke"
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextStrokeTransparency = 0
		label.TextScaled = false
		label.TextSize = 12
		label.Font = Enum.Font.GothamBold
		label.Parent = gui
	end
end)

-- ========================================================
-- 2. TẠO GUI FOLLOW PLAYER CONTROL
-- ========================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
LocalPlayer = Players.LocalPlayer

local targetPlayer = nil
local followConnection = nil

-- Tự động dọn dẹp GUI cũ nếu re-execute
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("FollowGUI") then
	CoreGui.FollowGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FollowGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 310)
mainFrame.Position = UDim2.new(0.5, -110, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar (Thanh Kéo Thả)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Player Follower"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 13
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Nút Thu Gọn GUI
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -28, 0, 4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minimizeBtn

-- Status Bar
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -16, 0, 20)
statusLabel.Position = UDim2.new(0, 8, 0, 36)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Trạng thái: Đang rảnh"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Nút Stop Follow
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, -16, 0, 28)
stopBtn.Position = UDim2.new(0, 8, 0, 60)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.Text = "Stop Follow"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 12
stopBtn.Parent = mainFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopBtn

-- Nút Refresh
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(1, -16, 0, 28)
refreshBtn.Position = UDim2.new(0, 8, 0, 94)
refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
refreshBtn.Text = "Refresh Danh Sách"
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 12
refreshBtn.Parent = mainFrame

local refCorner = Instance.new("UICorner")
refCorner.CornerRadius = UDim.new(0, 6)
refCorner.Parent = refreshBtn

-- Danh sách người chơi (ScrollFrame)
local scrollList = Instance.new("ScrollingFrame")
scrollList.Size = UDim2.new(1, -16, 1, -134)
scrollList.Position = UDim2.new(0, 8, 0, 128)
scrollList.BackgroundTransparency = 1
scrollList.BorderSizePixel = 0
scrollList.ScrollBarThickness = 4
scrollList.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrollList

-- ========================================================
-- 3. XỬ LÝ CHỨC NĂNG (LOGIC)
-- ========================================================

-- Dừng bay theo
local function stopFollowing()
	if followConnection then
		followConnection:Disconnect()
		followConnection = nil
	end
	targetPlayer = nil
	statusLabel.Text = "Trạng thái: Đang rảnh"
	statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
end

-- Bắt đầu bay theo mục tiêu
local function startFollowing(plr)
	if plr == LocalPlayer then return end
	stopFollowing()
	
	targetPlayer = plr
	statusLabel.Text = "Đang bay theo: " .. plr.DisplayName
	statusLabel.TextColor3 = Color3.fromRGB(50, 220, 100)

	followConnection = RunService.Heartbeat:Connect(function()
		if not targetPlayer or not targetPlayer.Parent then
			statusLabel.Text = "Mục tiêu đã rời server!"
			statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
			stopFollowing()
			return
		end

		local myChar = LocalPlayer.Character
		local targetChar = targetPlayer.Character

		if myChar and targetChar then
			local myHRP = myChar:FindFirstChild("HumanoidRootPart")
			local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")

			if myHRP and targetHRP then
				-- Đặt vị trí phía sau/trên đầu mục tiêu một chút
				myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 2, 3)
				myHRP.Velocity = Vector3.new(0, 0, 0) -- Giảm quán tính trôi
			end
		end
	end)
end

-- Tải/Cập nhật danh sách người chơi
local function updatePlayerList()
	for _, child in ipairs(scrollList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -6, 0, 26)
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
			btn.Text = "  " .. plr.DisplayName .. " (@" .. plr.Name .. ")"
			btn.TextColor3 = Color3.fromRGB(220, 220, 220)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 11
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.Parent = scrollList

			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 4)
			btnCorner.Parent = btn

			btn.MouseButton1Click:Connect(function()
				startFollowing(plr)
			end)
		end
	end
	
	scrollList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

-- Sự kiện Nút Bấm
stopBtn.MouseButton1Click:Connect(stopFollowing)
refreshBtn.MouseButton1Click:Connect(updatePlayerList)

-- Tự động ngưng bay khi người chơi mục tiêu thoát
Players.PlayerRemoving:Connect(function(plr)
	if plr == targetPlayer then
		statusLabel.Text = plr.DisplayName .. " đã rời server!"
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		stopFollowing()
	end
	task.wait(0.5)
	updatePlayerList()
end)

Players.PlayerAdded:Connect(function()
	task.wait(0.5)
	updatePlayerList()
end)

-- Thu gọn / Mở rộng GUI
local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		mainFrame:TweenSize(UDim2.new(0, 220, 0, 32), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
		minimizeBtn.Text = "+"
	else
		mainFrame:TweenSize(UDim2.new(0, 220, 0, 310), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
		minimizeBtn.Text = "-"
	end
end)

-- ========================================================
-- 4. TÍNH NĂNG KÉO THẢ (DRAGGABLE - HỖ TRỢ MOBILE)
-- ========================================================
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Cập nhật danh sách lần đầu tiên
updatePlayerList()

