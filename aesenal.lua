local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local settings = {
    esp = false,
    autoKill = false,
    autoPlay = false,
}

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ArsenalMod"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Fondo oscuro semi-transparente para el menú
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.BackgroundTransparency = 0.6
background.Visible = false
background.ZIndex = 8
background.Parent = screenGui

-- Botón principal
local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(0, 50, 0, 50)
mainBtn.Position = UDim2.new(0, 10, 0.5, -25)
mainBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
mainBtn.Text = "≡"
mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mainBtn.TextScaled = true
mainBtn.ZIndex = 10
mainBtn.Parent = screenGui
mainBtn.BorderSizePixel = 0
mainBtn.AutoButtonColor = true

-- Menú contenedor
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0, 70, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Visible = false
frame.ZIndex = 10
frame.Parent = screenGui
frame.AnchorPoint = Vector2.new(0, 0)

-- Sombra para frame (para más visibilidad)
local shadow = Instance.new("UIStroke")
shadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
shadow.Color = Color3.fromRGB(0, 0, 0)
shadow.Thickness = 2
shadow.Parent = frame

-- Crear botón y asignar función toggle con callback
local function makeBtn(name, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Text = name .. ": OFF"
    btn.AutoButtonColor = true
    btn.ZIndex = 11
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        settings[name] = not settings[name]
        btn.Text = name .. ": " .. (settings[name] and "ON" or "OFF")
        -- Ejecutar callback si existe para activar/desactivar función
        if name == "esp" then
            if settings.esp then
                enableESP()
            else
                disableESP()
            end
        elseif name == "autoKill" then
            -- no requiere acción adicional, loop checa settings
        elseif name == "autoPlay" then
            -- no requiere acción adicional, loop checa settings
        end
    end)

    return btn
end

local espBtn = makeBtn("esp", 10)
local killBtn = makeBtn("autoKill", 60)
local playBtn = makeBtn("autoPlay", 110)

-- Toggle menú con el botón principal
mainBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    background.Visible = frame.Visible
end)

-- ESP
local espBoxes = {}

local function enableESP()
    -- Crear cajas para todos jugadores
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not espBoxes[player] then
            local box = Drawing.new("Square")
            box.Thickness = 2
            box.Color = Color3.new(1, 0, 0)
            box.Transparency = 1
            box.Filled = false
            espBoxes[player] = box
        end
    end
end

local function disableESP()
    -- Remover cajas
    for player, box in pairs(espBoxes) do
        box:Remove()
        espBoxes[player] = nil
    end
end

-- Actualizar posiciones ESP en RenderStepped
RunService.RenderStepped:Connect(function()
    if settings.esp then
        for player, box in pairs(espBoxes) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
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
        end
    else
        -- Si ESP está desactivado, esconder todas las cajas
        for _, box in pairs(espBoxes) do
            box.Visible = false
        end
    end
end)

-- Detectar nuevos jugadores y crear cajas ESP automáticamente si está activado
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        if settings.esp and not espBoxes[player] and player ~= LocalPlayer then
            local box = Drawing.new("Square")
            box.Thickness = 2
            box.Color = Color3.new(1, 0, 0)
            box.Transparency = 1
            box.Filled = false
            espBoxes[player] = box
        end
    end)
end)

-- Auto Kill loop
spawn(function()
    while true do
        task.wait(0.4)
        if settings.autoKill then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Humanoid") then
                    p.Character.Humanoid.Health = 0
                end
            end
        end
    end
end)

-- Auto Play loop
spawn(function()
    while true do
        task.wait(0.5)
        if settings.autoPlay and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetCFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
                end
            end
        end
    end
end)