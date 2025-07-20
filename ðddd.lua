-- Roblox Fly & NoClip Script para Android
local Players = game:GetService("Players")
local UserInputService = game:GetService("User InputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Configuración
local FLY_SPEED = 50
local NOCLIP_COOLDOWN = 0.1

-- Variables de estado
local flying = false
local noclip = false
local lastTick = 0
local moveDirection = Vector3.new()

-- Crear interfaz de usuario
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlightControls"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.2, 0, 0.3, 0)
frame.Position = UDim2.new(0.8, 0, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(1, 0, 0.5, 0)
flyButton.Text = "FLY: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.Gotham
flyButton.Parent = frame

local noclipButton = Instance.new("TextButton")
noclipButton.Name = "NoClipButton"
noclipButton.Size = UDim2.new(1, 0, 0.5, 0)
noclipButton.Position = UDim2.new(0, 0, 0.5, 0)
noclipButton.Text = "NO CLIP: OFF"
noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Font = Enum.Font.Gotham
noclipButton.Parent = frame

-- Función para cambiar el modo fly
local function toggleFly()
    flying = not flying
    if flying then
        flyButton.Text = "FLY: ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        humanoid.PlatformStand = true
    else
        flyButton.Text = "FLY: OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        humanoid.PlatformStand = false
        moveDirection = Vector3.new()
    end
end

-- Función para cambiar el modo noclip
local function toggleNoClip()
    noclip = not noclip
    if noclip then
        noclipButton.Text = "NO CLIP: ON"
        noclipButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        noclipButton.Text = "NO CLIP: OFF"
        noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end

-- Conexión de los botones
flyButton.MouseButton1Click:Connect(toggleFly)
noclipButton.MouseButton1Click:Connect(toggleNoClip)

-- Configuración de los controles de vuelo
local function handleFlightInputs()
    moveDirection = Vector3.new()
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + Vector3.new(0, 0, -1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection + Vector3.new(0, 0, 1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection + Vector3.new(-1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + Vector3.new(1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        moveDirection = moveDirection + Vector3.new(0, -1, 0)
    end
    
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * FLY_SPEED
    else
        moveDirection = moveDirection * 0
    end
end

-- Conexión para actualizar el estado de noclip
local function updateNoClip()
    if not noclip then return end
    
    if tick() - lastTick < NOCLIP_COOLDOWN then return end
    lastTick = tick()
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end

-- Conexión para el vuelo
RunService.Heartbeat:Connect(function(delta)
    if flying and character and character.PrimaryPart then
        handleFlightInputs()
        
        if moveDirection.Magnitude > 0.1 then
            character.PrimaryPart.Velocity = moveDirection
        else
            character.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
    
    updateNoClip()
end)

-- Reiniciar estados cuando el personaje reaparece
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    flying = false
    noclip = false
    
    flyButton.Text = "FLY: OFF"
    flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    noclipButton.Text = "NO CLIP: OFF"
    noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    screenGui.Parent = player.PlayerGui
end)