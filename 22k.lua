-- MOD MENU ANDROID | v1.0
-- Compatible con KRNL, Hydrogen, etc.
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Helper
local function makeText(parent, text, pos, size, bg, func)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = bg
    btn.TextScaled = true
    btn.Parent = parent
    if func then btn.MouseButton1Click:Connect(func) end
    return btn
end

-- GUI Container
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- Draggable menu frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 400)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
frame.Active = true; frame.Draggable = true

-- Minimize toggle
local minimized = false
local miniBtn = makeText(frame, "🧷", UDim2.new(0.85,0,0,0), UDim2.new(0.15,0,0,0.08), Color3.new(0.7,0.7,0.2), function()
    minimized = not minimized
    for _,v in ipairs(frame:GetChildren()) do
        if v~= miniBtn and v~=scroll and v~=frame.Background then
            v.Visible = not minimized
        end
    end
end)

-- Scroll area
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,0,1,-30)
scroll.Position = UDim2.new(0,0,0.08,0)
scroll.CanvasSize = UDim2.new(0,0,800)
scroll.BackgroundTransparency = 1

-- Line buttons
local y = 0
local function add(text, f)
    makeText(scroll, text, UDim2.new(0,0,0,y), UDim2.new(1,0,0,40), Color3.new(0.2,0.2,0.2), f)
    y = y + 45
    scroll.CanvasSize = UDim2.new(0,0,0,y)
end

-- FUNCTIONS:

-- 1. Kill All
add("🔥 Kill All", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p~=LP and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.Health = 0
        end
    end
end)

-- 2. Kill by name
add("🎯 Kill por nombre", function()
    local name = tostring(game:GetService("StarterGui"):SetCore("PromptInput", {
        Title = "Nombre exacto";
        Text = "";
        PlaceholderText = "Jugador";
    }))
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower() == name:lower() and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.Health = 0
        end
    end
end)

-- 3. Speed Hack
local speedOn = false
add("🚀 Speed Hack", function()
    speedOn = not speedOn
    if not speedOn then LP.Character.Humanoid.WalkSpeed = 16
    else LP.Character.Humanoid.WalkSpeed = 60 end
end)

-- 4. Noclip
local nc = false
add("🧱 Noclip", function()
    nc = not nc
end)
Run.RenderStepped:Connect(function()
    if nc and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 5. God Mode
add("🛡 God Mode", function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.MaxHealth = math.huge
        LP.Character.Humanoid.Health = math.huge
    end
end)

-- 6. Auto Farm (ex: Speed game)
local af = false
add("⚡ Auto Farm", function()
    af = not af
    spawn(function()
        while af do
            -- insertar lógica según juego (ej. tocar checkpoints)
            wait(0.5)
        end
    end)
end)

-- 7. Auto Buy
local ab = false
add("💸 Auto Buy", function()
    ab = not ab
    spawn(function()
        while ab do
            -- lógica auto buy según juego
            wait(5)
        end
    end)
end)

-- 8. Teleports
add("🌍 Teleports", function()
    local pos = {
        ["Police"] = Vector3.new(0,10,0),
        ["Yard"] = Vector3.new(100,10,0),
    }
    local choice = tostring(game:GetService("StarterGui"):SetCore("PromptInput", {
        Title = "Teleport to";
        Text = "";
        PlaceholderText = "Police/Yard";
    }))
    if pos[choice] and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = CFrame.new(pos[choice])
    end
end)

-- 9. Fly
local flyOn = false
local yv = Instance.new("BodyVelocity")
yv.MaxForce = Vector3.new(0,0,0)
yv.Velocity = Vector3.new()
yv.Parent = LP.Character:WaitForChild("HumanoidRootPart")
add("🦅 Fly", function()
    flyOn = not flyOn
    if flyOn then yv.MaxForce = Vector3.new(1e4,1e4,1e4)
    else yv.MaxForce = Vector3.new(0,0,0) end
end)
UIS.InputBegan:Connect(function(i)
    if flyOn and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local vel = Vector3.new()
        if i.KeyCode == Enum.KeyCode.W then vel = vel + LP.Character.HumanoidRootPart.CFrame.LookVector end
        if i.KeyCode == Enum.KeyCode.S then vel = vel - LP.Character.HumanoidRootPart.CFrame.LookVector end
        if i.KeyCode == Enum.KeyCode.A then vel = vel - LP.Character.HumanoidRootPart.CFrame.RightVector end
        if i.KeyCode == Enum.KeyCode.D then vel = vel + LP.Character.HumanoidRootPart.CFrame.RightVector end
        yv.Velocity = vel * 50
    end
end)

-- 10. Reset
add("🔄 Reset Menú", function()
    gui:Destroy()
end)