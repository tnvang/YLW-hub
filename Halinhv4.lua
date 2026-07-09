-- YLW Hub - Phiên bản 4.2 (Bản Gốc Đầy Đủ + Viền Rainbow + Fix Aimbot)
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
    Aim_Mode = "Players" -- Mặc định chỉ Aim người chơi để không khóa vào quái
}

-- TẠO GIAO DIỆN CHÍNH (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YLW_Hub_v42_Official"
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

-- TẠO VIỀN RAINBOW CHO MENU
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

task.spawn(function()
    while true do
        for hue = 0, 1, 0.01 do
            UIStroke.Color = Color3.fromHSV(hue, 0.9, 1)
            task.wait(0.03)
        end
    end
end)

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

-- HÀM TẠO TOGGLES & SLIDERS CHUẨN
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

-- TÍNH NĂNG KÉO THU PHÓNG GUI (Drag & Minimize)
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

local Dragging, DragInput, DragStart, StartPosition
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true; DragStart = input.Position; StartPosition = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
    end
end)

----------------------------------------------------
-- THIẾT LẬP CÁC PHẦN TỬ TRONG TAB MENU
----------------------------------------------------

-- Vòng tròn FOV của Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 50, 50)
FOVCircle.Thickness = 1.5
FOVCircle.Radius = State.Aim_Radius
FOVCircle.Filled = false
FOVCircle.Visible = false

-- LOGIC FIX AIMBOT CHỈ VÀO NGƯỜI CHƠI (KHÔNG VÀO QUÁI)
local function getClosestTarget()
    local closestTarget = nil
    local shortestDistance = State.Aim_Radius
    local mousePos = UserInputService:GetMouseLocation()

    if State.Aim_Mode == "Players" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mag = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if mag < shortestDistance then
                        shortestDistance = mag
                        closestTarget = player.Character.HumanoidRootPart
                    end
                end
            end
        end
    elseif State.Aim_Mode == "All" then
        -- Chế độ cũ nếu muốn Aim cả quái vật/NPCs ngoài workspace
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Parent and obj.Parent:FindFirstChild("HumanoidRootPart") and obj.Health > 0 and obj.Parent ~= LocalPlayer.Character then
                local screenPos, onScreen = Camera:WorldToViewportPoint(obj.Parent.HumanoidRootPart.Position)
                if onScreen then
                    local mag = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if mag < shortestDistance then
                        shortestDistance = mag
                        closestTarget = obj.Parent.HumanoidRootPart
                    end
                end
            end
        end
    end
    return closestTarget
end

-- TAB 1: COMBAT
local State_Aimbot_Active = false
local Aim_Btn = createToggle("Combat", "AIMBOT", 1, function(state) 
    State_Aimbot_Active = state
    FOVCircle.Visible = state 
end)

local AimMode_Btn = Instance.new("TextButton")
AimMode_Btn.Size = UDim2.new(1, -10, 0, 36)
AimMode_Btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
AimMode_Btn.Text = "AIM TARGET: PLAYERS (ONLY)"
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

local State_Hitbox_Active = false
local Hitbox_Btn = createToggle("Combat", "HITBOX EXPANDER", 4, function(state) State_Hitbox_Active = state end)
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

-- Biến phục vụ tính năng Fly gốc
local flying = false
local flySpeed = 50
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}

local function toggleFly(enable)
    flying = enable
    if not enable and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        for _, v in pairs(root:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
        end
    elseif enable then
        task.spawn(function()
            local root = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            local bg = Instance.new("BodyGyro", root) bg.P = 9e4 bg.maxTorque = Vector3.new(9e9, 9e9, 9e9) bg.cframe = root.CFrame
            local bv = Instance.new("BodyVelocity", root) bv.velocity = Vector3.new(0, 0.1, 0) bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            while flying do
                task.wait()
                if ctrl.l + ctrl.r + ctrl.f + ctrl.b ~= 0 then
                    bv.velocity = ((Camera.CFrame.LookVector * (ctrl.f + ctrl.b)) + ((Camera.CFrame.ToWorldSpace(CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0)).Position - Camera.CFrame.p) * flySpeed))
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                else
                    bv.velocity = Vector3.new(0, 0.1, 0)
                end
                bg.cframe = Camera.CFrame
            end
        end)
    end
end

local Fly_Btn_Node = createToggle("Movement", "FLY MOBILE (3D)", 6, function(state) toggleFly(state) end)
createSlider("Movement", "Tốc độ bay", 10, 300, 50, 7, function(v) flySpeed = v end)

createToggle("Movement", "NOCLIP (XUYÊN TƯỜNG)", 8, function(state) State.Noclip_Enabled = state end)

-- Teleport Player Dropdown
local TeleportContainer = Instance.new("Frame")
TeleportContainer.Size = UDim2.new(1, -10, 0, 36)
TeleportContainer.BackgroundTransparency = 1
TeleportContainer.LayoutOrder = 9
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
local DropdownLayout = Instance.new("UIListLayout", DropdownFrame)
DropdownLayout.Padding = UDim.new(0, 4)

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
SelectPlayerBtn.MouseButton1Click:Connect(function() DropdownFrame.Visible = not DropdownFrame.Visible; if DropdownFrame.Visible then updateDropdownList() end end)

-- Hệ thống Portal
local PortalMaster_Btn = createToggle("Movement", "HỆ THỐNG PORTAL", 10, function(state) State.Portal_System_Enabled = state end)
local PortalContainer = Instance.new("Frame")
PortalContainer.Size = UDim2.new(1, -10, 0, 80)
PortalContainer.BackgroundTransparency = 1
PortalContainer.LayoutOrder = 11
PortalContainer.Visible = true
PortalContainer.Parent = tabs["Movement"]

local MAX_PORTALS = 5
local portals = {}
local debounces = {}
local currentSelectedId = nil
for i = 1, MAX_PORTALS do portals[i] = {} debounces[i] = false end
local portalColors = {Color3.fromRGB(255, 50, 50), Color3.fromRGB(50, 255, 50), Color3.fromRGB(50, 50, 255), Color3.fromRGB(255, 255, 50), Color3.fromRGB(255, 50, 255)}

local previewPortal = Instance.new("Part")
previewPortal.Size = Vector3.new(4, 6, 0.5)
previewPortal.Anchored = true; previewPortal.CanCollide = false; previewPortal.Material = Enum.Material.Neon; previewPortal.Parent = workspace; previewPortal.Transparency = 1 

RunService.RenderStepped:Connect(function()
	if State.Portal_System_Enabled and currentSelectedId and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		previewPortal.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -6)
		previewPortal.Transparency = 0.6; previewPortal.Color = portalColors[currentSelectedId]
	else previewPortal.Transparency = 1 end
end)

local function deletePortalPair(id) if portals[id] then for _, p in pairs(portals[id]) do p:Destroy() end portals[id] = {} end end
local function createPortal(id)
    if not State.Portal_System_Enabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	if #portals[id] >= 2 then deletePortalPair(id) end
	local p = Instance.new("Part") p.Size = Vector3.new(4, 6, 0.5) p.CFrame = previewPortal.CFrame p.Anchored = true; p.CanCollide = false; p.Material = Enum.Material.Neon; p.Color = portalColors[id]; p.Parent = workspace
	local bgui = Instance.new("BillboardGui", p) bgui.Size = UDim2.new(0, 50, 0, 50) bgui.AlwaysOnTop = true
	local tl = Instance.new("TextLabel", bgui) tl.Size = UDim2.new(1, 0, 1, 0) tl.BackgroundTransparency = 1 tl.Text = tostring(id) tl.TextSize = 24 tl.Font = Enum.Font.SourceSansBold tl.TextColor3 = p.Color
	table.insert(portals[id], p)
	p.Touched:Connect(function(hit)
		if not State.Portal_System_Enabled or debounces[id] then return end
		if LocalPlayer.Character and hit.Parent == LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			for _, other in ipairs(portals[id]) do
				if other ~= p then
					debounces[id] = true
					LocalPlayer.Character.HumanoidRootPart.CFrame = other.CFrame * CFrame.new(0, 0, -4) * CFrame.Angles(0, math.pi, 0)
					task.wait(1.2) debounces[id] = false break
				end
			end
		end
	end)
end

for i = 1, MAX_PORTALS do
	local btn = Instance.new("TextButton", PortalContainer) btn.Size = UDim2.new(0, 48, 0, 32) btn.Position = UDim2.new(0, (i-1)*54, 0, 5) btn.Text = tostring(i) btn.TextSize = 14 btn.Font = Enum.Font.SourceSansBold btn.TextColor3 = Color3.fromRGB(255, 255, 255) btn.BackgroundColor3 = portalColors[i]; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Down:Connect(function() currentSelectedId = i end)
	btn.MouseButton1Click:Connect(function() createPortal(i) currentSelectedId = nil end)
    local delBtn = Instance.new("TextButton", PortalContainer) delBtn.Size = UDim2.new(0, 48, 0, 22) delBtn.Position = UDim2.new(0, (i-1)*54, 0, 42) delBtn.Text = "X" delBtn.TextSize = 12 delBtn.Font = Enum.Font.SourceSansBold delBtn.TextColor3 = Color3.fromRGB(255, 100, 100) delBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40); Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)
	delBtn.MouseButton1Click:Connect(function() deletePortalPair(i) end)
end
local clearBtn = Instance.new("TextButton", PortalContainer) clearBtn.Size = UDim2.new(0, 75, 0, 59) clearBtn.Position = UDim2.new(0, 275, 0, 5) clearBtn.Text = "Clear All" clearBtn.TextSize = 14 clearBtn.Font = Enum.Font.SourceSansBold clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255) clearBtn.BackgroundColor3 = Color3.fromRGB(90, 30, 30); Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)
clearBtn.MouseButton1Click:Connect(function() for id = 1, MAX_PORTALS do deletePortalPair(id) end currentSelectedId = nil end)

-- TAB 3: VISUALS
createToggle("Visuals", "FPS BOOSTER", 1, function(state) end)
createToggle("Visuals", "ESP NAME", 2, function(state) State.ESP_Name = state end)
createToggle("Visuals", "ESP BOX", 3, function(state) State.ESP_Box = state end)

createSlider("Visuals", "Góc Nhìn Camera (FOV)", 30, 120, 70, 4, function(v)
    State.Camera_FOV_Value = v
    Camera.FieldOfView = v
end)

createToggle("Visuals", "HIỆU ỨNG RAINBOW CẦU VỒNG", 5, function(state) end)
createToggle("Visuals", "HIỆU ỨNG BĂNG GIÁ RƠI", 6, function(state) end)
createToggle("Visuals", "HIỆU ỨNG KHÓI BAY", 7, function(state) end)

----------------------------------------------------
-- VÒNG LẶP SỰ KIỆN HỆ THỐNG CHÍNH
----------------------------------------------------

Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if Camera.FieldOfView ~= State.Camera_FOV_Value then
        Camera.FieldOfView = State.Camera_FOV_Value
    end
end)

function createESP(player)
    if State.ESP_Storage[player] then return end
    local box = Drawing.new("Square") box.Color = Color3.fromRGB(255, 50, 50) box.Thickness = 1.5 box.Filled = false box.Visible = false
    local nameText = Drawing.new("Text") nameText.Color = Color3.fromRGB(255, 255, 255) nameText.Center = true nameText.Outline = true nameText.Visible = false
    State.ESP_Storage[player] = {Box = box, Text = nameText}
end

function removeESP(player) if State.ESP_Storage[player] then State.ESP_Storage[player].Box:Destroy() State.ESP_Storage[player].Text:Destroy() State.ESP_Storage[player] = nil end end
Players.PlayerAdded:Connect(createESP) Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then createESP(p) end end

RunService.RenderStepped:Connect(function()
    if FOVCircle.Visible then
        FOVCircle.Position = UserInputService:GetMouseLocation()
    end

    if State_Aimbot_Active then
        local target = getClosestTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end

    if State_Hitbox_Active then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(State.Hitbox_Size, State.Hitbox_Size, State.Hitbox_Size)
                p.Character.HumanoidRootPart.Transparency = State.Hitbox_Transparency
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end

    for player, esp in pairs(State.ESP_Storage) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local root = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen and (State.ESP_Name or State.ESP_Box) then
                local distance = (Camera.CFrame.Position - root.Position).Magnitude
                if State.ESP_Name then
                    esp.Text.Position = Vector2.new(screenPos.X, screenPos.Y - 35) esp.Text.Text = player.Name .. " [" .. math.round(distance) .. "m]"
                    esp.Text.Size = math.clamp(math.round(400 / distance) + 10, 11, 20) esp.Text.Visible = true
                else esp.Text.Visible = false end
                if State.ESP_Box then
                    local sizeX, sizeY = 2000 / distance, 3000 / distance
                    esp.Box.Size = Vector2.new(sizeX, sizeY) esp.Box.Position = Vector2.new(screenPos.X - (sizeX / 2), screenPos.Y - (sizeY / 2)) esp.Box.Visible = true
                else esp.Box.Visible = false end
            else esp.Box.Visible = false esp.Text.Visible = false end
        else esp.Box.Visible = false esp.Text.Visible = false end
    end
end)

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
end)

TransBox.FocusLost:Connect(function() State.Hitbox_Transparency = math.clamp(tonumber(TransBox.Text) or 0.5, 0, 1) TransBox.Text = tostring(State.Hitbox_Transparency) end)

AimMode_Btn.MouseButton1Click:Connect(function()
    if State.Aim_Mode == "Players" then
        State.Aim_Mode = "All"
        AimMode_Btn.Text = "AIM TARGET: ALL (INC. MONSTERS)"
        AimMode_Btn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    else
        State.Aim_Mode = "Players"
        AimMode_Btn.Text = "AIM TARGET: PLAYERS (ONLY)"
        AimMode_Btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    end
end)

