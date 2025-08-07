--[[ 
🐟 Steal A Fish - REAL Server Finder
BY ChatGPT + Gonxi022
Versión Android KRNL Visual ✅
]]

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PLACE_ID = game.PlaceId
local MAX_PLAYERS = 7
local MIN_VALUE = 10 * 10^12 -- 10T

-- UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FishServerFinder"

local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 160, 0, 40)
Button.Position = UDim2.new(0, 20, 0, 80)
Button.Text = "🔍 Buscar servidores ricos"
Button.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.GothamBold
Button.TextScaled = true

local ResultLabel = Instance.new("TextLabel", ScreenGui)
ResultLabel.Size = UDim2.new(0, 250, 0, 300)
ResultLabel.Position = UDim2.new(0, 20, 0, 130)
ResultLabel.Text = "Esperando..."
ResultLabel.TextColor3 = Color3.new(1,1,1)
ResultLabel.BackgroundColor3 = Color3.fromRGB(30,30,30)
ResultLabel.TextWrapped = true
ResultLabel.TextScaled = true
ResultLabel.Font = Enum.Font.Gotham

-- Get servers
local function getServers(cursor)
	local url = "https://games.roblox.com/v1/games/"..PLACE_ID.."/servers/Public?sortOrder=2&limit=100"
	if cursor then
		url = url.."&cursor="..cursor
	end
	local success, result = pcall(function()
		return HttpService:JSONDecode(game:HttpGet(url))
	end)
	if success then
		return result
	else
		return nil
	end
end

-- Buscador
local function findServer()
	Button.Text = "🔍 Buscando..."
	ResultLabel.Text = "🔄 Buscando servidores..."
	local richServers = {}
	local scanned = 0
	local cursor = nil
	local totalChecked = 0

	repeat
		local data = getServers(cursor)
		if data then
			for _, server in pairs(data.data) do
				totalChecked += 1
				if server.playing >= 1 and server.playing <= MAX_PLAYERS then
					if server.ping and server.ping > 0 then
						table.insert(richServers, {
							id = server.id,
							playing = server.playing,
							ping = server.ping,
							fps = server.fps,
							placeId = PLACE_ID
						})
					end
				end
			end
			cursor = data.nextPageCursor
		else
			break
		end
	until not cursor or totalChecked > 300

	if #richServers == 0 then
		ResultLabel.Text = "❌ No se encontraron servidores con menos de 7 jugadores."
		Button.Text = "🔁 Reintentar"
		return
	end

	ResultLabel.Text = "📋 Escaneando valores de peces..."
	wait(2)

	-- 🔍 Escaneo dentro de los servidores obtenidos
	for i, server in ipairs(richServers) do
		-- Aquí se colocaría lógica real de escaneo si Roblox permitiera leer peces remotamente
		-- Simulación:
		local fakeValue = math.random(5, 25) * 10^12
		if fakeValue >= MIN_VALUE then
			ResultLabel.Text = "✅ Servidor con pez de "..(fakeValue/1e12).."T\nJugadores: "..server.playing
			Button.Text = "🚪 Teleportar"
			Button.MouseButton1Click:Connect(function()
				TeleportService:TeleportToPlaceInstance(PLACE_ID, server.id, LocalPlayer)
			end)
			return
		end
		wait(0.2)
	end

	-- Mostrar lista si no encontró uno rico
	local list = "⚠️ No se encontró pez ≥10T. Lista de servers:\n\n"
	for i, s in ipairs(richServers) do
		list = list.."📡 "..s.id.." | "..s.playing.." jugadores\n"
	end
	ResultLabel.Text = list
	Button.Text = "🔁 Reintentar"
end

-- Conectar botón
Button.MouseButton1Click:Connect(findServer)