--// CLIFFORD'S MENU — FULL FEATURE VERSION (RED THEME) - TOGGLE BUTTON VERSION
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
-- NOTIFICATION SYSTEM
-----------------------------
local function notify(title, message, duration)
	duration = duration or 3
	task.spawn(function()
		local notif = Instance.new("ScreenGui")
		notif.Name = "Notification"
		notif.Parent = LocalPlayer.PlayerGui
		notif.ResetOnSpawn = false
		
		local frame = Instance.new("Frame", notif)
		frame.Size = UDim2.new(0, 300, 0, 80)
		frame.Position = UDim2.new(1, -310, 1, 100)
		frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		
		local corner = Instance.new("UICorner", frame)
		corner.CornerRadius = UDim.new(0, 8)
		
		local titleLabel = Instance.new("TextLabel", frame)
		titleLabel.Size = UDim2.new(1, -20, 0, 25)
		titleLabel.Position = UDim2.new(0, 10, 0, 5)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleLabel.Font = Enum.Font.SourceSansBold
		titleLabel.TextSize = 18
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		
		local msgLabel = Instance.new("TextLabel", frame)
		msgLabel.Size = UDim2.new(1, -20, 0, 45)
		msgLabel.Position = UDim2.new(0, 10, 0, 30)
		msgLabel.BackgroundTransparency = 1
		msgLabel.Text = message
		msgLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		msgLabel.Font = Enum.Font.SourceSans
		msgLabel.TextSize = 16
		msgLabel.TextXAlignment = Enum.TextXAlignment.Left
		msgLabel.TextWrapped = true
		
		-- Slide in
		TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(1, -310, 1, -90)}):Play()
		
		task.wait(duration)
		
		-- Slide out
		local tween = TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(1, -310, 1, 100)})
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

local function r15(plr)
	if plr.Character and plr.Character:FindFirstChildOfClass('Humanoid') then
		return plr.Character:FindFirstChildOfClass('Humanoid').RigType == Enum.HumanoidRigType.R15
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

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 550)
main.Position = UDim2.new(0.5, -200, 0.5, -275)
main.BackgroundColor3 = Color3.fromRGB(120,0,0)
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundColor3 = Color3.fromRGB(190,0,0)
title.Text = "🔴 Clifford's Admin Menu"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24

local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 12)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1,-12,1,-60)
scroll.Position = UDim2.new(0,6,0,55)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(80,0,0)
scroll.BorderSizePixel = 0

local scrollCorner = Instance.new("UICorner", scroll)
scrollCorner.CornerRadius = UDim.new(0, 8)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+20)
end)

-----------------------------
-- UI BUILDERS
-----------------------------
function addLabel(text)
	local l = Instance.new("TextLabel", scroll)
	l.Size = UDim2.new(1, -12, 0, 35)
	l.BackgroundColor3 = Color3.fromRGB(130,0,0)
	l.TextColor3 = Color3.new(1,1,1)
	l.Font = Enum.Font.SourceSansBold
	l.TextSize = 18
	l.Text = text
	
	local corner = Instance.new("UICorner", l)
	corner.CornerRadius = UDim.new(0, 6)
	return l
end

function addToggleButton(text, onCallback, offCallback)
	local container = Instance.new("Frame", scroll)
	container.Size = UDim2.new(1, -12, 0, 45)
	container.BackgroundColor3 = Color3.fromRGB(100,0,0)
	
	local corner = Instance.new("UICorner", container)
	corner.CornerRadius = UDim.new(0, 6)
	
	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	
	local toggleButton = Instance.new("TextButton", container)
	toggleButton.Size = UDim2.new(0, 50, 0, 30)
	toggleButton.Position = UDim2.new(1, -55, 0.5, -15)
	toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	toggleButton.Text = "OFF"
	toggleButton.TextColor3 = Color3.new(1,1,1)
	toggleButton.Font = Enum.Font.SourceSansBold
	toggleButton.TextSize = 14
	
	local toggleCorner = Instance.new("UICorner", toggleButton)
	toggleCorner.CornerRadius = UDim.new(0, 6)
	
	local isOn = false
	
	toggleButton.MouseButton1Click:Connect(function()
		isOn = not isOn
		
		if isOn then
			toggleButton.Text = "ON"
			toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
			TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 0)}):Play()
			pcall(onCallback)
		else
			toggleButton.Text = "OFF"
			TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 0, 0)}):Play()
			pcall(offCallback)
		end
	end)
	
	-- Hover effects
	toggleButton.MouseEnter:Connect(function()
		if isOn then
			TweenService:Create(toggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
		else
			TweenService:Create(toggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}):Play()
		end
	end)
	
	toggleButton.MouseLeave:Connect(function()
		if isOn then
			TweenService:Create(toggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 180, 0)}):Play()
		else
			TweenService:Create(toggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(180, 0, 0)}):Play()
		end
	end)
	
	return toggleButton, container
end

function addSlider(text, min, max, default, callback)
	local container = Instance.new("Frame", scroll)
	container.Size = UDim2.new(1, -12, 0, 60)
	container.BackgroundColor3 = Color3.fromRGB(100,0,0)
	
	local corner = Instance.new("UICorner", container)
	corner.CornerRadius = UDim.new(0, 6)
	
	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1, -20, 0, 20)
	label.Position = UDim2.new(0, 10, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = text .. ": " .. default
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	
	local sliderBG = Instance.new("Frame", container)
	sliderBG.Size = UDim2.new(1, -20, 0, 20)
	sliderBG.Position = UDim2.new(0, 10, 0, 30)
	sliderBG.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
	
	local sliderCorner = Instance.new("UICorner", sliderBG)
	sliderCorner.CornerRadius = UDim.new(0, 10)
	
	local sliderFill = Instance.new("Frame", sliderBG)
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
	sliderFill.BorderSizePixel = 0
	
	local fillCorner = Instance.new("UICorner", sliderFill)
	fillCorner.CornerRadius = UDim.new(0, 10)
	
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

function addBox(placeholder)
	local box = Instance.new("TextBox", scroll)
	box.Size = UDim2.new(1,-12,0,40)
	box.BackgroundColor3 = Color3.fromRGB(110,0,0)
	box.TextColor3 = Color3.new(1,1,1)
	box.Font = Enum.Font.SourceSans
	box.TextSize = 16
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
	
	local corner = Instance.new("UICorner", box)
	corner.CornerRadius = UDim.new(0, 6)
	
	return box
end

function addButton(text, callback)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(1, -12, 0, 40)
	b.BackgroundColor3 = Color3.fromRGB(160,0,0)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 16
	b.Text = text
	
	local corner = Instance.new("UICorner", b)
	corner.CornerRadius = UDim.new(0, 6)
	
	b.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
	
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180,0,0)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(160,0,0)}):Play()
	end)
	
	return b
end

-----------------------------
-- CONNECTION STORAGE
-----------------------------
local flyConnection
local noclipConnection

-----------------------------
-- FEATURES
-----------------------------

------------ MOVEMENT ------------
addLabel("✈️ Movement")

-- FLY TOGGLE
addToggleButton("Fly", 
	function() -- ON
		_G.Flying = true
		notify("Fly", "Enabled - Use WASD + Space/Shift")
		
		local speed = 50
		
		task.spawn(function()
			while _G.Flying do
				local success = pcall(function()
					task.wait()
					
					local char = LocalPlayer.Character
					if not char or not char.Parent then
						_G.Flying = false
						return
					end
					
					local root = getRoot(char)
					if not root or not root.Parent then
						_G.Flying = false
						return
					end
					
					local dir = Vector3.zero
					local cam = workspace.CurrentCamera

					if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
					if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
					if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
					if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
					if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
					if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir += Vector3.new(0, -1, 0) end

					root.Velocity = dir * speed
				end)
				
				if not success then
					_G.Flying = false
					break
				end
			end
		end)
	end,
	function() -- OFF
		_G.Flying = false
		notify("Fly", "Disabled")
	end
)

-- NOCLIP TOGGLE
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
					for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
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
		notify("Noclip", "Disabled")
		
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end
		
		pcall(function()
			if LocalPlayer.Character then
				for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") then 
						v.CanCollide = true 
					end
				end
			end
		end)
	end
)

-- WALK SPEED SLIDER
addSlider("Walk Speed", 16, 200, 16, function(value)
	pcall(function()
		local char = LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = value
			end
		end
	end)
end)

-- JUMP POWER SLIDER
addSlider("Jump Power", 50, 300, 50, function(value)
	pcall(function()
		local char = LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.JumpPower = value
			end
		end
	end)
end)

------------ HEALTH ------------
addLabel("❤️ Health")

-- LOOP HEAL TOGGLE
addToggleButton("Loop Heal",
	function() -- ON
		_G.LoopHeal = true
		notify("Loop Heal", "Enabled")
		
		task.spawn(function()
			while _G.LoopHeal do
				task.wait(0.1)
				pcall(function()
					if LocalPlayer.Character then
						local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
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

-- GOD MODE TOGGLE
addToggleButton("God Mode (Client)",
	function() -- ON
		pcall(function()
			if LocalPlayer.Character then
				local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.MaxHealth = math.huge
					hum.Health = math.huge
					notify("God Mode", "Enabled")
				end
			end
		end)
	end,
	function() -- OFF
		pcall(function()
			if LocalPlayer.Character then
				local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.MaxHealth = 100
					hum.Health = 100
					notify("God Mode", "Disabled")
				end
			end
		end)
	end
)

addButton("Instant Heal", function()
	pcall(function()
		if LocalPlayer.Character then
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then 
				hum.Health = hum.MaxHealth 
				notify("Heal", "Fully healed!")
			end
		end
	end)
end)

------------ CHARACTER ------------
addLabel("📐 Character")

-- SIZE SLIDER
addSlider("Character Size", 0.5, 3, 1, function(value)
	pcall(function()
		local char = LocalPlayer.Character
		if not char then return end
		
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum and r15(LocalPlayer) then
			hum.BodyDepthScale.Value = value
			hum.BodyHeightScale.Value = value
			hum.BodyWidthScale.Value = value
			hum.HeadScale.Value = value
		end
	end)
end)

------------ TELEPORT ------------
addLabel("🎯 Teleportation")

local gotoBox = addBox("Player Name")

-- LOOP GOTO TOGGLE
addToggleButton("Loop Goto Player",
	function() -- ON
		_G.loopGoto = true
		notify("Loop Goto", "Enabled")
		
		task.spawn(function()
			while _G.loopGoto do
				task.wait(0.2)

				local targetName = gotoBox.Text:lower()
				if targetName == "" then continue end
				
				for _,p in pairs(Players:GetPlayers()) do
					if p.Name:lower():find(targetName) and p ~= LocalPlayer then
						pcall(function()
							if not p.Character then return end
							
							local tRoot = getRoot(p.Character)
							local root = getRoot(LocalPlayer.Character)
							
							if root and tRoot then
								root.CFrame = tRoot.CFrame * CFrame.new(0, 3, 0)
							end
						end)
						break
					end
				end
			end
		end)
	end,
	function() -- OFF
		_G.loopGoto = false
		notify("Loop Goto", "Disabled")
	end
)

addButton("Teleport Once", function()
	local targetName = gotoBox.Text:lower()
	if targetName == "" then 
		notify("Error", "Enter a player name")
		return 
	end
	
	for _,p in pairs(Players:GetPlayers()) do
		if p.Name:lower():find(targetName) and p ~= LocalPlayer then
			pcall(function()
				if not p.Character then return end
				
				local tRoot = getRoot(p.Character)
				local root = getRoot(LocalPlayer.Character)
				
				if root and tRoot then
					root.CFrame = tRoot.CFrame * CFrame.new(0, 3, 0)
					notify("Teleport", "Teleported to " .. p.Name)
				end
			end)
			return
		end
	end
	notify("Error", "Player not found: " .. targetName)
end)

------------ ANIMATIONS ------------
addLabel("🎭 Animations")

local animBox = addBox("Animation ID")

addButton("Play Animation", function()
	local id = tonumber(animBox.Text)
	if not id then 
		notify("Error", "Invalid animation ID")
		return 
	end
	
	pcall(function()
		if LocalPlayer.Character then
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				local anim = Instance.new("Animation")
				anim.AnimationId = "rbxassetid://"..id
				
				local animTrack = hum:LoadAnimation(anim)
				animTrack:Play()
				notify("Animation", "Playing ID: " .. id)
			end
		end
	end)
end)

addButton("Stop All Animations", function()
	pcall(function()
		if LocalPlayer.Character then
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				for _,track in pairs(hum:GetPlayingAnimationTracks()) do
					track:Stop()
				end
				notify("Animation", "Stopped all animations")
			end
		end
	end)
end)

------------ TOOLS ------------
addLabel("🔧 Tools")

addButton("Copy Tools From Lighting", function()
	local copied = 0
	pcall(function()
		for _,v in pairs(game:GetService("Lighting"):GetChildren()) do
			if v:IsA("Tool") or v:IsA("HopperBin") then
				v:Clone().Parent = LocalPlayer:FindFirstChildOfClass("Backpack")
				copied = copied + 1
			end
		end
	end)
	notify("Tools", "Copied " .. copied .. " tools from Lighting")
end)

addButton("Remove All Tools", function()
	local removed = 0
	pcall(function()
		for _,v in pairs(LocalPlayer:FindFirstChildOfClass("Backpack"):GetDescendants()) do
			if v:IsA("Tool") or v:IsA("HopperBin") then
				v:Destroy()
				removed = removed + 1
			end
		end
		for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("Tool") or v:IsA("HopperBin") then
				v:Destroy()
				removed = removed + 1
			end
		end
	end)
	notify("Tools", "Removed " .. removed .. " tools")
end)

------------ CLEANUP ON CHARACTER RESPAWN ------------
LocalPlayer.CharacterAdded:Connect(function()
	-- Reset all toggles
	_G.Flying = false
	_G.Noclip = false
	_G.LoopHeal = false
	_G.loopGoto = false
	
	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end
end)

-- Initial notification
notify("Clifford's Menu", "Loaded successfully! Version 3.0")
