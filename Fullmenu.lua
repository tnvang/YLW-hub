local Player = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. Tạo "Màn hình lỗi" bám theo camera
local screenOverlay = Instance.new("Part")
screenOverlay.Name = "GlitchOverlay"
screenOverlay.Size = Vector3.new(10, 10, 1)
screenOverlay.Transparency = 0.2
screenOverlay.Color = Color3.fromRGB(0, 0, 0)
screenOverlay.Anchored = true
screenOverlay.CanCollide = false
screenOverlay.Parent = Camera

game:GetService("RunService").RenderStepped:Connect(function()
    if screenOverlay then
        screenOverlay.CFrame = Camera.CFrame * CFrame.new(0, 0, -5)
    end
end)

local surfaceGui = Instance.new("SurfaceGui", screenOverlay)
surfaceGui.Face = Enum.NormalId.Front
surfaceGui.CanvasSize = Vector2.new(800, 800)

local textLabel = Instance.new("TextLabel", surfaceGui)
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
textLabel.Font = Enum.Font.Code
textLabel.TextScaled = true
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.TextYAlignment = Enum.TextYAlignment.Top

-- KỊCH BẢN TROLL
task.spawn(function()
    -- S1: HIỆU ỨNG LỖI HỆ THỐNG (MEMORY DUMP LOOK)
    local hexDump = {"0x00A3F2", "0xFF0032", "0x99A1C2", "BUFFER_OVERFLOW", "STACK_CORRUPTION", "CRITICAL_FAILURE"}
    for i = 1, 40 do
        local randomLines = ""
        for j = 1, 10 do
            randomLines = randomLines .. hexDump[math.random(1, #hexDump)] .. ": " .. string.char(math.random(65, 90)) .. math.random(100, 999) .. "\n"
        end
        textLabel.Text = "--- SYSTEM MEMORY DUMP ---\n" .. randomLines
        screenOverlay.Transparency = (i % 2 == 0) and 0.1 or 0.3 -- Giật lag màn hình
        task.wait(0.08)
    end
    
    -- S2: Phát hiện gian lận
    screenOverlay.Transparency = 0
    screenOverlay.Color = Color3.fromRGB(0, 0, 0)
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.Text = "\n\nCẢNH BÁO ANTI-CHEAT:\nPHÁT HIỆN SỬ DỤNG PHẦN MỀM GIAN LẬN!\nNGƯỜI DÙNG: "..Player.Name
    task.wait(3)
    
    -- S3: Báo cáo
    textLabel.Text = "\n\nĐANG GỬI DỮ LIỆU VỀ MÁY CHỦ ROBLOX...\nTIẾN TRÌNH: 100%...\nBÁO CÁO ĐÃ ĐƯỢC GỬI THÀNH CÔNG!"
    task.wait(2)
    
    -- Hiệu ứng chớp nháy báo động
    for i = 1, 10 do
        screenOverlay.Transparency = 0
        task.wait(0.05)
        screenOverlay.Transparency = 0.8
        task.wait(0.05)
    end
    
    -- S4: Fake Ban
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Text = "\n\n❌ TÀI KHOẢN ĐÃ BỊ TẠM KHÓA\n\nTài khoản của bạn đã bị đình chỉ 72 giờ do sử dụng phần mềm gian lận / can thiệp trái phép.\n\nMã lỗi: #RBX-BAN-9921"
end)

