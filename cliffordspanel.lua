--// CLIFFORD'S ADMIN V5.0 — INFINITE YIELD INTEGRATION
--// Using Infinite Yield source code for core functionality

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

-- Cleanup existing GUI
pcall(function()
	if LocalPlayer.PlayerGui:FindFirstChild("CliffordsMenu") then
		LocalPlayer.PlayerGui.CliffordsMenu:Destroy()
	end
end)

-----------------------------
-- INFINITE YIELD HELPER FUNCTIONS
-----------------------------
local function getRoot(char)
	return char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
end

local function getHumanoid(char)
	return char:FindFirstChildOfClass('Humanoid')
end

local function r15(plr)
	local char = plr.Character
	if char then
		local hum = getHumanoid(char)
		if hum then
			return hum.RigType == Enum.HumanoidRigType.R15
		end
	end
	return false
end

-- Get player by name (from IY)
local function getPlayer(name, speaker)
	if not name or name == "" then return {} end
	local nameList = name:lower():split(",")
	local foundPlayers = {}
	
	for _, playerName in pairs(nameList) do
		-- Special cases
		if playerName == "me" then
			table.insert(foundPlayers, speaker)
		elseif playerName == "all" then
			for _, plr in pairs(Players:GetPlayers()) do
				table.insert(foundPlayers, plr)
			end
		elseif playerName == "others" then
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= speaker then
					table.insert(foundPlayers, plr)
				end
			end
		elseif playerName == "random" then
			local plrs = Players:GetPlayers()
			table.insert(foundPlayers, plrs[math.random(1, #plrs)])
		else
			-- Search by name
			for _, plr in pairs(Players:GetPlayers()) do
				if plr.Name:lower():find(playerName) or plr.DisplayName:lower():find(playerName) then
					table.insert(foundPlayers, plr)
				end
			end
		end
	end
	
	return foundPlayers
end

-----------------------------
-- NOTIFICATION SYSTEM
-----------------------------
local function notify(title, message, duration)
	duration = duration or 3
	task.spawn(function()
		local notif = Instance.new("ScreenGui")
		notif.Name = "Notification"
		notif.Parent = CoreGui
		notif.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		
		local frame = Instance.new("Frame", notif)
		frame.Size = UDim2.new(0, 320, 0, 90)
		frame.Position = UDim2.new(1, -330, 1, 100)
		frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		frame.ZIndex = 10000
		
		local corner = Instance.new("UICorner", frame)
		corner.CornerRadius = UDim.new(0, 10)
		
		local stroke = Instance.new("UIStroke", frame)
		stroke.Color = Color3.fromRGB(190, 0, 0)
		stroke.Thickness = 2
		
		local titleLabel = Instance.new("TextLabel", frame)
		titleLabel.Size = UDim2.new(1, -20, 0, 28)
		titleLabel.Position = UDim2.new(0, 10, 0, 8)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.TextSize = 16
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.ZIndex = 10001
		
		local msgLabel = Instance.new("TextLabel", frame)
		msgLabel.Size = UDim2.new(1, -20, 0, 48)
		msgLabel.Position = UDim2.new(0, 10, 0, 36)
		msgLabel.BackgroundTransparency = 1
		msgLabel.Text = message
		msgLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
		msgLabel.Font = Enum.Font.Gotham
		msgLabel.TextSize = 14
		msgLabel.TextXAlignment = Enum.TextXAlignment.Left
		msgLabel.TextYAlignment = Enum.TextYAlignment.Top
		msgLabel.TextWrapped = true
		msgLabel.ZIndex = 10001
		
		TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -330, 1, -100)}):Play()
		task.wait(duration)
		
		local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, -330, 1, 100)})
		tween:Play()
		tween.Completed:Wait()
		notif:Destroy()
	end)
end

-----------------------------
-- MAIN GUI SETUP
-----------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "CliffordsMenu"
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 650)
main.Position = UDim2.new(0.5, -250, 0.5, -325)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
main.ZIndex = 100

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 15)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(190, 0, 0)
mainStroke.Thickness = 3

local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.BackgroundColor3 = Color3.fromRGB(190, 0, 0)
titleBar.ZIndex = 101

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "CLIFFORD'S ADMIN"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 102

local version = Instance.new("TextLabel", titleBar)
version.Size = UDim2.new(0, 100, 0, 20)
version.Position = UDim2.new(1, -110, 0, 5)
version.BackgroundTransparency = 1
version.Text = "v5.0 IY"
version.TextColor3 = Color3.fromRGB(200, 200, 200)
version.Font = Enum.Font.GothamBold
version.TextSize = 12
version.TextXAlignment = Enum.TextXAlignment.Right
version.ZIndex = 102

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.ZIndex = 102

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
	main.Visible = false
	notify("Menu", "Closed - Press RightShift to reopen")
end)

local contentFrame = Instance.new("Frame", main)
contentFrame.Size = UDim2.new(1, -20, 1, -80)
contentFrame.Position = UDim2.new(0, 10, 0, 70)
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
contentFrame.ZIndex = 101

local contentCorner = Instance.new("UICorner", contentFrame)
contentCorner.CornerRadius = UDim.new(0, 10)

local scroll = Instance.new("ScrollingFrame", contentFrame)
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 4
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ZIndex = 102

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
end)

-----------------------------
-- UI BUILDERS
-----------------------------
local shade1 = Color3.fromRGB(50, 50, 50)
local shade2 = Color3.fromRGB(45, 45, 45)
local shade3 = Color3.fromRGB(78, 78, 79)

function addLabel(text)
	local l = Instance.new("TextLabel", scroll)
	l.Size = UDim2.new(1, -10, 0, 35)
	l.BackgroundColor3 = shade1
	l.TextColor3 = Color3.new(1, 1, 1)
	l.Font = Enum.Font.GothamBold
	l.TextSize = 16
	l.Text = text
	l.ZIndex = 103
	
	local corner = Instance.new("UICorner", l)
	corner.CornerRadius = UDim.new(0, 8)
	
	return l
end

function addToggleButton(text, onCallback, offCallback)
	local container = Instance.new("Frame", scroll)
	container.Size = UDim2.new(1, -10, 0, 50)
	container.BackgroundColor3 = shade2
	container.ZIndex = 103
	
	local corner = Instance.new("UICorner", container)
	corner.CornerRadius = UDim.new(0, 8)
	
	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1, -75, 1, 0)
	label.Position = UDim2.new(0, 15, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 104
	
	local toggleButton = Instance.new("TextButton", container)
	toggleButton.Size = UDim2.new(0, 55, 0, 32)
	toggleButton.Position = UDim2.new(1, -65, 0.5, -16)
	toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	toggleButton.Text = "OFF"
	toggleButton.TextColor3 = Color3.new(1, 1, 1)
	toggleButton.Font = Enum.Font.GothamBold
	toggleButton.TextSize = 13
	toggleButton.ZIndex = 104
	
	local toggleCorner = Instance.new("UICorner", toggleButton)
	toggleCorner.CornerRadius = UDim.new(0, 8)
	
	local isOn = false
	
	toggleButton.MouseButton1Click:Connect(function()
		isOn = not isOn
		
		if isOn then
			toggleButton.Text = "ON"
			TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
			pcall(onCallback)
		else
			toggleButton.Text = "OFF"
			TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 0, 0)}):Play()
			pcall(offCallback)
		end
	end)
	
	return container, toggleButton
end

function addSlider(text, min, max, default, callback)
	local container = Instance.new("Frame", scroll)
	container.Size = UDim2.new(1, -10, 0, 65)
	container.BackgroundColor3 = shade2
	container.ZIndex = 103
	
	local corner = Instance.new("UICorner", container)
	corner.CornerRadius = UDim.new(0, 8)
	
	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1, -20, 0, 22)
	label.Position = UDim2.new(0, 10, 0, 8)
	label.BackgroundTransparency = 1
	label.Text = text .. ": " .. default
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 104
	
	local sliderBG = Instance.new("Frame", container)
	sliderBG.Size = UDim2.new(1, -20, 0, 22)
	sliderBG.Position = UDim2.new(0, 10, 0, 35)
	sliderBG.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	sliderBG.ZIndex = 104
	
	local sliderCorner = Instance.new("UICorner", sliderBG)
	sliderCorner.CornerRadius = UDim.new(0, 11)
	
	local sliderFill = Instance.new("Frame", sliderBG)
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	sliderFill.BorderSizePixel = 0
	sliderFill.ZIndex = 105
	
	local fillCorner = Instance.new("UICorner", sliderFill)
	fillCorner.CornerRadius = UDim.new(0, 11)
	
	local currentValue = default
	
	local function updateSlider(input)
		local relativeX = math.clamp((input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
		currentValue = math.floor(min + (max - min) * relativeX)
		sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
		label.Text = text .. ": " .. currentValue
		pcall(callback, currentValue)
	end
	
	sliderBG.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateSlider(input)
			
			local moveConnection
			local releaseConnection
			
			moveConnection = UIS.InputChanged:Connect(function(input2)
				if input2.UserInputType == Enum.UserInputType.MouseMovement then
					updateSlider(input2)
				end
			end)
			
			releaseConnection = UIS.InputEnded:Connect(function(input2)
				if input2.UserInputType == Enum.UserInputType.MouseButton1 then
					moveConnection:Disconnect()
					releaseConnection:Disconnect()
				end
			end)
		end
	end)
	
	return container
end

function addButton(text, callback)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(1, -10, 0, 45)
	b.BackgroundColor3 = Color3.fromRGB(190, 0, 0)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 15
	b.Text = text
	b.ZIndex = 103
	
	local corner = Instance.new("UICorner", b)
	corner.CornerRadius = UDim.new(0, 8)
	
	b.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
	
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(210, 0, 0)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(190, 0, 0)}):Play()
	end)
	
	return b
end

function addBox(placeholder)
	local box = Instance.new("TextBox", scroll)
	box.Size = UDim2.new(1, -10, 0, 45)
	box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.Gotham
	box.TextSize = 15
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
	box.ZIndex = 103
	
	local corner = Instance.new("UICorner", box)
	corner.CornerRadius = UDim.new(0, 8)
	
	local stroke = Instance.new("UIStroke", box)
	stroke.Color = Color3.fromRGB(100, 100, 100)
	stroke.Thickness = 1
	
	return box
end

-----------------------------
-- INFINITE YIELD FLY (FROM IY SOURCE)
-----------------------------
local flySpeed = 1
local vehicleflyspeed = 1
local Clip = true
local FLYING = false
local FLYOBJ, FLYGYRO

function sFLY(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	repeat wait() until IYMouse
	
	local T = getRoot(Players.LocalPlayer.Character)
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0
	
	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	IYMouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or flySpeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = -(vfly and vehicleflyspeed or flySpeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = -(vfly and vehicleflyspeed or flySpeed)
		elseif KEY:lower() == 'd' then
			CONTROL.R = (vfly and vehicleflyspeed or flySpeed)
		elseif KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or flySpeed)*2
		elseif KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or flySpeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	IYMouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end

function NOFLY()
	FLYING = false
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
end

-----------------------------
-- ESP FUNCTION (FROM IY SOURCE)
-----------------------------
local ESPenabled = false

function ESP(plr)
	task.spawn(function()
		for i,v in pairs(CoreGui:GetChildren()) do
			if v.Name == plr.Name..'_ESP' then
				v:Destroy()
			end
		end
		wait()
		if plr.Character and plr.Name ~= Players.LocalPlayer.Name and not CoreGui:FindFirstChild(plr.Name..'_ESP') then
			local ESPholder = Instance.new("Folder")
			ESPholder.Name = plr.Name..'_ESP'
			ESPholder.Parent = CoreGui
			repeat wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
			for b,n in pairs (plr.Character:GetChildren()) do
				if (n:IsA("BasePart")) then
					local a = Instance.new("BoxHandleAdornment")
					a.Name = plr.Name
					a.Parent = ESPholder
					a.Adornee = n
					a.AlwaysOnTop = true
					a.ZIndex = 10
					a.Size = n.Size
					a.Transparency = 0.3
					a.Color = plr.TeamColor
				end
			end
			if plr.Character and plr.Character:FindFirstChild('Head') then
				local BillboardGui = Instance.new("BillboardGui")
				local TextLabel = Instance.new("TextLabel")
				BillboardGui.Adornee = plr.Character.Head
				BillboardGui.Name = plr.Name
				BillboardGui.Parent = ESPholder
				BillboardGui.Size = UDim2.new(0, 100, 0, 150)
				BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
				BillboardGui.AlwaysOnTop = true
				TextLabel.Parent = BillboardGui
				TextLabel.BackgroundTransparency = 1
				TextLabel.Position = UDim2.new(0, 0, 0, -50)
				TextLabel.Size = UDim2.new(0, 100, 0, 100)
				TextLabel.Font = Enum.Font.SourceSansSemibold
				TextLabel.TextSize = 20
				TextLabel.TextColor3 = Color3.new(1, 1, 1)
				TextLabel.TextStrokeTransparency = 0
				TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
				TextLabel.Text = 'Name: '..plr.Name
				TextLabel.ZIndex = 10
				local espLoopFunc
				local function espLoop()
					if CoreGui:FindFirstChild(plr.Name..'_ESP') then
						if plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid") and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
							local pos = math.floor((getRoot(Players.LocalPlayer.Character).Position - getRoot(plr.Character).Position).magnitude)
							TextLabel.Text = 'Name: '..plr.Name..' | Health: '..math.floor(plr.Character:FindFirstChildOfClass('Humanoid').Health)..' | Studs: '..pos
						end
					else
						espLoopFunc:Disconnect()
					end
				end
				espLoopFunc = RunService.RenderStepped:Connect(espLoop)
			end
		end
	end)
end

-----------------------------
-- FLING FUNCTION (FROM IY SOURCE)
-----------------------------
local flinging = false

function fling()
	task.spawn(function()
		local Char = Players.LocalPlayer.Character
		local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
		local RootPart = Hum and Hum.RootPart

		flinging = true
		local BV = Instance.new("BodyAngularVelocity")
		BV.Name = "Spinning"
		BV.Parent = RootPart
		BV.MaxTorque = Vector3.new(0, math.huge, 0)
		BV.AngularVelocity = Vector3.new(0, 20000, 0)

		while flinging and RootPart and BV.Parent do
			task.wait()
			Hum.PlatformStand = true
			Hum.Sit = false
		end

		if BV then BV:Destroy() end
		if Hum then
			Hum.PlatformStand = false
			Hum.Sit = false
		end
	end)
end

function unfling()
	flinging = false
	local Char = Players.LocalPlayer.Character
	local RootPart = Char and getRoot(Char)
	if RootPart then
		for _, v in pairs(RootPart:GetChildren()) do
			if v.Name == "Spinning" then
				v:Destroy()
			end
		end
	end
end

-----------------------------
-- BUILD GUI
-----------------------------
IYMouse = Players.LocalPlayer:GetMouse()

addLabel("Movement Controls")

-- FLY
addToggleButton("Fly Mode", 
	function()
		sFLY()
		notify("Fly", "Enabled - WASD to move, Q/E for up/down")
	end,
	function()
		NOFLY()
		notify("Fly", "Disabled")
	end
)

-- Fly Speed Slider
addSlider("Fly Speed", 0.1, 5, 1, function(value)
	flySpeed = value
end)

-- NOCLIP
local noclipConnection
addToggleButton("Noclip",
	function()
		Clip = false
		notify("Noclip", "Enabled")
		
		if noclipConnection then
			noclipConnection:Disconnect()
		end
		
		noclipConnection = RunService.Stepped:Connect(function()
			pcall(function()
				if not Clip and Players.LocalPlayer.Character then
					for _, v in pairs(Players.LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") then 
							v.CanCollide = false 
						end
					end
				end
			end)
		end)
	end,
	function()
		Clip = true
		notify("Noclip", "Disabled")
		
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end
		
		pcall(function()
			if Players.LocalPlayer.Character then
				for _, v in pairs(Players.LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") then 
						v.CanCollide = true 
					end
				end
			end
		end)
	end
)

-- Walk Speed Slider
addSlider("Walk Speed", 16, 250, 16, function(value)
	pcall(function()
		local char = Players.LocalPlayer.Character
		if char then
			local hum = getHumanoid(char)
			if hum then
				hum.WalkSpeed = value
			end
		end
	end)
end)

-- Jump Power Slider
addSlider("Jump Power", 50, 350, 50, function(value)
	pcall(function()
		local char = Players.LocalPlayer.Character
		if char then
			local hum = getHumanoid(char)
			if hum then
				hum.JumpPower = value
			end
		end
	end)
end)

addLabel("Player Actions")

-- ESP
addToggleButton("ESP (All Players)",
	function()
		ESPenabled = true
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= Players.LocalPlayer then
				ESP(plr)
			end
		end
		notify("ESP", "Enabled for all players")
	end,
	function()
		ESPenabled = false
		for _, v in pairs(CoreGui:GetChildren()) do
			if v.Name:match("_ESP$") then
				v:Destroy()
			end
		end
		notify("ESP", "Disabled")
	end
)

-- GOTO
local gotoBox = addBox("Enter Player Name")

addButton("Goto Player", function()
	local targetName = gotoBox.Text
	if targetName == "" then 
		notify("Error", "Enter a player name")
		return 
	end
	
	local players = getPlayer(targetName, Players.LocalPlayer)
	if #players > 0 then
		local targetPlayer = players[1]
		pcall(function()
			if targetPlayer.Character then
				local tRoot = getRoot(targetPlayer.Character)
				local root = getRoot(Players.LocalPlayer.Character)
				
				if root and tRoot then
					root.CFrame = tRoot.CFrame * CFrame.new(0, 3, 0)
					notify("Teleport", "Teleported to " .. targetPlayer.Name)
				end
			end
		end)
	else
		notify("Error", "Player not found: " .. targetName)
	end
end)

-- LOOP GOTO
local loopGotoEnabled = false
addToggleButton("Loop Goto Player",
	function()
		loopGotoEnabled = true
		notify("Loop Goto", "Enabled")
		
		task.spawn(function()
			while loopGotoEnabled do
				task.wait(0.2)

				local targetName = gotoBox.Text
				if targetName == "" then continue end
				
				local players = getPlayer(targetName, Players.LocalPlayer)
				if #players > 0 then
					local targetPlayer = players[1]
					pcall(function()
						if targetPlayer.Character then
							local tRoot = getRoot(targetPlayer.Character)
							local root = getRoot(Players.LocalPlayer.Character)
							
							if root and tRoot then
								root.CFrame = tRoot.CFrame * CFrame.new(0, 3, 0)
							end
						end
					end)
				end
			end
		end)
	end,
	function()
		loopGotoEnabled = false
		notify("Loop Goto", "Disabled")
	end
)

addLabel("Animations")

local animBox = addBox("Animation ID")

addButton("Play Animation", function()
	local id = tonumber(animBox.Text)
	if not id then 
		notify("Error", "Invalid animation ID")
		return 
	end
	
	pcall(function()
		if Players.LocalPlayer.Character then
			local hum = getHumanoid(Players.LocalPlayer.Character)
			if hum then
				local animator = hum:FindFirstChildOfClass("Animator")
				if not animator then
					animator = Instance.new("Animator")
					animator.Parent = hum
				end
				
				local anim = Instance.new("Animation")
				anim.AnimationId = "rbxassetid://" .. id
				
				local animTrack = animator:LoadAnimation(anim)
				animTrack:Play()
				
				notify("Animation", "Playing animation: " .. id)
			end
		end
	end)
end)

addButton("Stop All Animations", function()
	pcall(function()
		if Players.LocalPlayer.Character then
			local hum = getHumanoid(Players.LocalPlayer.Character)
			if hum then
				local animator = hum:FindFirstChildOfClass("Animator")
				if animator then
					for _, track in pairs(animator:GetPlayingAnimationTracks()) do
						track:Stop()
					end
					notify("Animation", "Stopped all animations")
				end
			end
		end
	end)
end)

addLabel("Fling / Combat")

-- FLING
addToggleButton("Fling (Touch Players)",
	function()
		fling()
		notify("Fling", "Enabled - Touch players to fling them")
	end,
	function()
		unfling()
		notify("Fling", "Disabled")
	end
)

-- FLING SPECIFIC PLAYER
local flingPlayerBox = addBox("Player to Fling")

addButton("Fling Specified Player", function()
	local targetName = flingPlayerBox.Text
	if targetName == "" then 
		notify("Error", "Enter a player name")
		return 
	end
	
	local players = getPlayer(targetName, Players.LocalPlayer)
	if #players > 0 then
		local targetPlayer = players[1]
		
		-- Start fling
		fling()
		
		-- Teleport to player repeatedly while flinging
		task.spawn(function()
			for i = 1, 30 do
				if not flinging then break end
				
				pcall(function()
					if targetPlayer.Character then
						local tRoot = getRoot(targetPlayer.Character)
						local root = getRoot(Players.LocalPlayer.Character)
						
						if root and tRoot then
							root.CFrame = tRoot.CFrame
						end
					end
				end)
				
				task.wait(0.1)
			end
			
			-- Stop flinging after 3 seconds
			unfling()
			notify("Fling", "Completed fling on " .. targetPlayer.Name)
		end)
		
		notify("Fling", "Flinging " .. targetPlayer.Name)
	else
		notify("Error", "Player not found: " .. targetName)
	end
end)

addLabel("Utilities")

addButton("Respawn", function()
	pcall(function()
		local char = Players.LocalPlayer.Character
		if char then
			local hum = getHumanoid(char)
			if hum then
				hum.Health = 0
				notify("Respawn", "Respawning...")
			end
		end
	end)
end)

addButton("Reset Camera", function()
	pcall(function()
		workspace.CurrentCamera.CameraSubject = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		Players.LocalPlayer.CameraMaxZoomDistance = 400
		Players.LocalPlayer.CameraMinZoomDistance = 0.5
		notify("Camera", "Camera reset")
	end)
end)

-----------------------------
-- HOTKEY TOGGLE
-----------------------------
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.RightShift then
		main.Visible = not main.Visible
		if main.Visible then
			notify("Menu", "Opened")
		else
			notify("Menu", "Closed")
		end
	end
end)

-----------------------------
-- CLEANUP ON RESPAWN
-----------------------------
Players.LocalPlayer.CharacterAdded:Connect(function()
	NOFLY()
	flinging = false
	Clip = true
	
	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end
end)

-----------------------------
-- INITIAL LOAD
-----------------------------
notify("Clifford's Admin", "Loaded v5.0 with IY Integration! Press RightShift to toggle", 5)
