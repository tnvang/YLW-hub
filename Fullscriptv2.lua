local Player = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera

-- Xóa màn hình lỗi cũ nếu có để không bị đè lên nhau
if Camera:FindFirstChild("GlitchOverlay") then
    Camera.GlitchOverlay:Destroy()
end

-- 1. Tạo "Màn hình lỗi" bám theo camera (Tối ưu tỉ lệ màn hình điện thoại)
local screenOverlay = Instance.new("Part")
screenOverlay.Name = "GlitchOverlay"
screenOverlay.Size = Vector3.new(12, 9, 1) -- Tỉ lệ chuẩn hiển thị mobile
screenOverlay.Transparency = 0.2
screenOverlay.Color = Color3.fromRGB(0, 0, 0)
screenOverlay.Anchored = true
screenOverlay.CanCollide = false
screenOverlay.Parent = Camera

-- Cập nhật bám sát góc nhìn của Camera
game:GetService("RunService").RenderStepped:Connect(function()
    if screenOverlay and screenOverlay.Parent then
        screenOverlay.CFrame = Camera.CFrame * CFrame.new(0, 0, -4.5)
    end
end)

-- Tạo SurfaceGui độ phân giải cao để chữ nét hơn
local surfaceGui = Instance.new("SurfaceGui", screenOverlay)
surfaceGui.Face = Enum.NormalId.Front
surfaceGui.CanvasSize = Vector2.new(1024, 1024) -- Tăng độ rộng Canvas để căn tọa độ chuẩn
surfaceGui.AlwaysOnTop = true

-- 2. Khung chữ đặt ĐÚNG VỊ TRÍ KHOANH ĐỎ trong ảnh 1000002078.jpg
local textLabel = Instance.new("TextLabel", surfaceGui)
textLabel.Size = UDim2.new(0.9, 0, 0.4, 0) -- Rộng bao quát
textLabel.Position = UDim2.new(0.05, 0, 0.3, 0) -- Đẩy xuống vị trí 30% (khớp khung đỏ dưới logo)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextSize = 42 -- FIX: Dùng kích thước cố định để không bị mất chữ trên điện thoại
textLabel.TextWrapped = true
textLabel.TextXAlignment = Enum.TextXAlignment.Center
textLabel.TextYAlignment = Enum.TextYAlignment.Top

-- KỊCH BẢN TROLL VÀ FIX HIỂN THỊ
task.spawn(function()
    -- S1: HIỆU ỨNG LỖI HỆ THỐNG
    local hexDump = {"0x00A3F2", "0xFF0032", "0x99A1C2", "BUFFER_OVERFLOW", "STACK_CORRUPTION", "CRITICAL_FAILURE"}
    textLabel.TextXAlignment = Enum.TextXAlignment.Left -- Đoạn đầu hiện mã lỗi căn trái cho giống thật
    textLabel.Font = Enum.Font.Code
    
    for i = 1, 25 do
        local randomLines = ""
        for j = 1, 4 do
            randomLines = randomLines .. hexDump[math.random(1, #hexDump)] .. ": " .. string.char(math.random(65, 90)) .. math.random(100, 999) .. "\n"
        end
        textLabel.Text = "--- SYSTEM ERROR ---\n" .. randomLines
        screenOverlay.Transparency = (i % 2 == 0) and 0.1 or 0.3
        task.wait(0.08)
    end
    
    -- Chuyển chữ về căn giữa ngay vị trí ô màu đỏ bạn kẻ
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.Font = Enum.Font.SourceSansBold
    
    -- S2 & S3: Cảnh báo & Hiện tiến trình Báo cáo tiếng Việt
    screenOverlay.Transparency = 0
    screenOverlay.Color = Color3.fromRGB(0, 0, 0)
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.Text = "CẢNH BÁO ANTI-CHEAT:\nPHÁT HIỆN GIAN LẬN!"
    task.wait(2.5)
    
    textLabel.Text = "⏳ ĐANG BÁO CÁO TÀI KHOẢN: " .. Player.Name .. "\n\n✔ BÁO CÁO THÀNH CÔNG!"
    task.wait(2.5)
    
    -- Hiệu ứng chớp nháy báo động màn hình
    for i = 1, 8 do
        screenOverlay.Transparency = 0
        task.wait(0.06)
        screenOverlay.Transparency = 0.7
        task.wait(0.06)
    end
    
    -- S4: HIỆN THÔNG BÁO BAN CỐ ĐỊNH (Đã fix hoàn toàn)
    screenOverlay.Transparency = 0
    screenOverlay.Color = Color3.fromRGB(25., 25, 25) -- Đổi nền xám đậm bảng ban thông dụng
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Text = "❌ TÀI KHOẢN ĐÃ BỊ TẠM KHÓA\n\nLý do: Sử dụng phần mềm gian lận / Can thiệp hệ thống.\nThời hạn: 72 giờ.\n\n[Thông báo từ hệ thống bảo mật Roblox]"
end)

