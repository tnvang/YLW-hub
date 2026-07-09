-- [[ PREMIUM MOBILE HUB V4.2 - ULTIMATE INTERFACE EDITION ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5) 
local Camera = workspace.CurrentCamera

if _G.MobileHubExecutedFinalV4_2 then
    print("[Mobile Hub] Hub V4.2 đã kích hoạt thành công!")
    return
else
    _G.MobileHubExecutedFinalV4_2 = true
end

-- Hệ thống Quản lý Trạng thái (State)
local State = {
    FPS_Enabled = false,
    Aim_Enabled = false,
    Aim_Mode = "All",
    Aim_Radius = 35,
    Hitbox_Enabled = false,
    Hitbox_Size = 5,
    Hitbox_Transparency = 0.5,
    Hitbox_Originals = {},
    
    ESP_Name = false,
    ESP_Box = false,
    ESP_Storage = {},
    
    WalkSpeed_Enabled = false,
    WalkSpeed_Value = 16,
    JumpPower_Enabled = false,
    JumpPower_Value = 50,
    InfJump_Enabled = false,
    Fly_Enabled = false,
    Fly_Speed = 50,
    Noclip_Enabled = false,
    Spider_Enabled = false,
    
    Portal_System_Enabled = false,
    VisualEffects_Enabled = false,
    Camera_FOV_Value = 70,

    -- MỚI: Freecam & Fake Clone
    Freecam_Enabled = false,
    Clone_Active = false,
    Clone_Mode = "Stand", -- "Stand" hoặc "Follow"
    Clone_Model = nil
}

local currentAimTarget = nil
local FlyVelocity = nil
local FlyGyro = nil
local ActiveTrail = nil
local ActiveSparkles = nil
local CurrentActiveEffect = nil
local hitboxConnection = nil

-- Vẽ vòng tròn FOV Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Filled = false
FOVCircle.Radius = State.Aim_Radius
FOVCircle.Visible = false

-- KHỞI TẠO GUI CHÍNH
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumMobileHub_V4_2"
ScreenGui.ResetOnSpawn = false
local success, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = PlayerGui end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Nền Gradient cho MainFrame
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35,35,45))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

local MainCorner = Instance.new("UICorner") 
MainCorner.CornerRadius = UDim.new(0, 14) 
MainCorner.Parent = MainFrame

-- Viền Rainbow cho Khung chính
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

task.spawn(function()
    local h = 0
    while ScreenGui.Parent do
        h = (h + 0.003) % 1
        MainStroke.Color = Color3.fromHSV(h, 1, 1)
        task.wait(0.02)
    end
end)

-- Thanh Tiêu Đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 220, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PREMIUM MOBILE HUB V4.2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- MỚI: Nhãn hiển thị FPS / Ping / RAM khi thu nhỏ
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(0, 220, 0, 45)
StatsLabel.Position = UDim2.new(1, -270, 0, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "FPS: -- | Ping: --ms | RAM: --MB"
StatsLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
StatsLabel.Font = Enum.Font.SourceSansBold
StatsLabel.TextSize = 13
StatsLabel.TextXAlignment = Enum.TextXAlignment.Right
StatsLabel.Parent = MainFrame

-- Cập nhật thông số FPS / Ping / RAM liên tục
task.spawn(function()
    local lastTime = os.clock()
    local frameCount = 0
    local fps = 60
    
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = os.clock()
        if currentTime - lastTime >= 1 then
            fps = frameCount
            frameCount = 0
            lastTime = currentTime
            
            local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local ram = math.round(Stats:GetTotalMemoryUsageMb())
            StatsLabel.Text = string.format("FPS: %d | Ping: %dms | RAM: %dMB", fps, ping, ram)
        end
    end)
end)

-- Nút Thu Nhỏ
local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 35, 0, 30)
MiniBtn.Position = UDim2.new(1, -45, 0, 7)
MiniBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MiniBtn.Text = "—"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.SourceSansBold
MiniBtn.TextSize = 14
MiniBtn.Parent = MainFrame
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", MiniBtn).Color = Color3.fromRGB(60, 60, 70)

-- THANH DI CHUYỂN TAB (Sidebar bên trái)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -55)
Sidebar.Position = UDim2.new(0, 10, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

-- Viền Rainbow cho Sidebar
local SidebarStroke = Instance.new("UIStroke")
SidebarStroke.Parent = Sidebar
SidebarStroke.Thickness = 1.3

task.spawn(function()
    local h = 0
    while ScreenGui.Parent do
        h = (h + 0.003) % 1
        SidebarStroke.Color = Color3.fromHSV(h, 1, 1)
        task.wait(0.02)
    end
end)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- VÙNG CHỨA NỘI DUNG CÁC TAB
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -160, 1, -55)
ContentContainer.Position = UDim2.new(0, 150, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local tabs = {}
local tabButtons = {}

local function createTab(tabName, displayName)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = tabName .. "Tab"
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 750)
    scroll.ScrollBarThickness = 4
    scroll.Visible = false
    scroll.Parent = ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    
    tabs[tabName] = scroll
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 114, 0, 36)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    tabBtn.Text = displayName
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 14
    tabBtn.Parent = Sidebar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    tabButtons[tabName] = tabBtn
    
    tabBtn.MouseButton1Click:Connect(function()
        for t, s in pairs(tabs) do s.Visible = (t == tabName) end
        for t, b in pairs(tabButtons) do 
            b.BackgroundColor3 = (t == tabName) and Color3.fromRGB(55, 85, 140) or Color3.fromRGB(30, 30, 38)
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

-- HÀM TẠO THÀNH PHẦN GUI
local function createToggle(tab, text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(150, 45, 45)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.Parent = tabs[tab]
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local normal = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        normal = btn.BackgroundColor3
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(70, 70, 90) }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = normal }):Play()
    end)
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.BackgroundColor3 = Color3.fromRGB(45, 140, 70)
            btn.Text = text .. ": ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(150, 45, 45)
            btn.Text = text .. ": OFF"
        end
        normal = btn.BackgroundColor3
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
    sBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
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

local function createButton(tab, text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(45, 60, 85)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.Parent = tabs[tab]
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Animation Thu Gọn Menu
local isMinimized = false
MiniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        Sidebar.Visible = false
        ContentContainer.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 520, 0, 45) }):Play()
        MiniBtn.Text = "＋"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 520, 0, 320) }):Play()
        task.wait(0.25)
        Sidebar.Visible = true
        ContentContainer.Visible = true
        MiniBtn.Text = "—"
    end
end)

-- Dragging Control
local Dragging, DragInput, DragStart, StartPosition
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true; DragStart = input.Position; StartPosition = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end 
end)
UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
    end
end)

-- TAB 1: COMBAT
local toggleAimbot, toggleHitbox
createToggle("Combat", "AIMBOT", 1, function(state) toggleAimbot(state) end)

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

createToggle("Combat", "HITBOX EXPANDER", 4, function(state) toggleHitbox(state) end)
createSlider("Combat", "Kích thước Hitbox", 5, 100, 5, 5, function(v) State.Hitbox_Size = v end)

local TransContainer = Instance.new("Frame")
TransContainer.Size = UDim2.new(1, -10, 0, 36)
TransContainer.BackgroundTransparency = 1
TransContainer.LayoutOrder = 6
TransContainer.Parent = tabs["Combat"]

local TransBox = Instance.new("TextBox")
TransBox.Size = UDim2.new(0, 60, 1, 0)
TransBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
TransBox.Text = "0.5"
TransBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TransBox.Font = Enum.Font.SourceSansBold
TransBox.TextSize = 14
TransBox.Parent = TransContainer
Instance.new("UICorner", TransBox).CornerRadius = UDim.new(0, 5)

local TransLabel = Instance.new("TextLabel")
TransLabel.Size = UDim2.new(1, -70, 1, 0)
TransLabel.Position = UDim2.new(0, 70, 0, 0)
TransLabel.BackgroundTransparency = 1
TransLabel.Text = "Độ trong suốt Hitbox (0 - 1)"
TransLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
TransLabel.Font = Enum.Font.SourceSans
TransLabel.TextSize = 13
TransLabel.TextXAlignment = Enum.TextXAlignment.Left
TransLabel.Parent = TransContainer

-- TAB 2: MOVEMENT
local toggleFly
createToggle("Movement", "SPEED SYSTEM", 1, function(state)
    State.WalkSpeed_Enabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
createSlider("Movement", "Tốc độ chạy", 16, 500, 100, 2, function(v) State.WalkSpeed_Value = v end)

createToggle("Movement", "JUMP SYSTEM", 3, function(state)
    State.JumpPower_Enabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end)
createSlider("Movement", "Sức mạnh nhảy", 50, 500, 120, 4, function(v) State.JumpPower_Value = v end)

createToggle("Movement", "INFINITE JUMP", 5, function(state) State.InfJump_Enabled = state end)
createToggle("Movement", "FLY MOBILE (3D)", 6, function(state) toggleFly(state) end)
createSlider("Movement", "Tốc độ bay", 10, 300, 50, 7, function(v) State.Fly_Speed = v end)

createToggle("Movement", "NOCLIP (XUYÊN TƯỜNG)", 8, function(state) State.Noclip_Enabled = state end)

-- MỚI: Spider Climb (Leo tường)
createToggle("Movement", "SPIDER CLIMB (LEO TƯỜNG)", 9, function(state) State.Spider_Enabled = state end)

-- Teleport Player Dropdown
local TeleportContainer = Instance.new("Frame")
TeleportContainer.Size = UDim2.new(1, -10, 0, 36)
TeleportContainer.BackgroundTransparency = 1
TeleportContainer.LayoutOrder = 10
TeleportContainer.Parent = tabs["Movement"]

local SelectPlayerBtn = Instance.new("TextButton")
SelectPlayerBtn.Size = UDim2.new(1, 0, 1, 0)
SelectPlayerBtn.BackgroundColor3 = Color3.fromRGB(45, 60, 85)
SelectPlayerBtn.Text = "🎯 CHỌN NGƯỜI CHƠI ĐỂ TELEPORT"
SelectPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectPlayerBtn.Font = Enum.Font.SourceSansBold
SelectPlayerBtn.TextSize = 14
SelectPlayerBtn.Parent = TeleportContainer
Instance.new("UICorner", SelectPlayerBtn).CornerRadius = UDim.new(0, 6)

local DropdownFrame = Instance.new("ScrollingFrame")
DropdownFrame.Size = UDim2.new(1, 0, 0, 120)
DropdownFrame.Position = UDim2.new(0, 0, 0, 40)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
DropdownFrame.BorderSizePixel = 1
DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownFrame.ScrollBarThickness = 4
DropdownFrame.Visible = false
DropdownFrame.ZIndex = 50
DropdownFrame.Parent = TeleportContainer
Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIListLayout", DropdownFrame).Padding = UDim.new(0, 4)

local function updateDropdownList()
    for _, child in ipairs(DropdownFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, -8, 0, 30)
            pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            pBtn.Text = p.Name
            pBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.TextSize = 13
            pBtn.ZIndex = 51
            pBtn.Parent = DropdownFrame
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)
            
            pBtn.MouseButton1Click:Connect(function()
                DropdownFrame.Visible = false
                SelectPlayerBtn.Text = "TELE TO: " .. p.Name
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                end
                task.wait(1) SelectPlayerBtn.Text = "🎯 CHỌN NGƯỜI CHƠI ĐỂ TELEPORT"
            end)
        end
    end
    DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, count * 34)
end

SelectPlayerBtn.MouseButton1Click:Connect(function() 
    DropdownFrame.Visible = not DropdownFrame.Visible
    if DropdownFrame.Visible then updateDropdownList() end 
end)

-- TAB 3: VISUALS - THANHCONG SUB
local toggleFPS, toggleVisualEffects, toggleFreecam, toggleFakeClone
createToggle("Thanhcong sub", "FPS BOOSTER", 1, function(state) toggleFPS(state) end)
createToggle("Thanhcong sub", "ESP NAME", 2, function(state) State.ESP_Name = state end)
createToggle("Thanhcong sub", "ESP BOX", 3, function(state) State.ESP_Box = state end)

createSlider("Thanhcong sub", "Góc Nhìn Camera (FOV)", 30, 120, 70, 4, function(v)
    State.Camera_FOV_Value = v
    Camera.FieldOfView = v
end)

-- Chuyển Đổi Góc Nhìn 1 & 3
createButton("Thanhcong sub", "📷 GÓC NHÌN THỨ NHẤT (FIRST PERSON)", 5, function()
    LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
end)
createButton("Thanhcong sub", "🎥 GÓC NHÌN THỨ BA (THIRD PERSON)", 6, function()
    LocalPlayer.CameraMode = Enum.CameraMode.Classic
    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 128
end)

-- Freecam (Góc nhìn tự do)
createToggle("Thanhcong sub", "🛸 FREECAM (GÓC NHÌN TỰ DO)", 7, function(state) toggleFreecam(state) end)

-- Fake Clone
createToggle("Thanhcong sub", "👥 FAKE CLONE (BẢN SAO NHỎ)", 8, function(state) toggleFakeClone(state) end)

local CloneModeBtn = createButton("Thanhcong sub", "🤖 CLONE MODE: ĐỨNG YÊN", 9, function() end)
CloneModeBtn.MouseButton1Click:Connect(function()
    if State.Clone_Mode == "Stand" then
        State.Clone_Mode = "Follow"
        CloneModeBtn.Text = "🤖 CLONE MODE: CHẠY THEO"
        CloneModeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 180)
    else
        State.Clone_Mode = "Stand"
        CloneModeBtn.Text = "🤖 CLONE MODE: ĐỨNG YÊN"
        CloneModeBtn.BackgroundColor3 = Color3.fromRGB(45, 60, 85)
    end
end)

local EffBtn_Rainbow = createToggle("Thanhcong sub", "HIỆU ỨNG RAINBOW CẦU VỒNG", 10, function(state) toggleVisualEffects("Rainbow", state) end)
local EffBtn_Ice = createToggle("Thanhcong sub", "HIỆU ỨNG BĂNG GIÁ RƠI", 11, function(state) toggleVisualEffects("Ice", state) end)
local EffBtn_Smoke = createToggle("Thanhcong sub", "HIỆU ỨNG KHÓI BAY", 12, function(state) toggleVisualEffects("Smoke", state) end)

-- FREECAM LOGIC
local freecamCamPart = nil
local freecamConnection = nil

function toggleFreecam(enable)
    State.Freecam_Enabled = enable
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if enable then
        if root and hum then
            root.Anchored = true
        end
        Camera.CameraType = Enum.CameraType.Scriptable
        
        freecamCamPart = Instance.new("Part")
        freecamCamPart.Transparency = 1
        freecamCamPart.CanCollide = false
        freecamCamPart.Anchored = true
        freecamCamPart.CFrame = Camera.CFrame
        freecamCamPart.Parent = workspace

        freecamConnection = RunService.RenderStepped:Connect(function()
            if not State.Freecam_Enabled then return end
            Camera.CFrame = freecamCamPart.CFrame
        end)
    else
        if freecamConnection then freecamConnection:Disconnect(); freecamConnection = nil end
        if freecamCamPart then freecamCamPart:Destroy(); freecamCamPart = nil end
        if root then root.Anchored = false end
        Camera.CameraType = Enum.CameraType.Custom
    end
end

-- FAKE CLONE LOGIC
function toggleFakeClone(enable)
    State.Clone_Active = enable
    if enable then
        local char = LocalPlayer.Character
        if not char then return end
        
        char.Archivable = true
        local clone = char:Clone()
        char.Archivable = false
        
        clone:ScaleTo(0.5)
        clone.Name = LocalPlayer.Name .. " (Clone)"
        
        local root = clone:FindFirstChild("HumanoidRootPart")
        local pRoot = char:FindFirstChild("HumanoidRootPart")
        if root and pRoot then
            root.CFrame = pRoot.CFrame * CFrame.new(2, 0, 0)
        end
        
        clone.Parent = workspace
        State.Clone_Model = clone

        task.spawn(function()
            while State.Clone_Active and State.Clone_Model and State.Clone_Model.Parent do
                if State.Clone_Mode == "Follow" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local cHum = State.Clone_Model:FindFirstChildOfClass("Humanoid")
                    if cHum then
                        cHum:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(2, 0, 2))
                    end
                end
                task.wait(0.3)
            end
        end)
    else
        if State.Clone_Model then
            State.Clone_Model:Destroy()
            State.Clone_Model = nil
        end
    end
end

-- SPIDER CLIMB LOGIC
RunService.Stepped:Connect(function()
    if State.Spider_Enabled and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local ray = Ray.new(root.Position, root.CFrame.LookVector * 1.5)
            local part, pos = workspace:FindPartOnRayWithIgnoreList(ray, {char})
            if part then
                root.Velocity = Vector3.new(root.Velocity.X, 30, root.Velocity.Z)
            end
        end
    end
end)

-- Thuật toán điều khiển Fly Mobile 3D
local flyRenderConnection
function toggleFly(enable)
    State.Fly_Enabled = enable
    if enable then
        if FlyVelocity then FlyVelocity:Destroy() end
        if FlyGyro then FlyGyro:Destroy() end

        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() 
        local root = char:WaitForChild("HumanoidRootPart") 
        local hum = char:WaitForChild("Humanoid") 
        
        FlyVelocity = Instance.new("BodyVelocity") 
        FlyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5) 
        FlyVelocity.Velocity = Vector3.new(0, 0, 0) 
        FlyVelocity.Parent = root 
        
        FlyGyro = Instance.new("BodyGyro") 
        FlyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5) 
        FlyGyro.CFrame = root.CFrame 
        FlyGyro.Parent = root 
        
        flyRenderConnection = RunService.Heartbeat:Connect(function() 
            if not State.Fly_Enabled or not char.Parent or not root.Parent then 
                if flyRenderConnection then flyRenderConnection:Disconnect() end 
                return 
            end 
            
            local moveDir = hum.MoveDirection 
            local camCFrame = Camera.CFrame 
            
            if moveDir.Magnitude > 0 then 
                local rawDirection = camCFrame:VectorToWorldSpace(Vector3.new(moveDir.X, 0, moveDir.Z)) 
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then 
                    FlyVelocity.Velocity = Vector3.new(rawDirection.X, 1, rawDirection.Z).Unit * State.Fly_Speed 
                else 
                    FlyVelocity.Velocity = camCFrame.LookVector * State.Fly_Speed * (moveDir.Z < 0 and 1 or -1) + camCFrame.RightVector * State.Fly_Speed * (moveDir.X > 0 and 1 or -1) 
                    FlyVelocity.Velocity = FlyVelocity.Velocity.Unit * State.Fly_Speed 
                end 
            else 
                FlyVelocity.Velocity = Vector3.new(0, 0.1, 0) 
            end 
            FlyGyro.CFrame = camCFrame 
        end) 
    else 
        if flyRenderConnection then flyRenderConnection:Disconnect(); flyRenderConnection = nil end 
        if FlyVelocity then FlyVelocity:Destroy() FlyVelocity = nil end 
        if FlyGyro then FlyGyro:Destroy() FlyGyro = nil end 
    end 
end

-- Hiệu ứng hình ảnh nhân vật
function toggleVisualEffects(mode, enable)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if enable then 
        State.VisualEffects_Enabled = true 
        if mode ~= "Rainbow" and EffBtn_Rainbow.Text:find("ON") then EffBtn_Rainbow.MouseButton1Click:Fire() end 
        if mode ~= "Ice" and EffBtn_Ice.Text:find("ON") then EffBtn_Ice.MouseButton1Click:Fire() end 
        if mode ~= "Smoke" and EffBtn_Smoke.Text:find("ON") then EffBtn_Smoke.MouseButton1Click:Fire() end 
        
        for _, v in ipairs(root:GetChildren()) do 
            if v:IsA("Trail") or v:IsA("Sparkles") or v:IsA("Attachment") or v:IsA("ParticleEmitter") or v:IsA("Smoke") then 
                v:Destroy() 
            end 
        end 
        
        currentActiveEffect = mode 
        if mode == "Rainbow" then 
            local topAtt = Instance.new("Attachment", root) topAtt.Position = Vector3.new(0, 2, 0) 
            local bottomAtt = Instance.new("Attachment", root) bottomAtt.Position = Vector3.new(0, -2, 0) 
            ActiveTrail = Instance.new("Trail") 
            ActiveTrail.Attachment0 = topAtt 
            ActiveTrail.Attachment1 = bottomAtt 
            ActiveTrail.Lifetime = 0.6 
            ActiveTrail.WidthScale = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}) 
            ActiveTrail.Transparency = NumberSequence.new(0.2) 
            ActiveTrail.Texture = "rbxassetid://401172639" 
            ActiveTrail.Parent = root 
            
            ActiveSparkles = Instance.new("Sparkles") 
            ActiveSparkles.Parent = root 
            
            task.spawn(function() 
                local hue = 0 
                while State.VisualEffects_Enabled and currentActiveEffect == "Rainbow" and ActiveTrail and ActiveTrail.Parent do 
                    hue = (hue + 0.01) % 1 
                    local rainbowColor = Color3.fromHSV(hue, 1, 1) 
                    ActiveTrail.Color = ColorSequence.new(rainbowColor) 
                    ActiveSparkles.SparkleColor = rainbowColor 
                    task.wait(0.03) 
                end 
            end) 
        elseif mode == "Ice" then 
            local IceEmitter = Instance.new("ParticleEmitter") 
            IceEmitter.Texture = "rbxassetid://243089305" 
            IceEmitter.Color = ColorSequence.new(Color3.fromRGB(150, 240, 255)) 
            IceEmitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0)}) 
            IceEmitter.Lifetime = NumberRange.new(0.8, 1.5) 
            IceEmitter.Rate = 60 
            IceEmitter.Speed = NumberRange.new(1, 4) 
            IceEmitter.VelocityInheritance = 0.4 
            IceEmitter.EmissionDirection = Enum.NormalId.Bottom 
            IceEmitter.Parent = root 
        elseif mode == "Smoke" then 
            local SmokeEmitter = Instance.new("ParticleEmitter") 
            SmokeEmitter.Texture = "rbxassetid://252060136" 
            SmokeEmitter.Color = ColorSequence.new(Color3.fromRGB(220, 220, 220)) 
            SmokeEmitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.5), NumberSequenceKeypoint.new(1, 4)}) 
            SmokeEmitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(0.7, 0.6), NumberSequenceKeypoint.new(1, 1)}) 
            SmokeEmitter.Lifetime = NumberRange.new(1, 2) 
            SmokeEmitter.Rate = 35 
            SmokeEmitter.Speed = NumberRange.new(0.5, 2) 
            SmokeEmitter.VelocityInheritance = 0.3 
            SmokeEmitter.Parent = root 
        end 
    else 
        if currentActiveEffect == mode then 
            State.VisualEffects_Enabled = false 
            currentActiveEffect = nil 
            for _, v in ipairs(root:GetChildren()) do 
                if v:IsA("Trail") or v:IsA("Sparkles") or v:IsA("Attachment") or v:IsA("ParticleEmitter") or v:IsA("Smoke") then 
                    v:Destroy() 
                end 
            end 
            ActiveTrail = nil 
            ActiveSparkles = nil 
        end 
    end 
end

Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if Camera.FieldOfView ~= State.Camera_FOV_Value then
        Camera.FieldOfView = State.Camera_FOV_Value
    end
end)

-- HỆ THỐNG DRAWING ESP
function createESP(player)
    if State.ESP_Storage[player] then return end
    local box = Drawing.new("Square") box.Color = Color3.fromRGB(255, 50, 50) box.Thickness = 1.5 box.Filled = false box.Visible = false
    local nameText = Drawing.new("Text") nameText.Color = Color3.fromRGB(255, 255, 255) nameText.Center = true nameText.Outline = true nameText.Visible = false
    State.ESP_Storage[player] = {Box = box, Text = nameText}
end

function removeESP(player) 
    if State.ESP_Storage[player] then 
        State.ESP_Storage[player].Box:Destroy() 
        State.ESP_Storage[player].Text:Destroy() 
        State.ESP_Storage[player] = nil 
    end 
end

Players.PlayerAdded:Connect(createESP) 
Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then createESP(p) end end

RunService.RenderStepped:Connect(function()
    for player, esp in pairs(State.ESP_Storage) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local root = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen and (State.ESP_Name or State.ESP_Box) then
                local distance = (Camera.CFrame.Position - root.Position).Magnitude
                if State.ESP_Name then
                    esp.Text.Position = Vector2.new(screenPos.X, screenPos.Y - 35) 
                    esp.Text.Text = player.Name .. " [" .. math.round(distance) .. "m]"
                    esp.Text.Size = math.clamp(math.round(400 / distance) + 10, 11, 20) 
                    esp.Text.Visible = true
                else 
                    esp.Text.Visible = false 
                end
                
                if State.ESP_Box then
                    local sizeX, sizeY = 2000 / distance, 3000 / distance
                    esp.Box.Size = Vector2.new(sizeX, sizeY) 
                    esp.Box.Position = Vector2.new(screenPos.X - (sizeX / 2), screenPos.Y - (sizeY / 2)) 
                    esp.Box.Visible = true
                else 
                    esp.Box.Visible = false 
                end
            else 
                esp.Box.Visible = false 
                esp.Text.Visible = false 
            end
        else 
            esp.Box.Visible = false 
            esp.Text.Visible = false 
        end
    end
end)

-- VÒNG LẶP DI CHUYỂN NGẦM
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
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do 
            if part:IsA("BasePart") then part.CanCollide = false end 
        end
    end
end)

-- LOGIC FPS BOOSTER
local fpsConnection
function toggleFPS(enable)
    State.FPS_Enabled = enable
    if enable then
        Lighting.GlobalShadows = false; Lighting.ClockTime = 12
        for _, v in ipairs(workspace:GetDescendants()) do 
            if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic 
                    v.CastShadow = false 
                elseif v:IsA("Texture") or v:IsA("Decal") or v:IsA("ParticleEmitter") then 
                    v:Destroy() 
                end 
            end
            fpsConnection = workspace.DescendantAdded:Connect(function(v) 
                if State.FPS_Enabled and v:IsA("BasePart") then 
                    v.Material = Enum.Material.SmoothPlastic 
                    v.CastShadow = false 
                end 
            end)
        else 
            if fpsConnection then fpsConnection:Disconnect() end 
        end
    end

-- LOGIC AIMBOT TỐI ƯU HÓA
function isVisible(targetChar, targetPart)
    local p = RaycastParams.new() 
    p.FilterType = Enum.RaycastFilterType.Exclude 
    p.FilterDescendantsInstances = {LocalPlayer.Character, targetChar}
    return workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, p) == nil
end

function getClosestAimTarget()
    local closest, shortestDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if State.Aim_Mode == "All" or State.Aim_Mode == "Players" then 
        for _, p in ipairs(Players:GetPlayers()) do 
            if p ~= LocalPlayer and p.Character then 
                local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart") 
                local hum = p.Character:FindFirstChildOfClass("Humanoid") 
                if head and hum and hum.Health > 0 then 
                    local pos, visible = Camera:WorldToViewportPoint(head.Position) 
                    if visible and isVisible(p.Character, head) then 
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude 
                        if dist <= State.Aim_Radius and dist < shortestDist then 
                            shortestDist = dist 
                            closest = {Character = p.Character, Part = head} 
                        end 
                    end 
                end 
            end 
        end 
    end 
    
    if State.Aim_Mode == "All" or State.Aim_Mode == "NPCs" then 
        for _, model in ipairs(workspace:GetChildren()) do 
            if model:IsA("Model") and model ~= LocalPlayer.Character then 
                if not Players:GetPlayerFromCharacter(model) then 
                    local hum = model:FindFirstChildOfClass("Humanoid") 
                    local targetPart = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart") 
                    if hum and targetPart and hum.Health > 0 then 
                        local pos, visible = Camera:WorldToViewportPoint(targetPart.Position) 
                        if visible and isVisible(model, targetPart) then 
                            local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude 
                            if dist <= State.Aim_Radius and dist < shortestDist then 
                                shortestDist = dist 
                                closest = {Character = model, Part = targetPart} 
                            end 
                        end 
                    end 
                end 
            end 
        end 
    end 
    
    return closest 
end

local aimConnection
function toggleAimbot(enable)
    State.Aim_Enabled = enable
    if enable then
        FOVCircle.Visible = true
        aimConnection = RunService.RenderStepped:Connect(function()
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            if currentAimTarget and currentAimTarget.Character.Parent and isVisible(currentAimTarget.Character, currentAimTarget.Part) then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, currentAimTarget.Part.Position)
            else 
                currentAimTarget = getClosestAimTarget() 
            end
        end)
    else 
        FOVCircle.Visible = false
        if aimConnection then aimConnection:Disconnect() end 
    end
end

-- LOGIC HITBOX EXPANDER
function toggleHitbox(enable)
    State.Hitbox_Enabled = enable
    if enable then
        hitboxConnection = RunService.RenderStepped:Connect(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = p.Character.HumanoidRootPart
                    if not State.Hitbox_Originals[rootPart] then 
                        State.Hitbox_Originals[rootPart] = { 
                            Size = rootPart.Size, 
                            Transparency = rootPart.Transparency, 
                            CanCollide = rootPart.CanCollide 
                        } 
                    end
                    rootPart.Size = Vector3.new(State.Hitbox_Size, State.Hitbox_Size, State.Hitbox_Size) 
                    rootPart.Transparency = State.Hitbox_Transparency 
                    rootPart.CanCollide = false
                end
            end
        end)
    else
        if hitboxConnection then hitboxConnection:Disconnect() end
        for rPart, orig in pairs(State.Hitbox_Originals) do 
            if rPart and rPart.Parent then 
                rPart.Size = orig.Size 
                rPart.Transparency = orig.Transparency 
                rPart.CanCollide = orig.CanCollide 
            end 
        end
        table.clear(State.Hitbox_Originals)
    end
end

TransBox.FocusLost:Connect(function() 
    State.Hitbox_Transparency = math.clamp(tonumber(TransBox.Text) or 0.5, 0, 1) 
    TransBox.Text = tostring(State.Hitbox_Transparency) 
end)

AimMode_Btn.MouseButton1Click:Connect(function()
    if State.Aim_Mode == "All" then 
        State.Aim_Mode = "Players" 
        AimMode_Btn.Text = "AIM TARGET: PLAYERS" 
        AimMode_Btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    elseif State.Aim_Mode == "Players" then 
        State.Aim_Mode = "NPCs" 
        AimMode_Btn.Text = "AIM TARGET: NPCS" 
        AimMode_Btn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    else 
        State.Aim_Mode = "All" 
        AimMode_Btn.Text = "AIM TARGET: ALL" 
        AimMode_Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50) 
    end 
    currentAimTarget = nil
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if State.VisualEffects_Enabled and currentActiveEffect then
        local effectToRestore = currentActiveEffect
        toggleVisualEffects(effectToRestore, false)
        toggleVisualEffects(effectToRestore, true)
    end
end)

