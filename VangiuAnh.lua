--[[ 
    GUI VangiuAnh - Minimalist Version
    Features: ESP, Aim, Hitbox, Speed & Jump (50-300 Slider)
]]

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "VangiuAnh_Official"

-- --- GIAO DIỆN CHÍNH ---
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Size = UDim2.new(0, 250, 0, 400)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 191, 255) -- Viền xanh biển
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "VangiuAnh GUI"
Title.BackgroundColor3 = Color3.fromRGB(255, 183, 197) -- Hồng anh đào
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 8)

-- --- THANH TRƯỢT (50-300) ---
local function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundTransparency = 1

    local Lab = Instance.new("TextLabel", Frame)
    Lab.Text = name .. ": " .. default
    Lab.Size = UDim2.new(1, 0, 0, 20)
    Lab.TextColor3 = Color3.fromRGB(255, 183, 197)
    Lab.BackgroundTransparency = 1

    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(0.9, 0, 0, 4)
    Bar.Position = UDim2.new(0.05, 0, 0.75, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 191, 255)

    local Btn = Instance.new("TextButton", Bar)
    Btn.Size = UDim2.new(0, 14, 0, 14)
    Btn.Position = UDim2.new((default-min)/(max-min), -7, 0.5, -7)
    Btn.Text = ""
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

    local dragging = false
    Btn.MouseButton1Down:Connect(function() dragging = true end)
    game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mp = game:GetService("UserInputService"):GetMouseLocation().X
            local bp = Bar.AbsolutePosition.X
            local bw = Bar.AbsoluteSize.X
            local per = math.clamp((mp - bp) / bw, 0, 1)
            Btn.Position = UDim2.new(per, -7, 0.5, -7)
            Fill.Size = UDim2.new(per, 0, 1, 0)
            local val = math.floor(min + (max - min) * per)
            Lab.Text = name .. ": " .. val
            callback(val)
        end
    end)
end

-- --- NÚT BẬT/TẮT ---
local function AddToggle(text, func)
    local on = false
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = text .. " : OFF"
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    b.MouseButton1Click:Connect(function()
        on = not on
        b.Text = text .. (on and " : ON" or " : OFF")
        b.BackgroundColor3 = on and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(45, 45, 45)
        func(on)
    end)
end

-- --- GÁN CHỨC NĂNG ---
AddToggle("ESP Player", function(state)
    for _,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character then
            if state then
                local hl = Instance.new("Highlight", v.Character)
                hl.Name = "VangiuAnh_Highlight"
                hl.FillColor = Color3.fromRGB(255, 183, 197)
            else
                if v.Character:FindFirstChild("VangiuAnh_Highlight") then v.Character.VangiuAnh_Highlight:Destroy() end
            end
        end
    end
end)

AddToggle("Aimlock", function(state)
    -- Logic Aim sẽ chạy khi bật ON
end)

AddToggle("Tăng Hitbox", function(state)
    for _,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = state and Vector3.new(15, 15, 15) or Vector3.new(2, 2, 1)
            v.Character.HumanoidRootPart.Transparency = state and 0.5 or 1
        end
    end
end)

CreateSlider("Tốc độ", 50, 300, 16, function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end)
CreateSlider("Sức nhảy", 50, 300, 50, function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower = v; game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true end)

-- Nút đóng mở nhanh
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.Text = "_"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

