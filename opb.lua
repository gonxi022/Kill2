local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local settings = {
    noclip = false,
    esp = false,
    teleport = false,
}

-- Crear GUI
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "BrainrotModMenu"
screenGui.ResetOnSpawn = false

local mainBtn = Instance.new("TextButton", screenGui)
mainBtn.Size = UDim2.new(0, 50, 0, 50)
mainBtn.Position = UDim2.new(0, 10, 0.5, -25)
mainBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainBtn.Text = "≡"
mainBtn.TextColor3 = Color3.fromRGB(255,255,255)
mainBtn.TextScaled = true
mainBtn.ZIndex = 10

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 70, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.BorderSizePixel = 0
frame.Visible = false
frame.ZIndex = 9

-- Función para crear toggles
local function createToggle(name, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    btn.TextColor3 = Color3.fromRGB(240,240,240)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Text = name .. ": OFF"
    btn.MouseButton1Click:Connect(function()
        settings[name] = not settings[name]
        btn.Text = name .. ": " .. (settings[name] and "ON" or "OFF")
    end)
    return btn
end

local noclipBtn = createToggle("noclip", 10)
local espBtn = createToggle("esp", 60)
local teleportBtn = createToggle("teleport", 110)

mainBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Noclip
RunService.Stepped:Connect(function()
    if settings.noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- ESP simple
local espBoxes = {}

local function createESP(player)
    if player == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.new(1, 0, 0)
    box.Transparency = 1
    box.Filled = false
    espBoxes[player] = box

    RunService.RenderStepped:Connect(function()
        if settings.esp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (player.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
                local size = 50 / dist
                box.Size = Vector2.new(size * 2, size * 3)
                box.Position = Vector2.new(pos.X - size, pos.Y - size * 1.5)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        wait(1)
        createESP(p)
    end)
end)

-- Teleport simple a la posición del mouse (ejemplo)
local UserInputService = game:GetService("UserInputService")
teleportBtn.MouseButton1Click:Connect(function()
    if settings.teleport then
        local mousePos = UserInputService:GetMouseLocation()
        local ray = workspace.CurrentCamera:ScreenPointToRay(mousePos.X, mousePos.Y)
        local targetPos = ray.Origin + ray.Direction * 50
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
        end
    end
end)