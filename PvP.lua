local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
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

-- ================= VÒNG LẶP ĐỒNG BỘ (RENDER LOOPS) =================
-- Xu ly Noclip lien tuc de tranh bi game ghi de
RunService.Stepped:Connect(function()
    if Configs.NoClip and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Xu ly Hitbox (Bật thì to ra, Tắt thì khôi phục ban đầu)
task.spawn(function()
    while task.wait(0.5) do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LP and player.Character and player.Character:FindFirstChild("Head") then
                if Configs.Hitbox then
                    player.Character.Head.Size = Vector3.new(5, 5, 5)
                    player.Character.Head.Transparency = 0.5
                    player.Character.Head.CanCollide = false
                else
                    -- Khoi phuc kich thuoc mac dinh nhu anh 1000001911.jpg chi ra
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

local InfJumpToggle = MoveTab:CreateToggle({
   Name = "InfiniteJump",
   CurrentValue = false,
   Callback = function(Value)
      Configs.InfJump = Value
      game:GetService("UserInputService").JumpRequest:Connect(function()
          if Configs.InfJump and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
              LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
          end
      end)
   end,
})

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

-- Xu ly danh sach nguoi choi cho Dropdown nhu anh 1000001910.jpg
local function GetPlayerNames()
    local list = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LP then
            table.insert(list, p.Name)
        end
    end
    return list
end

local PlayerDropdown = PlayerTab:CreateDropdown({
   Name = "Hien thi danh sach nguoi choi",
   Options = GetPlayerNames(),
   CurrentOption = "",
   Flag = "PlayerList", -- Dong bo dung Flag de Teleport dung nhan vat
   Callback = function(Option)
      Configs.SelectedPlayer = Option
   end,
})

PlayerTab:CreateButton({
   Name = "Lam moi danh sach",
   Callback = function()
       PlayerDropdown:Refresh(GetPlayerNames())
   end,
})

PlayerTab:CreateButton({
   Name = "Bay lai nguoi choi da chon",
   Callback = function()
       local targetName = Configs.SelectedPlayer
       local Target = game.Players:FindFirstChild(targetName)
       if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
           LP.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
           Rayfield:Notify({Title = "Huhu hub", Content = "Da bay den " .. targetName, Duration = 2})
       else
           Rayfield:Notify({Title = "Loi", Content = "Vui long chon nguoi choi hoac muc tieu chua load!", Duration = 2})
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
