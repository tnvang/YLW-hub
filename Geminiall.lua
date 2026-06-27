-- [[ ROBLOX PREMIUM MENU SCRIPT - 2026 UPDATE ]] --
local RaycastProperties = RaycastParams.new()
RaycastProperties.FilterType = Enum.RaycastFilterType.Exclude

-- Thư viện UI Đơn giản, trực quan và có nút Thu gọn (Minimize)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TabContainer = Instance.new("ScrollingFrame")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "PremiumMenu"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Nút Thu Gọn / Mở Menu
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleButton.Size = UDim2.new(0, 100, 0, 35)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Text = "Ẩn/Hiện Menu"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.Parent = ToggleButton

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true -- Có thể kéo di chuyển trên màn hình

local UICornerMain = Instance.new("UICorner")
UICornerMain.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "PREMIUM MENU MULTIHACK | USER: BẢN QUYỀN"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

------------------------------------------------------------------------
-- [ 1. CONFIG / BIẾN KHỞI TẠO ]
------------------------------------------------------------------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Options = {
    Aimbot = false,
    AimNPC = false,
    HitboxSize = 2, -- Mặc định gốc là ~2
    HitboxChance = 100,
    ESP = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 50
}

------------------------------------------------------------------------
-- [ 2. DRAWING FOV UI (VÒNG TRÒN AIMBOT) ]
------------------------------------------------------------------------
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Radius = 120
FOVCircle.Filled = false
FOVCircle.Visible = true

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
end)

------------------------------------------------------------------------
-- [ 3. TÍNH NĂNG AIMBOT (CHECK TƯỜNG + ĐẦU + NPC) ]
------------------------------------------------------------------------
local function IsVisible(TargetPart)
    local Obstruction = Camera:GetPartsObscuredByPixels({Camera.CFrame.Position, TargetPart.Position}, {LocalPlayer.Character, TargetPart.Parent})
    return #Obstruction == 0
end

local function GetClosestTarget()
    local ClosestTarget = nil
    local MaxDistance = FOVCircle.Radius

    -- Quét Người chơi
    if Options.Aimbot then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character.Humanoid.Health > 0 then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if OnScreen then
                    local MousePos = UserInputService:GetMouseLocation()
                    local Dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                    if Dist < MaxDistance and IsVisible(p.Character.Head) then
                        MaxDistance = Dist
                        ClosestTarget = p.Character.Head
                    end
                end
            end
        end
    end

    -- Quét NPC (Các Model có Humanoid trong Workspace nhưng không phải Player)
    if Options.AimNPC then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Parent and obj.Parent:FindFirstChild("Head") and obj.Parent.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(obj.Parent) then
                if obj.Health > 0 then
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(obj.Parent.Head.Position)
                    if OnScreen then
                        local MousePos = UserInputService:GetMouseLocation()
                        local Dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
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
-- [ 4. FPS BOOST & HUD THÔNG SỐ CẬP NHẬT MỖI GIÂY ]
------------------------------------------------------------------------
local HUDLabel = Instance.new("TextLabel")
HUDLabel.Parent = ScreenGui
HUDLabel.Position = UDim2.new(0.01, 0, 0.85, 0)
HUDLabel.Size = UDim2.new(0, 250, 0, 90)
HUDLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
HUDLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
HUDLabel.Font = Enum.Font.Code
HUDLabel.TextSize = 13
HUDLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tối ưu hóa tài nguyên (FPS Boost thực tế)
local function OptimizeGame()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end
OptimizeGame() -- Gọi kích hoạt luôn khi chạy script

-- Bộ đếm thông số hệ thống
local FrameCount = 0
RunService.RenderStepped:Connect(function() FrameCount = FrameCount + 1 end)

task.spawn(function()
    while task.wait(1) do
        local fps = FrameCount
        FrameCount = 0
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():sub(1, 5)
        local timeStr = os.date("%H:%M:%S")
        HUDLabel.Text = string.format([[
  [ MENU USER HUD ]
  FPS: %d | Ping: %s ms
  Time: %s
  Status: Đã tối ưu hóa tài nguyên
        ]], fps, ping, timeStr)
    end
end)

------------------------------------------------------------------------
-- [ 5. TÙY CHỈNH HITBOX THEO TỈ LỆ % (TUYỆT ĐỐI CHỈ TĂNG ĐỐI THỦ) ]
------------------------------------------------------------------------
task.spawn(function()
    while task.wait(1) do
        local RollChance = math.random(1, 100)
        if RollChance <= Options.HitboxChance then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(Options.HitboxSize, Options.HitboxSize, Options.HitboxSize)
                    p.Character.HumanoidRootPart.Transparency = 0.7
                    p.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                    p.Character.HumanoidRootPart.CanCollide = false
                end
            end
        else
            -- Trả về bình thường nếu trượt tỉ lệ % chính xác
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 2)
                    p.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end
end)

------------------------------------------------------------------------
-- [ 6. CHỨC NĂNG ESP (BOX + NAME) ]
------------------------------------------------------------------------
local function CreateESP(Player)
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "ESPHighlight"
    Highlight.FillColor = Color3.fromRGB(255, 0, 0)
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 0.5
    
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "ESPName"
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0, 100, 0, 30)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Billboard
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Player.Name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 14

    Player.CharacterAdded:Connect(function(Char)
        if Options.ESP then
            Highlight.Parent = Char
            Billboard.Parent = Char:WaitForChild("Head")
        end
    end)
    
    if Player.Character then
        if Options.ESP then
            Highlight.Parent = Player.Character
            Billboard.Parent = Player.Character:FindFirstChild("Head")
        end
    end
end

-- Bật ESP cho toàn bộ người chơi hiện tại và tương lai
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end)

------------------------------------------------------------------------
-- [ 7. HACK DI CHUYỂN: WALK, JUMP, INFJUMP, NOCLIP, FLY ]
------------------------------------------------------------------------
-- Noclip logic
RunService.Stepped:Connect(function()
    if Options.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Infinite Jump logic
UserInputService.JumpRequest:Connect(function()
    if Options.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Fly Logic
local Flying = false
local deb = true
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}

RunService.RenderStepped:Connect(function()
    if Options.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        -- Bấm nút Nhảy (Space) để kích hoạt trạng thái bay tự do lên xuống bằng phím di chuyển
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, Options.FlySpeed, hrp.Velocity.Z)
        end
    end
end)

------------------------------------------------------------------------
-- [ 8. TELEPORT LIST PLAYERS ]
------------------------------------------------------------------------
-- Để đơn giản hóa và không làm xung đột, tạo một danh sách nhấn để Teleport thẳng đến người đó
local TeleportFrame = Instance.new("ScrollingFrame")
TeleportFrame.Parent = MainFrame
TeleportFrame.Position = UDim2.new(0.6, 0, 0.1, 0)
TeleportFrame.Size = UDim2.new(0, 180, 0, 340)
TeleportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local function UpdateTeleportList()
    TeleportFrame:ClearAllChildren()
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = TeleportFrame
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 30)
            Btn.Text = p.Name
            Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Parent = TeleportFrame
            
            Btn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                end
            end)
        end
    end
end
Players.PlayerAdded:Connect(UpdateTeleportList)
Players.PlayerRemoving:Connect(UpdateTeleportList)
UpdateTeleportList()

------------------------------------------------------------------------
-- [ THIẾT KẾ CÁC NÚT TẮT / BẬT NHANH TRÊN MENU ]
------------------------------------------------------------------------
local function CreateToggleButton(Text, Position, OptionName)
    local Btn = Instance.new("TextButton")
    Btn.Parent = MainFrame
    Btn.Position = Position
    Btn.Size = UDim2.new(0, 120, 0, 35)
    Btn.Text = Text .. ": OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 14
    
    local Corner = Instance.new("UICorner")
    Corner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        Options[OptionName] = not Options[OptionName]
        if Options[OptionName] then
            Btn.Text = Text .. ": ON"
            Btn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        else
            Btn.Text = Text .. ": OFF"
            Btn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        end
    end)
end

-- Tạo các phím tắt tính năng trực quan trên Menu chính
CreateToggleButton("Aimbot Người", UDim2.new(0.05, 0, 0.15, 0), "Aimbot")
CreateToggleButton("Aimbot NPC", UDim2.new(0.05, 0, 0.27, 0), "AimNPC")
CreateToggleButton("Bật ESP", UDim2.new(0.05, 0, 0.39, 0), "ESP")
CreateToggleButton("Nhảy Vô Hạn", UDim2.new(0.05, 0, 0.51, 0), "InfJump")
CreateToggleButton("Xuyên Tường", UDim2.new(0.05, 0, 0.63, 0), "Noclip")
CreateToggleButton("Chế Độ Bay", UDim2.new(0.05, 0, 0.75, 0), "Fly")

-- Thông báo kích hoạt thành công
print("[PREMIUM MENU]: Loaded Successfully. Enjoy your gameplay!")

