local Player = game.Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

-- 1. TẠO GUI LOADING THU GỌN (Thương hiệu mới VANGBOND)
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "vangbond_autobond"
ScreenGui.ResetOnSpawn = false

local LoadFrame = Instance.new("Frame", ScreenGui)
LoadFrame.Size = UDim2.new(0, 160, 0, 35)
LoadFrame.Position = UDim2.new(0.5, -80, 0.8, 0)
LoadFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoadFrame.BorderSizePixel = 1
LoadFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)

local LoadText = Instance.new("TextLabel", LoadFrame)
LoadText.Size = UDim2.new(1, 0, 1, 0)
LoadText.Text = "Vangbond loading."
LoadText.TextColor3 = Color3.fromRGB(255, 215, 0)
LoadText.Font = Enum.Font.SourceSansBold
LoadText.TextSize = 14
LoadText.BackgroundTransparency = 1

task.spawn(function()
    for i = 1, 3 do
        LoadText.Text = "Vangbond loading."
        task.wait(0.3)
        LoadText.Text = "Vangbond loading.."
        task.wait(0.3)
        LoadText.Text = "Vangbond loading..."
        task.wait(0.3)
    end
    LoadFrame:Destroy()
end)

task.wait(2.7)

-- 2. GIAO DIỆN CHÍNH (VANGBOND)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 160, 0, 50)
MainFrame.Position = UDim2.new(0.5, -80, 0.8, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
MainFrame.Active = true
MainFrame.Draggable = true

local Bond_Btn = Instance.new("TextButton", MainFrame)
Bond_Btn.Size = UDim2.new(1, 0, 1, 0)
Bond_Btn.Text = "VANGBOND: OFF"
Bond_Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Bond_Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Bond_Btn.Font = Enum.Font.SourceSansBold
Bond_Btn.TextSize = 16

local bondEnabled = false

local function autoPressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Hàm lấy tọa độ chính xác của Trái Phiếu
local function getPositionOfObject(obj)
    if obj:IsA("Model") then
        if obj.PrimaryPart then
            return obj.PrimaryPart.Position
        else
            local anyPart = obj:FindFirstChildWhichIsA("BasePart")
            if anyPart then return anyPart.Position end
        end
    elseif obj:IsA("BasePart") then
        return obj.Position
    end
    return nil
end

Bond_Btn.MouseButton1Click:Connect(function()
    bondEnabled = not bondEnabled
    Bond_Btn.Text = bondEnabled and "VANGBOND: ON" or "VANGBOND: OFF"
    Bond_Btn.BackgroundColor3 = bondEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    if bondEnabled then
        task.spawn(function()
            while bondEnabled do
                local myChar = Player.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local root = myChar.HumanoidRootPart
                    local closestBond = nil
                    local shortestDist = math.huge
                    
                    -- Quét tìm vật phẩm chứa chữ "trái phiếu" hoặc "trai phieu" hoặc "bond"
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        local nameLower = string.lower(obj.Name)
                        if string.find(nameLower, "trái phiếu") or string.find(nameLower, "trai phieu") or string.find(nameLower, "bond") then
                            local pos = getPositionOfObject(obj)
                            if pos then
                                local dist = (root.Position - pos).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    closestBond = obj
                                end
                            end
                        end
                    end
                    
                    if closestBond then
                        local targetPos = getPositionOfObject(closestBond)
                        if targetPos then
                            print("Vangbond phát hiện mục tiêu: " .. closestBond.Name)
                            
                            -- Teleport thẳng tới vị trí trái phiếu
                            root.CFrame = CFrame.new(targetPos + Vector3.new(0, 1, 0))
                            task.wait(0.2) -- Chờ game nhận diện nhân vật đã đứng đó
                            
                            -- Tự động bấm E thu thập
                            autoPressE()
                            task.wait(0.5) -- Đợi nhặt xong rồi mới quét tiếp
                        end
                    end
                end
                task.wait(0.3) -- Nghỉ quét để tránh quá tải
            end
        end)
    end
end)

print("Vangbond: Bản cập nhật quét Trái Phiếu Tiếng Việt đã kích hoạt!")

