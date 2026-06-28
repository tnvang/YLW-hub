-- FIX: Dán vào Delta Executor và chạy
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Tạo ScreenGui với ZIndex cao
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiCheat_UI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999 -- Đảm bảo đè mọi thứ
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Parent = ScreenGui

-- Hiệu ứng Code Xanh
local MatrixLabel = Instance.new("TextLabel")
MatrixLabel.Size = UDim2.new(1, 0, 1, 0)
MatrixLabel.BackgroundTransparency = 1
MatrixLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
MatrixLabel.TextFont = Enum.Font.Code
MatrixLabel.TextScaled = true
MatrixLabel.TextXAlignment = Enum.TextXAlignment.Left
MatrixLabel.TextYAlignment = Enum.TextYAlignment.Top
MatrixLabel.ZIndex = 10
MatrixLabel.Parent = MainFrame

-- Thông báo trạng thái
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
StatusLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.SourceSansBold
StatusLabel.TextScaled = true
StatusLabel.ZIndex = 20
StatusLabel.Parent = MainFrame

-- 1. Chạy code xanh
task.spawn(function()
    local codes = {"ERROR_404", "ACCESS_DENIED", "SYSTEM_CORRUPT", "SCANNING...", "USER_IP_LOGGED", "SCRIPT_DETECTED"}
    for i = 1, 100 do
        if not MainFrame:IsDescendantOf(game) then break end
        local str = ""
        for j = 1, 15 do str = str .. codes[math.random(1, #codes)] .. " " end
        MatrixLabel.Text = str
        task.wait(0.08)
    end
end)

-- 2. Anti-cheat thông báo
StatusLabel.Text = "ANTI-CHEAT: PHÁT HIỆN PHẦN MỀM GIAN LẬN!"
task.wait(3)

-- 3. Báo cáo
StatusLabel.Text = "Đang báo cáo tài khoản ["..Player.Name.."] về máy chủ..."
task.wait(3)
StatusLabel.Text = "BÁO CÁO THÀNH CÔNG!"
task.wait(2)

-- Nhấp nháy màn hình
for i = 1, 10 do
    MainFrame.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    task.wait(0.1)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    task.wait(0.1)
end

-- 4. Fake Ban
MatrixLabel.Visible = false
StatusLabel.Size = UDim2.new(0.9, 0, 0.5, 0)
StatusLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Text = "TÀI KHOẢN ĐÃ BỊ KHÓA\n\nLý do: Sử dụng phần mềm gian lận / Script trái phép.\nThời hạn: 72 Giờ.\n\nThông báo từ hệ thống bảo mật Roblox."

