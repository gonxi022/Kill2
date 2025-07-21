local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Settings
local settings = {
    noclip = false,
    speed = false,
    speedValue = 80,
}

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotUltraOPMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0.5, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.Text = "≡"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Parent = screenGui

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 220, 0, 150)
menuFrame.Position = UDim2.new(0, 70, 0.5, -75)
menuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = screenGui

local function createToggle(text, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 20
    btn.Text = text .. ": OFF"
    btn.Parent = menuFrame
    return btn
end

local noclipBtn = createToggle("Noclip", 10)
local speedBtn = createToggle("Speed", 60)

toggleButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

noclipBtn.MouseButton1Click:Connect(function()
    settings.noclip = not settings.noclip
    noclipBtn.Text = "Noclip: " .. (settings.noclip and "ON" or "OFF")
end)

speedBtn.MouseButton1Click:Connect(function()
    settings.speed = not settings.speed
    speedBtn.Text = "Speed: " .. (settings.speed and "ON" or "OFF")
end)

-- Noclip implementation
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

-- Speed hack implementation
RunService.RenderStepped:Connect(function()
    if settings.speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = settings.speedValue
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- default speed
    end
end)