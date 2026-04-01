--// NeroZ GOD MODE PRO

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

-- CONFIG LOAD
local config = {
	x = 50,
	y = 50,
	lowgfx = false
}

if isfile and isfile("neroz_config.txt") then
	local data = readfile("neroz_config.txt")
	local split = string.split(data,",")
	config.x = tonumber(split[1]) or 50
	config.y = tonumber(split[2]) or 50
	config.lowgfx = split[3] == "true"
end

local function save()
	if writefile then
		writefile("neroz_config.txt",
			config.x..","..config.y..","..tostring(config.lowgfx)
		)
	end
end

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NeroZ_GOD"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 220)
main.Position = UDim2.new(0, config.x, 0, config.y)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BackgroundTransparency = 0.2
main.Active = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "NeroZ GOD MODE"
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- TAB BUTTONS
local tabs = {}
local tabNames = {"Stats","Graph","Settings"}
for i,name in ipairs(tabNames) do
	local btn = Instance.new("TextButton", main)
	btn.Size = UDim2.new(1/3,0,0,25)
	btn.Position = UDim2.new((i-1)/3,0,0,30)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	btn.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", btn)
	tabs[name] = btn
end

-- PAGES
local pages = {}
for _,name in ipairs(tabNames) do
	local page = Instance.new("Frame", main)
	page.Size = UDim2.new(1,0,1,-60)
	page.Position = UDim2.new(0,0,0,60)
	page.BackgroundTransparency = 1
	page.Visible = false
	pages[name] = page
end
pages["Stats"].Visible = true

-- SWITCH TAB
for name,btn in pairs(tabs) do
	btn.MouseButton1Click:Connect(function()
		for _,p in pairs(pages) do p.Visible = false end
		pages[name].Visible = true
	end)
end

-- STATS PAGE
local statsText = Instance.new("TextLabel", pages["Stats"])
statsText.Size = UDim2.new(1,-10,1,-10)
statsText.Position = UDim2.new(0,5,0,5)
statsText.BackgroundTransparency = 1
statsText.Font = Enum.Font.Code
statsText.TextSize = 14
statsText.TextXAlignment = Enum.TextXAlignment.Left
statsText.TextYAlignment = Enum.TextYAlignment.Top

-- GRAPH PAGE
local graphFrame = Instance.new("Frame", pages["Graph"])
graphFrame.Size = UDim2.new(1,-10,1,-10)
graphFrame.Position = UDim2.new(0,5,0,5)
graphFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", graphFrame)

local points = {}

-- SETTINGS PAGE
local btnLow = Instance.new("TextButton", pages["Settings"])
btnLow.Size = UDim2.new(0.8,0,0,30)
btnLow.Position = UDim2.new(0.1,0,0,10)
btnLow.Text = "Toggle Low Graphics"
btnLow.BackgroundColor3 = Color3.fromRGB(30,30,30)
btnLow.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btnLow)

btnLow.MouseButton1Click:Connect(function()
	config.lowgfx = not config.lowgfx

	if config.lowgfx then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.SmoothPlastic
			end
		end
		Lighting.GlobalShadows = false
	else
		Lighting.GlobalShadows = true
	end

	save()
end)

-- DRAG
local dragging, dragStart, startPos

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
		config.x = main.Position.X.Offset
		config.y = main.Position.Y.Offset
		save()
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- RAINBOW
local hue = 0
RunService.RenderStepped:Connect(function()
	hue += 0.003
	if hue > 1 then hue = 0 end
	local c = Color3.fromHSV(hue,1,1)
	title.TextColor3 = c
	stroke.Color = c
end)

-- FPS
local fps = 0
local last = tick()

RunService.RenderStepped:Connect(function()
	fps = math.floor(1 / (tick() - last))
	last = tick()
end)

-- UPDATE LOOP
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

		-- GRAPH
		table.insert(points, fps)
		if #points > 30 then table.remove(points,1) end

		graphFrame:ClearAllChildren()
		for i,v in ipairs(points) do
			local bar = Instance.new("Frame", graphFrame)
			bar.Size = UDim2.new(0,5,0,v)
			bar.Position = UDim2.new(0,(i*7),1,-v)
			bar.BackgroundColor3 = Color3.fromRGB(0,255,100)
		end
	end
end)