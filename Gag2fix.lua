local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌱 Huhu hub | Max Fix Lag & Auto Farm",
   LoadingTitle = "Đang tối ưu và tải tính năng...",
   LoadingSubtitle = "by Nvang m8",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("Tối Ưu Cực Hạn", 4483362458)
local FarmTab = Window:CreateTab("Tự Động (Auto)", 4483301774)

local _G = _G or {}
_G.LoopClean = false
_G.AutoHarvest = false
_G.AutoSell = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function CleanLightingAndSky()
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") or v:IsA("Clouds") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then
            v:Destroy()
        end
    end
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end

local function OptimizePlantsAndLeaves()
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
        if v:IsA("MeshPart") or v:IsA("Part") or v:IsA("UnionOperation") then
            local nameLower = v.Name:lower()
            if nameLower:match("leaf") or nameLower:match("leaves") or nameLower:match("foliage") then
                v.Transparency = 1
            else
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            end
        end
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        end
    end
end

spawn(function()
    while task.wait(2) do
        if _G.LoopClean then
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Sparkles") then v.Enabled = false end
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

spawn(function()
    while task.wait(0.5) do
        if _G.AutoHarvest then
            for _, prompt in pairs(game.Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local actionText = prompt.ActionText:lower()
                    local objectText = prompt.ObjectText:lower()
                    
                    if actionText:match("harvest") or actionText:match("pick") or objectText:match("plant") or objectText:match("tree") then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - prompt.Parent:GetPivot().Position).Magnitude
                            if distance <= 25 then 
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end
            end
        end
    end
end)

spawn(function()
    while task.wait(1) do
        if _G.AutoSell then
            for _, prompt in pairs(game.Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.ActionText:lower():match("sell") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - prompt.Parent:GetPivot().Position).Magnitude
                        if distance <= 20 then
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end
            
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or game:GetService("ReplicatedStorage"):FindFirstChild("Events")
            if remotes then
                local sellRemote = remotes:FindFirstChild("Sell") or remotes:FindFirstChild("SellItems") or remotes:FindFirstChild("Merchant")
                if sellRemote and sellRemote:IsA("RemoteEvent") then
                    sellRemote:FireServer()
                end
            end
        end
    end
end)

MainTab:CreateButton({
   Name = "⚡ Kích Hoạt Siêu Fix Lag (Bóng + Mây + Lá)",
   Callback = function()
      CleanLightingAndSky()
      OptimizePlantsAndLeaves()
      Rayfield:Notify({Name = "Huhu hub", Content = "Đã dọn sạch mây, lá cây và bóng đổ!", Duration = 4})
   end,
})

MainTab:CreateToggle({
   Name = "Duy Trì Xóa Lá & Hiệu Ứng Cây Mới",
   CurrentValue = false,
   Flag = "LoopCleanToggle",
   Callback = function(Value) _G.LoopClean = Value end,
})

MainTab:CreateButton({
   Name = "🔒 Khóa 60 FPS (Ổn định máy)",
   Callback = function()
      if setfpscap then setfpscap(60) end
   end,
})

FarmTab:CreateToggle({
   Name = "🔥 Tự Động Thu Hoạch (Auto Harvest)",
   CurrentValue = false,
   Flag = "HarvestToggle",
   Callback = function(Value)
      _G.AutoHarvest = Value
      if Value then
          Rayfield:Notify({Name = "Huhu hub", Content = "Đã bật tự động thu hoạch cây ở gần!", Duration = 3})
      end
   end,
})

FarmTab:CreateToggle({
   Name = "💰 Tự Động Bán Đồ (Auto Sell)",
   CurrentValue = false,
   Flag = "SellToggle",
   Callback = function(Value)
      _G.AutoSell = Value
      if Value then
          Rayfield:Notify({Name = "Huhu hub", Content = "Đã bật tự động bán nông sản tại quầy!", Duration = 3})
      end
   end,
})

Rayfield:Notify({Name = "Huhu hub", Content = "Hệ thống bởi Nvang m8 đã sẵn sàng!", Duration = 5})

