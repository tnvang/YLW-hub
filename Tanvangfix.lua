local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name, ScreenGui.ResetOnSpawn = "GeminiPro_Menu", false
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
ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible ToggleButton.Text = MainFrame.Visible and "Menu: Hiện" or "Menu: Ẩn" end)
local LeftScroll = Instance.new("ScrollingFrame", MainFrame)
LeftScroll.Position, LeftScroll.Size, LeftScroll.BackgroundTransparency, LeftScroll.CanvasSize, LeftScroll.ScrollBarThickness = UDim2.new(0.02, 0, 0.13, 0), UDim2.new(0, 240, 0, 300), 1, UDim2.new(0, 0, 0, 650), 4
Instance.new("UIListLayout", LeftScroll).Padding = UDim.new(0, 6)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness, FOVCircle.Color, FOVCircle.Radius, FOVCircle.Filled, FOVCircle.Visible = 1.5, Color3.fromRGB(0, 255, 255), Options.FOVRadius, false, false
RunService.RenderStepped:Connect(function() FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) FOVCircle.Radius = Options.FOVRadius FOVCircle.Visible = Options.ShowFOV end)
local function IsVisible(TargetPart)
    local Character = LocalPlayer.Character if not Character then return false end
    local RaycastParamsArgs = RaycastParams.new()
    RaycastParamsArgs.FilterType = Enum.RaycastFilterType.Exclude
    RaycastParamsArgs.FilterDescendantsInstances = {Character, TargetPart.Parent}
    return workspace:Raycast(Camera.CFrame.Position, (TargetPart.Position - Camera.CFrame.Position), RaycastParamsArgs) == nil
end
local function GetClosestTarget()
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
            if obj:IsA("Humanoid") and obj.Parent and obj.Parent:FindFirstChild("Head") and obj.Parent.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(obj.Parent) and obj.Health > 0 then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(obj.Parent.Head.Position)
                if OnScreen then
                    local Dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - CenterScreen).Magnitude
                    if Dist < MaxDistance and IsVisible(obj.Parent.Head) then MaxDistance = Dist ClosestTarget = obj.Parent.Head end
                end
            end
        end
    end
    return ClosestTarget
end
RunService.RenderStepped:Connect(function() if Options.Aimbot or Options.AimNPC then local Target = GetClosestTarget() if Target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position) end end end)
task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if math.random(1, 100) <= Options.HitboxChance and Options.HitboxSize > 2 then
                    p.Character.HumanoidRootPart.Size = Vector3.new(Options.HitboxSize, Options.HitboxSize, Options.HitboxSize)
                    p.Character.HumanoidRootPart.Transparency, p.Character.HumanoidRootPart.BrickColor, p.Character.HumanoidRootPart.CanCollide = 0.6, BrickColor.new("Neon orange"), false
                else p.Character.HumanoidRootPart.Size, p.Character.HumanoidRootPart.Transparency = Vector3.new(2, 2, 2), 1 end
            end
        end
    end
end)
local ESPCache = {}
local function CreateESP(Player)
    if ESPCache[Player] then return end
    local Box, Text = Drawing.new("Square"), Drawing.new("Text")
    Box.Color, Box.Thickness, Box.Filled, Box.Visible = Color3.fromRGB(255, 0, 0), 1.5, false, false
    Text.Color, Text.Center, Text.Outline, Text.OutlineColor, Text.Visible = Color3.fromRGB(255, 255, 255), true, true, Color3.fromRGB(0, 0, 0), false
    ESPCache[Player] = {Box = Box, Text = Text}
end
local function RemoveESP(Player) if ESPCache[Player] then ESPCache[Player].Box:Remove() ESPCache[Player].Text:Remove() ESPCache[Player] = nil end end
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end)
Players.PlayerRemoving:Connect(RemoveESP)
RunService.RenderStepped:Connect(function()
    for player, drawings in pairs(ESPCache) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.Health > 0 then
            local hrp, head = char.HumanoidRootPart, char.Head
            local hrpPos, hrpOnScreen = Camera:WorldToViewportPoint(hrp.Position)
            if hrpOnScreen then
                local headPos, legPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)), Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local boxHeight = math.abs(headPos.Y - legPos.Y)
                local boxWidth, distance = boxHeight / 1.5, (Camera.CFrame.Position - hrp.Position).Magnitude
                local calculatedFontSize = math.clamp(math.floor(20 - (distance / 45)), 11, 16)
                if Options.ESPBox then drawings.Box.Size, drawings.Box.Position, drawings.Box.Visible = Vector2.new(boxWidth, boxHeight), Vector2.new(hrpPos.X - boxWidth / 2, hrpPos.Y - boxHeight / 2), true else drawings.Box.Visible = false end
                if Options.ESPName then drawings.Text.Text, drawings.Text.Size, drawings.Text.Position, drawings.Text.Visible = player.Name, calculatedFontSize, Vector2.new(hrpPos.X, (hrpPos.Y - boxHeight / 2) - 15), true else drawings.Text.Visible = false end
            else drawings.Box.Visible, drawings.Text.Visible = false, false end
        else drawings.Box.Visible, drawings.Text.Visible = false, false end
    end
end)
local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.Velocity, BodyVelocity.MaxForce = Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp, hum = LocalPlayer.Character.HumanoidRootPart, LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed, hum.JumpPower = Options.WalkSpeed, Options.JumpPower end
        if Options.Fly then
            BodyVelocity.Parent, BodyVelocity.MaxForce = hrp, Vector3.new(9e9, 9e9, 9e9)
            local VelocityY = UserInputService:IsKeyDown(Enum.KeyCode.Space) and Options.FlySpeed or 0
            BodyVelocity.Velocity = (hum.MoveDirection * Options.FlySpeed) + Vector3.new(0, VelocityY, 0)
        else BodyVelocity.MaxForce, BodyVelocity.Parent = Vector3.new(0, 0, 0), nil end
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = not Options.Noclip and (part.Name ~= "HumanoidRootPart") or false end end
    end
end)
UserInputService.JumpRequest:Connect(function() if Options.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)
local RightFrame = Instance.new("Frame", MainFrame)
RightFrame.Position, RightFrame.Size, RightFrame.BackgroundTransparency = UDim2.new(0.52, 0, 0.13, 0), UDim2.new(0, 235, 0, 300), 1
local TeleportScroll = Instance.new("ScrollingFrame", RightFrame)
TeleportScroll.Position, TeleportScroll.Size, TeleportScroll.BackgroundColor3, TeleportScroll.CanvasSize = UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), Color3.fromRGB(24, 24, 32), UDim2.new(0, 0, 0, 700)
Instance.new("UICorner", TeleportScroll).CornerRadius = UDim.new(0, 6)
local TeleportLayout = Instance.new("UIListLayout", TeleportScroll)
TeleportLayout.Padding = UDim.new(0, 4)
local ResetBtn = Instance.new("TextButton", TeleportScroll)
ResetBtn.Size, ResetBtn.BackgroundColor3, ResetBtn.Text, ResetBtn.TextColor3, ResetBtn.Font, ResetBtn.TextSize = UDim2.new(0.95, 0, 0, 30), Color3.fromRGB(0, 180, 120), "🔄 Cập nhật danh sách Sever", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 13
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)
local MAX_PORTALS, portals, debounces, currentSelectedId = 5, {}, {}, nil
for i = 1, MAX_PORTALS do portals[i], debounces[i] = {}, false end
local portalColors = {Color3.fromRGB(255, 50, 50), Color3.fromRGB(50, 255, 50), Color3.fromRGB(50, 50, 255), Color3.fromRGB(255, 255, 50), Color3.fromRGB(255, 50, 255)}
local previewPortal = Instance.new("Part", workspace)
previewPortal.Size, previewPortal.Anchored, previewPortal.CanCollide, previewPortal.Material, previewPortal.Transparency = Vector3.new(4, 6, 0.5), true, false, Enum.Material.Neon, 1
RunService.RenderStepped:Connect(function()
	if currentSelectedId and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		previewPortal.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -6)
		previewPortal.Transparency, previewPortal.Color = 0.6, portalColors[currentSelectedId] or Color3.fromRGB(255, 255, 255)
	else previewPortal.Transparency = 1 end
end)
local function deletePortalPair(id) if portals[id] then for _, p in pairs(portals[id]) do p:Destroy() end portals[id] = {} end end
local function createPortal(id)
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	if #portals[id] >= 2 then deletePortalPair(id) end
	local p = Instance.new("Part", workspace)
	p.Size, p.CFrame, p.Anchored, p.CanCollide, p.Material, p.Color = Vector3.new(4, 6, 0.5), previewPortal.CFrame, true, false, Enum.Material.Neon, portalColors[id]
	local bgui = Instance.new("BillboardGui", p)
	bgui.Size, bgui.StudsOffset, bgui.AlwaysOnTop = UDim2.new(0, 50, 0, 50), Vector3.new(0, 4, 0), true
	local tl = Instance.new("TextLabel", bgui)
	tl.Size, tl.BackgroundTransparency, tl.Text, tl.TextSize, tl.Font, tl.TextColor3 = UDim2.new(1, 0, 1, 0), 1, tostring(id), 24, Enum.Font.SourceSansBold, p.Color
	table.insert(portals[id], p)
	p.Touched:Connect(function(hit)
		if debounces[id] then return end
		if LocalPlayer.Character and hit.Parent == LocalPlayer.Character then
			local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if not hrp then return end
			for _, other in ipairs(portals[id]) do
				if other ~= p then debounces[id] = true hrp.CFrame = other.CFrame * CFrame.new(0, 0, -4) * CFrame.Angles(0, math.pi, 0) task.wait(1.2) debounces[id] = false break end
			end
		end
	end)
end
local PortalTitle = Instance.new("TextLabel", TeleportScroll)
PortalTitle.Size, PortalTitle.BackgroundTransparency, PortalTitle.Text, PortalTitle.TextColor3, PortalTitle.Font, PortalTitle.TextSize = UDim2.new(0.95, 0, 0, 25), 1, "🌀 HỆ THỐNG CỔNG PORTAL", Color3.fromRGB(0, 255, 255), Enum.Font.SourceSansBold, 14
local PortalGrid = Instance.new("Frame", TeleportScroll)
PortalGrid.Size, PortalGrid.BackgroundTransparency = UDim2.new(0.95, 0, 0, 130), 1
for i = 1, MAX_PORTALS do
	local btn = Instance.new("TextButton", PortalGrid)
	btn.Size, btn.Position, btn.Text, btn.TextSize, btn.Font, btn.TextColor3, btn.BackgroundColor3 = UDim2.new(0, 36, 0, 36), UDim2.new(0, (i-1)*42 + 5, 0, 5), tostring(i), 16, Enum.Font.SourceSansBold, Color3.fromRGB(255, 255, 255), portalColors[i]
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Down:Connect(function() currentSelectedId = i end)
	btn.MouseButton1Click:Connect(function() createPortal(i) currentSelectedId = nil end)
	local delBtn = Instance.new("TextButton", PortalGrid)
	delBtn.Size, delBtn.Position, delBtn.Text, delBtn.TextSize, delBtn.Font, delBtn.TextColor3, delBtn.BackgroundColor3 = UDim2.new(0, 36, 0, 25), UDim2.new(0, (i-1)*42 + 5, 0, 46), "X", 14, Enum.Font.SourceSansBold, Color3.fromRGB(255, 100, 100), Color3.fromRGB(45, 45, 45)
	Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)
	delBtn.MouseButton1Click:Connect(function() deletePortalPair(i) delBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0) task.wait(0.15) delBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end)
end
local clearBtn = Instance.new("TextButton", PortalGrid)
clearBtn.Size, clearBtn.Position, clearBtn.Text, clearBtn.TextSize, clearBtn.Font, clearBtn.TextColor3, clearBtn.BackgroundColor3 = UDim2.new(0, 204, 0, 30), UDim2.new(0, 5, 0, 80), "Xóa Toàn Bộ Portal (Clear)", 13, Enum.Font.SourceSansBold, Color3.fromRGB(255, 255, 255), Color3.fromRGB(100, 20, 20)
Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)
clearBtn.MouseButton1Click:Connect(function() for id = 1, MAX_PORTALS do deletePortalPair(id) end currentSelectedId = nil end)
local ServerTitle = Instance.new("TextLabel", TeleportScroll)
ServerTitle.Size, ServerTitle.BackgroundTransparency, ServerTitle.Text, ServerTitle.TextColor3, ServerTitle.Font, ServerTitle.TextSize = UDim2.new(0.95, 0, 0, 25), 1, "👥 TELEPORT NGƯỜI CHƠI", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 14
local function BuildTeleportMenu()
    for _, child in pairs(TeleportScroll:GetChildren()) do if child:IsA("TextButton") and child ~= ResetBtn and child ~= clearBtn then child:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local PBtn = Instance.new("TextButton", TeleportScroll)
            PBtn.Size, PBtn.BackgroundColor3, PBtn.Text, PBtn.TextColor3, PBtn.Font, PBtn.TextSize = UDim2.new(0.95, 0, 0, 32), Color3.fromRGB(36, 36, 46), "Teleport -> " .. p.Name, Color3.fromRGB(255, 255, 255), Enum.Font.SourceSans, 13
            Instance.new("UICorner", PBtn).CornerRadius = UDim.new(0, 4)
            PBtn.MouseButton1Click:Connect(function() if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0) end end)
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
HUDToggle.MouseButton1Click:Connect(function() HUDLabel.Visible = not HUDLabel.Visible HUDFrame.Size = HUDLabel.Visible and UDim2.new(0, 150, 0, 75) or UDim2.new(0, 150, 0, 18) end)
local Frames = 0 RunService.RenderStepped:Connect(function() Frames = Frames + 1 end)
task.spawn(function()
    while task.wait(1) do
        local currentFps, currentPing = Frames, game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():sub(1, 5)
        Frames = 0
        HUDLabel.Text = string.format("FPS: %d | MS: %s\nCPU: %d%%\nPING: %s ms\nTIME: %s", currentFps, currentPing, math.clamp(math.floor((1 / currentFps) * 3500), 15, 85), currentPing, os.date("%H:%M:%S"))
    end
end)
local function CreateNewToggle(Text, OptionName)
    local TBtn = Instance.new("TextButton", LeftScroll)
    TBtn.Size, TBtn.BackgroundColor3, TBtn.Text, TBtn.TextColor3, TBtn.Font, TBtn.TextSize = UDim2.new(0.95, 0, 0, 36), Options[OptionName] and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50), Options[OptionName] and Text .. ": ON" or Text .. ": OFF", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 14
    Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)
    TBtn.MouseButton1Click:Connect(function() Options[OptionName] = not Options[OptionName] TBtn.BackgroundColor3 = Options[OptionName] and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50) TBtn.Text = Options[OptionName] and Text .. ": ON" or Text .. ": OFF" end)
end
local function CreateNewSlider(Text, Min, Max, OptionName, UpdateFunc)
    local Container = Instance.new("Frame", LeftScroll)
    Container.Size, Container.BackgroundTransparency = UDim2.new(0.95, 0, 0, 45), 1
    local Label = Instance.new("TextLabel", Container)
    Label.Size, Label.Text, Label.TextColor3, Label.BackgroundTransparency, Label.Font, Label.TextSize = UDim2.new(1, 0, 0, 20), Text .. ": " .. tostring(Options[OptionName]), Color3.fromRGB(255, 255, 255), 1, Enum.Font.SourceSans, 13
    local SlideBar = Instance.new("TextButton", Container)
    SlideBar.Position, SlideBar.Size, SlideBar.BackgroundColor3, SlideBar.Text = UDim2.new(0, 0, 0, 22), UDim2.new(1, 0, 0, 15), Color3.fromRGB(40, 40, 50), ""
    Instance.new("UICorner",SlideBar).CornerRadius = UDim.new(0, 4)
    SlideBar.MouseButton1Click:Connect(function()
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
