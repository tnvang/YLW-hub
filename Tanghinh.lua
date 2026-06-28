-- [[ INVISIBLE TOGGLE SCRIPT - SINGLE SCRIPT INTEGRATION ]] --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- 1. TỰ ĐỘNG KHỞI TẠO REMOTE EVENT (CHẠY TRÊN SERVER)
if RunService:IsServer() then
	local invisibleEvent = ReplicatedStorage:FindFirstChild("InvisibleEvent") or Instance.new("RemoteEvent")
	invisibleEvent.Name = "InvisibleEvent"
	invisibleEvent.Parent = ReplicatedStorage

	local function SetInvisible(character, invisible)
		if not character then return end
		for _, obj in ipairs(character:GetDescendants()) do
			if obj:IsA("BasePart") then
				if obj.Name ~= "HumanoidRootPart" then obj.Transparency = invisible and 1 or 0 end
				obj.CastShadow = not invisible
			elseif obj:IsA("Decal") or obj:IsA("Texture") then
				obj.Transparency = invisible and 1 or 0
			elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
				obj.Enabled = not invisible
			end
		end
		local head = character:FindFirstChild("Head")
		if head then
			for _, child in ipairs(head:GetChildren()) do
				if child:IsA("Decal") then child.Transparency = invisible and 1 or 0 end
			end
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.DisplayDistanceType = invisible and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
		end
	end

	invisibleEvent.OnServerEvent:Connect(function(player, invisibleState)
		if player.Character then SetInvisible(player.Character, invisibleState) end
	end)

-- 2. TỰ ĐỘNG KHỞI TẠO GUI & LOGIC KÉO THẢ (CHẠY TRÊN CLIENT)
elseif RunService:IsClient() then
	local UserInputService = game:GetService("UserInputService")
	local localPlayer = Players.LocalPlayer
	local invisibleEvent = ReplicatedStorage:WaitForChild("InvisibleEvent")
	local isInvisible = false

	localPlayer.CharacterAdded:Connect(function()
		task.wait(0.5)
		invisibleEvent:FireServer(isInvisible)
	end)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "InvisibleToggleGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

	local toggleButton = Instance.new("TextButton")
	toggleButton.Size = UDim2.new(0, 110, 0, 40)
	toggleButton.Position = UDim2.new(0.1, 0, 0.2, 0)
	toggleButton.BackgroundColor3 = Color3.fromRGB(240, 50, 50)
	toggleButton.Text = "Tàng Hình: TẮT"
	toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleButton.Font = Enum.Font.SourceSansBold
	toggleButton.TextSize = 14
	toggleButton.Active = true
	toggleButton.Parent = screenGui

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = toggleButton

	toggleButton.MouseButton1Click:Connect(function()
		isInvisible = not isInvisible
		toggleButton.Text = isInvisible and "Tàng Hình: BẬT" or "Tàng Hình: TẮT"
		toggleButton.BackgroundColor3 = isInvisible and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(240, 50, 50)
		invisibleEvent:FireServer(isInvisible)
	end)

	-- HỆ THỐNG KÉO DI CHUYỂN NÚT BẤM (DRAG)
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
end

