--[[ 
    XUANANHIU HUB PRO - CHERRY BLOSSOM EDITION
    Features: Auth System, Circular Toggle, Transparent UI, Sliders (Speed/Jump)
]]

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "XuananhiuHub_Pro"

-- --- AUTHORIZATION SYSTEM ---
local AuthFrame = Instance.new("Frame")
AuthFrame.Size = UDim2.new(0, 260, 0, 130)
AuthFrame.Position = UDim2.new(0.5, -130, 0.5, -65)
AuthFrame.BackgroundColor3 = Color3.fromRGB(255, 183, 197) -- Cherry Blossom Pink
AuthFrame.BorderSizePixel = 0
AuthFrame.Parent = ScreenGui

local ACorner = Instance.new("UICorner")
ACorner.CornerRadius = UDim.new(0, 15)
ACorner.Parent = AuthFrame

local ATitle = Instance.new("TextLabel")
ATitle.Size = UDim2.new(1, 0, 0.6, 0)
ATitle.Text = "xuananh co iu t hog? <3"
ATitle.Parent = AuthFrame
ATitle.BackgroundTransparency = 1
ATitle.Font = Enum.Font.SourceSansBold
ATitle.TextSize = 20
ATitle.TextColor3 = Color3.fromRGB(255, 255, 255)

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 100, 0, 35)
YesBtn.Position = UDim2.new(0.5, -50, 0.65, 0)
YesBtn.Text = "Yes, I do!"
YesBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
YesBtn.Font = Enum.Font.SourceSansBold
YesBtn.Parent = AuthFrame
local BCorner = Instance.new("UICorner")
BCorner.CornerRadius = UDim.new(0, 10)
BCorner.Parent = YesBtn

-- --- MAIN MENU COMPONENTS ---
local MainFrame = Instance.new("Frame")
local OpenBtn = Instance.new("TextButton") -- The Circular Mini Button

-- Mini Circular Toggle Button
OpenBtn.Name = "ToggleBtn"
OpenBtn.Parent = ScreenGui
OpenBtn.Visible = false
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.05, 0, 0.15, 0) -- Positioned where you marked red
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 183, 197)
OpenBtn.Text = "X"
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 22
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local OCorner = Instance.new("UICorner")
OCorner.CornerRadius = UDim.new(1, 0)
OCorner.Parent = OpenBtn

-- Transparent Main Menu
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Visible = false
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.35 -- Transparent effect
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -175)
MainFrame.Size = UDim2.new(0, 230, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true
local MCorner = Instance.new("UICorner")
MCorner.CornerRadius = UDim.new(0, 15)
MCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "XUANANHIU HUB PRO"
Title.BackgroundColor3 = Color3.fromRGB(255, 183, 197)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame
local TCorner = Instance.new("UICorner")
TCorner.CornerRadius = UDim.new(0, 15)
TCorner.Parent = Title

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 2.2, 0)
Container.ScrollBarThickness = 2
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.Padding = UDim.new(0, 12)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- --- SLIDER CREATOR FUNCTION ---
local function CreateSlider(name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 55)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Text = name .. ": " .. default
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.TextColor3 = Color3.fromRGB(255, 183, 197)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSansBold
    Label.Parent = SliderFrame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(0.9, 0, 0, 6)
    Bar.Position = UDim2.new(0.05, 0, 0.75, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Bar.Parent = SliderFrame
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 183, 197)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 16, 0, 16)
    Btn.Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8)
    Btn.Text = ""
    Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Parent = Bar
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

    local dragging = false
    Btn.MouseButton1Down:Connect(function() dragging = true end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation().X
            local barPos = Bar.AbsolutePosition.X
            local barWidth = Bar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barWidth, 0, 1)
            Btn.Position = UDim2.new(percent, -8, 0.5, -8)
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(min + (max - min) * percent)
            Label.Text = name .. ": " .. val
            callback(val)
        end
    end)
end

-- --- FEATURE BUTTONS ---
local function AddButton(text, func)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 38)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(255, 183, 197)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    b.Parent = Container
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    b.MouseButton1Click:Connect(func)
end

-- --- LOGIC & CONNECTIONS ---
YesBtn.MouseButton1Click:Connect(function()
    AuthFrame:Destroy()
    OpenBtn.Visible = true
    print("Authorization Successful!")
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    OpenBtn.Text = MainFrame.Visible and "-" or "X"
end)

-- Initialize Features
CreateSlider("WalkSpeed", 50, 300, 16, function(v)
    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

CreateSlider("JumpPower", 50, 200, 50, function(v)
    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
        game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
    end
end)

AddButton("Enable ESP (Visuals)", function()
    -- ESP Logic goes here
end)

AddButton("Enable Aimlock (Combat)", function()
    -- Aimlock Logic goes here
end)

AddButton("RESET EVERYTHING", function()
    local h = game.Players.LocalPlayer.Character.Humanoid
    h.WalkSpeed = 16
    h.JumpPower = 50
    -- Reset other features here
end)
