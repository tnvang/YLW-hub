local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- 1. Tự động khởi tạo giao diện Full Màn Hình Đen ngay khi chạy
local screenGui = script.Parent
screenGui.IgnoreGuiInset = true -- Đảm bảo đè toàn bộ màn hình

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgFrame.BorderSizePixel = 0
bgFrame.Parent = screenGui

-- Khởi tạo khu vực chạy mã code xanh
local codeLabel = Instance.new("TextLabel")
codeLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
codeLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
codeLabel.BackgroundTransparency = 1
codeLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
codeLabel.TextFont = Enum.Font.Code
codeLabel.TextSize = 16
codeLabel.TextXAlignment = Enum.TextXAlignment.Left
codeLabel.TextYAlignment = Enum.TextYAlignment.Top
codeLabel.Parent = bgFrame

-- Khởi tạo khu vực hiển thị thông báo tiến trình công việc
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
statusLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextSize = 24
statusLabel.TextWrapped = true
statusLabel.Parent = bgFrame

-- Các đoạn mã giả lập hiển thị lỗi hệ thống
local errorCodes = {
	"CRITICAL_ERROR: Memory address violation at 0x00F3A2",
	"Anti-Cheat Core: Scanning suspicious memory threads...",
	"Warning: Unregistered script execution detected.",
	"Packet Manipulation identified on active channel.",
	"Dumping local environment variables for analysis...",
	"Error 404: Game assets corrupted by third-party injector."
}

-- 1. Hàm chạy hiệu ứng dòng mã xanh như bị lỗi
local function runMatrixError()
	task.spawn(function()
		while codeLabel.Visible do
			local textLines = ""
			for i = 1, 12 do
				textLines = textLines .. errorCodes[math.random(1, #errorCodes)] .. "\n"
			end
			codeLabel.Text = textLines
			task.wait(0.15)
		end
	end)
end

-- Hàm thực thi chuỗi sự kiện kịch bản troll
local function startTrollSequence()
	-- BƯỚC 1: Hiện dòng code xanh liên tục
	runMatrixError()
	
	-- BƯỚC 2: Thông báo Anti-cheat phát hiện gian lận
	statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
	statusLabel.Text = "[HỆ THỐNG ANTI-CHEAT]: Phát hiện phần mềm gian lận đang can thiệp vào trò chơi!"
	task.wait(3.5)
	
	-- BƯỚC 3: Thông báo đang gửi báo cáo
	statusLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
	statusLabel.Text = "⏳ Đang tiến hành thu thập bằng chứng và báo cáo tài khoản [" .. localPlayer.Name .. "] với mục đích gian lận lên hệ thống..."
	task.wait(4)
	
	statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	statusLabel.Text = "✔ Gửi dữ liệu báo cáo thành công! Mã tiến trình: #RBX-" .. math.random(100000, 999999)
	task.wait(2.5)
	
	-- BƯỚC 4: Hiển thị giao diện Fake Ban + HIỆU ỨNG CHỚP NHÁY BÁO ĐỘNG
	codeLabel.Visible = false -- Ẩn mã xanh đi
	statusLabel.Text = "" -- Tạm ẩn chữ khi đang chớp nháy
	
	-- Vòng lặp làm mờ/chớp nháy màn hình đỏ đen (Chớp nháy 6 lần)
	for i = 1, 6 do
		bgFrame.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Đỏ rực
		task.wait(0.1)
		bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Đen
		task.wait(0.1)
	end
	
	-- Sau khi chớp nháy xong, trả về giao diện bảng Ban cố định giống thật
	bgFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Màu nền xám đen mặc định của Roblox
	
	statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	statusLabel.TextXAlignment = Enum.TextXAlignment.Center
	statusLabel.TextSize = 22
	statusLabel.Text = "❌ Bạn đã bị ngắt kết nối\n\n" ..
		"Tài khoản cá nhân của bạn đã bị đình chỉ hoạt động tạm thời.\n" ..
		"Lý do: Sử dụng phần mềm gian lận / Can thiệp dữ liệu trò chơi.\n" ..
		"Thời gian khóa: 72 giờ.\n\n" ..
		"(Vui lòng tuân thủ điều khoản để tránh bị khóa vĩnh viễn)"
end

-- Kích hoạt chạy ngay lập tức khi người chơi load xong script
startTrollSequence()

