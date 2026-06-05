local Player = game.Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

-- Tạo Giao diện Nút bấm mang tên vangaotu
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "vangauto_autobond"
ScreenGui.ResetOnSpawn = false

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
Bond_Btn.Text = "VANGAOUTU: OFF"
Bond_Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Bond_Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Bond_Btn.Font = Enum.Font.SourceSansBold
Bond_Btn.TextSize = 16

local bondEnabled = false

-- Hàm giả lập nhấn phím E tự động
local function autoPressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Logic Tự Động Vận Hành
Bond_Btn.MouseButton1Click:Connect(function()
    bondEnabled = not bondEnabled
    Bond_Btn.Text = bondEnabled and "VANGAOUTU: ON" or "VANGAOUTU: OFF"
    Bond_Btn.BackgroundColor3 = bondEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    if bondEnabled then
        task.spawn(function()
            while bondEnabled do
                local myChar = Player.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local root = myChar.HumanoidRootPart
                    local closestBond = nil
                    local shortestDist = math.huge
                    
                    -- 1. Tự động quét tìm Bond gần nhất trong map
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if (obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("Model")) 
                           and string.find(string.lower(obj.Name), "bond") then
                            
                            local targetPos = (obj:IsA("Model") and obj:GetPrimaryPartCFrame().p) or obj.Position
                            local dist = (root.Position - targetPos).Magnitude
                            
                            if dist < shortestDist then
                                shortestDist = dist
                                closestBond = obj
                            end
                        end
                    end
                    
                    -- 2. Tự động Teleport và tự động nhấn thu thập
                    if closestBond then
                        local targetPos = (closestBond:IsA("Model") and closestBond:GetPrimaryPartCFrame().p) or closestBond.Position
                        
                        -- Dịch chuyển bồ đến sát vị trí tờ Bond
                        root.CFrame = CFrame.new(targetPos + Vector3.new(0, 1, 0)) 
                        task.wait(0.3) -- Chờ game ổn định vị trí nhân vật
                        
                        -- Tự động kích hoạt hành động nhấn E để thu thập
                        autoPressE() 
                        
                        task.wait(0.6) -- Chờ nhặt xong xuôi hoàn toàn rồi mới quét tìm tờ tiếp theo
                    end
                end
                task.wait(0.3) -- Nhịp nghỉ quét để tránh lag máy
            end
        end)
    end
end)

print("vangaotu: Script Auto Bond đã sẵn sàng!")

