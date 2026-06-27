-- [[ GEMINIPRO PREMIUM MENU SCRIPT - FIXED MOBILE CONSOLE 2026 ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Tạo Core UI chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GeminiPro_Menu"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Cấu hình mặc định
local Options = {
    Aimbot = false,
    AimNPC = false,
    FOVRadius = 120,
    HitboxChance = 100, -- Mặc định 100% tỉ lệ chính xác
    HitboxSize = 2,     -- Gốc mặc định là 2
    ESP = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 30
}

------------------------------------------------------------------------
-- [ 1. GIAO DIỆN UI THU GỌN VÀ DI CHUYỂN ]
------------------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Thanh Tiêu đề
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
Title.Text = "   GEMINIPRO - PREMIUM MULTIHACK"
Title.TextColor3 = Color3.fromRGB(0, 220, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Nút Ẩn/Hiện Menu chính
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Position = UDim2.new(0.02, 0, 0.05, 0)
ToggleButton.Size = UDim2.new(0, 110, 0, 35)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ToggleButton.Text = "Menu: Hiện"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleButton.Text = MainFrame.Visible and "Menu: Hiện" or "Menu: Ẩn"
end)

-- Khung chứa các Nút chức năng (Trái)
local LeftScroll = Instance.new("ScrollingFrame")
LeftScroll.Parent = MainFrame
LeftScroll.Position = UDim2.new(0.02, 0, 0.13, 0)
LeftScroll.Size = UDim2.new(0, 240, 0, 300)
LeftScroll.BackgroundTransparency = 1
LeftScroll.CanvasSize = UDim2.new(0, 0, 0, 500)
LeftScroll.ScrollBarThickness = 4

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = LeftScroll
ListLayout.Padding = UDim.new(0, 6)

------------------------------------------------------------------------
-- [ 2. VÒNG TRÒN AIMBOT GỐC GIỮA MÀN HÌNH PHONE ]
------------------------------------------------------------------------
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Radius = Options.FOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = true

RunService.RenderStepped:Connect(function()
    -- Luôn cố định tâm chính giữa màn hình thực tế của điện thoại
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

local function IsVisible(TargetPart)
    local Obstruction = Camera:GetPartsObscuredByPixels({Camera.CFrame.Position, TargetPart.Position}, {LocalPlayer.Character, TargetPart.Parent})
    return #Obstruction == 0
end

local function GetClosestTarget()
    local ClosestTarget = nil
    local MaxDistance = Options.FOVRadius
    local CenterScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if Options.Aimbot then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character.Humanoid.Health > 0 then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if OnScreen then
                    local Dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - CenterScreen).Magnitude
                    if Dist < MaxDistance and IsVisible(p.Character.Head) then
                        MaxDistance = Dist
                        ClosestTarget = p.Character.Head
                    end
                end
            end
        end
    end

    if Options.AimNPC then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Parent and obj.Parent:FindFirstChild("Head") and obj.Parent.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(obj.Parent) then
                if obj.Health > 0 then
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(obj.Parent.Head.Position)
                    if OnScreen then
                        local Dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - CenterScreen).Magnitude
                        if Dist < MaxDistance and IsVisible(obj.Parent.Head) then
                            MaxDistance = Dist
                            ClosestTarget = obj.Parent.Head
                        end
                    end
                end
            end
        end
    end
    return ClosestTarget
end

RunService.RenderStepped:Connect(function()
    if Options.Aimbot or Options.AimNPC then
        local Target = GetClosestTarget()
        if Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end
end)

------------------------------------------------------------------------
-- [ 3. HỆ THỐNG TĂNG HITBOX THEO TỶ LỆ CHÍNH XÁC ]
------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local Roll = math.random(1, 100)
                -- Kiểm tra nếu nằm trong tỷ lệ % được cho phép thì tăng kích thước
                if Roll <= Options.HitboxChance and Options.HitboxSize > 2 then
                    p.Character.HumanoidRootPart.Size = Vector3.new(Options.HitboxSize, Options.HitboxSize, Options.HitboxSize)
                    p.Character.HumanoidRootPart.Transparency = 0.6
                    p.Character.HumanoidRootPart.BrickColor = BrickColor.new("Neon orange")
                    p.Character.HumanoidRootPart.CanCollide = false
                else
                    p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 2)
                    p.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end
end)

------------------------------------------------------------------------
-- [ 4. FIX CHỨC NĂNG BAY (FLY) & DI CHUYỂN ]
------------------------------------------------------------------------
local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.Velocity = Vector3.new(0, 0, 0)
BodyVelocity.MaxForce = Vector3.new(0, 0, 0)

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if Options.Fly then
            BodyVelocity.Parent = hrp
            BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            
            local MoveDirection = hum.MoveDirection
            local VelocityY = 0
            
            -- Ấn nút Nhảy trên Mobile để nâng độ cao khi đang bay
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                VelocityY = Options.FlySpeed
            end
            
            BodyVelocity.Velocity = (MoveDirection * Options.FlySpeed) + Vector3.new(0, VelocityY, 0)
        else
            BodyVelocity.MaxForce = Vector3.new(0, 0, 0)
            BodyVelocity.Parent = nil
        end
        
        -- Noclip
        if Options.Noclip then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

-- Nhảy vô hạn
UserInputService.JumpRequest:Connect(function()
    if Options.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

------------------------------------------------------------------------
-- [ 5. CHỨC NĂNG TELEPORT & RESET CẬP NHẬT DANH SÁCH ]
------------------------------------------------------------------------
local RightFrame = Instance.new("Frame")
RightFrame.Parent = MainFrame
RightFrame.Position = UDim2.new(0.52, 0, 0.13, 0)
RightFrame.Size = UDim2.new(0, 235, 0, 300)
RightFrame.BackgroundTransparency = 1

local TeleportScroll = Instance.new("ScrollingFrame")
TeleportScroll.Parent = RightFrame
TeleportScroll.Position = UDim2.new(0, 0, 0.13, 0)
TeleportScroll.Size = UDim2.new(1, 0, 0.87, 0)
TeleportScroll.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
TeleportScroll.CanvasSize = UDim2.new(0, 0, 0, 600)
Instance.new("UICorner", TeleportScroll).CornerRadius = UDim.new(0, 6)

local TeleportLayout = Instance.new("UIListLayout")
TeleportLayout.Parent = TeleportScroll
TeleportLayout.Padding = UDim.new(0, 4)

local ResetBtn = Instance.new("TextButton")
ResetBtn.Parent = RightFrame
ResetBtn.Size = UDim2.new(1, 0, 0, 30)
ResetBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
ResetBtn.Text = "🔄 Cập nhật danh sách Sever"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.Font = Enum.Font.SourceSansBold
ResetBtn.TextSize = 13
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)

local function BuildTeleportMenu()
    TeleportScroll:ClearAllChildren()
    Instance.new("UIListLayout", TeleportScroll).Padding = UDim.new(0, 4)
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local PBtn = Instance.new("TextButton")
            PBtn.Size = UDim2.new(0.95, 0, 0, 32)
            PBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 46)
            PBtn.Text = "Teleport -> " .. p.Name
            PBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            PBtn.Font = Enum.Font.SourceSans
            PBtn.TextSize = 13
            PBtn.Parent = TeleportScroll
            Instance.new("UICorner", PBtn).CornerRadius = UDim.new(0, 4)
            
            PBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                end
            end)
        end
    end
end
ResetBtn.MouseButton1Click:Connect(BuildTeleportMenu)
BuildTeleportMenu()

------------------------------------------------------------------------
-- [ 6. NÂNG CẤP FPS BOOST THỰC TẾ TRÊN DI ĐỘNG ]
------------------------------------------------------------------------
local function RealFPSBoost()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj:Destroy()
        end
    end
    sethiddenproperty(workspace, "StreamingEnabled", true)
end
RealFPSBoost()

------------------------------------------------------------------------
-- [ 7. HUD ĐO THÔNG SỐ TOÀN DIỆN (CÓ NÚT THU GỌN RIÊNG) ]
------------------------------------------------------------------------
local HUDFrame = Instance.new("Frame")
HUDFrame.Name = "HUDFrame"
HUDFrame.Parent = ScreenGui
HUDFrame.Position = UDim2.new(0.75, 0, 0.02, 0) -- Đưa lên góc trên bên phải để tránh bị đè khuất
HUDFrame.Size = UDim2.new(0, 220, 0, 100)
HUDFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", HUDFrame).CornerRadius = UDim.new(0, 8)

local HUDLabel = Instance.new("TextLabel")
HUDLabel.Parent = HUDFrame
HUDLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
HUDLabel.Size = UDim2.new(0.9, 0, 0.7, 0)
HUDLabel.BackgroundTransparency = 1
HUDLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
HUDLabel.Font = Enum.Font.Code
HUDLabel.TextSize = 12
HUDLabel.TextXAlignment = Enum.TextXAlignment.Left

local HUDToggle = Instance.new("TextButton")
HUDToggle.Parent = HUDFrame
HUDToggle.Size = UDim2.new(1, 0, 0, 22)
HUDToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
HUDToggle.Text = "[ ĐÓNG/MỞ HUD ] USER: GEMINIPRO"
HUDToggle.TextColor3 = Color3.fromRGB(255, 255, 0)
HUDToggle.Font = Enum.Font.SourceSansBold
HUDToggle.TextSize = 11

HUDToggle.MouseButton1Click:Connect(function()
    HUDLabel.Visible = not HUDLabel.Visible
    HUDFrame.Size = HUDLabel.Visible and UDim2.new(0, 220, 0, 100) or UDim2.new(0, 220, 0, 22)
end)

-- Bộ đếm FPS / Hệ thống
local Frames = 0
RunService.RenderStepped:Connect(function() Frames = Frames + 1 end)

task.spawn(function()
    while task.wait(1) do
        local currentFps = Frames
        Frames = 0
        local currentPing = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():sub(1, 5)
        local timeStr = os.date("%H:%M:%S")
        
        -- Giả lập đo hiệu năng CPU di động tương đối dựa trên độ trễ khung hình
        local cpuUsage = math.clamp(math.floor((1 / currentFps) * 3500), 15, 85) 
        
        HUDLabel.Text = string.format("FPS: %d\nPING: %s ms\nCPU: %d%%\nTIME: %s", currentFps, currentPing, cpuUsage, timeStr)
    end
end)

------------------------------------------------------------------------
-- [ TRÌNH TẠO SLIDER & TOGGLE CHO MENU TRÁI ]
------------------------------------------------------------------------
local function CreateNewToggle(Text, OptionName)
    local TBtn = Instance.new("TextButton")
    TBtn.Size = UDim2.new(0.95, 0, 0, 36)
    TBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    TBtn.Text = Text .. ": OFF"
    TBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TBtn.Font = Enum.Font.SourceSansBold
    TBtn.TextSize = 14
    TBtn.Parent = LeftScroll
    Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)
    
    TBtn.MouseButton1Click:Connect(function()
        Options[OptionName] = not Options[OptionName]
        TBtn.BackgroundColor3 = Options[OptionName] and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
        TBtn.Text = Options[OptionName] and Text .. ": ON" or Text .. ": OFF"
    end)
end

local function CreateNewSlider(Text, Min, Max, OptionName, UpdateFunc)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0.95, 0, 0, 45)
    Container.BackgroundTransparency = 1
    Container.Parent = LeftScroll
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = Text .. ": " .. tostring(Options[OptionName])
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 13
    Label.Parent = Container
    
    local SlideBar = Instance.new("TextButton")
    SlideBar.Position = UDim2.new(0, 0, 0, 22)
    SlideBar.Size = UDim2.new(1, 0, 0, 15)
    SlideBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SlideBar.Text = ""
    SlideBar.Parent = Container
    Instance.new("UICorner", SlideBar).CornerRadius = UDim.new(0, 4)
    
    SlideBar.MouseButton1Click:Connect(function()
        local MousePos = UserInputService:GetMouseLocation().X
        local Percent = math.clamp((MousePos - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
        local Value = math.floor(Min + (Max - Min) * Percent)
        Options[OptionName] = Value
        Label.Text = Text .. ": " .. tostring(Value)
        if UpdateFunc then UpdateFunc(Value) end
    end)
end

-- Khởi tạo các phần tử trên Menu Left
CreateNewToggle("Aimbot Người", "Aimbot")
CreateNewToggle("Aimbot NPC", "AimNPC")
CreateNewToggle("Xuyên Tường (Noclip)", "Noclip")
CreateNewToggle("Nhảy Vô Hạn", "InfJump")
CreateNewToggle("Chế Độ Bay (Fly)", "Fly")

-- Thêm thanh kéo Hitbox (Tăng từ 2 đến 30 kích thước)
CreateNewSlider("Kích cỡ Hitbox", 2, 30, "HitboxSize")
-- Thêm thanh kéo Tỉ lệ chính xác % Hitbox
CreateNewSlider("Tỷ lệ % Hitbox", 1, 100, "HitboxChance")
-- Thanh tốc độ bay
CreateNewSlider("Tốc Độ Bay", 10, 120, "FlySpeed")

print("[GEMINIPRO]: Menu Mobile Re-optimized and fully fixed!")

