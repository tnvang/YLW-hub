local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HentaiListGUI"
screenGui.Parent = playerGui
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 600)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "📜 40 BỘ HENTAI ĐÃ XEM VÀ CỰC MÚP Dành cho ae"
title.TextColor3 = Color3.fromRGB(255, 180, 80)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = mainFrame
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -70)
scroll.Position = UDim2.new(0, 8, 0, 58)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 10
scroll.Parent = mainFrame
local hentaiNames = {
    "Kyonyuu no Tomodachi to Tsukiau made no Hanashi",
    "Ore no Mawari ni Kyonyuu ga Oosugiru",
    "Deco x Deco The Animation",
    "Boku ni Haishin Bare shita U-Cup Chinkobi Joshi Amino-san",
    "Yogoreta Kanojo",
    "Todo no Tsumari",
    "Oshikake! Bakunyuu Gal Harem Seikatsu",
    "Imouto Paradise! 2",
    "Oni Chichi 2",
    "Toshi Densetsu",
    "Kuroinu ~Kedakaki Seijo wa Hakudaku ni Somaru~",
    "Rance 01",
    "Euphoria",
    "Bible Black",
    "La Blue Girl",
    "Urotsukidoji",
    "Cool Devices",
    "G-Taste",
    "Kangoku Senkan",
    "Kansen 3",
    "Shin Seiki Inma Seiden",
    "Mahou Shoujo Ai",
    "Sisters ~Natsu no Saigo no Hi~",
    "Bondage Game",
    "Enbi",
    "Koukaku no Regios (Hentai Parody)",
    "Futari no Aniyome",
    "Gibomai",
    "Houkago no Yuutousei",
    "Netorare Hime",
    "Oni Chichi Rebuild",
    "Taimanin Asagi 3",
    "Starless",
    "Kono Naka ni Hitori, Imouto ga Iru! (OVA)",
    "Jutaijima",
    "Himekishi Lilia",
    "Miyabi na Niku",
    "Dokidoki Oyako Gokko",
    "Ane Jiru 2",
    "Milk Junkie"
}
local yOffset = 0
local buttonHeight = 34
local spacing = 4
for i, name in ipairs(hentaiNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, buttonHeight)
    btn.Position = UDim2.new(0, 5, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    btn.BackgroundTransparency = 0.2
    btn.Text = tostring(i) .. ". " .. name
    btn.TextColor3 = Color3.fromRGB(210, 210, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = true
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(function()
        print("Chọn: " .. name)
    end)
    yOffset = yOffset + buttonHeight + spacing
end
scroll.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
