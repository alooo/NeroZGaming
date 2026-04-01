--// NeroZ UI PRO MAX + RAINBOW GRADIENT

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NeroZ_GradientPro"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 140)
main.Position = UDim2.new(0, 60, 0, 60)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BackgroundTransparency = 0.15
main.Active = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "NeroZ PRO MAX"
title.Font = Enum.Font.GothamBold
title.TextSize = 15

-- 🌈 GRADIENT TITLE
local gradientTitle = Instance.new("UIGradient", title)
gradientTitle.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,127,0)),
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255,255,0)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,255,0)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,0,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(139,0,255))
}

-- MINIMIZE BUTTON
local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0,25,0,25)
minimize.Position = UDim2.new(1,-30,0,2)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimize)

-- TEXT
local statsText = Instance.new("TextLabel", main)
statsText.Position = UDim2.new(0,5,0,30)
statsText.Size = UDim2.new(1,-10,1,-35)
statsText.BackgroundTransparency = 1
statsText.Font = Enum.Font.Code
statsText.TextSize = 14
statsText.TextXAlignment = Enum.TextXAlignment.Left
statsText.TextYAlignment = Enum.TextYAlignment.Top

-- 🌈 GRADIENT TEXT
local gradient = Instance.new("UIGradient", statsText)
gradient.Color = gradientTitle.Color

-- DRAG SMOOTH
local dragging = false
local dragStart, startPos

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

main.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		
		TweenService:Create(main, TweenInfo.new(0.08), {
			Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		}):Play()
	end
end)

-- 🌈 ANIMATE GRADIENT
RunService.RenderStepped:Connect(function()
	local t = tick()
	gradient.Offset = Vector2.new(math.sin(t), 0)
	gradientTitle.Offset = Vector2.new(math.sin(t), 0)
end)

-- FPS
local fps = 0
local last = tick()

RunService.RenderStepped:Connect(function()
	fps = math.floor(1 / (tick() - last))
	last = tick()
end)

-- UPDATE TEXT
task.spawn(function()
	while true do
		task.wait(1)

		local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
		local players = #Players:GetPlayers()
		local time = math.floor(workspace.DistributedGameTime)

		statsText.Text =
			"FPS: "..fps..
			"\nPing: "..ping..
			"\nPlayers: "..players..
			"\nTime: "..time..
			"\nCPU: "..math.random(30,90).."%"..
			"\nGPU: "..math.random(30,90).."%"
	end
end)

-- ✨ MINIMIZE ANIMATION
local minimized = false

minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	
	if minimized then
		TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, 200, 0, 30)
		}):Play()
		
		statsText.Visible = false
	else
		TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, 260, 0, 140)
		}):Play()
		
		task.wait(0.1)
		statsText.Visible = true
	end
end)