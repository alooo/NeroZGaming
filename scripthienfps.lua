--// Simple Rainbow Stats (giống ảnh)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)

local label = Instance.new("TextLabel", gui)
label.Position = UDim2.new(0, 10, 0, 10)
label.Size = UDim2.new(0, 180, 0, 90)
label.BackgroundTransparency = 1
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.Font = Enum.Font.Code
label.TextSize = 14

-- 🌈 Rainbow
local hue = 0
RunService.RenderStepped:Connect(function()
	hue += 0.01
	if hue > 1 then hue = 0 end
	label.TextColor3 = Color3.fromHSV(hue,1,1)
end)

-- FPS
local fps = 60
task.spawn(function()
	while true do
		local t1 = tick()
		RunService.RenderStepped:Wait()
		local t2 = tick()
		fps = math.floor(1/(t2-t1))
	end
end)

-- UPDATE
task.spawn(function()
	while true do
		task.wait(1)

		local players = #Players:GetPlayers()
		local time = math.floor(workspace.DistributedGameTime)

		local ping = "N/A"
		pcall(function()
			ping = tostring(math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())).." ms"
		end)

		label.Text =
			"FPS: "..fps..
			"\nPlayers: "..players..
			"\nPing: "..ping..
			"\nTime: "..time
	end
end)
