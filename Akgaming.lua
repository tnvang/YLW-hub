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
local KillTargetPlayer = "" -- Người chơi bị chọn để giết
local InfiniteJumpEnabled = false
local NoclipEnabled = false
local AntiAfkEnabled = false
local HitboxSize = 2
local AimPartMode = "Head / Đầu"
local AimTargetMode = "Player / Người chơi"
local AimLockEnabled = false -- Nút Aim đã được bổ sung
local EspEnabled = false
local InvisibleEnabled = false

-- Lưu trữ trạng thái gốc hệ thống
local OriginalAmbient = game:GetService("Lighting").Ambient
local OriginalFogEnd = game:GetService("Lighting").FogEnd
local OriginalFogStart = game:GetService("Lighting").FogStart
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
-- [2] VISUALS (HIỂN THỊ & ESP)
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
                if head then
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "HuhuESP"; bg.Adornee = head; bg.Size = UDim2.new(0, 200, 0, 50); bg.AlwaysOnTop = true; bg.Parent = head
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = p.Name; tl.TextColor3 = Color3.fromRGB(255, 0, 0); tl.TextSize = 14; tl.Font = Enum.Font.SourceSansBold; tl.Parent = bg
                    
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
-- [3] PLAYER MOVEMENT (TÀNG HÌNH & DI CHUYỂN)
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
   Name = "Jump Power / Sức Nhảy",
   Range = {50, 500},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "SliderJumpPower",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
          local hum = game.Players.LocalPlayer.Character.Humanoid
          hum.UseJumpPower = true
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

-- TÍNH NĂNG TÀNG HÌNH (INVISIBILITY)
PlayerTab:CreateToggle({
   Name = "Invisible / Tàng Hình",
   CurrentValue = false,
   Flag = "ToggleInvisible",
   Callback = function(Value)
      InvisibleEnabled = Value
      local char = game.Players.LocalPlayer.Character
      if char then
          for _, v in pairs(char:GetDescendants()) do
              if v:IsA("BasePart") or v:IsA("Decal") then
                  if v.Name ~= "HumanoidRootPart" then
                      v.Transparency = Value and 1 or 0
                  end
              end
          end
      end
   end,
})

--------------------------------------------
-- [4] COMBAT (SỬA LỖI HITBOX WELD & ĐÃ THÊM NÚT AIM & ONE CLICK KILL)
--------------------------------------------
PvpTab:CreateSection("Aim Bot & Hitbox Settings")

-- SỬA LỖI: Đã thêm nút bật tắt Aim Bot chính thức
PvpTab:CreateToggle({
   Name = "Enable Aim Lock / Bật Khóa Tâm",
   CurrentValue = false,
   Flag = "ToggleAimLock",
   Callback = function(Value) AimLockEnabled = Value end,
})

PvpTab:CreateDropdown({
   Name = "Aim Target / Đối Tượng Khóa",
   Options = {"Player / Người chơi", "NPC / Quái", "All / Cả hai"},
   CurrentOption = {"Player / Người chơi"},
   Flag = "DropdownTarget",
   Callback = function(Option) AimTargetMode = Option[1] end,
})

PvpTab:CreateDropdown({
   Name = "Aim Position / Vị Trí Găm Tâm",
   Options = {"Head / Đầu", "Torso / Người"},
   CurrentOption = {"Head / Đầu"},
   Flag = "DropdownAim",
   Callback = function(Option) AimPartMode = Option[1] end,
})

PvpTab:CreateSlider({
   Name = "Hitbox Size / Kích Thước Hitbox",
   Range = {2, 50},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 2,
   Flag = "SliderHitbox",
   Callback = function(Value) HitboxSize = Value end
})

-- Hàm tạo Hitbox bằng WeldConstraint chính xác theo yêu cầu của bạn
local function ApplyWeldHitbox(char)
    local partName = (AimPartMode == "Head / Đầu") and "Head" or "HumanoidRootPart"
    local hrp = char:WaitForChild(partName, 5)
    
    if hrp and hrp:IsA("BasePart") then
        local hitbox = char:FindFirstChild("HuhuCustomHitbox")
        local selectionBox = hrp:FindFirstChild("HitboxSelectionBox")
        
        if HitboxSize <= 2 then
            if hitbox then hitbox:Destroy() end
            if selectionBox then selectionBox:Destroy() end
        else
            if not hitbox then
                hitbox = Instance.new("Part")
                hitbox.Name = "HuhuCustomHitbox"
                hitbox.CanCollide = false
                hitbox.Massless = true
                hitbox.Parent = char
                
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = hrp
                weld.Part1 = hitbox
                weld.Parent = hitbox
            end
            
            hitbox.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
            hitbox.Transparency = 0.7 -- Để lộ khối khung neon nhìn cho rõ
            hitbox.CFrame = hrp.CFrame
            hitbox.Color = Color3.fromRGB(0, 255, 255)

            if not selectionBox then
                selectionBox = Instance.new("SelectionBox")
                selectionBox.Name = "HitboxSelectionBox"
                selectionBox.Color3 = Color3.fromRGB(0, 255, 255)
                selectionBox.LineThickness = 0.05
                selectionBox.Adornee = hitbox
                selectionBox.Parent = hrp
            end
        end
    end
end

-- Vòng lặp quản lý Hitbox và Khóa Tâm (Aim Lock) nâng cao
game:GetService("RunService").RenderStepped:Connect(function()
    -- Xử lý Logic Aim Lock nếu được bật
    if AimLockEnabled then
        pcall(function()
            local closestTarget = nil
            local shortestDistance = math.huge
            local localChar = game.Players.LocalPlayer.Character
            local camera = workspace.CurrentCamera

            local function checkTarget(model)
                local partName = (AimPartMode == "Head / Đầu") and "Head" or "HumanoidRootPart"
                local targetPart = model:FindFirstChild(partName)
                local hum = model:FindFirstChildOfClass("Humanoid")
                if targetPart and hum and hum.Health > 0 then
                    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortestDistance then
                            closestTarget = targetPart
                            shortestDistance = dist
                        end
                    end
                end
            end

            if AimTargetMode == "Player / Người chơi" or AimTargetMode == "All / Cả hai" then
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= game.Players.LocalPlayer and p.Character then checkTarget(p.Character) end
                end
            end
            if AimTargetMode == "NPC / Quái" or AimTargetMode == "All / Cả hai" then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and not game.Players:GetPlayerFromCharacter(v) and v ~= localChar then
                        checkTarget(v)
                    end
                end
            end

            if closestTarget then
                camera.CFrame = CFrame.new(camera.CFrame.Position, closestTarget.Position)
            end
        end)
    end
end)

-- Vòng lặp áp dụng Hitbox Weld liên tục
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if AimTargetMode == "Player / Người chơi" or AimTargetMode == "All / Cả hai" then
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= game.Players.LocalPlayer and p.Character then ApplyWeldHitbox(p.Character) end
                end
            end
            if AimTargetMode == "NPC / Quái" or AimTargetMode == "All / Cả hai" then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and not game.Players:GetPlayerFromCharacter(v) then
                        ApplyWeldHitbox(v)
                    end
                end
            end
        end)
    end
end)

-- NÂNG CẤP: DANH SÁCH CHỌN ĐỂ GIẾT 1 NHẤN (ONE CLICK REMOTELY KILL)
PvpTab:CreateSection("One Click Remote Kill / Hạ gục chọn lọc")

local function GetPlayerNames()
    local list = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then table.insert(list, p.Name) end
    end
    return list
end

local KillDropdown = PvpTab:CreateDropdown({
   Name = "Select Victim / Chọn Người Muốn Diệt",
   Options = GetPlayerNames(),
   CurrentOption = {""},
   Flag = "DropdownKillTarget",
   Callback = function(Option) KillTargetPlayer = Option[1] end,
})

PvpTab:CreateButton({
   Name = "🔄 Refresh List / Làm Mới DS Diệt",
   Callback = function() KillDropdown:Refresh(GetPlayerNames(), true) end,
})

PvpTab:CreateButton({
   Name = "☠️ KILL NOW / DIỆT NGAY LẬP TỨC",
   Callback = function()
      if KillTargetPlayer ~= "" and game.Players:FindFirstChild(KillTargetPlayer) then
          local targetChar = game.Players[KillTargetPlayer].Character
          local localChar = game.Players.LocalPlayer.Character
          local tool = localChar and localChar:FindFirstChildOfClass("Tool")
          
          if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and localChar and localChar:FindFirstChild("HumanoidRootPart") and tool then
              local oldCFrame = localChar.HumanoidRootPart.CFrame
              -- Instant Teleport chớp nhoáng ra sau lưng kẻ địch -> vung kiếm -> biến về chỗ cũ trong 0.1s
              localChar.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
              task.wait(0.05)
              tool:Activate()
              firetouchinterest(targetChar.HumanoidRootPart, tool.Handle, 0)
              firetouchinterest(targetChar.HumanoidRootPart, tool.Handle, 1)
              task.wait(0.05)
              localChar.HumanoidRootPart.CFrame = oldCFrame
          else
              Rayfield:Notify({Title = "Lỗi", Content = "Hãy chắc chắn bạn đang cầm Vũ khí (Tool) trên tay!", Duration = 3})
          end
      end
   end,
})

--------------------------------------------
-- [5] TELEPORT (DỊCH CHUYỂN)
--------------------------------------------
TeleTab:CreateSection("Teleport Player / Dịch Chuyển Player")

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
    Callback = function(Value) Rayfield.Flags["ColorPickerTheme"] = Value end
})

SettingTab:CreateSection("Script Info / Thông Tin Script")
SettingTab:CreateParagraph({Title = "Lời chúc", Content = "✨ Chúc một ngày tốt lành! ✨"})
SettingTab:CreateParagraph({Title = "Menu", Content = "Huhu hub"})
SettingTab:CreateParagraph({Title = "Author / Tác giả", Content = "Nvang m8"})
SettingTab:CreateParagraph({Title = "TikTok ID", Content = "ditnatbuombn"})
SettingTab:CreateParagraph({Title = "Version", Content = "1.2.0 Ultra Premium"})
SettingTab:CreateParagraph({Title = "User / Người dùng", Content = game.Players.LocalPlayer.Name})

Rayfield:Notify({
   Title = "Huhu hub",
   Content = "Chúc 1 ngày tốt lành! Script đã cập nhật sửa lỗi thành công.",
   Duration = 6,
})

