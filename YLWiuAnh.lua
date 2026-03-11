-- YLWiuAnh GUI - ENGLISH VERSION
-- Features: ESP, Aimlock, WalkSpeed, JumpPower, Hitbox Slider

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "YLWiuAnh_EN"

-- MAIN GUI
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 380)
Main.Position = UDim2.new(0.5, -125, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(0, 191, 255) -- Sky Blue Border
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- TITLE BAR
local Title = Instance.new("TextButton", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "YLWiuAnh GUI"
Title.BackgroundColor3 = Color3.fromRGB(255, 180, 200) -- Cherry Blossom Pink
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Title.AutoButtonColor = false
Instance.new("UICorner", Title)

-- CONTAINER
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 8)

-- MINIMIZE BUTTON (-)
local MinBtn = Instance.new("TextButton", Title)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn)

-- Smart Minimize Logic
local isMinimized = false
local originalSize = Main.Size
local function toggleMenu()
    if not isMinimized then
        Container.Visible = false
        Main:TweenSize(UDim2.new(0, 250, 0, 40), "Out", "Quart", 0.3, true)
        MinBtn.Text = "+"
    else
        Main:TweenSize(originalSize, "Out", "Quart", 0.3, true)
        task.wait(0.2)
        Container.Visible = true
        MinBtn.Text = "-"
    end
    isMinimized = not isMinimized
end
MinBtn.MouseButton1Click:Connect(toggleMenu)
Title.MouseButton1Click:Connect(function() if isMinimized then toggleMenu() end end)

-- UI HELPERS
local function CreateToggle(text, callback)
    local on = false
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.Text = text .. " : OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(function()
        on = not on
        Btn.Text = text .. (on and " : ON" or " : OFF")
        Btn.BackgroundColor3 = on and Color3.fromRGB(255, 120, 180) or Color3.fromRGB(45, 45, 45)
        callback(on)
    end)
end

local function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    local Text = Instance.new("TextLabel", Frame)
    Text.Size = UDim2.new(1, 0, 0, 20)
    Text.Text = name .. " (" .. default .. ")"
    Text.TextColor3 = Color3.new(1, 1, 1)
    Text.BackgroundTransparency = 1
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(0.9, 0, 0, 6)
    Bar.Position = UDim2.new(0.05, 0, 0.65, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 191, 255)
    local function update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        Text.Text = name .. " (" .. val .. ")"
        callback(val)
    end
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local move; move = UIS.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then update(input) end
            end)
            local release; release = UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    move:Disconnect(); release:Disconnect()
                end
            end)
            update(input)
        end
    end)
end

-- FUNCTIONS
CreateToggle("Player ESP", function(state)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character then
            if state then
                local h = Instance.new("Highlight", v.Character)
                h.Name = "YLW_ESP"; h.FillColor = Color3.fromRGB(255, 180, 200)
            else
                if v.Character:FindFirstChild("YLW_ESP") then v.Character.YLW_ESP:Destroy() end
            end
        end
    end
end)

local aimlockOn = false
CreateToggle("Aimlock", function(v) aimlockOn = v end)
local function getClosest()
    local target = nil; local dist = math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, vis = camera:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then dist = mag; target = v end
            end
        end
    end
    return target
end
RunService.RenderStepped:Connect(function()
    if aimlockOn then
        local t = getClosest()
        if t then camera.CFrame = CFrame.new(camera.CFrame.Position, t.Character.Head.Position) end
    end
end)

CreateSlider("WalkSpeed", 16, 300, 16, function(v) if player.Character then player.Character.Humanoid.WalkSpeed = v end end)
CreateSlider("JumpPower", 50, 300, 50, function(v) if player.Character then player.Character.Humanoid.JumpPower = v; player.Character.Humanoid.UseJumpPower = true end end)
CreateSlider("Hitbox Size", 2, 150, 2, function(size)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = Vector3.new(size, size, size)
            v.Character.HumanoidRootPart.Transparency = 0.5
            v.Character.HumanoidRootPart.CanCollide = false
        end
    end
end)

