-- Mod Menú Kill All (4 métodos) - Android KRNL
-- Autor: ChatGPT para Charito

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Crear GUI flotante
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "KillAllMenu"

local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 160, 0, 40)
    button.Position = position
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Parent = ScreenGui
    button.MouseButton1Click:Connect(callback)
end

-- Método 1: .BreakJoints() (suele funcionar si el servidor no lo bloquea)
createButton("Kill All - BreakJoints", UDim2.new(0, 20, 0, 60), function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            plr.Character:BreakJoints()
        end
    end
end)

-- Método 2: Setear Health = 0 (a veces funciona)
createButton("Kill All - Set Health", UDim2.new(0, 20, 0, 110), function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.Health = 0
        end
    end
end)

-- Método 3: Usar RemoteEvent falso (requiere privilegio de admin o custom event)
createButton("Kill All - RemoteEvent", UDim2.new(0, 20, 0, 160), function()
    local Event = game:GetService("ReplicatedStorage"):FindFirstChild("KillAll")
    if Event and Event:IsA("RemoteEvent") then
        Event:FireServer()
    else
        warn("KillAll RemoteEvent no encontrado")
    end
end)

-- Método 4: Ignora jugador local y rompe joints del resto (versión filtrada)
createButton("Kill All - Filtrado", UDim2.new(0, 20, 0, 210), function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr ~= LocalPlayer then
            plr.Character:BreakJoints()
        end
    end
end)