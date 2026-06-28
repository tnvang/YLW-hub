-- [[ EXECUTOR INVISIBLE TOGGLE SCRIPT ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

local isInvisible = false
local savedPosition = nil

-- Hàm xử lý tàng hình nâng cao cho các Trình thực thi (Executor)
local function ToggleExecutorInvisible(state)
	local character = localPlayer.Character
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	
	if state then
		-- BẬT TÀNG HÌNH (Phá khớp nối để đánh lừa Server)
		savedPosition = rootPart.CFrame
		
		-- Ẩn phần tên hiển thị
		if humanoid then
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end
		
		-- Làm mờ/Ẩn các bộ phận ở máy mình (để biết là đang bật)
		for _, obj in ipairs(character:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
				obj.Transparency = 0.5
			elseif obj:IsA("Decal") then
				obj.Transparency = 0.5
			end
		end
		
		-- Đánh lừa Server: Tách HumanoidRootPart ra khỏi cơ thể
		-- Đối với người khác, bạn sẽ đứng yên hoặc biến mất dưới đất, nhưng bạn vẫn di chuyển được
		if character:FindFirstChild("LowerTorso") then
			local rootJoint = character.LowerTorso:FindFirstChild("Root")
			if rootJoint then rootJoint:Destroy() end
		elseif character:FindFirstChild("Torso") then
			local rootJoint = character.Torso:FindFirstChild("RootJoint")
			if rootJoint then rootJoint:Destroy() end
		end
	else
		-- TẮT TÀNG HÌNH (Reset lại nhân vật để hiện hình)
		-- Vì đã phá khớp nối, cách duy nhất để hiện hình chuẩn là hồi sinh lại
		localPlayer:CharacterReset()
	end
end

-- --- TỰ ĐỘNG KHỞI TẠO NÚT BẤM KÉO THẢ ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExecInvisibleGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0.1, 0, 0.2, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(240, 50, 50) -- Màu đỏ (TẮT)
toggleButton.Text = "Tàng Hình: TẮT"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 14
toggleButton.Active = true
toggleButton.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = toggleButton

-- Logic khi nhấn nút
toggleButton.MouseButton1Click:Connect(function()
	isInvisible = not isInvisible
	
	if isInvisible then
		toggleButton.Text = "Tàng Hình: BẬT"
		toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Màu xanh
		ToggleExecutorInvisible(true)
	else
		toggleButton.Text = "Tàng Hình: TẮT"
		toggleButton.BackgroundColor3 = Color3.fromRGB(240, 50, 50)
		ToggleExecutorInvisible(false)
	end
end)

-- --- HỆ THỐNG KÉO DI CHUYỂN NÚT BẤM (HỖ TRỢ CẢ PC & ĐIỆN THOẠI) ---
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

toggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = toggleButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

toggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

