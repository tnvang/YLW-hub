local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local cornerGui = Instance.new("ScreenGui")
cornerGui.Name = "CornerTextGui"
cornerGui.ResetOnSpawn = false
cornerGui.Parent = PlayerGui

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
	label.Parent = cornerGui
end

local targetPlayer = nil
local followConnection = nil
local isCollapsed = false

local function getTargetRoot(player)
	if not player or not player.Character then return nil end
	local char = player.Character
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.SeatPart then
		return humanoid.SeatPart
	end
	return char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
end

local function stopFollowing()
	if followConnection then
		followConnection:Disconnect()
		followConnection = nil
	end
	targetPlayer = nil
	if LocalPlayer.Character then
		local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if myRoot then
			myRoot.Velocity = Vector3.zero
			myRoot.AssemblyLinearVelocity = Vector3.zero
		end
	end
end

local function startFollowing(player)
	if player == LocalPlayer then return end
	stopFollowing()
	targetPlayer = player

	followConnection = RunService.Heartbeat:Connect(function()
		if not targetPlayer or not targetPlayer.Parent then
			stopFollowing()
			return
		end

		local myChar = LocalPlayer.Character
		if not myChar then return end
		local myRoot = myChar:FindFirstChild("HumanoidRootPart")
		local myHumanoid = myChar:FindFirstChildOfClass("Humanoid")
		
		if not myRoot or not myHumanoid or myHumanoid.Health <= 0 then return end

		local targetRoot = getTargetRoot(targetPlayer)
		if targetRoot then
			local targetCFrame = targetRoot.CFrame * CFrame.new(0, 2, 4)
			myRoot.CFrame = myRoot.CFrame:Lerp(targetCFrame, 0.25)
			myRoot.Velocity = Vector3.zero
			myRoot.AssemblyLinearVelocity = Vector3.zero
		end
	end)
end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "PlayerTrackerGUI"
mainGui.ResetOnSpawn = false
mainGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 360)
mainFrame.Position = UDim2.new(0.5, -130, 0.4, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = mainGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Player Tracker"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.Parent = topBar

local collapseBtn = Instance.new("TextButton")
collapseBtn.Size = UDim2.new(0, 25, 0, 25)
collapseBtn.Position = UDim2.new(1, -30, 0, 5)
collapseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
collapseBtn.Text = "-"
collapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 16
collapseBtn.Parent = topBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 4)
collapseCorner.Parent = collapseBtn

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 30)
searchBox.Position = UDim2.new(0, 10, 0, 42)
searchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderText = "Tìm kiếm người chơi..."
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 12
searchBox.Parent = mainFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 6)
searchCorner.Parent = searchBox

local scrollList = Instance.new("ScrollingFrame")
scrollList.Size = UDim2.new(1, -20, 0, 200)
scrollList.Position = UDim2.new(0, 10, 0, 78)
scrollList.BackgroundTransparency = 1
scrollList.ScrollBarThickness = 4
scrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollList.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrollList

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end)

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0.47, 0, 0, 32)
refreshBtn.Position = UDim2.new(0, 10, 1, -40)
refreshBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 210)
refreshBtn.Text = "Refresh"
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 12
refreshBtn.Parent = mainFrame

local refreshCorner = Instance.new("UICorner")
refreshCorner.CornerRadius = UDim.new(0, 6)
refreshCorner.Parent = refreshBtn

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.47, 0, 0, 32)
stopBtn.Position = UDim2.new(0.53, 0, 1, -40)
stopBtn.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
stopBtn.Text = "Stop Follow"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 12
stopBtn.Parent = mainFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopBtn

local dragging, dragInput, dragStart, startPos

topBar.InputBegan:Connect(function(input)
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

topBar.InputChanged:Connect(function(input)
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

collapseBtn.MouseButton1Click:Connect(function()
	isCollapsed = not isCollapsed
	if isCollapsed then
		mainFrame:TweenSize(UDim2.new(0, 260, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
		collapseBtn.Text = "+"
	else
		mainFrame:TweenSize(UDim2.new(0, 260, 0, 360), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
		collapseBtn.Text = "-"
	end
end)

local function updatePlayerList()
	for _, child in ipairs(scrollList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	local filterText = string.lower(searchBox.Text)

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local pName = p.DisplayName .. " (@" .. p.Name .. ")"
			if filterText == "" or string.find(string.lower(pName), filterText) then
				local pBtn = Instance.new("TextButton")
				pBtn.Size = UDim2.new(1, 0, 0, 28)
				pBtn.BackgroundColor3 = (targetPlayer == p) and Color3.fromRGB(50, 150, 80) or Color3.fromRGB(40, 40, 48)
				pBtn.Text = "  " .. pName
				pBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
				pBtn.TextXAlignment = Enum.TextXAlignment.Left
				pBtn.Font = Enum.Font.Gotham
				pBtn.TextSize = 11
				pBtn.Parent = scrollList

				local btnCorner = Instance.new("UICorner")
				btnCorner.CornerRadius = UDim.new(0, 4)
				btnCorner.Parent = pBtn

				pBtn.MouseButton1Click:Connect(function()
					startFollowing(p)
					updatePlayerList()
				end)
			end
		end
	end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(updatePlayerList)

refreshBtn.MouseButton1Click:Connect(updatePlayerList)
stopBtn.MouseButton1Click:Connect(function()
	stopFollowing()
	updatePlayerList()
end)

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(player)
	if player == targetPlayer then
		stopFollowing()
	end
	updatePlayerList()
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
	if targetPlayer then
		task.wait(0.5)
		if targetPlayer and targetPlayer.Parent then
			startFollowing(targetPlayer)
		end
	end
end)

updatePlayerList()

