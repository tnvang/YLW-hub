local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "mxuan",
    SubTitle = "Bản Thử Nghiệm Premium",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Chức Năng Chính", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Cài Đặt", Icon = "settings" })
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

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

local ToggleFastAttack = Tabs.Main:AddToggle("FastAttack", {Title = "Tấn Công Nhanh (Fast Attack M1)", Default = false})

ToggleFastAttack:OnChanged(function(Value)
    _G.FastAttack = Value
    
    task.spawn(function()
        while _G.FastAttack do
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.01)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
            task.wait(0.05)
        end
    end)
end)

local ToggleAimSkill = Tabs.Main:AddToggle("AutoAimSkill", {Title = "Auto Aim Chiêu (Người Gần Nhất)", Default = false})

ToggleAimSkill:OnChanged(function(Value)
    _G.AutoAimSkill = Value
    
    task.spawn(function()
        while _G.AutoAimSkill do
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = target.Character.HumanoidRootPart.Position
                
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                        LocalPlayer.Character.HumanoidRootPart.Position, 
                        Vector3.new(targetPos.X, LocalPlayer.Character.HumanoidRootPart.Position.Y, targetPos.Z)
                    )
                end

                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
            end
            task.wait(0.2)
        end
    end)
end)

local SliderSpeed = Tabs.Main:AddSlider("WalkSpeed", {
    Title = "Tốc Độ Di Chuyển",
    Description = "Giúp di chuyển linh hoạt, né tránh chiêu thức tốt hơn",
    Default = 16,
    Min = 16,
    Max = 120,
    Rounding = 0,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

Tabs.Main:AddButton({
    Title = "Tắt Tất Cả Chức Năng (Emergency Stop)",
    Description = "Bấm vào đây để dừng ngay lập tức mọi vòng lặp đang chạy",
    Callback = function()
        ToggleFastAttack:SetValue(false)
        ToggleAimSkill:SetValue(false)
        _G.FastAttack = false
        _G.AutoAimSkill = false
        
        Fluent:Notify({
            Title = "mxuan",
            Content = "Đã tắt tất cả các tính năng an toàn!",
            Duration = 3
        })
    end
})

Tabs.Settings:AddButton({
    Title = "Xóa Giao Diện (Destroy UI)",
    Callback = function()
        Fluent:Destroy()
    end
})

Fluent:Notify({
    Title = "mxuan",
    Content = "Menu Đấu Trường Kỹ Năng đã sẵn sàng hoạt động!",
    Duration = 5
})

