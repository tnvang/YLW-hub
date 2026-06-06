-- ====================================================================
-- SCRIPT NAME: vagdaide (Safe Edition)
-- CHỨC NĂNG: Tự động gom vật phẩm (Bond/Liên kết) an toàn
-- ====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Hàm tìm và tự động gom vật phẩm về vị trí nhân vật
local function collectBonds()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart

    -- Quét toàn bộ Workspace để tìm vật phẩm (Bond/Liên kết)
    -- Thay "Bond" bằng tên chính xác của Object vật phẩm trong game nếu có thay đổi
    for _, item in pairs(Workspace:GetDescendants()) do
        if item:IsA("Tool") or item:IsA("Model") then
            if item.Name:lower():match("bond") or item.Name:match("Liên kết") then
                -- Di chuyển vật phẩm hoặc nhân vật đến gần để nhặt tự động
                if item:FindFirstChild("Handle") then
                    item.Handle.CFrame = rootPart.CFrame
                elseif item:IsA("Model") and item.PrimaryPart then
                    item.PrimaryPart.CFrame = rootPart.CFrame
                end
            end
        end
    end
end

-- Vòng lặp chạy ngầm tự động gom từ xa (An toàn, không chứa mã độc)
task.spawn(function()
    while true do
        pcall(collectBonds)
        task.wait(1) -- Nghỉ 1 giây mỗi lần quét để tránh tình trạng lag/văng game
    end
end)

