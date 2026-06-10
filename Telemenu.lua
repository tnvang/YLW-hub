Title.Text = "TnVang TeleMenu | By Vang"
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local LocationKeywords = {
    ["Town (Thị trấn thường)"] = "Town",
    ["Fortified Town / Safe Zone"] = "Fort", 
    ["Sterling (Thị trấn bỏ hoang)"] = "Sterl",
    ["Castle (Lâu đài)"] = "Cast",
    ["Fort Constitution (Pháo đài)"] = "Const",
    ["Tesla Lab (Phòng thí nghiệm)"] = "Tesla",
    ["Oil Refinery (Nhà máy lọc dầu)"] = "Oil",
    ["Stillwater Prison (Nhà tù)"] = "Prison",
    ["Outlaw's Town (Khu cuối game)"] = "Outlaw",
    ["Strange Pyramid (Kim tự tháp)"] = "Pyramid"
}

-- 1. Hàm quét map thông minh (Chỉ tìm Model lớn để giảm tải cho CPU)
local function SmartFindLocation(keyword)
    local lowerKeyword = string.lower(keyword)
    
    -- Ưu tiên quét các Model trước thay vì quét vô tội vạ mọi loại Object
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and string.find(string.lower(obj.Name), lowerKeyword) then
            return obj.PrimaryPart and obj.PrimaryPart.Position or obj:FindFirstChildWhichIsA("BasePart").Position
        end
    end
    
    -- Nếu không thấy ở thư mục gốc mới quét sâu vào các Folder con (Tránh quá tải)
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart")) and string.find(string.lower(obj.Name), lowerKeyword) then
            if obj:IsA("Model") then
                return obj.PrimaryPart and obj.PrimaryPart.Position or obj:FindFirstChildWhichIsA("BasePart", true).Position
            else
                return obj.Position
            end
        end
    end
    return nil
end

-- 2 & 3 & 4. Hàm dịch chóp ngắt quãng kết hợp No-clip bằng State (Siêu nhẹ máy)
local function OptimizedBypassTeleport(targetPos)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    local stepDistance = 35 -- Bước nhảy (Giảm xuống nếu bị rubberband)
    local waitTime = 0.04    -- Thời gian nghỉ giữa các bước nhảy
    
    -- Bật No-clip siêu nhẹ bằng cách đổi State của nhân vật
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end
    
    -- Tiến hành di chuyển ngắt quãng
    while (hrp.Position - targetPos).Magnitude > stepDistance do
        if not LocalPlayer.Character or not hrp.Parent then break end
        
        local currentPos = hrp.Position
        local direction = (targetPos - currentPos).Unit
        local nextPos = currentPos + (direction * stepDistance)
        
        hrp.CFrame = CFrame.new(nextPos)
        hrp.Velocity = Vector3.new(0,0,0) -- Reset vận tốc liên tục để qua mặt hệ thống quét tốc độ
        task.wait(waitTime)
    end
    
    -- Đến đích: Neo nhân vật trên cao một chút để map kịp load (Chống rơi xuống void)
    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 12, 0))
    hrp.Anchored = true
    task.wait(0.5) -- Đợi 0.5 giây cho map hiển thị hoàn toàn
    hrp.Anchored = false
    
    -- Trả nhân vật về trạng thái đứng bình thường
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- --- 5. GIAO DIỆN (UI) KÉO THẢ MƯỢT MÀ ---
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 240, 0, 420)
Frame.BorderSizePixel = 0

-- Bo góc UI cho đẹp mắt
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

-- Xử lý kéo thả mượt bằng UIS
local dragging, dragInput, dragStart, startPos
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIListLayout.Parent = Frame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Title.Text = "Dead Rails PRO Bypass"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

for displayName, keyword in pairs(LocationKeywords) do
    local Button = Instance.new("TextButton")
    Button.Parent = Frame
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Button.Text = displayName
    Button.TextColor3 = Color3.fromRGB(240, 240, 240)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 14
    Button.BorderSizePixel = 0
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        Button.Text = "🔍 Đang tìm kiếm..."
        Button.BackgroundColor3 = Color3.fromRGB(160, 90, 15)
        
        local targetPos = SmartFindLocation(keyword)
        
        if targetPos then
            Button.Text = "⚡ Bypassing..."
            OptimizedBypassTeleport(targetPos)
            Button.Text = displayName
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        else
            Button.Text = "❌ Không tìm thấy!"
            Button.BackgroundColor3 = Color3.fromRGB(120, 35, 35)
            task.wait(1)
            Button.Text = displayName
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        end
    end)
end
