local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- 1. Xóa UI cũ nếu đang chạy
if PlayerGui:FindFirstChild("AntiCheat_Troll") then PlayerGui.AntiCheat_Troll:Destroy() end

-- 2. Tạo ScreenGui (Giao diện đè lên màn hình)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiCheat_Troll"
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- Nền đen (Cho nó trong suốt 0.5 để nhìn thấy game phía sau, tránh bị đen kịt)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Parent = ScreenGui

-- KHUNG THÔNG BÁO (Vị trí đúng khung đỏ trong ảnh 1000002078.jpg)
local AlertBox = Instance.new("TextLabel")
AlertBox.Size = UDim2.new(0.8, 0, 0.3, 0) -- Chiều rộng 80%, cao 30%
AlertBox.Position = UDim2.new(0.1, 0, 0.35, 0) -- Đẩy xuống giữa màn hình (đúng vị trí khoanh đỏ)
AlertBox.BackgroundTransparency = 1
AlertBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AlertBox.Font = Enum.Font.SourceSansBold
AlertBox.TextSize = 35 -- Kích thước chữ cố định
AlertBox.TextWrapped = true
AlertBox.Parent = MainFrame

-- KỊCH BẢN CHẠY
task.spawn(function()
    -- S1: Lỗi hệ thống (Giật màn hình)
    for i = 1, 20 do
        MainFrame.BackgroundColor3 = Color3.fromRGB(math.random(0, 50), 0, 0)
        AlertBox.Text = "SYSTEM ERROR: " .. math.random(1000, 9999)
        task.wait(0.1)
    end
    
    -- S2 & S3: Cảnh báo & Báo cáo
    AlertBox.TextColor3 = Color3.fromRGB(255, 0, 0)
    AlertBox.Text = "CẢNH BÁO: PHÁT HIỆN GIAN LẬN!"
    task.wait(2)
    AlertBox.Text = "Đang báo cáo: " .. Player.Name .. "..."
    task.wait(2)
    AlertBox.Text = "BÁO CÁO THÀNH CÔNG!"
    
    -- Hiệu ứng chớp nháy màu đỏ
    for i = 1, 10 do
        MainFrame.BackgroundTransparency = 0
        task.wait(0.1)
        MainFrame.BackgroundTransparency = 0.5
        task.wait(0.1)
    end
    
    -- S4: Fake Ban (Khóa acc)
    MainFrame.BackgroundTransparency = 0
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    AlertBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    AlertBox.Text = "❌ TÀI KHOẢN BỊ KHÓA 72 GIỜ\nLý do: Sử dụng phần mềm gian lận.\nThông báo từ hệ thống quản trị Roblox."
end)

