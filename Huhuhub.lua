local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Huhu hub | Đấu Trường Kỹ Năng",
   LoadingTitle = "Đang tải...",
   LoadingSubtitle = "by Huhu hub",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local Tab = Window:CreateTab("Chức Năng", nil)

Tab:CreateToggle({
   Name = "Tấn Công Nhanh (30/s)",
   CurrentValue = false,
   Callback = function(Value)
      _G.FastAttack = Value
      while _G.FastAttack do
         local myChar = game.Players.LocalPlayer.Character
         local tool = myChar and myChar:FindFirstChildOfClass("Tool")
         if tool then
            for i = 1, 30 do tool:Activate() end
         end
         task.wait(0.1)
      end
   end
})

Tab:CreateToggle({
   Name = "Auto Aim & Skill",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoAim = Value
      while _G.AutoAim do
         local target = nil
         local dist = math.huge
         for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
               local d = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
               if d < dist then dist = d; target = p end
            end
         end
         
         if target then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position)
         end
         task.wait(0.1)
      end
   end
})

Rayfield:LoadConfiguration()

