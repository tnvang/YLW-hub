local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local _G = {
    FixLag = false,
    InfJump = false,
    WalkSpeed = 16,
    JumpPower = 50 -- Giá trị mặc định ban đầu của Roblox
}

local Window = Rayfield:CreateWindow({
   Name = "Ak Gaming Hub",
   LoadingTitle = "Đang Kiểm Tra Hệ Thống...",
   LoadingSubtitle = "by Tác giả: Ak Gaming",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "GardenHub"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "Hệ Thống Xác Thực Key",
      Subtitle = "Vui lòng nhập Key để sử dụng Script",
      Note = "Mật khẩu: Fixlag Akgaming",
      FileName = "GardenKeyConfig", 
      SaveKey = true,
      GrabKeyFromUrl = false, 
      Key = {"Fixlag Akgaming"}
   }
})

local SoundService = game:GetService("SoundService")
local successSound = Instance.new("Sound")
successSound.SoundId = "rbxassetid://4432131238"
successSound.Volume = 1
successSound.Parent = SoundService
successSound:Play()

-- Thông báo bản quyền và lời chúc từ Ak Gaming
Rayfield:Notify({
   Title = "Xác Thực Thành Công!",
   Content = "Chúc bạn chơi game vui vẻ!\nYouTube: Akmemesea | TikTok: Akgamingytb999",
   Duration = 7,
   Image = 4483362458,
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- TAB THÔNG TIN TÁC GIẢ
local AuthorTab = Window:CreateTab("Thông Tin Tác Giả", 4483362458)

AuthorTab:CreateParagraph({Title = "👑 Tác giả: Ak Gaming", Content = "Cảm ơn bạn đã tin tưởng và sử dụng script!"})
AuthorTab:CreateParagraph({Title = "📺 Kênh YouTube", Content = "Akmemesea (Nhớ bấm Đăng ký ủng hộ AK nhé!)"})
AuthorTab:CreateParagraph({Title = "🎵 Kênh TikTok", Content = "Akgamingytb999"})
AuthorTab:CreateParagraph({Title = "💖 Lời chúc từ AK", Content = "Ak chúc bạn một ngày vui vẻ, hạnh phúc và thành công trong cuộc sống!"})

-- TAB TÍNH NĂNG NHÂN VẬT (Bao gồm Tốc độ, Nhảy cao và Nhảy vô hạn)
local MainTab = Window:CreateTab("Tính Năng Nhân Vật", 4483362458)

local SpeedSlider = MainTab:CreateSlider({
   Name = "Tốc Độ Chạy (WalkSpeed)",
   Range = {16, 150},
   Increment = 1,
   Suffix = " Tốc độ",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      _G.WalkSpeed = Value
      if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
          player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
      end
   end,
})

local JumpPowerSlider = MainTab:CreateSlider({
   Name = "Độ Cao Nhảy (JumpPower)",
   Range = {50, 500},
   Increment = 5,
   Suffix = " Lực nhảy",
   CurrentValue = 50,
   Flag = "JumpPowerSlider",
   Callback = function(Value)
      _G.JumpPower = Value
      if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
          local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
          humanoid.UseJumpPower = true -- Đảm bảo game sử dụng thuộc tính JumpPower thay vì JumpHeight
          humanoid.JumpPower = Value
      end
   end,
})

local JumpToggle = MainTab:CreateToggle({
   Name = "Nhảy Vô Hạn (Inf Jump)",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value)
      _G.InfJump = Value
   end,
})

-- Đồng bộ chỉ số khi nhân vật tải lại (Reset/Hồi sinh)
player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = _G.WalkSpeed
    hum.UseJumpPower = true
    hum.JumpPower = _G.JumpPower
end)

-- Xử lý Nhảy vô hạn
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- TAB TỐI ƯU & FIX LAG
local LagTab = Window:CreateTab("Tối Ưu & Khử Lag", 4483362458)

local function shouldRemoveColor(color)
    local h, s, v = color:ToHSV()
    local hue, sat, val = h * 360, s * 100, v * 100
    if val < 20 then return true end
    if hue >= 10 and hue <= 40 and val < 50 then return true end
    if hue >= 175 and hue <= 255 and sat > 20 then return true end
    if hue > 255 and hue <= 345 and sat > 20 then return true end
    return false
end

local function UltraFixLag()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    
    if workspace:FindFirstChildOfClass("Terrain") then
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 0
        if sethiddenproperty then
            sethiddenproperty(terrain, "Decoration", false)
        end
    end

    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRays") or effect:IsA("Atmosphere") or effect:IsA("Clouds") then
            effect.Enabled = false
        end
    end

    for _, obj in pairs(workspace:GetDescendants()) do
        if _G.FixLag == false then break end

        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") or obj:IsA("Beam") then
            obj.Enabled = false
        end
        
        if obj:IsA("Texture") or obj:IsA("Decal") then
            obj:Destroy() 
        end

        if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("BasePart") then
            obj.CastShadow = false
            obj.Material = Enum.Material.SmoothPlastic
            if shouldRemoveColor(obj.Color) then
                obj.Color = Color3.fromRGB(170, 170, 170)
            end
        end

        if obj:IsA("MeshPart") then
            obj.RenderFidelity = Enum.RenderFidelity.Performance
        end
        
        if obj:IsA("Highlight") then
            obj.Enabled = false
        end
    end
end

local LagToggle = LagTab:CreateToggle({
   Name = "Bật Chế Độ SIÊU FIX LAG (Mượt Tối Đa)",
   CurrentValue = false,
   Flag = "FixLagToggle",
   Callback = function(Value)
      _G.FixLag = Value
      if Value then
          UltraFixLag()
          Rayfield:Notify({
             Title = "Ultra Fix Lag - Ak Gaming",
             Content = "Đã dọn dẹp Texture, Hiệu ứng và Đất đá tối đa!",
             Duration = 4,
             Image = 4483362458,
          })
      end
   end,
})

task.spawn(function()
    while task.wait(5) do
        if _G.FixLag then
            for _, obj in pairs(workspace:GetDescendants()) do
                if not _G.FixLag then break end
                
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") or obj:IsA("Beam") then
                    obj.Enabled = false
                end
                if obj:IsA("Texture") or obj:IsA("Decal") then
                    obj:Destroy()
                end
                if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("BasePart") then
                    obj.CastShadow = false
                    if obj.Material ~= Enum.Material.SmoothPlastic then
                        obj.Material = Enum.Material.SmoothPlastic
                    end
                end
                if obj:IsA("Highlight") then
                    obj.Enabled = false
                end
            end
        end
    end
end)

-- BẢNG THÔNG SỐ (UI STATS)
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")
local startTime = os.time()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RayfieldLagStatsUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 200, 0, 105)
textLabel.Position = UDim2.new(1, -210, 0, 45)
textLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
textLabel.BackgroundTransparency = 0.4
textLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
textLabel.TextSize = 13
textLabel.Font = Enum.Font.RobotoMono
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.BorderSizePixel = 0
textLabel.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = textLabel

local deviceType = UserInputService.TouchEnabled and (UserInputService.KeyboardEnabled and "Tablet" or "Mobile") or "PC"

task.spawn(function()
    local fpsCount = 0
    RunService.RenderStepped:Connect(function() fpsCount = fpsCount + 1 end)

    while task.wait(1) do
        local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local duration = os.difftime(os.time(), startTime)
        local hours = math.floor(duration / 3600)
        local mins = math.floor((duration % 3600) / 60)
        local secs = duration % 60
        
        textLabel.Text = string.format(
            " 👤 USER: %s\n 📱 DEV: %s\n ⚡ PING: %d ms\n 📊 FPS: %d\n ⏱️ TIME: %02d:%02d:%02d",
            player.Name, deviceType, ping, fpsCount, hours, mins, secs
        )
        fpsCount = 0
    end
end)

