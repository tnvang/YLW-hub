local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- 1. Tạo Giao diện (GUI)
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "PortalGui"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 205, 0, 60)
frame.Position = UDim2.new(0.5, -102, 0.4, -30)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- --- CODE KÉO THẢ MƯỢT MÀ ---
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true; dragStart = input.Position; startPos = frame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
-- ---------------------------------

-- Kho dữ liệu hệ thống
local portals = { [1] = {}, [2] = {}, [3] = {} }
local debounces = { [1] = false, [2] = false, [3] = false }
local currentSelectedId = nil -- ID cổng đang được chọn để xem trước

-- 2. Tạo Cổng Mờ Xem Trước (Preview Portal)
local previewPortal = Instance.new("Part")
previewPortal.Size = Vector3.new(4, 6, 0.5)
previewPortal.Anchored = true
previewPortal.CanCollide = false
previewPortal.Material = Enum.Material.Neon
previewPortal.Transparency = 0.7 -- Làm mờ 70%
previewPortal.Parent = workspace
previewPortal.Transparency = 1 -- Ẩn đi mặc định khi chưa chọn

-- Cập nhật vị trí cổng mờ liên tục trước mặt nhân vật
RunService.RenderStepped:Connect(function()
	if currentSelectedId and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		previewPortal.CFrame = hrp.CFrame * CFrame.new(0, 0, -6)
		previewPortal.Transparency = 0.6
		
		local id = currentSelectedId
		previewPortal.Color = (id == 1 and Color3.fromRGB(255, 50, 50)) or (id == 2 and Color3.fromRGB(50, 255, 50)) or Color3.fromRGB(50, 50, 255)
	else
		previewPortal.Transparency = 1
	end
end)

-- Hàm xóa một cặp cổng cụ thể
local function deletePortalPair(id)
	if portals[id] then
		for _, p in pairs(portals[id]) do
			p:Destroy()
		end
		portals[id] = {}
	end
end

-- Hàm tạo cổng chính thức
local function createPortal(id)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	
	-- Nếu đã đủ 2 cổng, xóa đi để reset lại cặp mới
	if #portals[id] >= 2 then
		deletePortalPair(id)
	end
	
	local p = Instance.new("Part")
	p.Size = Vector3.new(4, 6, 0.5)
	p.CFrame = previewPortal.CFrame -- Đặt ngay tại vị trí cổng mờ đang hiện
	p.Anchored = true
	p.CanCollide = false
	p.Material = Enum.Material.Neon
	p.Color = previewPortal.Color
	p.Parent = workspace
	
	-- --- THÊM CHỮ HIỂN THỊ SỐ TRÊN ĐẦU CỔNG ---
	local bgui = Instance.new("BillboardGui", p)
	bgui.Size = UDim2.new(0, 50, 0, 50)
	bgui.StudsOffset = Vector3.new(0, 4, 0) -- Hiện cao hơn cổng 4 block
	bgui.AlwaysOnTop = true
	
	local tl = Instance.new("TextLabel", bgui)
	tl.Size = UDim2.new(1, 0, 1, 0)
	tl.BackgroundTransparency = 1
	tl.Text = tostring(id)
	tl.TextSize = 24
	tl.Font = Enum.Font.SourceSansBold
	tl.TextColor3 = p.Color
	-- ------------------------------------------
	
	table.insert(portals[id], p)
	
	-- Xử lý va chạm dịch chuyển độc lập
	p.Touched:Connect(function(hit)
		if debounces[id] then return end
		if player.Character and hit.Parent == player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			
			for _, other in ipairs(portals[id]) do
				if other ~= p then
					debounces[id] = true
					hrp.CFrame = other.CFrame * CFrame.new(0, 0, -4) * CFrame.Angles(0, math.pi, 0)
					task.wait(1.5)
					debounces[id] = false
					break
				end
			end
		end
	end)
end

-- 3. Tạo các nút bấm cổng (1, 2, 3) có tích hợp Nhấn Giữ để xóa
for i = 1, 3 do
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0, 40, 0, 40)
	btn.Position = UDim2.new(0, (i-1)*45 + 10, 0, 10)
	btn.Text = tostring(i)
	btn.TextSize = 18
	btn.Font = Enum.Font.SourceSansBold
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = (i == 1 and Color3.fromRGB(200, 40, 40)) or (i == 2 and Color3.fromRGB(40, 200, 40)) or Color3.fromRGB(40, 40, 200)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	-- Xử lý Nhấn Giữ (Hold) bằng thời gian hệ thống
	local pressStartTime = 0
	local holding = false
	
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			currentSelectedId = i -- Bật cổng mờ xem trước của số này lên
			pressStartTime = tick()
			holding = true
			
			-- Tạo vòng lặp nhỏ kiểm tra nếu giữ đủ 1 giây thì xóa cổng
			task.spawn(function()
				while holding do
					if tick() - pressStartTime >= 1 then -- Giữ 1 giây
						deletePortalPair(i) -- Xóa cặp cổng tương ứng
						currentSelectedId = nil
						holding = false
						-- Đổi màu tạm thời báo hiệu đã xóa thành công
						local oldColor = btn.BackgroundColor3
						btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
						task.wait(0.3)
						btn.BackgroundColor3 = oldColor
						break
					end
					task.wait(0.1)
				end
			end)
		end
	end)
	
	btn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if holding then
				holding = false
				-- Nếu thời gian nhấn nhanh dưới 1 giây thì là ĐẶT CỔNG
				if tick() - pressStartTime < 1 then
					createPortal(i)
				end
				currentSelectedId = nil
			end
		end
	end)
end

-- 4. Tạo nút "Clear" để xóa tất cả các cổng
local clearBtn = Instance.new("TextButton", frame)
clearBtn.Size = UDim2.new(0, 55, 0, 40)
clearBtn.Position = UDim2.new(0, 140, 0, 10)
clearBtn.Text = "Clear"
clearBtn.TextSize = 16
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)

clearBtn.MouseButton1Click:Connect(function()
	for id = 1, 3 do
		deletePortalPair(id)
	end
	currentSelectedId = nil
end)

