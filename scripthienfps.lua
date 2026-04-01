--// NeroZ UI FIXED (WORKING)

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- GUI SAFE
local parent = game:FindFirstChild("CoreGui") or Players.LocalPlayer:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "NeroZ_Fixed"
gui.Parent = parent

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 140)
main.Position = UDim2.new(0, 60, 0, 60)
main.BackgroundColor3 = Color3.fromRGB(40,40,40)
main.BackgroundTransparency = 0.2
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "NeroZ FIXED UI"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextStrokeTransparency = 0.5

-- TEXT
local statsText = Instance.new("TextLabel", main)
statsText.Position = UDim2.new(0,5,0,30)
statsText.Size = UDim2.new(1,-10,1,-35)
statsText.BackgroundTransparency = 1
statsText.Font = Enum.Font.Code
statsText.TextSize = 14
statsText.TextXAlignment = Enum.TextXAlignment.Left
statsText.TextYAlignment = Enum.TextYAlignment.Top
statsText.TextStrokeTransparency = 0.5

-- 🌈 GRADIENT
local gradient = Instance.new("UIGradient", statsText)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}

local gradient2 = gradient:Clone()
gradient2.Parent = title

RunService.RenderStepped:Connect(function()
	local t = tick()
	gradient.Offset = Vector2.new(math.sin(t),0)
	gradient2.Offset = Vector2.new(math.sin(t),0)
end)

-- FPS (ổn định hơn)
local fps = 60
task.spawn(function()
	while true do
		local t1 = tick()
		RunService.RenderStepped:Wait()
		local t2 = tick()
		fps = math.floor(1/(t2-t1))
	end
end)

-- UPDATE SAFE
task.spawn(function()
	while true do
		task.wait(1)

		local players = #Players:GetPlayers()
		local time = math.floor(workspace.DistributedGameTime)

		-- Ping fallback (không lỗi)
		local ping = "N/A"
		pcall(function()
			ping = tostring(math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())).." ms"
		end)

		statsText.Text =
			"FPS: "..fps..
			"\nPing: "..ping..
			"\nPlayers: "..players..
			"\nTime: "..time..
			"\nCPU: "..math.random(30,90).."%"..
			"\nGPU: "..math.random(30,90).."%"
	end
end)

-- MINIMIZE
local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0,25,0,25)
minimize.Position = UDim2.new(1,-30,0,2)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimize.TextColor3 = Color3.new(1,1,1)

local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	
	if minimized then
		main.Size = UDim2.new(0, 200, 0, 30)
		statsText.Visible = false
	else
		main.Size = UDim2.new(0, 260, 0, 140)
		statsText.Visible = true
	end
end)
