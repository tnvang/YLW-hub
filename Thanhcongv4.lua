-- KHỞI TẠO HỆ THỐNG & BIẾN TOÀN CỤC
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local State = {
    WalkSpeed_Enabled = false,
    WalkSpeed_Value = 16,
    JumpPower_Enabled = false,
    JumpPower_Value = 50,
    InfJump_Enabled = false,
    Noclip_Enabled = false,
    Spider_Enabled = false,
    Fly_Enabled = false,
    Fly_Speed = 50,
    ESP_Name = false,
    ESP_Box = false,
    ESP_Storage = {},
    Camera_FOV_Value = 70,
    Freecam_Enabled = false,
    Clone_Active = false,
    Clone_Mode = "Stand",
    Clone_Model = nil,
    VisualEffects_Enabled = false,
    FPS_Enabled = false,
    Aim_Enabled = false,
    Aim_Radius = 150,
    Aim_Mode = "All",
    Hitbox_Enabled = false,
    Hitbox_Size = 2,
    Hitbox_Transparency = 0.5,
    Hitbox_Originals = {}
}

local FlyVelocity, FlyGyro
local currentActiveEffect, ActiveTrail, ActiveSparkles, ActiveSnowEmitter
local currentAimTarget = nil
local snowRenderConnection = nil

-- Khởi tạo vòng tròn FOV cho Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1.5
FOVCircle.Radius = State.Aim_Radius
FOVCircle.Filled = false
FOVCircle.Visible = false

-- GIAO DIỆN PHẦN CỨNG (HÀM TẠO UI PHỤ TRỢ)
local function createToggle(tab, text, order, callback)
    local btn = Instance.new("TextButton")
    btn.MouseButton1Click:Connect(function() end)
    return btn
end

local function createButton(tab, text, order, callback)
    local btn = Instance.new("TextButton")
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createSlider(tab, text, min, max, default, order, callback) end

local DropdownFrame = Instance.new("ScrollingFrame")
local SelectPlayerBtn = Instance.new("TextButton")
local updateDropdownList

-- XỬ LÝ LỰA CHỌN NGƯỜI CHƠI
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
        Instance.new("UICorner", pBtn).CornerRadius = UDim2.new(0, 4)

        pBtn.MouseButton1Click:Connect(function()
            DropdownFrame.Visible = false
            SelectPlayerBtn.Text = "TELE TO: " .. p.Name
            if LocalPlayer.Character and p.Character then
                local pRoot = p.Character:FindFirstChild("HumanoidRootPart")
                local lRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if pRoot and lRoot then
                    lRoot.CFrame = pRoot.CFrame
                end
            end
            task.wait(1)
            SelectPlayerBtn.Text = "🎯 CHỌN NGƯỜI CHƠI ĐỂ TELE"
        end)
    end
end

DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, count * 34)

local tPlayerBtn = Instance.new("TextButton")
tPlayerBtn.MouseButton1Click:Connect(function()
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

createButton("Thanhcong sub", "📷 GÓC NHÌN THỨ NHẤT (FIRST PERSON)", 5, function()
    LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
end)
createButton("Thanhcong sub", "🎥 GÓC NHÌN THỨ BA (THIRD PERSON)", 6, function()
    LocalPlayer.CameraMode = Enum.CameraMode.Classic
    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 128
end)

createToggle("Thanhcong sub", "🛸 FREECAM (GÓC NHÌN TỰ DO)", 7, function(state) toggleFreecam(state) end)
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
local EffBtn_Snow = createToggle("Thanhcong sub", "HIỆU ỨNG TUYẾT DI CHUYỂN", 13, function(state) toggleVisualEffects("Snow", state) end)

-- FREECAM LOGIC
local freecamCamPart = nil
local freecamConnection = nil

function toggleFreecam(enable)
    State.Freecam_Enabled = enable
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if enable then
        if root then root.Anchored = true end
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

-- FLY MOBILE LOGIC (SỬA LỖI ĐẢO HƯỚNG THEO GÓP Ý)
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
            
            -- Tính toán vector hướng chuẩn xác không bị ngược
            local direction = camCFrame.LookVector * (-moveDir.Z) + camCFrame.RightVector * moveDir.X
            
            if direction.Magnitude > 0 then
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    FlyVelocity.Velocity = Vector3.new(direction.X, 1, direction.Z).Unit * State.Fly_Speed
                else
                    FlyVelocity.Velocity = direction.Unit * State.Fly_Speed
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

-- HIỆU ỨNG HÌNH ẢNH NHÂN VẬT (TÍCH HỢP TUYẾT RƠI KHI DI CHUYỂN)
function toggleVisualEffects(mode, enable)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    -- Xóa dọn các hiệu ứng cũ đang chạy
    if snowRenderConnection then snowRenderConnection:Disconnect(); snowRenderConnection = nil end
    for _, v in ipairs(root:GetChildren()) do
        if v:IsA("Trail") or v:IsA("Sparkles") or v:IsA("Attachment") or v:IsA("ParticleEmitter") or v:IsA("Smoke") or v.Name == "SnowEffect" then
            v:Destroy()
        end 
    end 

    if enable then 
        State.VisualEffects_Enabled = true
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
        elseif mode == "Snow" then
            ActiveSnowEmitter = Instance.new("ParticleEmitter")
            ActiveSnowEmitter.Name = "SnowEffect"
            ActiveSnowEmitter.Texture = "rbxassetid://243660364"
            ActiveSnowEmitter.Color = ColorSequence.new(Color3.new(1, 1, 1))
            ActiveSnowEmitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 0)})
            ActiveSnowEmitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
            ActiveSnowEmitter.Lifetime = NumberRange.new(1.5, 2.5)
            ActiveSnowEmitter.Speed = NumberRange.new(2, 4)
            ActiveSnowEmitter.Rate = 0
            ActiveSnowEmitter.SpreadAngle = Vector2.new(180, 180)
            ActiveSnowEmitter.Acceleration = Vector3.new(0, -8, 0)
            ActiveSnowEmitter.Parent = root

            snowRenderConnection = RunService.RenderStepped:Connect(function()
                if not ActiveSnowEmitter or not hum.Parent then return end
                if hum.MoveDirection.Magnitude > 0 then
                    ActiveSnowEmitter.Rate = 60
                else
                    ActiveSnowEmitter.Rate = 0
                end
            end)
        end 
    else 
        if currentActiveEffect == mode then 
            State.VisualEffects_Enabled = false 
            currentActiveEffect = nil 
            ActiveTrail = nil 
            ActiveSparkles = nil 
            ActiveSnowEmitter = nil
        end 
    end 
end

Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if Camera.FieldOfView ~= State.Camera_FOV_Value then
        Camera.FieldOfView = State.Camera_FOV_Value
    end
end)

-- HỆ THỐNG DRAWING ESP
local function createESP(player)
    if State.ESP_Storage[player] then return end
    local box = Drawing.new("Square") box.Color = Color3.fromRGB(255, 50, 50) box.Thickness = 1.5 box.Filled = false box.Visible = false
    local nameText = Drawing.new("Text") nameText.Color = Color3.fromRGB(255, 255, 255) nameText.Center = true nameText.Outline = true nameText.Visible = false
    State.ESP_Storage[player] = {Box = box, Text = nameText}
end

local function removeESP(player)
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

-- LOGIC AIMBOT TỐI ƯU HÓA (ĐÃ NÂNG CẤP DUYỆT SÂU ĐỂ TÌM NPC)
local function isVisible(targetChar, targetPart) 
    local p = RaycastParams.new() 
    p.FilterType = Enum.RaycastFilterType.Exclude 
    p.FilterDescendantsInstances = {LocalPlayer.Character, targetChar} 
    return workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, p) == nil 
end

local function getClosestAimTarget() 
    local closest, shortestDist = nil, math.huge 
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) 

    -- Chế độ khóa mục tiêu Người chơi 
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
    
    -- Chế độ khóa mục tiêu NPC / ZOMBIE (Được cải tiến quét toàn bộ folder lồng sâu) 
    if State.Aim_Mode == "All" or State.Aim_Mode == "NPCs" then 
        for _, model in ipairs(workspace:GetDescendants()) do 
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
local hitboxConnection 
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

local TransBox = Instance.new("TextBox") 
TransBox.FocusLost:Connect(function() 
    State.Hitbox_Transparency = math.clamp(tonumber(TransBox.Text) or 0.5, 0, 1) 
    TransBox.Text = tostring(State.Hitbox_Transparency) 
end)

local AimMode_Btn = Instance.new("TextButton") 
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

