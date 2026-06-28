local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- 1. Xóa UI cũ nếu đang chạy
if PlayerGui:FindFirstChild("AntiCheat_Troll") then PlayerGui.AntiCheat_Troll:Destroy() end

-- 2. Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiCheat_Troll"
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- Nền đen
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Parent = ScreenGui

-- Khung thông báo
local AlertBox = Instance.new("TextLabel")
AlertBox.Size = UDim2.new(0.8, 0, 0.3, 0)
AlertBox.Position = UDim2.new(0.1, 0, 0.35, 0)
AlertBox.BackgroundTransparency = 1
AlertBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AlertBox.Font = Enum.Font.SourceSansBold
AlertBox.TextSize = 35
AlertBox.TextWrapped = true
AlertBox.Parent = MainFrame

-- KỊCH BẢN CHẠY
task.spawn(function()
    -- S1: Lỗi hệ thống
    for i = 1, 15 do
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
    
    -- Hiệu ứng chớp nháy
    for i = 1, 6 do
        MainFrame.BackgroundTransparency = 0
        task.wait(0.1)
        MainFrame.BackgroundTransparency = 0.5
        task.wait(0.1)
    end
    
    -- S4: Fake Ban
    MainFrame.BackgroundTransparency = 0
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    AlertBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    AlertBox.Text = "❌ TÀI KHOẢN ĐÃ BỊ KHÓA 72 GIỜ\nLý do: Sử dụng phần mềm gian lận.\nThông báo từ hệ thống quản trị Roblox."
    
    -- ĐỢI 3 GIÂY ĐỂ NẠN NHÂN KỊP ĐỌC RỒI KICK
    task.wait(3)
    
    -- Lệnh Kick (Hệ thống sẽ tự động văng người chơi ra ngoài)
    Player:Kick("\n\n[HỆ THỐNG BẢO MẬT]: Tài khoản của bạn đã bị khóa do vi phạm điều khoản dịch vụ (Gian lận trong game).")
end)

