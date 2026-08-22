local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("CustomLuxuryMenu") then
	CoreGui:FindFirstChild("CustomLuxuryMenu"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomLuxuryMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(245, 215, 110)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 235, 150)
MainStroke.Thickness = 3
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 225, 120)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 195, 90)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 170, 70))
})
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

local HeaderContainer = Instance.new("Frame")
HeaderContainer.Size = UDim2.new(1, 0, 0, 70)
HeaderContainer.BackgroundTransparency = 1
HeaderContainer.Parent = MainFrame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 50, 0, 50)
AvatarImage.Position = UDim2.new(0, 15, 0, 10)
AvatarImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AvatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
AvatarImage.Parent = HeaderContainer

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

local UserNameLabel = Instance.new("TextLabel")
UserNameLabel.Size = UDim2.new(0, 300, 0, 25)
UserNameLabel.Position = UDim2.new(0, 75, 0, 12)
UserNameLabel.BackgroundTransparency = 1
UserNameLabel.Font = Enum.Font.FredokaOne
UserNameLabel.Text = LocalPlayer.Name
UserNameLabel.TextColor3 = Color3.fromRGB(32, 178, 170)
UserNameLabel.TextSize = 22
UserNameLabel.TextXAlignment = Enum.TextXAlignment.Left
UserNameLabel.Parent = HeaderContainer

local AuthorLabel = Instance.new("TextLabel")
AuthorLabel.Size = UDim2.new(0, 300, 0, 20)
AuthorLabel.Position = UDim2.new(0, 75, 0, 38)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Font = Enum.Font.FredokaOne
AuthorLabel.Text = "Tvàn x viet69 Presents"
AuthorLabel.TextColor3 = Color3.fromRGB(100, 120, 110)
AuthorLabel.TextSize = 13
AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
AuthorLabel.Parent = HeaderContainer

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0.9, 0, 0, 32)
TabContainer.Position = UDim2.new(0.05, 0, 0, 80)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = TabContainer

local function CreateTabButton(name, isActive)
	local TabBtn = Instance.new("TextButton")
	TabBtn.Size = UDim2.new(0, 150, 1, 0)
	TabBtn.BackgroundColor3 = isActive and Color3.fromRGB(32, 178, 170) or Color3.fromRGB(220, 190, 100)
	TabBtn.Font = Enum.Font.FredokaOne
	TabBtn.Text = name
	TabBtn.TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 80, 40)
	TabBtn.TextSize = 15
	TabBtn.AutoButtonColor = false
	TabBtn.Parent = TabContainer

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 10)
	Corner.Parent = TabBtn

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(255, 255, 255)
	Stroke.Thickness = 1.5
	Stroke.Transparency = isActive and 0.2 or 0.7
	Stroke.Parent = TabBtn

	return TabBtn
end

CreateTabButton("TAB CHÍNH", true)
CreateTabButton("TAB PVP", false)
CreateTabButton("UP TỘC V4", false)

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(0.92, 0, 0, 240)
ContentFrame.Position = UDim2.new(0.04, 0, 0, 122)
ContentFrame.BackgroundColor3 = Color3.fromRGB(240, 220, 140)
ContentFrame.BackgroundTransparency = 0.3
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 12)
ContentCorner.Parent = ContentFrame

local LeftColumn = Instance.new("Frame")
LeftColumn.Size = UDim2.new(0.48, 0, 0.95, 0)
LeftColumn.Position = UDim2.new(0.01, 0, 0.025, 0)
LeftColumn.BackgroundTransparency = 1
LeftColumn.Parent = ContentFrame

local RightColumn = Instance.new("Frame")
RightColumn.Size = UDim2.new(0.48, 0, 0.95, 0)
RightColumn.Position = UDim2.new(0.51, 0, 0.025, 0)
RightColumn.BackgroundTransparency = 1
RightColumn.Parent = ContentFrame

local LeftLayout = Instance.new("UIListLayout")
LeftLayout.Padding = UDim.new(0, 8)
LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
LeftLayout.Parent = LeftColumn

local RightLayout = Instance.new("UIListLayout")
RightLayout.Padding = UDim.new(0, 8)
RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
RightLayout.Parent = RightColumn

local function CreateToggle(parent, titleText, defaultState, order)
	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, 0, 0, 32)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = order
	Container.Parent = parent

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.7, 0, 1, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.FredokaOne
	Label.Text = titleText
	Label.TextColor3 = Color3.fromRGB(50, 50, 50)
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Container

	local SwitchBg = Instance.new("Frame")
	SwitchBg.Size = UDim2.new(0, 44, 0, 22)
	SwitchBg.Position = UDim2.new(1, -46, 0.5, -11)
	SwitchBg.BackgroundColor3 = defaultState and Color3.fromRGB(32, 178, 170) or Color3.fromRGB(160, 160, 160)
	SwitchBg.Parent = Container

	local SwitchCorner = Instance.new("UICorner")
	SwitchCorner.CornerRadius = UDim.new(1, 0)
	SwitchCorner.Parent = SwitchBg

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0, 18, 0, 18)
	Circle.Position = defaultState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
	Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Circle.Parent = SwitchBg

	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = Circle

	local state = defaultState
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.BackgroundTransparency = 1
	Button.Text = ""
	Button.Parent = SwitchBg

	Button.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(SwitchBg, TweenInfo.new(0.2), {
			BackgroundColor3 = state and Color3.fromRGB(32, 178, 170) or Color3.fromRGB(160, 160, 160)
		}):Play()
		TweenService:Create(Circle, TweenInfo.new(0.2), {
			Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
		}):Play()
	end)
end

local function CreateTextBox(parent, placeholder, order)
	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, 0, 0, 36)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = order
	Container.Parent = parent

	local InputBg = Instance.new("Frame")
	InputBg.Size = UDim2.new(1, 0, 1, 0)
	InputBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	InputBg.BackgroundTransparency = 0.2
	InputBg.Parent = Container

	local InputCorner = Instance.new("UICorner")
	InputCorner.CornerRadius = UDim.new(0, 8)
	InputCorner.Parent = InputBg

	local InputStroke = Instance.new("UIStroke")
	InputStroke.Color = Color3.fromRGB(32, 178, 170)
	InputStroke.Thickness = 1.5
	InputStroke.Parent = InputBg

	local TextBox = Instance.new("TextBox")
	TextBox.Size = UDim2.new(1, -12, 1, 0)
	TextBox.Position = UDim2.new(0, 6, 0, 0)
	TextBox.BackgroundTransparency = 1
	TextBox.Font = Enum.Font.FredokaOne
	TextBox.PlaceholderText = placeholder
	TextBox.PlaceholderColor3 = Color3.fromRGB(130, 150, 140)
	TextBox.Text = ""
	TextBox.TextColor3 = Color3.fromRGB(40, 40, 40)
	TextBox.TextSize = 12
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	TextBox.Parent = InputBg
end

local function CreateButton(parent, buttonText, order)
	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, 0, 0, 32)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = order
	Container.Parent = parent

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 1, 0)
	Btn.BackgroundColor3 = Color3.fromRGB(32, 178, 170)
	Btn.Font = Enum.Font.FredokaOne
	Btn.Text = buttonText
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 13
	Btn.AutoButtonColor = false
	Btn.Parent = Container

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Btn

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(255, 255, 255)
	Stroke.Thickness = 1
	Stroke.Parent = Btn

	Btn.MouseButton1Down:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(24, 140, 134)}):Play()
	end)
	Btn.MouseButton1Up:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(32, 178, 170)}):Play()
	end)
end

CreateToggle(LeftColumn, "Auto Farm (Max Level)", true, 1)
CreateTextBox(LeftColumn, "Nhập trái muốn random...", 2)
CreateToggle(LeftColumn, "ESP Player (Người chơi)", false, 3)
CreateToggle(LeftColumn, "ESP Trái Ác Quỷ (Fruit)", true, 4)

CreateToggle(RightColumn, "Auto Nhặt Rương", false, 1)
CreateToggle(RightColumn, "Auto Teleport Fruit", false, 2)
CreateToggle(RightColumn, "Auto Bounty", false, 3)
CreateButton(RightColumn, "⚡ Fix Lag (Xoá 99% đồ hoạ)", 4)

local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
