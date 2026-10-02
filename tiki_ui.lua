local __uiSource = [==============[--[[
=======================================================================
  Tiki Hub — Slayers 2 Full Build
  Backend: supplied Tiki HUB/Cryptic/Slayers 2 script
  Interface: Tiki Hub local UI library only (no Obsidian download)

  Tabs:
  Auto Game · Farm · Progress · Boss · Dungeons · Quest · Teleport
  Player · Loot · Activities · Misc · Server

  Right Ctrl toggles the main window.
=======================================================================
]]

do
	local runtimeEnvironment = (getgenv and getgenv()) or _G
	local previousTikiHubUnload = runtimeEnvironment.__TikiHubUnload
	if type(previousTikiHubUnload) == "function" then
		pcall(previousTikiHubUnload)
	end
	runtimeEnvironment.__TikiHubUnload = nil
end

local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	-- Potassium can execute Auto Execute before Players.LocalPlayer is assigned.
	-- Polling avoids racing the one-time LocalPlayer property-change signal.
	task.wait()
	LocalPlayer = Players.LocalPlayer
end
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local function viewportSize()
	local camera = workspace.CurrentCamera
	if camera then
		return camera.ViewportSize
	end
	return Vector2.new(1280, 720)
end

local function getDeviceProfile()
	local viewport = viewportSize()
	local touch = UserInputService.TouchEnabled
	local mobile = touch and (not UserInputService.KeyboardEnabled or viewport.X < 900)
	local compact = mobile or viewport.X < 760 or viewport.Y < 540

	return {
		Touch = touch,
		Mobile = mobile,
		Compact = compact,
		LowPower = mobile or (viewport.X * viewport.Y) < 450000,
		EspStep = mobile and (1 / 24) or (1 / 45),
		EffectStep = mobile and (1 / 24) or (1 / 45),
	}
end

local DeviceProfile = getDeviceProfile()

local function preferredFont(name, fallback)
	local ok, value = pcall(function() return Enum.Font[name] end)
	return ok and value or fallback
end

local function lowerText(text)
	text = tostring(text or "")

	if not utf8.len(text) then
		return string.lower(text)
	end

	local result = {}
	for _, code in utf8.codes(text) do
		if code >= 65 and code <= 90 then
			code = code + 32
		elseif code >= 0x410 and code <= 0x42F then
			code = code + 32
		elseif code == 0x401 then
			code = 0x451
		end
		table.insert(result, utf8.char(code))
	end
	return table.concat(result)
end

local Theme = {
	Background = Color3.fromRGB(16, 26, 22), 
	BackgroundLo = Color3.fromRGB(11, 19, 16),
	Panel      = Color3.fromRGB(13, 22, 19),  
	Element      = Color3.fromRGB(26, 42, 35),
	ElementHover = Color3.fromRGB(36, 58, 48), 
	Accent      = Color3.fromRGB(72, 230, 160),
	AccentSoft = Color3.fromRGB(150, 255, 190),
	Text       = Color3.fromRGB(232, 245, 238),
	TextDim    = Color3.fromRGB(138, 165, 152), 
	Stroke     = Color3.fromRGB(40, 64, 54),
	Font         = preferredFont("BuilderSansMedium", Enum.Font.GothamMedium),
	FontBold     = preferredFont("BuilderSansBold", Enum.Font.GothamBold),
	FontHeavy    = preferredFont("BuilderSansExtraBold", Enum.Font.GothamBlack),
}

-- Layer-specific glass values keep the world slightly visible without
-- sacrificing contrast.  The collapsed capsule uses only its topbar layer,
-- otherwise two translucent backgrounds would combine into an opaque block.
local Glass = {
	Window  = 0.34,
	Topbar  = 0.30,
	Capsule = 0.36,
	Panel   = 0.52,
	Section = 0.56,
	Element = 0.62,
	Popup   = 0.44,
}

--======================================================================--

--======================================================================--

local Themes = {
	["Crimson"] = {
		Background   = Color3.fromRGB(20, 10, 12),
		BackgroundLo = Color3.fromRGB(30, 10, 20),
		Panel        = Color3.fromRGB(75, 15, 25),
		Element      = Color3.fromRGB(95, 20, 30),
		ElementHover = Color3.fromRGB(140, 30, 40),
		Accent       = Color3.fromRGB(220, 40, 60),
		AccentSoft   = Color3.fromRGB(255, 100, 110),
		Text         = Color3.fromRGB(245, 230, 232),
		TextDim      = Color3.fromRGB(180, 145, 150),
		Stroke       = Color3.fromRGB(120, 30, 45),
	},
	["Emerald"] = {
		Background = Color3.fromRGB(16, 26, 22),  BackgroundLo = Color3.fromRGB(11, 19, 16),
		Panel      = Color3.fromRGB(13, 22, 19),  Element      = Color3.fromRGB(26, 42, 35),
		ElementHover = Color3.fromRGB(36, 58, 48), Accent      = Color3.fromRGB(72, 230, 160),
		AccentSoft = Color3.fromRGB(150, 255, 190), Text       = Color3.fromRGB(232, 245, 238),
		TextDim    = Color3.fromRGB(138, 165, 152), Stroke     = Color3.fromRGB(40, 64, 54),
	},
}

local themeBindings    = {}   -- { Instance, Property, Key }
local gradientBindings = {}   -- { Instance, Keys = {a, b} }
local restylers        = {}
local colorKeyIndex    = {}
local runtimeAlive     = true

local function colorId(color)
	return string.format("%d_%d_%d",
		math.floor(color.R * 255 + 0.5),
		math.floor(color.G * 255 + 0.5),
		math.floor(color.B * 255 + 0.5))
end

local function rebuildColorIndex()
	colorKeyIndex = {}
	for key, value in pairs(Theme) do
		if typeof(value) == "Color3" then
			local id = colorId(value)

			if id ~= "255_255_255" and id ~= "0_0_0" then
				colorKeyIndex[id] = key
			end
		end
	end
end

rebuildColorIndex()

local function bindThemeColor(inst, property, value)
	local key = colorKeyIndex[colorId(value)]
	if key then
		table.insert(themeBindings, { Instance = inst, Property = property, Key = key })
	end
end

local function bindThemeGradient(inst, sequence)
	local points = sequence.Keypoints
	if #points ~= 2 then
		return
	end
	local first  = colorKeyIndex[colorId(points[1].Value)]
	local second = colorKeyIndex[colorId(points[2].Value)]
	if first and second then
		table.insert(gradientBindings, { Instance = inst, Keys = { first, second } })
	end
end

local function addRestyler(fn)
	table.insert(restylers, fn)
end

task.spawn(function()
	while runtimeAlive do
		task.wait(30)
		if not runtimeAlive then break end
		for index = #themeBindings, 1, -1 do
			local inst = themeBindings[index].Instance
			if not inst or not inst.Parent then
				table.remove(themeBindings, index)
			end
		end
		for index = #gradientBindings, 1, -1 do
			local inst = gradientBindings[index].Instance
			if not inst or not inst.Parent then
				table.remove(gradientBindings, index)
			end
		end
	end
end)

local Locales = {
	en = {
		["ui.search"]        = "Search features...",
		["ui.none"]          = "none",
		["ui.listening"]     = "...",
		["ui.empty"]         = "—",
		["ui.bindHint"]      = "right click — bind a key",

		["loader.title"]     = "Tiki Hub",
		["loader.boot"]      = "starting up",
		["loader.theme"]     = "applying theme",
		["loader.elements"]  = "building interface",
		["loader.visuals"]   = "loading visuals",
		["loader.ready"]     = "ready",

		["tab.main"]         = "Main",
		["tab.visuals"]      = "Visuals",
		["tab.settings"]     = "Settings",

		["main.character"]   = "Character",
		["main.walkspeed"]   = "Walk speed",
		["main.jumppower"]   = "Jump power",
		["main.resetspeed"]  = "Reset speed",
		["main.info"]        = "Info",
		["main.notify"]      = "Show notification",

		["vis.jump"]         = "Jump circles",
		["vis.jumpOn"]       = "Enable jump circles",
		["vis.style"]        = "Style",
		["vis.color"]        = "Color",
		["vis.size"]         = "Size",
		["vis.duration"]     = "Duration, sec",
		["vis.wings"]        = "Wings",
		["vis.wingsOn"]      = "Enable wings",
		["vis.wingsType"]    = "Wing type",
		["vis.wingsScale"]   = "Wing size",
		["vis.flap"]         = "Flapping",
		["vis.halo"]         = "Halo",
		["vis.haloOn"]       = "Enable halo",
		["vis.haloSpeed"]    = "Spin speed",
		["vis.glow"]         = "Extra glow",

		["sky.title"]        = "Sky",
		["sky.preset"]       = "Preset",
		["sky.brightness"]   = "Brightness",
		["sky.exposure"]     = "Exposure",
		["sky.restore"]      = "Restore original",
		["sky.note"]         = "Lighting changes are client-side only.",

		["set.interface"]    = "Interface",
		["set.theme"]        = "Theme",
		["set.language"]     = "Language",
		["set.sounds"]       = "Interface sounds",
		["set.volume"]       = "Volume",
		["set.clamp"]        = "Keep window on screen",
		["set.button"]       = "On-screen button",
		["set.buttonStyle"]  = "Button style",
		["set.hide"]         = "Hide menu",
		["set.config"]       = "Config",
		["set.configName"]   = "Config name",
		["set.save"]         = "Save settings",
		["set.load"]         = "Load settings",
	},
}

local currentLocale = "en"
local textBindings  = {}

local function translate(key)
	local pack = Locales[currentLocale]
	if pack and pack[key] then
		return pack[key]
	end
	if Locales.en and Locales.en[key] then
		return Locales.en[key]
	end
	return key
end

local function resolveText(text)
	if type(text) == "string" and string.sub(text, 1, 1) == "@" then
		local key = string.sub(text, 2)
		return translate(key), key
	end
	return text, nil
end

local function bindText(inst, property, key)
	if key then
		table.insert(textBindings, { Instance = inst, Property = property, Key = key })
	end
end

local SoundService = game:GetService("SoundService")

local Sounds = {
	Enabled = true,
	Volume  = 0.45,

	Source  = "rbxasset://sounds/electronicpingshort.wav",
	Pitch   = {
		ToggleOn  = 1.35,
		ToggleOff = 0.80,
		Click     = 1.10,
		Open      = 1.55,
		Close     = 0.70,
		Notify    = 1.20,
	},
}

local soundPool = {}

local function playSound(name)
	if not Sounds.Enabled then
		return
	end

	local sound = soundPool[name]
	if not sound or not sound.Parent then
		sound = Instance.new("Sound")
		sound.Name   = "SimpleUI_" .. tostring(name)
		sound.Parent = SoundService
		soundPool[name] = sound
	end

	sound.SoundId       = Sounds.Source
	sound.Volume        = Sounds.Volume
	sound.PlaybackSpeed = Sounds.Pitch[name] or 1
	sound:Play()
end

local keyBinds      = {}    -- [KeyCode.Name] = { { Id, Fn }, ... }
local bindListener  = nil
local bindIdCounter = 0
local captureConn   = nil

local function ensureBindListener()
	if bindListener then
		return
	end

	bindListener = UserInputService.InputBegan:Connect(function(input, processed)
		if processed or captureConn then
			return
		end
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		if UserInputService:GetFocusedTextBox() then
			return
		end

		local list = keyBinds[input.KeyCode.Name]
		if not list then
			return
		end

		for _, item in ipairs(list) do
			task.spawn(item.Fn)
		end
	end)
end

local function addBind(keyCode, fn)
	if not keyCode then
		return nil
	end

	ensureBindListener()
	bindIdCounter = bindIdCounter + 1

	local name = keyCode.Name
	keyBinds[name] = keyBinds[name] or {}
	table.insert(keyBinds[name], { Id = bindIdCounter, Fn = fn })

	return { Key = keyCode, Id = bindIdCounter }
end

local function removeBind(handle)
	if not handle then
		return
	end

	local list = keyBinds[handle.Key.Name]
	if not list then
		return
	end

	for index = #list, 1, -1 do
		if list[index].Id == handle.Id then
			table.remove(list, index)
		end
	end
end

local function captureKey(callback)
	if captureConn then
		captureConn:Disconnect()
		captureConn = nil
	end

	local myConn
	myConn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		if UserInputService:GetFocusedTextBox() then
			return
		end

		if captureConn == myConn then
			captureConn = nil
		end
		myConn:Disconnect()

		if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
			callback(nil)
		else
			callback(input.KeyCode)
		end
	end)

	captureConn = myConn

	task.delay(6, function()
		if captureConn == myConn then
			captureConn = nil
			myConn:Disconnect()
			callback(nil)
		end
	end)
end

local function new(class, props, children)
	local inst = Instance.new(class)
	if props then
		for key, value in pairs(props) do
			if key ~= "Parent" then
				inst[key] = value

				local kind = typeof(value)
				if kind == "Color3" then
					bindThemeColor(inst, key, value)
				elseif kind == "ColorSequence" then
					bindThemeGradient(inst, value)
				end
			end
		end
	end
	if children then
		for _, child in ipairs(children) do
			child.Parent = inst
		end
	end
	if props and props.Parent then
		inst.Parent = props.Parent
	end
	return inst
end

local Softness = 1

local WINDOW_RADIUS = 20

local function corner(parent, radius)
	radius = radius or 6
	return new("UICorner", {
		CornerRadius = UDim.new(0, math.max(math.floor(radius * Softness + 0.5), 0)),
		Parent       = parent,
	})
end

-- keepSquare: "bottom" | "top" | "right" | "topright"
local function roundSide(target, radius, keepSquare)
	radius = radius or 12
	corner(target, radius)

	local patches = {}

	local function patch(size, position)
		local layer = new("Frame", {
			Size                   = size,
			Position               = position,
			BackgroundColor3       = target.BackgroundColor3,
			BackgroundTransparency = target.BackgroundTransparency,
			BorderSizePixel        = 0,
			ZIndex                 = 0,
			Parent                 = target,
		})
		table.insert(patches, layer)
		return layer
	end

	if keepSquare == "bottom" then
		patch(UDim2.new(1, 0, 0, radius), UDim2.new(0, 0, 1, -radius))
	elseif keepSquare == "top" then
		patch(UDim2.new(1, 0, 0, radius), UDim2.new(0, 0, 0, 0))
	elseif keepSquare == "right" then
		patch(UDim2.new(0, radius, 1, 0), UDim2.new(1, -radius, 0, 0))
	elseif keepSquare == "topright" then
		patch(UDim2.new(1, 0, 0, radius), UDim2.new(0, 0, 0, 0))
		patch(UDim2.new(0, radius, 1, -radius), UDim2.new(1, -radius, 0, radius))
	end

	target:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
		for _, layer in ipairs(patches) do
			layer.BackgroundColor3 = target.BackgroundColor3
		end
	end)
	target:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
		for _, layer in ipairs(patches) do
			layer.BackgroundTransparency = target.BackgroundTransparency
		end
	end)

	return patches
end

local function blendWithBackground(panelKey, backgroundKey, alpha)
	return Theme[panelKey]:Lerp(Theme[backgroundKey], alpha)
end

local function addShadow(target, layers, radius, strength)
	layers   = layers or 5
	radius   = radius or 18
	strength = strength or 0.86
	layers   = math.min(layers, DeviceProfile.LowPower and 1 or 3)

	local host = target.Parent
	if not host then
		return {}
	end

	local size = target.Size
	local pos  = target.Position
	local made = {}

	for index = 1, layers do
		local pad = index * 4
		local layer = new("Frame", {
			Size                   = UDim2.new(size.X.Scale, size.X.Offset + pad * 2, size.Y.Scale, size.Y.Offset + pad * 2),
			Position               = UDim2.new(pos.X.Scale, pos.X.Offset - pad, pos.Y.Scale, pos.Y.Offset - pad + 2),
			AnchorPoint            = target.AnchorPoint,
			BackgroundColor3       = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = strength + (1 - strength) * (index / layers),
			BorderSizePixel        = 0,
			ZIndex                 = math.max(target.ZIndex - 2, 0),
			Parent                 = host,
		})
		new("UICorner", { CornerRadius = UDim.new(0, radius + pad), Parent = layer })
		table.insert(made, layer)
	end

	local function follow()
		local nowSize = target.Size
		local nowPos  = target.Position
		for index, layer in ipairs(made) do
			local pad = index * 4
			layer.Size = UDim2.new(
				nowSize.X.Scale, nowSize.X.Offset + pad * 2,
				nowSize.Y.Scale, nowSize.Y.Offset + pad * 2)
			layer.Position = UDim2.new(
				nowPos.X.Scale, nowPos.X.Offset - pad,
				nowPos.Y.Scale, nowPos.Y.Offset - pad + 2)
		end
	end

	target:GetPropertyChangedSignal("Position"):Connect(follow)
	target:GetPropertyChangedSignal("Size"):Connect(follow)

	return made
end

local function addSheen(target, strength)
	-- A sheen costs a frame, corner and gradient per control. Keeping it only on
	-- capable layouts removes dozens of overdraw layers on phones.
	if DeviceProfile.LowPower then
		return nil
	end

	if target:FindFirstChildOfClass("UIListLayout")
		or target:FindFirstChildOfClass("UIGridLayout") then
		return nil
	end

	local sheen = new("Frame", {
		Size                   = UDim2.new(1, 0, 1, 0),
		BackgroundColor3       = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0,
		BorderSizePixel        = 0,
		ZIndex                 = math.max(target.ZIndex, 1),
		Parent                 = target,
	})

	local parentCorner = target:FindFirstChildOfClass("UICorner")
	new("UICorner", {
		CornerRadius = parentCorner and parentCorner.CornerRadius or UDim.new(0, 10),
		Parent       = sheen,
	})
	new("UIGradient", {
		Rotation     = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, strength or 0.94),
			NumberSequenceKeypoint.new(0.45, 1),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = sheen,
	})
	return sheen
end

local function stroke(parent, color, thickness, transparency)
	return new("UIStroke", {
		Color           = color or Theme.Stroke,
		Thickness       = thickness or 1,
		Transparency    = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent          = parent,
	})
end

-- A moving neon highlight used by the window edge and every active feature.
-- UIGradient keeps it cheap: no RenderStepped loop and no particle spam.
local function addNeonSnake(target, thickness, radius, speed)
	local snakeStroke = new("UIStroke", {
		Name = "NeonSnake",
		Color = Color3.new(1, 1, 1),
		Thickness = thickness or 1.5,
		Transparency = 0.04,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		LineJoinMode = Enum.LineJoinMode.Round,
		Parent = target,
	})
	local snakeGradient = new("UIGradient", {
		Rotation = 0,
		Offset = Vector2.new(-1, 0),
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 225, 255)),
			ColorSequenceKeypoint.new(0.35, Color3.fromRGB(105, 92, 255)),
			ColorSequenceKeypoint.new(0.68, Color3.fromRGB(235, 82, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 225, 255)),
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.28, 0.82),
			NumberSequenceKeypoint.new(0.45, 0),
			NumberSequenceKeypoint.new(0.62, 0.12),
			NumberSequenceKeypoint.new(0.82, 0.9),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = snakeStroke,
	})
	local animation = TweenService:Create(
		snakeGradient,
		TweenInfo.new(speed or (DeviceProfile.LowPower and 3.8 or 2.3), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
		{ Offset = Vector2.new(1, 0), Rotation = radius or 360 }
	)
	animation:Play()
	target.Destroying:Connect(function()
		pcall(function() animation:Cancel() end)
	end)
	return snakeStroke, snakeGradient, animation
end

local activeTweens = setmetatable({}, { __mode = "k" })

local function playTween(inst, info, props)
	local previous = activeTweens[inst]
	if previous then
		pcall(function() previous:Cancel() end)
	end

	local animation = TweenService:Create(inst, info, props)
	activeTweens[inst] = animation
	animation.Completed:Connect(function()
		if activeTweens[inst] == animation then
			activeTweens[inst] = nil
		end
	end)
	animation:Play()
	return animation
end

local function tween(inst, props, time, style)
	local info = TweenInfo.new(time or 0.22, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	return playTween(inst, info, props)
end

local function spring(inst, props, time)
	local info = TweenInfo.new(time or 0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	return playTween(inst, info, props)
end

local function pressEffect(target, scaleObject)
	if not scaleObject then
		return
	end
	tween(scaleObject, { Scale = 0.97 }, 0.08, Enum.EasingStyle.Sine)
	task.delay(0.09, function()
		spring(scaleObject, { Scale = 1 }, 0.3)
	end)
end

local function rippleAt(host, color)
	local wave = new("Frame", {
		Size                   = UDim2.fromOffset(0, 0),
		Position               = UDim2.fromScale(0.5, 0.5),
		AnchorPoint            = Vector2.new(0.5, 0.5),
		BackgroundColor3       = color or Theme.Accent,
		BackgroundTransparency = 0.55,
		BorderSizePixel        = 0,
		ZIndex                 = 2,
		Parent                 = host,
	})
	new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = wave })

	local multiplier = DeviceProfile.LowPower and 1.45 or 2.2
	local width = math.max(host.AbsoluteSize.X, 100) * multiplier
	tween(wave, {
		Size                   = UDim2.fromOffset(width, width),
		BackgroundTransparency = 1,
	}, DeviceProfile.LowPower and 0.32 or 0.55)

	task.delay(DeviceProfile.LowPower and 0.36 or 0.6, function()
		wave:Destroy()
	end)
end

local function isPressInput(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

local function isMoveInput(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
end

local function safeCall(fn, ...)
	if type(fn) ~= "function" then return end
	local ok, err = pcall(fn, ...)
	if not ok then
		warn("[SimpleUI] callback error: " .. tostring(err))
	end
end

local function addGlowInside(parent, color, layers, radius)
	layers = layers or 3
	radius = radius or 6
	layers = math.min(layers, DeviceProfile.LowPower and 1 or 2)
	local made = {}
	for i = 1, layers do
		local pad = i * 3
		local layer = new("Frame", {
			Size                   = UDim2.new(1, pad * 2, 1, pad * 2),
			Position               = UDim2.new(0, -pad, 0, -pad),
			BackgroundColor3       = color or Theme.Accent,
			BackgroundTransparency = 0.68 + i * 0.09,
			BorderSizePixel        = 0,
			ZIndex                 = 0,
			Parent                 = parent,
		})
		corner(layer, radius + pad)
		table.insert(made, layer)
	end
	return made
end

local function addGlow(target, color, layers, radius)
	layers = layers or 3
	radius = radius or 6
	layers = math.min(layers, DeviceProfile.LowPower and 1 or 2)
	local host = target.Parent
	if not host then
		return addGlowInside(target, color, layers, radius)
	end

	local size = target.Size
	local pos  = target.Position
	local made = {}

	for i = 1, layers do
		local pad = i * 3
		local layer = new("Frame", {
			Size                   = UDim2.new(size.X.Scale, size.X.Offset + pad * 2, size.Y.Scale, size.Y.Offset + pad * 2),
			Position               = UDim2.new(pos.X.Scale, pos.X.Offset - pad, pos.Y.Scale, pos.Y.Offset - pad),
			AnchorPoint            = target.AnchorPoint,
			BackgroundColor3       = color or Theme.Accent,
			BackgroundTransparency = 0.68 + i * 0.09,
			BorderSizePixel        = 0,
			ZIndex                 = math.max(target.ZIndex - 1, 0),
			Parent                 = host,
		})
		corner(layer, radius + pad)
		table.insert(made, layer)
	end
	return made
end

local function setGlow(layers, visible)
	for i, layer in ipairs(layers) do
		tween(layer, { BackgroundTransparency = visible and (0.68 + i * 0.09) or 1 }, 0.2)
	end
end

local function makeDraggable(window, handle, state)
	local dragging  = false
	local dragStart = nil
	local startPos  = nil
	local conns     = {}

	table.insert(conns, handle.InputBegan:Connect(function(input)
		if isPressInput(input) then
			dragging  = true
			dragStart = input.Position
			startPos  = window.Position
		end
	end))

	table.insert(conns, UserInputService.InputChanged:Connect(function(input)
		if not dragging or not dragStart then return end
		if isMoveInput(input) then
			local delta = input.Position - dragStart
			local x = startPos.X.Offset + delta.X
			local y = startPos.Y.Offset + delta.Y

			if state and state.Clamp then
				local screen = viewportSize()
				local size   = window.AbsoluteSize
				x = math.clamp(x, 0, math.max(screen.X - size.X, 0))
				y = math.clamp(y, 0, math.max(screen.Y - size.Y, 0))
			end

			window.Position = UDim2.new(startPos.X.Scale, x, startPos.Y.Scale, y)
		end
	end))

	table.insert(conns, UserInputService.InputEnded:Connect(function(input)
		if isPressInput(input) then
			dragging = false
		end
	end))

	return conns
end

local Tiki_LOGO_IMAGE = "rbxthumb://type=Asset&id=71152887867495&w=420&h=420"

local function createLogo(parent, size, position, animated)
	local holder = new("Frame", {
		Name                   = "Logo",
		Size                   = UDim2.fromOffset(size, size),
		Position               = position,
		BackgroundTransparency = 1,
		Parent                 = parent,
	})

	-- One uploaded transparent source keeps the branding identical in the
	-- loader, full header, minimized header and floating open button.
	local Tiki = new("ImageLabel", {
		Name = "TikiMark",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = Tiki_LOGO_IMAGE,
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 3,
		Parent = holder,
	})
	local sheen = new("ImageLabel", {
		Name = "Sheen",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = Tiki_LOGO_IMAGE,
		ImageColor3 = Color3.fromRGB(255, 255, 255),
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 4,
		Parent = holder,
	})
	local sheenGradient = new("UIGradient", {
		Rotation = 24,
		Offset = Vector2.new(-1.15, 0),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.42, 1),
			NumberSequenceKeypoint.new(0.5, 0.18),
			NumberSequenceKeypoint.new(0.58, 1),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = sheen,
	})
	local logoScale = new("UIScale", { Scale = 1, Parent = holder })
	if animated ~= false then
		local logoTweens = {
			TweenService:Create(logoScale,
				TweenInfo.new(DeviceProfile.LowPower and 2.5 or 1.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
				{ Scale = DeviceProfile.LowPower and 1.07 or 1.12 }),
			TweenService:Create(Tiki,
				TweenInfo.new(DeviceProfile.LowPower and 3.8 or 2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
				{ Rotation = 5, ImageColor3 = Color3.fromRGB(194, 226, 255) }),
			TweenService:Create(sheenGradient,
				TweenInfo.new(DeviceProfile.LowPower and 3.8 or 2.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1),
				{ Offset = Vector2.new(1.15, 0) }),
		}
		for _, animation in ipairs(logoTweens) do animation:Play() end
		holder.Destroying:Connect(function()
			for _, animation in ipairs(logoTweens) do
				pcall(function() animation:Cancel() end)
			end
		end)
	end

	return holder
end

local Library: any = {}
Library.Theme   = Theme
Library.Windows = {}
Library.Entries = {}
Library.FloatersLocked = false  -- when true, on-screen buttons can't be dragged
Library.Floaters = {}

Library.Flags = setmetatable({}, {
	__index = function(_, key)
		local entry = Library.Entries[key]
		if entry and entry.Get then
			return entry.Get()
		end
		return nil
	end,
	__newindex = function(_, key, value)
		local entry = Library.Entries[key]
		if entry and entry.Set then
			entry.Set(value)
		end
	end,
})

local notifyGui, notifyHolder

local function notificationCardWidth()
	return math.min(310, math.max(math.floor(viewportSize().X - 44), 200))
end

local function ensureNotifyGui()
	local cardWidth = notificationCardWidth()
	if notifyGui and notifyGui.Parent then
		notifyHolder.Size = UDim2.new(0, cardWidth + 20, 1, -24)
		notifyHolder.Position = UDim2.new(1, -(cardWidth + 28), 0, 12)
		return
	end

	notifyGui = new("ScreenGui", {
		Name           = "SimpleUI_Notifications",
		ResetOnSpawn   = false,
		IgnoreGuiInset = true,
		DisplayOrder   = 1000,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent         = PlayerGui,
	})

	notifyHolder = new("Frame", {
		Size                   = UDim2.new(0, cardWidth + 20, 1, -24),
		Position               = UDim2.new(1, -(cardWidth + 28), 0, 12),
		BackgroundTransparency = 1,
		Parent                 = notifyGui,
	})

	new("UIListLayout", {
		Padding             = UDim.new(0, 10),
		SortOrder           = Enum.SortOrder.LayoutOrder,
		VerticalAlignment   = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Parent              = notifyHolder,
	})
end

function Library:Notify(config)
	config = config or {}

	local title    = config.Title    or "Tiki Hub"
	local text     = config.Text     or ""
	local duration = config.Duration or 4
	local kind     = config.Kind     or "info"

	local palette = {
		info    = { Color = Theme.Accent,                    Glyph = "i" },
		success = { Color = Color3.fromRGB(80, 220, 150),    Glyph = "✓" },
		warning = { Color = Color3.fromRGB(240, 180, 70),    Glyph = "!" },
		error   = { Color = Color3.fromRGB(240, 90, 110),    Glyph = "×" },
	}

	local tone  = palette[kind] or palette.info
	local color = config.Color or tone.Color

	ensureNotifyGui()
	playSound("Notify")
	local cardWidth = notificationCardWidth()

	local slot = new("Frame", {
		Size                   = UDim2.new(0, cardWidth, 0, 0),
		AutomaticSize          = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ClipsDescendants       = false,
		Parent                 = notifyHolder,
	})

	local card = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 0),
		AutomaticSize    = Enum.AutomaticSize.Y,
		Position         = UDim2.new(1, 60, 0, 0),
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel  = 0,
		Parent           = slot,
	})
	corner(card, 15)
	local cardStroke = stroke(card, Theme.Stroke, 1, 0.15)

	new("UIGradient", {
		Rotation = 90,
		Color    = ColorSequence.new(Theme.Element, Theme.Panel),
		Parent   = card,
	})

	local cardScale = new("UIScale", { Scale = 0.92, Parent = card })

	new("UIPadding", {
		PaddingTop    = UDim.new(0, 12),
		PaddingBottom = UDim.new(0, 14),
		PaddingLeft   = UDim.new(0, 12),
		PaddingRight  = UDim.new(0, 12),
		Parent        = card,
	})

	local badge = new("Frame", {
		Size             = UDim2.fromOffset(26, 26),
		Position         = UDim2.fromOffset(0, 0),
		BackgroundColor3 = color,
		BackgroundTransparency = 0.82,
		BorderSizePixel  = 0,
		Parent           = card,
	})
	new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = badge })
	stroke(badge, color, 1, 0.35)
	addGlowInside(badge, color, 2, 13)

	new("TextLabel", {
		Size                   = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text                   = tone.Glyph,
		TextColor3             = color,
		TextSize               = 15,
		Font                   = Theme.FontBold,
		ZIndex                 = 3,
		Parent                 = badge,
	})

	new("TextLabel", {
		Size                   = UDim2.new(1, -38, 0, 17),
		Position               = UDim2.fromOffset(36, 1),
		BackgroundTransparency = 1,
		Text                   = title,
		TextColor3             = Theme.Text,
		TextSize               = 14,
		Font                   = Theme.FontBold,
		TextXAlignment         = Enum.TextXAlignment.Left,
		TextTruncate           = Enum.TextTruncate.AtEnd,
		Parent                 = card,
	})

	new("TextLabel", {
		Size                   = UDim2.new(1, -38, 0, 0),
		AutomaticSize          = Enum.AutomaticSize.Y,
		Position               = UDim2.fromOffset(36, 21),
		BackgroundTransparency = 1,
		Text                   = text,
		TextColor3             = Theme.TextDim,
		TextSize               = 13,
		Font                   = Theme.Font,
		TextXAlignment         = Enum.TextXAlignment.Left,
		TextYAlignment         = Enum.TextYAlignment.Top,
		TextWrapped            = true,
		Parent                 = card,
	})

	local track = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 3),
		Position         = UDim2.new(0, 0, 1, 6),
		BackgroundColor3 = Theme.BackgroundLo,
		BorderSizePixel  = 0,
		Parent           = card,
	})
	new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

	local bar = new("Frame", {
		Size             = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = color,
		BorderSizePixel  = 0,
		Parent           = track,
	})
	new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
	new("UIGradient", { Color = ColorSequence.new(color, Theme.AccentSoft), Parent = bar })

	local hit = new("TextButton", {
		Size                   = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		AutoButtonColor        = false,
		Text                   = "",
		ZIndex                 = 6,
		Parent                 = card,
	})

	tween(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.5)
	spring(cardScale, { Scale = 1 }, 0.55)

	local barTween = TweenService:Create(bar,
		TweenInfo.new(duration, Enum.EasingStyle.Linear),
		{ Size = UDim2.new(0, 0, 1, 0) })
	barTween:Play()

	local closed = false
	local paused = false

	local function close()
		if closed then
			return
		end
		closed = true

		barTween:Cancel()
		tween(card, { Position = UDim2.new(1, 60, 0, 0) }, 0.4)
		tween(cardScale, { Scale = 0.9 }, 0.4)
		tween(cardStroke, { Transparency = 1 }, 0.3)

		task.delay(0.42, function()

			local height = slot.AbsoluteSize.Y
			slot.AutomaticSize = Enum.AutomaticSize.None
			slot.Size = UDim2.new(0, cardWidth, 0, height)
			tween(slot, { Size = UDim2.new(0, cardWidth, 0, 0) }, 0.25)
			task.delay(0.3, function()
				slot:Destroy()
			end)
		end)
	end

	hit.MouseEnter:Connect(function()
		if closed then
			return
		end
		paused = true
		barTween:Pause()
		tween(cardStroke, { Color = color, Transparency = 0 }, 0.2)
		spring(cardScale, { Scale = 1.02 }, 0.3)
	end)

	hit.MouseLeave:Connect(function()
		if closed then
			return
		end
		paused = false
		if barTween.PlaybackState ~= Enum.PlaybackState.Completed then
			barTween:Play()
		end
		tween(cardStroke, { Color = Theme.Stroke, Transparency = 0.15 }, 0.25)
		tween(cardScale, { Scale = 1 }, 0.3)
	end)

	hit.MouseButton1Click:Connect(close)

	task.spawn(function()
		local left    = duration
		local started = os.clock()

		local ceiling = duration * 5 + 10

		while left > 0 and not closed do
			task.wait(0.1)
			if not paused then
				left = left - 0.1
			end
			if os.clock() - started > ceiling then
				break
			end
		end
		close()
	end)

	return { Close = close, Card = card }
end

function Library:ResolveBackgroundAsset()
	if type(self._backgroundAsset) == "string" and self._backgroundAsset ~= "" then return self._backgroundAsset end
	local environment = (getgenv and getgenv()) or _G
	local loader = environment.getcustomasset or getcustomasset or environment.getsynasset or getsynasset
	if type(loader) ~= "function" then return nil, "local image loader unavailable" end
	local ok, asset = pcall(loader, "TikiHubAssets/anime-background-20030a4e.png")
	if not ok then return nil, tostring(asset) end
	if type(asset) ~= "string" or asset == "" then return nil, "local image loader returned a non-ContentId value" end
	self._backgroundAsset = asset
	return asset
end

function Library:CreateWindow(config)
	config = config or {}

	local titleText = config.Title      or "SimpleUI"
	local subText   = config.Subtitle   or ""
	local size      = config.Size       or UDim2.fromOffset(700, 500)
	local keybind   = config.Keybind    or Enum.KeyCode.RightControl
	local folder    = config.ConfigDir  or "SimpleUI"

	local width  = size.X.Offset
	local height = size.Y.Offset
	local preferredWidth, preferredHeight = width, height

	local vp0 = viewportSize()
	local profile = getDeviceProfile()
	DeviceProfile = profile
	local isMobile = profile.Mobile
	local compactMode = profile.Compact
	if compactMode then
		local availableWidth = math.max(math.floor(vp0.X - 12), 260)
		local availableHeight = math.max(math.floor(vp0.Y - 12), 220)
		width = math.min(width, math.floor(vp0.X * (isMobile and 0.96 or 0.92)), availableWidth)
		height = math.min(height, math.floor(vp0.Y * (isMobile and 0.92 or 0.88)), availableHeight)
	end

	local sidebarWidth = isMobile and 96 or (compactMode and 112 or 164)
	local minWidth     = math.min(isMobile and 184 or 196, width)

	local minMinW      = math.min(isMobile and 260 or 460, width)
	local minMinH      = math.min(isMobile and 220 or 300, height)

	local connections = {}
	local function track(conn)
		table.insert(connections, conn)
		return conn
	end

	local dragState = { Clamp = config.ClampToScreen ~= false }

	local screenGui = new("ScreenGui", {
		Name           = "SimpleUI",
		ResetOnSpawn   = false,
		IgnoreGuiInset = true,
		DisplayOrder   = 999,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent         = PlayerGui,
	})
	if profile.Touch then
		pcall(function() screenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets end)
		pcall(function() screenGui.ClipToDeviceSafeArea = true end)
	end

	local viewport = viewportSize()
	local main = new("Frame", {
		Name             = "Main",
		Size             = UDim2.fromOffset(width, height),
		Position         = UDim2.fromOffset(
			math.max((viewport.X - width) / 2, 0),
			math.max((viewport.Y - height) / 2, 0)
		),
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = Glass.Window,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
		Active           = true,
		Parent           = screenGui,
	})
	corner(main, WINDOW_RADIUS)
	stroke(main, Theme.Stroke, 1, 0.08)
	local prismStroke = stroke(main, Theme.Accent, 1.35, 0.48)
	addNeonSnake(main, DeviceProfile.LowPower and 1.2 or 1.75, 360, DeviceProfile.LowPower and 5.2 or 3.1)
	local edgeSnakeB = addNeonSnake(main, DeviceProfile.LowPower and 0.8 or 1.15, -360, DeviceProfile.LowPower and 6.4 or 4.2)
	edgeSnakeB.Transparency = 0.42
	local prismGradient = new("UIGradient", {
		Rotation = 0,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.AccentSoft),
			ColorSequenceKeypoint.new(0.48, Theme.Accent),
			ColorSequenceKeypoint.new(1, Theme.AccentSoft),
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.15),
			NumberSequenceKeypoint.new(0.5, 0.72),
			NumberSequenceKeypoint.new(1, 0.15),
		}),
		Parent = prismStroke,
	})
	local mainShadows = addShadow(main, 5, 20, 0.88)
	addSheen(main, 0.93)

	local introScale = new("UIScale", { Scale = 0.94, Parent = main })
	spring(introScale, { Scale = 1 }, 0.5)
	new("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.Background),
			ColorSequenceKeypoint.new(0.58, Theme.BackgroundLo),
			ColorSequenceKeypoint.new(1, Theme.Background),
		}),
		Parent   = main,
	})

	-- Ambient circles removed; only the existing border gradient remains.
	if not DeviceProfile.LowPower then
		TweenService:Create(prismGradient,
			TweenInfo.new(7, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
			{ Rotation = 360 }):Play()
	end

	local topbar = new("Frame", {
		Name             = "Topbar",
		Size             = UDim2.new(1, 0, 0, 48),
		BackgroundColor3 = Theme.Panel,
		BackgroundTransparency = Glass.Topbar,
		BorderSizePixel  = 0,
		Active           = true,
		ClipsDescendants = true,
		Parent           = main,
	})

	local topbarSquarePatches = roundSide(topbar, WINDOW_RADIUS, "bottom")
	local topbarSheen = nil

	local underline = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 2),
		Position         = UDim2.new(0, 0, 1, -2),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel  = 0,
		Parent           = topbar,
	})
	local underlineGradient = new("UIGradient", {
		Color        = ColorSequence.new(Theme.Accent, Theme.AccentSoft),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0.25),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = underline,
	})
	if not DeviceProfile.LowPower then
		TweenService:Create(underlineGradient,
			TweenInfo.new(3.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
			{ Offset = Vector2.new(0.22, 0) }):Play()
	end

	local logo = createLogo(topbar, 30, UDim2.new(0, 14, 0, 9))

	local titleLabel = new("TextLabel", {
		Size                   = UDim2.new(0, 240, 0, 18),
		Position               = UDim2.new(0, 52, 0, 8),
		BackgroundTransparency = 1,
		Text                   = titleText,
		TextColor3             = Theme.Text,
		TextSize               = 16,
		Font                   = Theme.FontHeavy,
		TextXAlignment         = Enum.TextXAlignment.Left,
		TextTruncate           = Enum.TextTruncate.AtEnd,
		Parent                 = topbar,
	})
	new("UIGradient", {
		Color = ColorSequence.new(Theme.Text, Theme.AccentSoft),
		Rotation = 10,
		Parent = titleLabel,
	})

	local subLabel = new("TextLabel", {
		Size                   = UDim2.new(0, 240, 0, 14),
		Position               = UDim2.new(0, 52, 0, 26),
		BackgroundTransparency = 1,
		Text                   = subText,
		TextColor3             = Theme.TextDim,
		TextSize               = 12,
		Font                   = Theme.Font,
		TextXAlignment         = Enum.TextXAlignment.Left,
		TextTruncate           = Enum.TextTruncate.AtEnd,
		Parent                 = topbar,
	})
	local miniCreditLabel = new("TextLabel", {
		Size = UDim2.new(1, -140, 0, 14),
		Position = UDim2.new(0, 52, 0, 24),
		BackgroundTransparency = 1,
		Text = "Made By Tiki",
		TextColor3 = Theme.TextDim,
		TextSize = 11,
		Font = Theme.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Visible = false,
		ZIndex = 6,
		Parent = topbar,
	})

	local searchW = compactMode and 86 or 160
	local searchBox = new("TextBox", {
		Size               = UDim2.new(0, searchW, 0, 26),
		Position           = UDim2.new(1, -76 - searchW, 0, 10),
		BackgroundColor3   = Theme.Element,
		BackgroundTransparency = Glass.Element,
		Text               = "",
		PlaceholderText    = translate("ui.search"),
		PlaceholderColor3  = Theme.TextDim,
		TextColor3         = Theme.Text,
		TextSize           = 13,
		Font               = Theme.Font,
		ClearTextOnFocus   = false,
		BorderSizePixel    = 0,
		Parent             = topbar,
	})
	corner(searchBox, 9)
	bindText(searchBox, "PlaceholderText", "ui.search")
	local searchStroke = stroke(searchBox, Theme.Stroke, 1)
	searchBox.TextXAlignment = Enum.TextXAlignment.Center
	searchBox.TextYAlignment = Enum.TextYAlignment.Center
	new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = searchBox })

	searchBox.Focused:Connect(function()
		tween(searchStroke, { Color = Theme.Accent })
	end)
	searchBox.FocusLost:Connect(function()
		tween(searchStroke, { Color = Theme.Stroke })
	end)

	local topButtonSize = isMobile and 38 or 26
	local function topButton(text, offsetX, hoverColor)
		local b = new("TextButton", {
			Size             = UDim2.fromOffset(topButtonSize, topButtonSize),
			Position         = UDim2.new(1, offsetX, 0, math.floor((46 - topButtonSize) / 2)),
			BackgroundColor3 = Theme.Element,
			BackgroundTransparency = Glass.Element,
			AutoButtonColor  = false,
			Text             = text,
			TextColor3       = Theme.TextDim,
			TextSize         = 16,
			Font             = Theme.FontBold,
			BorderSizePixel  = 0,
			Parent           = topbar,
		})
		corner(b, 9)
		local buttonStroke = stroke(b, Theme.Stroke, 1, 0.35)
		local buttonScale = new("UIScale", { Scale = 1, Parent = b })
		b.MouseEnter:Connect(function()
			tween(b, { BackgroundColor3 = hoverColor or Theme.ElementHover, TextColor3 = Theme.Text })
			tween(buttonStroke, { Color = hoverColor or Theme.Accent, Transparency = 0.05 })
			tween(buttonScale, { Scale = 1.06 }, 0.18)
		end)
		b.MouseLeave:Connect(function()
			tween(b, { BackgroundColor3 = Theme.Element, TextColor3 = Theme.TextDim })
			tween(buttonStroke, { Color = Theme.Stroke, Transparency = 0.35 })
			tween(buttonScale, { Scale = 1 }, 0.2)
		end)
		return b
	end

	local closeBtn = topButton("×", -(topButtonSize + 8), Color3.fromRGB(220, 70, 80))
	local minBtn   = topButton("—", -(topButtonSize * 2 + 14), nil)
	local miniOpenButton = new("TextButton", {
		Name = "ExpandCapsule",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Active = false,
		Text = "",
		Visible = false,
		ZIndex = 0,
		Parent = topbar,
	})

	for _, conn in ipairs(makeDraggable(main, topbar, dragState)) do
		track(conn)
	end

	local body = new("Frame", {
		Name                   = "Body",
		Size                   = UDim2.new(1, 0, 1, -46),
		Position               = UDim2.new(0, 0, 0, 46),
		BackgroundTransparency = 1,
		Parent                 = main,
	})

	local sidebar = new("Frame", {
		Name             = "Sidebar",
		Size             = UDim2.new(0, sidebarWidth, 1, 0),
		BackgroundColor3 = blendWithBackground("Panel", "BackgroundLo", 0.35),
		BackgroundTransparency = Glass.Panel,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
		Parent           = body,
	})

	corner(sidebar, WINDOW_RADIUS)
	addRestyler(function()
		if sidebar.Parent then
			sidebar.BackgroundColor3 = blendWithBackground("Panel", "BackgroundLo", 0.35)
		end
	end)

	local tabList = new("ScrollingFrame", {
		Size                   = UDim2.new(1, 0, 1, -72),
		BackgroundTransparency = 1,
		BorderSizePixel        = 0,
		ScrollBarThickness     = 0,
		CanvasSize             = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize    = Enum.AutomaticSize.Y,
		Parent                 = sidebar,
	})
	new("UIListLayout", {
		Padding   = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent    = tabList,
	})
	new("UIPadding", {
		PaddingTop    = UDim.new(0, 12),
		PaddingBottom = UDim.new(0, 68),
		PaddingLeft   = UDim.new(0, 10),
		PaddingRight  = UDim.new(0, 10),
		Parent        = tabList,
	})

	local divider = new("Frame", {
		Size             = UDim2.new(0, 1, 1, -24),
		Position         = UDim2.new(1, -1, 0, 12),
		BackgroundColor3 = Theme.Stroke,
		BorderSizePixel  = 0,
		Parent           = sidebar,
	})
	new("UIGradient", {
		Rotation     = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0.2),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = divider,
	})

	local content = new("Frame", {
		Name                   = "Content",
		Size                   = UDim2.new(1, -sidebarWidth, 1, 0),
		Position               = UDim2.new(0, sidebarWidth, 0, 0),
		BackgroundTransparency = 1,
		Parent                 = body,
	})

	local accountCard = new("Frame", {
		Name = "AccountCard",
		Size = UDim2.new(1, -20, 0, 50),
		Position = UDim2.new(0, 10, 1, -62),
		BackgroundColor3 = Theme.Panel,
		BackgroundTransparency = Glass.Panel,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 30,
		Parent = sidebar,
	})
	corner(accountCard, 14)
	stroke(accountCard, Theme.Stroke, 1, 0.14)
	new("UIGradient", {
		Rotation = 8,
		Color = ColorSequence.new(Theme.Panel, Theme.Element),
		Transparency = NumberSequence.new(0.04, 0.28),
		Parent = accountCard,
	})
	local accountAvatar = new("ImageLabel", {
		Size = UDim2.fromOffset(36, 36),
		Position = UDim2.fromOffset(7, 7),
		BackgroundColor3 = Theme.Element,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		Image = "",
		ZIndex = 32,
		Parent = accountCard,
	})
	corner(accountAvatar, 11)
	stroke(accountAvatar, Theme.AccentSoft, 1, 0.24)
	local accountName = new("TextLabel", {
		Size = UDim2.new(1, -58, 0, 18),
		Position = UDim2.fromOffset(51, 7),
		BackgroundTransparency = 1,
		Text = LocalPlayer.DisplayName,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Theme.FontBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 32,
		Parent = accountCard,
	})
	local accountUsername = new("TextLabel", {
		Size = UDim2.new(1, -58, 0, 15),
		Position = UDim2.fromOffset(51, 25),
		BackgroundTransparency = 1,
		Text = "@" .. LocalPlayer.Name,
		TextColor3 = Theme.TextDim,
		TextSize = 11,
		Font = Theme.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 32,
		Parent = accountCard,
	})
	task.spawn(function()
		local ok, thumbnail = pcall(function()
			return Players:GetUserThumbnailAsync(LocalPlayer.UserId,
				Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
		if not (ok and accountAvatar.Parent) then return end
		-- An executor/service wrapper can return an unexpected value. Never pass
		-- an Instance (or its tostring name) to the ContentId property.
		if type(thumbnail) ~= "string" or thumbnail == "" then
			warn("[TikiUI][AVATAR] ignored unexpected thumbnail type=" .. typeof(thumbnail))
			return
		end
		accountAvatar.Image = thumbnail
	end)

	local grip = new("TextButton", {
		Size                   = UDim2.fromOffset(isMobile and 30 or 18, isMobile and 30 or 18),
		Position               = UDim2.new(1, isMobile and -34 or -22, 1, isMobile and -34 or -22),
		BackgroundTransparency = 1,
		AutoButtonColor        = false,
		Text                   = "",
		ZIndex                 = 20,
		Parent                 = main,
	})

	new("Frame", {
		Size                   = UDim2.fromOffset(11, 2),
		Position               = UDim2.fromOffset(5, 11),
		BackgroundColor3       = Theme.TextDim,
		BackgroundTransparency = 0.4,
		BorderSizePixel        = 0,
		Rotation               = -45,
		Parent                 = grip,
	})
	new("Frame", {
		Size                   = UDim2.fromOffset(6, 2),
		Position               = UDim2.fromOffset(10, 6),
		BackgroundColor3       = Theme.TextDim,
		BackgroundTransparency = 0.55,
		BorderSizePixel        = 0,
		Rotation               = -45,
		Parent                 = grip,
	})

	local Window: any = {}
	Window.Gui      = screenGui
	Window.Main     = main
	Window.Tabs     = {}
	Window.Sections = {}
	Window.Registry = {}
	Window.Current  = nil
	Window.ConfigDir = folder

	local minimized = false
	-- Wallpaper stays behind every interactive sibling, without consuming input.
	Window.BackgroundSettings = { Enabled = true, Dim = 0.35 }
	Window.BackgroundImage = new("ImageLabel", {
		Name = "TikiAnimeBackground", Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1, BorderSizePixel = 0,
		Image = "", ImageTransparency = 0, ImageColor3 = Color3.new(1, 1, 1),
		ScaleType = Enum.ScaleType.Crop, ZIndex = 0,
		Active = false, Selectable = false, Visible = false, Parent = main,
	})
	corner(Window.BackgroundImage, WINDOW_RADIUS)
	Window.BackgroundShade = new("Frame", {
		Name = "ReadabilityShade", Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.65,
		BorderSizePixel = 0, ZIndex = 1, Active = false, Selectable = false,
		Parent = Window.BackgroundImage,
	})
	corner(Window.BackgroundShade, WINDOW_RADIUS)
	function Window:RefreshBackground()
		if not self.BackgroundImage.Parent then return end
		self.BackgroundImage.Visible = self.BackgroundSettings.Enabled
			and not minimized and self.BackgroundImage.Image ~= ""
		self.BackgroundShade.BackgroundTransparency = 1 - self.BackgroundSettings.Dim
	end
	function Window:ApplyBackground(enabled, dim, reload)
		if enabled ~= nil then self.BackgroundSettings.Enabled = enabled == true end
		if type(dim) == "number" and dim == dim then self.BackgroundSettings.Dim = math.clamp(dim, 0, 0.85) end
		if reload then Library._backgroundAsset = nil; self.BackgroundImage.Image = "" end
		if self.BackgroundSettings.Enabled and self.BackgroundImage.Image == "" then
			local asset, err = Library:ResolveBackgroundAsset()
			if asset then
				local ok, assignError = pcall(function() self.BackgroundImage.Image = asset end)
				if not ok then err = tostring(assignError) end
			end
			if err and (reload or not self.BackgroundErrorShown) then
				self.BackgroundErrorShown = true
				warn("[TikiUI][BACKGROUND] " .. err)
			end
		end
		self:RefreshBackground()
	end
	Window:ApplyBackground(true, 0.35)


	local expandedW, expandedH = width, height
	local viewportConnection

	local function applyResponsiveLayout(recenter)
		local currentViewport = viewportSize()
		profile = getDeviceProfile()
		DeviceProfile = profile
		isMobile = profile.Mobile
		compactMode = profile.Compact

		topButtonSize = isMobile and 38 or 26
		closeBtn.Size = UDim2.fromOffset(topButtonSize, topButtonSize)
		minBtn.Size = UDim2.fromOffset(topButtonSize, topButtonSize)
		local buttonY = math.floor((46 - topButtonSize) / 2)
		closeBtn.Position = UDim2.new(1, -(topButtonSize + 8), 0, buttonY)
		minBtn.Position = UDim2.new(1, -(topButtonSize * 2 + 14), 0, buttonY)
		closeBtn.Visible = not minimized
		minBtn.Visible = not minimized

		sidebarWidth = isMobile and 96 or (compactMode and 112 or 164)
		sidebar.Size = UDim2.new(0, sidebarWidth, 1, 0)
		content.Size = UDim2.new(1, -sidebarWidth, 1, 0)
		content.Position = UDim2.new(0, sidebarWidth, 0, 0)
		accountCard.Size = UDim2.new(1, -20, 0, 50)
		accountCard.Position = UDim2.new(0, 10, 1, -62)
		local showAccountText = sidebarWidth >= 140
		accountName.Visible = showAccountText
		accountUsername.Visible = showAccountText
		accountAvatar.Position = showAccountText
			and UDim2.fromOffset(7, 7)
			or UDim2.new(0.5, -18, 0, 7)

		local titleX = compactMode and 46 or 52
		logo.Position = UDim2.new(0, compactMode and 10 or 14, 0, 9)
		searchW = compactMode
			and math.clamp(math.floor(currentViewport.X * 0.22), 72, 96)
			or 160
		local rightReserve = minimized and 8 or (topButtonSize * 2 + 22)
		searchBox.Size = UDim2.fromOffset(searchW, isMobile and 36 or 26)
		searchBox.Position = UDim2.new(1, -(rightReserve + searchW), 0, isMobile and 5 or 10)
		local titleRightGap = titleX + rightReserve + (minimized and 0 or (searchW + 8))
		titleLabel.Size = UDim2.new(1, -titleRightGap, 0, 18)
		titleLabel.Position = UDim2.new(0, titleX, 0, minimized and 12 or (compactMode and 15 or 8))
		titleLabel.Size = minimized and UDim2.new(1, -(titleX + 10), 0, 22) or titleLabel.Size
		titleLabel.TextSize = minimized and 18 or (compactMode and 15 or 16)
		subLabel.Size = UDim2.new(1, -titleRightGap, 0, 14)
		subLabel.Position = UDim2.new(0, titleX, 0, 24)
		subLabel.Text = subText
		subLabel.Visible = not compactMode and not minimized
		miniCreditLabel.Size = UDim2.new(1, -(titleX + rightReserve), 0, 14)
		miniCreditLabel.Position = UDim2.new(0, titleX, 0, 24)
		miniCreditLabel.Visible = false

		local gripSize = isMobile and 30 or 18
		grip.Size = UDim2.fromOffset(gripSize, gripSize)
		grip.Position = UDim2.new(1, -(gripSize + 4), 1, -(gripSize + 4))

		if compactMode then
			local availableWidth = math.max(math.floor(currentViewport.X - 12), 260)
			local availableHeight = math.max(math.floor(currentViewport.Y - 12), 220)
			local targetWidth = math.min(preferredWidth, math.floor(currentViewport.X * (isMobile and 0.96 or 0.92)), availableWidth)
			local targetHeight = math.min(preferredHeight, math.floor(currentViewport.Y * (isMobile and 0.92 or 0.88)), availableHeight)
			expandedW, expandedH = targetWidth, targetHeight
			if not minimized then
				width, height = targetWidth, targetHeight
			end
		end

		minWidth = math.min(isMobile and 184 or 196, compactMode and expandedW or width)
		minMinW = math.min(isMobile and 260 or 460, compactMode and expandedW or width)
		minMinH = math.min(isMobile and 220 or 300, compactMode and expandedH or height)

		if minimized then
			main.Size = UDim2.fromOffset(minWidth, 46)
		else
			main.Size = UDim2.fromOffset(width, height)
		end

		local actualWidth = minimized and minWidth or width
		local actualHeight = minimized and 46 or height
		local x = math.clamp(main.Position.X.Offset, 0, math.max(currentViewport.X - actualWidth, 0))
		local y = math.clamp(main.Position.Y.Offset, 0, math.max(currentViewport.Y - actualHeight, 0))
		if recenter then
			x = math.max((currentViewport.X - actualWidth) / 2, 0)
			y = math.max((currentViewport.Y - actualHeight) / 2, 0)
		end
		main.Position = UDim2.fromOffset(x, y)
	end
	local function runResponsiveLayout(recenter)
		local ok, err = pcall(applyResponsiveLayout, recenter)
		if not ok then warn("[TikiHub] responsive layout error: " .. tostring(err)) end
		return ok
	end

	local function watchCurrentCamera()
		if viewportConnection then
			viewportConnection:Disconnect()
			viewportConnection = nil
		end
		local camera = workspace.CurrentCamera
		if camera then
			viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
				task.defer(function()
					if screenGui.Parent then runResponsiveLayout(false) end
				end)
			end)
			table.insert(connections, viewportConnection)
		end
	end

	runResponsiveLayout(true)
	watchCurrentCamera()
	track(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		watchCurrentCamera()
		if screenGui.Parent then runResponsiveLayout(false) end
	end))

	do
		local resizing  = false
		local startSize = nil
		local startPos  = nil

		track(grip.InputBegan:Connect(function(input)
			if isPressInput(input) and not minimized then
				resizing  = true
				startSize = main.AbsoluteSize
				startPos  = input.Position
			end
		end))

		track(UserInputService.InputChanged:Connect(function(input)
			if not resizing or not startPos then return end
			if isMoveInput(input) then
				local delta  = input.Position - startPos
				local screen = viewportSize()
				width  = math.clamp(startSize.X + delta.X, minMinW, math.max(screen.X - 20, minMinW))
				height = math.clamp(startSize.Y + delta.Y, minMinH, math.max(screen.Y - 20, minMinH))
				main.Size = UDim2.fromOffset(width, height)

				if dragState.Clamp then
					local pos = main.Position
					main.Position = UDim2.new(
						pos.X.Scale, math.clamp(pos.X.Offset, 0, math.max(screen.X - width, 0)),
						pos.Y.Scale, math.clamp(pos.Y.Offset, 0, math.max(screen.Y - height, 0))
					)
				end
			end
		end))

		track(UserInputService.InputEnded:Connect(function(input)
			if isPressInput(input) then
				resizing = false
			end
		end))
	end

	local function setMinimized(value)
		local nextValue = value and true or false
		if minimized == nextValue then return end
		minimized = nextValue
		Window:RefreshBackground()
		local titleX = compactMode and 46 or 52
		local buttonReserve = minimized and 8 or (topButtonSize * 2 + 22)
		titleLabel.Size = minimized
			and UDim2.new(1, -(titleX + buttonReserve), 0, 18)
			or UDim2.new(1, -(titleX + buttonReserve + searchW + 8), 0, 18)
		closeBtn.Visible = not minimized
		minBtn.Visible = not minimized
		miniOpenButton.Visible = false
		main.BackgroundTransparency = minimized and 1 or Glass.Window
		topbar.BackgroundTransparency = minimized and Glass.Capsule or Glass.Topbar
		for _, patch in ipairs(topbarSquarePatches) do patch.Visible = not minimized end
		for _, patch in ipairs(topbarSquarePatches) do
			patch.BackgroundTransparency = Glass.Topbar
		end
		if topbarSheen then topbarSheen.Visible = not minimized end
		underline.Visible = not minimized
		for index, shadow in ipairs(mainShadows) do
			shadow.Visible = not minimized
			if not minimized then
				shadow.BackgroundTransparency = 0.88 + (1 - 0.88) * (index / math.max(#mainShadows, 1))
			end
		end

		if minimized then

			expandedW, expandedH = width, height
			body.Visible  = false
			grip.Visible  = false

			searchBox.Visible = false
			titleLabel.Position = UDim2.new(0, titleX, 0, 12)
			titleLabel.TextSize = 18
			subLabel.Visible = false
			miniCreditLabel.Visible = false
			logo.Position = UDim2.new(0, 9, 0, 8)
			tween(main, {
				Size = UDim2.fromOffset(minWidth, 46),
			}, 0.28, Enum.EasingStyle.Quint)
			width = minWidth
		else
			width, height = expandedW, expandedH
			logo.Position = UDim2.new(0, compactMode and 10 or 14, 0, 9)
			searchBox.Visible = true
			titleLabel.Position = UDim2.new(0, titleX, 0, compactMode and 15 or 8)
			titleLabel.TextSize = compactMode and 15 or 16
			subLabel.Text = subText
			subLabel.Visible  = not compactMode
			miniCreditLabel.Visible = false
			tween(main, { Size = UDim2.fromOffset(width, height) }, 0.34, Enum.EasingStyle.Quint)
			task.delay(0.16, function()
				if not minimized then
					body.Visible = true
					grip.Visible = true
				end
			end)
		end
	end

	minBtn.MouseButton1Click:Connect(function()
		setMinimized(true)
	end)
	local miniPressPosition
	local miniPressMoved = false
	track(topbar.InputBegan:Connect(function(input)
		if minimized and isPressInput(input) then
			miniPressPosition = input.Position
			miniPressMoved = false
		end
	end))
	track(UserInputService.InputChanged:Connect(function(input)
		if minimized and miniPressPosition and isMoveInput(input) then
			if (input.Position - miniPressPosition).Magnitude > 6 then miniPressMoved = true end
		end
	end))
	track(UserInputService.InputEnded:Connect(function(input)
		if minimized and miniPressPosition and isPressInput(input) then
			local shouldOpen = not miniPressMoved
			miniPressPosition = nil
			miniPressMoved = false
			if shouldOpen then setMinimized(false) end
		end
	end))

	closeBtn.MouseButton1Click:Connect(function()
		tween(main, { Size = UDim2.fromOffset(width, 0) }, 0.15)
		task.delay(0.2, function()
			Window:Destroy()
		end)
	end)

	track(UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode == keybind then
			screenGui.Enabled = not screenGui.Enabled
		end
	end))

	function Window:Toggle()
		screenGui.Enabled = not screenGui.Enabled
	end

	function Window:SetClamp(enabled)
		dragState.Clamp = enabled and true or false
	end

	function Window:ApplyResponsiveLayout(recenter)
		runResponsiveLayout(recenter == true)
	end

	function Window:Destroy()
		if Library.StopFeatures then
			pcall(function()
				Library:StopFeatures()
			end)
		end

		for _, conn in ipairs(connections) do
			pcall(function()
				conn:Disconnect()
			end)
		end
		connections = {}

		for _, entry in ipairs(Window.Registry) do

			if entry.SetBind then
				pcall(entry.SetBind, nil)
			end
			if entry.Flag and Library.Entries[entry.Flag] == entry then
				Library.Entries[entry.Flag] = nil
			end
		end

		for index, other in ipairs(Library.Windows) do
			if other == Window then
				table.remove(Library.Windows, index)
				break
			end
		end
		if #Library.Windows == 0 then
			runtimeAlive = false
		end

		screenGui:Destroy()
		if #Library.Windows == 0 and not Library._unloading then
			task.defer(function()
				if #Library.Windows == 0 and Library.Unload then
					Library:Unload()
				end
			end)
		end
	end

	function Window:Notify(cfg)
		Library:Notify(cfg)
	end

	function Window:Search(query)
		query = lowerText(query or "")
		local matchesByTab = {}
		local firstMatchingTab

		for _, entry in ipairs(Window.Registry) do
			local tabName = entry.Tab and entry.Tab.Name or ""
			local sectionName = entry.Section and entry.Section.Name or ""
			local searchable = lowerText(table.concat({ entry.Name or "", sectionName, tabName }, " "))
			local visible = query == "" or string.find(searchable, query, 1, true) ~= nil
			entry.Instance.Visible = visible
			if visible and entry.Tab then
				matchesByTab[entry.Tab] = (matchesByTab[entry.Tab] or 0) + 1
				firstMatchingTab = firstMatchingTab or entry.Tab
			end
		end

		for _, section in ipairs(Window.Sections) do
			if query == "" then
				section.Holder.Visible = true
			else
				local any = false
				for _, entry in ipairs(section.Entries) do
					if entry.Instance.Visible then
						any = true
						break
					end
				end
				section.Holder.Visible = any
			end
		end

		for _, tab in ipairs(Window.Tabs) do
			local hasMatch = query == "" or (matchesByTab[tab] or 0) > 0
			if tab.Row then tab.Row.Visible = hasMatch end
		end

		if query ~= "" and firstMatchingTab
			and (not Window.Current or (matchesByTab[Window.Current] or 0) == 0) then
			firstMatchingTab.Select()
		end
	end

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		Window:Search(searchBox.Text)
	end)

	-- Code-drawn icons: no unsupported Unicode glyphs or external image assets.
	function Window:_drawTabIcon(parent, key)
		local canvas = new("Frame", {
			Name = "TabVectorIcon", Size = UDim2.fromOffset(18, 18),
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1, ZIndex = 4, Parent = parent,
		})
		local paints = {}

		local function line(x1, y1, x2, y2)
			local dx, dy = x2 - x1, y2 - y1
			local part = new("Frame", {
				Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), 1.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2),
				Rotation = math.deg(math.atan2(dy, dx)),
				BackgroundColor3 = Theme.TextDim,
				BorderSizePixel = 0, ZIndex = 4, Parent = canvas,
			})
			corner(part, 1)
			table.insert(paints, { Object = part, Property = "BackgroundColor3" })
		end

		local function ring(x, y, diameter)
			local part = new("Frame", {
				Size = UDim2.fromOffset(diameter, diameter),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromOffset(x, y),
				BackgroundTransparency = 1,
				BorderSizePixel = 0, ZIndex = 4, Parent = canvas,
			})
			corner(part, diameter)
			table.insert(paints, { Object = stroke(part, Theme.TextDim, 1.5), Property = "Color" })
		end

		local function dot(x, y, diameter)
			local part = new("Frame", {
				Size = UDim2.fromOffset(diameter, diameter),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromOffset(x, y),
				BackgroundColor3 = Theme.TextDim,
				BorderSizePixel = 0, ZIndex = 4, Parent = canvas,
			})
			corner(part, diameter)
			table.insert(paints, { Object = part, Property = "BackgroundColor3" })
		end

		local name = string.lower(tostring(key)):gsub("^@", ""):gsub("^tab%.", "")

		if name == "info" or name == "read this" then
			ring(9, 9, 14); dot(9, 5, 2.5); line(9, 8, 9, 14)
		elseif name == "swords" or name == "farm" or name == "combat" then
			line(3, 3, 15, 15); line(15, 3, 3, 15); line(2, 2, 6, 2); line(12, 2, 16, 2)
		elseif name == "trending-up" or name == "progress" then
			line(2, 14, 7, 9); line(7, 9, 10, 12); line(10, 12, 16, 5); line(12, 5, 16, 5); line(16, 5, 16, 9)
		elseif name == "skull" or name == "boss" then
			ring(9, 8, 12); dot(6.5, 7.5, 2); dot(11.5, 7.5, 2); line(6, 13, 12, 13); line(7, 13, 7, 16); line(11, 13, 11, 16)
		elseif name == "door-open" or name == "dungeons" then
			line(4, 2, 13, 2); line(4, 2, 4, 16); line(13, 2, 13, 16); line(4, 16, 15, 16); dot(10.5, 9, 2)
		elseif name == "scroll-text" or name == "quest" then
			line(5, 3, 14, 3); line(4, 5, 4, 15); line(4, 15, 13, 15); line(14, 3, 14, 13)
			line(7, 7, 12, 7); line(7, 10, 12, 10)
		elseif name == "map-pin" or name == "teleport" then
			ring(9, 7, 8); dot(9, 7, 2); line(6, 10, 9, 16); line(12, 10, 9, 16)
		elseif name == "user" or name == "player" then
			ring(9, 5, 6); line(3, 16, 3, 13); line(3, 13, 6, 10); line(6, 10, 12, 10); line(12, 10, 15, 13); line(15, 13, 15, 16)
		elseif name == "package-open" or name == "loot" then
			line(3, 6, 9, 2); line(9, 2, 15, 6); line(3, 6, 9, 10); line(15, 6, 9, 10)
			line(3, 6, 3, 13); line(15, 6, 15, 13); line(3, 13, 9, 16); line(15, 13, 9, 16); line(9, 10, 9, 16)
		elseif name == "fish" or name == "activities" then
			line(3, 9, 7, 5); line(7, 5, 13, 6); line(13, 6, 16, 3); line(13, 6, 16, 9); line(7, 13, 3, 9); line(7, 5, 7, 13); dot(10, 8, 2)
		elseif name == "settings" or name == "misc" then
			line(3, 2, 3, 16); line(9, 2, 9, 16); line(15, 2, 15, 16); ring(3, 6, 4); ring(9, 12, 4); ring(15, 7, 4)
		elseif name == "server" then
			line(3, 3, 15, 3); line(3, 8, 15, 8); line(3, 13, 15, 13); dot(5, 5.5, 2); dot(5, 10.5, 2); dot(12.5, 5.5, 1.5); dot(12.5, 10.5, 1.5)
		elseif name == "main" then
			line(2, 8, 9, 2); line(9, 2, 16, 8); line(4, 7, 4, 16); line(4, 16, 14, 16); line(14, 16, 14, 7)
			line(8, 16, 8, 11); line(8, 11, 11, 11); line(11, 11, 11, 16)
		elseif name == "visuals" then
			line(1, 9, 5, 5); line(5, 5, 13, 5); line(13, 5, 17, 9); line(17, 9, 13, 13); line(13, 13, 5, 13); line(5, 13, 1, 9); ring(9, 9, 5)
		else
			line(3, 3, 15, 3); line(3, 9, 15, 9); line(3, 15, 15, 15)
		end
		return paints
	end

	function Window:AddTab(tabName, iconName)
		local tabText, tabKey = resolveText(tabName)
		local row = new("Frame", {
			Size                   = UDim2.new(1, 0, 0, isMobile and 44 or 38),
			BackgroundTransparency = 1,
			Parent                 = tabList,
		})

		local barHolder = new("Frame", {
			Size                   = UDim2.new(0, 3, 0, 0),
			Position               = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint            = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Visible                = false,
			Parent                 = row,
		})

		local bar = new("Frame", {
			Size             = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Theme.Accent,
			BorderSizePixel  = 0,
			Parent           = barHolder,
		})
		corner(bar, 2)
		new("UIGradient", {
			Rotation = 90,
			Color    = ColorSequence.new(Theme.AccentSoft, Theme.Accent),
			Parent   = bar,
		})
		addGlow(bar, Theme.Accent, 2, 2)

		local button = new("TextButton", {
			Size                   = UDim2.new(1, -8, 1, 0),
			Position               = UDim2.new(0, 8, 0, 0),
			BackgroundColor3       = Theme.Element,
			BackgroundTransparency = 1,
			AutoButtonColor        = false,
			Text                   = "",
			BorderSizePixel        = 0,
			Parent                 = row,
		})
		corner(button, 11)

		local iconBadge = new("Frame", {
			Size = UDim2.fromOffset(isMobile and 26 or 24, isMobile and 26 or 24),
			Position = UDim2.new(0, 7, 0.5, isMobile and -13 or -12),
			BackgroundColor3 = Theme.ElementHover,
			BackgroundTransparency = 0.48,
			BorderSizePixel = 0,
			ZIndex = 3,
			Parent = button,
		})
		corner(iconBadge, 8)
		local iconStroke = stroke(iconBadge, Theme.Stroke, 1, 0.45)
		local iconPaints = Window:_drawTabIcon(iconBadge, iconName or tabKey or tabName)

		local tabLabel = new("TextLabel", {
			Size = UDim2.new(1, -45, 1, 0),
			Position = UDim2.fromOffset(39, 0),
			BackgroundTransparency = 1,
			Text = tabText,
			TextColor3 = Theme.TextDim,
			TextSize = 13,
			Font = Theme.FontBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = 3,
			Parent = button,
		})
		bindText(tabLabel, "Text", tabKey)

		local page = new("ScrollingFrame", {
			Size                   = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel        = 0,
			ScrollBarThickness     = isMobile and 3 or 4,
			ScrollBarImageColor3   = Theme.Accent,
			ScrollBarImageTransparency = 0.55,
			CanvasSize             = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize    = Enum.AutomaticSize.Y,
			Visible                = false,
			Parent                 = content,
		})
		new("UIListLayout", {
			Padding   = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent    = page,
		})
		new("UIPadding", {
			PaddingTop    = UDim.new(0, isMobile and 10 or 14),
			PaddingBottom = UDim.new(0, isMobile and 10 or 14),
			PaddingLeft   = UDim.new(0, isMobile and 10 or 14),
			PaddingRight  = UDim.new(0, isMobile and 10 or 14),
			Parent        = page,
		})

		local Tab = {}
		Tab.Button = button
		Tab.Page   = page
		Tab.Row    = row
		Tab.Name   = tabText

		local function select()
			for _, other in ipairs(Window.Tabs) do
				if other ~= Tab then
					other.Page.Visible = false
					other.SetActive(false)
				end
			end

			page.Position = UDim2.new(0, 22, 0, 0)
			page.Visible  = true
			tween(page, { Position = UDim2.new(0, 0, 0, 0) }, 0.4)

			Tab.SetActive(true)
			Window.Current = Tab
		end

		function Tab.SetActive(active)
			if active then
				barHolder.Visible = true
				tween(barHolder, { Size = UDim2.new(0, 3, 0, 20) }, 0.2, Enum.EasingStyle.Back)
				tween(button, { BackgroundTransparency = 0.08 }, 0.2)
				tween(tabLabel, { TextColor3 = Theme.Text }, 0.2)
				tween(iconBadge, { BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.12 }, 0.22)
				for _, paint in ipairs(iconPaints) do tween(paint.Object, { [paint.Property] = Color3.fromRGB(255, 255, 255) }, 0.22) end
				tween(iconStroke, { Color = Theme.AccentSoft, Transparency = 0.12 }, 0.22)
			else
				tween(barHolder, { Size = UDim2.new(0, 3, 0, 0) }, 0.15)
				tween(button, { BackgroundTransparency = 1 }, 0.15)
				tween(tabLabel, { TextColor3 = Theme.TextDim }, 0.15)
				tween(iconBadge, { BackgroundColor3 = Theme.ElementHover, BackgroundTransparency = 0.48 }, 0.18)
				for _, paint in ipairs(iconPaints) do tween(paint.Object, { [paint.Property] = Theme.TextDim }, 0.18) end
				tween(iconStroke, { Color = Theme.Stroke, Transparency = 0.45 }, 0.18)
				task.delay(0.16, function()
					if Window.Current ~= Tab then
						barHolder.Visible = false
					end
				end)
			end
		end

		Tab.Select = select

		button.MouseEnter:Connect(function()
			if Window.Current ~= Tab then
				tween(button, { BackgroundTransparency = 0.6 })
				tween(tabLabel, { TextColor3 = Theme.Text })
			end
		end)
		button.MouseLeave:Connect(function()
			if Window.Current ~= Tab then
				tween(button, { BackgroundTransparency = 1 })
				tween(tabLabel, { TextColor3 = Theme.TextDim })
			end
		end)
		button.MouseButton1Click:Connect(select)

		function Tab:AddSection(sectionName)
			local holder = new("Frame", {
				Size             = UDim2.new(1, 0, 0, 0),
				AutomaticSize    = Enum.AutomaticSize.Y,
				BackgroundColor3 = Theme.Panel,
				BackgroundTransparency = Glass.Section,
				BorderSizePixel  = 0,
				Parent           = page,
			})
			corner(holder, 15)
			stroke(holder, Theme.Stroke, 1, 0.18)
			new("UIGradient", {
				Rotation = 105,
				Color = ColorSequence.new(Theme.Panel, Theme.Background),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.02),
					NumberSequenceKeypoint.new(1, 0.36),
				}),
				Parent = holder,
			})
			new("UIPadding", {
				PaddingTop    = UDim.new(0, 13),
				PaddingBottom = UDim.new(0, 13),
				PaddingLeft   = UDim.new(0, 13),
				PaddingRight  = UDim.new(0, 13),
				Parent        = holder,
			})
			new("UIListLayout", {
				Padding   = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent    = holder,
			})

			local sectionText, sectionKey = resolveText(sectionName)
			if sectionText and sectionText ~= "" then
				local header = new("Frame", {
					Size                   = UDim2.new(1, 0, 0, 22),
					BackgroundTransparency = 1,
					LayoutOrder            = -1,
					Parent                 = holder,
				})

				local dot = new("Frame", {
					Size             = UDim2.fromOffset(4, 14),
					Position         = UDim2.new(0, 0, 0.5, -7),
					BackgroundColor3 = Theme.Accent,
					BorderSizePixel  = 0,
					Parent           = header,
				})
				corner(dot, 2)
				addGlow(dot, Theme.Accent, 2, 2)

				local headerLabel = new("TextLabel", {
					Size                   = UDim2.new(1, -12, 1, 0),
					Position               = UDim2.new(0, 10, 0, 0),
					BackgroundTransparency = 1,
					Text                   = sectionText,
					TextColor3             = Theme.Text,
					TextSize               = 13,
					Font                   = Theme.FontBold,
					TextXAlignment         = Enum.TextXAlignment.Left,
					Parent                 = header,
				})
				bindText(headerLabel, "Text", sectionKey)

				local hair = new("Frame", {
					Size             = UDim2.new(1, 0, 0, 1),
					Position         = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = Theme.Stroke,
					BorderSizePixel  = 0,
					Parent           = header,
				})
				new("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.35),
						NumberSequenceKeypoint.new(1, 1),
					}),
					Parent = hair,
				})
			end

			local sectionRecord = { Holder = holder, Entries = {}, Name = sectionText or "", Tab = Tab }
			table.insert(Window.Sections, sectionRecord)

			local Section = {}

			local function register(entry)
				local display, nameKey = resolveText(entry.Name)
				entry.Name    = display
				entry.NameKey = nameKey
				entry.Tab     = Tab
				entry.Section = sectionRecord
				table.insert(Window.Registry, entry)
				table.insert(sectionRecord.Entries, entry)
				if entry.Flag then
					Library.Entries[entry.Flag] = entry
				end
				return entry
			end

			local function baseRow(height, asButton)
				if not isMobile and height <= 34 then height = 38 end
				if isMobile then
					if height <= 34 then
						height = 44
					elseif height <= 50 then
						height = 54
					end
				end
				local props = {
					Size             = UDim2.new(1, 0, 0, height),
					BackgroundColor3 = Theme.Element,
					BackgroundTransparency = Glass.Element,
					BorderSizePixel  = 0,
					Parent           = holder,
				}
				if asButton then
					props.AutoButtonColor = false
					props.Text = ""
				end
				local row = new(asButton and "TextButton" or "Frame", props)
				corner(row, 11)
				local rowStroke = stroke(row, Theme.Stroke, 1, 0.38)
				addSheen(row, 0.955)
				return row, rowStroke
			end

			local function hoverable(row, rowStroke)
				if DeviceProfile.LowPower then
					return nil
				end
				local rowScale = new("UIScale", { Scale = 1, Parent = row })

				row.MouseEnter:Connect(function()
					tween(row, { BackgroundColor3 = Theme.ElementHover }, 0.2, Enum.EasingStyle.Sine)
					tween(rowStroke, { Color = Theme.Accent, Transparency = 0.35 }, 0.2, Enum.EasingStyle.Sine)
					tween(rowScale, { Scale = 1.006 }, 0.22)
				end)
				row.MouseLeave:Connect(function()
					tween(row, { BackgroundColor3 = Theme.Element }, 0.25, Enum.EasingStyle.Sine)
					tween(rowStroke, { Color = Theme.Stroke, Transparency = 0.45 }, 0.25, Enum.EasingStyle.Sine)
					tween(rowScale, { Scale = 1 }, 0.28)
				end)

				return rowScale
			end

			local function rowLabel(row, text, rightGap)
				local display, key = resolveText(text)
				local label = new("TextLabel", {
					Size                   = UDim2.new(1, -(rightGap or 24), 1, 0),
					Position               = UDim2.new(0, 12, 0, 0),
					BackgroundTransparency = 1,
					Text                   = display,
					TextColor3             = Theme.Text,
					TextSize               = 14,
					Font                   = Theme.Font,
					TextXAlignment         = Enum.TextXAlignment.Left,
					TextTruncate           = Enum.TextTruncate.AtEnd,
					Parent                 = row,
				})
				bindText(label, "Text", key)
				return label
			end

			local function bindChip(row, offsetX)
				local chip = new("TextLabel", {
					Size             = UDim2.fromOffset(38, 16),
					Position         = UDim2.new(1, offsetX, 0.5, -8),
					BackgroundColor3 = Theme.BackgroundLo,
					Text             = "",
					TextColor3       = Theme.Accent,
					TextSize         = 11,
					Font             = Theme.FontBold,
					Visible          = false,
					BorderSizePixel  = 0,
					ZIndex           = 4,
					Parent           = row,
				})
				corner(chip, 4)
				stroke(chip, Theme.Accent, 1, 0.55)
				return chip
			end

			function Section:AddButton(text, callback, flag)
				local row, rowStroke = baseRow(34, true)
				row.ClipsDescendants = true
				local rowScale = hoverable(row, rowStroke)
				local display, textKey = resolveText(text)
				row.Text       = display
				row.TextColor3 = Theme.Text
				row.TextSize   = 13
				row.Font       = Theme.FontBold
				row.TextXAlignment = Enum.TextXAlignment.Left
				bindText(row, "Text", textKey)
				new("UIPadding", {
					PaddingLeft = UDim.new(0, 14),
					PaddingRight = UDim.new(0, 34),
					Parent = row,
				})
				local arrow = new("TextLabel", {
					Size = UDim2.fromOffset(20, 20),
					Position = UDim2.new(1, -27, 0.5, -10),
					BackgroundTransparency = 1,
					Text = "›",
					TextColor3 = Theme.AccentSoft,
					TextSize = 20,
					Font = Theme.FontBold,
					Parent = row,
				})

				local bindKey, bindHandle
				local chip = bindChip(row, -44)

				local function press()
					tween(arrow, { Position = UDim2.new(1, -23, 0.5, -10), TextColor3 = Theme.Text }, 0.09)
					rippleAt(row, Theme.Accent)
					pressEffect(row, rowScale)
					tween(rowStroke, { Color = Theme.Accent, Transparency = 0 }, 0.1)
					task.delay(0.18, function()
						tween(rowStroke, { Color = Theme.Stroke, Transparency = 0.45 }, 0.3)
						tween(arrow, { Position = UDim2.new(1, -27, 0.5, -10), TextColor3 = Theme.AccentSoft }, 0.24)
					end)
					playSound("Click")
					safeCall(callback)
				end

				local function setBind(key)
					if bindHandle then
						removeBind(bindHandle)
						bindHandle = nil
					end
					bindKey = key
					if key then
						bindHandle  = addBind(key, press)
						chip.Text    = key.Name
						chip.Visible = true
					else
						chip.Visible = false
					end
				end

				row.MouseButton1Click:Connect(press)

				row.MouseButton2Click:Connect(function()
					chip.Visible = true
					chip.Text    = translate("ui.listening")
					captureKey(setBind)
				end)

				register({
					Type = "button", Name = text, Instance = row, Flag = flag,
					GetBind = function() return bindKey end,
					SetBind = function(key) setBind(key) end,
				})

				return {
					Set      = function(_, newText) row.Text = newText end,
					SetBind  = function(_, key) setBind(key) end,
					Instance = row,
				}
			end

			function Section:AddLabel(text)
				local display, textKey = resolveText(text)
				local label = new("TextLabel", {
					Size                   = UDim2.new(1, 0, 0, 0),
					AutomaticSize          = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Text                   = display,
					TextColor3             = Theme.TextDim,
					TextSize               = 13,
					Font                   = Theme.Font,
					TextXAlignment         = Enum.TextXAlignment.Left,
					TextWrapped            = true,
					Parent                 = holder,
				})

				bindText(label, "Text", textKey)

				local entry = register({ Type = "label", Name = text, Instance = label })
				return {
					Set = function(_, newText)
						label.Text    = newText
						entry.Name    = newText
						entry.NameKey = nil
					end,
					Instance = label,
				}
			end

			function Section:AddDivider()
				local line = new("Frame", {
					Size                   = UDim2.new(1, 0, 0, 1),
					BackgroundColor3       = Theme.Stroke,
					BorderSizePixel        = 0,
					Parent                 = holder,
				})
				register({ Type = "divider", Name = "", Instance = line })
				return line
			end

			function Section:AddToggle(text, default, callback, flag)
				local state = default and true or false
				local row, rowStroke = baseRow(34, true)
				hoverable(row, rowStroke)
				rowLabel(row, text, 70)
				local featureSnake, featureSnakeGradient, featureSnakeAnimation = addNeonSnake(
					row,
					DeviceProfile.LowPower and 1 or 1.45,
					360,
					DeviceProfile.LowPower and 4.2 or 2.45
				)
				featureSnake.Transparency = 1
				featureSnakeAnimation:Pause()
				featureSnakeGradient.Offset = Vector2.new(-1, 0)

				local switch = new("Frame", {
					Size             = UDim2.fromOffset(42, 22),
					Position         = UDim2.new(1, -54, 0.5, -11),
					BackgroundColor3 = Theme.BackgroundLo,
					BorderSizePixel  = 0,
					Parent           = row,
				})
				corner(switch, 11)
				local switchStroke = stroke(switch, Theme.Stroke, 1, 0.36)
				local switchFlow = new("UIGradient", {
					Enabled = false,
					Rotation = 12,
					Offset = Vector2.new(-1, 0),
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 225, 255)),
						ColorSequenceKeypoint.new(0.5, Color3.fromRGB(116, 84, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(239, 82, 255)),
					}),
					Parent = switch,
				})
				local switchFlowAnimation = TweenService:Create(
					switchFlow,
					TweenInfo.new(DeviceProfile.LowPower and 3.6 or 1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
					{ Offset = Vector2.new(1, 0), Rotation = 372 }
				)
				local trackGlow = addGlow(switch, Theme.Accent, 3, 10)
				setGlow(trackGlow, false)

				local knob = new("Frame", {
					Size             = UDim2.fromOffset(16, 16),
					Position         = UDim2.new(0, 3, 0.5, -8),
					BackgroundColor3 = Theme.TextDim,
					BorderSizePixel  = 0,
					ZIndex           = 2,
					Parent           = switch,
				})
				corner(knob, 8)
				stroke(knob, Color3.fromRGB(255, 255, 255), 1, 0.62)

				local function set(value, fire)
					state = value and true or false
					if state then
						featureSnake.Transparency = 0.02
						featureSnakeAnimation:Play()
						switchFlow.Enabled = true
						switchFlowAnimation:Play()
					else
						featureSnake.Transparency = 1
						featureSnakeAnimation:Pause()
						featureSnakeGradient.Offset = Vector2.new(-1, 0)
						switchFlowAnimation:Pause()
						switchFlow.Offset = Vector2.new(-1, 0)
						switchFlow.Enabled = false
					end
					tween(switch, { BackgroundColor3 = state and Theme.Accent or Theme.BackgroundLo }, 0.3, Enum.EasingStyle.Sine)
					tween(switchStroke, { Color = state and Theme.AccentSoft or Theme.Stroke, Transparency = state and 0.08 or 0.36 }, 0.25)
					spring(knob, {
						Position         = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
						BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Theme.TextDim,
						Size             = state and UDim2.fromOffset(16, 16) or UDim2.fromOffset(16, 16),
					}, 0.36)
					setGlow(trackGlow, state)
					if fire ~= false then
						safeCall(callback, state)
					end
				end

				local bindKey, bindHandle
				local chip = bindChip(row, -92)

				local function toggle()
					set(not state)
					playSound(state and "ToggleOn" or "ToggleOff")
				end

				local function setBind(key)
					if bindHandle then
						removeBind(bindHandle)
						bindHandle = nil
					end
					bindKey = key
					if key then
						bindHandle   = addBind(key, toggle)
						chip.Text    = key.Name
						chip.Visible = true
					else
						chip.Visible = false
					end
				end

				row.MouseButton1Click:Connect(toggle)

				row.MouseButton2Click:Connect(function()
					chip.Visible = true
					chip.Text    = translate("ui.listening")
					captureKey(setBind)
				end)

				set(state, false)
				addRestyler(function() set(state, false) end)

				register({
					Type = "toggle", Name = text, Instance = row, Flag = flag,
					Get = function() return state end,
					Set = function(value) set(value) end,
					GetBind = function() return bindKey end,
					SetBind = function(key) setBind(key) end,
				})

				return {
					Set     = function(_, value) set(value) end,
					Get     = function() return state end,
					SetBind = function(_, key) setBind(key) end,
				}
			end

			function Section:AddSlider(text, minValue, maxValue, default, callback, step, flag)
				local display, textKey = resolveText(text)
				minValue = minValue or 0
				maxValue = maxValue or 100
				step     = step or 1
				local value = math.clamp(default or minValue, minValue, maxValue)

				local row, rowStroke = baseRow(50, false)
				hoverable(row, rowStroke)

				local titleLabel = new("TextLabel", {
					Size                   = UDim2.new(1, -90, 0, 18),
					Position               = UDim2.new(0, 12, 0, 7),
					BackgroundTransparency = 1,
					Text                   = display,
					TextColor3             = Theme.Text,
					TextSize               = 13,
					Font                   = Theme.FontBold,
					TextXAlignment         = Enum.TextXAlignment.Left,
					TextTruncate           = Enum.TextTruncate.AtEnd,
					Parent                 = row,
				})
				bindText(titleLabel, "Text", textKey)

				local valueLabel = new("TextLabel", {
					Size                   = UDim2.new(0, 60, 0, 20),
					Position               = UDim2.new(1, -72, 0, 6),
					BackgroundColor3       = Theme.BackgroundLo,
					BackgroundTransparency = 0.12,
					Text                   = "0",
					TextColor3             = Theme.Accent,
					TextSize               = 13,
					Font                   = Theme.FontBold,
					TextXAlignment         = Enum.TextXAlignment.Center,
					Parent                 = row,
				})
				corner(valueLabel, 7)
				stroke(valueLabel, Theme.Stroke, 1, 0.4)

				local bar = new("Frame", {
					Size             = UDim2.new(1, -24, 0, 6),
					Position         = UDim2.new(0, 12, 0, 33),
					BackgroundColor3 = Theme.BackgroundLo,
					BorderSizePixel  = 0,
					Parent           = row,
				})
				corner(bar, 3)
				stroke(bar, Theme.Stroke, 1, 0.55)

				local fill = new("Frame", {
					Size             = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = Theme.Accent,
					BorderSizePixel  = 0,
					Parent           = bar,
				})
				corner(fill, 3)
				new("UIGradient", {
					Color  = ColorSequence.new(Theme.AccentSoft, Theme.Accent),
					Parent = fill,
				})
				addGlowInside(fill, Theme.Accent, 2, 3)

				local knob = new("Frame", {
					Size             = UDim2.fromOffset(14, 14),
					Position         = UDim2.new(0, -7, 0.5, -7),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel  = 0,
					ZIndex           = 3,
					Parent           = bar,
				})
				corner(knob, 7)
				stroke(knob, Theme.AccentSoft, 1.5, 0.12)

				local dragging = false

				local function format(v)
					if step >= 1 then
						return tostring(math.floor(v + 0.5))
					end
					return string.format("%.2f", v)
				end

				local function set(v, fire)
					v = math.clamp(v, minValue, maxValue)
					if step > 0 then
						v = math.floor((v - minValue) / step + 0.5) * step + minValue
					end
					v = math.clamp(v, minValue, maxValue)
					value = v

					local alpha = 0
					if maxValue > minValue then
						alpha = (v - minValue) / (maxValue - minValue)
					end

					if dragging then
						fill.Size     = UDim2.new(alpha, 0, 1, 0)
						knob.Position = UDim2.new(alpha, -7, 0.5, -7)
					else
						tween(fill, { Size = UDim2.new(alpha, 0, 1, 0) }, 0.3)
						tween(knob, { Position = UDim2.new(alpha, -7, 0.5, -7) }, 0.3)
					end
					valueLabel.Text = format(v)

					if fire ~= false then
						safeCall(callback, v)
					end
				end

				local hit = new("TextButton", {
					Size                   = UDim2.new(1, -24, 0, 22),
					Position               = UDim2.new(0, 12, 0, 26),
					BackgroundTransparency = 1,
					AutoButtonColor        = false,
					Text                   = "",
					ZIndex                 = 5,
					Parent                 = row,
				})

				local function updateFrom(input)
					local barPos  = bar.AbsolutePosition.X
					local barSize = math.max(bar.AbsoluteSize.X, 1)
					local alpha   = math.clamp((input.Position.X - barPos) / barSize, 0, 1)
					set(minValue + (maxValue - minValue) * alpha)
				end

				hit.InputBegan:Connect(function(input)
					if isPressInput(input) then
						dragging = true
						spring(knob, { Size = UDim2.fromOffset(18, 18) }, 0.28)
						tween(bar, { BackgroundColor3 = Theme.Element }, 0.2)
						updateFrom(input)
					end
				end)

				track(UserInputService.InputChanged:Connect(function(input)
					if dragging and isMoveInput(input) then
						updateFrom(input)
					end
				end))

				track(UserInputService.InputEnded:Connect(function(input)
					if isPressInput(input) and dragging then
						dragging = false
						spring(knob, { Size = UDim2.fromOffset(14, 14) }, 0.3)
						tween(bar, { BackgroundColor3 = Theme.BackgroundLo }, 0.25)
					end
				end))

				set(value, false)
				addRestyler(function() set(value, false) end)

				register({
					Type = "slider", Name = text, Instance = row, Flag = flag,
					Get = function() return value end,
					Set = function(v) set(v) end,
				})

				return {
					Set = function(_, v) set(v) end,
					Get = function() return value end,
				}
			end

			function Section:AddDropdown(text, options, default, callback, flag)
				options = options or {}
				local selected = default or options[1] or "—"
				local open = false

				local container = new("Frame", {
					Size                   = UDim2.new(1, 0, 0, 0),
					AutomaticSize          = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Parent                 = holder,
				})
				new("UIListLayout", {
					Padding   = UDim.new(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent    = container,
				})

				local head = new("TextButton", {
					Size             = UDim2.new(1, 0, 0, isMobile and 44 or 38),
					BackgroundColor3 = Theme.Element,
					BackgroundTransparency = Glass.Element,
					AutoButtonColor  = false,
					Text             = "",
					BorderSizePixel  = 0,
					LayoutOrder      = 1,
					Parent           = container,
				})
				corner(head, 11)
				local headStroke = stroke(head, Theme.Stroke, 1, 0.4)
				new("UIGradient", {
					Rotation = 12,
					Color = ColorSequence.new(Theme.Element, Theme.ElementHover),
					Transparency = NumberSequence.new(0.18, 0.58),
					Parent = head,
				})
				hoverable(head, headStroke)
				rowLabel(head, text, isMobile and 102 or 150)

				local valueLabel = new("TextLabel", {
					Size                   = UDim2.new(0, isMobile and 72 or 120, 1, 0),
					Position               = UDim2.new(1, isMobile and -94 or -142, 0, 0),
					BackgroundTransparency = 1,
					Text                   = tostring(selected),
					TextColor3             = Theme.AccentSoft,
					TextSize               = 13,
					Font                   = Theme.FontBold,
					TextXAlignment         = Enum.TextXAlignment.Right,
					TextTruncate           = Enum.TextTruncate.AtEnd,
					Parent                 = head,
				})

				local arrow = new("TextLabel", {
					Size                   = UDim2.new(0, 18, 1, 0),
					Position               = UDim2.new(1, -22, 0, 0),
					BackgroundTransparency = 1,
					Text                   = "v",
					TextColor3             = Theme.TextDim,
					TextSize               = 12,
					Font                   = Theme.FontBold,
					Parent                 = head,
				})

				local list = new("Frame", {
					Size             = UDim2.new(1, 0, 0, 0),
					AutomaticSize    = Enum.AutomaticSize.Y,
					BackgroundColor3 = Theme.BackgroundLo,
					BackgroundTransparency = Glass.Popup,
					BorderSizePixel  = 0,
					Visible          = false,
					LayoutOrder      = 2,
					Parent           = container,
				})
				corner(list, 11)
				stroke(list, Theme.Stroke, 1, 0.35)
				new("UIListLayout", {
					Padding   = UDim.new(0, 3),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent    = list,
				})
				new("UIPadding", {
					PaddingTop    = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 5),
					PaddingLeft   = UDim.new(0, 5),
					PaddingRight  = UDim.new(0, 5),
					Parent        = list,
				})

				local optionButtons = {}

				local function setOpen(value)
					open = value
					list.Visible = value
					tween(arrow, { Rotation = value and 180 or 0, TextColor3 = value and Theme.AccentSoft or Theme.TextDim }, 0.22)
					tween(headStroke, { Color = value and Theme.Accent or Theme.Stroke, Transparency = value and 0.08 or 0.4 }, 0.22)
				end

				local function refresh()
					for option, btn in pairs(optionButtons) do
						local active = option == selected
						tween(btn, {
							BackgroundColor3       = Theme.ElementHover,
							BackgroundTransparency = active and 0.18 or 1,
							TextColor3             = active and Theme.AccentSoft or Theme.TextDim,
						}, 0.12)
					end
				end

				local function set(option, fire)
					selected = option
					valueLabel.Text = tostring(option)
					refresh()
					if fire ~= false then
						safeCall(callback, option)
					end
				end

				head.MouseButton1Click:Connect(function()
					setOpen(not open)
				end)

				local function buildOptions(newOptions)
					for _, child in ipairs(list:GetChildren()) do
						if child:IsA("TextButton") then
							child:Destroy()
						end
					end
					optionButtons = {}
					options = newOptions or {}

					for index, option in ipairs(options) do
						local optBtn = new("TextButton", {
							Size                   = UDim2.new(1, 0, 0, isMobile and 34 or 26),
							BackgroundColor3       = Theme.ElementHover,
							BackgroundTransparency = 1,
							AutoButtonColor        = false,
							Text                   = tostring(option),
							TextColor3             = Theme.TextDim,
							TextSize               = 13,
							Font                   = Theme.Font,
							BorderSizePixel        = 0,
							LayoutOrder            = index,
							Parent                 = list,
						})
						corner(optBtn, 8)
						optionButtons[option] = optBtn

						optBtn.MouseEnter:Connect(function()
							if option ~= selected then
								tween(optBtn, { BackgroundTransparency = 0.52, TextColor3 = Theme.Text })
							end
						end)
						optBtn.MouseLeave:Connect(function()
							if option ~= selected then
								tween(optBtn, { BackgroundTransparency = 1, TextColor3 = Theme.TextDim })
							end
						end)
						optBtn.MouseButton1Click:Connect(function()
							set(option)
							setOpen(false)
						end)
					end
				end

				buildOptions(options)
				set(selected, false)
				addRestyler(function() refresh() end)

				register({
					Type = "dropdown", Name = text, Instance = container, Flag = flag,
					Get = function() return selected end,
					Set = function(option) set(option) end,
				})

				return {
					Set = function(_, option) set(option) end,
					Get = function() return selected end,

					SetOptions = function(_, newOptions, keepSelection)
						buildOptions(newOptions)
						if keepSelection and optionButtons[selected] then
							set(selected, false)
						else
							set(newOptions and newOptions[1] or "—", false)
						end
					end,
					GetOptions = function() return options end,
				}
			end

			function Section:AddMultiDropdown(text, options, defaults, callback, flag)
				options = options or {}
				local chosen = {}
				for _, option in ipairs(defaults or {}) do
					chosen[option] = true
				end
				local open = false

				local container = new("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Parent = holder,
				})
				new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = container })

				local head = new("TextButton", {
					Size = UDim2.new(1, 0, 0, isMobile and 44 or 34),
					BackgroundColor3 = Theme.Element,
					BackgroundTransparency = Glass.Element,
					AutoButtonColor = false,
					Text = "",
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Parent = container,
				})
				corner(head, 7)
				local headStroke = stroke(head, Theme.Stroke, 1, 0.4)
				hoverable(head, headStroke)
				rowLabel(head, text, isMobile and 102 or 150)

				local valueLabel = new("TextLabel", {
					Size = UDim2.new(0, isMobile and 72 or 120, 1, 0),
					Position = UDim2.new(1, isMobile and -94 or -142, 0, 0),
					BackgroundTransparency = 1,
					Text = "—",
					TextColor3 = Theme.Accent,
					TextSize = 13,
					Font = Theme.Font,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = head,
				})
				local arrow = new("TextLabel", {
					Size = UDim2.new(0, 18, 1, 0),
					Position = UDim2.new(1, -22, 0, 0),
					BackgroundTransparency = 1,
					Text = "v",
					TextColor3 = Theme.TextDim,
					TextSize = 12,
					Font = Theme.FontBold,
					Parent = head,
				})

				local list = new("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Theme.BackgroundLo,
					BackgroundTransparency = Glass.Popup,
					BorderSizePixel = 0,
					Visible = false,
					LayoutOrder = 2,
					Parent = container,
				})
				corner(list, 11)
				stroke(list, Theme.Stroke, 1, 0.35)
				new("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })
				new("UIPadding", {
					PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5),
					PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), Parent = list,
				})

				local marks = {}

				local function selectedList()
					local result = {}
					for _, option in ipairs(options) do
						if chosen[option] then table.insert(result, option) end
					end
					return result
				end

				local function refresh(fire)
					local list2 = selectedList()
					valueLabel.Text = #list2 > 0 and table.concat(list2, ", ") or "—"
					for option, entry in pairs(marks) do
						local active = chosen[option] and true or false
						tween(entry.Mark, { BackgroundTransparency = active and 0 or 1 }, 0.12)
						setGlow(entry.Glow, active)
					end
					if fire ~= false then safeCall(callback, list2) end
				end

				local function buildOptions(newOptions, keepSelection)
					local old = chosen
					options = newOptions or {}
					chosen = {}
					if keepSelection then
						for _, option in ipairs(options) do
							if old[option] then chosen[option] = true end
						end
					end

					for _, child in ipairs(list:GetChildren()) do
						if child:IsA("TextButton") then child:Destroy() end
					end
					marks = {}

					for index, option in ipairs(options) do
						local optBtn = new("TextButton", {
							Size = UDim2.new(1, 0, 0, isMobile and 34 or 26),
							BackgroundTransparency = 1,
							AutoButtonColor = false,
							Text = "",
							BorderSizePixel = 0,
							LayoutOrder = index,
							Parent = list,
						})
						local box = new("Frame", {
							Size = UDim2.fromOffset(14, 14),
							Position = UDim2.new(0, 4, 0.5, -7),
							BackgroundColor3 = Theme.Element,
							BorderSizePixel = 0,
							Parent = optBtn,
						})
						corner(box, 4)
						stroke(box, Theme.Stroke, 1, 0.3)
						local mark = new("Frame", {
							Size = UDim2.fromOffset(8, 8),
							Position = UDim2.new(0.5, -4, 0.5, -4),
							BackgroundColor3 = Theme.Accent,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Parent = box,
						})
						corner(mark, 2)
						local markGlow = addGlow(mark, Theme.Accent, 2, 2)
						setGlow(markGlow, false)
						marks[option] = { Mark = mark, Glow = markGlow }

						new("TextLabel", {
							Size = UDim2.new(1, -26, 1, 0),
							Position = UDim2.new(0, 24, 0, 0),
							BackgroundTransparency = 1,
							Text = tostring(option),
							TextColor3 = Theme.TextDim,
							TextSize = 13,
							Font = Theme.Font,
							TextXAlignment = Enum.TextXAlignment.Left,
							Parent = optBtn,
						})

						optBtn.MouseButton1Click:Connect(function()
							chosen[option] = not chosen[option]
							refresh()
						end)
					end
					refresh(false)
				end

				head.MouseButton1Click:Connect(function()
					open = not open
					list.Visible = open
					arrow.Text = open and "^" or "v"
				end)

				buildOptions(options, true)

				register({
					Type = "multidropdown", Name = text, Instance = container, Flag = flag,
					Get = function() return selectedList() end,
					Set = function(values)
						chosen = {}
						for _, option in ipairs(values or {}) do chosen[option] = true end
						refresh()
					end,
				})

				return {
					Set = function(_, values)
						chosen = {}
						for _, option in ipairs(values or {}) do chosen[option] = true end
						refresh()
					end,
					Get = function() return selectedList() end,
					SetOptions = function(_, newOptions, keepSelection)
						buildOptions(newOptions, keepSelection ~= false)
					end,
					GetOptions = function() return options end,
				}
			end

			function Section:AddTextbox(text, default, placeholder, callback, flag)
				local value = default or ""
				local placeholderText, placeholderKey = resolveText(placeholder or "")
				local row, rowStroke = baseRow(34, false)
				hoverable(row, rowStroke)
				rowLabel(row, text, isMobile and 112 or 160)

				local box = new("TextBox", {
					Size              = UDim2.new(0, isMobile and 92 or 140, 0, isMobile and 28 or 24),
					Position          = UDim2.new(1, isMobile and -104 or -152, 0.5, isMobile and -14 or -12),
					BackgroundColor3  = Theme.BackgroundLo,
					Text              = value,
					PlaceholderText   = placeholderText,
					PlaceholderColor3 = Theme.TextDim,
					TextColor3        = Theme.Text,
					TextSize          = 13,
					Font              = Theme.Font,
					ClearTextOnFocus  = false,
					BorderSizePixel   = 0,
					Parent            = row,
				})
				corner(box, 8)
				bindText(box, "PlaceholderText", placeholderKey)
				local boxStroke = stroke(box, Theme.Stroke, 1, 0.3)
				new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = box })

				box.Focused:Connect(function()
					tween(boxStroke, { Color = Theme.Accent, Transparency = 0 })
				end)

				box.FocusLost:Connect(function(enterPressed)
					tween(boxStroke, { Color = Theme.Stroke, Transparency = 0.3 })
					value = box.Text
					safeCall(callback, value, enterPressed)
				end)

				register({
					Type = "textbox", Name = text, Instance = row, Flag = flag,
					Get = function() return value end,
					Set = function(newValue)
						value = tostring(newValue or "")
						box.Text = value
						safeCall(callback, value, false)
					end,
				})

				return {
					Set = function(_, newValue)
						value = tostring(newValue or "")
						box.Text = value
						safeCall(callback, value, false)
					end,
					Get = function() return value end,
				}
			end

			function Section:AddKeybind(text, defaultKey, callback, flag)
				local key = defaultKey
				local listening = false

				local row, rowStroke = baseRow(34, false)
				hoverable(row, rowStroke)
				rowLabel(row, text, isMobile and 106 or 130)

				local button = new("TextButton", {
					Size             = UDim2.new(0, isMobile and 82 or 110, 0, isMobile and 28 or 24),
					Position         = UDim2.new(1, isMobile and -94 or -122, 0.5, isMobile and -14 or -12),
					BackgroundColor3 = Theme.BackgroundLo,
					AutoButtonColor  = false,
					Text             = key and key.Name or translate("ui.none"),
					TextColor3       = Theme.Accent,
					TextSize         = 13,
					Font             = Theme.FontBold,
					BorderSizePixel  = 0,
					Parent           = row,
				})
				corner(button, 8)
				local btnStroke = stroke(button, Theme.Stroke, 1, 0.3)

				local function setKey(newKey, fire)
					key = newKey
					button.Text = key and key.Name or translate("ui.none")
					if fire ~= false then
						safeCall(callback, key)
					end
				end

				button.MouseButton1Click:Connect(function()
					listening = true
					button.Text = translate("ui.listening")
					tween(btnStroke, { Color = Theme.Accent, Transparency = 0 })
				end)

				track(UserInputService.InputBegan:Connect(function(input, processed)
					if listening then

						if UserInputService:GetFocusedTextBox() then return end
						if input.UserInputType == Enum.UserInputType.Keyboard then
							listening = false
							tween(btnStroke, { Color = Theme.Stroke, Transparency = 0.3 })
							if input.KeyCode == Enum.KeyCode.Backspace then
								setKey(nil)
							else
								setKey(input.KeyCode)
							end
						end
						return
					end

					if processed or not key then return end
					if input.KeyCode == key then
						safeCall(callback, key, true)
					end
				end))

				register({
					Type = "keybind", Name = text, Instance = row, Flag = flag,
					Get = function() return key end,
					Set = function(newKey) setKey(newKey) end,
				})

				return {
					Set = function(_, newKey) setKey(newKey) end,
					Get = function() return key end,
				}
			end

			function Section:AddColorpicker(text, defaultColor, callback, flag)
				local color = defaultColor or Color3.fromRGB(255, 255, 255)
				local h, s, v = Color3.toHSV(color)
				local open = false

				local container = new("Frame", {
					Size                   = UDim2.new(1, 0, 0, 0),
					AutomaticSize          = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Parent                 = holder,
				})
				new("UIListLayout", {
					Padding   = UDim.new(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent    = container,
				})

				local head = new("TextButton", {
					Size             = UDim2.new(1, 0, 0, isMobile and 40 or 34),
					BackgroundColor3 = Theme.Element,
					AutoButtonColor  = false,
					Text             = "",
					BorderSizePixel  = 0,
					LayoutOrder      = 1,
					Parent           = container,
				})
				corner(head, 7)
				local headStroke = stroke(head, Theme.Stroke, 1, 0.4)
				hoverable(head, headStroke)
				rowLabel(head, text, 60)

				local swatch = new("Frame", {
					Size             = UDim2.fromOffset(34, 20),
					Position         = UDim2.new(1, -46, 0.5, -10),
					BackgroundColor3 = color,
					BorderSizePixel  = 0,
					Parent           = head,
				})
				corner(swatch, 5)
				stroke(swatch, Theme.Stroke, 1, 0.2)
				local swatchGlow = addGlow(swatch, color, 2, 5)

				local panel = new("Frame", {
					Size             = UDim2.new(1, 0, 0, 136),
					BackgroundColor3 = Theme.BackgroundLo,
					BorderSizePixel  = 0,
					Visible          = false,
					LayoutOrder      = 2,
					Parent           = container,
				})
				corner(panel, 7)
				stroke(panel, Theme.Stroke, 1, 0.4)

				local sv = new("Frame", {
					Size             = UDim2.new(1, -46, 0, 112),
					Position         = UDim2.new(0, 10, 0, 12),
					BackgroundColor3 = Color3.fromHSV(h, 1, 1),
					BorderSizePixel  = 0,
					ClipsDescendants = false,
					Parent           = panel,
				})
				corner(sv, 5)

				local whiteLayer = new("Frame", {
					Size             = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel  = 0,
					ZIndex           = 2,
					Parent           = sv,
				})
				corner(whiteLayer, 5)
				new("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1),
					}),
					Parent = whiteLayer,
				})

				local blackLayer = new("Frame", {
					Size             = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel  = 0,
					ZIndex           = 3,
					Parent           = sv,
				})
				corner(blackLayer, 5)
				new("UIGradient", {
					Rotation     = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0),
					}),
					Parent = blackLayer,
				})

				local cursor = new("Frame", {
					Size                   = UDim2.fromOffset(10, 10),
					BackgroundTransparency = 1,
					ZIndex                 = 4,
					Parent                 = sv,
				})
				stroke(cursor, Color3.fromRGB(255, 255, 255), 2, 0)
				corner(cursor, 5)

				local hue = new("Frame", {
					Size             = UDim2.fromOffset(18, 112),
					Position         = UDim2.new(1, -28, 0, 12),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel  = 0,
					Parent           = panel,
				})
				corner(hue, 5)
				new("UIGradient", {
					Rotation = 90,
					Color    = ColorSequence.new({
						ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
						ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
						ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
						ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
						ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
						ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
						ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
					}),
					Parent = hue,
				})

				local hueCursor = new("Frame", {
					Size             = UDim2.new(1, 4, 0, 3),
					Position         = UDim2.new(0, -2, 0, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel  = 0,
					ZIndex           = 3,
					Parent           = hue,
				})
				corner(hueCursor, 2)

				local function apply(fire)
					color = Color3.fromHSV(h, s, v)
					swatch.BackgroundColor3 = color
					sv.BackgroundColor3     = Color3.fromHSV(h, 1, 1)
					cursor.Position         = UDim2.new(s, -5, 1 - v, -5)
					hueCursor.Position      = UDim2.new(0, -2, h, -1)
					for _, layer in ipairs(swatchGlow) do
						layer.BackgroundColor3 = color
					end
					if fire ~= false then
						safeCall(callback, color)
					end
				end

				head.MouseButton1Click:Connect(function()
					open = not open
					panel.Visible = open
				end)

				local dragSV, dragHue = false, false

				local svHit = new("TextButton", {
					Size                   = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					AutoButtonColor        = false,
					Text                   = "",
					ZIndex                 = 5,
					Parent                 = sv,
				})

				local hueHit = new("TextButton", {
					Size                   = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					AutoButtonColor        = false,
					Text                   = "",
					ZIndex                 = 5,
					Parent                 = hue,
				})

				local function updateSV(input)
					local pos  = sv.AbsolutePosition
					local size = sv.AbsoluteSize
					s = math.clamp((input.Position.X - pos.X) / math.max(size.X, 1), 0, 1)
					v = 1 - math.clamp((input.Position.Y - pos.Y) / math.max(size.Y, 1), 0, 1)
					apply()
				end

				local function updateHue(input)
					local pos  = hue.AbsolutePosition
					local size = hue.AbsoluteSize
					h = math.clamp((input.Position.Y - pos.Y) / math.max(size.Y, 1), 0, 1)
					apply()
				end

				svHit.InputBegan:Connect(function(input)
					if isPressInput(input) then
						dragSV = true
						updateSV(input)
					end
				end)

				hueHit.InputBegan:Connect(function(input)
					if isPressInput(input) then
						dragHue = true
						updateHue(input)
					end
				end)

				track(UserInputService.InputChanged:Connect(function(input)
					if not isMoveInput(input) then return end
					if dragSV then updateSV(input) end
					if dragHue then updateHue(input) end
				end))

				track(UserInputService.InputEnded:Connect(function(input)
					if isPressInput(input) then
						dragSV  = false
						dragHue = false
					end
				end))

				apply(false)

				register({
					Type = "colorpicker", Name = text, Instance = container, Flag = flag,
					Get = function() return color end,
					Set = function(newColor)
						h, s, v = Color3.toHSV(newColor)
						apply()
					end,
				})

				return {
					Set = function(_, newColor)
						h, s, v = Color3.toHSV(newColor)
						apply()
					end,
					Get = function() return color end,
				}
			end

			return Section
		end

		table.insert(Window.Tabs, Tab)
		if #Window.Tabs == 1 then
			select()
		end

		return Tab
	end

	local memoryConfigs = {}
	local persistedConfigs = {}

	local function filesAvailable()
		return type(writefile) == "function"
			and type(readfile) == "function"
			and type(isfile) == "function"
	end

	local function sanitizeName(name)
		name = string.gsub(tostring(name or ""), '[%./\\:%*%?"<>|]', "")
		name = string.gsub(name, "^%s+", "")
		name = string.gsub(name, "%s+$", "")
		if name == "" then
			name = "default"
		end
		return name
	end

	local function configPath(name)
		return folder .. "/" .. name .. ".json"
	end

	local function serialize(value)
		local kind = typeof(value)
		if kind == "Color3" then
			return { __type = "Color3", R = value.R, G = value.G, B = value.B }
		elseif kind == "EnumItem" then
			return { __type = "EnumItem", Enum = string.match(tostring(value.EnumType), "^Enum%.(.+)$") or tostring(value.EnumType), Name = value.Name }
		elseif kind == "table" then
			local total, arrayCount = 0, 0
			for key in pairs(value) do
				total = total + 1
				if type(key) == "number" and key >= 1 and key % 1 == 0 then arrayCount = arrayCount + 1 end
			end
			if total == arrayCount and arrayCount == #value then
				local list = {}
				for index, item in ipairs(value) do list[index] = serialize(item) end
				return { __type = "list", Values = list }
			end
			local map = {}
			for key, item in pairs(value) do map[tostring(key)] = serialize(item) end
			return { __type = "map", Values = map }
		end
		return value
	end

	local function deserialize(value)
		if type(value) == "table" then
			if value.__type == "Color3" then
				return Color3.new(value.R, value.G, value.B)
			elseif value.__type == "EnumItem" then
				local ok, result = pcall(function()
					local enumName = string.match(tostring(value.Enum), "^Enum%.(.+)$") or tostring(value.Enum)
				return Enum[enumName][value.Name]
				end)
				if ok then
					return result
				end
				return nil
			elseif value.__type == "list" then
				local list = {}
				for index, item in ipairs(value.Values or {}) do
					list[index] = deserialize(item)
				end
				return list
			elseif value.__type == "map" then
				local map = {}
				for key, item in pairs(value.Values or {}) do map[key] = deserialize(item) end
				return map
			end
		end
		return value
	end

	function Window:IsPersistent()
		return filesAvailable()
	end

	function Window:GetConfig()
		local data = {}
		for _, entry in ipairs(Window.Registry) do
			if entry.Flag and entry.Get then
				data[entry.Flag] = serialize(entry.Get())
			end

			if entry.Flag and entry.GetBind then
				local key = entry.GetBind()

				data[entry.Flag .. "__bind"] = key and serialize(key) or false
			end
		end
		local environment = (getgenv and getgenv()) or _G
		local skinConfig = environment.TikiSavedSkinConfig
		if type(environment.TikiSkinChangerGetConfig) == "function" then
			local ok, current = pcall(environment.TikiSkinChangerGetConfig)
			if ok and type(current) == "table" then skinConfig = current end
		end
		if type(skinConfig) == "table" then
			data.__Tiki_skin_changer = serialize(skinConfig)
		end
		return data
	end

	function Window:SaveConfig(name)
		name = sanitizeName(name)

		local ok, encoded = pcall(function()
			return HttpService:JSONEncode(Window:GetConfig())
		end)
		if not ok then
			warn("[SimpleUI] failed to encode config: " .. tostring(encoded))
			return false
		end

		if filesAvailable() then
			if persistedConfigs[name] == encoded then
				local stillExists = false
				pcall(function()
					stillExists = isfile(configPath(name))
				end)
				if stillExists then
					return true
				end
			end
			if type(makefolder) == "function" and type(isfolder) == "function" then
				if not isfolder(folder) then
					pcall(makefolder, folder)
				end
			end
			if pcall(writefile, configPath(name), encoded) then
				persistedConfigs[name] = encoded
				return true
			end

			memoryConfigs[name] = encoded
			return false
		end

		memoryConfigs[name] = encoded
		persistedConfigs[name] = encoded
		return true
	end

	function Window:LoadConfig(name)
		name = sanitizeName(name)
		local encoded = memoryConfigs[name]

		if filesAvailable() then
			local exists = false
			pcall(function()
				exists = isfile(configPath(name))
			end)
			if exists then
				local ok, contents = pcall(readfile, configPath(name))
				if ok then
					encoded = contents
				end
			end
		end

		if not encoded then
			return false
		end

		local ok, data = pcall(function()
			return HttpService:JSONDecode(encoded)
		end)
		if not ok or type(data) ~= "table" then
			return false
		end

		for _, entry in ipairs(Window.Registry) do
			if entry.Flag and entry.Set and data[entry.Flag] ~= nil then
				local value = deserialize(data[entry.Flag])
				if value ~= nil then
					safeCall(entry.Set, value)
				end
			end
			if entry.Flag and entry.SetBind then
				local stored = data[entry.Flag .. "__bind"]
				if stored == false then
					safeCall(entry.SetBind, nil)
				elseif stored ~= nil then
					safeCall(entry.SetBind, deserialize(stored))
				end
			end
		end

		local storedSkinConfig = data.__Tiki_skin_changer and deserialize(data.__Tiki_skin_changer) or nil
		if type(storedSkinConfig) == "table" then
			local environment = (getgenv and getgenv()) or _G
			environment.TikiSavedSkinConfig = storedSkinConfig
			if type(environment.TikiSkinChangerApplyConfig) == "function" then
				task.defer(environment.TikiSkinChangerApplyConfig, storedSkinConfig)
			elseif Library.SkinSpawner and type(Library.SkinSpawner.Open) == "function" then
				-- Initialize the cosmetic engine without flashing its catalogue window.
				task.spawn(function()
					environment.TikiSkinChangerStartHidden = true
					-- Open's initializer consumes TikiSavedSkinConfig once.
					-- Applying it again here raced the deferred bootstrap and equipped twice.
					local opened, openError = pcall(Library.SkinSpawner.Open)
					if not opened then warn("[TikiSkin][CONFIG_OPEN_ERROR] " .. tostring(openError)) end
					environment.TikiSkinChangerStartHidden = nil
				end)
			end
		end
		return true
	end

	function Window:ListConfigs()
		local names = {}
		local seen  = {}

		local function add(name)
			if name and not seen[name] then
				seen[name] = true
				table.insert(names, name)
			end
		end

		for name in pairs(memoryConfigs) do
			add(name)
		end

		if filesAvailable() and type(listfiles) == "function" then
			pcall(function()
				for _, path in ipairs(listfiles(folder)) do
					add(string.match(path, "([^/\\]+)%.json$"))
				end
			end)
		end

		table.sort(names)
		return names
	end

	table.insert(Library.Windows, Window)
	return Window
end

--======================================================================--

--======================================================================--

Library.Sounds       = Sounds
Library.CurrentTheme = "Emerald"

function Library:GetThemes()
	local names = {}
	for name in pairs(Themes) do
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

function Library:SetTheme(name)
	local preset = type(name) == "table" and name or Themes[name]
	if not preset then
		return false
	end

	for key, value in pairs(preset) do
		Theme[key] = value
	end
	rebuildColorIndex()

	local info = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	for index = #themeBindings, 1, -1 do
		local bind = themeBindings[index]
		local inst = bind.Instance
		if not inst or not inst.Parent then
			table.remove(themeBindings, index)
		else
			local color = Theme[bind.Key]
			if color then
				TweenService:Create(inst, info, { [bind.Property] = color }):Play()
			end
		end
	end

	for index = #gradientBindings, 1, -1 do
		local bind = gradientBindings[index]
		local inst = bind.Instance
		if not inst or not inst.Parent then
			table.remove(gradientBindings, index)
		else
			inst.Color = ColorSequence.new(Theme[bind.Keys[1]], Theme[bind.Keys[2]])
		end
	end

	task.delay(0.3, function()
		for index = #restylers, 1, -1 do
			if not pcall(restylers[index]) then
				table.remove(restylers, index)
			end
		end
	end)

	if type(name) == "string" then
		Library.CurrentTheme = name
	end
	local sharedEnvironment = (getgenv and getgenv()) or _G
	sharedEnvironment.TikiHubTheme = Theme
	if type(sharedEnvironment.TikiSpawnerApplyTheme) == "function" then
		pcall(sharedEnvironment.TikiSpawnerApplyTheme)
	end
	return true
end

function Library:GetLocales()
	local codes = {}
	for code in pairs(Locales) do
		table.insert(codes, code)
	end
	table.sort(codes)
	return codes
end

function Library:GetLocale()
	return currentLocale
end

function Library:SetLocale(code)
	if not Locales[code] then
		return false
	end

	currentLocale = code

	for index = #textBindings, 1, -1 do
		local bind = textBindings[index]
		local inst = bind.Instance
		if not inst or not inst.Parent then
			table.remove(textBindings, index)
		else
			inst[bind.Property] = translate(bind.Key)
		end
	end

	for _, window in ipairs(Library.Windows) do
		for _, entry in ipairs(window.Registry) do
			if entry.NameKey then
				entry.Name = translate(entry.NameKey)
			end
		end
	end

	return true
end

function Library:T(key)
	return translate(key)
end

function Library:PlaySound(name)
	playSound(name)
end

--======================================================================--

--======================================================================--

function Library:CreateLoader(config)
	config = config or {}
	local loaderProfile = getDeviceProfile()
	local loaderViewport = viewportSize()

	local title    = config.Title    or translate("loader.title")
	local subtitle = config.Subtitle or "v4"

	local gui = new("ScreenGui", {
		Name           = "SimpleUI_Loader",
		ResetOnSpawn   = false,
		IgnoreGuiInset = true,
		DisplayOrder   = 2000,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent         = PlayerGui,
	})

	local backdrop = new("Frame", {
		Size                   = UDim2.fromScale(1, 1),
		BackgroundColor3       = Theme.BackgroundLo,
		BackgroundTransparency = 1,
		BorderSizePixel        = 0,
		Parent                 = gui,
	})

	local card = new("Frame", {
		Size             = UDim2.fromOffset(math.min(400, math.max(loaderViewport.X - 24, 260)), 190),
		Position         = UDim2.fromScale(0.5, 0.5),
		AnchorPoint      = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel  = 0,
		Parent           = gui,
	})
	corner(card, 20)
	stroke(card, Theme.Stroke, 1, 0.2)
	addShadow(card, 5, 24, 0.9)
	addSheen(card, 0.93)
	new("UIGradient", {
		Rotation = 90,
		Color    = ColorSequence.new(Theme.Background, Theme.BackgroundLo),
		Parent   = card,
	})

	local scale = new("UIScale", { Scale = 0.82, Parent = card })
	createLogo(card, 32, UDim2.fromOffset(20, 32), true)

	local topLine = new("Frame", {
		Size             = UDim2.new(1, -40, 0, 2),
		Position         = UDim2.new(0, 20, 0, 0),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel  = 0,
		Parent           = card,
	})
	corner(topLine, 1)
	new("UIGradient", {
		Color        = ColorSequence.new(Theme.AccentSoft, Theme.Accent),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = topLine,
	})

	new("TextLabel", {
		Size                   = UDim2.new(1, -84, 0, 30),
		Position               = UDim2.new(0, 64, 0, 32),
		BackgroundTransparency = 1,
		Text                   = title,
		TextColor3             = Theme.Text,
		TextSize               = loaderProfile.Compact and 23 or 26,
		Font                   = Theme.FontBold,
		TextXAlignment         = Enum.TextXAlignment.Left,
		Parent                 = card,
	})

	new("TextLabel", {
		Size                   = UDim2.new(1, -84, 0, 16),
		Position               = UDim2.new(0, 64, 0, 62),
		BackgroundTransparency = 1,
		Text                   = subtitle,
		TextColor3             = Theme.TextDim,
		TextSize               = 13,
		Font                   = Theme.Font,
		TextXAlignment         = Enum.TextXAlignment.Left,
		Parent                 = card,
	})

	local statusLabel = new("TextLabel", {
		Size                   = UDim2.new(1, -80, 0, 16),
		Position               = UDim2.new(0, 20, 0, 112),
		BackgroundTransparency = 1,
		Text                   = translate("loader.boot"),
		TextColor3             = Theme.TextDim,
		TextSize               = 13,
		Font                   = Theme.Font,
		TextXAlignment         = Enum.TextXAlignment.Left,
		Parent                 = card,
	})

	local percentLabel = new("TextLabel", {
		Size                   = UDim2.new(0, 50, 0, 16),
		Position               = UDim2.new(1, -70, 0, 112),
		BackgroundTransparency = 1,
		Text                   = "0%",
		TextColor3             = Theme.Accent,
		TextSize               = 13,
		Font                   = Theme.FontBold,
		TextXAlignment         = Enum.TextXAlignment.Right,
		Parent                 = card,
	})

	local track = new("Frame", {
		Size             = UDim2.new(1, -40, 0, 6),
		Position         = UDim2.new(0, 20, 0, 140),
		BackgroundColor3 = Theme.BackgroundLo,
		BorderSizePixel  = 0,
		Parent           = card,
	})
	corner(track, 3)

	local fill = new("Frame", {
		Size             = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel  = 0,
		Parent           = track,
	})
	corner(fill, 3)
	new("UIGradient", {
		Color  = ColorSequence.new(Theme.AccentSoft, Theme.Accent),
		Parent = fill,
	})
	addGlowInside(fill, Theme.Accent, 2, 3)

	local shine = new("Frame", {
		Size                   = UDim2.new(0, 60, 1, 0),
		BackgroundColor3       = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.55,
		BorderSizePixel        = 0,
		ZIndex                 = 3,
		Parent                 = fill,
	})
	new("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0.2),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = shine,
	})

	local dots = {}
	for index = 1, 3 do
		local dot = new("Frame", {
			Size             = UDim2.fromOffset(6, 6),
			Position         = UDim2.new(1, -70 + (index - 1) * 12, 0, 64),
			BackgroundColor3 = Theme.Accent,
			BorderSizePixel  = 0,
			Parent           = card,
		})
		corner(dot, 3)
		table.insert(dots, dot)
	end

	local Loader = {}
	Loader.Gui     = gui
	Loader.Running = true

	tween(backdrop, { BackgroundTransparency = 0.15 }, 0.5, Enum.EasingStyle.Sine)
	spring(scale, { Scale = 1 }, 0.6)

	task.spawn(function()
		local phase = 0
		while Loader.Running and gui.Parent do
			phase = phase + 1
			for index, dot in ipairs(dots) do
				local active = ((phase + index) % 3) == 0
				tween(dot, { BackgroundTransparency = active and 0 or 0.75 }, 0.2)
			end
			task.wait(0.32)
		end
	end)

	if loaderProfile.LowPower then
		shine.Visible = false
	else
		task.spawn(function()
			while Loader.Running and gui.Parent do
				shine.Position = UDim2.new(0, -60, 0, 0)
				tween(shine, { Position = UDim2.new(1, 10, 0, 0) }, 1.1, Enum.EasingStyle.Linear)
				task.wait(1.35)
			end
		end)
	end

	function Loader:Set(alpha, text)
		alpha = math.clamp(alpha, 0, 1)
		tween(fill, { Size = UDim2.new(alpha, 0, 1, 0) }, 0.35)
		percentLabel.Text = string.format("%d%%", math.floor(alpha * 100 + 0.5))
		if text then
			statusLabel.Text = text
		end
	end

	function Loader:Finish(callback)
		Loader.Running = false
		Loader:Set(1, translate("loader.ready"))
		playSound("Open")
		if callback then
			local callbackOk, callbackError = pcall(callback)
			if not callbackOk then
				local message = tostring(callbackError)
				statusLabel.Text = "Startup failed: " .. string.sub(message, 1, 120)
				statusLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
				percentLabel.Text = "ERROR"
				warn("[TikiHub] interface startup failed: " .. message)
				return false
			end
		end

		task.delay(0.45, function()
			tween(scale, { Scale = 1.06 }, 0.25)
			tween(card, { BackgroundTransparency = 1 }, 0.3)
			tween(backdrop, { BackgroundTransparency = 1 }, 0.35)
			for _, child in ipairs(card:GetDescendants()) do
				if child:IsA("TextLabel") then
					tween(child, { TextTransparency = 1 }, 0.25)
				elseif child:IsA("Frame") then
					tween(child, { BackgroundTransparency = 1 }, 0.25)
				elseif child:IsA("UIStroke") then
					tween(child, { Transparency = 1 }, 0.25)
				end
			end

			task.delay(0.45, function()
				gui:Destroy()
			end)
		end)
		return true
	end

	function Loader:Run(steps, callback)
		steps = steps or {
			{ Text = translate("loader.boot"),     Time = 0.35 },
			{ Text = translate("loader.theme"),    Time = 0.3 },
			{ Text = translate("loader.elements"), Time = 0.45 },
			{ Text = translate("loader.visuals"),  Time = 0.35 },
		}

		task.spawn(function()
			for index, step in ipairs(steps) do
				Loader:Set(index / (#steps + 1), step.Text)
				task.wait(step.Time or 0.3)
			end
			Loader:Finish(callback)
		end)
	end

	return Loader
end

--======================================================================--

--======================================================================--

function Library:CreateFloatingButton(config)
	config = config or {}
	local floaterProfile = getDeviceProfile()

	local style    = config.Style or "circle"      -- "circle" | "pill"
	local text     = config.Text or (style == "circle" and "S" or "MENU")
	local callback = config.Callback
	local isPill   = style == "pill"

	local width  = config.Width  or (isPill and 132 or 54)
	local height = config.Height or (isPill and 42 or 54)
	if floaterProfile.Touch then
		width = math.max(width, isPill and 104 or 54)
		height = math.max(height, isPill and 44 or 54)
	end

	local gui = new("ScreenGui", {
		Name           = "SimpleUI_FloatingButton",
		ResetOnSpawn   = false,
		IgnoreGuiInset = true,
		DisplayOrder   = 1500,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent         = PlayerGui,
	})

	local viewport = viewportSize()
	local button = new("TextButton", {
		Size                   = UDim2.fromOffset(width, height),
		Position               = config.Position or UDim2.fromOffset(30, math.floor(viewport.Y / 2)),
		BackgroundColor3       = Theme.Panel,
		BackgroundTransparency = 0.45,
		AutoButtonColor        = false,
		Text                   = "",
		ClipsDescendants       = true,
		Parent                 = gui,
	})
	corner(button, isPill and 21 or 27)

	local ring = stroke(button, Theme.Accent, 1.5, 0.15)
	addNeonSnake(button, floaterProfile.LowPower and 1.15 or 1.65, 360, floaterProfile.LowPower and 4.4 or 2.5)
	addSheen(button, 0.9)

	local ringTween

	local glow = addGlowInside(button, Theme.Accent, 3, isPill and 21 or 27)
	for _, layer in ipairs(glow) do
		layer.BackgroundTransparency = math.min(layer.BackgroundTransparency + 0.12, 1)
	end

	local scale = new("UIScale", { Scale = 1, Parent = button })

	local label = new("TextLabel", {
		Size                   = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text                   = isPill and text or "",
		TextColor3             = Theme.Text,
		TextSize               = isPill and 14 or 18,
		Font                   = Theme.FontBold,
		ZIndex                 = 3,
		Parent                 = button,
	})
	if not isPill then
		local logoSize = math.floor(math.min(width, height) * 0.58)
		createLogo(button, logoSize, UDim2.new(0.5, -logoSize / 2, 0.5, -logoSize / 2), true)
	end

	button.MouseEnter:Connect(function()
		spring(scale, { Scale = 1.09 }, 0.32)
		tween(ring, { Transparency = 0 }, 0.16)
		tween(button, { BackgroundTransparency = 0.25 }, 0.16)
	end)

	button.MouseLeave:Connect(function()
		tween(scale, { Scale = 1 }, 0.3)
		tween(ring, { Transparency = 0.15 }, 0.16)
		tween(button, { BackgroundTransparency = 0.45 }, 0.16)
	end)

	-- drag with a threshold: a short tap counts as a click, not a move.
	-- dragging is skipped while this button (or all buttons globally) is locked.
	local dragging, moved = false, false
	local dragStart, startPos
	local locked = false

	button.InputBegan:Connect(function(input)
		if isPressInput(input) and not locked and not Library.FloatersLocked then
			dragging  = true
			moved     = false
			dragStart = input.Position
			startPos  = button.Position
		end
	end)

	local moveConn = UserInputService.InputChanged:Connect(function(input)
		if not dragging or not dragStart or not isMoveInput(input) then
			return
		end

		local delta = input.Position - dragStart
		if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
			moved = true
		end

		local screen = viewportSize()
		button.Position = UDim2.new(
			startPos.X.Scale, math.clamp(startPos.X.Offset + delta.X, 0, math.max(screen.X - width, 0)),
			startPos.Y.Scale, math.clamp(startPos.Y.Offset + delta.Y, 0, math.max(screen.Y - height, 0))
		)
	end)

	local endConn = UserInputService.InputEnded:Connect(function(input)
		if isPressInput(input) then
			dragging = false
		end
	end)

	local viewportConn
	local camera = workspace.CurrentCamera
	if camera then
		viewportConn = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			local screen = viewportSize()
			button.Position = UDim2.new(
				button.Position.X.Scale, math.clamp(button.Position.X.Offset, 0, math.max(screen.X - width, 0)),
				button.Position.Y.Scale, math.clamp(button.Position.Y.Offset, 0, math.max(screen.Y - height, 0))
			)
		end)
	end

	button.MouseButton1Click:Connect(function()
		if moved then
			moved = false
			return
		end

		rippleAt(button, Theme.Accent)

		playSound("Click")
		if callback then
			safeCall(callback)
		end
	end)

	local Button = {}
	Button.Gui      = gui
	Button.Instance = button
	table.insert(Library.Floaters, Button)

	function Button:SetText(newText)
		label.Text = newText
	end

	function Button:SetVisible(state)
		gui.Enabled = state and true or false
	end

	-- lock/unlock dragging for this specific button
	function Button:SetLocked(state)
		locked = state and true or false
	end

	function Button:Destroy()
		if not gui then return end
		moveConn:Disconnect()
		endConn:Disconnect()
		if viewportConn then viewportConn:Disconnect()
		viewportConn = nil end
		if ringTween then pcall(function() ringTween:Cancel() end)
		ringTween = nil end
		gui:Destroy()
		gui = nil
		Button.Gui = nil
		for index, floater in ipairs(Library.Floaters) do
			if floater == Button then
				table.remove(Library.Floaters, index)
				break
			end
		end
	end

	return Button
end


-- Tiki Hub generic standalone cleanup for the compatibility shell.
local function TikiUIUnload()
	if Library._compatUnloading then return end
	Library._compatUnloading = true

	local floaters = {}
	for _, floater in ipairs(Library.Floaters or {}) do table.insert(floaters, floater) end
	for _, floater in ipairs(floaters) do pcall(function() floater:Destroy() end) end

	local windows = {}
	for _, window in ipairs(Library.Windows or {}) do table.insert(windows, window) end
	for _, window in ipairs(windows) do
		pcall(function()
			if window.Gui and window.Gui.Parent then window:Destroy() end
		end)
	end

	if notifyGui then
		pcall(function() notifyGui:Destroy() end)
		notifyGui, notifyHolder = nil, nil
	end

	runtimeAlive = false
	Library._compatUnloading = false
end

-- ─────────────────────────────────────────────────────────────
-- Theme butterflies: animated wings that follow the current theme
-- ─────────────────────────────────────────────────────────────

Library.ButterflySettings = {
    Enabled = true,
    Count = 12,
    Theme = "Crimson",
}

Library.ButterflyPalette = {
	Crimson  = { Color3.fromRGB(220, 40, 60),  Color3.fromRGB(255, 100, 110) },
    Golden   = { Color3.fromRGB(255, 200, 80),  Color3.fromRGB(255, 235, 155) },
    Midnight = { Color3.fromRGB(145, 104, 255), Color3.fromRGB(67, 216, 255) },
    Obsidian = { Color3.fromRGB(240, 240, 245), Color3.fromRGB(170, 170, 180) },
    Violet   = { Color3.fromRGB(186, 110, 255), Color3.fromRGB(255, 130, 220) },
    Emerald  = { Color3.fromRGB(72, 230, 160),  Color3.fromRGB(150, 255, 190) },
    Crimson  = { Color3.fromRGB(255, 88, 110),  Color3.fromRGB(255, 160, 120) },
    Ocean    = { Color3.fromRGB(70, 190, 255),  Color3.fromRGB(120, 255, 240) },
    Daylight = { Color3.fromRGB(88, 104, 255),  Color3.fromRGB(120, 190, 255) },
}

local __bflyHosts = {}

local function __bflyBuild(parent, palette)
    local holder = new("Frame", {
        Name = "Butterfly",
        Size = UDim2.fromOffset(28, 22),
        BackgroundTransparency = 1,
        Active = false,
        Selectable = false,
        ZIndex = 2,
        Parent = parent,
    })

    local left = new("Frame", {
        Size = UDim2.fromOffset(12, 16),
        Position = UDim2.fromOffset(12, 11),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = palette[1],
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Active = false,
        Selectable = false,
        ZIndex = 2,
        Parent = holder,
    })
    corner(left, 6)
    new("UIGradient", {
        Rotation = 45,
        Color = ColorSequence.new(palette[1], palette[2]),
        Parent = left,
    })

    local right = new("Frame", {
        Size = UDim2.fromOffset(12, 16),
        Position = UDim2.fromOffset(16, 11),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = palette[2],
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Active = false,
        Selectable = false,
        ZIndex = 2,
        Parent = holder,
    })
    corner(right, 6)
    new("UIGradient", {
        Rotation = -45,
        Color = ColorSequence.new(palette[2], palette[1]),
        Parent = right,
    })

    local body = new("Frame", {
        Size = UDim2.fromOffset(2, 10),
        Position = UDim2.fromOffset(13, 6),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Active = false,
        Selectable = false,
        ZIndex = 3,
        Parent = holder,
    })
    corner(body, 1)

    return holder, left, right
end

local function __bflyStart(windowGui, parent)
    if __bflyHosts[windowGui] then
        return __bflyHosts[windowGui]
    end

    local state = {
        Gui = windowGui,
        Parent = parent,
        Active = Library.ButterflySettings.Enabled,
        Butts = {},
    }
    __bflyHosts[windowGui] = state

    if not state.Active then
        return state
    end

    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local palette = Library.ButterflyPalette[Library.ButterflySettings.Theme]
        or Library.ButterflyPalette.Crimson

    for _ = 1, Library.ButterflySettings.Count do
        local holder, lw, rw = __bflyBuild(parent, palette)
        local startX = math.random(40, math.max(60, math.floor(vp.X) - 60))
        local startY = math.random(40, math.max(60, math.floor(vp.Y) - 60))
        local angle = math.random() * math.pi * 2
        local speed = math.random(24, 62)
        local scale = 0.55 + math.random() * 0.65

        new("UIScale", { Scale = scale, Parent = holder })
        holder.Position = UDim2.fromOffset(startX, startY)
        holder.Rotation = math.deg(angle)

        table.insert(state.Butts, {
            Holder = holder,
            Left = lw,
            Right = rw,
            Angle = angle,
            Speed = speed,
            Wobble = math.random() * math.pi * 2,
            Phase = math.random() * math.pi * 2,
        })
    end

    task.spawn(function()
        local last = os.clock()
        while state.Active and state.Gui and state.Gui.Parent do
            local now = os.clock()
            local dt = now - last
            last = now
            local c = workspace.CurrentCamera
            local v2 = c and c.ViewportSize or vp

            for _, b in ipairs(state.Butts) do
                if not b.Holder.Parent then break end

                b.Phase = b.Phase + dt * 2.4
                b.Wobble = b.Wobble + dt * 1.7
                b.Angle = b.Angle + math.sin(b.Wobble) * dt * 1.8

                local x = b.Holder.Position.X.Offset + math.cos(b.Angle) * b.Speed * dt
                local y = b.Holder.Position.Y.Offset + math.sin(b.Angle) * b.Speed * dt

                if x < -40 then x = v2.X + 30 elseif x > v2.X + 40 then x = -30 end
                if y < -40 then y = v2.Y + 30 elseif y > v2.Y + 40 then y = -30 end

                b.Holder.Position = UDim2.fromOffset(math.floor(x), math.floor(y))
                b.Holder.Rotation = math.deg(b.Angle) + math.sin(b.Phase) * 8

                local flap = 0.5 + math.sin(b.Phase * 4) * 0.5
                b.Left.Size = UDim2.fromOffset(math.floor(5 + 11 * flap), 16)
                b.Right.Size = UDim2.fromOffset(math.floor(5 + 11 * flap), 16)
            end

            task.wait(1 / 45)
        end
    end)

    return state
end

local function __bflyClear(windowGui)
    local state = __bflyHosts[windowGui]
    if not state then
        return
    end
    state.Active = false
    for _, b in ipairs(state.Butts) do
        pcall(function() b.Holder:Destroy() end)
    end
    state.Butts = {}
    __bflyHosts[windowGui] = nil
end

local function __bflyRefresh(windowGui, parent)
    __bflyClear(windowGui)
    if Library.ButterflySettings.Enabled then
        __bflyStart(windowGui, parent)
    end
end

function Library:SetButterflies(enabled, themeName)
    if enabled ~= nil then
        Library.ButterflySettings.Enabled = enabled == true
    end
    if themeName and Library.ButterflyPalette[themeName] then
        Library.ButterflySettings.Theme = themeName
    end
    for _, window in ipairs(Library.Windows) do
        if window.Gui and window.Main then
            __bflyRefresh(window.Gui, window.Main)
        end
    end
end

function Library:GetButterflySettings()
    return Library.ButterflySettings
end

function Library:SetButterflyCount(n)
    n = tonumber(n)
    if not n then
        return
    end
    Library.ButterflySettings.Count = math.clamp(math.floor(n), 1, 40)
    for _, window in ipairs(Library.Windows) do
        if window.Gui and window.Main then
            __bflyRefresh(window.Gui, window.Main)
        end
    end
end

-- Auto-attach butterflies to every window created from now on.
local __origCreateWindow = Library.CreateWindow
function Library:CreateWindow(config)
    local window = __origCreateWindow(self, config)
    if window and window.Gui and window.Main then
        task.defer(function()
            __bflyStart(window.Gui, window.Main)
        end)
    end
    return window
end




local TikiCompat = {
	Unloaded = false,
	Options = {},
	Toggles = {},
	ForceCheckbox = false,
	_unloadCallbacks = {},
	Window = nil,
	FloatingButton = nil,
}

local function compatSafe(fn, ...)
	if type(fn) ~= "function" then return end
	local args = table.pack(...)
	task.spawn(function()
		local ok, err = pcall(fn, table.unpack(args, 1, args.n))
		if not ok then warn("[TikiHub UI callback] " .. tostring(err)) end
	end)
end

local function mapDefault(values, default)
	if type(default) == "number" then
		return values[default] or values[1]
	end
	if default ~= nil then return default end
	return values[1]
end

local function mapToList(map, values)
	local list = {}
	if type(map) == "table" then
		for _, value in ipairs(values or {}) do
			if map[value] == true then table.insert(list, value) end
		end
		-- Support list-shaped input too.
		if #list == 0 then
			for _, value in ipairs(map) do table.insert(list, value) end
		end
	end
	return list
end

local function listToMap(list)
	local map = {}
	for _, value in ipairs(list or {}) do map[value] = true end
	return map
end

function TikiCompat:Notify(config)
	config = config or {}
	return Library:Notify({
		Title = config.Title or "Tiki Hub",
		Text = config.Description or config.Text or "",
		Duration = config.Time or config.Duration or 4,
		Kind = config.Kind or "info",
	})
end

function TikiCompat:OnUnload(fn)
	if type(fn) == "function" then table.insert(self._unloadCallbacks, fn) end
end

function TikiCompat:Unload()
	if self.Unloaded then return end
	self.Unloaded = true

	for _, fn in ipairs(self._unloadCallbacks) do pcall(fn) end
	self._unloadCallbacks = {}

	TikiUIUnload()

	local env = (getgenv and getgenv()) or _G
	if env.__TikiHubUnload == self._runtimeUnloadHandle then
		env.__TikiHubUnload = nil
	end
end

TikiCompat._runtimeUnloadHandle = function()
	pcall(function() TikiCompat:Unload() end)
end
((getgenv and getgenv()) or _G).__TikiHubUnload = TikiCompat._runtimeUnloadHandle

function TikiCompat:CreateWindow(_config)
	self.Unloaded = false

	local baseWindow = Library:CreateWindow({
		Title = "Tiki Hub",
		Subtitle = "Slayers 2  ·  made by Tiki  ·  Right Ctrl to hide",
		Size = UDim2.fromOffset(820, 610),
		Keybind = Enum.KeyCode.RightControl,
		ConfigDir = "TikiHub/Slayers2",
		ClampToScreen = true,
	})

	self.Window = baseWindow

	if baseWindow.Gui then
		baseWindow.Gui.Destroying:Connect(function()
			if not TikiCompat.Unloaded then
				task.defer(function()
					if not TikiCompat.Unloaded then
						TikiCompat:Unload()
					end
				end)
			end
		end)
	end

	pcall(function()
		self.FloatingButton = Library:CreateFloatingButton({
			Style = "circle",
			Width = 54,
			Height = 54,
			Position = UDim2.fromOffset(24, 170),
			Callback = function()
				baseWindow:Toggle()
			end,
		})
	end)

	local windowProxy = {}

	function windowProxy:AddTab(name, icon)
		local baseTab = baseWindow:AddTab(name, icon)
		local tabProxy = {}

		function tabProxy:AddGroupbox(config)
			config = config or {}
			local sectionName = config.Name or "Section"
			local section = baseTab:AddSection(sectionName)
			local group = {}

			function group:AddLabel(labelConfig)
				local text = type(labelConfig) == "table" and labelConfig.Text or tostring(labelConfig or "")
				local base = section:AddLabel(text)
				local obj = { Text = text, Value = text }
				function obj:SetText(newText)
					self.Text, self.Value = tostring(newText), tostring(newText)
					base:Set(self.Text)
				end
				function obj:Set(newText) self:SetText(newText) end
				return obj
			end

			function group:AddButton(config)
				config = config or {}
				local base = section:AddButton(config.Text or "Button", function()
					compatSafe(config.Func)
				end)
				return base
			end

			function group:AddToggle(id, config)
				config = config or {}
				local obj = { Value = config.Default == true }
				local base
				base = section:AddToggle(
					config.Text or tostring(id),
					obj.Value,
					function(value)
						obj.Value = value and true or false
						compatSafe(config.Callback, obj.Value)
					end,
					id
				)
				function obj:SetValue(value)
					self.Value = value and true or false
					base:Set(self.Value)
				end
				function obj:Set(value) self:SetValue(value) end
				TikiCompat.Toggles[id] = obj
				return obj
			end

			function group:AddInput(id, config)
				config = config or {}
				local obj = { Value = tostring(config.Default or ""), Holder = nil }
				local base
				base = section:AddTextbox(
					config.Text or tostring(id),
					obj.Value,
					config.Placeholder or config.PlaceholderText or "",
					function(value)
						obj.Value = tostring(value or "")
						compatSafe(config.Callback, obj.Value)
					end,
					id
				)
				function obj:SetValue(value)
					self.Value = tostring(value or "")
					base:Set(self.Value)
				end
				function obj:Set(value) self:SetValue(value) end
				TikiCompat.Options[id] = obj
				return obj
			end

			function group:AddDropdown(id, config)
				config = config or {}
				local values = config.Values or {}

				if config.Multi == true then
					local defaultMap = {}
					if type(config.Default) == "table" then
						for k, v in pairs(config.Default) do
							if type(k) == "number" then defaultMap[v] = true elseif v == true then defaultMap[k] = true end
						end
					end

					local obj = {
						Value = defaultMap,
						Values = values,
					}
					local base
					base = section:AddMultiDropdown(
						config.Text or tostring(id),
						values,
						mapToList(defaultMap, values),
						function(list)
							obj.Value = listToMap(list)
							compatSafe(config.Callback, obj.Value)
						end,
						id
					)

					function obj:SetValue(value)
						self.Value = type(value) == "table" and value or {}
						base:Set(mapToList(self.Value, self.Values))
					end
					function obj:Set(value) self:SetValue(value) end
					function obj:SetValues(newValues)
						self.Values = newValues or {}
						base:SetOptions(self.Values, true)
						self.Value = listToMap(base:Get())
					end
					function obj:SetOptions(newValues) self:SetValues(newValues) end

					TikiCompat.Options[id] = obj
					return obj
				end

				local selected = mapDefault(values, config.Default)
				local obj = { Value = selected, Values = values }
				local base
				base = section:AddDropdown(
					config.Text or tostring(id),
					values,
					selected,
					function(value)
						obj.Value = value
						compatSafe(config.Callback, value)
					end,
					id
				)

				function obj:SetValue(value)
					self.Value = value
					base:Set(value)
				end
				function obj:Set(value) self:SetValue(value) end
				function obj:SetValues(newValues)
					self.Values = newValues or {}
					base:SetOptions(self.Values, true)
					self.Value = base:Get()
				end
				function obj:SetOptions(newValues) self:SetValues(newValues) end

				TikiCompat.Options[id] = obj
				return obj
			end

			return group
		end

		return tabProxy
	end

	return windowProxy
end

function TikiCompat:SetTheme(name)
    Library:SetTheme(name)
    Library:SetButterflies(nil, name)
end

function TikiCompat:GetThemes()
    return Library:GetThemes()
end

function TikiCompat:GetCurrentTheme()
    return Library.CurrentTheme
end

function TikiCompat:SetButterflies(enabled)
    Library:SetButterflies(enabled)
end

function TikiCompat:SetButterflyCount(n)
    Library:SetButterflyCount(n)
end

function TikiCompat:ButterfliesEnabled()
    return Library.ButterflySettings.Enabled == true
end

return Library
