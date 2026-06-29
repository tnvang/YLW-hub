local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local KeyGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
KeyGui.Name = "GeminiPro_KeySystem"
local KeyFrame = Instance.new("Frame", KeyGui)
KeyFrame.Size, KeyFrame.Position, KeyFrame.BackgroundColor3, KeyFrame.BorderSizePixel = UDim2.new(0, 360, 0, 180), UDim2.new(0.5, -180, 0.4, -90), Color3.fromRGB(22, 22, 30), 0
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size, KeyTitle.BackgroundColor3, KeyTitle.Text, KeyTitle.TextColor3, KeyTitle.Font, KeyTitle.TextSize = UDim2.new(1, 0, 0, 45), Color3.fromRGB(30, 30, 42), "XÁC MINH NGƯỜI DÙNG (KEY SCRIPT)", Color3.fromRGB(255, 200, 0), Enum.Font.SourceSansBold, 15
Instance.new("UICorner", KeyTitle).CornerRadius = UDim.new(0, 8)
local QuestionLabel = Instance.new("TextLabel", KeyFrame)
QuestionLabel.Position, QuestionLabel.Size, QuestionLabel.BackgroundTransparency, QuestionLabel.Text, QuestionLabel.TextColor3, QuestionLabel.Font, QuestionLabel.TextSize, QuestionLabel.TextWrapped = UDim2.new(0, 10, 0, 55), UDim2.new(1, -20, 0, 45), 1, "Tấn Vàng người tạo script có đẹp trai không?", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 15, true
local CorrectBtn = Instance.new("TextButton", KeyFrame)
CorrectBtn.Position, CorrectBtn.Size, CorrectBtn.BackgroundColor3, CorrectBtn.Text, CorrectBtn.TextColor3, CorrectBtn.Font, CorrectBtn.TextSize = UDim2.new(0.08, 0, 0.68, 0), UDim2.new(0.4, 0, 0, 38), Color3.fromRGB(0, 160, 90), "Rất xinh trai", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 14
Instance.new("UICorner", CorrectBtn).CornerRadius = UDim.new(0, 6)
local WrongBtn = Instance.new("TextButton", KeyFrame)
WrongBtn.Position, WrongBtn.Size, WrongBtn.BackgroundColor3, WrongBtn.Text, WrongBtn.TextColor3, WrongBtn.Font, WrongBtn.TextSize = UDim2.new(0.52, 0, 0.68, 0), UDim2.new(0.4, 0, 0, 38), Color3.fromRGB(180, 40, 40), "Tuất", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 14
Instance.new("UICorner", WrongBtn).CornerRadius = UDim.new(0, 6)
local KeyPassed = false
WrongBtn.MouseButton1Click:Connect(function() LocalPlayer:Kick("Bạn đã chọn đáp án sai! Trở lại khi đã có câu trả lời đúng.") end)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "GeminiPro_Menu"
ScreenGui.ResetOnSpawn, ScreenGui.Enabled = false, false
CorrectBtn.MouseButton1Click:Connect(function() KeyPassed = true KeyGui:Destroy() ScreenGui.Enabled = true end)
local Options = {Aimbot = false, AimNPC = false, ShowFOV = true, FOVRadius = 120, HitboxChance = 100, HitboxSize = 2, WalkSpeed = 16, JumpPower = 50, InfJump = false, Noclip = false, Fly = false, FlySpeed = 30, ESPName = false, ESPBox = false}
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name, MainFrame.Position, MainFrame.Size, MainFrame.BackgroundColor3, MainFrame.BorderSizePixel, MainFrame.Active, MainFrame.Draggable = "MainFrame", UDim2.new(0.2, 0, 0.15, 0), UDim2.new(0, 520, 0, 360), Color3.fromRGB(18, 18, 24), 0, true, true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size, Title.BackgroundColor3, Title.Text, Title.TextColor3, Title.Font, Title.TextSize, Title.TextXAlignment = UDim2.new(1, 0, 0, 40), Color3.fromRGB(28, 28, 36), "   GEMINIPRO - PREMIUM MULTIHACK", Color3.fromRGB(0, 220, 255), Enum.Font.SourceSansBold, 18, Enum.TextXAlignment.Left
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Position, ToggleButton.Size, ToggleButton.BackgroundColor3, ToggleButton.Text, ToggleButton.TextColor3, ToggleButton.Font, ToggleButton.TextSize = UDim2.new(0.02, 0, 0.05, 0), UDim2.new(0, 110, 0, 35), Color3.fromRGB(0, 150, 255), "Menu: Hiện", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 14
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)
ToggleButton.MouseButton1Click:Connect(function() if not KeyPassed then return end MainFrame.Visible = not MainFrame.Visible ToggleButton.Text = MainFrame.Visible and "Menu: Hiện" or "Menu: Ẩn" end)
local LeftScroll = Instance.new("ScrollingFrame", MainFrame)
LeftScroll.Position, LeftScroll.Size, LeftScroll.BackgroundTransparency, LeftScroll.CanvasSize, LeftScroll.ScrollBarThickness = UDim2.new(0.02, 0, 0.13, 0), UDim2.new(0, 240, 0, 300), 1, UDim2.new(0, 0, 0, 650), 4
local ListLayout = Instance.new("UIListLayout", LeftScroll)
ListLayout.Padding = UDim.new(0, 6)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness, FOVCircle.Color, FOVCircle.Radius, FOVCircle.Filled, FOVCircle.Visible = 1.5, Color3.fromRGB(0, 255, 255), Options.FOVRadius, false, false
RunService.RenderStepped:Connect(function() if not KeyPassed then FOVCircle.Visible = false return end FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) FOVCircle.Radius = Options.FOVRadius FOVCircle.Visible = Options.ShowFOV end)
local function IsVisible(TargetPart)
    local Character = LocalPlayer.Character if not Character then return false end
    local RaycastParamsArgs = RaycastParams.new()
    RaycastParamsArgs.FilterType = Enum.RaycastFilterType.Exclude
    RaycastParamsArgs.FilterDescendantsInstances = {Character, TargetPart.Parent}
    local RaycastResult = workspace:Raycast(Camera.CFrame.Position, (TargetPart.Position - Camera.CFrame.Position), RaycastParamsArgs)
    return RaycastResult == nil
end
local function GetClosestTarget()
    if not KeyPassed then return nil end
    local ClosestTarget, MaxDistance, CenterScreen = nil, Options.FOVRadius, Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if Options.Aimbot then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character.Humanoid.Health > 0 then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if OnScreen then
                    local Dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - CenterScreen).Magnitude
                    if Dist < MaxDistance and IsVisible(p.Character.Head) then MaxDistance = Dist ClosestTarget = p.Character.Head end
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
                        if Dist < MaxDistance and IsVisible(obj.Parent.Head) then MaxDistance = Dist ClosestTarget = obj.Parent.Head end
                    end
                end
            end
        end
    end
    return ClosestTarget
end
RunService.RenderStepped:Connect(function()
    if not KeyPassed then return end
    if Options.Aimbot or Options.AimNPC then local Target = GetClosestTarget() if Target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position) end end
end)
task.spawn(function()
    while task.wait(0.5) do
        if KeyPassed then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local Roll = math.random(1, 100)
                    if Roll <= Options.HitboxChance and Options.HitboxSize > 2 then
                        p.Character.HumanoidRootPart.Size = Vector3.new(Options.HitboxSize, Options.HitboxSize, Options.HitboxSize)
                        p.Character.HumanoidRootPart.Transparency, p.Character.HumanoidRootPart.BrickColor, p.Character.HumanoidRootPart.CanCollide = 0.6, BrickColor.new("Neon orange"), false
                    else
                        p.Character.HumanoidRootPart.Size, p.Character.HumanoidRootPart.Transparency = Vector3.new(2, 2, 2), 1
                    end
                end
            end
        end
    end
end)
local ESPCache = {}
local function CreateESP(Player)
    if ESPCache[Player] then return end
    local Box = Drawing.new("Square")
    Box.Color, Box.Thickness, Box.Filled, Box.Visible = Color3.fromRGB(255, 0, 0), 1.5, false, false
    local Text = Drawing.new("Text")
    Text.Color, Text.Center, Text.Outline, Text.OutlineColor, Text.Visible = Color3.fromRGB(255, 255, 255), true, true, Color3.fromRGB(0, 0, 0), false
    ESPCache[Player] = {Box = Box, Text = Text}
end
local function RemoveESP(Player) if ESPCache[Player] then ESPCache[Player].Box:Remove() ESPCache[Player].Text:Remove() ESPCache[Player] = nil end end
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end)
Players.PlayerRemoving:Connect(RemoveESP)
RunService.RenderStepped:Connect(function()
    for player, drawings in pairs(ESPCache) do
        if KeyPassed then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.Health > 0 then
                local hrp, head = char.HumanoidRootPart, char.Head
                local hrpPos, hrpOnScreen = Camera:WorldToViewportPoint(hrp.Position)
                if hrpOnScreen then
                    local headPos, legPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)), Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    local boxHeight = math.abs(headPos.Y - legPos.Y)
                    local boxWidth = boxHeight / 1.5
                    local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
                    local calculatedFontSize = math.clamp(math.floor(20 - (distance / 45)), 11, 16)
                    if Options.ESPBox then
                        drawings.Box.Size, drawings.Box.Position, drawings.Box.Visible = Vector2.new(boxWidth, boxHeight), Vector2.new(hrpPos.X - boxWidth / 2, hrpPos.Y - boxHeight / 2), true
                    else drawings.Box.Visible = false end
                    if Options.ESPName then
                        drawings.Text.Text, drawings.Text.Size, drawings.Text.Position, drawings.Text.Visible = player.Name, calculatedFontSize, Vector2.new(hrpPos.X, (hrpPos.Y - boxHeight / 2) - 15), true
                    else drawings.Text.Visible = false end
                else drawings.Box.Visible, drawings.Text.Visible = false, false end
            else drawings.Box.Visible, drawings.Text.Visible = false, false end
        else drawings.Box.Visible, drawings.Text.Visible = false, false end
    end
end)
local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.Velocity, BodyVelocity.MaxForce = Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)
RunService.RenderStepped:Connect(function()
    if not KeyPassed then return end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp, hum = LocalPlayer.Character.HumanoidRootPart, LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed, hum.JumpPower = Options.WalkSpeed, Options.JumpPower end
        if Options.Fly then
            BodyVelocity.Parent, BodyVelocity.MaxForce = hrp, Vector3.new(9e9, 9e9, 9e9)
            local VelocityY = UserInputService:IsKeyDown(Enum.KeyCode.Space) and Options.FlySpeed or 0
            BodyVelocity.Velocity = (hum.MoveDirection * Options.FlySpeed) + Vector3.new(0, VelocityY, 0)
        else BodyVelocity.MaxForce, BodyVelocity.Parent = Vector3.new(0, 0, 0), nil end
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = not Options.Noclip and (part.Name ~= "HumanoidRootPart") or false end
        end
    end
end)
UserInputService.JumpRequest:Connect(function() if not KeyPassed then return end if Options.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)
local RightFrame = Instance.new("Frame", MainFrame)
RightFrame.Position, RightFrame.Size, RightFrame.BackgroundTransparency = UDim2.new(0.52, 0, 0.13, 0), UDim2.new(0, 235, 0, 300), 1
local TeleportScroll = Instance.new("ScrollingFrame", RightFrame)
TeleportScroll.Position, TeleportScroll.Size, TeleportScroll.BackgroundColor3, TeleportScroll.CanvasSize = UDim2.new(0, 0, 0.13, 0), UDim2.new(1, 0, 0.87, 0), Color3.fromRGB(24, 24, 32), UDim2.new(0, 0, 0, 600)
Instance.new("UICorner", TeleportScroll).CornerRadius = UDim.new(0, 6)
local TeleportLayout = Instance.new("UIListLayout", TeleportScroll)
TeleportLayout.Padding = UDim.new(0, 4)
local ResetBtn = Instance.new("TextButton", RightFrame)
ResetBtn.Size, ResetBtn.BackgroundColor3, ResetBtn.Text, ResetBtn.TextColor3, ResetBtn.Font, ResetBtn.TextSize = UDim2.new(1, 0, 0, 30), Color3.fromRGB(0, 180, 120), "🔄 Cập nhật danh sách Sever", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 13
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)
local function BuildTeleportMenu()
    TeleportScroll:ClearAllChildren() Instance.new("UIListLayout", TeleportScroll).Padding = UDim.new(0, 4)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local PBtn = Instance.new("TextButton", TeleportScroll)
            PBtn.Size, PBtn.BackgroundColor3, PBtn.Text, PBtn.TextColor3, PBtn.Font, PBtn.TextSize = UDim2.new(0.95, 0, 0, 32), Color3.fromRGB(36, 36, 46), "Teleport -> " .. p.Name, Color3.fromRGB(255, 255, 255), Enum.Font.SourceSans, 13
            Instance.new("UICorner", PBtn).CornerRadius = UDim.new(0, 4)
            PBtn.MouseButton1Click:Connect(function() if not KeyPassed then return end if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0) end end)
        end
    end
end
ResetBtn.MouseButton1Click:Connect(BuildTeleportMenu) BuildTeleportMenu()
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Part") or obj:IsA("MeshPart") then obj.Material, obj.CastShadow = Enum.Material.SmoothPlastic, false
    elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj:Destroy() end
end
local HUDFrame = Instance.new("Frame", ScreenGui)
HUDFrame.Name, HUDFrame.Position, HUDFrame.Size, HUDFrame.BackgroundColor3, HUDFrame.BackgroundTransparency = "HUDFrame", UDim2.new(0.82, 0, 0.02, 0), UDim2.new(0, 150, 0, 75), Color3.fromRGB(15, 15, 20), 0.2
Instance.new("UICorner", HUDFrame).CornerRadius = UDim.new(0, 6)
local HUDLabel = Instance.new("TextLabel", HUDFrame)
HUDLabel.Position, HUDLabel.Size, HUDLabel.BackgroundTransparency, HUDLabel.TextColor3, HUDLabel.Font, HUDLabel.TextSize, HUDLabel.TextXAlignment = UDim2.new(0.08, 0, 0.22, 0), UDim2.new(0.84, 0, 0.75, 0), 1, Color3.fromRGB(0, 255, 150), Enum.Font.Code, 10, Enum.TextXAlignment.Left
local HUDToggle = Instance.new("TextButton", HUDFrame)
HUDToggle.Size, HUDToggle.BackgroundColor3, HUDToggle.Text, HUDToggle.TextColor3, HUDToggle.Font, HUDToggle.TextSize = UDim2.new(1, 0, 0, 18), Color3.fromRGB(25, 25, 30), "[ HUD MTR ]", Color3.fromRGB(255, 255, 0), Enum.Font.SourceSansBold, 10
HUDToggle.MouseButton1Click:Connect(function() if not KeyPassed then return end HUDLabel.Visible = not HUDLabel.Visible HUDFrame.Size = HUDLabel.Visible and UDim2.new(0, 150, 0, 75) or UDim2.new(0, 150, 0, 18) end)
local Frames = 0 RunService.RenderStepped:Connect(function() Frames = Frames + 1 end)
task.spawn(function()
    while task.wait(1) do
        if KeyPassed then
            local currentFps, currentPing = Frames, game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():sub(1, 5)
            Frames = 0
            HUDLabel.Text = string.format("FPS: %d | MS: %s\nCPU: %d%%\nPING: %s ms\nTIME: %s", currentFps, currentPing, math.clamp(math.floor((1 / currentFps) * 3500), 15, 85), currentPing, os.date("%H:%M:%S"))
        end
    end
end)
local function CreateNewToggle(Text, OptionName)
    local TBtn = Instance.new("TextButton", LeftScroll)
    TBtn.Size, TBtn.BackgroundColor3, TBtn.Text, TBtn.TextColor3, TBtn.Font, TBtn.TextSize = UDim2.new(0.95, 0, 0, 36), Options[OptionName] and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50), Options[OptionName] and Text .. ": ON" or Text .. ": OFF", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 14
    Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)
    TBtn.MouseButton1Click:Connect(function() if not KeyPassed then return end Options[OptionName] = not Options[OptionName] TBtn.BackgroundColor3 = Options[OptionName] and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50) TBtn.Text = Options[OptionName] and Text .. ": ON" or Text .. ": OFF" end)
end
local function CreateNewSlider(Text, Min, Max, OptionName, UpdateFunc)
    local Container = Instance.new("Frame", LeftScroll)
    Container.Size, Container.BackgroundTransparency = UDim2.new(0.95, 0, 0, 45), 1
    local Label = Instance.new("TextLabel", Container)
    Label.Size, Label.Text, Label.TextColor3, Label.BackgroundTransparency, Label.Font, Label.TextSize = UDim2.new(1, 0, 0, 20), Text .. ": " .. tostring(Options[OptionName]), Color3.fromRGB(255, 255, 255), 1, Enum.Font.SourceSans, 13
    local SlideBar = Instance.new("TextButton", Container)
    SlideBar.Position, SlideBar.Size, SlideBar.BackgroundColor3, SlideBar.Text = UDim2.new(0, 0, 0, 22), UDim2.new(1, 0, 0, 15), Color3.fromRGB(40, 40, 50), ""
    Instance.new("UICorner", SlideBar).CornerRadius = UDim.new(0, 4)
    SlideBar.MouseButton1Click:Connect(function()
        if not KeyPassed then return end
        local MousePos = UserInputService:GetMouseLocation().X
        local Value = math.floor(Min + (Max - Min) * math.clamp((MousePos - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1))
        Options[OptionName] = Value Label.Text = Text .. ": " .. tostring(Value)
        if UpdateFunc then UpdateFunc(Value) end
    end)
end
CreateNewToggle("ESP Hiện Tên", "ESPName") CreateNewToggle("ESP Khung Người", "ESPBox") CreateNewToggle("Aimbot Người", "Aimbot") CreateNewToggle("Aimbot NPC", "AimNPC")
CreateNewToggle("Hiển thị vòng FOV", "ShowFOV") CreateNewToggle("Xuyên Tường (Noclip)", "Noclip") CreateNewToggle("Nhảy Vô Hạn", "InfJump") CreateNewToggle("Chế Độ Bay (Fly)", "Fly")
CreateNewSlider("Tốc Độ Chạy (Walk)", 16, 250, "WalkSpeed") CreateNewSlider("Nhảy Cao (Jump)", 50, 350, "JumpPower") CreateNewSlider("Kích cỡ Hitbox", 2, 30, "HitboxSize")
CreateNewSlider("Tỷ lệ % Hitbox", 1, 100, "HitboxChance") CreateNewSlider("Tốc Độ Bay", 10, 120, "FlySpeed") CreateNewSlider("Bán Kính FOV Ngắm", 30, 400, "FOVRadius")
