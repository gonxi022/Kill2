-- Prison Life Kill All - Incluye al jugador local
-- Funciona en Android con KRNL - Botones flotantes

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Borrar menú anterior si existe
pcall(function() CoreGui.ModMenuKill:Destroy() end)

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ModMenuKill"
ScreenGui.ResetOnSpawn = false

-- Función para crear botones flotantes
local function createButton(text, position, callback)
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 160, 0, 45)
    Frame.Position = position
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Active = true
    Frame.Draggable = true
    Frame.BorderSizePixel = 0
    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 8)

    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.Text = text
    Button.TextColor3 = Color3.new(1,1,1)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.TextScaled = true
    Button.Font = Enum.Font.GothamBold
    local btnCorner = Instance.new("UICorner", Button)
    btnCorner.CornerRadius = UDim.new(0, 8)

    Button.MouseButton1Click:Connect(callback)
end

-- Función 1: Matar por Health = 0 (a todos)
local function killAllByHealth()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                humanoid.Health = 0
            end
        end
    end
end

-- Función 2: Matar con BreakJoints (a todos)
local function killAllByBreakJoints()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            player.Character:BreakJoints()
        end
    end
end

-- Botones flotantes
createButton("💀 Kill All - Health", UDim2.new(0, 10, 0.45, 0), killAllByHealth)
createButton("☠️ Kill All - BreakJoints", UDim2.new(0, 10, 0.55, 0), killAllByBreakJoints)