local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local ShootEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("HitPart")

local gui = Instance.new("ScreenGui")
gui.Name = "ModMenu"
gui.ResetOnSpawn = false
pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 20, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Visible = false

local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0.5, -25)
toggleButton.Text = "≡"
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggleButton.TextScaled = true
toggleButton.ZIndex = 2

toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Botón TP Kill
local tpKill = false

local tpButton = Instance.new("TextButton", frame)
tpButton.Size = UDim2.new(1, -20, 0, 40)
tpButton.Position = UDim2.new(0, 10, 0, 10)
tpButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
tpButton.TextColor3 = Color3.new(1,1,1)
tpButton.Text = "TP Kill: OFF"
tpButton.TextScaled = true

tpButton.MouseButton1Click:Connect(function()
    tpKill = not tpKill
    tpButton.Text = "TP Kill: " .. (tpKill and "ON" or "OFF")
end)

-- Función para matar al jugador
function kill(player)
    if player and player.Character and player.Character:FindFirstChild("Head") then
        local head = player.Character.Head
        ShootEvent:FireServer({
            Part = head,
            Dmg = 100,
            HitPos = head.Position,
            HitNormal = Vector3.new(),
            Distance = 0,
            Material = Enum.Material.Plastic,
            Pos = head.Position,
            Velocity = Vector3.new()
        })
    end
end

-- Bucle de ejecución
RunService.RenderStepped:Connect(function()
    if tpKill and LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, enemy in pairs(Players:GetPlayers()) do
            if enemy ~= LocalPlayer and enemy.Team ~= LocalPlayer.Team then
                if enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    kill(enemy)
                end
            end
        end
    end
end)