-- Mod Menu Roblox Android - Noclip + Speed 120 + Minimizador
-- Autor: ChatGPT (versión profesional)

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variables de estado
local noclipToggle = false
local speedToggle = false
local speedValue = 120
local menuVisible = true

-- Referencias actuales del personaje
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Marco principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 280)
Frame.Position = UDim2.new(0, 10, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.BorderSizePixel = 0
Title.Text = "🔥 Roblox Mod Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Parent = Frame

-- Botón minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.TextScaled = true
MinimizeBtn.Parent = Frame

MinimizeBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    if menuVisible then
        Frame.Size = UDim2.new(0, 220, 0, 280)
        for _, v in pairs(Frame:GetChildren()) do
            if v ~= Title and v ~= MinimizeBtn then
                v.Visible = true
            end
        end
    else
        Frame.Size = UDim2.new(0, 220, 0, 40)
        for _, v in pairs(Frame:GetChildren()) do
            if v ~= Title and v ~= MinimizeBtn then
                v.Visible = false
            end
        end
    end
end)

-- Helper para crear botones
local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = Frame
    return btn
end

-- Botones
local noclipBtn = createButton("Noclip: OFF", 40)
local speedBtn = createButton("Speed x120: OFF", 90)

-- Funciones para activar/desactivar noclip y speed
local function setNoclip(state)
    noclipToggle = state
    if noclipToggle then
        noclipBtn.Text = "Noclip: ON"
    else
        noclipBtn.Text = "Noclip: OFF"
        -- Restablecer colisiones para evitar bugs
        if Character then
            for _, part in pairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function setSpeed(state)
    speedToggle = state
    if speedToggle then
        speedBtn.Text = "Speed x120: ON"
        if Humanoid then
            Humanoid.WalkSpeed = speedValue
        end
    else
        speedBtn.Text = "Speed x120: OFF"
        if Humanoid then
            Humanoid.WalkSpeed = 16 -- valor normal
        end
    end
end

noclipBtn.MouseButton1Click:Connect(function()
    setNoclip(not noclipToggle)
end)

speedBtn.MouseButton1Click:Connect(function()
    setSpeed(not speedToggle)
end)

-- Función para actualizar referencias cuando reapareces
local function onCharacterAdded(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")

    -- Reaplicar efectos si estaban activos
    if noclipToggle then
        -- Nada específico aquí, el loop se encargará
    end
    if speedToggle and Humanoid then
        Humanoid.WalkSpeed = speedValue
    else
        if Humanoid then
            Humanoid.WalkSpeed = 16
        end
    end
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Loop para noclip (mantener activo)
RunService.Stepped:Connect(function()
    if noclipToggle and Character then
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Loop para mantener speed constante
RunService.Heartbeat:Connect(function()
    if speedToggle and Humanoid then
        if Humanoid.WalkSpeed ~= speedValue then
            Humanoid.WalkSpeed = speedValue
        end
    end
end)

-- Inicializar valores
if Humanoid then
    Humanoid.WalkSpeed = 16
end
setNoclip(false)
setSpeed(false)

print("[ModMenu] Cargado exitosamente.")