local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = game.Players.LocalPlayer

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

-- ================= SỬA LỖI 1: INFINITE JUMP (ẢNH 1000001911_2.JPG) =================
-- Đưa kết nối sự kiện ra ngoài vòng lặp/toggle để tránh tạo nhiều kết nối gây lag bộ nhớ
UIS.JumpRequest:Connect(function()
    if Configs.InfJump and LP.Character then
        local Hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if Hum then
            Hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ================= SỬA LỖI 2: NOCLIP TỐI ƯU (ẢNH 1000001912.JPG) =================
-- Sử dụng ipairs và GetChildren thay vì GetDescendants để giảm tải tài nguyên hệ thống
RunService.Stepped:Connect(function()
    if Configs.NoClip and LP.Character then
        for _, v in ipairs(LP.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Vòng lặp quản lý trạng thái Hitbox (Bật/Tắt khôi phục như ảnh 1000001916.jpg)
task.spawn(function()
    while task.wait(0.5) do
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= LP and player.Character and player.Character:FindFirstChild("Head") then
                if Configs.Hitbox then
                    player.Character.Head.Size = Vector3.new(5, 5, 5)
                    player.Character.Head.Transparency = 0.5
                    player.Character.Head.CanCollide = false
                else
                    player.Character.Head.Size = Vector3.new(2, 1, 1)
                    player.Character.Head.Transparency = 0
                    player.Character.Head.CanCollide = true
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
   Callback = function(Value)
      Configs.InfJump = Value
   end,
})

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

local function GetPlayerNames()
    local list = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= LP then
            table.insert(list, p.Name)
        end
    end
    return list
end

-- ================= SỬA LỖI 3: DROPDOWN TYPECHECK (ẢNH 1000001913.JPG) =================
local PlayerDropdown = PlayerTab:CreateDropdown({
   Name = "Hien thi danh sach nguoi choi",
   Options = GetPlayerNames(),
   CurrentOption = "",
   Flag = "PlayerList",
   Callback = function(Option)
      -- Xử lý trường hợp Rayfield trả về kiểu bảng thay vì chuỗi đơn lẻ
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

-- ================= SỬA LỖI 4: TELEPORT AN TOÀN (ẢNH 1000001913.JPG) =================
PlayerTab:CreateButton({
   Name = "Bay lai nguoi choi da chon",
   Callback = function()
       local targetName = Configs.SelectedPlayer
       local Target = game.Players:FindFirstChild(targetName)
       if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
           -- Thay đổi offset thành CFrame.new(0, 3, 0) để nhân vật xuất hiện phía trên đầu mục tiêu, tránh bị kẹt
           LP.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
           Rayfield:Notify({Title = "Huhu hub", Content = "Da bay den " .. targetName, Duration = 2})
       else
           Rayfield:Notify({Title = "Loi", Content = "Vui long chon nguoi choi hop le!", Duration = 2})
       end
   end,
})

-- ================= TAB TÁC GIẢ =================
local AuthorTab = Window:CreateTab("👑 Tac Gia", 4483362000)
AuthorTab:CreateParagraph({Title = "Ten menu", Content = "Huhu hub"})
AuthorTab:CreateParagraph({Title = "Ten tgia", Content = "Nvang m8"})
AuthorTab:CreateParagraph({
    Title = "Phan gioi thieu", 
    Content = "Menu dc lam vao ngay 20 thang 6 nam 2026\n\nNeu ban muon script game ban thich thi tim id tiktok ditnatbuombn\n\nTac gia la 1 nguoi sigma boy cu to ban linh tu tin diem tinh"
})

