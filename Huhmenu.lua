local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local CurrentLang = "Tiếng Việt"
local SelectedPlayer = ""
local InfiniteJumpEnabled = false
local NoclipEnabled = false
local InvisibleEnabled = false
local AntiAfkEnabled = false
local KillTargetEnabled = false
local HitboxSize = 2
local AimPartMode = "Đầu"
local SpectateEnabled = false
local BoxEspEnabled = false
local NameEspEnabled = false

local FakeCharacter = nil

local Window = Rayfield:CreateWindow({
   Name = "Huhu hub | Premium Edition",
   LoadingTitle = "Đang tải dữ liệu...",
   LoadingSubtitle = "by Nvang m8",
   Theme = "Default", -- Các theme có sẵn: Default, Green, Ocean, Light, Amber, DeepBlue

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      Folder = "HuhuConfigRayfield",
      FileName = "HuhuHubConfig"
   },

   KeySystem = false -- Tắt hệ thống key để vào thẳng menu
})

-- Tạo các Tab
local VisualTab = Window:CreateTab("👁️ Hiển Thị & ESP", 4483345998)
local PlayerTab = Window:CreateTab("🏃 Người Chơi", 4483345998)
local PvpTab = Window:CreateTab("⚔️ PvP & Chiến Đấu", 4483345998)
local TeleTab = Window:CreateTab("🌀 Dịch Chuyển", 4483345998)
local SystemTab = Window:CreateTab("🛠️ Hệ Thống & Lag", 4483345998)
local SettingTab = Window:CreateTab("⚙️ Cài Đặt & Tác Giả", 4483345998)

---------------------------------------------------------
-- [TAB VISUALS & ESP]
---------------------------------------------------------
local function CreateAdornmentBox(character)
    local box = character:FindFirstChild("HuhuBoxESP")
    if box then box:Destroy() end
    
    if BoxEspEnabled then
        local adornment = Instance.new("SelectionBox")
        adornment.Name = "HuhuBoxESP"
        adornment.Color3 = Color3.fromRGB(255, 0, 0)
        adornment.LineThickness = 0.05
        adornment.Adornee = character
        adornment.AlwaysOnTop = true
        adornment.Parent = character
    end
end

local function UpdateNameESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local oldEsp = head:FindFirstChild("HuhuESP")
                if oldEsp then oldEsp:Destroy() end
                if NameEspEnabled then
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "HuhuESP"; bg.Adornee = head; bg.Size = UDim2.new(0, 200, 0, 50); bg.AlwaysOnTop = true; bg.Parent = head
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = p.Name; tl.TextColor3 = Color3.fromRGB(255, 0, 0); tl.TextSize = 14; tl.Font = Enum.Font.SourceSansBold; tl.Parent = bg
                end
            end
            CreateAdornmentBox(p.Character)
        end
    end
end

VisualTab:CreateToggle({
   Name = "ESP Tên Người Chơi",
   CurrentValue = false,
   Flag = "NameESP_Flag",
   Callback = function(Value)
      NameEspEnabled = Value
      UpdateNameESP()
   end,
})

VisualTab:CreateToggle({
   Name = "ESP Khung (Box ESP)",
   CurrentValue = false,
   Flag = "BoxESP_Flag",
   Callback = function(Value)
      BoxEspEnabled = Value
      UpdateNameESP()
   end,
})

task.spawn(function()
    while task.wait(5) do if NameEspEnabled or BoxEspEnabled then pcall(UpdateNameESP) end end
end)

game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        if NameEspEnabled or BoxEspEnabled then pcall(UpdateNameESP) end
    end)
end)

VisualTab:CreateToggle({
   Name = "Fullbright (Sáng bản đồ)",
   CurrentValue = false,
   Flag = "Fullbright_Flag",
   Callback = function(Value)
      game:GetService("Lighting").Ambient = Value and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(128, 128, 128)
   end,
})

local OriginalFogEnd = game:GetService("Lighting").FogEnd
local OriginalFogStart = game:GetService("Lighting").FogStart
VisualTab:CreateToggle({
   Name = "No Fog (Xóa sương mù)",
   CurrentValue = false,
   Flag = "NoFog_Flag",
   Callback = function(Value)
      if Value then
          game:GetService("Lighting").FogStart = 9e9; game:GetService("Lighting").FogEnd = 9e9
      else
          game:GetService("Lighting").FogStart = OriginalFogStart; game:GetService("Lighting").FogEnd = OriginalFogEnd
      end
   end,
})

---------------------------------------------------------
-- [TAB PLAYER MOVEMENT]
---------------------------------------------------------
PlayerTab:CreateToggle({
   Name = "Nhảy Vô Hạn (Infinite Jump)",
   CurrentValue = false,
   Flag = "InfJump_Flag",
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
   Name = "Tốc độ chạy (Walkspeed)",
   Min = 16,
   Max = 500,
   CurrentValue = 16,
   Flag = "Walkspeed_Flag",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
          game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "Độ cao nhảy (Jump Power)",
   Min = 50,
   Max = 500,
   CurrentValue = 50,
   Flag = "JumpPower_Flag",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
          game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "Noclip (Xuyên tường)",
   CurrentValue = false,
   Flag = "Noclip_Flag",
   Callback = function(Value)
      NoclipEnabled = Value
   end,
})

RunService.Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- CHỨC NĂNG TÀNG HÌNH PHÂN THÂN CHUẨN REAL (SERVER-SIDE GHOST)
PlayerTab:CreateToggle({
   Name = "👻 Tàng Hình Phân Thân (Real)",
   CurrentValue = false,
   Flag = "Invisible_Flag",
   Callback = function(Value)
      InvisibleEnabled = Value
      local player = game.Players.LocalPlayer
      
      if InvisibleEnabled then
          pcall(function()
              local char = player.Character
              if char and char:FindFirstChild("HumanoidRootPart") then
                  char.Archivable = true
                  
                  FakeCharacter = char:Clone()
                  FakeCharacter.Name = "HuhuGhost_Clone"
                  FakeCharacter.Parent = workspace
                  
                  for _, v in pairs(FakeCharacter:GetDescendants()) do
                      if v:IsA("Script") or v:IsA("LocalScript") then
                          v:Destroy()
                      end
                  end
                  
                  if FakeCharacter:FindFirstChild("HumanoidRootPart") then
                      FakeCharacter.HumanoidRootPart.Anchored = true
                  end
                  
                  local rootJoint = char.HumanoidRootPart:FindFirstChild("RootJoint") or char:FindFirstChild("LowerTorso") and char.LowerTorso:FindFirstChild("Root")
                  if rootJoint then
                      rootJoint:Destroy()
                  elseif char:FindFirstChild("Torso") and char.Torso:FindFirstChild("Neck") then
                      char.Torso.Neck:Destroy()
                  end
                  
                  Rayfield:Notify({Title = "Huhu hub", Content = "Đã kích hoạt tàng hình phân thân thành công!", Duration = 3, Image = 4483345998})
              end
          end)
      else
          pcall(function()
              if FakeCharacter then
                  FakeCharacter:Destroy()
                  FakeCharacter = nil
              end
              if player.Character then
                  player.Character:BreakJoints()
              end
              Rayfield:Notify({Title = "Huhu hub", Content = "Đang hồi sinh nhân vật để hủy tàng hình...", Duration = 3, Image = 4483345998})
          end)
      end
   end,
})

---------------------------------------------------------
-- [TAB COMBAT & PvP]
---------------------------------------------------------
PvpTab:CreateToggle({
   Name = "⚔️ Diệt Người Chơi Đã Chọn",
   CurrentValue = false,
   Flag = "KillTarget_Flag",
   Callback = function(Value)
      KillTargetEnabled = Value
   end,
})

task.spawn(function()
    while task.wait(0.1) do
        if KillTargetEnabled and SelectedPlayer ~= "" then
            pcall(function()
                local localPlayer = game.Players.LocalPlayer
                local targetPlayer = game.Players:FindFirstChild(SelectedPlayer)
                
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (localPlayer.Character.HumanoidRootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= 25 then
                        local tool = localPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("Activate") then
                            tool:Activate()
                        elseif tool then
                            tool:HitStart()
                        end
                    end
                end
            end)
        end
    end
end)

PvpTab:CreateSlider({
   Name = "Tăng Kích Thước Hitbox",
   Min = 2,
   Max = 50,
   CurrentValue = 2,
   Flag = "Hitbox_Flag",
   Callback = function(Value)
      HitboxSize = Value
   end,
})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character then
                    local targetPart = AimPartMode == "Đầu" and p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        targetPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                        targetPart.Transparency = 0.5
                        targetPart.CanCollide = false
                    end
                end
            end
        end)
    end
end)

PvpTab:CreateDropdown({
   Name = "Vị trí găm Hitbox",
   Options = {"Đầu", "Người"},
   CurrentOption = {"Đầu"},
   MultipleOptions = false,
   Flag = "AimPos_Flag",
   Callback = function(Option)
      AimPartMode = Option[1]
   end,
})

---------------------------------------------------------
-- [TAB TELEPORT & TARGET]
---------------------------------------------------------
local function GetPlayerNames()
    local list = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then table.insert(list, p.Name) end
    end
    return list
end

local PlayerDropdown = TeleTab:CreateDropdown({
   Name = "Chọn người chơi để xử lý",
   Options = GetPlayerNames(),
   CurrentOption = {""},
   MultipleOptions = false,
   Flag = "SelectPlr_Flag",
   Callback = function(Option)
      SelectedPlayer = Option[1]
   end,
})

TeleTab:CreateButton({
   Name = "🔄 Làm mới danh sách Player",
   Callback = function()
      PlayerDropdown:Refresh(GetPlayerNames(), true)
   end,
})

TeleTab:CreateButton({
   Name = "Teleport đến Người chơi",
   Callback = function()
      if SelectedPlayer ~= "" and game.Players:FindFirstChild(SelectedPlayer) then
          local targetChar = game.Players[SelectedPlayer].Character
          if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
              game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame
          end
      end
   end,
})

TeleTab:CreateToggle({
   Name = "👁️ Xem góc nhìn người này (Spectate)",
   CurrentValue = false,
   Flag = "Spectate_Flag",
   Callback = function(Value)
      SpectateEnabled = Value
   end,
})

task.spawn(function()
    RunService.RenderStepped:Connect(function()
        if SpectateEnabled and SelectedPlayer ~= "" then
            pcall(function()
                local camera = workspace.CurrentCamera
                local targetPlr = game.Players:FindFirstChild(SelectedPlayer)
                if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChildOfClass("Humanoid") then
                    if camera.CameraSubject ~= targetPlr.Character:FindFirstChildOfClass("Humanoid") then
                        camera.CameraSubject = targetPlr.Character:FindFirstChildOfClass("Humanoid")
                    end
                end
            end)
        elseif not SpectateEnabled then
            pcall(function()
                local camera = workspace.CurrentCamera
                local localHum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if localHum and camera.CameraSubject ~= localHum then
                    camera.CameraSubject = localHum
                end
            end)
        end
    end)
end)

---------------------------------------------------------
-- [TAB SYSTEM OPTIMIZATION]
---------------------------------------------------------
SystemTab:CreateButton({
   Name = "Fix Lag & Tối ưu bộ nhớ",
   Callback = function()
      settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
      for _, v in pairs(game:GetDescendants()) do
          if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v.Enabled = false end
      end
      collectgarbage("collect")
      Rayfield:Notify({Title = "System", Content = "Đã tối ưu RAM & Đồ họa!", Duration = 2})
   end,
})

SystemTab:CreateButton({
   Name = "Xóa bớt đồ họa (Low Graphics)",
   Callback = function()
      for _, v in pairs(workspace:GetDescendants()) do
          if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic end
      end
   end,
})

SystemTab:CreateToggle({
   Name = "Anti AFK (Chống văng game)",
   CurrentValue = false,
   Flag = "AntiAfk_Flag",
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

---------------------------------------------------------
-- [TAB SETTINGS & CREDITS]
---------------------------------------------------------
SettingTab:CreateParagraph({Title = "Menu: Huhu hub", Content = "Version: 1.0.0 Premium (Rayfield UI)"})
SettingTab:CreateParagraph({Title = "Tác giả", Content = "Nvang m8"})
SettingTab:CreateParagraph({Title = "TikTok ID", Content = "ditnatbuombn"})
SettingTab:CreateParagraph({Title = "Người dùng hiện tại", Content = game.Players.LocalPlayer.Name})

SettingTab:CreateButton({
   Name = "Hủy toàn bộ Menu (Destroy UI)",
   Callback = function()
      Rayfield:Destroy()
   end,
})

---------------------------------------------------------
-- [CƠ CHẾ NÚT TRÒN CHÚ KHỈ BẬT/TẮT TRÊN MOBILE]
---------------------------------------------------------
local HuhuScreenGui = Instance.new("ScreenGui")
HuhuScreenGui.Name = "HuhuToggleGui"
HuhuScreenGui.ResetOnSpawn = false
pcall(function() HuhuScreenGui.Parent = CoreGui end)
if not HuhuScreenGui.Parent then HuhuScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

local HuhuButton = Instance.new("ImageButton")
HuhuButton.Name = "ToggleButton"
HuhuButton.Size = UDim2.new(0, 60, 0, 60)
HuhuButton.Position = UDim2.new(0.05, 0, 0.2, 0)
HuhuButton.Image = "rbxassetid://1000001809" -- ID ảnh chú khỉ chuẩn của bạn
HuhuButton.BackgroundTransparency = 0.3
HuhuButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HuhuButton.Visible = false -- Chỉ hiện khi menu đóng lại
HuhuButton.Parent = HuhuScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = HuhuButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 120, 0)
UIStroke.Thickness = 2
UIStroke.Parent = HuhuButton

-- Code kéo thả nút tròn mượt mà trên Mobile
local function MakeMobileDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(gui, TweenInfo.new(0.1), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
end
MakeMobileDraggable(HuhuButton)

-- Loop bắt sự kiện khi bấm nút đóng Rayfield để kích hoạt nút chú khỉ
task.spawn(function()
    while true do
        local rayfieldGui = CoreGui:FindFirstChild("Rayfield") or game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Rayfield")
        if rayfieldGui and rayfieldGui:FindFirstChild("Main") then
            local mainFrame = rayfieldGui.Main
            
            -- Tìm nút Close mặc định của Rayfield Topbar
            local topbar = mainFrame:FindFirstChild("Topbar")
            if topbar then
                local closeBtn = topbar:FindFirstChild("Close") or topbar:FindFirstChildOfClass("ImageButton")
                if closeBtn then
                    closeBtn.MouseButton1Click:Connect(function()
                        HuhuButton.Visible = true
                    end)
                    break
                end
            end
        end
        task.wait(0.5)
    end
end)

-- Click nút chú khỉ để mở lại Menu Rayfield
HuhuButton.MouseButton1Click:Connect(function()
    local rayfieldGui = CoreGui:FindFirstChild("Rayfield") or game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Rayfield")
    if rayfieldGui and rayfieldGui:FindFirstChild("Main") then
        rayfieldGui.Main.Visible = true
        HuhuButton.Visible = false
    end
end)

