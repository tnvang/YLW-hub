-- [[ VANXGPT PRO OPTIMIZED MENU V3 ]]
-- GitHub Repository Component (Performance Focus)

local vanxgpt = {
    FixLagEnabled = false,
    EspEnabled = false,
    EspColor = Color3.fromRGB(0, 255, 0),
    RefreshRate = 2,
    TextureCache = {}, -- Lưu trữ texture gốc để khôi phục khi tắt
    OriginalLighting = {
        GlobalShadows = game:GetService("Lighting").GlobalShadows,
        FogStart = game:GetService("Lighting").FogStart,
        FogEnd = game:GetService("Lighting").FogEnd
    }
}

-- [[ TRÌNH TẠO GIAO DIỆN (TỐI ƯU KÉO THẢ) ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleMin = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local FixLagBtn = Instance.new("TextButton")
local EspBtn = Instance.new("TextButton")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "vanxgpt_v3"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 180, 0, 130)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

-- Hệ thống kéo thả chuẩn hóa (Sửa lỗi MouseBehavior)
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Giao diện Tiêu đề hiển thị vanxgpt Menu
Title.Parent = MainFrame
Title.Size = UDim2.new(0, 140, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "  vanxgpt Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14

-- Nút thu gọn menu
ToggleMin.Parent = MainFrame
ToggleMin.Position = UDim2.new(0, 140, 0, 0)
ToggleMin.Size = UDim2.new(0, 40, 0, 30)
ToggleMin.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleMin.Text = "-"
ToggleMin.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMin.TextSize = 16

local minimized = false
ToggleMin.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ContentFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 180, 0, 30)
        ToggleMin.Text = "+"
    else
        ContentFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 180, 0, 130)
        ToggleMin.Text = "-"
    end
end)

ContentFrame.Parent = MainFrame
ContentFrame.Position = UDim2.new(0, 0, 0, 35)
ContentFrame.Size = UDim2.new(0, 180, 0, 90)
ContentFrame.BackgroundTransparency = 1

UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function styleButton(btn, text)
    btn.Size = UDim2.new(0, 160, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
end

FixLagBtn.Parent = ContentFrame
styleButton(FixLagBtn, "FIX LAG")

EspBtn.Parent = ContentFrame
styleButton(EspBtn, "ESP MONSTERS")


-- [[ HÀM CHỨC NĂNG TỐI ƯU HIỆU NĂNG CỦA VANXGPT ]]

-- 1. Bật Fix Lag (Ẩn texture tạm thời, không xóa vĩnh viễn)
function vanxgpt.EnableFixLag()
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false
    lighting.FogStart = 9e9
    lighting.FogEnd = 9e9
    
    -- Chỉ quét 1 lần duy nhất khi bấm bật để lưu Cache vật thể
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("MeshPart") then
            if not vanxgpt.TextureCache[v] then
                vanxgpt.TextureCache[v] = { Material = v.Material }
            end
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") then
            if not vanxgpt.TextureCache[v] then
                vanxgpt.TextureCache[v] = { Transparency = v.Transparency }
            end
            v.Transparency = 1 -- Ẩn đi để nhẹ máy
        end
    end
end

-- Tắt Fix Lag (Khôi phục lại hiện trạng cũ từ Cache)
function vanxgpt.DisableFixLag()
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = vanxgpt.OriginalLighting.GlobalShadows
    lighting.FogStart = vanxgpt.OriginalLighting.FogStart
    lighting.FogEnd = vanxgpt.OriginalLighting.FogEnd
    
    for obj, original in pairs(vanxgpt.TextureCache) do
        if obj and obj.Parent then
            if obj:IsA("BasePart") then
                obj.Material = original.Material
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = original.Transparency
            end
        end
    end
    vanxgpt.TextureCache = {} -- Làm sạch bộ nhớ đệm
end


-- 2. ESP Quái (Quét thông minh qua Workspace tầng nông)
function vanxgpt.ApplyESP()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") or v:IsA("Folder") then
            for _, child in pairs(v:GetChildren()) do
                if child:IsA("Model") and child:FindFirstChild("HumanoidRootPart") and child:FindFirstChildOfClass("Humanoid") then
                    -- Loại trừ người chơi thật
                    if not game:GetService("Players"):GetPlayerFromCharacter(child) then
                        local hrp = child.HumanoidRootPart
                        if not hrp:FindFirstChild("MonsterESP") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "MonsterESP"
                            highlight.FillColor = vanxgpt.EspColor
                            highlight.FillTransparency = 0.5
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.OutlineTransparency = 0
                            highlight.Adornee = child
                            highlight.Parent = hrp
                        end
                    end
                end
            end
        end
    end
end

function vanxgpt.RemoveESP()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "MonsterESP" and v:IsA("Highlight") then
            v:Destroy()
        end
    end
end


-- [[ KHỞI CHẠY VÒNG LẶP SỰ KIỆN ]]

FixLagBtn.MouseButton1Click:Connect(function()
    vanxgpt.FixLagEnabled = not vanxgpt.FixLagEnabled
    if vanxgpt.FixLagEnabled then
        FixLagBtn.Text = "FIX LAG: ON"
        FixLagBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
        FixLagBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.spawn(vanxgpt.EnableFixLag)
    else
        FixLagBtn.Text = "FIX LAG: OFF"
        FixLagBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        FixLagBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.spawn(vanxgpt.DisableFixLag)
    end
end)

-- Vòng lặp ESP Quái
task.spawn(function()
    while true do
        if vanxgpt.EspEnabled then
            vanxgpt.ApplyESP()
        end
        task.wait(vanxgpt.RefreshRate)
    end
end)

EspBtn.MouseButton1Click:Connect(function()
    vanxgpt.EspEnabled = not vanxgpt.EspEnabled
    if vanxgpt.EspEnabled then
        EspBtn.Text = "ESP MONSTERS: ON"
        EspBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
        EspBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        EspBtn.Text = "ESP MONSTERS: OFF"
        EspBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        EspBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        vanxgpt.RemoveESP()
    end
end)

return vanxgpt

