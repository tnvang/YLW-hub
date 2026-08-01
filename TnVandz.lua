local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local ItemCategories = {
    Weapons = {
        Color = Color3.fromRGB(255, 60, 60),
        Names = {"pistol", "revolver", "handgun", "rifle", "sniper", "awm", "military knife", "knife", "axe", "hammer", "machete", "crowbar", "bat", "stick", "melee", "gun"}
    },
    Survival = {
        Color = Color3.fromRGB(60, 255, 60),
        Names = {"binoculars", "ammo", "bullet", "bandage", "sandbag", "brick", "glass bottle", "bottle", "flashlight", "medkit", "health", "food"}
    },
    Loot = {
        Color = Color3.fromRGB(255, 215, 0),
        Names = {"coin", "coins", "supply crate", "crate", "loot box", "supply"}
    },
    Monsters = {
        Color = Color3.fromRGB(160, 32, 240),
        Names = {"death angel", "listener", "angel of death"}
    }
}

local Toggles = {
    ESP_Weapons = false,
    ESP_Survival = false,
    ESP_Loot = false,
    ESP_Monsters = false,
    ESP_Players = false,
    ESP_Tracer = false,
    ESP_NameDist = false,
    MuteMovement = false,
    Watermark = true
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomESP_GUI"
ScreenGui.ResetOnSpawn = false

local Success, _ = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not Success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ==================== BẢNG CÂU HỎI MỞ ĐẦU ====================
local QuestionFrame = Instance.new("Frame")
QuestionFrame.Size = UDim2.new(0, 340, 0, 200)
QuestionFrame.Position = UDim2.new(0.5, -170, 0.5, -100)
QuestionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
QuestionFrame.BorderSizePixel = 0
QuestionFrame.Active = true
QuestionFrame.Draggable = true
QuestionFrame.Parent = ScreenGui

local QCorner = Instance.new("UICorner")
QCorner.CornerRadius = UDim.new(0, 10)
QCorner.Parent = QuestionFrame

local QTitle = Instance.new("TextLabel")
QTitle.Size = UDim2.new(1, -20, 0, 50)
QTitle.Position = UDim2.new(0, 10, 0, 10)
QTitle.BackgroundTransparency = 1
QTitle.Text = "Tn Vàn dz (Discord: cammuoilupro)\ncó dz lv max không?"
QTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
QTitle.TextSize = 15
QTitle.Font = Enum.Font.SourceSansBold
QTitle.TextWrapped = true
QTitle.Parent = QuestionFrame

local Option1 = Instance.new("TextButton")
Option1.Size = UDim2.new(0.85, 0, 0, 40)
Option1.Position = UDim2.new(0.075, 0, 0.38, 0)
Option1.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
Option1.Text = "Tn Vàn dz pro lv max"
Option1.TextColor3 = Color3.fromRGB(255, 255, 255)
Option1.TextSize = 14
Option1.Font = Enum.Font.SourceSansBold
Option1.Parent = QuestionFrame

local Opt1Corner = Instance.new("UICorner")
Opt1Corner.CornerRadius = UDim.new(0, 6)
Opt1Corner.Parent = Option1

local Option2 = Instance.new("TextButton")
Option2.Size = UDim2.new(0.85, 0, 0, 40)
Option2.Position = UDim2.new(0.075, 0, 0.64, 0)
Option2.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
Option2.Text = "T dz nhất vụ trũ m tuổi"
Option2.TextColor3 = Color3.fromRGB(255, 255, 255)
Option2.TextSize = 14
Option2.Font = Enum.Font.SourceSansBold
Option2.Parent = QuestionFrame

local Opt2Corner = Instance.new("UICorner")
Opt2Corner.CornerRadius = UDim.new(0, 6)
Opt2Corner.Parent = Option2

-- ==================== MENU CHÍNH (ESP) ====================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 390)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false -- Ban đầu ẩn đi, chọn đúng mới hiện
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Tn Vàn dz (TB)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Size = UDim2.new(0, 30, 0, 30)
CollapseBtn.Position = UDim2.new(1, -32, 0, 2)
CollapseBtn.Text = "[-]"
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.TextSize = 14
CollapseBtn.Font = Enum.Font.SourceSansBold
CollapseBtn.BackgroundTransparency = 1
CollapseBtn.Parent = Header

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -10, 1, -45)
Container.Position = UDim2.new(0, 5, 0, 40)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 410)
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = Container

-- Xử lý sự kiện bấm nút mở menu / kick
Option1.MouseButton1Click:Connect(function()
    QuestionFrame.Visible = false
    MainFrame.Visible = true
end)

Option2.MouseButton1Click:Connect(function()
    LocalPlayer:Kick("T dz nhất vụ trũ m tuổi")
end)

-- Kéo thả MainFrame
local Dragging, DragInput, DragStart, StartPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

local IsCollapsed = false
CollapseBtn.MouseButton1Click:Connect(function()
    IsCollapsed = not IsCollapsed
    if IsCollapsed then
        MainFrame:TweenSize(UDim2.new(0, 240, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        CollapseBtn.Text = "[+]"
    else
        MainFrame:TweenSize(UDim2.new(0, 240, 0, 390), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        CollapseBtn.Text = "[-]"
    end
end)

local FolderESP = Instance.new("Folder")
FolderESP.Name = "ESP_Container"
FolderESP.Parent = Workspace

local ActiveDrawings = {}

local function CreateDrawingESP(obj, textStr, color, categoryKey)
    if not obj then return end
    
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = color
    tracer.Thickness = 1
    tracer.Transparency = 0.7

    local text = Drawing.new("Text")
    text.Visible = false
    text.Color = color
    text.Size = 13
    text.Center = true
    text.Outline = true
    text.Font = Drawing.Fonts.UI

    local connection
    connection = RunService.RenderStepped:Connect(function()
        local isCategoryActive = false
        if categoryKey == "Weapons" then isCategoryActive = Toggles.ESP_Weapons
        elseif categoryKey == "Survival" then isCategoryActive = Toggles.ESP_Survival
        elseif categoryKey == "Loot" then isCategoryActive = Toggles.ESP_Loot
        elseif categoryKey == "Monsters" then isCategoryActive = Toggles.ESP_Monsters
        elseif categoryKey == "Players" then isCategoryActive = Toggles.ESP_Players
        end

        if not obj or not obj.Parent or not isCategoryActive then
            tracer:Remove()
            text:Remove()
            connection:Disconnect()
            return
        end

        local cf, size
        if obj:IsA("Model") then
            cf, size = obj:GetBoundingBox()
        elseif obj:IsA("BasePart") then
            cf, size = obj.CFrame, obj.Size
        elseif obj:IsA("Player") and obj.Character and obj.Character:FindFirstChild("HumanoidRootPart") then
            cf, size = obj.Character.HumanoidRootPart.CFrame, Vector3.new(4, 5, 4)
        end

        if cf and size then
            local vector, onScreen = Camera:WorldToViewportPoint(cf.Position)
            if onScreen then
                local dist = math.floor((Camera.CFrame.Position - cf.Position).Magnitude)

                if Toggles.ESP_Tracer then
                    tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(vector.X, vector.Y)
                    tracer.Visible = true
                else
                    tracer.Visible = false
                end

                if Toggles.ESP_NameDist then
                    text.Text = textStr .. " [" .. tostring(dist) .. "m]"
                    text.Position = Vector2.new(vector.X, vector.Y - 15)
                    text.Visible = true
                else
                    text.Visible = false
                end
            else
                tracer.Visible = false
                text.Visible = false
            end
        else
            tracer.Visible = false
            text.Visible = false
        end
    end)
    table.insert(ActiveDrawings, {Tracer = tracer, Text = text, Conn = connection})
end

local function RemoveESP(category)
    for _, item in pairs(FolderESP:GetChildren()) do
        if item:FindFirstChild("Category") and item.Category.Value == category then
            item:Destroy()
        end
    end
end

local function MatchesName(objName, nameList)
    local lowerName = string.lower(objName)
    for _, name in ipairs(nameList) do
        if string.find(lowerName, string.lower(name)) then
            return true
        end
    end
    return false
end

local function ApplyESP(categoryName, categoryData)
    RemoveESP(categoryName)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("Model")) and not obj:IsDescendantOf(LocalPlayer.Character or workspace) then
            if MatchesName(obj.Name, categoryData.Names) then
                local Highlight = Instance.new("Highlight")
                Highlight.Name = obj.Name .. "_ESP"
                Highlight.Adornee = obj
                Highlight.FillColor = categoryData.Color
                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                Highlight.FillTransparency = 0.5
                Highlight.OutlineTransparency = 0.1
                Highlight.Parent = FolderESP

                local CatVal = Instance.new("StringValue")
                CatVal.Name = "Category"
                CatVal.Value = categoryName
                CatVal.Parent = Highlight

                CreateDrawingESP(obj, obj.Name, categoryData.Color, categoryName)
            end
        end
    end
end

local function SetupPlayerESP()
    RemoveESP("Players")
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character then
                local Highlight = Instance.new("Highlight")
                Highlight.Name = player.Name .. "_PlayerESP"
                Highlight.Adornee = player.Character
                Highlight.FillColor = Color3.fromRGB(0, 150, 255)
                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                Highlight.FillTransparency = 0.5
                Highlight.Parent = FolderESP

                local CatVal = Instance.new("StringValue")
                CatVal.Name = "Category"
                CatVal.Value = "Players"
                CatVal.Parent = Highlight

                CreateDrawingESP(player, player.Name, Color3.fromRGB(0, 150, 255), "Players")
            end
        end
    end
end

local function SetupSilentMovement(character)
    if not character then return end

    character.DescendantAdded:Connect(function(child)
        if Toggles.MuteMovement and child:IsA("Sound") then
            child.Volume = 0
            child.Playing = false
            child:GetPropertyChangedSignal("Volume"):Connect(function()
                if Toggles.MuteMovement then child.Volume = 0 end
            end)
            child:GetPropertyChangedSignal("Playing"):Connect(function()
                if Toggles.MuteMovement and child.Playing then child.Playing = false end
            end)
        end
    end)

    RunService.Stepped:Connect(function()
        if not Toggles.MuteMovement then return end
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("Sound") then
                obj.Volume = 0
                if obj.Playing then
                    obj:Stop()
                end
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(SetupSilentMovement)
if LocalPlayer.Character then
    SetupSilentMovement(LocalPlayer.Character)
end

RunService.Stepped:Connect(function()
    if Toggles.MuteMovement then
        pcall(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, v in ipairs(hrp:GetChildren()) do
                    if v:IsA("Sound") then
                        v.Volume = 0
                        v:Stop()
                    end
                end
            end
        end)
    end
end)

local function GetRainbowColor()
    local hue = tick() % 5 / 5
    return Color3.fromHSV(hue, 1, 1)
end

local HeadWatermarks = {}
local function UpdateHeadWatermarks()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local wm = HeadWatermarks[player]
                if not wm then
                    wm = Drawing.new("Text")
                    wm.Size = 12
                    wm.Center = true
                    wm.Outline = true
                    wm.Font = Drawing.Fonts.UI
                    wm.Text = "Tn Vàn dz"
                    HeadWatermarks[player] = wm
                end
                
                local vector, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.2, 0))
                if onScreen and Toggles.Watermark then
                    wm.Position = Vector2.new(vector.X, vector.Y)
                    wm.Color = GetRainbowColor()
                    wm.Visible = true
                else
                    wm.Visible = false
                end
            end
        end
    end
end

local CornerWatermarks = {
    TopLeft = Drawing.new("Text"),
    TopRight = Drawing.new("Text"),
    BottomLeft = Drawing.new("Text"),
    BottomRight = Drawing.new("Text")
}

for _, wm in pairs(CornerWatermarks) do
    wm.Size = 12
    wm.Outline = true
    wm.Font = Drawing.Fonts.UI
    wm.Text = "Tn Vàn dz"
end

RunService.RenderStepped:Connect(function()
    UpdateHeadWatermarks()

    if Toggles.Watermark then
        local rbColor = GetRainbowColor()
        local vpSize = Camera.ViewportSize

        CornerWatermarks.TopLeft.Position = Vector2.new(10, 10)
        CornerWatermarks.TopLeft.Color = rbColor
        CornerWatermarks.TopLeft.Visible = true

        CornerWatermarks.TopRight.Position = Vector2.new(vpSize.X - 70, 10)
        CornerWatermarks.TopRight.Color = rbColor
        CornerWatermarks.TopRight.Visible = true

        CornerWatermarks.BottomLeft.Position = Vector2.new(10, vpSize.Y - 25)
        CornerWatermarks.BottomLeft.Color = rbColor
        CornerWatermarks.BottomLeft.Visible = true

        CornerWatermarks.BottomRight.Position = Vector2.new(vpSize.X - 70, vpSize.Y - 25)
        CornerWatermarks.BottomRight.Color = rbColor
        CornerWatermarks.BottomRight.Visible = true
    else
        for _, wm in pairs(CornerWatermarks) do
            wm.Visible = false
        end
    end
end)

local function CreateButton(text, onClick)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = "☑ " .. text .. " [TẮT]"
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 13
    Button.Font = Enum.Font.SourceSans
    Button.Parent = Container

    local Corner = Instance.new("UICorner", Button)
    Corner.CornerRadius = UDim.new(0, 6)

    Button.MouseButton1Click:Connect(function()
        local State = onClick()
        if State then
            Button.BackgroundColor3 = Color3.fromRGB(0, 140, 70)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Text = "☑ " .. text .. " [BẬT]"
        else
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            Button.Text = "☑ " .. text .. " [TẮT]"
        end
    end)
end

CreateButton("ESP Vũ Khí", function()
    Toggles.ESP_Weapons = not Toggles.ESP_Weapons
    if Toggles.ESP_Weapons then ApplyESP("Weapons", ItemCategories.Weapons) else RemoveESP("Weapons") end
    return Toggles.ESP_Weapons
end)

CreateButton("ESP Sinh Tồn", function()
    Toggles.ESP_Survival = not Toggles.ESP_Survival
    if Toggles.ESP_Survival then ApplyESP("Survival", ItemCategories.Survival) else RemoveESP("Survival") end
    return Toggles.ESP_Survival
end)

CreateButton("ESP Đồ / Tiền", function()
    Toggles.ESP_Loot = not Toggles.ESP_Loot
    if Toggles.ESP_Loot then ApplyESP("Loot", ItemCategories.Loot) else RemoveESP("Loot") end
    return Toggles.ESP_Loot
end)

CreateButton("ESP Quái Vật", function()
    Toggles.ESP_Monsters = not Toggles.ESP_Monsters
    if Toggles.ESP_Monsters then ApplyESP("Monsters", ItemCategories.Monsters) else RemoveESP("Monsters") end
    return Toggles.ESP_Monsters
end)

CreateButton("ESP Người Chơi", function()
    Toggles.ESP_Players = not Toggles.ESP_Players
    if Toggles.ESP_Players then SetupPlayerESP() else RemoveESP("Players") end
    return Toggles.ESP_Players
end)

CreateButton("Đường Kẻ Tracers", function()
    Toggles.ESP_Tracer = not Toggles.ESP_Tracer
    return Toggles.ESP_Tracer
end)

CreateButton("Tên & Khoảng Cách", function()
    Toggles.ESP_NameDist = not Toggles.ESP_NameDist
    return Toggles.ESP_NameDist
end)

CreateButton("Chữ Cầu Vồng (Rainbow)", function()
    Toggles.Watermark = not Toggles.Watermark
    return Toggles.Watermark
end)

CreateButton("Di Chuyển Không Tiếng", function()
    Toggles.MuteMovement = not Toggles.MuteMovement
    return Toggles.MuteMovement
end)
