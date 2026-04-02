local textLabel = script.Parent

local stats = game:GetService("Stats")
local runService = game:GetService("RunService")
local playersService = game:GetService("Players")

local startTime = tick()

local function getRainbowColor(t)
	local r = math.sin(t) * 127 + 128
	local g = math.sin(t + 2) * 127 + 128
	local b = math.sin(t + 4) * 127 + 128
	return Color3.fromRGB(r, g, b)
end

runService.RenderStepped:Connect(function(delta)
	local fps = math.floor(1 / delta)

	local ping = 0
	pcall(function()
		ping = math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue())
	end)

	local playerCount = #playersService:GetPlayers()

	local timeElapsed = math.floor(tick() - startTime)
	local minutes = math.floor(timeElapsed / 60)
	local seconds = timeElapsed % 60

	textLabel.Text =
		"FPS: " .. fps .. "\n" ..
		"Players: " .. playerCount .. "\n" ..
		"Ping: " .. ping .. " ms\n" ..
		string.format("Time: %02d:%02d", minutes, seconds)

	local t = tick() * 2
	textLabel.TextColor3 = getRainbowColor(t)
end)