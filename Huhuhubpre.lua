local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local CurrentLang = "Tiếng Việt"
local SelectedPlayer = ""
local AimTargetMode = "Người"
local AimPartMode = "Đầu"
local IsInvisible = false
local SavedCFrame = nil
local InfiniteJumpEnabled = false
local NoclipEnabled = false
local AntiAfkEnabled = false
local HitboxSize = 2

local LangTable = {
    ["Tiếng Việt"] = {
        LoadingSub = "bởi Nvang m8 (TikTok: ditnatbuombn)",
        TabVisuals = "👁️ Hiển Thị & ESP",
        TabPlayer = "🏃 Người Chơi",
        TabCombat = "⚔️ PvP & Chiến Đấu",
        TabTeleport = "🌀 Dịch Chuyển",
        TabSystem = "🛠️ Hệ Thống & Lag",
        TabSettings = "⚙️ Cài Đặt & Tác Giả",
        EspToggle = "ESP Khung & Tên",
        Fullbright = "Fullbright (Sáng bản đồ)",
        NoFog = "No Fog (Xóa sương mù)",
        Cam3D = "Camera 3D (Góc nhìn)",
        InfJump = "Nhảy Vô Hạn (Infinite Jump)",
        Walkspeed = "Tốc độ chạy (Walkspeed)",
        JumpPower = "Độ cao nhảy (Jump Power)",
        Noclip = "Noclip (Xuyên tường)",
        Invis = "Tàng Hình (Người khác không thấy)",
        Hitbox = "Tăng Hitbox Thanh Trượt",
        AimMode = "Chế độ Aim (Mục tiêu)",
        AimPos = "Vị trí Aim",
        SelectPlr = "Chọn người chơi",
        RefreshPlr = "🔄 Làm mới danh sách Player",
        TelePlr = "Teleport đến Người chơi",
        KillPlr = "Kill Người chơi",
        Spectate = "Xem góc nhìn (Spectate)",
        FixLag = "Fix Lag & Tối ưu bộ nhớ",
        LowGraph = "Xóa bớt đồ họa (Low Graphics)",
        AntiAfk = "Anti AFK (Chống văng game)",
        SysInfo = "📊 Thông số hệ thống",
        LangSelect = "Ngôn Ngữ / Language",
        HubColor = "Đổi màu HUB",
        Opacity = "Độ trong suốt Menu",
        UserTitle = "👤 Người sử dụng script",
        UserContent = "Tên: %s\nCấp độ: Thành viên Premium",
        AuthorSec = "Thông Tin Tác Giả",
        AuthorTitle = "Tác giả: Nvang m8",
        AuthorContent = "• ID TikTok: ditnatbuombn\n• Ngày tạo: 21 tháng 6 năm 2026\n• Phiên bản: 1.0.0 Premium",
        NotifyTitle = "Thành Công!",
        NotifyContent = "Script của Huhu hub đã kích hoạt thành công!",
        NotifyLang = "Đã chuyển sang Tiếng Việt!"
    },
    ["English"] = {
        LoadingSub = "by Nvang m8 (TikTok: ditnatbuombn)",
        TabVisuals = "👁️ Visuals & ESP",
        TabPlayer = "🏃 Player Movement",
        TabCombat = "⚔️ Combat & PvP",
        TabTeleport = "🌀 Teleport",
        TabSystem = "🛠️ System & Optimization",
        TabSettings = "⚙️ Settings & Credits",
        EspToggle = "Box & Name ESP",
        Fullbright = "Fullbright (Bright Map)",
        NoFog = "No Fog (Remove Fog)",
        Cam3D = "Camera 3D (Custom View)",
        InfJump = "Infinite Jump",
        Walkspeed = "Walkspeed Slider",
        JumpPower = "Jump Power Slider",
        Noclip = "Noclip (Walk Through Walls)",
        Invis = "Invisibility (Server-sided)",
        Hitbox = "Hitbox Extender Slider",
        AimMode = "Aim Target Mode",
        AimPos = "Aim Position",
        SelectPlr = "Select Player",
        RefreshPlr = "🔄 Refresh Player List",
        TelePlr = "Teleport to Player",
        KillPlr = "Kill Player",
        Spectate = "Spectate Player",
        FixLag = "Fix Lag & Optimize Memory",
        LowGraphics = "Low Graphics",
        AntiAfk = "Anti AFK (Anti-Disconnect)",
        SysInfo = "📊 System Status",
        LangSelect = "Language / Ngôn Ngữ",
        HubColor = "Change HUB Color",
        Opacity = "Menu Opacity",
        UserTitle = "👤 Script User",
        UserContent = "Name: %s\nRank: Premium Member",
        AuthorSec = "Author Credits",
        AuthorTitle = "Author: Nvang m8",
        AuthorContent = "• TikTok ID: ditnatbuombn\n• Created: June 21, 2026\n• Version: 1.0.0 Premium",
        NotifyTitle = "Success!",
        NotifyContent = "Huhu hub Script Activated Successfully!",
        NotifyLang = "Language switched to English!"
    }
}

local Window = Rayfield:CreateWindow({
   Name = "Huhu hub | Roblox Script",
   LoadingTitle = "Đang tải Huhu hub...",
   LoadingSubtitle = LangTable[CurrentLang].LoadingSub,
   ConfigurationSaving = { Enabled = true, FolderName = "HuhuHub_Config", FileName = "HubSetting" },
   Discord = { Enabled = false, Invite = "", RememberJoins = true },
   KeySystem = false
})

local VisualTab = Window:CreateTab(LangTable[CurrentLang].TabVisuals, 4483362458)
local PlayerTab = Window:CreateTab(LangTable[CurrentLang].TabPlayer, 4483362458)
local PvpTab = Window:CreateTab(LangTable[CurrentLang].TabCombat, 4483362458)
local TeleTab = Window:CreateTab(LangTable[CurrentLang].TabTeleport, 4483362458)
local SystemTab = Window:CreateTab(LangTable[CurrentLang].TabSystem, 4483362458)
local SettingTab = Window:CreateTab(LangTable[CurrentLang].TabSettings, 4483362458)

local EspEnabled = false
local function UpdateESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local oldEsp = head:FindFirstChild("NvangESP")
                if oldEsp then oldEsp:Destroy() end
                
                if EspEnabled then
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "NvangESP"
                    bg.Adornee = head
                    bg.Size = UDim2.new(0, 200, 0, 50)
                    bg.AlwaysOnTop = true
                    bg.StudsOffset = Vector3.new(0, 2, 0)
                    bg.Parent = head
                    
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.Text = p.Name
                    tl.TextColor3 = Color3.fromRGB(255, 0, 0)
                    tl.TextSize = 14
                    tl.Font = Enum.Font.SourceSansBold
                    tl.Parent = bg
                    
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "NvangBox"
                    box.Size = p.Character:GetExtentsSize()
                    box.Adornee = p.Character
                    box.AlwaysOnTop = true
                    box.ZIndex = 5
                    box.Transparency = 0.6
                    box.Color3 = Color3.fromRGB(255, 0, 0)
                    box.Parent = bg
                end
            end
        end
    end
end

local EspToggle = VisualTab:CreateToggle({
   Name = LangTable[CurrentLang].EspToggle,
   CurrentValue = false,
   Callback = function(Value)
       EspEnabled = Value
       UpdateESP()
   end,
})

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if EspEnabled then UpdateESP() end
    end)
end)

task.spawn(function()
    while task.wait(5) do
        if EspEnabled then UpdateESP() end
    end
end)

local FullbrightToggle = VisualTab:CreateToggle({
   Name = LangTable[CurrentLang].Fullbright,
   CurrentValue = false,
   Callback = function(Value)
       if Value then
           game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
       else
           game:GetService("Lighting").Ambient = Color3.fromRGB(128, 128, 128)
       end
   end,
})

local OriginalFogEnd = game:GetService("Lighting").FogEnd
local OriginalFogStart = game:GetService("Lighting").FogStart
local NoFogToggle = VisualTab:CreateToggle({
   Name = LangTable[CurrentLang].NoFog,
   CurrentValue = false,
   Callback = function(Value)
       if Value then
           game:GetService("Lighting").FogStart = 9e9
           game:GetService("Lighting").FogEnd = 9e9
       else
           game:GetService("Lighting").FogStart = OriginalFogStart
           game:GetService("Lighting").FogEnd = OriginalFogEnd
       end
   end,
})

local Cam3DButton = VisualTab:CreateButton({
   Name = LangTable[CurrentLang].Cam3D,
   Callback = function()
       local cam = workspace.CurrentCamera
       if cam.CameraType == Enum.CameraType.Custom then
           cam.CameraType = Enum.CameraType.Scriptable
           task.spawn(function()
               while cam.CameraType == Enum.CameraType.Scriptable do
                   cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(1), 0)
                   task.wait()
               end
           end)
       else
           cam.CameraType = Enum.CameraType.Custom
       end
   end,
})

local InfJumpToggle = PlayerTab:CreateToggle({
   Name = LangTable[CurrentLang].InfJump,
   CurrentValue = false,
   Callback = function(Value)
       InfiniteJumpEnabled = Value
   end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled and game.Players.LocalPlayer.Character then
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local WalkspeedSlider = PlayerTab:CreateSlider({
   Name = LangTable[CurrentLang].Walkspeed,
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
       if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
           game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

local JumpPowerSlider = PlayerTab:CreateSlider({
   Name = LangTable[CurrentLang].JumpPower,
   Range = {50, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
       if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
           game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
       end
   end,
})

local NoclipToggle = PlayerTab:CreateToggle({
   Name = LangTable[CurrentLang].Noclip,
   CurrentValue = false,
   Callback = function(Value)
       NoclipEnabled = Value
   end,
})

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

local function ToggleInvisibility(Value)
    IsInvisible = Value
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end

    if IsInvisible then
        SavedCFrame = root.CFrame
        task.wait(0.1)
        player.Character = nil
        local clone = Instance.new("Model")
        clone.Name = "FakeCharacter"
        local human = Instance.new("Humanoid", clone)
        player.Character = clone
        player.Character = character
        task.wait(0.1)
        if character:FindFirstChild("LowerTorso") and root:FindFirstChild("RootJoint") then
            root.RootJoint.Parent = nil
        elseif character:FindFirstChild("Torso") and root:FindFirstChild("RootJoint") then
            root.RootJoint.Parent = nil
        end
        root.CFrame = SavedCFrame
    else
        if character and humanoid and humanoid.Health > 0 then
            humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            player.Character = nil
            task.wait(0.2)
            player.Character = character
        end
    end
end

local InvisToggle = PlayerTab:CreateToggle({
   Name = LangTable[CurrentLang].Invis,
   CurrentValue = false,
   Callback = function(Value)
       ToggleInvisibility(Value)
   end,
})

local HitboxSlider = PvpTab:CreateSlider({
   Name = LangTable[CurrentLang].Hitbox,
   Range = {2, 50},
   Increment = 1,
   CurrentValue = 2,
   Callback = function(Value)
       HitboxSize = Value
   end,
})

task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                local targetPart = (AimPartMode == "Đầu") and p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                if targetPart then
                    targetPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    targetPart.Transparency = 0.5
                    targetPart.CanCollide = false
                end
            end
        end
    end
end)

local AimModeDropdown = PvpTab:CreateDropdown({
   Name = LangTable[CurrentLang].AimMode,
   Options = {"Người", "Quái"},
   CurrentOption = {"Người"},
   MultipleOptions = false,
   Callback = function(Option)
       AimTargetMode = Option[1]
   end,
})

local AimPosDropdown = PvpTab:CreateDropdown({
   Name = LangTable[CurrentLang].AimPos,
   Options = {"Đầu", "Người"},
   CurrentOption = {"Đầu"},
   MultipleOptions = false,
   Callback = function(Option)
       AimPartMode = Option[1]
   end,
})

local function GetPlayerNames()
    local list = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

local PlayerDropdown = TeleTab:CreateDropdown({
   Name = LangTable[CurrentLang].SelectPlr,
   Options = GetPlayerNames(),
   CurrentOption = {""},
   MultipleOptions = false,
   Callback = function(Option)
       SelectedPlayer = Option[1]
   end,
})

local RefreshPlrButton = TeleTab:CreateButton({
   Name = LangTable[CurrentLang].RefreshPlr,
   Callback = function()
       PlayerDropdown:Refresh(GetPlayerNames())
   end,
})

local TelePlrButton = TeleTab:CreateButton({
   Name = LangTable[CurrentLang].TelePlr,
   Callback = function()
       if SelectedPlayer ~= "" and game.Players:FindFirstChild(SelectedPlayer) then
           local targetChar = game.Players[SelectedPlayer].Character
           if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame
           end
       end
   end,
})

local KillPlrButton = TeleTab:CreateButton({
   Name = LangTable[CurrentLang].KillPlr,
   Callback = function()
       if SelectedPlayer ~= "" and game.Players:FindFirstChild(SelectedPlayer) then
           local target = game.Players[SelectedPlayer]
           local targetChar = target.Character
           local myChar = game.Players.LocalPlayer.Character
           if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and myChar and myChar:FindFirstChild("HumanoidRootPart") then
               local myRoot = myChar.HumanoidRootPart
               local targetRoot = targetChar.HumanoidRootPart
               local savedCFrame = myRoot.CFrame
               local bv = Instance.new("BodyVelocity")
               bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
               bv.Velocity = Vector3.new(0, 5000, 0)
               bv.Parent = myRoot
               local bg = Instance.new("BodyGyro")
               bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
               bg.CFrame = myRoot.CFrame
               bg.Parent = myRoot
               task.spawn(function()
                   while targetChar and targetChar:FindFirstChild("HumanoidRootPart") and targetChar.Humanoid.Health > 0 do
                       myRoot.CFrame = targetRoot.CFrame
                       myRoot.Velocity = Vector3.new(99999, 99999, 99999)
                       task.wait()
                   end
               end)
               repeat task.wait() until not targetChar or not targetChar:FindFirstChild("Humanoid") or targetChar.Humanoid.Health <= 0
               bv:Destroy()
               bg:Destroy()
               myRoot.Velocity = Vector3.new(0, 0, 0)
               myRoot.CFrame = savedCFrame
           end
       end
   end,
})

local SpectateToggle = TeleTab:CreateToggle({
   Name = LangTable[CurrentLang].Spectate,
   CurrentValue = false,
   Callback = function(Value)
       if Value and SelectedPlayer ~= "" and game.Players:FindFirstChild(SelectedPlayer) and game.Players[SelectedPlayer].Character and game.Players[SelectedPlayer].Character:FindFirstChild("Humanoid") then
           workspace.CurrentCamera.CameraSubject = game.Players[SelectedPlayer].Character.Humanoid
       else
           if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
               workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
           end
       end
   end,
})

local FixLagButton = SystemTab:CreateButton({
   Name = LangTable[CurrentLang].FixLag,
   Callback = function()
       settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
       for _, v in pairs(game:GetDescendants()) do
           if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
               v.Enabled = false
           end
       end
       collectgarbage("collect")
   end,
})

local LowGraphButton = SystemTab:CreateButton({
   Name = LangTable[CurrentLang].LowGraph,
   Callback = function()
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("Part") or v:IsA("MeshPart") then
               v.Material = Enum.Material.SmoothPlastic
           end
       end
   end,
})

local AntiAfkToggle = SystemTab:CreateToggle({
   Name = LangTable[CurrentLang].AntiAfk,
   CurrentValue = false,
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

local InfoParagraph = SystemTab:CreateParagraph({Title = LangTable[CurrentLang].SysInfo, Content = "..."})

task.spawn(function()
    while task.wait(1) do
        local fps = math.floor(workspace:GetRealPhysicsFPS())
        local ping = tonumber(string.format("%.0f", game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()))
        local ram = string.format("%.2f MB", game:GetService("Stats").PerformanceStats.Memory:GetValue())
        InfoParagraph:SetTitle(LangTable[CurrentLang].SysInfo)
        InfoParagraph:SetContent("FPS: " .. fps .. " | Ping: " .. ping .. "ms\nRAM: " .. ram)
    end
end)

local LocalPlayerName = game.Players.LocalPlayer.Name
local UserParagraph = SettingTab:CreateParagraph({Title = LangTable[CurrentLang].UserTitle, Content = string.format(LangTable[CurrentLang].UserContent, LocalPlayerName)})
local AuthorSection = SettingTab:CreateSection(LangTable[CurrentLang].AuthorSec)
local AuthorParagraph = SettingTab:CreateParagraph({Title = LangTable[CurrentLang].AuthorTitle, Content = LangTable[CurrentLang].AuthorContent})

local LangDropdown = SettingTab:CreateDropdown({
   Name = LangTable[CurrentLang].LangSelect,
   Options = {"Tiếng Việt", "English"},
   CurrentOption = {CurrentLang},
   MultipleOptions = false,
   Callback = function(Option)
       CurrentLang = Option[1]
       VisualTab:SetTitle(LangTable[CurrentLang].TabVisuals)
       PlayerTab:SetTitle(LangTable[CurrentLang].TabPlayer)
       PvpTab:SetTitle(LangTable[CurrentLang].TabCombat)
       TeleTab:SetTitle(LangTable[CurrentLang].TabTeleport)
       SystemTab:SetTitle(LangTable[CurrentLang].TabSystem)
       SettingTab:SetTitle(LangTable[CurrentLang].TabSettings)
       EspToggle:SetTitle(LangTable[CurrentLang].EspToggle)
       FullbrightToggle:SetTitle(LangTable[CurrentLang].Fullbright)
       NoFogToggle:SetTitle(LangTable[CurrentLang].NoFog)
       Cam3DButton:SetTitle(LangTable[CurrentLang].Cam3D)
       Inf
