-- [[ VGFLAG HACK/UTILITY MENU ]]
-- GitHub Repository Component

-- Khởi tạo Namespace tránh trùng lặp biến toàn cục
local vgflag = {
    FixLagEnabled = false,
    EspEnabled = false,
    EspColor = Color3.fromRGB(0, 255, 0),
    RefreshRate = 1,
    OriginalSettings = {
        GlobalShadows = game:GetService("Lighting").GlobalShadows,
        FogStart = game:GetService("Lighting").FogStart,
        FogEnd = game:GetService("Lighting").FogEnd
    }
}

-- [[ TRÌNH TẠO GIAO DIỆN (GUI) ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleMin = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local FixLagBtn = Instance.new("TextButton")
local EspBtn = Instance.new("TextButton")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "vgflag_gui"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

-- Tính năng kéo thả Menu (Draggable)
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseBehavior or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Giao diện Tiêu đề (Đặt tên theo dự án của bạn)
Title.Parent = MainFrame
Title.Size = UDim2.new(0, 160, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "  vgflag Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

-- Nút thu gọn menu
ToggleMin.Parent = MainFrame
ToggleMin.Position = UDim2.new(0, 160, 0, 0)
ToggleMin.Size = UDim2.new(0, 40, 0, 30)
ToggleMin.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleMin.Text = "-"
ToggleMin.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMin.TextSize = 18

local minimized = false
ToggleMin.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ContentFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 200, 0, 30)
        ToggleMin.Text = "+"
    else
        ContentFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 200, 0, 150)
        ToggleMin.Text = "-"
    end
end)

ContentFrame.Parent = MainFrame
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.Size = UDim2.new(0, 200, 0, 120)
ContentFrame.BackgroundTransparency = 1

UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local function styleButton(btn, text)
    btn.Size = UDim2.new(0, 190, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    local padding = Instance.new("UIPadding")
    padding.Left = UDim.new(0, 5)
    padding.Parent = ContentFrame
end

FixLagBtn.Parent = ContentFrame
styleButton(FixLagBtn, "FIX LAG")

EspBtn.Parent = ContentFrame
styleButton(EspBtn, "ESP MONSTERS")


-- [[ HÀM CHỨC NĂNG CỦA VGFLAG ]]

-- 1. Hàm xử lý giảm lag & xóa sương mù
function vgflag.ApplyFixLag()
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false
    lighting.FogStart = 9e9
    lighting.FogEnd = 9e9
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
    end
end

-- 2. Hàm tạo ESP Quái
function vgflag.CreateESP(folderName)
    local targetFolder = workspace:FindFirstChild(folderName)
    if not targetFolder then return end

    for _, monster in pairs(targetFolder:GetChildren()) do
        if monster:FindFirstChild("HumanoidRootPart") and not monster.HumanoidRootPart:FindFirstChild("MonsterESP") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "MonsterESP"
            highlight.FillColor = vgflag.EspColor
            highlight.FillTransparency = 0.6
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Adornee = monster
            highlight.Parent = monster.HumanoidRootPart
            
            local humanoid = monster:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Died:Connect(function()
                    highlight:Destroy()
                end)
            end
        end
    end
end

-- 3. Hàm gỡ bỏ ESP
function vgflag.RemoveESP()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "MonsterESP" and v:IsA("Highlight") then
            v:Destroy()
        end
    end
end


-- [[ KHỞI CHẠY VÒNG LẶP HỆ THỐNG ]]

-- Vòng lặp Fix Lag
task.spawn(function()
    while true do
        if vgflag.FixLagEnabled then
            vgflag.ApplyFixLag()
        end
        task.wait(5)
    end
end)

-- Vòng lặp ESP Quái
task.spawn(function()
    while true do
        if vgflag.EspEnabled then
            -- Điền các folder quái phổ biến ở đây
            vgflag.CreateESP("Monsters")
            vgflag.CreateESP("Enemies")
            vgflag.CreateESP("Mobs")
        else
            vgflag.RemoveESP()
        end
        task.wait(vgflag.RefreshRate)
    end
end)


-- [[ LẮNG NGHE SỰ KIỆN NÚT BẤM ]]

FixLagBtn.MouseButton1Click:Connect(function()
    vgflag.FixLagEnabled = not vgflag.FixLagEnabled
    if vgflag.FixLagEnabled then
        FixLagBtn.Text = "FIX LAG: ON"
        FixLagBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
        FixLagBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        FixLagBtn.Text = "FIX LAG: OFF"
        FixLagBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        FixLagBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        game:GetService("Lighting").GlobalShadows = vgflag.OriginalSettings.GlobalShadows
    end
end)

EspBtn.MouseButton1Click:Connect(function()
    vgflag.EspEnabled = not vgflag.EspEnabled
    if vgflag.EspEnabled then
        EspBtn.Text = "ESP MONSTERS: ON"
        EspBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
        EspBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        EspBtn.Text = "ESP MONSTERS: OFF"
        EspBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        EspBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        vgflag.RemoveESP()
    end
end)

return vgflag


