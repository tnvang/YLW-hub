-- ====================================================================
-- SCRIPT NAME: autotele
-- TÍNH NĂNG: Auto Teleport, ESP Khung To Hiện Tên, Gom Bond 100m
-- ====================================================================

_G.autotele_Config = {
    AutoTeleOnStart = true,  -- Tự động nhảy tới tờ Bond khi vừa vào game
    BigESP = true,           -- Bật khung ESP siêu to xuyên tường + Hiện tên + Số mét
    RadiusCollect = true,    -- Tự động hút/nhặt Bond trong phạm vi an toàn
    MaxDistance = 100        -- Giới hạn khoảng cách 100m chống bị game quét
}

-- Danh sách tên hệ thống của Bond (Tự động quét đa ngôn ngữ)
local BOND_NAMES = {
    "bond", "phieu", "phiếu", "moi lien ket", "mối liên kết", 
    "lien ket", "liên kết", "phiếu liên kết", "phieu lien ket"
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Hàm nhận diện tờ Bond thông minh
local function findBond(obj)
    if not obj then return false end
    local nameLower = string.lower(obj.Name)
    
    for _, keyword in pairs(BOND_NAMES) do
        if string.find(nameLower, keyword) then return true end
    end
    
    local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj.Parent:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        local actText = string.lower(prompt.ActionText)
        local objText = string.lower(prompt.ObjectText)
        if string.find(actText, "thu") or string.find(actText, "nhặt") or string.find(actText, "nhat") or
           string.find(objText, "liên") or string.find(objText, "bond") then
            return true
        end
    end
    return false
end

-- ==========================================
-- 1. CHỨC NĂNG ESP KHUNG 3D TO & HIỆN TÊN CHỮ LỚN
-- ==========================================
local function createBigESP(object)
    if object:FindFirstChild("autotele_Box") then 
        local billboard = object:FindFirstChild("autotele_Label")
        if billboard and billboard:FindFirstChild("TextLabel") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - object.Position).Magnitude)
            billboard.TextLabel.Text = "📜 [" .. object.Name .. "] - " .. dist .. "m"
        end
        return 
    end
    
    -- Tạo khung hộp nhựa 3D TO HƠN tờ phiếu thực tế
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "autotele_Box"
    box.Size = object.Size + Vector3.new(1.6, 1.6, 1.6) 
    box.Color3 = Color3.fromRGB(255, 0, 0) -- Màu đỏ rực cực dễ thấy
    box.Transparency = 0.4 
    box.AlwaysOnTop = true 
    box.ZIndex = 10
    box.Adornee = object
    box.Parent = object

    -- Tạo chữ hiển thị tên và khoảng cách
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "autotele_Label"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0) 
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 0) 
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) 
    label.TextStrokeTransparency = 0
    label.TextSize = 18 
    label.Font = Enum.Font.SourceSansBold 
    label.Text = "📜 [" .. object.Name .. "]"
    label.Parent = billboard
    
    billboard.Parent = object
end

task.spawn(function()
    while true do
        task.wait(1)
        if _G.autotele_Config.BigESP then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and findBond(obj) then
                    createBigESP(obj)
                end
            end
        end
    end
end)

-- ==========================================
-- 2. TỰ ĐỘNG TELE KHI MỚI VÀO GAME
-- ==========================================
if _G.autotele_Config.AutoTeleOnStart then
    task.spawn(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        task.wait(3) -- Đợi map tải ổn định
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and findBond(obj) then
                hrp.CFrame = obj.CFrame * CFrame.new(0, 2, 0)
                break -- Chỉ nhảy 1 lần duy nhất lúc đầu game
            end
        end
    end)
end

-- ==========================================
-- 3. TỰ ĐỘNG GOM BOND TRONG PHẠM VI 100M
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.4)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and _G.autotele_Config.RadiusCollect then
            local myPos = char.HumanoidRootPart.Position
            
            for _, obj in pairs(Workspace:GetDescendants()) do
                if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and findBond(obj) then
                    local distance = (myPos - obj.Position).Magnitude
                    
                    if distance <= _G.autotele_Config.MaxDistance then
                        -- Nhặt bằng nút bấm (ProximityPrompt)
                        local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj.Parent:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            fireproximityprompt(prompt)
                        end
                        -- Nhặt bằng cơ chế dẫm chạm chân (Touch)
                        firetouchinterest(char.HumanoidRootPart, obj, 0)
                        task.wait(0.02)
                        firetouchinterest(char.HumanoidRootPart, obj, 1)
                    end
                end
            end
        end
    end
end)

