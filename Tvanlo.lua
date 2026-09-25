local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

for _, n in ipairs({"MeowTargetTrackerGui", "TVanDzWatermarkGui", "TVanDzNotifyGui"}) do
    local o = PG:FindFirstChild(n)
    if o then o:Destroy() end
end

local C = {
    Brand = "TVANCTE",
    Title = "TVÀN DZ HUB",
    Sub = "ULTIMATE PRO MAX",
    Ver = "v3.4",
    P = Color3.fromRGB(138, 43, 226),
    S = Color3.fromRGB(75, 0, 130),
    A = Color3.fromRGB(0, 229, 255),
    G = Color3.fromRGB(255, 200, 60),
    OK = Color3.fromRGB(0, 255, 150),
    Bad = Color3.fromRGB(255, 60, 90),
    Warn = Color3.fromRGB(255, 160, 40),
    Bg = Color3.fromRGB(12, 10, 20),
    Panel = Color3.fromRGB(20, 16, 32),
    Elem = Color3.fromRGB(32, 26, 48),
    Txt = Color3.fromRGB(240, 240, 255),
    Dim = Color3.fromRGB(160, 150, 190),
}

local S = {
    Target = nil, Flying = false, Speed = 50, Min = 1, Max = 100000,
    AntiCheck = true, AntiRay = true, AntiInput = true, AntiSum = true,
    FlyConn = nil, CheckConn = nil, RayConn = nil,
    DistConn = nil, AddConn = nil, RemConn = nil, CharConn = nil,
    Buttons = {}, DragSlider = false, IsMin = false,
    RayN = 0, SumN = 0, InpN = 0, Smooth = nil,
}

local function root(ch)
    if not ch then return nil end
    return ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function stroke(p, col, t)
    local s = Instance.new("UIStroke")
    s.Color = col or C.P
    s.Thickness = t or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function grad(p, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rot or 90
    g.Parent = p
    return g
end

local function fmt(n)
    if n >= 1e6 then return string.format("%.1fM", n / 1e6) end
    if n >= 1e3 then return string.format("%.0fK", n / 1e3) end
    return tostring(n)
end

local NGui = Instance.new("ScreenGui")
NGui.Name = "TVanDzNotifyGui"
NGui.ResetOnSpawn = false
NGui.IgnoreGuiInset = true
NGui.DisplayOrder = 999
NGui.Parent = PG

local NC = {info = C.A, success = C.OK, warn = C.Warn, error = C.Bad}
local NI = {info = "ℹ️", success = "✅", warn = "⚠️", error = "❌"}

local function Notify(title, msg, typ, dur)
    typ = typ or "info"
    dur = dur or 3
    local col = NC[typ] or C.A
    local icon = NI[typ] or "ℹ️"

    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 300, 0, 60)
    f.Position = UDim2.new(1, 320, 0, 20)
    f.BackgroundColor3 = C.Panel
    f.BorderSizePixel = 0
    f.Parent = NGui
    corner(f, 10)
    stroke(f, col, 1.5)

    local acc = Instance.new("Frame")
    acc.Size = UDim2.new(0, 4, 1, -12)
    acc.Position = UDim2.new(0, 6, 0, 6)
    acc.BackgroundColor3 = col
    acc.BorderSizePixel = 0
    acc.Parent = f
    corner(acc, 2)

    local il = Instance.new("TextLabel")
    il.Size = UDim2.new(0, 30, 0, 30)
    il.Position = UDim2.new(0, 16, 0, 8)
    il.BackgroundTransparency = 1
    il.Text = icon
    il.TextSize = 18
    il.Parent = f

    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, -60, 0, 20)
    tl.Position = UDim2.new(0, 50, 0, 8)
    tl.BackgroundTransparency = 1
    tl.Text = title
    tl.TextColor3 = col
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 12
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.Parent = f

    local ml = Instance.new("TextLabel")
    ml.Size = UDim2.new(1, -60, 0, 24)
    ml.Position = UDim2.new(0, 50, 0, 28)
    ml.BackgroundTransparency = 1
    ml.Text = msg
    ml.TextColor3 = C.Txt
    ml.Font = Enum.Font.GothamMedium
    ml.TextSize = 11
    ml.TextXAlignment = Enum.TextXAlignment.Left
    ml.TextWrapped = true
    ml.Parent = f

    TweenService:Create(f, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -320, 0, 20)}):Play()

    task.delay(dur, function()
        if f and f.Parent then
            local t = TweenService:Create(f, TweenInfo.new(0.3), {Position = UDim2.new(1, 320, 0, 20)})
            t:Play()
            t.Completed:Connect(function() f:Destroy() end)
        end
    end)
end

local WGui = Instance.new("ScreenGui")
WGui.Name = "TVanDzWatermarkGui"
WGui.ResetOnSpawn = false
WGui.IgnoreGuiInset = true
WGui.DisplayOrder = 998
WGui.Parent = PG

local function watermark(pos, anchor, ax, ay)
    local w = Instance.new("TextLabel")
    w.Size = UDim2.new(0, 200, 0, 30)
    w.Position = pos
    w.AnchorPoint = anchor
    w.BackgroundTransparency = 0.35
    w.BackgroundColor3 = Color3.new(0, 0, 0)
    w.Text = C.Brand
    w.TextColor3 = C.A
    w.Font = Enum.Font.GothamBlack
    w.TextSize = 16
    w.TextXAlignment = ax
    w.TextYAlignment = ay
    w.TextStrokeTransparency = 0.3
    w.TextStrokeColor3 = C.P
    w.Parent = WGui
    corner(w, 6)
    stroke(w, C.P, 1)
    TweenService:Create(w, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {TextColor3 = C.P}):Play()
end

watermark(UDim2.new(0, 10, 0, 10), Vector2.new(0, 0), Enum.TextXAlignment.Left, Enum.TextYAlignment.Top)
watermark(UDim2.new(1, -10, 0, 10), Vector2.new(1, 0), Enum.TextXAlignment.Right, Enum.TextYAlignment.Top)
watermark(UDim2.new(0, 10, 1, -10), Vector2.new(0, 1), Enum.TextXAlignment.Left, Enum.TextYAlignment.Bottom)
watermark(UDim2.new(1, -10, 1, -10), Vector2.new(1, 1), Enum.TextXAlignment.Right, Enum.TextYAlignment.Bottom)

local Gui = Instance.new("ScreenGui")
Gui.Name = "MeowTargetTrackerGui"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 997
Gui.Parent = PG

local W, H = 320, 450
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, W, 0, H)
Main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
Main.BackgroundColor3 = C.Bg
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = true
Main.Parent = Gui
corner(Main, 14)

local mStroke = stroke(Main, C.P, 2)

local bgG = Instance.new("UIGradient")
bgG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.Bg),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 12, 32)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 18, 48)),
})
bgG.Rotation = 135
bgG.Parent = Main

task.spawn(function()
    while Main.Parent do
        TweenService:Create(mStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = C.A}):Play()
        task.wait(2)
        TweenService:Create(mStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = C.P}):Play()
        task.wait(2)
    end
end)

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 42)
Top.BackgroundColor3 = C.S
Top.BorderSizePixel = 0
Top.Parent = Main
corner(Top, 14)

local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 12)
topFix.Position = UDim2.new(0, 0, 1, -12)
topFix.BackgroundColor3 = C.S
topFix.BorderSizePixel = 0
topFix.Parent = Top

local topG = Instance.new("UIGradient")
topG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.P),
    ColorSequenceKeypoint.new(0.5, C.S),
    ColorSequenceKeypoint.new(1, C.P),
})
topG.Parent = Top

local Logo = Instance.new("Frame")
Logo.Size = UDim2.new(0, 26, 0, 26)
Logo.Position = UDim2.new(0, 10, 0.5, -13)
Logo.BackgroundColor3 = C.A
Logo.BorderSizePixel = 0
Logo.Parent = Top
corner(Logo, 8)

local lG = Instance.new("UIGradient")
lG.Color = ColorSequence.new(C.A, C.P)
lG.Rotation = 45
lG.Parent = Logo

local lT = Instance.new("TextLabel")
lT.Size = UDim2.new(1, 0, 1, 0)
lT.BackgroundTransparency = 1
lT.Text = "★"
lT.TextColor3 = C.Bg
lT.Font = Enum.Font.GothamBlack
lT.TextSize = 16
lT.Parent = Logo

local TL = Instance.new("TextLabel")
TL.Size = UDim2.new(1, -120, 0, 17)
TL.Position = UDim2.new(0, 44, 0, 4)
TL.BackgroundTransparency = 1
TL.Text = C.Title
TL.TextColor3 = C.Txt
TL.Font = Enum.Font.GothamBlack
TL.TextSize = 13
TL.TextXAlignment = Enum.TextXAlignment.Left
TL.Parent = Top

local SL = Instance.new("TextLabel")
SL.Size = UDim2.new(1, -120, 0, 13)
SL.Position = UDim2.new(0, 44, 0, 22)
SL.BackgroundTransparency = 1
SL.Text = C.Sub .. " • " .. C.Ver
SL.TextColor3 = C.G
SL.Font = Enum.Font.GothamBold
SL.TextSize = 8
SL.TextXAlignment = Enum.TextXAlignment.Left
SL.Parent = Top

local MinB = Instance.new("TextButton")
MinB.Size = UDim2.new(0, 22, 0, 22)
MinB.Position = UDim2.new(1, -56, 0.5, -11)
MinB.BackgroundColor3 = C.Elem
MinB.TextColor3 = C.Txt
MinB.Text = "−"
MinB.Font = Enum.Font.GothamBold
MinB.TextSize = 13
MinB.AutoButtonColor = false
MinB.Parent = Top
corner(MinB, 6)

local ClsB = Instance.new("TextButton")
ClsB.Size = UDim2.new(0, 22, 0, 22)
ClsB.Position = UDim2.new(1, -28, 0.5, -11)
ClsB.BackgroundColor3 = C.Bad
ClsB.TextColor3 = Color3.new(1, 1, 1)
ClsB.Text = "✕"
ClsB.Font = Enum.Font.GothamBold
ClsB.TextSize = 10
ClsB.AutoButtonColor = false
ClsB.Parent = Top
corner(ClsB, 6)

local Body = Instance.new("Frame")
Body.Size = UDim2.new(1, 0, 1, -42)
Body.Position = UDim2.new(0, 0, 0, 42)
Body.BackgroundTransparency = 1
Body.Parent = Main

local Stat = Instance.new("Frame")
Stat.Size = UDim2.new(1, -16, 0, 22)
Stat.Position = UDim2.new(0, 8, 0, 6)
Stat.BackgroundColor3 = C.Panel
Stat.BorderSizePixel = 0
Stat.Parent = Body
corner(Stat, 6)
stroke(Stat, Color3.fromRGB(50, 40, 70), 1)

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 7, 0, 7)
dot.Position = UDim2.new(0, 9, 0.5, -3.5)
dot.BackgroundColor3 = C.OK
dot.BorderSizePixel = 0
dot.Parent = Stat
corner(dot, 4)

local StatL = Instance.new("TextLabel")
StatL.Size = UDim2.new(1, -30, 1, 0)
StatL.Position = UDim2.new(0, 22, 0, 0)
StatL.BackgroundTransparency = 1
StatL.Text = "Sẵn sàng"
StatL.TextColor3 = C.OK
StatL.Font = Enum.Font.GothamBold
StatL.TextSize = 10
StatL.TextXAlignment = Enum.TextXAlignment.Left
StatL.Parent = Stat

local Tgt = Instance.new("Frame")
Tgt.Size = UDim2.new(1, -16, 0, 28)
Tgt.Position = UDim2.new(0, 8, 0, 32)
Tgt.BackgroundColor3 = C.Panel
Tgt.BorderSizePixel = 0
Tgt.Parent = Body
corner(Tgt, 6)
stroke(Tgt, Color3.fromRGB(50, 40, 70), 1)

local tI = Instance.new("TextLabel")
tI.Size = UDim2.new(0, 22, 1, 0)
tI.Position = UDim2.new(0, 6, 0, 0)
tI.BackgroundTransparency = 1
tI.Text = "🎯"
tI.TextSize = 12
tI.Parent = Tgt

local TgtL = Instance.new("TextLabel")
TgtL.Size = UDim2.new(1, -34, 1, 0)
TgtL.Position = UDim2.new(0, 28, 0, 0)
TgtL.BackgroundTransparency = 1
TgtL.Text = "Chưa chọn mục tiêu"
TgtL.TextColor3 = C.Dim
TgtL.Font = Enum.Font.GothamBold
TgtL.TextSize = 10
TgtL.TextXAlignment = Enum.TextXAlignment.Left
TgtL.Parent = Tgt

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -16, 0, 92)
Scroll.Position = UDim2.new(0, 8, 0, 66)
Scroll.BackgroundColor3 = C.Panel
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = C.P
Scroll.Parent = Body
corner(Scroll, 6)
stroke(Scroll, Color3.fromRGB(50, 40, 70), 1)

local lL = Instance.new("UIListLayout")
lL.Padding = UDim.new(0, 3)
lL.Parent = Scroll

local lP = Instance.new("UIPadding")
lP.PaddingTop = UDim.new(0, 4)
lP.PaddingBottom = UDim.new(0, 4)
lP.PaddingLeft = UDim.new(0, 4)
lP.PaddingRight = UDim.new(0, 4)
lP.Parent = Scroll

local BtnRow = Instance.new("Frame")
BtnRow.Size = UDim2.new(1, -16, 0, 32)
BtnRow.Position = UDim2.new(0, 8, 0, 166)
BtnRow.BackgroundTransparency = 1
BtnRow.Parent = Body

local TeleB = Instance.new("TextButton")
TeleB.Size = UDim2.new(0.5, -4, 1, 0)
TeleB.BackgroundColor3 = C.P
TeleB.TextColor3 = Color3.new(1, 1, 1)
TeleB.Text = "⚡ TELEPORT"
TeleB.Font = Enum.Font.GothamBlack
TeleB.TextSize = 11
TeleB.AutoButtonColor = false
TeleB.Parent = BtnRow
corner(TeleB, 8)
grad(TeleB, C.P, C.S, 90)

local FlyB = Instance.new("TextButton")
FlyB.Size = UDim2.new(0.5, -4, 1, 0)
FlyB.Position = UDim2.new(0.5, 4, 0, 0)
FlyB.BackgroundColor3 = C.Elem
FlyB.TextColor3 = C.Txt
FlyB.Text = "🚀 BAY: OFF"
FlyB.Font = Enum.Font.GothamBlack
FlyB.TextSize = 11
FlyB.AutoButtonColor = false
FlyB.Parent = BtnRow
corner(FlyB, 8)
stroke(FlyB, C.A, 1.5)

local Grid = Instance.new("Frame")
Grid.Size = UDim2.new(1, -16, 0, 66)
Grid.Position = UDim2.new(0, 8, 0, 204)
Grid.BackgroundTransparency = 1
Grid.Parent = Body

local gL = Instance.new("UIGridLayout")
gL.CellSize = UDim2.new(0.5, -3, 0, 30)
gL.CellPadding = UDim2.new(0, 6, 0, 6)
gL.Parent = Grid

local function toggle(parent, label, def, cb)
    local r = Instance.new("Frame")
    r.BackgroundColor3 = C.Panel
    r.BorderSizePixel = 0
    r.Parent = parent
    corner(r, 6)
    stroke(r, Color3.fromRGB(50, 40, 70), 1)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -44, 1, 0)
    l.Position = UDim2.new(0, 6, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = C.Txt
    l.Font = Enum.Font.GothamBold
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = r

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 30, 0, 17)
    bg.Position = UDim2.new(1, -36, 0.5, -8.5)
    bg.BackgroundColor3 = def and C.OK or Color3.fromRGB(60, 50, 70)
    bg.BorderSizePixel = 0
    bg.Parent = r
    corner(bg, 9)

    local k = Instance.new("Frame")
    k.Size = UDim2.new(0, 13, 0, 13)
    k.Position = def and UDim2.new(1, -14, 0.5, -6.5) or UDim2.new(0, 1, 0.5, -6.5)
    k.BackgroundColor3 = Color3.new(1, 1, 1)
    k.BorderSizePixel = 0
    k.Parent = bg
    corner(k, 7)

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 1, 0)
    b.BackgroundTransparency = 1
    b.Text = ""
    b.Parent = bg

    local st = def
    b.MouseButton1Click:Connect(function()
        st = not st
        if st then
            TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = C.OK}):Play()
            TweenService:Create(k, TweenInfo.new(0.2), {Position = UDim2.new(1, -14, 0.5, -6.5)}):Play()
        else
            TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 50, 70)}):Play()
            TweenService:Create(k, TweenInfo.new(0.2), {Position = UDim2.new(0, 1, 0.5, -6.5)}):Play()
        end
        cb(st)
    end)
end

toggle(Grid, "🛡️ Anti-Check", true, function(v)
    S.AntiCheck = v
    Notify("Anti-Check", v and "Đã BẬT" or "Đã TẮT", v and "success" or "warn", 2)
end)
toggle(Grid, "🎯 Anti-Ray", true, function(v)
    S.AntiRay = v
    Notify("Anti-Raycast", v and "Đã BẬT" or "Đã TẮT", v and "success" or "warn", 2)
end)
toggle(Grid, "⌨️ Anti-Input", true, function(v)
    S.AntiInput = v
    Notify("Anti-Input", v and "Đã BẬT" or "Đã TẮT", v and "success" or "warn", 2)
end)
toggle(Grid, "🔐 Anti-Sum", true, function(v)
    S.AntiSum = v
    Notify("Anti-Checksum", v and "Đã BẬT" or "Đã TẮT", v and "success" or "warn", 2)
end)

local StatLbl = Instance.new("TextLabel")
StatLbl.Size = UDim2.new(1, -16, 0, 11)
StatLbl.Position = UDim2.new(0, 8, 0, 274)
StatLbl.BackgroundTransparency = 1
StatLbl.Text = "Ray: 0 • Checksum: 0 • Input: 0"
StatLbl.TextColor3 = C.Dim
StatLbl.Font = Enum.Font.GothamMedium
StatLbl.TextSize = 8
StatLbl.TextXAlignment = Enum.TextXAlignment.Left
StatLbl.Parent = Body

local SpdL = Instance.new("TextLabel")
SpdL.Size = UDim2.new(0.55, -8, 0, 17)
SpdL.Position = UDim2.new(0, 8, 0, 289)
SpdL.BackgroundTransparency = 1
SpdL.Text = "⚙️ Tốc độ: 50"
SpdL.TextColor3 = C.Txt
SpdL.Font = Enum.Font.GothamBold
SpdL.TextSize = 10
SpdL.TextXAlignment = Enum.TextXAlignment.Left
SpdL.Parent = Body

local PreRow = Instance.new("Frame")
PreRow.Size = UDim2.new(0.45, -8, 0, 17)
PreRow.Position = UDim2.new(0.55, 0, 0, 289)
PreRow.BackgroundTransparency = 1
PreRow.Parent = Body

local pL = Instance.new("UIListLayout")
pL.FillDirection = Enum.FillDirection.Horizontal
pL.Padding = UDim.new(0, 3)
pL.Parent = PreRow

local SpdIn = Instance.new("TextBox")
SpdIn.Size = UDim2.new(1, -16, 0, 22)
SpdIn.Position = UDim2.new(0, 8, 0, 310)
SpdIn.BackgroundColor3 = C.Elem
SpdIn.TextColor3 = C.A
SpdIn.Text = "50"
SpdIn.Font = Enum.Font.GothamBlack
SpdIn.TextSize = 11
SpdIn.ClearTextOnFocus = false
SpdIn.PlaceholderText = "1 - 100000"
SpdIn.PlaceholderColor3 = C.Dim
SpdIn.Parent = Body
corner(SpdIn, 6)
stroke(SpdIn, C.P, 1)

local SlBg = Instance.new("Frame")
SlBg.Size = UDim2.new(1, -16, 0, 10)
SlBg.Position = UDim2.new(0, 8, 0, 338)
SlBg.BackgroundColor3 = C.Elem
SlBg.BorderSizePixel = 0
SlBg.Parent = Body
corner(SlBg, 5)

local SlFill = Instance.new("Frame")
SlFill.Size = UDim2.new(0, 0, 1, 0)
SlFill.BackgroundColor3 = C.A
SlFill.BorderSizePixel = 0
SlFill.Parent = SlBg
corner(SlFill, 5)
grad(SlFill, C.P, C.A, 0)

local SlK = Instance.new("Frame")
SlK.Size = UDim2.new(0, 16, 0, 16)
SlK.Position = UDim2.new(0, -8, 0.5, -8)
SlK.BackgroundColor3 = Color3.new(1, 1, 1)
SlK.BorderSizePixel = 0
SlK.ZIndex = 2
SlK.Parent = SlBg
corner(SlK, 8)
stroke(SlK, C.A, 2)

local MinL = Instance.new("TextLabel")
MinL.Size = UDim2.new(0.5, -8, 0, 10)
MinL.Position = UDim2.new(0, 8, 0, 352)
MinL.BackgroundTransparency = 1
MinL.Text = "1"
MinL.TextColor3 = C.Dim
MinL.Font = Enum.Font.GothamMedium
MinL.TextSize = 8
MinL.TextXAlignment = Enum.TextXAlignment.Left
MinL.Parent = Body

local MaxL = Instance.new("TextLabel")
MaxL.Size = UDim2.new(0.5, -8, 0, 10)
MaxL.Position = UDim2.new(0.5, 0, 0, 352)
MaxL.BackgroundTransparency = 1
MaxL.Text = "100000"
MaxL.TextColor3 = C.Dim
MaxL.Font = Enum.Font.GothamMedium
MaxL.TextSize = 8
MaxL.TextXAlignment = Enum.TextXAlignment.Right
MaxL.Parent = Body

local FootL = Instance.new("TextLabel")
FootL.Size = UDim2.new(1, -16, 0, 16)
FootL.Position = UDim2.new(0, 8, 1, -20)
FootL.BackgroundTransparency = 1
FootL.Text = "💎 Made by TVANCTE • Ultimate Pro Max"
FootL.TextColor3 = C.G
FootL.Font = Enum.Font.GothamBold
FootL.TextSize = 8
FootL.Parent = Body

local function setSpeed(val)
    local n = tonumber(val)
    if not n or n ~= n or n == math.huge or n == -math.huge then n = S.Speed end
    n = math.clamp(math.floor(n), S.Min, S.Max)
    S.Speed = n
    SpdIn.Text = tostring(n)
    SpdL.Text = "⚙️ Tốc độ: " .. fmt(n)
    local a = (n - S.Min) / (S.Max - S.Min)
    local e = math.log(a * 99 + 1) / math.log(100)
    TweenService:Create(SlFill, TweenInfo.new(0.15), {Size = UDim2.new(e, 0, 1, 0)}):Play()
    TweenService:Create(SlK, TweenInfo.new(0.15), {Position = UDim2.new(e, -8, 0.5, -8)}):Play()
end

for _, p in ipairs({{"100", 100}, {"1K", 1000}, {"10K", 10000}, {"100K", 100000}}) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 30, 0, 17)
    b.BackgroundColor3 = C.Elem
    b.TextColor3 = C.A
    b.Text = p[1]
    b.Font = Enum.Font.GothamBold
    b.TextSize = 8
    b.AutoButtonColor = false
    b.Parent = PreRow
    corner(b, 4)
    stroke(b, C.P, 1)
    b.MouseButton1Click:Connect(function()
        setSpeed(p[2])
        Notify("Preset", "Đã đặt: " .. fmt(p[2]), "success", 2)
    end)
end

setSpeed(50)

SpdIn.FocusLost:Connect(function()
    local before = S.Speed
    setSpeed(SpdIn.Text)
    if before ~= S.Speed then
        Notify("Tốc độ", "Đã cập nhật: " .. fmt(S.Speed), "success", 2)
    end
end)

local function sliderInput(input)
    local ax = SlBg.AbsolutePosition.X
    local aw = SlBg.AbsoluteSize.X
    if aw <= 0 then return end
    local rx = math.clamp(input.Position.X - ax, 0, aw)
    local a = rx / aw
    local e = (math.exp(a * math.log(100)) - 1) / 99
    setSpeed(math.floor(S.Min + e * (S.Max - S.Min)))
end

SlBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        S.DragSlider = true
        sliderInput(input)
    end
end)

UIS.InputChanged:Connect(function(input)
    if S.DragSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        sliderInput(input)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if S.DragSlider then
            S.DragSlider = false
            Notify("Tốc độ", "Đã đặt: " .. fmt(S.Speed), "info", 1.5)
        end
    end
end)

local function selectTarget(plr)
    S.Target = plr
    for p, b in pairs(S.Buttons) do
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = p == plr and C.P or C.Elem}):Play()
    end
    Notify("Mục tiêu", "Đã chọn: " .. plr.DisplayName, "success", 2)
end

local function refreshList()
    for _, c in ipairs(Scroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    S.Buttons = {}
    local plrs = Players:GetPlayers()
    table.sort(plrs, function(a, b) return a.DisplayName:lower() < b.DisplayName:lower() end)
    for _, plr in ipairs(plrs) do
        if plr ~= LP then
            local b = Instance.new("TextButton")
            b.Name = plr.Name
            b.Size = UDim2.new(1, 0, 0, 24)
            b.BackgroundColor3 = S.Target == plr and C.P or C.Elem
            b.TextColor3 = C.Txt
            b.Font = Enum.Font.GothamBold
            b.TextSize = 10
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Text = "  👤 " .. plr.DisplayName .. " (@" .. plr.Name .. ")"
            b.AutoButtonColor = false
            b.Parent = Scroll
            corner(b, 5)
            S.Buttons[plr] = b
            b.MouseEnter:Connect(function()
                if S.Target ~= plr then
                    TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 35, 65)}):Play()
                end
            end)
            b.MouseLeave:Connect(function()
                if S.Target ~= plr then
                    TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = C.Elem}):Play()
                end
            end)
            b.MouseButton1Click:Connect(function() selectTarget(plr) end)
        end
    end
end

refreshList()
S.AddConn = Players.PlayerAdded:Connect(refreshList)
S.RemConn = Players.PlayerRemoving:Connect(function(plr)
    if S.Target == plr then
        S.Target = nil
        TgtL.Text = "Chưa chọn mục tiêu"
        TgtL.TextColor3 = C.Dim
        if S.Flying then stopFly(true) end
    end
    refreshList()
end)

local function getTargetRoot()
    if not S.Target then return nil end
    if not S.Target.Parent then return nil end
    local tc = S.Target.Character
    if not tc then return nil end
    return root(tc)
end

local function teleport()
    if not S.Target then
        Notify("Lỗi", "Chưa chọn mục tiêu!", "error", 2)
        return
    end
    local mc = LP.Character
    local mr = root(mc)
    local tr = getTargetRoot()
    if mr and tr then
        local h = mc:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = true end
        mr.AssemblyLinearVelocity = Vector3.zero
        mr.AssemblyAngularVelocity = Vector3.zero
        mr.CFrame = tr.CFrame * CFrame.new(0, 0, 3) + Vector3.new(0, 2, 0)
        Notify("Teleport", "Đã tới " .. S.Target.DisplayName, "success", 2)
        StatL.Text = "⚡ Đã teleport tới " .. S.Target.DisplayName
        StatL.TextColor3 = C.OK
        task.delay(1.5, function()
            if not S.Flying and h then h.PlatformStand = false end
        end)
    else
        Notify("Lỗi", "Không tìm thấy vị trí!", "error", 2)
    end
end

TeleB.MouseButton1Click:Connect(teleport)
TeleB.MouseEnter:Connect(function()
    TweenService:Create(TeleB, TweenInfo.new(0.2), {BackgroundColor3 = C.A}):Play()
end)
TeleB.MouseLeave:Connect(function()
    TweenService:Create(TeleB, TweenInfo.new(0.2), {BackgroundColor3 = C.P}):Play()
end)

function stopFly(silent)
    S.Flying = false
    FlyB.Text = "🚀 BAY: OFF"
    FlyB.BackgroundColor3 = C.Elem
    FlyB.TextColor3 = C.Txt
    StatL.Text = "Sẵn sàng"
    StatL.TextColor3 = C.OK
    dot.BackgroundColor3 = C.OK
    if S.FlyConn then S.FlyConn:Disconnect() S.FlyConn = nil end
    S.Smooth = nil
    local mc = LP.Character
    if mc then
        local mr = root(mc)
        local h = mc:FindFirstChildOfClass("Humanoid")
        if mr then
            mr.AssemblyLinearVelocity = Vector3.zero
            mr.AssemblyAngularVelocity = Vector3.zero
        end
        if h then h.PlatformStand = false end
    end
    if not silent then Notify("Fly", "Đã TẮT chế độ bay", "warn", 2) end
end

function startFly()
    if not S.Target then
        Notify("Lỗi", "Chưa chọn mục tiêu!", "error", 2)
        return
    end
    if S.Flying then stopFly() return end
    S.Flying = true
    FlyB.Text = "🚀 BAY: ON"
    FlyB.BackgroundColor3 = C.Bad
    FlyB.TextColor3 = Color3.new(1, 1, 1)
    dot.BackgroundColor3 = C.Bad
    local mc = LP.Character
    local mr = root(mc)
    if mr then S.Smooth = mr.Position end
    Notify("Fly", "Đã BẬT • Speed: " .. fmt(S.Speed), "success", 2)

    S.FlyConn = RunService.Heartbeat:Connect(function(dt)
        if not S.Flying then return end
        local c = LP.Character
        if not c then return end
        local r = root(c)
        local h = c:FindFirstChildOfClass("Humanoid")
        if not r or not h or h.Health <= 0 then return end
        if not S.Target or not S.Target.Parent then stopFly(true) return end

        local tr = getTargetRoot()
        if not tr then
            StatL.Text = "Đang chờ mục tiêu respawn..."
            StatL.TextColor3 = C.Dim
            r.AssemblyLinearVelocity = Vector3.zero
            r.AssemblyAngularVelocity = Vector3.zero
            return
        end

        StatL.Text = "Bay tới " .. S.Target.DisplayName .. " • " .. fmt(S.Speed)
        StatL.TextColor3 = C.A
        h.PlatformStand = true

        local tp = tr.Position + Vector3.new(0, 3, 0)

        if not S.Smooth then S.Smooth = r.Position end

        local d = tp - S.Smooth
        local dist = d.Magnitude

        if dist > 0.5 then
            local step = math.min(dist, S.Speed * dt)
            S.Smooth = S.Smooth + (d / dist) * step
        end

        r.AssemblyLinearVelocity = Vector3.zero
        r.AssemblyAngularVelocity = Vector3.zero
        r.CFrame = CFrame.new(S.Smooth, tp)
    end)
end

FlyB.MouseButton1Click:Connect(startFly)
FlyB.MouseEnter:Connect(function()
    if not S.Flying then
        TweenService:Create(FlyB, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 35, 65)}):Play()
    end
end)
FlyB.MouseLeave:Connect(function()
    if not S.Flying then
        TweenService:Create(FlyB, TweenInfo.new(0.2), {BackgroundColor3 = C.Elem}):Play()
    end
end)

do
    if getrawmetatable and setreadonly then
        pcall(function()
            local mt = getrawmetatable(game)
            local old = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                if S.AntiInput or S.AntiSum then
                    local m = getnamecallmethod()
                    if m == "Kick" or m == "kick" then
                        if S.AntiInput then S.InpN = S.InpN + 1 end
                        if S.AntiSum then S.SumN = S.SumN + 1 end
                        return nil
                    end
                end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end)
    end

    if hookfunction then
        pcall(function()
            local ok, old = pcall(function() return LP.Kick end)
            if ok and old then
                LP.Kick = newcclosure(function(self, ...)
                    if S.AntiSum then
                        S.SumN = S.SumN + 1
                        return nil
                    end
                    return old(self, ...)
                end)
            end
        end)
    end
end

S.CheckConn = RunService.Heartbeat:Connect(function()
    if not S.AntiCheck then return end
    local c = LP.Character
    if not c then return end
    local r = root(c)
    if not r then return end
    if not S.Flying then
        local v = r.AssemblyLinearVelocity
        local sp = v.Magnitude
        if sp > 150 then r.AssemblyLinearVelocity = v.Unit * 100 end
        local av = r.AssemblyAngularVelocity
        if av.Magnitude > 50 then r.AssemblyAngularVelocity = av.Unit * 20 end
    end
end)

do
    if hookfunction and Workspace.Raycast then
        pcall(function()
            local old = Workspace.Raycast
            hookfunction(old, newcclosure(function(self, origin, direction, params)
                if S.AntiRay then
                    local c = LP.Character
                    if c then
                        local r = root(c)
                        if r and origin and (origin - r.Position).Magnitude < 20 then
                            S.RayN = S.RayN + 1
                            return nil
                        end
                    end
                end
                return old(self, origin, direction, params)
            end))
        end)
    end
end

S.RayConn = RunService.Heartbeat:Connect(function()
    StatLbl.Text = string.format("Ray: %d • Checksum: %d • Input: %d", S.RayN, S.SumN, S.InpN)
end)

S.DistConn = RunService.RenderStepped:Connect(function()
    if S.Target and S.Target.Parent then
        local mr = root(LP.Character)
        local tr = getTargetRoot()
        if mr and tr then
            local d = math.floor((mr.Position - tr.Position).Magnitude)
            TgtL.Text = S.Target.DisplayName .. "  •  " .. d .. "m"
            TgtL.TextColor3 = C.A
        else
            TgtL.Text = S.Target.DisplayName .. "  •  N/A"
            TgtL.TextColor3 = C.Dim
        end
    elseif S.Target and not S.Target.Parent then
        S.Target = nil
        TgtL.Text = "Chưa chọn mục tiêu"
        TgtL.TextColor3 = C.Dim
        if S.Flying then stopFly(true) end
    end
end)

S.CharConn = LP.CharacterAdded:Connect(function()
    if S.Flying then stopFly(true) end
end)

MinB.MouseButton1Click:Connect(function()
    S.IsMin = not S.IsMin
    if S.IsMin then
        Body.Visible = false
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, W, 0, 42)}):Play()
        MinB.Text = "+"
    else
        Body.Visible = true
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, W, 0, H)}):Play()
        MinB.Text = "−"
    end
end)

do
    local drag, dIn, dStart, sPos
    Top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true
            dStart = i.Position
            sPos = Main.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    Top.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            dIn = i
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == dIn and drag then
            local d = i.Position - dStart
            Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
        end
    end)
end

ClsB.MouseEnter:Connect(function()
    TweenService:Create(ClsB, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 100, 120)}):Play()
end)
ClsB.MouseLeave:Connect(function()
    TweenService:Create(ClsB, TweenInfo.new(0.15), {BackgroundColor3 = C.Bad}):Play()
end)
MinB.MouseEnter:Connect(function()
    TweenService:Create(MinB, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 50, 80)}):Play()
end)
MinB.MouseLeave:Connect(function()
    TweenService:Create(MinB, TweenInfo.new(0.15), {BackgroundColor3 = C.Elem}):Play()
end)

ClsB.MouseButton1Click:Connect(function()
    Notify("Đóng", "Đã đóng " .. C.Title, "warn", 1.5)
    pcall(function()
        for _, c in ipairs({S.FlyConn, S.CheckConn, S.RayConn, S.DistConn, S.AddConn, S.RemConn, S.CharConn}) do
            if c then c:Disconnect() end
        end
        stopFly(true)
    end)
    task.wait(0.3)
    Gui:Destroy()
    WGui:Destroy()
    NGui:Destroy()
end)

task.wait(0.5)
Notify("Chào mừng", C.Brand .. " • " .. C.Sub, "success", 4)
task.wait(0.5)
Notify("Hệ thống", "4 lớp bảo vệ đã BẬT", "info", 4)
task.wait(0.5)
Notify("Tốc độ", "Hỗ trợ 1 - 100000", "success", 4)

StatL.Text = "✅ Hệ thống sẵn sàng"
StatL.TextColor3 = C.OK
