-- YLW Hub - Phiên bản 4.2 (Sửa lỗi thực thi trên Delta Mobile)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Khởi tạo State hệ thống
local State = {
    WalkSpeed_Enabled = false,
    WalkSpeed_Value = 16,
    JumpPower_Enabled = false,
    JumpPower_Value = 50,
    InfJump_Enabled = false,
    Fly_Speed = 50,
    Noclip_Enabled = false,
    Aim_Radius = 35,
    Hitbox_Size = 5,
    Hitbox_Transparency = 0.5,
    Portal_System_Enabled = false,
    Camera_FOV_Value = 70,
    ESP_Name = false,
    ESP_Box = false,
    ESP_Storage = {},
    Aim_Mode = "All"
}

-- TẠO GIAO DIỆN CHÍNH (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YLW_Hub_v42"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 9)

-- Thanh tiêu đề
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 9)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "YLW HUB v4.2"
Title.TextColor3 = Color3.fromRGB(255, 220, 100)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 35, 0, 35)
MiniBtn.Position = UDim2.new(1, -45, 0, 5)
MiniBtn.Text = "—"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MiniBtn.Font = Enum.Font.SourceSansBold
MiniBtn.TextSize = 16
MiniBtn.Parent = TopBar
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 6)

-- Sidebar phân mục
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 5)

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -145, 1, -55)
ContentContainer.Position = UDim2.new(0, 145, 0, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local tabs = {}
local tabButtons = {}

local function createTab(tabName, displayName)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -10, 0, 38)
    tabBtn.Position = UDim2.new(0, 5, 0, 0)
    tabBtn.Text = displayName
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 14
    tabBtn.Parent = Sidebar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 4
    page.Parent = ContentContainer
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)

    tabs[tabName] = page
    tabButtons[tabName] = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        for t, s in pairs(tabs) do s.Visible = (t == tabName) end
        for t, b in pairs(tabButtons) do
            b.BackgroundColor3 = (t == tabName) and Color3.fromRGB(55, 85, 140) or Color3.fromRGB(30, 30, 35)
            b.TextColor3 = (t == tabName) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)
        end
    end)
end

createTab("Combat", "⚔️ CHÍNH")
createTab("Movement", "⚡ DI CHUYỂN")
createTab("Visuals", "👁️ GIAO DIỆN")

tabs["Combat"].Visible = true
tabButtons["Combat"].BackgroundColor3 = Color3.fromRGB(55, 85, 140)
tabButtons["Combat"].TextColor3 = Color3.fromRGB(255, 255, 255)

-- LOGIC ĐIỀU KHIỂN ĐÚNG CHUẨN (Toggles & Sliders)
local function createToggle(tab, text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(150, 45, 45)
    btn.Text = text .. " : OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.Parent = tabs[tab]
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.BackgroundColor3 = Color3.fromRGB(45, 140, 70)
            btn.Text = text .. " : ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(150, 45, 45)
            btn.Text = text .. " : OFF"
        end
        callback(enabled)
    end)
    return btn
end

local function createSlider(tab, text, min, max, default, order, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 42)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order
    container.Parent = tabs[tab]

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 140, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(default)
    lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = container

    local sFrame = Instance.new("Frame")
    sFrame.Size = UDim2.new(1, -150, 0, 6)
    sFrame.Position = UDim2.new(0, 145, 0.5, -3)
    sFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    sFrame.Parent = container
    Instance.new("UICorner", sFrame).CornerRadius = UDim.new(1, 0)

    local sBtn = Instance.new("TextButton")
    sBtn.Size = UDim2.new(0, 16, 0, 16)
    local initPct = math.clamp((default - min) / (max - min), 0, 1)
    sBtn.Position = UDim2.new(initPct, -8, -0.5, -5)
    sBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sBtn.Text = ""
    sBtn.Parent = sFrame
    Instance.new("UICorner", sBtn).CornerRadius = UDim.new(1, 0)

    local sliding = false
    sBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
            local pct = math.clamp((i.Position.X - sFrame.AbsolutePosition.X) / sFrame.AbsoluteSize.X, 0, 1)
            sBtn.Position = UDim2.new(pct, -8, -0.5, -5)
            local val = math.clamp(math.round(min + (pct * (max - min))), min, max)
            lbl.Text = text .. ": " .. tostring(val)
            callback(val)
        end
    end)
end

-- TÍNH NĂNG ĐÓNG MỞ GUI
local isMinimized = false
MiniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 520, 0, 45)
        Sidebar.Visible = false
        ContentContainer.Visible = false
        MiniBtn.Text = "＋"
    else
        MainFrame.Size = UDim2.new(0, 520, 0, 320)
        Sidebar.Visible = true
        ContentContainer.Visible = true
        MiniBtn.Text = "—"
    end
end)

-- THIẾT LẬP MENU PHÂN HỆ KHÁC
-- TAB 1: COMBAT
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.Radius = State.Aim_Radius
FOVCircle.Visible = false

local Aim_Btn = createToggle("Combat", "AIMBOT", 1, function(state) FOVCircle.Visible = state end)

local AimMode_Btn = Instance.new("TextButton")
AimMode_Btn.Size = UDim2.new(1, -10, 0, 36)
AimMode_Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
AimMode_Btn.Text = "AIM TARGET: ALL"
AimMode_Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimMode_Btn.Font = Enum.Font.SourceSansBold
AimMode_Btn.TextSize = 14
AimMode_Btn.LayoutOrder = 2
AimMode_Btn.Parent = tabs["Combat"]
Instance.new("UICorner", AimMode_Btn).CornerRadius = UDim.new(0, 6)

createSlider("Combat", "Phạm vi Aimbot (FOV)", 10, 500, 35, 3, function(v) 
    State.Aim_Radius = v 
    FOVCircle.Radius = v 
end)

local Hitbox_Btn = createToggle("Combat", "HITBOX EXPANDER", 4, function(state) end)
createSlider("Combat", "Kích thước Hitbox", 5, 100, 5, 5, function(v) State.Hitbox_Size = v end)

-- TAB 2: MOVEMENT
local Speed_Btn = createToggle("Movement", "SPEED SYSTEM", 1, function(state)
    State.WalkSpeed_Enabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
createSlider("Movement", "Tốc độ chạy", 16, 500, 100, 2, function(v) State.WalkSpeed_Value = v end)

local Jump_Btn = createToggle("Movement", "JUMP SYSTEM", 3, function(state)
    State.JumpPower_Enabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end)
createSlider("Movement", "Sức mạnh nhảy", 50, 500, 120, 4, function(v) State.JumpPower_Value = v end)

createToggle("Movement", "INFINITE JUMP", 5, function(state) State.InfJump_Enabled = state end)
createToggle("Movement", "NOCLIP (XUYÊN TƯỜNG)", 6, function(state) State.Noclip_Enabled = state end)

-- Hệ thống Portal
local PortalMaster_Btn = createToggle("Movement", "HỆ THỐNG PORTAL", 7, function(state) State.Portal_System_Enabled = state end)

local PortalContainer = Instance.new("Frame")
PortalContainer.Size = UDim2.new(1, -10, 0, 80)
PortalContainer.BackgroundTransparency = 1
PortalContainer.LayoutOrder = 8
PortalContainer.Parent = tabs["Movement"]

local MAX_PORTALS = 5
local portals = {}
local debounces = {}
local currentSelectedId = nil
for i = 1, MAX_PORTALS do portals[i] = {}; debounces[i] = false end
local portalColors = {Color3.fromRGB(255, 50, 50), Color3.fromRGB(50, 255, 50), Color3.fromRGB(50, 50, 255), Color3.fromRGB(255, 255, 50), Color3.fromRGB(255, 50, 255)}

for i = 1, MAX_PORTALS do
    local btn = Instance.new("TextButton", PortalContainer)
    btn.Size = UDim2.new(0, 48, 0, 32)
    btn.Position = UDim2.new(0, (i-1)*54, 0, 5)
    btn.Text = tostring(i)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = portalColors[i]
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
end

-- TAB 3: VISUALS
createToggle("Visuals", "ESP NAME", 1, function(state) State.ESP_Name = state end)
createToggle("Visuals", "ESP BOX", 2, function(state) State.ESP_Box = state end)

createSlider("Visuals", "Góc Nhìn Camera (FOV)", 30, 120, 70, 3, function(v)
    State.Camera_FOV_Value = v
    Camera.FieldOfView = v
end)

----------------------------------------------------
-- VÒNG LẶP LIÊN TỤC (TỐI ƯU HÓA MOBILE)
----------------------------------------------------
RunService.PostSimulation:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if State.WalkSpeed_Enabled then hum.WalkSpeed = State.WalkSpeed_Value end
        if State.JumpPower_Enabled then hum.JumpPower = State.JumpPower_Value hum.UseJumpPower = true end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfJump_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    if State.Noclip_Enabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end
    end
    if FOVCircle.Visible then
        FOVCircle.Position = UserInputService:GetMouseLocation()
    end
end)

