--// CLIFFORD'S MENU V4.0 — PREMIUM ADMIN PANEL
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Cleanup existing GUI
pcall(function()
	if LocalPlayer.PlayerGui:FindFirstChild("CliffordsMenu") then
		LocalPlayer.PlayerGui.CliffordsMenu:Destroy()
	end
end)

-----------------------------
-- CONFIGURATION
-----------------------------
local Config = {
	ToggleKey = Enum.KeyCode.RightShift, -- Change this to customize hotkey
	FlySpeed = 100,
	FlyEnabled = false
}

-----------------------------
-- NOTIFICATION SYSTEM
-----------------------------
local function notify(title, message, duration)
	duration = duration or 3
	task.spawn(function()
		local notif = Instance.new("ScreenGui")
		notif.Name = "Notification"
		notif.Parent = LocalPlayer.PlayerGui
		notif.ResetOnSpawn = false
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
		titleLabel.Text = "🔴 " .. title
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
		
		-- Slide in
		TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -330, 1, -100)}):Play()
		
		task.wait(duration)
		
		-- Slide out
		local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, -330, 1, 100)})
		tween:Play()
		tween.Completed:Wait()
		notif:Destroy()
	end)
end

-----------------------------
-- HELPER FUNCTIONS
-----------------------------
local function getRoot(char)
	return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function getHumanoid(char)
	return char:FindFirstChildOfClass("Humanoid")
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

-----------------------------
-- MAIN GUI
-----------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "CliffordsMenu"
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main container
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 450, 0, 600)
main.Position = UDim2.new(0.5, -225, 0.5, -300)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
main.ZIndex = 100

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 15)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(190, 0, 0)
mainStroke.Thickness = 3

-- Shadow effect
local shadow = Instance.new("ImageLabel", main)
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ZIndex = 99

-- Title bar
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
title.Text = "🔴 CLIFFORD'S ADMIN"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 102

-- Version label
local version = Instance.new("TextLabel", titleBar)
version.Size = UDim2.new(0, 100, 0, 20)
version.Position = UDim2.new(1, -110, 0, 5)
version.BackgroundTransparency = 1
version.Text = "v4.0"
version.TextColor3 = Color3.fromRGB(200, 200, 200)
version.Font = Enum.Font.GothamBold
version.TextSize = 12
version.TextXAlignment = Enum.TextXAlignment.Right
version.ZIndex = 102

-- Hotkey label
local hotkeyLabel = Instance.new("TextLabel", titleBar)
hotkeyLabel.Size = UDim2.new(0, 100, 0, 20)
hotkeyLabel.Position = UDim2.new(1, -110, 0, 25)
hotkeyLabel.BackgroundTransparency = 1
hotkeyLabel.Text = "RightShift to toggle"
hotkeyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
hotkeyLabel.Font = Enum.Font.Gotham
hotkeyLabel.TextSize = 10
hotkeyLabel.TextXAlignment = Enum.TextXAlignment.Right
hotkeyLabel.ZIndex = 102

-- Close button
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "✕"
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

-- Tab system
local tabContainer = Instance.new("Frame", main)
tabContainer.Size = UDim2.new(1, -20, 0, 45)
tabContainer.Position = UDim2.new(0, 10, 0, 70)
tabContainer.BackgroundTransparency = 1
tabContainer.ZIndex = 101

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 5)

-- Content area
local contentFrame = Instance.new("Frame", main)
contentFrame.Size = UDim2.new(1, -20, 1, -130)
contentFrame.Position = UDim2.new(0, 10, 0, 120)
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
contentFrame.ZIndex = 101

local contentCorner = Instance.new("UICorner", contentFrame)
contentCorner.CornerRadius = UDim.new(0, 10)

-- Scrolling frame
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
-- TAB SYSTEM
-----------------------------
local tabs = {}
local currentTab = nil

local function createTab(name, icon)
	local btn = Instance.new("TextButton", tabContainer)
	btn.Size = UDim2.new(0, 100, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.Text = icon .. " " .. name
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.ZIndex = 102
	
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 8)
	
	local tabData = {
		button = btn,
		name = name,
		elements = {}
	}
	
	btn.MouseButton1Click:Connect(function()
		for _, tab in pairs(tabs) do
			tab.button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
			for _, element in pairs(tab.elements) do
				element.Visible = false
			end
		end
		
		btn.BackgroundColor3 = Color3.fromRGB(190, 0, 0)
		btn.TextColor3 = Color3.new(1, 1, 1)
		for _, element in pairs(tabData.elements) do
			element.Visible = true
		end
		
		currentTab = tabData
	end)
	
	table.insert(tabs, tabData)
	return tabData
end

-----------------------------
-- UI BUILDERS
-----------------------------
function addToCurrentTab(element)
	if currentTab then
		table.insert(currentTab.elements, element)
		element.Visible = true
	end
	return element
end

function addLabel(text)
	local l = Instance.new("TextLabel", scroll)
	l.Size = UDim2.new(1, -10, 0, 35)
	l.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	l.TextColor3 = Color3.new(1, 1, 1)
	l.Font = Enum.Font.GothamBold
	l.TextSize = 16
	l.Text = text
	l.ZIndex = 103
	
	local corner = Instance.new("UICorner", l)
	corner.CornerRadius = UDim.new(0, 8)
	
	return addToCurrentTab(l)
end

function addToggleButton(text, onCallback, offCallback)
	local container = Instance.new("Frame", scroll)
	container.Size = UDim2.new(1, -10, 0, 50)
	container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
	label.TextSize = 15
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
	
	toggleButton.MouseEnter:Connect(function()
		if isOn then
			TweenService:Create(toggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 220, 0)}):Play()
		else
			TweenService:Create(toggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}):Play()
		end
	end)
	
	toggleButton.MouseLeave:Connect(function()
		if isOn then
			TweenService:Create(toggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
		else
			TweenService:Create(toggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(180, 0, 0)}):Play()
		end
	end)
	
	return addToCurrentTab(container), toggleButton
end

function addSlider(text, min, max, default, callback)
	local container = Instance.new("Frame", scroll)
	container.Size = UDim2.new(1, -10, 0, 65)
	container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
	
	return addToCurrentTab(container)
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
	
	return addToCurrentTab(b)
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
	
	return addToCurrentTab(box)
end

-----------------------------
-- CREATE TABS
-----------------------------
local movementTab = createTab("Movement", "✈️")
local playerTab = createTab("Player", "👤")
local teleportTab = createTab("Teleport", "🎯")
local miscTab = createTab("Misc", "⚙️")

-----------------------------
-- CONNECTION STORAGE
-----------------------------
local flyConnection
local noclipConnection
local flyBodyVelocity
local flyBodyGyro

-----------------------------
-- MOVEMENT TAB
-----------------------------
movementTab.button.BackgroundColor3 = Color3.fromRGB(190, 0, 0)
movementTab.button.TextColor3 = Color3.new(1, 1, 1)
currentTab = movementTab

addLabel("✈️ Flight Controls")

addToggleButton("Fly Mode", 
	function() -- ON
		Config.FlyEnabled = true
		notify("Fly", "Enabled - WASD + Space/Shift to move")
		
		local char = LocalPlayer.Character
		if not char then return end
		local root = getRoot(char)
		if not root then return end
		
		-- Create BodyVelocity and BodyGyro for smooth flying
		flyBodyVelocity = Instance.new("BodyVelocity")
		flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
		flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		flyBodyVelocity.Parent = root
		
		flyBodyGyro = Instance.new("BodyGyro")
		flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		flyBodyGyro.P = 9e4
		flyBodyGyro.Parent = root
		
		task.spawn(function()
			while Config.FlyEnabled do
				pcall(function()
					task.wait()
					
					if not char or not char.Parent then
						Config.FlyEnabled = false
						return
					end
					
					if not root or not root.Parent then
						Config.FlyEnabled = false
						return
					end
					
					local cam = workspace.CurrentCamera
					local dir = Vector3.zero
					
					if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
					if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
					if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
					if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
					if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
					if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
					
					if flyBodyVelocity and flyBodyVelocity.Parent then
						flyBodyVelocity.Velocity = dir.Unit * Config.FlySpeed
					end
					
					if flyBodyGyro and flyBodyGyro.Parent then
						flyBodyGyro.CFrame = cam.CFrame
					end
				end)
			end
			
			-- Cleanup
			if flyBodyVelocity then flyBodyVelocity:Destroy() end
			if flyBodyGyro then flyBodyGyro:Destroy() end
		end)
	end,
	function() -- OFF
		Config.FlyEnabled = false
		if flyBodyVelocity then flyBodyVelocity:Destroy() end
		if flyBodyGyro then flyBodyGyro:Destroy() end
		notify("Fly", "Disabled")
	end
)

addSlider("Fly Speed", 50, 300, 100, function(value)
	Config.FlySpeed = value
end)

addLabel("🚫 Collision")

addToggleButton("Noclip",
	function() -- ON
		_G.Noclip = true
		notify("Noclip", "Enabled")
		
		if noclipConnection then
			noclipConnection:Disconnect()
		end
		
		noclipConnection = RunService.Stepped:Connect(function()
			pcall(function()
				if _G.Noclip and LocalPlayer.Character then
					for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") then 
							v.CanCollide = false 
						end
					end
				end
			end)
		end)
	end,
	function() -- OFF
		_G.Noclip = false
		
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end
		
		pcall(function()
			if LocalPlayer.Character then
				for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") then 
						v.CanCollide = true 
					end
				end
			end
		end)
		
		notify("Noclip", "Disabled")
	end
)

addLabel("🏃 Speed Controls")

addSlider("Walk Speed", 16, 250, 16, function(value)
	pcall(function()
		local char = LocalPlayer.Character
		if char then
			local hum = getHumanoid(char)
			if hum then
				hum.WalkSpeed = value
			end
		end
	end)
end)

addSlider("Jump Power", 50, 350, 50, function(value)
	pcall(function()
		local char = LocalPlayer.Character
		if char then
			local hum = getHumanoid(char)
			if hum then
				hum.JumpPower = value
			end
		end
	end)
end)

-----------------------------
-- PLAYER TAB
-----------------------------
currentTab = playerTab

addLabel("❤️ Health Management")

addToggleButton("Loop Heal",
	function() -- ON
		_G.LoopHeal = true
		notify("Loop Heal", "Enabled")
		
		task.spawn(function()
			while _G.LoopHeal do
				task.wait(0.1)
				pcall(function()
					if LocalPlayer.Character then
						local hum = getHumanoid(LocalPlayer.Character)
						if hum then 
							hum.Health = hum.MaxHealth 
						end
					end
				end)
			end
		end)
	end,
	function() -- OFF
		_G.LoopHeal = false
		notify("Loop Heal", "Disabled")
	end
)

addToggleButton("God Mode (Client)",
	function() -- ON
		pcall(function()
			if LocalPlayer.Character then
				local hum = getHumanoid(LocalPlayer.Character)
				if hum then
					hum.MaxHealth = math.huge
					hum.Health = math.huge
					notify("God Mode", "Enabled (client-side)")
				end
			end
		end)
	end,
	function() -- OFF
		pcall(function()
			if LocalPlayer.Character then
				local hum = getHumanoid(LocalPlayer.Character)
				if hum then
					hum.MaxHealth = 100
					hum.Health = 100
					notify("God Mode", "Disabled")
				end
			end
		end)
	end
)

addButton("💊 Instant
