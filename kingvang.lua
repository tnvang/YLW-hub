-- ====================================================================
-- SCRIPT NAME: kingvang (Premium Safe Edition)
-- CHỨC NĂNG: Menu Auto Farm Bond & Vật Phẩm Độc Đáo Từ Xa (Không Lag)
-- ====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

_G.AutoBond = false -- Trạng thái bật/tắt ban đầu

-- --- 1. TẠO GIAO DIỆN MENU (UI MOBILE) ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "KingVang_UI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Thân Menu
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 180, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true -- Có thể kéo di chuyển trên màn hình điện thoại

-- Bo tròn góc cho đẹp
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Tiêu đề Menu (Chỉ hiển thị KINGVANG)
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0.4, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "KINGVANG"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- Nút Bật/Tắt Auto Bond
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30) -- Đỏ (OFF)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "Auto Bond: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleBtn

-- --- 2. LOGIC XỬ LÝ HÚT VẬT PHẨM (SAFE TELEPORT) ---
local function collectItems()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart

    -- Quét toàn bộ các vật thể trong Workspace
    for _, item in pairs(Workspace:GetDescendants()) do
        if item:IsA("Tool") or item:IsA("Model") then
            local itemName = item.Name:lower()
            -- Tự động nhận diện "bond", "liên kết" hoặc "vật phẩm" nhiệm vụ mục tiêu
            if itemName:match("bond") or itemName:match("liên kết") or itemName:match("vật phẩm") or itemName:match("độc đáo") then
                if item:FindFirstChild("Handle") and item.Handle:IsA("BasePart") then
                    item.Handle.CFrame = rootPart.CFrame
                elseif item:IsA("Model") and item.PrimaryPart then
                    item.PrimaryPart.CFrame = rootPart.CFrame
                end
            end
        end
    end
end

-- Vòng lặp chạy gom vật phẩm khi được bật
task.spawn(function()
    while true do
        if _G.AutoBond then
            pcall(collectItems)
        end
        task.wait(0.5) -- Quét liên tục mỗi 0.5 giây
    end
end)

-- --- 3. SỰ KIỆN KHI ẤN NÚT BẬT/TẮT ---
ToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoBond = not _G.AutoBond
    if _G.AutoBond then
        ToggleBtn.Text = "Auto Bond: ON"
        TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 180, 50)}):Play() -- Chuyển Xanh lá
    else
        ToggleBtn.Text = "Auto Bond: OFF"
        TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(200, 30, 30)}):Play() -- Chuyển Đỏ
    end
