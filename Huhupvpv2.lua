local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Window = Rayfield:CreateWindow({
   Name = "Huhu hub",
   LoadingTitle = "Dang tai Huhu hub...",
   LoadingSubtitle = "by Nvang m8",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HuhuHubConfig",
      FileName = "HuhuHub"
   },
   KeySystem = false
})

-- Cac bien trang thai logic
local Configs = {
   Aimbot = false,
   TangHinh = false,
   KillAura = false,
   NoClip = false,
   WalkSpeed = 16,
   JumpPower = 50,
   InfJump = false,
   Hitbox = false,
   Esp = false,
   SelectedPlayer = ""
}

-- ================= CÁC HÀM XỬ LÝ LOGIC THỰC TẾ =================

-- 1. Hàm tìm người chơi gần tâm màn hình nhất (Aimbot)
local function GetClosestPlayer()
    local MaximumDistance = 2000
    local Target = nil
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local Distance = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if Distance < MaximumDistance then
                local _, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                if OnScreen then
                    Target = v
                    MaximumDistance = Distance
                end
            end
        end
    end
    return Target
end

-- 2. Khởi tạo chức năng ESP (Vẽ khung và Hiện tên thương mại)
local function CreateESP(player)
    if player == LP then return end
    
    local function ApplyESP(character)
        if not character then return end
        local hrp = character:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        -- Tạo BillboardGui để hiện tên người chơi
        local bgui = Instance.new("BillboardGui")
        bgui.Name = "HuhuESP_Name"
        bgui.AlwaysOnTop = true
        bgui.Size = UDim2.new(0, 200, 0, 50)
        bgui.StudsOffset = Vector3.new(0, 3, 0)
        bgui.Adornee = hrp

        local textLabel = Instance.new("TextLabel", bgui)
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = player.Name
        textLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Màu đỏ nổi bật
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.SourceSansBold
        bgui.Parent = hrp

        -- Tạo Highlight để làm khung bao bọc phát sáng xuyên tường
        local highlight = Instance.new("Highlight")
        highlight.Name = "HuhuESP_Box"
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        
        -- Kiểm tra trạng thái Bật/Tắt của ESP ban đầu
        bgui.Enabled = Configs.Esp
        highlight.Enabled = Configs.Esp
    end

    if player.Character then ApplyESP(player.Character) end
    player.CharacterAdded:Connect(ApplyESP)
end

-- Kích hoạt ESP cho toàn bộ người chơi hiện tại và người chơi mới vào phòng
for _, p in ipairs(game.Players:GetPlayers()) do CreateESP(p) end
game.Players.PlayerAdded:Connect(CreateESP)


-- ================= VÒNG LẶP HỆ THỐNG (RENDERING LOOPS) =================

RunService.RenderStepped:Connect(function()
    -- Vòng lặp khóa mục tiêu (Aimbot)
    if Configs.Aimbot then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.HumanoidRootPart.Position)
        end
    end

    -- Vòng lặp quản lý Tàng Hình (Client-side)
    if LP.Character then
        for _, part in ipairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if Configs.TangHinh then
                    if part.Name ~= "HumanoidRootPart" then
                        part.Transparency = 1 -- Ẩn hoàn toàn nhân vật của mình
                    end
                else
                    if part:IsA("Decal") then part.Transparency = 0
                    elseif part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
                        part.Transparency = 0 -- Khôi phục khi tắt
                    end
                end
            end
        end
    end
end)

-- Vòng lặp Noclip tối ưu tài nguyên
RunService.Stepped:Connect(function()
    if Configs.NoClip and LP.Character then
        for _, v in ipairs(LP.Character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Vòng lặp quản lý trạng thái Hitbox cỡ lớn 6m (20 Studs) quanh người chơi
task.spawn(function()
    while task.wait(0.5) do
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local head = player.Character:FindFirstChild("Head") or player.Character:WaitForChild("Head", 2)
                if head then
                    if Configs.Hitbox then
                        head.Size = Vector3.new(20, 20, 20)
                        head.Transparency = 0.7
                        head.CanCollide = false
                    else
                        head.Size = Vector3.new(2, 1, 1)
                        head.Transparency = 0
                        head.CanCollide = true
                    end
                end
            end
        end
    end
end)

-- Nhảy vô hạn (Infinite Jump)
UIS.JumpRequest:Connect(function()
    if Configs.InfJump and LP.Character then
        local Hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)


-- ================= GIAO DIỆN MENU RAYFIELD =================
local MainTab = Window:CreateTab("🎯 Chuc Nang", 4483362458)

MainTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Callback = function(Value) Configs.Aimbot = Value end,
})

MainTab:CreateToggle({
   Name = "Tang hinh",
   CurrentValue = false,
   Callback = function(Value) Configs.TangHinh = Value end,
})

MainTab:CreateToggle({
   Name = "KillAura",
   CurrentValue = false,
   Callback = function(Value) Configs.KillAura = Value end,
})

MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value) Configs.NoClip = Value end,
})

local MoveTab = Window:CreateTab("⚡ Di Chuyen", 4483362534)

MoveTab:CreateSlider({
   Name = "Walkspeed",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      Configs.WalkSpeed = Value
      if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
          LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
      end
   end,
})

MoveTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 300},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
      Configs.JumpPower = Value
      if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
          LP.Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
      end
   end,
})

MoveTab:CreateToggle({
   Name = "InfiniteJump",
   CurrentValue = false,
   Callback = function(Value) Configs.InfJump = Value end,
})

LP.CharacterAdded:Connect(function(Char)
    local Hum = Char:WaitForChild("Humanoid")
    task.wait(0.5)
    Hum.WalkSpeed = Configs.WalkSpeed
    Hum.JumpPower = Configs.JumpPower
end)

local PlayerTab = Window:CreateTab("👥 Nguoi Choi", 4483362748)

PlayerTab:CreateToggle({
   Name = "Hitbox",
   CurrentValue = false,
   Callback = function(Value) Configs.Hitbox = Value end,
})

PlayerTab:CreateToggle({
   Name = "Esp va hien ten",
   CurrentValue = false,
   Callback = function(Value)
       Configs.Esp = Value
       -- Cập nhật ẩn/hiển thị ESP ngay lập tức khi gạt nút bấm
       for _, p in ipairs(game.Players:GetPlayers()) do
           if p.Character then
               local hrp = p.Character:FindFirstChild("HumanoidRootPart")
               local box = p.Character:FindFirstChild("HuhuESP_Box")
               if hrp and hrp:FindFirstChild("HuhuESP_Name") then
                   hrp.HuhuESP_Name.Enabled = Value
               end
               if box then box.Enabled = Value end
           end
       end
   end,
})

local function GetPlayerNames()
    local list = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= LP then table.insert(list, p.Name) end
    end
    return list
end

local PlayerDropdown = PlayerTab:CreateDropdown({
   Name = "Hien thi danh sach nguoi choi",
   Options = GetPlayerNames(),
   CurrentOption = "",
   Flag = "PlayerList",
   Callback = function(Option)
      if typeof(Option) == "table" then Configs.SelectedPlayer = Option[1] else Configs.SelectedPlayer = Option end
   end,
})

PlayerTab:CreateButton({
   Name = "Lam moi danh sach",
   Callback = function() PlayerDropdown:Refresh(GetPlayerNames()) end,
})

PlayerTab:CreateButton({
   Name = "Bay lai nguoi choi da chon",
   Callback = function()
       local targetName = Configs.SelectedPlayer
       local Target = game.Players:FindFirstChild(targetName)
       if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
           LP.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
           Rayfield:Notify({Title = "Huhu hub", Content = "Da bay den " .. targetName, Duration = 2})
       else
           Rayfield:Notify({Title = "Loi", Content = "Vui long chon nguoi choi hop le tu danh sach!", Duration = 2})
       end
   end,
})

local AuthorTab = Window:CreateTab("👑 Tac Gia", 4483362000)
AuthorTab:CreateParagraph({Title = "Ten menu", Content = "Huhu hub"})
AuthorTab:CreateParagraph({Title = "Ten tgia", Content = "Nvang m8"})
AuthorTab:CreateParagraph({
    Title = "Phan gioi thieu", 
    Content = "Menu dc lam vao ngay 20 thang 6 nam 2026\n\nNeu ban muon script game ban thich thi tim id tiktok ditnatbuombn\n\nTac gia la 1 nguoi sigma boy cu to ban linh tu tin diem tinh"
})

