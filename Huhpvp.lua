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

-- ================= CÁC VÒNG LẶP HỆ THỐNG & TỐI ƯU =================

-- 1. Hàm tìm người chơi gần tâm màn hình nhất phục vụ cho Aimbot
local function GetClosestPlayer()
    local MaximumDistance = 2000
    local Target = nil

    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local Distance = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if Distance < MaximumDistance then
                local ScreenPosition, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                if OnScreen then
                    Target = v
                    MaximumDistance = Distance
                end
            end
        end
    end
    return Target
end

-- 2. Vòng lặp khóa Camera khi bật Aimbot (RenderStepped mượt mà)
RunService.RenderStepped:Connect(function()
    if Configs.Aimbot then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- 3. Đưa kết nối sự kiện Infinite Jump ra ngoài để tránh rò rỉ bộ nhớ gây lag
UIS.JumpRequest:Connect(function()
    if Configs.InfJump and LP.Character then
        local Hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if Hum then
            Hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 4. Vòng lặp Noclip tối ưu tài nguyên (Sử dụng ipairs và GetChildren)
RunService.Stepped:Connect(function()
    if Configs.NoClip and LP.Character then
        for _, v in ipairs(LP.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- 5. Vòng lặp quản lý trạng thái Hitbox cỡ lớn 6m (20 Studs) quanh người chơi
task.spawn(function()
    while task.wait(0.5) do
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= LP and player.Character then
                -- Đảm bảo nhân vật đã load xong để tránh lỗi người được người không
                local head = player.Character:FindFirstChild("Head") or player.Character:WaitForChild("Head", 2)
                
                if head then
                    if Configs.Hitbox then
                        head.Size = Vector3.new(20, 20, 20) -- Kích thước 6m bao bọc
                        head.Transparency = 0.7 -- Làm trong suốt để dễ nhìn
                        head.CanCollide = false
                    else
                        -- Khôi phục kích thước mặc định khi tắt toggle
                        head.Size = Vector3.new(2, 1, 1)
                        head.Transparency = 0
                        head.CanCollide = true
                    end
                end
            end
        end
    end
end)


-- ================= TAB CHUC NANG =================
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


-- ================= TAB DI CHUYEN =================
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

-- Tự động giữ chỉ số WalkSpeed và JumpPower khi hồi sinh
LP.CharacterAdded:Connect(function(Char)
    local Hum = Char:WaitForChild("Humanoid")
    task.wait(0.5)
    Hum.WalkSpeed = Configs.WalkSpeed
    Hum.JumpPower = Configs.JumpPower
end)


-- ================= TAB NGUOI CHOI =================
local PlayerTab = Window:CreateTab("👥 Nguoi Choi", 4483362748)

PlayerTab:CreateToggle({
   Name = "Hitbox",
   CurrentValue = false,
   Callback = function(Value) Configs.Hitbox = Value end,
})

PlayerTab:CreateToggle({
   Name = "Esp va hien ten",
   CurrentValue = false,
   Callback = function(Value) Configs.Esp = Value end,
})

-- Hàm lấy danh sách người chơi trong server
local function GetPlayerNames()
    local list = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= LP then
            table.insert(list, p.Name)
        end
    end
    return list
end

-- Dropdown hiển thị danh sách người chơi và xử lý kiểm tra kiểu dữ liệu (table/string) của Rayfield
local PlayerDropdown = PlayerTab:CreateDropdown({
   Name = "Hien thi danh sach nguoi choi",
   Options = GetPlayerNames(),
   CurrentOption = "",
   Flag = "PlayerList",
   Callback = function(Option)
      if typeof(Option) == "table" then
          Configs.SelectedPlayer = Option[1]
      else
          Configs.SelectedPlayer = Option
      end
   end,
})

PlayerTab:CreateButton({
   Name = "Lam moi danh sach",
   Callback = function()
       PlayerDropdown:Refresh(GetPlayerNames())
   end,
})

-- Nút Teleport an toàn, xuất hiện phía trên đầu (0, 3, 0) để không bị kẹt vào người chơi khác
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


-- ================= TAB TAC GIA =================
local AuthorTab = Window:CreateTab("👑 Tac Gia", 4483362000)

AuthorTab:CreateParagraph({Title = "Ten menu", Content = "Huhu hub"})
AuthorTab:CreateParagraph({Title = "Ten tgia", Content = "Nvang m8"})
AuthorTab:CreateParagraph({
    Title = "Phan gioi thieu", 
    Content = "Menu dc lam vao ngay 20 thang 6 nam 2026\n\nNeu ban muon script game ban thich thi tim id tiktok ditnatbuombn\n\nTac gia la 1 nguoi sigma boy cu to 18cm ban linh tu tin diem tinh"
})

