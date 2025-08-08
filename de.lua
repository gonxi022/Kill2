local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()

-- Crear GUI simple
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "DupeGui"

local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 180, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.Text = "Duplicar Semillas"

button.MouseButton1Click:Connect(function()
    -- Duplica del Backpack
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            local clone = item:Clone()
            clone.Parent = backpack
        end
    end
    -- Duplica las semillas equipadas (en Character)
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") then
            local clone = item:Clone()
            clone.Parent = backpack -- Clonar en mochila para tenerlo ahí
        end
    end
    button.Text = "¡Semillas duplicadas!"
    wait(2)
    button.Text = "Duplicar Semillas"
end)