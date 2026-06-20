local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Huhu hub | Đấu Trường Kỹ Năng",
   LoadingTitle = "Menu Huhu hub đang tải...",
   LoadingSubtitle = "Tgia: Nvang",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local InfoTab = Window:CreateTab("Thông Tin", nil)
local CombatTab = Window:CreateTab("Chiến Đấu", nil)
local PlayerTab = Window:CreateTab("Người Chơi & ESP", nil)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

_G.FastAttackMaster = false
_G.DanhTayKhong = false
_G.DanhVuKhi = false
_G.AutoAim = false
_G.AimSkillLock = false
_G.EspPlayer = false

InfoTab:CreateSection("— CREDITS —")
InfoTab:CreateLabel("Menu: Huhu hub")
InfoTab:CreateLabel("Tác giả: Nvang")
InfoTab:CreateLabel("😎 Anh ấy rất đẹp trai và ngầu lòi sigma boy!")

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                local targetPos = player.Character.HumanoidRootPart.Position
                local distance = (myPos - targetPos).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

CombatTab:CreateToggle({
   Name = "Fast Attack (Công tắc tổng)",
   CurrentValue = false,
   Callback = function(Value)
      _G.FastAttackMaster = Value
      if not Value then
         _G.DanhTayKhong = false
         _G.DanhVuKhi = false
      end
   end
})

CombatTab:CreateToggle({
   Name = "-> Đánh tay không",
   CurrentValue = false,
   Callback = function(Value)
      if not _G.FastAttackMaster then _G.DanhTayKhong = false return end
      _G.DanhTayKhong = Value
      task.spawn(function()
         while _G.FastAttackMaster and _G.DanhTayKhong do
            local combatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("CombatRemote") or game:GetService("ReplicatedStorage"):FindFirstChild("Punch")
            if combatRemote and combatRemote:IsA("RemoteEvent") then
               for i = 1, 50 do combatRemote:FireServer() end
            end
            RunService.RenderStepped:Wait()
         end
      end)
   end
})

CombatTab:CreateToggle({
   Name = "-> Đánh dùng vũ khí",
   CurrentValue = false,
   Callback = function(Value)
      if not _G.FastAttackMaster then _G.DanhVuKhi = false return end
      _G.DanhVuKhi = Value
      task.spawn(function()
         while _G.FastAttackMaster and _G.DanhVuKhi do
            local myChar = LocalPlayer.Character
            local tool = myChar and myChar:FindFirstChildOfClass("Tool")
            if tool then
               for i = 1, 50 do tool:Activate() end
            end
            RunService.RenderStepped:Wait()
         end
      end)
   end
})

CombatTab:CreateToggle({
   Name = "Auto Aim (Quay người về mục tiêu)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoAim = Value
      task.spawn(function()
         while _G.AutoAim do
            local target = getClosestPlayer()
            if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               local targetPos = target.Character.HumanoidRootPart.Position
               LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                  LocalPlayer.Character.HumanoidRootPart.Position, 
                  Vector3.new(targetPos.X, LocalPlayer.Character.HumanoidRootPart.Position.Y, targetPos.Z)
               )
            end
            task.wait(0.01)
         end
      end)
   end
})

CombatTab:CreateToggle({
   Name = "Auto Aim Skill (Khóa tâm tung chiêu)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AimSkillLock = Value
      local Hook
      Hook = hookmetamethod(game, "__index", function(self, key)
         if _G.AimSkillLock and self == Mouse and (key == "Hit" or key == "Target") then
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
               if key == "Hit" then
                  return target.Character.HumanoidRootPart.CFrame
               elseif key == "Target" then
                  return target.Character.HumanoidRootPart
               end
            end
         end
         return Hook(self, key)
      end)
   end
})

PlayerTab:CreateToggle({
   Name = "Bật ESP Tên (Xuyên tường)",
   CurrentValue = false,
   Callback = function(Value)
      _G.EspPlayer = Value
      
      local function addEsp(player)
         if player == LocalPlayer then return end
         local function apply()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
               if not player.Character.HumanoidRootPart:FindFirstChild("EspBillboard") then
                  local bboard = Instance.new("BillboardGui", player.Character.HumanoidRootPart)
                  bboard.Name = "EspBillboard"
                  bboard.AlwaysOnTop = true
                  bboard.Size = UDim2.new(0, 200, 0, 50)
                  bboard.StudsOffset = Vector3.new(0, 3, 0)
                  
                  local label = Instance.new("TextLabel", bboard)
                  label.Size = UDim2.new(1, 0, 1, 0)
                  label.BackgroundTransparency = 1
                  label.Text = player.Name
                  label.TextColor3 = Color3.fromRGB(255, 0, 0)
                  label.TextSize = 14
                  label.Font = Enum.Font.SourceSansBold
               end
            end
         end
         player.CharacterAdded:Connect(apply)
         apply()
      end
      
      if _G.EspPlayer then
         for _, p in pairs(Players:GetPlayers()) do addEsp(p) end
         Players.PlayerAdded:Connect(addEsp)
      else
         for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.HumanoidRootPart:FindFirstChild("EspBillboard") then
               p.Character.HumanoidRootPart.EspBillboard:Destroy()
            end
         end
      end
   end
})

local playerList = {}
local selectedPlayer = nil

local function updatePlayerList()
   playerList = {}
   for _, p in pairs(Players:GetPlayers()) do
      if p ~= LocalPlayer then
         table.insert(playerList, p.Name)
      end
   end
end
updatePlayerList()

local PlayerDropdown = PlayerTab:CreateDropdown({
   Name = "Chọn Người Chơi",
   Options = playerList,
   CurrentOption = "",
   MultipleOptions = false,
   Callback = function(Option)
      selectedPlayer = Option[1]
   end
})

PlayerTab:CreateButton({
   Name = "Làm mới danh sách phòng",
   Callback = function()
      updatePlayerList()
      PlayerDropdown:Refresh(playerList, true)
   end
})

PlayerTab:CreateButton({
   Name = "Bay Đến Mục Tiêu (Teleport)",
   Callback = function()
      if selectedPlayer then
         local targetP = Players:FindFirstChild(selectedPlayer)
         if targetP and targetP.Character and targetP.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = targetP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
         end
      end
   end
})

local invisRunning = false
PlayerTab:CreateToggle({
   Name = "Chế độ Tàng Hình (Invisibility)",
   CurrentValue = false,
   Callback = function(Value)
      invisRunning = Value
      task.spawn(function()
         while invisRunning do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("LowerTorso") then
               local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
               if root then
                  local oldCFrame = root.CFrame
                  root.CFrame = oldCFrame * CFrame.new(0, 500, 0)
                  task.wait(0.05)
                  root.CFrame = oldCFrame
               end
            end
            task.wait(0.1)
         end
      end)
   end
})

Rayfield:LoadConfiguration()

