-- Đảm bảo script chỉ chạy trên thiết bị của người dùng
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- 1. Tạo UI đè lên toàn bộ màn hình
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiCheat_Report"
ScreenGui.IgnoreGuiInset = true -- Che cả thanh công cụ hệ thống
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Parent = ScreenGui

local MatrixLabel = Instance.new("TextLabel")
MatrixLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
MatrixLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
MatrixLabel.BackgroundTransparency = 1
MatrixLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
MatrixLabel.TextFont = Enum.Font.Code
MatrixLabel.TextSize = 16
MatrixLabel.TextXAlignment = Enum.TextXAlignment.Left
MatrixLabel.TextYAlignment = Enum.TextYAlignment.Top
MatrixLabel.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
StatusLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.SourceSansBold
StatusLabel.TextSize = 24
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

-- Kịch bản troll
task.spawn(function()
    -- Chạy Matrix
    local codes = {"SCANNING...", "INJECTION_DETECTED", "IP_LOGGED", "SUSPICIOUS_ACTIVITY", "REPORTING_USER..."}
    for i = 1, 50 do
        MatrixLabel.Text = codes[math.random(1, #codes)] .. "\n" .. codes[math.random(1, #codes)] .. "\n" .. codes[math.random(1, #codes)]
        task.wait(0.1)
    end
end)

-- Hiển thị thông báo
StatusLabel.Text = "Đang báo cáo tài khoản [" .. Player.Name .. "] với mục đích gian lận..."
task.wait(3)
StatusLabel.Text = "✔ Báo cáo thành công! Gửi dữ liệu về Server..."
task.wait(2)

-- Hiệu ứng chớp nháy đỏ đen
for i = 1, 10 do
    MainFrame.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    task.wait(0.1)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    task.wait(0.1)
end

-- Bảng Fake Ban
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MatrixLabel.Visible = false
StatusLabel.TextSize = 20
StatusLabel.Text = "❌ TÀI KHOẢN ĐÃ BỊ KHÓA\n\nLý do: Sử dụng phần mềm gian lận.\nThời gian: 72 giờ.\n\nThông báo từ hệ thống quản trị Roblox."

