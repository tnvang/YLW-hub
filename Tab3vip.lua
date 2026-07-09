-- TAB 3: VISUALS (TÍCH HỢP ĐỔI FOV VÀ 3 LOẠI HIỆU ỨNG TỰ ĐỘNG TẮT NHAU)
createToggle("Visuals", "FPS BOOSTER", 1, function(state) toggleFPS(state) end)
createToggle("Visuals", "ESP NAME", 2, function(state) State.ESP_Name = state end)
createToggle("Visuals", "ESP BOX", 3, function(state) State.ESP_Box = state end)

createSlider("Visuals", "Góc Nhìn Camera (FOV)", 30, 120, 70, 4, function(v)
    State.Camera_FOV_Value = v
    Camera.FieldOfView = v
end)

local EffBtn_Rainbow = createToggle("Visuals", "HIỆU ỨNG RAINBOW CẦU VỒNG", 5, function(state) toggleVisualEffects("Rainbow", state) end)
local EffBtn_Ice = createToggle("Visuals", "HIỆU ỨNG BĂNG GIÁ RƠI", 6, function(state) toggleVisualEffects("Ice", state) end)
local EffBtn_Smoke = createToggle("Visuals", "HIỆU ỨNG KHÓI BAY", 7, function(state) toggleVisualEffects("Smoke", state) end)


-- HỆ THỐNG VÒNG LẶP RAINBOW RGB TỰ ĐỘNG CHO GIAO DIỆN MENU (HUHU HUB)
task.spawn(function()
    local hue = 0
    -- Tìm giao diện Menu của bạn trong CoreGui hoặc PlayerGui
    local targetUI = game:GetService("CoreGui"):FindFirstChild("Huhu hub") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Huhu hub")
    
    while task.wait(0.03) do
        hue = hue + 0.005
        if hue > 1 then hue = 0 end
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        
        -- Nếu tìm thấy đúng tên Menu "Huhu hub", tự động đổi màu toàn bộ viền và chữ tiêu đề
        if targetUI then
            for _, v in ipairs(targetUI:GetDescendants()) do
                if v:IsA("TextLabel") and (v.Text:find("Huhu") or v.Text:find("hub")) then
                    v.TextColor3 = rainbowColor -- Chữ tiêu đề đổi màu Cầu vồng
                elseif v:IsA("Frame") and (v.Name:find("Border") or v.Name:find("Main") or v.Name:find("Hub")) then
                    v.BorderColor3 = rainbowColor -- Viền Menu đổi màu Cầu vồng
                end
            end
        else
            -- Quét tìm lại phòng trường hợp Menu chưa load xong lúc đầu
            targetUI = game:GetService("CoreGui"):FindFirstChild("Huhu hub") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Huhu hub")
        end
    end
end)


-- THUẬT TOÁN ĐIỀU KHIỂN FLY MOBILE 3D MỚI (ĐÃ SỬA TRIỆT ĐỂ LỖI BAY NGƯỢC)
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


-- HÀM LOGIC QUẢN LÝ 3 KIỂU HIỆU ỨNG ĐẸP MẮT (XỬ LÝ DỌN DẸP INSTANCE THÔNG MINH)
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
            if v:IsA("Trail") or v:IsA("Sparkles") or v:IsA("Attachment") or v:IsA("ParticleEmitter") or v:IsA("Smoke") then v:Destroy() end
        end

        CurrentActiveEffect = mode

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
                while State.VisualEffects_Enabled and CurrentActiveEffect == "Rainbow" and ActiveTrail and ActiveTrail.Parent do
                    hue = hue + 0.01 if hue > 1 then hue = 0 end
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
        if CurrentActiveEffect == mode then
            State.VisualEffects_Enabled = false
            CurrentActiveEffect = nil
            for _, v in ipairs(root:GetChildren()) do
                if v:IsA("Trail") or v:IsA("Sparkles") or v:IsA("Attachment") or v:IsA("ParticleEmitter") or v:IsA("Smoke") then v:Destroy() end
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

-- HỆ THỐNG ESP MULTI-TARGET (TỰ ĐỘNG PHÂN BIỆT NGƯỜI VÀ QUÁI VẬT)
local function createESPObj(instance, isNPC)
    if State.ESP_Storage[instance] then return end
    local box = Drawing.new("Square")
    box.Color = isNPC and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    box.Thickness = 1.5
    box.Filled = false
    box.Visible = false
    
    local nameText = Drawing.new("Text")
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Center = true
    nameText.Outline = true
    nameText.Visible = false
    
    State.ESP_Storage[instance] = {Box = box, Text = nameText, IsNPC = isNPC}
end

local function removeESPObj(instance)
    if State.ESP_Storage[instance] then
        State.ESP_Storage[instance].Box:Destroy()
        State.ESP_Storage[instance].Text:Destroy()
        State.ESP_Storage[instance] = nil
    end
end

Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then createESPObj(p, false) end end)
Players.PlayerRemoving:Connect(removeESPObj)

RunService.RenderStepped:Connect(function()
    if State.ESP_Name or State.ESP_Box then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(v) then
                if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                    createESPObj(v, true)
                else
                    removeESPObj(v)
                end
            end
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then createESPObj(p, false) end
        end
    end

    for obj, esp in pairs(State.ESP_Storage) do
        local char = esp.IsNPC and obj or obj.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
            local root = char.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            
            if onScreen and (State.ESP_Name or State.ESP_Box) then
                local distance = (Camera.CFrame.Position - root.Position).Magnitude
                local displayName = esp.IsNPC and (obj.Name or "NPC") or obj.Name
                
                if State.ESP_Name then
                    esp.Text.Position = Vector2.new(screenPos.X, screenPos.Y - 35)
                    esp.Text.Text = displayName .. " [" .. math.round(distance) .. "m]"
                    esp.Text.Size = math.clamp(math.round(400 / distance) + 10, 11, 20)
                    esp.Text.Visible = true
                else esp.Text.Visible = false end
                
                if State.ESP_Box then
                    local sizeX, sizeY = 2000 / distance, 3000 / distance
                    esp.Box.Size = Vector2.new(sizeX, sizeY)
                    esp.Box.Position = Vector2.new(screenPos.X - (sizeX / 2), screenPos.Y - (sizeY / 2))
                    esp.Box.Visible = true
                else esp.Box.Visible = false end
            else esp.Box.Visible = false esp.Text.Visible = false end
        else
            esp.Box.Visible = false
            esp.Text.Visible = false
            if esp.IsNPC then removeESPObj(obj) end
        end
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

local fpsConnection
function toggleFPS(enable)
    State.FPS_Enabled = enable
    if enable then
        Lighting.GlobalShadows = false; Lighting.ClockTime = 12
        for _, v in ipairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false elseif v:IsA("Texture") or v:IsA("Decal") or v:IsA("ParticleEmitter") then v:Destroy() end end
        fpsConnection = workspace.DescendantAdded:Connect(function(v) if State.FPS_Enabled and v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false end end)
    else if fpsConnection then fpsConnection:Disconnect() end end
end

function isVisible(targetChar, targetPart)
    local p = RaycastParams.new() p.FilterType = Enum.RaycastFilterType.Exclude p.FilterDescendantsInstances = {LocalPlayer.Character, targetChar}
    return workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, p) == nil
end

function getClosestAimTarget()
    local closest, shortestDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    local function checkCharacter(char)
        if char and char ~= LocalPlayer.Character and char:FindFirstChild("Head") and char:FindFirstChildOfClass("Humanoid") then
            if char:FindFirstChildOfClass("Humanoid").Health <= 0 then return end
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(char.Head.Position)
            if onScreen and isVisible(char, char.Head) then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if dist <= State.Aim_Radius and dist < shortestDist then
                    closest = { Character = char, Part = char.Head }
                    shortestDist = dist
                end
            end
        end
    end

    if State.Aim_Mode == "Players" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then checkCharacter(p.Character) end
        end
    elseif State.Aim_Mode == "NPCs" then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(v) then
                checkCharacter(v)
            end
        end
    elseif State.Aim_Mode == "All" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then checkCharacter(p.Character) end
        end
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(v) then
                checkCharacter(v)
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
            else currentAimTarget = getClosestAimTarget() end
        end)
    else FOVCircle.Visible = false; if aimConnection then aimConnection:Disconnect() end end
end

function toggleHitbox(enable)
    State.Hitbox_Enabled = enable
    if enable then
        hitboxConnection = RunService.RenderStepped:Connect(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = p.Character.HumanoidRootPart
                    if not State.Hitbox_Originals[rootPart] then State.Hitbox_Originals[rootPart] = { Size = rootPart.Size, Transparency = rootPart.Transparency, CanCollide = rootPart.CanCollide } end
                    rootPart.Size = Vector3.new(State.Hitbox_Size, State.Hitbox_Size, State.Hitbox_Size) rootPart.Transparency = State.Hitbox_Transparency rootPart.CanCollide = false
                end
            end
        end)
    else
        if hitboxConnection then hitboxConnection:Disconnect() end
        for rPart, orig in pairs(State.Hitbox_Originals) do if rPart and rPart.Parent then rPart.Size = orig.Size; rPart.Transparency = orig.Transparency; rPart.CanCollide = orig.CanCollide end end
        table.clear(State.Hitbox_Originals)
    end
end

TransBox.FocusLost:Connect(function() State.Hitbox_Transparency = math.clamp(tonumber(TransBox.Text) or 0.5, 0, 1) TransBox.Text = tostring(State.Hitbox_Transparency) end)
AimMode_Btn.MouseButton1Click:Connect(function()
    if State.Aim_Mode == "All" then State.Aim_Mode = "Players"; AimMode_Btn.Text = "AIM TARGET: PLAYERS"; AimMode_Btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    elseif State.Aim_Mode == "Players" then State.Aim_Mode = "NPCs"; AimMode_Btn.Text = "AIM TARGET: NPCS"; AimMode_Btn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    else State.Aim_Mode == "All" ;AimMode_Btn.Text = "AIM TARGET: ALL"; AimMode_Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50) end currentAimTarget = nil
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if State.VisualEffects_Enabled and CurrentActiveEffect then
        local effectToRestore = CurrentActiveEffect
        toggleVisualEffects(effectToRestore, false)
        toggleVisualEffects(effectToRestore, true)
    end
end)

