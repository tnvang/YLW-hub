local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local isEnabled = false
local originalDurations = {}
local promptConnections = {}

local function applyPromptFix(prompt)
    if prompt:IsA("ProximityPrompt") then
        if isEnabled then
            if not originalDurations[prompt] then
                originalDurations[prompt] = prompt.HoldDuration
            end
            
            prompt.HoldDuration = 0
            
            if not promptConnections[prompt] then
                promptConnections[prompt] = prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
                    if isEnabled and prompt.HoldDuration ~= 0 then
                        prompt.HoldDuration = 0
                    end
                end)
            end
        end
    end
end

local function restorePrompts()
    for prompt, connection in pairs(promptConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    table.clear(promptConnections)

    for prompt, duration in pairs(originalDurations) do
        if prompt and prompt.Parent then
            prompt.HoldDuration = duration
        end
    end
    table.clear(originalDurations)
end

local function scanAndBypassPrompts()
    if isEnabled then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            applyPromptFix(obj)
        end
    else
        restorePrompts()
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    if isEnabled then
        applyPromptFix(obj)
    end
end)

ProximityPromptService.PromptShown:Connect(function(prompt)
    if isEnabled then
        applyPromptFix(prompt)
    end
end)

RunService.Heartbeat:Connect(function()
    if not isEnabled then return end
    
    for _, gui in ipairs(PlayerGui:GetDescendants()) do
        if gui:IsA("Frame") or gui:IsA("ImageLabel") or gui:IsA("ImageButton") then
            local name = gui.Name:lower()
            if name:find("progress") or name:find("bar") or name:find("timer") or name:find("loading") or name:find("clean") or name:find("circle") then
                if gui:IsA("Frame") then
                    gui.Size = UDim2.new(1, 0, gui.Size.Y.Scale, gui.Size.Y.Offset)
                end
            end
        end
    end
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if isEnabled then
        fireproximityprompt(prompt)
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimeBypassGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 130, 0, 40)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 95, 1, 0)
ToggleBtn.Position = UDim2.new(0, 0, 0, 0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = "BYPASS: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = MainFrame

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.Parent = MainFrame

ToggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        ToggleBtn.Text = "BYPASS: ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        ToggleBtn.Text = "BYPASS: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
    end
    scanAndBypassPrompts()
end)

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 35, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        ToggleBtn.Visible = false
        MinBtn.Size = UDim2.new(1, 0, 1, 0)
        MinBtn.Position = UDim2.new(0, 0, 0, 0)
        MinBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 130, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        ToggleBtn.Visible = true
        MinBtn.Size = UDim2.new(0, 30, 1, 0)
        MinBtn.Position = UDim2.new(1, -30, 0, 0)
        MinBtn.Text = "-"
    end
end)

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
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)
