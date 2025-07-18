local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local meleeEvent = ReplicatedStorage:WaitForChild("meleeEvent")

-- Crear UI flotante
local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillAllTester"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local KillButton = Instance.new("TextButton")
KillButton.Size = UDim2.new(0, 120, 0, 40)
KillButton.Position = UDim2.new(1, -130, 0, 20)
KillButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
KillButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KillButton.Text = "Test Kill All"
KillButton.Font = Enum.Font.SourceSansBold
KillButton.TextSize = 20
KillButton.Parent = ScreenGui
KillButton.Draggable = true
KillButton.Active = true

-- Al hacer click en el botón, se prueba el exploit real
KillButton.MouseButton1Click:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            meleeEvent:FireServer(player)
        end
    end
end)
