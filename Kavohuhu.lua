local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("Huhu hub | Roblox Script", "DarkTheme")

local CurrentLang = "Tiếng Việt"
local SelectedPlayer = ""
local InfiniteJumpEnabled = false
local NoclipEnabled = false
local AntiAfkEnabled = false
local HitboxSize = 2
local AimPartMode = "Đầu"

local LangTable = {
    ["Tiếng Việt"] = {
        TabVisuals = "👁️ Hiển Thị & ESP", TabPlayer = "🏃 Người Chơi", TabCombat = "⚔️ PvP & Chiến Đấu",
        TabTeleport = "🌀 Dịch Chuyển", TabSystem = "🛠️ Hệ Thống & Lag", TabSettings = "⚙️ Cài Đặt & Tác Giả",
        SecVisuals = "Tính Năng Hiển Thị", SecPlayer = "Tính Năng Di Chuyển", SecCombat = "Tính Năng Chiến Đấu",
        SecTeleport = "Dịch Chuyển Player", SecSystem = "Tối Ưu & Hệ Thống", SecSettings = "Thông Tin Script",
        EspToggle = "ESP Tên Người Chơi", Fullbright = "Fullbright (Sáng bản đồ)", NoFog = "No Fog (Xóa sương mù)",
        InfJump = "Nhảy Vô Hạn (Infinite Jump)", Walkspeed = "Tốc độ chạy (Walkspeed)", JumpPower = "Độ cao nhảy (Jump Power)",
        Noclip = "Noclip (Xuyên tường)", Hitbox = "Tăng Kích Thước Hitbox", AimPos = "Vị trí găm Hitbox",
        SelectPlr = "Chọn người chơi", RefreshPlr = "🔄 Làm mới danh sách Player", TelePlr = "Teleport đến Người chơi",
        FixLag = "Fix Lag & Tối ưu bộ nhớ", LowGraph = "Xóa bớt đồ họa (Low Graphics)", AntiAfk = "Anti AFK (Chống văng game)",
        LangSelect = "Ngôn Ngữ / Language", Author = "Tác giả: Nvang m8", User = "Người dùng: ", Success = "Script đã kích hoạt thành công!"
    },
    ["English"] = {
        TabVisuals = "👁️ Visuals & ESP", TabPlayer = "🏃 Player Movement", TabCombat = "⚔️ Combat & PvP",
        TabTeleport = "🌀 Teleport", TabSystem = "🛠️ System & Optimization", TabSettings = "⚙️ Settings & Credits",
        SecVisuals = "Visual Features", SecPlayer = "Movement Features", SecCombat = "Combat Features",
        SecTeleport = "Teleport Player", SecSystem = "Optimization & System", SecSettings = "Script Info",
        EspToggle = "Box & Name ESP", Fullbright = "Fullbright (Bright Map)", NoFog = "No Fog (Remove Fog)",
        InfJump = "Infinite Jump", Walkspeed = "Walkspeed Slider", JumpPower = "Jump Power Slider",
        Noclip = "Noclip (Walk Through Walls)", Hitbox = "Hitbox Extender", AimPos = "Aim Position",
        SelectPlr = "Select Player", RefreshPlr = "🔄 Refresh Player List", TelePlr = "Teleport to Player",
        FixLag = "Fix Lag & Optimize Memory", LowGraph = "Low Graphics", AntiAfk = "Anti AFK (Anti-Disconnect)",
        LangSelect = "Language / Ngôn Ngữ", Author = "Author: Nvang m8", User = "User: ", Success = "Script activated successfully!"
    }
}

local VisualTab = Window:NewTab(LangTable[CurrentLang].TabVisuals)
local PlayerTab = Window:NewTab(LangTable[CurrentLang].TabPlayer)
local PvpTab = Window:NewTab(LangTable[CurrentLang].TabCombat)
local TeleTab = Window:NewTab(LangTable[CurrentLang].TabTeleport)
local SystemTab = Window:NewTab(LangTable[CurrentLang].TabSystem)
local SettingTab = Window:NewTab(LangTable[CurrentLang].TabSettings)

local VisualSection = VisualTab:NewSection(LangTable[CurrentLang].SecVisuals)
local PlayerSection = PlayerTab:NewSection(LangTable[CurrentLang].SecPlayer)
local PvpSection = PvpTab:NewSection(LangTable[CurrentLang].SecCombat)
local TeleSection = TeleTab:NewSection(LangTable[CurrentLang].SecTeleport)
local SystemSection = SystemTab:NewSection(LangTable[CurrentLang].SecSystem)
local SettingSection = SettingTab:NewSection(LangTable[CurrentLang].SecSettings)

local EspEnabled = false
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

local EspElement = VisualSection:NewToggle(LangTable[CurrentLang].EspToggle, "", function(Value)
    EspEnabled = Value
    UpdateESP()
end)

task.spawn(function()
    while task.wait(5) do if EspEnabled then pcall(UpdateESP) end end
end)

local FullbrightElement = VisualSection:NewToggle(LangTable[CurrentLang].Fullbright, "", function(Value)
    game:GetService("Lighting").Ambient = Value and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(128, 128, 128)
end)

local OriginalFogEnd = game:GetService("Lighting").FogEnd
local OriginalFogStart = game:GetService("Lighting").FogStart
local NoFogElement = VisualSection:NewToggle(LangTable[CurrentLang].NoFog, "", function(Value)
    if Value then
        game:GetService("Lighting").FogStart = 9e9; game:GetService("Lighting").FogEnd = 9e9
    else
        game:GetService("Lighting").FogStart = OriginalFogStart; game:GetService("Lighting").FogEnd = OriginalFogEnd
    end
end)

local InfJumpElement = PlayerSection:NewToggle(LangTable[CurrentLang].InfJump, "", function(Value)
    InfiniteJumpEnabled = Value
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled and game.Players.LocalPlayer.Character then
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local WalkspeedElement = PlayerSection:NewSlider(LangTable[CurrentLang].Walkspeed, "", 500, 16, function(Value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
end)

local JumpPowerElement = PlayerSection:NewSlider(LangTable[CurrentLang].JumpPower, "", 500, 50, function(Value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
end)

local NoclipElement = PlayerSection:NewToggle(LangTable[CurrentLang].Noclip, "", function(Value)
    NoclipEnabled = Value
end)

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

local HitboxElement = PvpSection:NewSlider(LangTable[CurrentLang].Hitbox, "", 50, 2, function(Value)
    HitboxSize = Value
end)

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

local AimPosElement = PvpSection:NewDropdown(LangTable[CurrentLang].AimPos, "", {"Đầu", "Người"}, function(Option)
    AimPartMode = Option
end)

local function GetPlayerNames()
    local list = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then table.insert(list, p.Name) end
    end
    return list
end

local PlayerDropdown = TeleSection:NewDropdown(LangTable[CurrentLang].SelectPlr, "", GetPlayerNames(), function(Option)
    SelectedPlayer = Option
end)

local RefreshPlrElement = TeleSection:NewButton(LangTable[CurrentLang].RefreshPlr, "", function()
    PlayerDropdown:Refresh(GetPlayerNames())
end)

local TelePlrElement = TeleSection:NewButton(LangTable[CurrentLang].TelePlr, "", function()
    if SelectedPlayer ~= "" and game.Players:FindFirstChild(SelectedPlayer) then
        local targetChar = game.Players[SelectedPlayer].Character
        if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame
        end
    end
end)

local FixLagElement = SystemSection:NewButton(LangTable[CurrentLang].FixLag, "", function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v.Enabled = false end
    end
    collectgarbage("collect")
end)

local LowGraphElement = SystemSection:NewButton(LangTable[CurrentLang].LowGraph, "", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic end
    end
end)

local AntiAfkElement = SystemSection:NewToggle(LangTable[CurrentLang].AntiAfk, "", function(Value)
    AntiAfkEnabled = Value
end)

game.Players.LocalPlayer.Idled:Connect(function()
    if AntiAfkEnabled then
        local vu = game:GetService("VirtualUser")
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

local MenuLabel = SettingSection:NewLabel("Menu: Huhu hub")
local AuthorLabel = SettingSection:NewLabel(LangTable[CurrentLang].Author)
local TikTokLabel = SettingSection:NewLabel("TikTok ID: ditnatbuombn")
local VersionLabel = SettingSection:NewLabel("Version: 1.0.0 Premium")
local UserLabel = SettingSection:NewLabel(LangTable[CurrentLang].User .. game.Players.LocalPlayer.Name)

SettingSection:NewDropdown(LangTable[CurrentLang].LangSelect, "Change language", {"Tiếng Việt", "English"}, function(Option)
    CurrentLang = Option
    pcall(function()
        EspElement.Text = LangTable[CurrentLang].EspToggle
        FullbrightElement.Text = LangTable[CurrentLang].Fullbright
        NoFogElement.Text = LangTable[CurrentLang].NoFog
        InfJumpElement.Text = LangTable[CurrentLang].InfJump
        WalkspeedElement.Text = LangTable[CurrentLang].Walkspeed
        JumpPowerElement.Text = LangTable[CurrentLang].JumpPower
        NoclipElement.Text = LangTable[CurrentLang].Noclip
        HitboxElement.Text = LangTable[CurrentLang].Hitbox
        AimPosElement.Text = LangTable[CurrentLang].AimPos
        RefreshPlrElement.Text = LangTable[CurrentLang].RefreshPlr
        TelePlrElement.Text = LangTable[CurrentLang].TelePlr
        FixLagElement.Text = LangTable[CurrentLang].FixLag
        LowGraphElement.Text = LangTable[CurrentLang].LowGraph
        AntiAfkElement.Text = LangTable[CurrentLang].AntiAfk
        AuthorLabel.Text = LangTable[CurrentLang].Author
        UserLabel.Text = LangTable[CurrentLang].User .. game.Players.LocalPlayer.Name
    end)
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Huhu hub",
    Text = LangTable[CurrentLang].Success,
    Duration = 5
})

