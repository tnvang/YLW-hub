local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Ak Gaming",
   LoadingTitle = "Đang Kiểm Tra Hệ Thống...",
   LoadingSubtitle = "by Gemini Assistant",
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

Rayfield:Notify({
   Title = "Xác Thực Thành Công!",
   Content = "Mật khẩu chính xác. Chúc bạn chơi game vui vẻ!",
   Duration = 5,
   Image = 4483362458,
})

local _G = {
    FixLag = false,
    InfJump = false,
    WalkSpeed = 16
}

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

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

player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = _G.WalkSpeed
end)

local JumpToggle = MainTab:CreateToggle({
   Name = "Nhảy Vô Hạn (Inf Jump)",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value)
      _G.InfJump = Value
   end,
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

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

local LagToggle = LagTab:CreateToggle({
   Name = "Bật Chế Độ Fix Lag (Xoá Hiệu Ứng & Màu Rối)",
   CurrentValue = false,
   Flag = "FixLagToggle",
   Callback = function(Value)
      _G.FixLag = Value
      if Value then
          Lighting.GlobalShadows = false
          Lighting.FogEnd = 9e9
          settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
          for _, effect in pairs(Lighting:GetChildren()) do
              if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRays") then
                  effect.Enabled = false
              end
          end
      end
   end,
})

task.spawn(function()
    while task.wait(3) do
        if _G.FixLag then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
                    obj.Enabled = false
                end
                if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("BasePart") then
                    obj.CastShadow = false
                    if shouldRemoveColor(obj.Color) then
                        obj.Material = Enum.Material.SmoothPlastic
                        obj.Color = Color3.fromRGB(170, 170, 170)
                    end
                end
            end
        end
    end
end)

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

