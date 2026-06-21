local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source.lua')))()

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

local LangTable = {
    ["Tiếng Việt"] = {
        TabVisuals = "👁️ Hiển Thị & ESP", TabPlayer = "🏃 Người Chơi", TabCombat = "⚔️ PvP & Chiến Đấu",
        TabTeleport = "🌀 Dịch Chuyển", TabSystem = "🛠️ Hệ Thống & Lag", TabSettings = "⚙️ Cài Đặt & Tác Giả",
        EspNameToggle = "ESP Tên Người Chơi", EspBoxToggle = "ESP Khung (Box ESP)", Fullbright = "Fullbright (Sáng bản đồ)", NoFog = "No Fog (Xóa sương mù)",
        InfJump = "Nhảy Vô Hạn (Infinite Jump)", Walkspeed = "Tốc độ chạy (Walkspeed)", JumpPower = "Độ cao nhảy (Jump Power)",
        Noclip = "Noclip (Xuyên tường)", Invisible = "👻 Tàng Hình Phân Thân (Real)", KillTarget = "⚔️ Diệt Người Chơi Đã Chọn", Hitbox = "Tăng Kích Thước Hitbox", AimPos = "Vị trí găm Hitbox",
        SelectPlr = "Chọn người chơi để xử lý", RefreshPlr = "🔄 Làm mới danh sách Player", TelePlr = "Teleport đến Người chơi", ViewPlr = "👁️ Xem góc nhìn người này (Spectate)",
        FixLag = "Fix Lag & Tối ưu bộ nhớ", LowGraph = "Xóa bớt đồ họa (Low Graphics)", AntiAfk = "Anti AFK (Chống văng game)",
        LangSelect = "Ngôn Ngữ / Language", Author = "Tác giả: Nvang m8", User = "Người dùng: "
    },
    ["English"] = {
        TabVisuals = "👁️ Visuals & ESP", TabPlayer = "🏃 Player Movement", TabCombat = "⚔️ Combat & PvP",
        TabTeleport = "🌀 Teleport", TabSystem = "🛠️ System & Optimization", TabSettings = "⚙️ Settings & Credits",
        EspNameToggle = "Name ESP", EspBoxToggle = "Box ESP", Fullbright = "Fullbright (Bright Map)", NoFog = "No Fog (Remove Fog)",
        InfJump = "Infinite Jump", Walkspeed = "Walkspeed Slider", JumpPower = "Jump Power Slider",
        Noclip = "Noclip (Walk Through Walls)", Invisible = "👻 Real Ghost Invisible", KillTarget = "⚔️ Kill Selected Target", Hitbox = "Hitbox Extender", AimPos = "Aim Position",
        SelectPlr = "Select Target Player", RefreshPlr = "🔄 Refresh Player List", TelePlr = "Teleport to Player", ViewPlr = "👁️ Spectate Player",
        FixLag = "Fix Lag & Optimize Memory", LowGraph = "Low Graphics", AntiAfk = "Anti AFK (Anti-Disconnect)",
        LangSelect = "Language / Ngôn Ngữ", Author = "Author: Nvang m8", User = "User: "
    }
}

local Window = OrionLib:MakeWindow({
    Name = "Huhu hub | Premium Edition",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "HuhuConfig",
    IntroEnabled = true,
    IntroText = "Chào mừng bạn đến với Huhu hub!",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998",
    Color = Color3.fromRGB(255, 120, 0),
    LoadingEnabled = true,
    LoadingTitle = "Đang tải dữ liệu...",
    LoadingSubtitle = "by Nvang m8"
})

local VisualTab = Window:MakeTab({Name = LangTable[CurrentLang].TabVisuals, Icon = "rbxassetid://4483345998", PremiumOnly = false})
local PlayerTab = Window:MakeTab({Name = LangTable[CurrentLang].TabPlayer, Icon = "rbxassetid://4483345998", PremiumOnly = false})
local PvpTab = Window:MakeTab({Name = LangTable[CurrentLang].TabCombat, Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TeleTab = Window:MakeTab({Name = LangTable[CurrentLang].TabTeleport, Icon = "rbxassetid://4483345998", PremiumOnly = false})
local SystemTab = Window:MakeTab({Name = LangTable[CurrentLang].TabSystem, Icon = "rbxassetid://4483345998", PremiumOnly = false})
local SettingTab = Window:MakeTab({Name = LangTable[CurrentLang].TabSettings, Icon = "rbxassetid://4483345998", PremiumOnly = false})

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

VisualTab:AddToggle({Name = LangTable[CurrentLang].EspNameToggle, Default = false, Callback = function(Value)
    NameEspEnabled = Value
    UpdateNameESP()
end})

VisualTab:AddToggle({Name = LangTable[CurrentLang].EspBoxToggle, Default = false, Callback = function(Value)
    BoxEspEnabled = Value
    UpdateNameESP()
end})

task.spawn(function()
    while task.wait(5) do if NameEspEnabled or BoxEspEnabled then pcall(UpdateNameESP) end end
end)

game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        if NameEspEnabled or BoxEspEnabled then pcall(UpdateNameESP) end
    end)
end)

VisualTab:AddToggle({Name = LangTable[CurrentLang].Fullbright, Default = false, Callback = function(Value)
    game:GetService("Lighting").Ambient = Value and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(128, 128, 128)
end})

local OriginalFogEnd = game:GetService("Lighting").FogEnd
local OriginalFogStart = game:GetService("Lighting").FogStart
VisualTab:AddToggle({Name = LangTable[CurrentLang].NoFog, Default = false, Callback = function(Value)
    if Value then
        game:GetService("Lighting").FogStart = 9e9; game:GetService("Lighting").FogEnd = 9e9
    else
        game:GetService("Lighting").FogStart = OriginalFogStart; game:GetService("Lighting").FogEnd = OriginalFogEnd
    end
end})

PlayerTab:AddToggle({Name = LangTable[CurrentLang].InfJump, Default = false, Callback = function(Value)
    InfiniteJumpEnabled = Value
end})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled and game.Players.LocalPlayer.Character then
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

PlayerTab:AddSlider({Name = LangTable[CurrentLang].Walkspeed, Min = 16, Max = 500, Default = 16, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Speed", Callback = function(Value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
end})

PlayerTab:AddSlider({Name = LangTable[CurrentLang].JumpPower, Min = 50, Max = 500, Default = 50, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Power", Callback = function(Value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
end})

PlayerTab:AddToggle({Name = LangTable[CurrentLang].Noclip, Default = false, Callback = function(Value)
    NoclipEnabled = Value
end})

RunService.Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

PlayerTab:AddToggle({Name = LangTable[CurrentLang].Invisible, Default = false, Callback = function(Value)
    InvisibleEnabled = Value
    local player = game.Players.LocalPlayer
    local storage = game:GetService("Lighting")
    
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
                
                OrionLib:MakeNotification({Name = "Huhu hub", Content = "Đã kích hoạt tàng hình phân thân thành công!", Time = 3})
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
            OrionLib:MakeNotification({Name = "Huhu hub", Content = "Đang hồi sinh nhân vật để hủy tàng hình...", Time = 3})
        end)
    end
end)

PvpTab:AddToggle({Name = LangTable[CurrentLang].KillTarget, Default = false, Callback = function(Value)
    KillTargetEnabled = Value
end})

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

PvpTab:AddSlider({Name = LangTable[CurrentLang].Hitbox, Min = 2, Max = 50, Default = 2, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Size", Callback = function(Value)
    HitboxSize = Value
end})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character then
                    local targetPart = (AimPartMode == "Đầu" or AimPartMode == "Head") and p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
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

PvpTab:AddDropdown({Name = LangTable[CurrentLang].AimPos, Options = {"Đầu", "Người"}, Default = "Đầu", Callback = function(Option)
    AimPartMode = Option
end})

local function GetPlayerNames()
    local list = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then table.insert(list, p.Name) end
    end
    return list
end

local PlayerDropdown = TeleTab:AddDropdown({Name = LangTable[CurrentLang].SelectPlr, Options = GetPlayerNames(), Default = "", Callback = function(Option)
    SelectedPlayer = Option
end})

TeleTab:AddButton({Name = LangTable[CurrentLang].RefreshPlr, Callback = function()
    PlayerDropdown:Refresh(GetPlayerNames(), true)
end})

TeleTab:AddButton({Name = LangTable[CurrentLang].TelePlr, Callback = function()
    if SelectedPlayer ~= "" and game.Players:FindFirstChild(SelectedPlayer) then
        local targetChar = game.Players[SelectedPlayer].Character
        if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame
        end
    end
end})

TeleTab:AddToggle({Name = LangTable[CurrentLang].ViewPlr, Default = false, Callback = function(Value)
    SpectateEnabled = Value
    pcall(function()
        local camera = workspace.CurrentCamera
        if SpectateEnabled and SelectedPlayer ~= "" and game.Players:FindFirstChild(SelectedPlayer) then
            local targetPlr = game.Players[SelectedPlayer]
            if targetPlr.Character and targetPlr.Character:FindFirstChildOfClass("Humanoid") then
                camera.CameraSubject = targetPlr.Character:FindFirstChildOfClass("Humanoid")
            end
        else
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                camera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
        end
    end)
end})

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

SystemTab:AddButton({Name = LangTable[CurrentLang].FixLag, Callback = function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v.Enabled = false end
    end
    collectgarbage("collect")
end})

SystemTab:AddButton({Name = LangTable[CurrentLang].LowGraph, Callback = function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic end
    end
end})

SystemTab:AddToggle({Name = LangTable[CurrentLang].AntiAfk, Default = false, Callback = function(Value)
    AntiAfkEnabled = Value
end})

game.Players.LocalPlayer.Idled:Connect(function()
    if AntiAfkEnabled then
        local vu = game:GetService("VirtualUser")
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

SettingTab:AddLabel("Menu: Huhu hub")
SettingTab:AddLabel("Tác giả: Nvang m8")
SettingTab:AddLabel("TikTok ID: ditnatbuombn")
SettingTab:AddLabel("Version: 1.0.0 Premium")
SettingTab:AddLabel("Người dùng: " .. game.Players.LocalPlayer.Name)

SettingTab:AddDropdown({Name = LangTable[CurrentLang].LangSelect, Options = {"Tiếng Việt", "English"}, Default = "Tiếng Việt", Callback = function(Option)
    CurrentLang = Option
    OrionLib:MakeNotification({Name = "Huhu hub", Content = LangTable[CurrentLang].LangSelect .. " -> " .. Option, Time = 3})
end})

OrionLib:Init()

local HuhuScreenGui = Instance.new("ScreenGui")
HuhuScreenGui.Name = "HuhuToggleGui"
HuhuScreenGui.ResetOnSpawn = false
pcall(function() HuhuScreenGui.Parent = CoreGui end)
if not HuhuScreenGui.Parent then HuhuScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

local HuhuButton = Instance.new("ImageButton")
HuhuButton.Name = "ToggleButton"
HuhuButton.Size = UDim2.new(0, 60, 0, 60)
HuhuButton.Position = UDim2.new(0.05, 0, 0.2, 0)
HuhuButton.Image = "rbxassetid://1000001809"
HuhuButton.BackgroundTransparency = 0.3
HuhuButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HuhuButton.Visible = false
HuhuButton.Parent = HuhuScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = HuhuButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 120, 0)
UIStroke.Thickness = 2
UIStroke.Parent = HuhuButton

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

task.spawn(function()
    while true do
        local orionGui = CoreGui:FindFirstChild("Orion") or game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Orion")
        if orionGui and orionGui:FindFirstChild("Main") then
            local mainFrame = orionGui.Main
            
            for _, v in pairs(mainFrame
