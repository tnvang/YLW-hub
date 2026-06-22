local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Huhu hub | Roblox Script",
   LoadingTitle = "Huhu Hub Premium",
   LoadingSubtitle = "by Nvang m8",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Biến cấu hình mặc định và trạng thái
local SelectedPlayer = ""
local InfiniteJumpEnabled = false
local NoclipEnabled = false
local AntiAfkEnabled = false
local HitboxSize = 2
local AimPartMode = "Head / Đầu"
local AimTargetMode = "Player / Người chơi" -- "Player / Người chơi", "NPC / Quái", "All / Cả hai"
local KillAuraEnabled = false
local KillAuraRange = 50
local EspEnabled = false

-- Lưu trữ trạng thái gốc hệ thống
local OriginalAmbient = game:GetService("Lighting").Ambient
local OriginalFogEnd = game:GetService("Lighting").FogEnd
local OriginalFogStart = game:GetService("Lighting").FogStart
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
-- [2] VISUALS (HIỂN THỊ & ESP KHUNG)
--------------------------------------------
VisualTab:CreateSection("Visual Features / Tính Năng Hiển Thị")

local function CleanESP(char)
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            local oldEsp = head:FindFirstChild("HuhuESP")
            if oldEsp then oldEsp:Destroy() end
        end
        local oldBox = char:FindFirstChild("HuhuBoxESP")
        if oldBox then oldBox:Destroy() end
    end
end

local function UpdateESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            CleanESP(p.Character)
            if EspEnabled then
                local head = p.Character:FindFirstChild("Head")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if head and hrp then
                    -- 1. Hiện Tên (BillboardGui)
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "HuhuESP"; bg.Adornee = head; bg.Size = UDim2.new(0, 200, 0, 50); bg.AlwaysOnTop = true; bg.Parent = head
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = p.Name; tl.TextColor3 = Color3.fromRGB(255, 0, 0); tl.TextSize = 14; tl.Font = Enum.Font.SourceSansBold; tl.Parent = bg
                    
                    -- 2. Khung ESP (Box ESP bằng BoxHandleAdornment)
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "HuhuBoxESP"
                    box.Size = p.Character:GetExtentsSize() + Vector3.new(0.5, 0.5, 0.5)
                    box.Color3 = Color3.fromRGB(255, 0, 0)
                    box.Transparency = 0.6
                    box.AlwaysOnTop = true
                    box.ZIndex = 5
                    box.Adornee = p.Character
                    box.Parent = p.Character
                end
            end
        end
    end
end

VisualTab:CreateToggle({
   Name = "ESP Name & Box / Hiện Tên & Khung",
   CurrentValue = false,
   Flag = "ToggleESP",
   Callback = function(Value)
      EspEnabled = Value
      if not Value then
          for _, p in pairs(game.Players:GetPlayers()) do if p.Character then CleanESP(p.Character) end end
      else
          UpdateESP()
      end
   end,
})

task.spawn(function()
    while task.wait(3) do if EspEnabled then pcall(UpdateESP) end end
end)

VisualTab:CreateToggle({
   Name = "Fullbright / Sáng Bản Đồ",
   CurrentValue = false,
   Flag = "ToggleFullbright",
   Callback = function(Value)
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
-- [3] PLAYER MOVEMENT (SỬA LỖI JUMPPOWER)
--------------------------------------------
PlayerTab:CreateSection("Movement Features / Tính Năng Di Chuyển")

PlayerTab:CreateToggle({
   Name = "Infinite Jump / Nhảy Vô Hạn",
   CurrentValue = false,
   Flag = "ToggleInfJump",
   Callback = function(Value) InfiniteJumpEnabled = Value end,
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
   Name = "Jump Power / Sức Nhảy (Đã Sửa)",
   Range = {50, 500},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "SliderJumpPower",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
          local hum = game.Players.LocalPlayer.Character.Humanoid
          hum.UseJumpPower = true -- SỬA LỖI: Bắt buộc bật thuộc tính này để nhận JumpPower diện rộng
          hum.JumpPower = Value
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "Noclip / Xuyên Tường",
   CurrentValue = false,
   Flag = "ToggleNoclip",
   Callback = function(Value)
      NoclipEnabled = Value
      if not Value and game.Players.LocalPlayer.Character then
          for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
              if v:IsA("BasePart") and OriginalCollisions[v] ~= nil then v.CanCollide = OriginalCollisions[v] end
          end
      end
   end,
})

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                if OriginalCollisions[v] == nil then OriginalCollisions[v] = v.CanCollide end
                v.CanCollide = false
            end
        end
    end
end)

--------------------------------------------
-- [4] COMBAT (HITBOX KHUNG DÂY & AIM QUÁI & KILL AURA)
--------------------------------------------
PvpTab:CreateSection("Hitbox & Target Settings")

PvpTab:CreateSlider({
   Name = "Hitbox Size / Kích Thước Hitbox",
   Range = {2, 50},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 2,
   Flag = "SliderHitbox",
   Callback = function(Value) HitboxSize = Value end,
})

PvpTab:CreateDropdown({
   Name = "Aim Position / Vị Trí Găm",
   Options = {"Head / Đầu", "Torso / Người"},
   CurrentOption = {"Head / Đầu"},
   Flag = "DropdownAim",
   Callback = function(Option) AimPartMode = Option[1] end,
})

PvpTab:CreateDropdown({
   Name = "Aim Target / Đối Tượng Khóa",
   Options = {"Player / Người chơi", "NPC / Quái", "All / Cả hai"},
   CurrentOption = {"Player / Người chơi"},
   Flag = "DropdownTarget",
   Callback = function(Option) AimTargetMode = Option[1] end,
})

-- Hàm xử lý và hiển thị Khung dây kích thước thực của Hitbox
local function ProcessHitbox(char)
    local partName = (AimPartMode == "Head / Đầu") and "Head" or "HumanoidRootPart"
    local targetPart = char:FindFirstChild(partName)
    
    if targetPart and targetPart:IsA("BasePart") then
        if not OriginalHitboxData[targetPart] then
            OriginalHitboxData[targetPart] = {
                Size = targetPart.Size, Transparency = targetPart.Transparency, CanCollide = targetPart.CanCollide
            }
        end
        
        local selectionBox = targetPart:FindFirstChild("HitboxSelectionBox")
        
        if HitboxSize <= 2 then
            targetPart.Size = OriginalHitboxData[targetPart].Size
            targetPart.Transparency = OriginalHitboxData[targetPart].Transparency
            targetPart.CanCollide = OriginalHitboxData[targetPart].CanCollide
            if selectionBox then selectionBox:Destroy() end
        else
            targetPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
            targetPart.Transparency = 0.7 -- Hơi mờ để lộ cơ thể gốc
            targetPart.CanCollide = false
            
            -- Tạo Khung kích thước bao quanh
            if not selectionBox then
                selectionBox = Instance.new("SelectionBox")
                selectionBox.Name = "HitboxSelectionBox"
                selectionBox.Color3 = Color3.fromRGB(0, 255, 255) -- Màu khung Neon xanh
                selectionBox.LineThickness = 0.05
                selectionBox.Adornee = targetPart
                selectionBox.Parent = targetPart
            end
        end
    end
end

-- Vòng lặp quét xử lý đa đối tượng (Player + Quái vật)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            -- Quét Người chơi
            if AimTargetMode == "Player / Người chơi" or AimTargetMode == "All / Cả hai" then
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= game.Players.LocalPlayer and p.Character then ProcessHitbox(p.Character) end
                end
            end
            -- Quét Quái vật (Tìm trong Workspace các Model có Humanoid)
            if AimTargetMode == "NPC / Quái" or AimTargetMode == "All / Cả hai" then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and not game.Players:GetPlayerFromCharacter(v) then
                        ProcessHitbox(v)
                    end
                end
            end
        end)
    end
end)

-- CHỨC NĂNG MỚI: KILL AURA (DIỆT TỪ XA TỰ ĐỘNG BẰNG 1 CLICK BẬT)
PvpTab:CreateSection("Kill Aura / Tấn Công Tự Động")
PvpTab:CreateToggle({
   Name = "Kill Aura / Diệt Từ Xa",
   CurrentValue = false,
   Flag = "ToggleKillAura",
   Callback = function(Value) KillAuraEnabled = Value end,
})

PvpTab:CreateSlider({
   Name = "Kill Aura Range (Phạm vi chém)",
   Range = {10, 200},
   Increment = 5,
   Suffix = "Studs",
   CurrentValue = 50,
   Flag = "SliderAuraRange",
   Callback = function(Value) KillAuraRange = Value end,
})

task.spawn(function()
    while task.wait(0.1) do
        if KillAuraEnabled then
            pcall(function()
                local localChar = game.Players.LocalPlayer.Character
                local tool = localChar and localChar:FindFirstChildOfClass("Tool")
                
                if localChar and tool then
                    -- Quét đối thủ xung quanh để kích hoạt đòn đánh của Tool
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v ~= localChar then
                            local targetHrp = v:FindFirstChild("HumanoidRootPart")
                            local myHrp = localChar:FindFirstChild("HumanoidRootPart")
                            
                            if targetHrp and myHrp then
                                local distance = (myHrp.Position - targetHrp.Position).Magnitude
                                if distance <= KillAuraRange and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                                    tool:Activate() -- Tự động vung kiếm/bắn từ xa
                                    firetouchinterest(targetHrp, tool.Handle, 0) -- Giả lập chạm sát thương vũ khí cận chiến
                                    firetouchinterest(targetHrp, tool.Handle, 1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
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
   Flag = "DropdownTele",
   Callback = function(Option) SelectedPlayer = Option[1] end,
})

TeleTab:CreateButton({
   Name = "🔄 Refresh / Làm Mới Danh Sách",
   Callback = function() PlayerDropdown:Refresh(GetPlayerNames(), true) end,
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
   Callback = function(Value) AntiAfkEnabled = Value end,
})

--------------------------------------------
-- [7] SETTINGS & CHỈNH MÀU GIAO DIỆN
--------------------------------------------
SettingTab:CreateSection("Theme Customization / Đổi Màu Giao Diện")

SettingTab:CreateColorPicker({
    Name = "UI Theme Color / Màu Giao Diện",
    Color = Color3.fromRGB(74, 144, 226),
    Flag = "ColorPickerTheme",
    Callback = function(Value)
        -- Cập nhật màu nhấn (Accent Color) trực tiếp cho hệ thống Rayfield
        Rayfield.Flags["ColorPickerTheme"] = Value
    end
})

SettingTab:CreateSection("Script Info / Thông Tin Script")
SettingTab:CreateParagraph({Title = "Lời chúc", Content = "✨ Chúc một ngày tốt lành! ✨"})
SettingTab:CreateParagraph({Title = "Menu", Content = "Huhu hub"})
SettingTab:CreateParagraph({Title = "Author / Tác giả", Content = "Nvang m8"})
SettingTab:CreateParagraph({Title = "TikTok ID", Content = "ditnatbuombn"})
SettingTab:CreateParagraph({Title = "Version", Content = "1.1.0 Ultimate"})
SettingTab:CreateParagraph({Title = "User / Người dùng", Content = game.Players.LocalPlayer.Name})

Rayfield:Notify({
   Title = "Huhu hub",
   Content = "Chúc 1 ngày tốt lành! Script đã cập nhật tính năng thành công.",
   Duration = 6,
})
