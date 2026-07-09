if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5) 
local Camera = workspace.CurrentCamera

if _G.MobileHubExecutedFinalV4_1 then
    print("[Mobile Hub] Hub đã được kích hoạt trước đó!")
    return
else
    _G.MobileHubExecutedFinalV4_1 = true
end

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
    Portal_System_Enabled = false
}

local currentAimTarget = nil
local FlyVelocity = nil
local FlyGyro = nil

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Filled = false
FOVCircle.Radius = State.Aim_Radius
FOVCircle.Visible = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalMobileHub_FinalV4_1"
ScreenGui.ResetOnSpawn = false

local success, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = PlayerGui end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 280)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 12) MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PREMIUM MOBILE HUB V4.1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 35, 0, 30)
MiniBtn.Position = UDim2.new(1, -45, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.SourceSansBold
MiniBtn.TextSize = 18
MiniBtn.Parent = MainFrame
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 6)

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -10, 1, -50)
ScrollContainer.Position = UDim2.new(0, 5, 0, 45)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 1030)
ScrollContainer.ScrollBarThickness = 5
ScrollContainer.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = ScrollContainer
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createToggle(name, text, order)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 440, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.Parent = ScrollContainer
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 6) corner.Parent = btn
    return btn
end

local function createSlider(name, text, min, max, default, order, callback)
    local container = Instance.new("Frame")
    container.Name = name .. "_Container"
    container.Size = UDim2.new(0, 440, 0, 40)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order
    container.Parent = ScrollContainer

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 160, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(default)
    lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = container

    local sFrame = Instance.new("Frame")
    sFrame.Size = UDim2.new(0, 260, 0, 6)
    sFrame.Position = UDim2.new(0, 170, 0.5, -3)
    sFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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

local isMinimized = false
MiniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 480, 0, 40)
        ScrollContainer.Visible = false
        MiniBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 480, 0, 280)
        ScrollContainer.Visible = true
        MiniBtn.Text = "-"
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

local FPS_Btn = createToggle("FPS_Btn", "FPS BOOSTER: OFF", 1)
local Aim_Btn = createToggle("Aim_Btn", "AIMBOT: OFF", 2)
local AimMode_Btn = createToggle("AimMode_Btn", "AIM TARGET: ALL", 3) AimMode_Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

createSlider("AimRadiusVal", "Phạm vi Aimbot (FOV)", 10, 500, 35, 4, function(v) 
    State.Aim_Radius = v 
    FOVCircle.Radius = v 
end)

local Hitbox_Btn = createToggle("Hitbox_Btn", "HITBOX EXPANDER: OFF", 5)
createSlider("HitboxSize", "Kích thước Hitbox", 5, 500, 5, 6, function(v) State.Hitbox_Size = v end)

local TransContainer = Instance.new("Frame")
TransContainer.Size = UDim2.new(0, 440, 0, 30)
TransContainer.BackgroundTransparency = 1
TransContainer.LayoutOrder = 7
TransContainer.Parent = ScrollContainer

local TransBox = Instance.new("TextBox")
TransBox.Size = UDim2.new(0, 60, 1, 0)
TransBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TransBox.Text = "0.5"
TransBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TransBox.Font = Enum.Font.SourceSansBold
TransBox.TextSize = 14
TransBox.Parent = TransContainer
Instance.new("UICorner", TransBox).CornerRadius = UDim.new(0, 5)

local TransLabel = Instance.new("TextLabel")
TransLabel.Size = UDim2.new(0, 360, 1, 0)
TransLabel.Position = UDim2.new(0, 70, 0, 0)
TransLabel.BackgroundTransparency = 1
TransLabel.Text = "Độ trong suốt Hitbox (0 - 1)"
TransLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
TransLabel.Font = Enum.Font.SourceSans
TransLabel.TextSize = 13
TransLabel.TextXAlignment = Enum.TextXAlignment.Left
TransLabel.Parent = TransContainer

local ESPName_Btn = createToggle("ESPName_Btn", "ESP NAME: OFF", 8)
local ESPBox_Btn = createToggle("ESPBox_Btn", "ESP BOX: OFF", 9)

local Speed_Btn = createToggle("Speed_Btn", "SPEED SYSTEM: OFF", 10)
createSlider("WalkSpeedVal", "Tốc độ chạy", 16, 500, 100, 11, function(v) State.WalkSpeed_Value = v end)

local Jump_Btn = createToggle("Jump_Btn", "JUMP SYSTEM: OFF", 12)
createSlider("JumpPowerVal", "Sức mạnh nhảy", 50, 500, 120, 13, function(v) State.JumpPower_Value = v end)

local InfJump_Btn = createToggle("InfJump_Btn", "INFINITE JUMP: OFF", 14)
local Fly_Btn = createToggle("Fly_Btn", "FLY MOBILE (3D): OFF", 15)
createSlider("FlySpeedVal", "Tốc độ bay", 10, 300, 50, 16, function(v) State.Fly_Speed = v end)

local Noclip_Btn = createToggle("Noclip_Btn", "NOCLIP (XUYÊN TƯỜNG): OFF", 17)
local PortalMaster_Btn = createToggle("PortalMaster_Btn", "HỆ THỐNG PORTAL: OFF", 19)

local TeleportContainer = Instance.new("Frame")
TeleportContainer.Name = "TeleportContainer"
TeleportContainer.Size = UDim2.new(0, 440, 0, 36)
TeleportContainer.BackgroundTransparency = 1
TeleportContainer.LayoutOrder = 18
TeleportContainer.Parent = ScrollContainer

local SelectPlayerBtn = Instance.new("TextButton")
SelectPlayerBtn.Size = UDim2.new(1, 0, 1, 0)
SelectPlayerBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 95)
SelectPlayerBtn.Text = " CHỌN NGƯỜI CHƠI ĐỂ TELE"
SelectPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectPlayerBtn.Font = Enum.Font.SourceSansBold
SelectPlayerBtn.TextSize = 14
SelectPlayerBtn.Parent = TeleportContainer
Instance.new("UICorner", SelectPlayerBtn).CornerRadius = UDim.new(0, 6)

local DropdownFrame = Instance.new("ScrollingFrame")
DropdownFrame.Size = UDim2.new(1, 0, 0, 120)
DropdownFrame.Position = UDim2.new(0, 0, 0, 40)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropdownFrame.BorderSizePixel = 1
DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownFrame.ScrollBarThickness = 4
DropdownFrame.Visible = false
DropdownFrame.ZIndex = 50
DropdownFrame.Parent = TeleportContainer
Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 6)

local DropdownLayout = Instance.new("UIListLayout")
DropdownLayout.Parent = DropdownFrame
DropdownLayout.Padding = UDim.new(0, 4)

local function updateDropdownList()
    for _, child in ipairs(DropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local totalPlayers = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            totalPlayers = totalPlayers + 1
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, -8, 0, 30)
            pBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
                task.wait(1)
                SelectPlayerBtn.Text = " CHỌN NGƯỜI CHƠI ĐỂ TELE"
            end)
        end
    end
    DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, totalPlayers * 34)
end

SelectPlayerBtn.MouseButton1Click:Connect(function()
    DropdownFrame.Visible = not DropdownFrame.Visible
    if DropdownFrame.Visible then updateDropdownList() end
end)

local PortalContainer = Instance.new("Frame")
PortalContainer.Name = "PortalContainer"
PortalContainer.Size = UDim2.new(0, 440, 0, 85)
PortalContainer.BackgroundTransparency = 1
PortalContainer.LayoutOrder = 20
PortalContainer.Visible = false
PortalContainer.Parent = ScrollContainer

local MAX_PORTALS = 5
local portals = {}
local debounces = {}
local currentSelectedId = nil

for i = 1, MAX_PORTALS do portals[i] = {} debounces[i] = false end

local portalColors = {
	Color3.fromRGB(255, 50, 50),
	Color3.fromRGB(50, 255, 50),
	Color3.fromRGB(50, 50, 255),
	Color3.fromRGB(255, 255, 50),
	Color3.fromRGB(255, 50, 255)
}

local previewPortal = Instance.new("Part")
previewPortal.Size = Vector3.new(4, 6, 0.5)
previewPortal.Anchored = true
previewPortal.CanCollide = false
previewPortal.Material = Enum.Material.Neon
previewPortal.Parent = workspace
previewPortal.Transparency = 1 

RunService.RenderStepped:Connect(function()
	if State.Portal_System_Enabled and currentSelectedId and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = LocalPlayer.Character.HumanoidRootPart
		previewPortal.CFrame = hrp.CFrame * CFrame.new(0, 0, -6)
		previewPortal.Transparency = 0.6
		previewPortal.Color = portalColors[currentSelectedId] or Color3.fromRGB(255, 255, 255)
	else
		previewPortal.Transparency = 1
	end
end)

local function deletePortalPair(id)
	if portals[id] then
		for _, p in pairs(portals[id]) do p:Destroy() end
		portals[id] = {}
	end
end

local function createPortal(id)
    if not State.Portal_System_Enabled then return end
	local character = LocalPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	if #portals[id] >= 2 then deletePortalPair(id) end
	
	local p = Instance.new("Part")
	p.Size = Vector3.new(4, 6, 0.5)
	p.CFrame = previewPortal.CFrame
	p.Anchored = true
	p.CanCollide = false
	p.Material = Enum.Material.Neon
	p.Color = portalColors[id]
	p.Parent = workspace
	
	local bgui = Instance.new("BillboardGui", p)
	bgui.Size = UDim2.new(0, 50, 0, 50)
	bgui.AlwaysOnTop = true
	
	local tl = Instance.new("TextLabel", bgui)
	tl.Size = UDim2.new(1, 0, 1, 0)
	tl.BackgroundTransparency = 1
	tl.Text = tostring(id)
	tl.TextSize = 24
	tl.Font = Enum.Font.SourceSansBold
	tl.TextColor3 = p.Color
	
	table.insert(portals[id], p)
	
	p.Touched:Connect(function(hit)
		if not State.Portal_System_Enabled or debounces[id] then return end
		if LocalPlayer.Character and hit.Parent == LocalPlayer.Character then
			local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			for _, other in ipairs(portals[id]) do
				if other ~= p then
					debounces[id] = true
					hrp.CFrame = other.CFrame * CFrame.new(0, 0, -4) * CFrame.Angles(0, math.pi, 0)
					task.wait(1.2)
					debounces[id] = false
					break
				end
			end
		end
	end)
end

for i = 1, MAX_PORTALS do
	local btn = Instance.new("TextButton", PortalContainer)
	btn.Size = UDim2.new(0, 55, 0, 34)
	btn.Position = UDim2.new(0, (i-1)*62 + 6, 0, 5)
	btn.Text = tostring(i)
	btn.TextSize = 15
	btn.Font = Enum.Font.SourceSansBold
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = portalColors[i]
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	btn.MouseButton1Down:Connect(function() currentSelectedId = i end)
	btn.MouseButton1Click:Connect(function() createPortal(i) currentSelectedId = nil end)

	local delBtn = Instance.new("TextButton", PortalContainer)
	delBtn.Size = UDim2.new(0, 55, 0, 24)
	delBtn.Position = UDim2.new(0, (i-1)*62 + 6, 0, 44)
	delBtn.Text = "X"
	delBtn.TextSize = 13
	delBtn.Font = Enum.Font.SourceSansBold
	delBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
	delBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)
	
	delBtn.MouseButton1Click:Connect(function() deletePortalPair(i) end)
end

local clearBtn = Instance.new("TextButton", PortalContainer)
clearBtn.Size = UDim2.new(0, 95, 0, 63)
clearBtn.Position = UDim2.new(0, 320, 0, 5)
clearBtn.Text = "Clear\nAll"
clearBtn.TextSize = 14
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.BackgroundColor3 = Color3.fromRGB(70, 20, 20)
Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)
clearBtn.MouseButton1Click:Connect(function() for id = 1, MAX_PORTALS do deletePortalPair(id) end currentSelectedId = nil end)

local function togglePortalSystem(enable)
    State.Portal_System_Enabled = enable
    if enable then
        PortalMaster_Btn.Text = "HỆ THỐNG PORTAL: ON"
        PortalMaster_Btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        PortalContainer.Visible = true
    else
        PortalMaster_Btn.Text = "HỆ THỐNG PORTAL: OFF"
        PortalMaster_Btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        PortalContainer.Visible = false
        currentSelectedId = nil
        for id = 1, MAX_PORTALS do deletePortalPair(id) end
    end
end

local function createESP(player)
    if State.ESP_Storage[player] then return end
    local box = Drawing.new("Square") box.Color = Color3.fromRGB(255, 0, 0) box.Thickness = 1.5 box.Filled = false box.Visible = false
    local nameText = Drawing.new("Text") nameText.Color = Color3.fromRGB(255, 255, 255) nameText.Center = true nameText.Outline = true nameText.Visible = false
    State.ESP_Storage[player] = {Box = box, Text = nameText}
end

local function removeESP(player)
    if State.ESP_Storage[player] then State.ESP_Storage[player].Box:Destroy() State.ESP_Storage[player].Text:Destroy() State.ESP_Storage[player] = nil end
end

Players.PlayerAdded:Connect(createESP) Players.PlayerRemoving:Connect(removeESP)
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
                    esp.Text.Size = math.clamp(math.round(400 / distance) + 10, 11, 22)
                    esp.Text.Visible = true
                else esp.Text.Visible = false end
                if State.ESP_Box then
                    local sizeX, sizeY = 2000 / distance, 3000 / distance
                    esp.Box.Size = Vector2.new(sizeX, sizeY)
                    esp.Box.Position = Vector2.new(screenPos.X - (sizeX / 2), screenPos.Y - (sizeY / 2))
                    esp.Box.Visible = true
                else esp.Box.Visible = false end
            else esp.Box.Visible = false esp.Text.Visible = false end
        else esp.Box.Visible = false esp.Text.Visible = false end
    end
end)

RunService.PostSimulation:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if State.WalkSpeed_Enabled then 
            hum.WalkSpeed = State.WalkSpeed_Value 
        end
        if State.JumpPower_Enabled then 
            hum.JumpPower = State.JumpPower_Value 
            hum.UseJumpPower = true 
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfJump_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local function toggleFly(enable)
    State.Fly_Enabled = enable
    if enable then
        Fly_Btn.Text = "FLY MOBILE (3D): ON"; Fly_Btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        task.spawn(function()
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
            
            while State.Fly_Enabled and char and root and FlyVelocity.Parent do
                local lookVector = Camera.CFrame.LookVector
                local moveDir = hum.MoveDirection
                local velocity = Vector3.new(0, 0, 0)
                
                if moveDir.Magnitude > 0 then
                    local rightVector = Camera.CFrame.RightVector
                    local forwardVector = lookVector
                    velocity = (forwardVector * (moveDir.Z * -1) + rightVector * moveDir.X).Unit * State.Fly_Speed
                end
                
                FlyVelocity.Velocity = velocity
                FlyGyro.CFrame = Camera.CFrame
                RunService.Heartbeat:Wait()
            end
        end)
    else
        Fly_Btn.Text = "FLY MOBILE (3D): OFF"; Fly_Btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        if FlyVelocity then FlyVelocity:Destroy() FlyVelocity = nil end
        if FlyGyro then FlyGyro:Destroy() FlyGyro = nil end
    end
end

RunService.Stepped:Connect(function()
    if State.Noclip_Enabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

local function disableNoclip()
    State.Noclip_Enabled = false
    Noclip_Btn.Text = "NOCLIP (XUYÊN TƯỜNG): OFF"
    Noclip_Btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    task.spawn(function()
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
                    part.CanCollide = true
                end
            end
        end
    end)
end

local function optimizeObject(v)
    if not State.FPS_Enabled then return end
    if v:IsA("BasePart") then 
        v.Material = Enum.Material.SmoothPlastic
        v.CastShadow = false
        v.Reflectance = 0
    elseif v:IsA("Texture") or v:IsA("Decal") then
        v:Destroy()
    elseif v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Trail") or v:IsA("Beam") then 
        v:Destroy() 
    end
end

local fpsConnection
local function toggleFPS(enable)
    State.FPS_Enabled = enable
    if enable then
        FPS_Btn.Text = "FPS BOOSTER: ON"; FPS_Btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 12
        for _, v in ipairs(workspace:GetDescendants()) do optimizeObject(v) end
        fpsConnection = workspace.DescendantAdded:Connect(optimizeObject)
    else
        FPS_Btn.Text = "FPS BOOSTER: OFF"; FPS_Btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        if fpsConnection then fpsConnection:Disconnect(); fpsConnection = nil end
    end
end

local function isVisible(targetChar, targetPart)
    local p = RaycastParams.new() p.FilterType = Enum.RaycastFilterType.Exclude p.FilterDescendantsInstances = {LocalPlayer.Character, targetChar}
    return workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, p) == nil
end

local function getClosestAimTarget()
    local closest, shortestDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if State.Aim_Mode == "All" or State.Aim_Mode == "Players" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen and isVisible(p.Character, p.Character.Head) then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist <= State.Aim_Radius and dist < shortestDist then closest = {Character = p.Character, Part = p.Character.Head} shortestDist = dist end
                end
            end
        end
    end
    return closest
end

local aimConnection
local function toggleAimbot(enable)
    State.Aim_Enabled = enable
    if enable then
        Aim_Btn.Text = "AIMBOT: ON"; Aim_Btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        if State.Aim_Enabled then FOVCircle.Visible = true end
        aimConnection = RunService.RenderStepped:Connect(function()
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            if currentAimTarget and currentAimTarget.Character.Parent and isVisible(currentAimTarget.Character, currentAimTarget.Part) then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, currentAimTarget.Part.Position)
            else currentAimTarget = getClosestAimTarget() end
        end)
    else
        Aim_Btn.Text = "AIMBOT: OFF"; Aim_Btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50); FOVCircle.Visible = false
        if aimConnection then aimConnection:Disconnect(); aimConnection = nil end
    end
end

local function applyHitboxLogic(rootPart)
    if not rootPart or not rootPart:IsA("BasePart") then return end
    if not State.Hitbox_Originals[rootPart] then State.Hitbox_Originals[rootPart] = { Size = rootPart.Size, Transparency = rootPart.Transparency, CanCollide = rootPart.CanCollide } end
    rootPart.Size = Vector3.new(State.Hitbox_Size, State.Hitbox_Size, State.Hitbox_Size)
    rootPart.Transparency = State.Hitbox_Transparency
    rootPart.CanCollide = false
end

local hitboxConnection
local function toggleHitbox(enable)
    State.Hitbox_Enabled = enable
    if enable then
        Hitbox_Btn.Text = "HITBOX EXPANDER: ON"; Hitbox_Btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        hitboxConnection = RunService.RenderStepped:Connect(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then applyHitboxLogic(p.Character.HumanoidRootPart) end
            end
        end)
    else
        Hitbox_Btn.Text = "HITBOX EXPANDER: OFF"; Hitbox_Btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        if hitboxConnection then hitboxConnection:Disconnect(); hitboxConnection = nil end
        for rPart, orig in pairs(State.Hitbox_Originals) do if rPart and rPart.Parent then rPart.Size = orig.Size; rPart.Transparency = orig.Transparency; rPart.CanCollide = orig.CanCollide end end
        table.clear(State.Hitbox_Originals)
    end
end

TransBox.FocusLost:Connect(function() State.Hitbox_Transparency = math.clamp(tonumber(TransBox.Text) or 0.5, 0, 1) TransBox.Text = tostring(State.Hitbox_Transparency) end)

FPS_Btn.MouseButton1Click:Connect(function() toggleFPS(not State.FPS_Enabled) end)
Aim_Btn.MouseButton1Click:Connect(function() toggleAimbot(not State.Aim_Enabled) end)
Hitbox_Btn.MouseButton1Click:Connect(function() toggleHitbox(not State.Hitbox_Enabled) end)
PortalMaster_Btn.MouseButton1Click:Connect(function() togglePortalSystem(not State.Portal_System_Enabled) end)

ESPName_Btn.MouseButton1Click:Connect(function()
    State.ESP_Name = not State.ESP_Name
    ESPName_Btn.Text = State.ESP_Name and "ESP NAME: ON" or "ESP NAME: OFF"
    ESPName_Btn.BackgroundColor3 = State.ESP_Name and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
end)

ESPBox_Btn.MouseButton1Click:Connect(function()
    State.ESP_Box = not State.ESP_Box
    ESPBox_Btn.Text = State.ESP_Box and "ESP BOX: ON" or "ESP BOX: OFF"
    ESPBox_Btn.BackgroundColor3 = State.ESP_Box and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
end)

Speed_Btn.MouseButton1Click:Connect(function()
    State.WalkSpeed_Enabled = not State.WalkSpeed_Enabled
    Speed_Btn.Text = State.WalkSpeed_Enabled and "SPEED SYSTEM: ON" or "SPEED SYSTEM: OFF"
    Speed_Btn.BackgroundColor3 = State.WalkSpeed_Enabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
    if not State.WalkSpeed_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)

Jump_Btn.MouseButton1Click:Connect(function()
    State.JumpPower_Enabled = not State.JumpPower_Enabled
    Jump_Btn.Text = State.JumpPower_Enabled and "JUMP SYSTEM: ON" or "JUMP SYSTEM: OFF"
    Jump_Btn.BackgroundColor3 = State.JumpPower_Enabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
    if not State.JumpPower_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end)

InfJump_Btn.MouseButton1Click:Connect(function()
    State.InfJump_Enabled = not State.InfJump_Enabled
    InfJump_Btn.Text = State.InfJump_Enabled and "INFINITE JUMP: ON" or "INFINITE JUMP: OFF"
    InfJump_Btn.BackgroundColor3 = State.InfJump_Enabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
end)

Fly_Btn.MouseButton1Click:Connect(function() toggleFly(not State.Fly_Enabled) end)

Noclip_Btn.MouseButton1Click:Connect(function()
    if not State.Noclip_Enabled then
        State.Noclip_Enabled = true
        Noclip_Btn.Text = "NOCLIP: ON"
        Noclip_Btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        disableNoclip()
    end
end)

AimMode_Btn.MouseButton1Click:Connect(function()
    if State.Aim_Mode == "All" then State.Aim_Mode = "Players"; AimMode_Btn.Text = "AIM TARGET: PLAYERS"; AimMode_Btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    elseif State.Aim_Mode == "Players" then State.Aim_Mode = "NPCs"; AimMode_Btn.Text = "AIM TARGET: NPCS"; AimMode_Btn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    else State.Aim_Mode = "All" ;AimMode_Btn.Text = "AIM TARGET: ALL"; AimMode_Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end currentAimTarget = nil
end)

LocalPlayer.CharacterRemoving:Connect(function() if not State.Hitbox_Enabled then table.clear(State.Hitbox_Originals) end end)

