--[[ 
    XUANANHDEPGAI HUB PRO - ENGLISH VERSION
    Features: Love Quiz, Mini Toggle, Sliders (50-300), Black Screen Penalty
]]

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "XuananhDepGai_Hub_EN"

-- --- LOVE QUIZ SYSTEM ---
local AuthFrame = Instance.new("Frame")
AuthFrame.Size = UDim2.new(0, 300, 0, 150)
AuthFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
AuthFrame.BackgroundColor3 = Color3.fromRGB(255, 183, 197) -- Cherry Blossom Pink
AuthFrame.BorderSizePixel = 3
AuthFrame.BorderColor3 = Color3.fromRGB(0, 191, 255) -- Ocean Blue Border
AuthFrame.Parent = ScreenGui

local ACorner = Instance.new("UICorner")
ACorner.CornerRadius = UDim.new(0, 15)
ACorner.Parent = AuthFrame

local ATitle = Instance.new("TextLabel")
ATitle.Size = UDim2.new(1, 0, 0.4, 0)
ATitle.Text = "Do you love Xuananh? <3"
ATitle.Parent = AuthFrame
ATitle.BackgroundTransparency = 1
ATitle.Font = Enum.Font.SourceSansBold
ATitle.TextSize = 20
ATitle.TextColor3 = Color3.fromRGB(255, 255, 255)

-- NO Button (Error Trigger)
local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 100, 0, 40)
NoBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
NoBtn.Text = "No!"
NoBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
NoBtn.Parent = AuthFrame
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 8)

-- YES Button (Activation)
local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 160, 0, 40)
YesBtn.Position = UDim2.new(0.45, 5, 0.55, 0)
YesBtn.Text = "Xuananh loves you so much!"
YesBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
YesBtn.Font = Enum.Font.SourceSansBold
YesBtn.TextSize = 12
YesBtn.Parent = AuthFrame
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 8)

-- --- MAIN GUI ---
local MainFrame = Instance.new("Frame")
local OpenBtn = Instance.new("TextButton")

OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = ScreenGui
OpenBtn.Visible = false
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 183, 197)
OpenBtn.Text = "X"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

MainFrame.Parent = ScreenGui
MainFrame.Visible = false
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Size = UDim2.new(0, 240, 0, 380)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -190)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 191, 255)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "XUANANHDEPGAI HUB"
Title.BackgroundColor3 = Color3.fromRGB(255, 183, 197)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 15)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.Parent = MainFrame
local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.Padding = UDim.new(0, 10)

-- --- SLIDER CREATOR (50-300) ---
local function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Container

    local Lab = Instance.new("TextLabel")
    Lab.Text = name .. ": " .. default
    Lab.Size = UDim2.new(1, 0, 0, 20)
    Lab.TextColor3 = Color3.fromRGB(255, 183, 197)
    Lab.BackgroundTransparency = 1
    Lab.Parent = Frame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(0.9, 0, 0, 5)
    Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Bar.Parent = Frame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 191, 255)
    Fill.Parent = Bar

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 14, 0, 14)
    Btn.Position = UDim2.new((default-min)/(max-min), -7, 0.5, -7)
    Btn.Text = ""
    Btn.Parent = Bar

    local dragging = false
    Btn.MouseButton1Down:Connect(function() dragging = true end)
    game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mp = game:GetService("UserInputService"):GetMouseLocation().X
            local bp = Bar.AbsolutePosition.X
            local bw = Bar.AbsoluteSize.X
            local per = math.clamp((mp - bp) / bw, 0, 1)
            Btn.Position = UDim2.new(per, -7, 0.5, -7)
            Fill.Size = UDim2.new(per, 0, 1, 0)
            local val = math.floor(min + (max - min) * per)
            Lab.Text = name .. ": " .. val
            callback(val)
        end
    end)
end

-- --- TOGGLE BUTTONS ---
local function AddToggle(text, func)
    local on = false
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = text .. " [OFF]"
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Parent = Container
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    b.MouseButton1Click:Connect(function()
        on = not on
        b.Text = text .. (on and " [ON]" or " [OFF]")
        b.BackgroundColor3 = on and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(50, 50, 50)
        func(on)
    end)
end

-- --- AUTH LOGIC ---
NoBtn.MouseButton1Click:Connect(function()
    AuthFrame:Destroy()
    local BlackFrame = Instance.new("Frame", ScreenGui)
    BlackFrame.Size = UDim2.new(1, 0, 1, 0)
    BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlackFrame.ZIndex = 999
    local Lbl = Instance.new("TextLabel", BlackFrame)
    Lbl.Size = UDim2.new(1, 0, 1, 0)
    Lbl.Text = "ERROR: Script won't run if you don't love Xuananh! :P"
    Lbl.TextColor3 = Color3.fromRGB(255, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.TextSize = 25
end)

YesBtn.MouseButton1Click:Connect(function()
    AuthFrame:Destroy()
    OpenBtn.Visible = true
    MainFrame.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- --- FEATURES ---
CreateSlider("WalkSpeed", 50, 300, 16, function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end)
CreateSlider("JumpPower", 50, 300, 50, function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower = v; game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true end)

AddToggle("Player ESP", function(state) -- ESP Logic end)
AddToggle("Aimbot", function(state) -- Aimlock Logic end)
AddToggle("Hitbox Expansion", function(state)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = state and Vector3.new(25, 25, 25) or Vector3.new(2, 2, 1)
            v.Character.HumanoidRootPart.Transparency = state and 0.7 or 1
        end
    end
end)
        
