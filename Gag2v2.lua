local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌱 Huhu hub | Max Fix Lag & Auto Farm",
   LoadingTitle = "Đang tối ưu cấu hình siêu yếu...",
   LoadingSubtitle = "by Nvang m8",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("Tối Ưu Cực Hạn", 4483362458)
local FarmTab = Window:CreateTab("Tự Động (Auto)", 4483301774)
local PVPTab = Window:CreateTab("Chiến Đấu (PVP)", 4483362458)

local _G = _G or {}
_G.LoopClean = false
_G.AutoHarvest = false
_G.AutoSell = false
_G.AutoBuy = false
_G.AutoPlant = false
_G.AutoSnipeSeeds = false
_G.AutoSteal = false
_G.AutoDodge = false
_G.PlayerESP = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = game:GetService("Workspace").CurrentCamera

local function CleanLightingAndSky()
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") or v:IsA("Clouds") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") then
            v:Destroy()
        end
    end
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    sethiddenproperty(game:GetService("Lighting"), "Technology", Enum.Technology.Compatibility)
end

local function OptimizePlantsAndLeaves()
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("Clothing") or v:IsA("ShirtGraphic") then v:Destroy() end
        if v:IsA("MeshPart") or v:IsA("Part") or v:IsA("UnionOperation") then
            local nameLower = v.Name:lower()
            if nameLower:match("leaf") or nameLower:match("leaves") or nameLower:match("foliage") or nameLower:match("bush") then
                v.Transparency = 1
            else
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            end
        end
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Fire") then
            v.Enabled = false
        end
    end
    local terrain = game.Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
        terrain.Decoration = false
    end
end

local function HardcoreAntiLag()
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("AnimationTrack") or v:IsA("Animator") then
            v:Destroy()
        end
    end
    game:GetService("ContentProvider"):PreloadAsync({})
end

local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

local espObjects = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 1.2
    box.Filled = false
    
    local text = Drawing.new("Text")
    text.Visible = false
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Size = 12
    text.Center = true
    text.Outline = true
    
    espObjects[player] = {Box = box, Text = text}
end

local function removeESP(player)
    if espObjects[player] then
        espObjects[player].Box:Destroy()
        espObjects[player].Text:Destroy()
        espObjects[player] = nil
    end
end

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for player, esp in pairs(espObjects) do
        if _G.PlayerESP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local sizeY = (Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0)).Y)
                local sizeX = sizeY / 1.8
                
                esp.Box.Size = Vector2.new(math.abs(sizeX), math.abs(sizeY))
                esp.Box.Position = Vector2.new(pos.X - math.abs(sizeX) / 2, pos.Y - math.abs(sizeY) / 2)
                esp.Box.Visible = true
                
                esp.Text.Text = player.Name
                esp.Text.Position = Vector2.new(pos.X, (pos.Y - math.abs(sizeY) / 2) - 14)
                esp.Text.Visible = true
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

spawn(function()
    while task.wait(0.02) do
        if _G.AutoDodge and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myHrp = LocalPlayer.Character.HumanoidRootPart
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    local enemyHrp = player.Character.HumanoidRootPart
                    local enemyHumanoid = player.Character.Humanoid
                    
                    local distance = (myHrp.Position - enemyHrp.Position).Magnitude
                    if distance <= 15 and enemyHumanoid.Health > 0 then
                        local isAttacking = false
                        
                        local playingTracks = enemyHumanoid:GetPlayingAnimationTracks()
                        for _, track in pairs(playingTracks) do
                            local animName = track.Animation and track.Animation.Name:lower() or ""
                            if animName:match("attack") or animName:match("slash") or animName:match("hit") or animName:match("swing") or animName:match("use") then
                                isAttacking = true
                                break
                            end
                        end
                        
                        local tool = player.Character:FindFirstChildOfClass("Tool")
                        if tool and (tool:FindFirstChild("RemoteClick") or tool:FindFirstChild("Activate")) then
                            isAttacking = true 
                        end
                        
                        if isAttacking then
                            myHrp.CFrame = enemyHrp.CFrame * CFrame.new(0, 0, 6) 
                            task.wait(0.15)
                        end
                    end
                end
            end
        end
    end
end)

spawn(function()
    while task.wait(1) do
        if _G.LoopClean then
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Sparkles") or v:IsA("Fire") then v.Enabled = false end
                if v:IsA("MeshPart") or v:IsA("Part") then
                    v.CastShadow = false
                    local nameLower = v.Name:lower()
                    if nameLower:match("leaf") or nameLower:match("leaves") then v.Transparency = 1 end
                end
            end
            collectgarbage("collect")
        end
    end
end)

-- 1. AUTO HARVEST
spawn(function()
    while task.wait(0.3) do
        if _G.AutoHarvest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, prompt in pairs(game.Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local actionText = prompt.ActionText:lower()
                    local objectText = prompt.ObjectText:lower()
                    if actionText:match("harvest") or actionText:match("pick") or objectText:match("plant") or objectText:match("tree") then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - prompt.Parent:GetPivot().Position).Magnitude
                        if distance <= 35 then 
                            fireproximityprompt(prompt) 
                        end
                    end
                end
            end
        end
    end
end)

-- 2. UPDATED AUTO SELL (Quét thêm từ khóa Trade/Market/Vendor & Chờ 5s)
spawn(function()
    while task.wait(5) do
        if _G.AutoSell and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, prompt in pairs(game.Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local actionText = prompt.ActionText:lower()
                    if actionText:match("sell") or actionText:match("trade") or actionText:match("market") or actionText:match("vendor") then
                        local targetPart = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildWhichIsA("BasePart")
                        if targetPart then
                            local oldCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, 2, 0)
                            task.wait(0.2)
                            fireproximityprompt(prompt)
                            task.wait(0.1)
                            LocalPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- 3. AUTO BUY
spawn(function()
    while task.wait(2) do
        if _G.AutoBuy and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, prompt in pairs(game.Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local actionText = prompt.ActionText:lower()
                    local objectText = prompt.ObjectText:lower()
                    if actionText:match("buy") or actionText:match("purchase") or objectText:match("seed") or objectText:match("hạt") then
                        local targetPart = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildWhichIsA("BasePart")
                        if targetPart then
                            local oldCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, 2, 0)
                            task.wait(0.2)
                            fireproximityprompt(prompt)
                            task.wait(0.1)
                            LocalPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- 4. AUTO PLANT
spawn(function()
    while task.wait(0.5) do
        if _G.AutoPlant and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, prompt in pairs(game.Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local actionText = prompt.ActionText:lower()
                    local objectText = prompt.ObjectText:lower()
                    if actionText:match("plant") or actionText:match("seed") or actionText:match("grow") or objectText:match("dirt") or objectText:match("plot") then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - prompt.Parent:GetPivot().Position).Magnitude
                        if distance <= 35 then 
                            fireproximityprompt(prompt) 
                        end
                    end
                end
            end
        end
    end
end)

-- 5. AUTO SNIPE SEEDS
spawn(function()
    while task.wait(0.1) do
        if _G.AutoSnipeSeeds and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, prompt in pairs(game.Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local nameTarget = prompt.Parent.Name:lower()
                    local textTarget = prompt.ObjectText:lower()
                    local actionTarget = prompt.ActionText:lower()
                    if nameTarget:match("golden") or nameTarget:match("rainbow") or textTarget:match("golden") or textTarget:match("rainbow") or actionTarget:match("golden") or actionTarget:match("rainbow") then
                        local targetPart = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildWhichIsA("BasePart")
                        if targetPart then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, 2, 0)
                            task.wait(0.1)
                            local origHold = prompt.HoldDuration
                            prompt.HoldDuration = 0
                            fireproximityprompt(prompt)
                            prompt.HoldDuration = origHold
                        end
                    end
                end
            end
        end
    end
end)

-- 6. AUTO STEAL
spawn(function()
    while task.wait(1.5) do
        if _G.AutoSteal then
            local Lighting = game:GetService("Lighting")
            if Lighting.ClockTime >= 18 or Lighting.ClockTime <= 5 then
                local myPlot = nil
                for _, p in pairs(game.Workspace:GetChildren()) do
                    if p.Name:lower():match("plot") and p:GetAttribute("Owner") == LocalPlayer.Name then
                        myPlot = p
                        break
                    end
                end
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local homeCFrame = myPlot and myPlot:GetPivot() or LocalPlayer.Character.HumanoidRootPart.CFrame
                    for _, prompt in pairs(game.Workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") then
                            local actionText = prompt.ActionText:lower()
                            local objectText = prompt.ObjectText:lower()
                            if actionText:match("steal") or actionText:match("harvest") or actionText:match("pick") then
                                local isTargetValuable = objectText:match("rainbow") or objectText:match("golden") or objectText:match("giant") or objectText:match("mega")
                                local targetPlot = prompt:FindFirstAncestorWhichIsA("Model") or prompt.Parent
                                local isMyOwn = false
                                if myPlot and targetPlot:IsDescendantOf(myPlot) then isMyOwn = true end
                                if not isMyOwn and isTargetValuable then
                                    local targetPart = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildWhichIsA("BasePart")
                                    if targetPart then
                                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, 2, 0)
                                        task.wait(0.15)
                                        local origHold = prompt.HoldDuration
                                        prompt.HoldDuration = 0
                                        fireproximityprompt(prompt)
                                        prompt.HoldDuration = origHold
                                        task.wait(0.1)
                                        LocalPlayer.Character.HumanoidRootPart.CFrame = homeCFrame
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

MainTab:CreateButton({
   Name = "⚡ Siêu Fix Lag Hoàn Toàn (Khuyên Dùng)",
   Callback = function()
      CleanLightingAndSky()
      OptimizePlantsAndLeaves()
      HardcoreAntiLag()
      Rayfield:Notify({Name = "Huhu hub", Content = "Đã kích hoạt chế độ siêu mượt tối đa!", Duration = 4})
   end,
})

MainTab:CreateToggle({
   Name = "Duy Trì Xóa Lá & Hiệu Ứng Khóa Lag",
   CurrentValue = false,
   Flag = "LoopCleanToggle",
   Callback = function(Value) _G.LoopClean = Value end,
})

MainTab:CreateButton({
   Name = "🔒 Khóa Thấp 30 FPS (Chống Nóng Máy)",
   Callback = function()
      if setfpscap then setfpscap(30) end
   end,
})

FarmTab:CreateToggle({
   Name = "🔥 Tự Động Thu Hoạch (Auto Harvest)",
   CurrentValue = false,
   Flag = "HarvestToggle",
   Callback = function(Value) _G.AutoHarvest = Value end,
})

FarmTab:CreateToggle({
   Name = "💰 Tự Động Bán Đồ Từ Xa (Remote Sell)",
   CurrentValue = false,
   Flag = "SellToggle",
   Callback = function(Value) _G.AutoSell = Value end,
})

FarmTab:CreateToggle({
   Name = "🛒 Tự Động Mua Tất Cả Hạt Giống (Auto Buy)",
   CurrentValue = false,
   Flag = "BuyToggle",
   Callback = function(Value) _G.AutoBuy = Value end,
})

FarmTab:CreateToggle({
   Name = "🌱 Tự Động Trồng Cây (Auto Plant)",
   CurrentValue = false,
   Flag = "PlantToggle",
   Callback = function(Value) _G.AutoPlant = Value end,
})

FarmTab:CreateToggle({
   Name = "👑 Tele Nhặt Siêu Tốc Hạt Golden / Rainbow",
   CurrentValue = false,
   Flag = "SnipeToggle",
   Callback = function(Value) _G.AutoSnipeSeeds = Value end,
})

FarmTab:CreateToggle({
   Name = "🥷 Auto Đi Trộm Trái To Về Nhà Siêu Tốc",
   CurrentValue = false,
   Flag = "StealToggle",
   Callback = function(Value) _G.AutoSteal = Value end,
})

PVPTab:CreateToggle({
   Name = "⚡ Né Đòn Phản Xạ Khi Địch Vung Chiêu",
   CurrentValue = false,
   Flag = "SmartDodgeToggle",
   Callback = function(Value)
      _G.AutoDodge = Value
      if Value then
          Rayfield:Notify({Name = "Huhu hub", Content = "Đã bật phản xạ tự động né đòn tầm gần!", Duration = 3})
      end
   end,
})

PVPTab:CreateToggle({
   Name = "👁️ Khung ESP Tên Thon Gọn (Dễ Nhìn)",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value) _G.PlayerESP = Value end,
})

Rayfield:Notify({Name = "Huhu hub", Content = "Hệ thống bởi Nvang m8 & Anti-AFK đã sẵn sàng!", Duration = 5})

