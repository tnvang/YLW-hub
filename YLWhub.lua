local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "YLW HUB | Blox Fruits",
   LoadingTitle = "YLW System Premium",
   LoadingSubtitle = "by tnvang",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "YLW_Configs",
      FileName = "MainHub"
   }
})

-- Main Tab for Farming
local MainTab = Window:CreateTab("Auto Farm", 4483362458) 

MainTab:CreateSection("Level Farming")

MainTab:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Flag = "FarmLevel", 
   Callback = function(Value)
      _G.AutoFarm = Value
      print("Auto Farm status: ", Value)
   end,
})

MainTab:CreateToggle({
   Name = "Auto Clicker",
   CurrentValue = false,
   Flag = "AutoClick",
   Callback = function(Value)
      _G.AutoClick = Value
   end,
})

-- Player Tab for Character Stats
local PlayerTab = Window:CreateTab("Character", 4483362458)

PlayerTab:CreateSection("Movement Settings")

PlayerTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 500},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

PlayerTab:CreateSlider({
   Name = "Jump Height",
   Range = {50, 500},
   Increment = 1,
   Suffix = " Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

-- Notification
Rayfield:Notify({
   Title = "YLW HUB LOADED",
   Content = "Welcome back, tnvang!",
   Duration = 5,
   Image = 4483362458,
})
