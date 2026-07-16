local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

if CoreGui:FindFirstChild("TruongNewbieCustomUI") then
    CoreGui["TruongNewbieCustomUI"]:Destroy()
end

local KeyVerified = false
local AimbotEnabled = false
local HitboxEnabled = false
local NoclipEnabled = false
local InfJumpEnabled = false
local EspEnabled = false
local RainbowWalkEnabled = false
local RainbowBall = nil

local HITBOX_SIZE = Vector3.new(10, 10, 10)
local HITBOX_TRANSPARENCY = 0.6
local HITBOX_COLOR = Color3.fromRGB(255, 0, 0)
local TARGET_PART = "HumanoidRootPart"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TruongNewbieCustomUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Trường newbie"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -130, 1, -40)
Container.Position = UDim2.new(0, 130, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local TabMain = Instance.new("ScrollingFrame")
TabMain.Size = UDim2.new(1, 0, 1, 0)
TabMain.BackgroundTransparency = 1
TabMain.CanvasSize = UDim2.new(0, 0, 0, 400)
TabMain.ScrollBarThickness = 4
TabMain.Visible = false
TabMain.Parent = Container

local TabChar = TabMain:Clone()
TabChar.Parent = Container

local TabFun = TabMain:Clone()
TabFun.Parent = Container

local function createLayout(folder)
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = folder
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 15)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.Parent = folder
end
createLayout(TabMain)
createLayout(TabChar)
createLayout(TabFun)

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 350, 0, 180)
KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -90)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 8)
KeyCorner.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeyTitle.Text = "Key System"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.TextSize = 16
KeyTitle.Parent = KeyFrame

local KeyCornerTop = Instance.new("UICorner")
KeyCornerTop.CornerRadius = UDim.new(0, 8)
KeyCornerTop.Parent = KeyTitle

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 280, 0, 35)
KeyInput.Position = UDim2.new(0.5, -140, 0, 60)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInput.BorderSizePixel = 0
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter Key Here..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Font = Enum.Font.SourceSans
KeyInput.TextSize = 14
KeyInput.Parent = KeyFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = KeyInput

local KeyBtn = Instance.new("TextButton")
KeyBtn.Size = UDim2.new(0, 120, 0, 35)
KeyBtn.Position = UDim2.new(0.5, -60, 0, 115)
KeyBtn.BackgroundColor3 = Color3.fromRGB(35, 150, 35)
KeyBtn.Text = "Check Key"
KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBtn.Font = Enum.Font.SourceSansBold
KeyBtn.TextSize = 14
KeyBtn.Parent = KeyFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = KeyBtn

KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "mày rất dz và còn dz nhất thgioi" then
        KeyVerified = true
        KeyFrame:Destroy()
        MainFrame.Visible = true
    elseif KeyInput.Text == "sấu hơn t đẹp cl j" then
        LocalPlayer:Kick("sấu hơn t đẹp cl j")
    end
end)

local currentTab = nil
local function setupTabButton(name, order, targetTab)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, (order * 40) + 10)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = Sidebar
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if currentTab then currentTab.Visible = false end
        targetTab.Visible = true
        currentTab = targetTab
    end)
end

setupTabButton("Tab chính", 0, TabMain)
setupTabButton("Tab nhân vật", 1, TabChar)
setupTabButton("Tab vui", 2, TabFun)
TabMain.Visible = true
currentTab = TabMain

local function createToggle(name, parent, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -30, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 26)
    btn.Position = UDim2.new(1, -60, 0, 7)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = ""
    btn.Parent = frame
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 13)
    c.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(35, 150, 35)
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
        callback(state)
    end)
end

local function createSlider(name, min, max, default, parent, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -30, 0, 55)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. " : " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(1, -20, 0, 8)
    bg.Position = UDim2.new(0, 0, 0, 30)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    bg.Text = ""
    bg.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(35, 120, 200)
    fill.BorderSizePixel = 0
    fill.Parent = bg
    
    local function update(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local value = math.floor(min + (pos * (max - min)))
        label.Text = name .. " : " .. tostring(value)
        callback(value)
    end
    
    local dragging = false
    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local function createButton(name, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Thickness = 2
FOV_Circle.NumSides = 460
FOV_Circle.Radius = 150
FOV_Circle.Filled = false
FOV_Circle.Color = Color3.fromRGB(0, 255, 255)
FOV_Circle.Visible = false

RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    FOV_Circle.Position = Vector2.new(mousePos.X, mousePos.Y)
end)

local function isObstructed(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    
    local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
    return raycastResult ~= nil
end

local function getClosestTarget()
    local closestPlayer = nil
    local shortestDistance = FOV_Circle.Radius

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local isTeammate = (player.Team == LocalPlayer.Team and player.Team ~= nil)
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if humanoid and humanoid.Health > 0 and not isTeammate then
                local head = player.Character.Head
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if distance < shortestDistance then
                        if not isObstructed(head) then
                            shortestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled and KeyVerified then
        local target = getClosestTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

createToggle("Aimbot (Head)", TabMain, function(val)
    AimbotEnabled = val
    FOV_Circle.Visible = val
end)

local function applyHitbox(player)
    if player ~= LocalPlayer and player.Character then
        local character = player.Character
        local targetPart = character:FindFirstChild(TARGET_PART)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if targetPart and humanoid and humanoid.Health > 0 then
            targetPart.Size = HITBOX_SIZE
            targetPart.Transparency = HITBOX_TRANSPARENCY
            targetPart.Color = HITBOX_COLOR
            targetPart.Material = Enum.Material.Neon
            targetPart.CanCollide = false
        end
    end
end

local function resetHitbox(player)
    if player ~= LocalPlayer and player.Character then
        local targetPart = player.Character:FindFirstChild(TARGET_PART)
        if targetPart then
            targetPart.Size = Vector3.new(2, 2, 1)
            targetPart.Transparency = 1
            targetPart.Color = Color3.fromRGB(163, 162, 165)
            targetPart.Material = Enum.Material.Plastic
            targetPart.CanCollide = true
        end
    end
end

RunService.RenderStepped:Connect(function()
    if HitboxEnabled and KeyVerified then
        for _, player in ipairs(Players:GetPlayers()) do
            applyHitbox(player)
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            resetHitbox(player)
        end
    end
end)

createToggle("Hitbox", TabMain, function(val)
    HitboxEnabled = val
end)

RunService.Stepped:Connect(function()
    if NoclipEnabled and KeyVerified and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

createToggle("Noclip", TabMain, function(val)
    NoclipEnabled = val
end)

createButton("Fix Lag", TabMain, function()
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterDetailScale = 0
    end
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("PostEffect") then
            v.Enabled = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
    end
end)

createSlider("WalkSpeed", 16, 300, 16, TabChar, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
    end
end)

createSlider("JumpPower", 50, 500, 50, TabChar, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.UseJumpPower = true
        hum.JumpPower = val
    end
end)

createToggle("Infinite Jump", TabChar, function(val)
    InfJumpEnabled = val
end)

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and KeyVerified and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local function createESP(player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 0, 0)
    Box.Thickness = 2
    Box.Filled = false

    local Text = Drawing.new("Text")
    Text.Visible = false
    Text.Color = Color3.fromRGB(255, 255, 255)
    Text.Size = 16
    Text.Center = true
    Text.Outline = true

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if EspEnabled and player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local hrp = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local sizeY = (Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0)).Y)
                local sizeX = sizeY / 1.5

                Box.Size = Vector2.new(sizeX, sizeY)
                Box.Position = Vector2.new(screenPos.X - sizeX / 2, screenPos.Y - sizeY / 2)
                Box.Visible = true

                Text.Text = player.Name
                Text.Position = Vector2.new(screenPos.X, screenPos.Y - sizeY / 2 - 18)
                Text.Visible = true
            else
                Box.Visible = false
                Text.Visible = false
            end
        else
            Box.Visible = false
            Text.Visible = false
            if not EspEnabled or not player.Parent then
                Box:Remove()
                Text:Remove()
                connection:Disconnect()
            end
        end
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createESP(player)
    end)
end)

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        createESP(p)
    end
end

createToggle("ESP (Name + Box)", TabChar, function(val)
    EspEnabled = val
end)

local DropdownFrame = Instance.new("Frame")
DropdownFrame.Size = UDim2.new(1, -40, 0, 120)
DropdownFrame.BackgroundTransparency = 1
DropdownFrame.Parent = TabChar

local DropLabel = Instance.new("TextLabel")
DropLabel.Size = UDim2.new(1, 0, 0, 25)
DropLabel.BackgroundTransparency = 1
DropLabel.Text = "Select Player to Teleport:"
DropLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
DropLabel.Font = Enum.Font.SourceSans
DropLabel.TextSize = 14
DropLabel.TextXAlignment = Enum.TextXAlignment.Left
DropLabel.Parent = DropdownFrame

local DropScroll = Instance.new("ScrollingFrame")
DropScroll.Size = UDim2.new(1, 0, 0, 90)
DropScroll.Position = UDim2.new(0, 0, 0, 25)
DropScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DropScroll.BorderSizePixel = 0
DropScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
DropScroll.ScrollBarThickness = 4
DropScroll.Parent = DropdownFrame

local dropLayout = Instance.new("UIListLayout")
dropLayout.SortOrder = Enum.SortOrder.Name
dropLayout.Padding = UDim.new(0, 5)
dropLayout.Parent = DropScroll

local function updateTeleportList()
    for _, child in ipairs(DropScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, -10, 0, 25)
            pBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            pBtn.Text = p.Name
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.TextSize = 14
            pBtn.Parent = DropScroll
            
            local pc = Instance.new("UICorner")
            pc.CornerRadius = UDim.new(0, 4)
            pc.Parent = pBtn
            
            pBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    end
                end
            end)
        end
    end
    DropScroll.CanvasSize = UDim2.new(0, 0, 0, count * 30)
end

Players.PlayerAdded:Connect(updateTeleportList)
Players.PlayerRemoving:Connect(updateTeleportList)
updateTeleportList()

createToggle("Rainbow Ball Back", TabFun, function(val)
    if val then
        RainbowBall = Instance.new("Part")
        RainbowBall.Size = Vector3.new(2.5, 2.5, 2.5)
        RainbowBall.Shape = Enum.PartType.Ball
        RainbowBall.Material = Enum.Material.Neon
        RainbowBall.CanCollide = false
        RainbowBall.Parent = Workspace
        
        local bg = Instance.new("BillboardGui")
        bg.Size = UDim2.new(0, 150, 0, 50)
        bg.AlwaysOnTop = true
        bg.StudsOffset = Vector3.new(0, 2, 0)
        bg.Parent = RainbowBall
        
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.BackgroundTransparency = 1
        tl.Text = "bố vào đây"
        tl.TextColor3 = Color3.fromRGB(255, 255, 255)
        tl.TextScaled = true
        tl.Font = Enum.Font.SourceSansBold
        tl.Parent = bg
        
        task.spawn(function()
            local hue = 0
            while RainbowBall and RainbowBall.Parent do
                hue = (hue + 1) % 360
                local rainbowColor = Color3.fromHSV(hue/360, 1, 1)
                RainbowBall.Color = rainbowColor
                tl.TextColor3 = rainbowColor
                
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local targetPos = (hrp.CFrame * CFrame.new(0, 1.5, 3.5)).Position
                    RainbowBall.Position = RainbowBall.Position:Lerp(targetPos, 0.1)
                end
                task.wait()
            end
        end)
    else
        if RainbowBall then
            RainbowBall:Destroy()
            RainbowBall = nil
        end
    end
end)

createToggle("Rainbow Move Trail", TabFun, function(val)
    RainbowWalkEnabled = val
end)

RunService.RenderStepped:Connect(function()
    if RainbowWalkEnabled and KeyVerified and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.MoveDirection.Magnitude > 0 then
            local p = Instance.new("Part")
            p.Size = Vector3.new(1, 0.2, 1)
            p.Anchored = true
            p.CanCollide = false
            p.Material = Enum.Material.Neon
            p.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -2, 0)
            p.Parent = Workspace
            
            local hue = (tick() * 120) % 360
            p.Color = Color3.fromHSV(hue/360, 1, 1)
            
            task.spawn(function()
                for i = 0, 1, 0.1 do
                    p.Transparency = i
                    task.wait(0.05)
                end
                p:Destroy()
            end)
        end
    end
end)
