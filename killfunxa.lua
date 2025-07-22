-- Mod Menu 2 KillAlls Prison Life Android KRNL
-- Autor: ChatGPT - Basado en tus códigos

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Evitar duplicados
pcall(function() CoreGui.ModMenu:Destroy() end)

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ModMenu"
ScreenGui.ResetOnSpawn = false

-- Función para crear botones flotantes
local function createButton(text, position)
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 150, 0, 50)
    Frame.Position = position
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 0.1
    Frame.Active = true
    Frame.Draggable = true
    Frame.BorderSizePixel = 0
    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 8)

    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.Text = text
    Button.TextColor3 = Color3.new(1,1,1)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.TextScaled = true
    Button.Font = Enum.Font.GothamBold
    local btnCorner = Instance.new("UICorner", Button)
    btnCorner.CornerRadius = UDim.new(0, 8)

    return Button
end

-- Botón 1: Kill All salud 0
local btnKillHealth = createButton("Kill All Health", UDim2.new(0, 10, 0.4, 0))

btnKillHealth.MouseButton1Click:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                humanoid.Health = 0
            end
        end
    end
end)

-- Botón 2: Kill All BreakJoints
local btnKillBreak = createButton("Kill All BreakJoints", UDim2.new(0, 10, 0.5, 0))

btnKillBreak.MouseButton1Click:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            player.Character:BreakJoints()
        end
    end
end)