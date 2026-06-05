local Player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- GUI Menu vangv1
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "vangv1_autobond"
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 160, 0, 50)
MainFrame.Position = UDim2.new(0.5, -80, 0.8, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true

local vangv1_Btn = Instance.new("TextButton", MainFrame)
vangv1_Btn.Size = UDim2.new(1, 0, 1, 0)
vangv1_Btn.Text = "VANGV1: OFF"
vangv1_Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
vangv1_Btn.TextColor3 = Color3.fromRGB(255, 255, 255)

local vangv1Enabled = false

-- Hàm tìm đối tượng gần nhất
local function findClosest(namePattern)
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local closest = nil
    local shortestDist = math.huge
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if string.find(string.lower(obj.Name), namePattern) then
            local pos = (obj:IsA("Model") and obj:GetPrimaryPartCFrame().p) or (obj:IsA("BasePart") and obj.Position)
            if pos then
                local dist = (root.Position - pos).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = obj
                end
            end
        end
    end
    return closest
end

vangv1_Btn.MouseButton1Click:Connect(function()
    vangv1Enabled = not vangv1Enabled
    vangv1_Btn.Text = vangv1Enabled and "VANGV1: ON" or "VANGV1: OFF"
    vangv1_Btn.BackgroundColor3 = vangv1Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    task.spawn(function()
        while vangv1Enabled do
            local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                -- 1. Tele tới Ghế để tránh bị Anti-Cheat quét
                local seat = findClosest("seat") 
                if seat then
                    local seatPos = (seat:IsA("Model") and seat:GetPrimaryPartCFrame().p) or seat.Position
                    root.CFrame = CFrame.new(seatPos + Vector3.new(0, 1, 0))
                    task.wait(0.2)
                end
                
                -- 2. Tele tới Trái Phiếu
                local bond = findClosest("trái phiếu") or findClosest("bond")
                if bond then
                    local bondPos = (bond:IsA("Model") and bond:GetPrimaryPartCFrame().p) or bond.Position
                    root.CFrame = CFrame.new(bondPos + Vector3.new(0, 0.5, 0))
                    
                    -- Nhặt đồ
                    local prompt = bond:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then fireproximityprompt(prompt) end
                    
                    task.wait(0.5)
                end
            end
            task.wait(0.3)
        end
    end)
end)

