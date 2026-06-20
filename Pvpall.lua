local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Huhu hub",
   LoadingTitle = "Dang tai Huhu hub...",
   LoadingSubtitle = "by Nvang m8",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HuhuHubConfig",
      FileName = "HuhuHub"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
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

local LP = game.Players.LocalPlayer

-- ================= TAB CHUC NANG =================
local MainTab = Window:CreateTab("🎯 Chuc Nang", 4483362458)

local AimbotToggle = MainTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Flag = "Aimbot",
   Callback = function(Value)
      Configs.Aimbot = Value
      if Value then
          -- Code logic Aimbot hoac lock camera vao day
      end
   end,
})

local TangHinhToggle = MainTab:CreateToggle({
   Name = "Tang hinh",
   CurrentValue = false,
   Flag = "TangHinh",
   Callback = function(Value)
      Configs.TangHinh = Value
      if LP.Character and LP.Character:FindFirstChild("LowerTorso") then
          -- Logic lam mo hoac an cac part cua nhan vat
      end
   end,
})

local KillAuraToggle = MainTab:CreateToggle({
   Name = "KillAura",
   CurrentValue = false,
   Flag = "KillAura",
   Callback = function(Value)
      Configs.KillAura = Value
      if Value then
          -- Vong lap tu dong tan cong o day
      end
   end,
})

local NoclipToggle = MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
      Configs.NoClip = Value
      game:GetService("RunService").Stepped:Connect(function()
          if Configs.NoClip and LP.Character then
              for _, v in pairs(LP.Character:GetDescendants()) do
                  if v:IsA("BasePart") then
                      v.CanCollide = false
                  end
              end
          end
      end)
   end,
})

-- ================= TAB DI CHUYEN =================
local MoveTab = Window:CreateTab("⚡ Di Chuyen", 4483362534)

local WSSlider = MoveTab:CreateSlider({
   Name = "Walkspeed",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WS",
   Callback = function(Value)
      Configs.WalkSpeed = Value
      if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
          LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
      end
   end,
})

local JPSlider = MoveTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 300},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JP",
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
   Flag = "InfJump",
   Callback = function(Value)
      Configs.InfJump = Value
      game:GetService("UserInputService").JumpRequest:Connect(function()
          if Configs.InfJump and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
              LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
          end
      end)
   end,
})

-- Giu chi so Walkspeed va JumpPower khi xnk hoi sinh
LP.CharacterAdded:Connect(function(Char)
    local Hum = Char:WaitForChild("Humanoid")
    task.wait(0.5)
    Hum.WalkSpeed = Configs.WalkSpeed
    Hum.JumpPower = Configs.JumpPower
end)

-- ================= TAB NGUOI CHOI =================
local PlayerTab = Window:CreateTab("👥 Nguoi Choi", 4483362748)

local HitboxToggle = PlayerTab:CreateToggle({
   Name = "Hitbox",
   CurrentValue = false,
   Flag = "Hitbox",
   Callback = function(Value)
      Configs.Hitbox = Value
      if Value then
          -- Code mo rong HumanoidRootPart cua doi thu o day
      end
   end,
})

local EspToggle = PlayerTab:CreateToggle({
   Name = "Esp va hien ten",
   CurrentValue = false,
   Flag = "EspName",
   Callback = function(Value)
      Configs.Esp = Value
      if Value then
          -- Code ve Box ESP hoac Highlight kem theo BillboardGui hien ten o day
      end
   end,
})

-- Lay danh sach nguoi choi trong server
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
   Flag = "PlayerList",
   Callback = function(Option)
      Configs.SelectedPlayer = Option
   end,
})

-- Nut lam moi danh sach neu co nguoi ra vao server
local RefreshButton = PlayerTab:CreateButton({
   Name = "Lam moi danh sach",
   Callback = function()
       PlayerDropdown:Refresh(GetPlayerNames())
   end,
})

local TeleportButton = PlayerTab:CreateButton({
   Name = "Bay lai nguoi choi da chon",
   Callback = function()
       if Configs.SelectedPlayer ~= "" then
           local Target = game.Players:FindFirstChild(Configs.SelectedPlayer)
           if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
               LP.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
               Rayfield:Notify({Title = "Huhu hub", Content = "Da bay den gan " .. Configs.SelectedPlayer, Duration = 2})
           else
               Rayfield:Notify({Title = "Loi", Content = "Khong tim thay muc tieu hoac nhan vat chua load!", Duration = 2})
           end
       else
           Rayfield:Notify({Title = "Chu y", Content = "Vui long chon 1 nguoi choi tu danh sach truoc!", Duration = 2})
       end
   end,
})

-- ================= TAB TAC GIA =================
local AuthorTab = Window:CreateTab("👑 Tac Gia", 4483362000)

AuthorTab:CreateParagraph({Title = "Ten menu", Content = "Huhu hub"})
AuthorTab:CreateParagraph({Title = "Ten tgia", Content = "Nvang m8"})

-- Phan gioi thieu khong dau hoan toan theo yeu cau
AuthorTab:CreateParagraph({
    Title = "Phan gioi thieu", 
    Content = "Menu dc lam vao ngay 20 thang 6 nam 2026\n\nNeu ban muon script game ban thich thi tim id tiktok ditnatbuombn\n\nTac gia la 1 nguoi sigma boy cu to ban linh tu tin diem tinh"
})

