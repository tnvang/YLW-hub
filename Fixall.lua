local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Huhu hub | Roblox Script",
   LoadingTitle = "Huhu Hub Premium",
   LoadingSubtitle = "by Nvang m8",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Biến cấu hình mặc định và Biến Lưu Trạng Thái Gốc (Để khôi phục chính xác)
local SelectedPlayer = ""
local InfiniteJumpEnabled = false
local NoclipEnabled = false
local AntiAfkEnabled = false
local HitboxSize = 2
local AimPartMode = "Head / Đầu"
local EspEnabled = false

-- Lưu trữ giá trị gốc của hệ thống
local OriginalAmbient = game:GetService("Lighting").Ambient
local OriginalFogEnd = game:GetService("Lighting").FogEnd
local OriginalFogStart = game:GetService("Lighting").FogStart

-- Bảng lưu trữ trạng thái gốc của Part (Dùng cho Hitbox & Noclip)
local OriginalHitboxData = {}
local OriginalCollisions = {}

--------------------------------------------
-- [1] TABS KHỞI TẠO
--------------------------------------------
local VisualTab = Window:CreateTab("👁️ Visuals", nil)
local PlayerTab = Window:CreateTab("🏃 Player", nil)
local PvpTab    = Window:CreateTab("⚔️ Combat", nil)
local TeleTab   = Window:CreateTab("🌀 Teleport", nil)
local SystemTab = Window:CreateTab("🛠️ System", nil)
local SettingTab = Window:CreateTab("⚙️ Settings", nil)

--------------------------------------------
-- [2] VISUALS (HIỂN THỊ)
--------------------------------------------
VisualTab:CreateSection("Visual Features / Tính Năng Hiển Thị")

local function UpdateESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local oldEsp = head:FindFirstChild("HuhuESP")
                if oldEsp then oldEsp:Destroy() end
                if EspEnabled then
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "HuhuESP"; bg.Adornee = head; bg.Size = UDim2.new(0, 200, 0, 50); bg.AlwaysOnTop = true; bg.Parent = head
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = p.Name; tl.TextColor3 = Color3.fromRGB(255, 0, 0); tl.TextSize = 14; tl.Font = Enum.Font.SourceSansBold; tl.Parent = bg
                end
            end
        end
    end
end

VisualTab:CreateToggle({
   Name = "ESP Name / Hiện Tên",
   CurrentValue = false,
   Flag = "ToggleESP",
   Callback = function(Value)
      EspEnabled = Value
      UpdateESP()
   end,
})

task.spawn(function()
    while task.wait(5) do 
        if EspEnabled then pcall(UpdateESP) end 
    end
end)

VisualTab:CreateToggle({
   Name = "Fullbright / Sáng Bản Đồ",
   CurrentValue = false,
   Flag = "ToggleFullbright",
   Callback = function(Value)
      -- Khôi phục chính xác Ambient gốc của Game khi tắt
      game:GetService("Lighting").Ambient = Value and Color3.fromRGB(255, 255, 255) or OriginalAmbient
   end,
})

VisualTab:CreateToggle({
   Name = "No Fog / Xóa Sương Mù",
   CurrentValue = false,
   Flag = "ToggleNoFog",
   Callback = function(Value)
      if Value then
          game:GetService("Lighting").FogStart = 9e9; game:GetService("Lighting").FogEnd = 9e9
      else
          game:GetService("Lighting").FogStart = OriginalFogStart; game:GetService("Lighting").FogEnd = OriginalFogEnd
      end
   end,
})

--------------------------------------------
-- [3] PLAYER MOVEMENT (NGƯỜI CHƠI)
--------------------------------------------
PlayerTab:CreateSection("Movement Features / Tính Năng Di Chuyển")

PlayerTab:CreateToggle({
   Name = "Infinite Jump / Nhảy Vô Hạn",
   CurrentValue = false,
   Flag = "ToggleInfJump",
   Callback = function(Value)
      InfiniteJumpEnabled = Value
   end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled and game.Players.LocalPlayer.Character then
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

PlayerTab:CreateSlider({
   Name = "Walkspeed / Tốc Độ Chạy",
   Range = {16, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SliderWalkspeed",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
          game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "Jump Power / Sức Nhảy",
   Range = {50, 500},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "SliderJumpPower",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
          game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "Noclip / Xuyên Tường",
   CurrentValue = false,
   Flag = "ToggleNoclip",
   Callback = function(Value)
      NoclipEnabled = Value
      -- Nếu tắt Noclip, khôi phục lại trạng thái va chạm ban đầu ngay lập tức
      if not Value and game.Players.LocalPlayer.Character then
          for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
              if v:IsA("BasePart") and OriginalCollisions[v] ~= nil then
                  v.CanCollide = OriginalCollisions[v]
              end
          end
      end
   end,
})

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                -- Lưu lại trạng thái va chạm gốc trước khi đổi thành false
                if OriginalCollisions[v] == nil then
                    OriginalCollisions[v] = v.CanCollide
                end
                v.CanCollide = false
            end
        end
    end
end)

--------------------------------------------
-- [4] COMBAT (CHIẾN ĐẤU)
--------------------------------------------
PvpTab:CreateSection("Combat Features / Tính Năng Chiến Đấu")

PvpTab:CreateSlider({
   Name = "Hitbox Size / Kích Thước Hitbox",
   Range = {2, 50},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 2,
   Flag = "SliderHitbox",
   Callback = function(Value)
      HitboxSize = Value
   end,
})

PvpTab:CreateDropdown({
   Name = "Aim Position / Vị Trí Găm",
   Options = {"Head / Đầu", "Torso / Người"},
   CurrentOption = {"Head / Đầu"},
   MultipleOptions = false,
   Flag = "DropdownAim",
   Callback = function(Option)
      AimPartMode = Option[1]
   end,
})

-- Hàm xử lý và quét áp dụng Hitbox liên tục, hỗ trợ hồi sinh (CharacterAdded)
local function ApplyHitbox(p)
    if p == game.Players.LocalPlayer then return end
    local char = p.Character or p.CharacterAdded:Wait()
    
    local partName = (AimPartMode == "Head / Đầu") and "Head" or "HumanoidRootPart"
    local targetPart = char:WaitForChild(partName, 5)
    
    if targetPart and targetPart:IsA("BasePart") then
        -- Lưu lại kích thước, độ trong suốt, va chạm gốc nếu chưa có dữ liệu lưu trữ
        if not OriginalHitboxData[targetPart] then
            OriginalHitboxData[targetPart] = {
                Size = targetPart.Size,
                Transparency = targetPart.Transparency,
                CanCollide = targetPart.CanCollide
            }
        end
        
        -- Nếu người dùng kéo Slider về mặc định (2), trả lại dữ liệu gốc ban đầu
        if HitboxSize <= 2 then
            targetPart.Size = OriginalHitboxData[targetPart].Size
            targetPart.Transparency = OriginalHitboxData[targetPart].Transparency
            targetPart.CanCollide = OriginalHitboxData[targetPart].CanCollide
        else
            targetPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
            targetPart.Transparency = 0.5
            targetPart.CanCollide = false
        end
    end
end

-- Vòng lặp quét thế giới bảo đảm không bị sót khi người chơi ra/vào game hoặc hồi sinh
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character then
                    ApplyHitbox(p)
                end
            end
        end)
    end
end)

-- Lắng nghe sự kiện người chơi mới vào phòng hoặc hồi sinh để găm lại Hitbox ngay lập tức
game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1) -- Chờ nhân vật load xong hẳn
        pcall(function() ApplyHitbox(plr) end)
    end)
end)

--------------------------------------------
-- [5] TELEPORT (DỊCH CHUYỂN)
--------------------------------------------
TeleTab:CreateSection("Teleport Player / Dịch Chuyển Player")

local function GetPlayerNames()
    local list = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then table.insert(list, p.Name) end
    end
    return list
end

local PlayerDropdown = TeleTab:CreateDropdown({
   Name = "Select Player / Chọn Người Chơi",
   Options = GetPlayerNames(),
   CurrentOption = {""},
   MultipleOptions = false,
   Flag = "DropdownTele",
   Callback = function(Option)
      SelectedPlayer = Option[1]
   end,
})

TeleTab:CreateButton({
   Name = "🔄 Refresh / Làm Mới Danh Sách",
   Callback = function()
      PlayerDropdown:Refresh(GetPlayerNames(), true)
   end,
})

TeleTab:CreateButton({
   Name = "Teleport / Dịch Chuyển Đến",
   Callback = function()
      if SelectedPlayer ~= "" and game.Players:FindFirstChild(SelectedPlayer) then
          local targetChar = game.Players[SelectedPlayer].Character
          local localChar = game.Players.LocalPlayer.Character
          if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and localChar and localChar:FindFirstChild("HumanoidRootPart") then
              localChar.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame
          end
      end
   end,
})

--------------------------------------------
-- [6] SYSTEM (HỆ THỐNG)
--------------------------------------------
SystemTab:CreateSection("Optimization & System / Tối Ưu Hệ Thống")

SystemTab:CreateButton({
   Name = "Fix Lag / Tối Ưu Bộ Nhớ",
   Callback = function()
      settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
      for _, v in pairs(game:GetDescendants()) do
          if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v.Enabled = false end
      end
      collectgarbage("collect")
   end,
})

SystemTab:CreateButton({
   Name = "Low Graphics / Xóa Vật Liệu",
   Callback = function()
      for _, v in pairs(workspace:GetDescendants()) do
          if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic end
      end
   end,
})

SystemTab:CreateToggle({
   Name = "Anti AFK / Chống Treo Máy",
   CurrentValue = false,
   Flag = "ToggleAntiAfk",
   Callback = function(Value)
      AntiAfkEnabled = Value
   end,
})

game.Players.LocalPlayer.Idled:Connect(function()
    if AntiAfkEnabled then
        local vu = game:GetService("VirtualUser")
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

--------------------------------------------
-- [7] SETTINGS & CREDITS
--------------------------------------------
SettingTab:CreateSection("Script Info / Thông Tin Script")
SettingTab:CreateParagraph({Title = "Menu", Content = "Huhu hub"})
SettingTab:CreateParagraph({Title = "Author / Tác giả", Content = "Nvang m8"})
SettingTab:CreateParagraph({Title = "TikTok ID", Content = "ditnatbuombn"})
SettingTab:CreateParagraph({Title = "Version", Content = "1.0.0 Premium"})
SettingTab:CreateParagraph({Title = "User / Người dùng", Content = game.Players.LocalPlayer.Name})

Rayfield:Notify({
   Title = "Huhu hub",
   Content = "Script đã sửa lỗi và kích hoạt thành công!",
   Duration = 5,
})
