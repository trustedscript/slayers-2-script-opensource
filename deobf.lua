-- This file was generated at discord.gg/syncrypt

local t1 = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

game:GetService("RunService")
t1.Config = {}
t1.ConfigName = "DefaultAMLIB.json"
local _writefile = writefile
if _writefile then
    _writefile = readfile and isfile
end
local v6 = _writefile ~= nil
function t1.SaveConfig(_)
    if not v6 then
        return
    end
    local json
    local ok, result = pcall(function()
        json = HttpService:JSONEncode(t1.Config)
    end)
    if ok then
        writefile(t1.ConfigName, json)
    else
        warn("Erro ao salvar config (" .. t1.ConfigName .. "):", result)
    end
end
function t1.LoadConfig(_)
    local v14 = not v6
    if not v14 then
        v14 = not isfile(t1.ConfigName)
    end
    if v14 then
        return
    end
    local v15 = readfile(t1.ConfigName)
    local u16 = v15
    local ok, result = pcall(function()
        return HttpService:JSONDecode(u16)
    end)
    if ok then
        t1.Config = result

        return result
    end

    return {}
end
local function v7(p3, p4)
    local v21 = Instance.new(p3)

    for k, v in pairs(p4) do
        v21[k] = v
    end

    return v21
end
local function v8(p5, p6)
    local dragging = false
    local dragInput
    local startMouse
    local startPos

    p5.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startMouse = input.Position
            startPos = p6.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    p5.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startMouse
            p6.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end
function t1.CreateWindow(_, p8)
    local v30 = p8.Title or "UI Library"
    local p8Color = p8.Color
    if not p8Color then
        p8Color = Color3.fromRGB(0, 255, 140)
    end
    local v32 = p8Color
    local MinimizeKey = p8.MinimizeKey
    if not MinimizeKey then
        MinimizeKey = Enum.KeyCode.LeftControl
    end
    local v34 = MinimizeKey
    local v35 = p8.Transparent or false
    local v36 = p8.SearchBar or false
    t1.ConfigName = tostring(v30) .. "-" .. tostring(game.GameId) .. "-AMLIN.json"
    local v37 = tostring(v30) .. "_SavedKey.txt"
    t1:LoadConfig()
    if game.CoreGui:FindFirstChild("MyDarkLib") then
        game.CoreGui:FindFirstChild("MyDarkLib"):Destroy()
    end
    local v38 = v7
    local CoreGui = game.CoreGui
    local Sibling = Enum.ZIndexBehavior.Sibling
    local v41 = v38("ScreenGui", {
		Name = "MyDarkLib",
		Parent = CoreGui,
		ZIndexBehavior = Sibling,
		ResetOnSpawn = false
	})
    local v42 = v7
    local uDim2 = UDim2.new(1, -220, 1, -20)
    local uDim2_2 = UDim2.new(0, 200, 1, 0)
    local vector2 = Vector2.new(0, 1)
    local v46 = v42("Frame", {
		Parent = v41,
		BackgroundTransparency = 1,
		Position = uDim2,
		Size = uDim2_2,
		AnchorPoint = vector2
	})
    local v47 = v7
    local SortOrderLayoutOrder = Enum.SortOrder.LayoutOrder
    local Bottom = Enum.VerticalAlignment.Bottom
    local uDim = UDim.new(0, 5)
    v47("UIListLayout", {
		Parent = v46,
		SortOrder = SortOrderLayoutOrder,
		VerticalAlignment = Bottom,
		Padding = uDim
	})
    function t1.Notify(_, p10, p11, p12)
        local v229 = p12 or 3
        local v231 = v46
        local color3 = Color3.fromRGB(20, 20, 20)
        local uDim2_3 = UDim2.new(1, 0, 0, 60)
        local uDim2_4 = UDim2.new(1, 220, 0, 0)
        local t2 = {
			Parent = v231,
			BackgroundColor3 = color3,
			Size = uDim2_3,
			Position = uDim2_4,
			BorderSizePixel = 0
		}
        local Frame = Instance.new("Frame")
        for k, v in pairs(t2) do
            Frame[k] = v
        end
        local v239 = Frame
        local v240 = v7
        local uDim3 = UDim.new(0, 6)
        v240("UICorner", {
			Parent = v239,
			CornerRadius = uDim3
		})
        local t3 = {
			Parent = v239,
			Color = v32,
			Thickness = 1,
			Transparency = 0.5
		}
        local UIStroke = Instance.new("UIStroke")
        for k, v in pairs(t3) do
            UIStroke[k] = v
        end
        local v246 = v7
        local uDim2_5 = UDim2.new(0, 10, 0, 5)
        local uDim2_6 = UDim2.new(1, -20, 0, 20)
        local GothamBold = Enum.Font.GothamBold
        local v250 = v32
        local Left = Enum.TextXAlignment.Left
        local v252 = v246("TextLabel", {
			Parent = v239,
			BackgroundTransparency = 1,
			Position = uDim2_5,
			Size = uDim2_6,
			Font = GothamBold,
			Text = p10,
			TextColor3 = v250,
			TextSize = 14,
			TextXAlignment = Left
		})
        local v253 = v7
        local uDim2_7 = UDim2.new(0, 10, 0, 25)
        local uDim2_8 = UDim2.new(1, -20, 0, 30)
        local Gotham = Enum.Font.Gotham
        local color3_2 = Color3.fromRGB(200, 200, 200)
        local Left2 = Enum.TextXAlignment.Left
        local v259 = v253("TextLabel", {
			Parent = v239,
			BackgroundTransparency = 1,
			Position = uDim2_7,
			Size = uDim2_8,
			Font = Gotham,
			Text = p11,
			TextColor3 = color3_2,
			TextSize = 12,
			TextXAlignment = Left2,
			TextWrapped = true
		})
        TweenService:Create(v239, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, 0, 0, 0)
		}):Play()
        task.delay(v229, function()
            local tween = TweenService:Create(v239, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				Position = UDim2.new(1, 220, 0, 0),
				BackgroundTransparency = 1
			})

            TweenService:Create(v252, TweenInfo.new(0.5), {
				TextTransparency = 1
			}):Play()
            TweenService:Create(v259, TweenInfo.new(0.5), {
				TextTransparency = 1
			}):Play()
            TweenService:Create(v239:FindFirstChild("UIStroke"), TweenInfo.new(0.5), {
				Transparency = 1
			}):Play()
            tween:Play()
            tween.Completed:Wait()
            v239:Destroy()
        end)
    end
    local v51 = false

    local v102 = v7
    local color3 = Color3.fromRGB(16, 14, 9)
    local v104 = v35 and 0.1 or 0
    local vector2_3 = Vector2.new(0.5, 0.5)
    local uDim2_18 = UDim2.new(0.5, 0, 0.5, 0)
    local uDim2_19 = UDim2.new(0, 0, 0, 0)
    local v108 = v102("Frame", {
		Name = "MainFrame",
		Parent = v41,
		BackgroundColor3 = color3,
		BackgroundTransparency = v104,
		BorderSizePixel = 0,
		AnchorPoint = vector2_3,
		Position = uDim2_18,
		Size = uDim2_19,
		ClipsDescendants = true
	})
    local uDim2_20 = UDim2.new(0, 500, 0, 350)
    local v110 = v7
    local uDim8 = UDim.new(0, 6)
    v110("UICorner", {
		Parent = v108,
		CornerRadius = uDim8
	})
    local v112 = v7
    local color3_10 = Color3.fromRGB(40, 40, 40)
    v112("UIStroke", {
		Parent = v108,
		Color = color3_10,
		Thickness = 1
	})
    local v114 = v7
    local color3_11 = Color3.fromRGB(255, 255, 255)
    local uDim2_21 = UDim2.new(1, 0, 0, 30)
    local v117 = v114("Frame", {
		Name = "Topbar",
		Parent = v108,
		BackgroundColor3 = color3_11,
		BackgroundTransparency = 1,
		Size = uDim2_21
	})
    v8(v117, v108)
    local v118 = v7
    local uDim2_22 = UDim2.new(0, 10, 0, 0)
    local uDim2_23 = UDim2.new(1, -70, 1, 0)
    local GothamBold = Enum.Font.GothamBold
    local Left = Enum.TextXAlignment.Left
    local v123 = v118("TextLabel", {
		Parent = v117,
		BackgroundTransparency = 1,
		Position = uDim2_22,
		Size = uDim2_23,
		Font = GothamBold,
		Text = v30,
		TextColor3 = v32,
		TextSize = 14,
		TextXAlignment = Left
	})
    local n1 = 0
    v123.InputBegan:Connect(function(input)
        local v269 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v269 then
            v269 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v269 then
            if tick() - 0 <= 0.5 then
                n1 += 1
            else
                n1 = 1
            end

            if n1 >= 5 then
                pcall(function()
                    if isfile(t1.ConfigName) then
                        if delfile then
                            delfile(t1.ConfigName)
                        else
                            writefile(t1.ConfigName, "{}")
                        end
                    end

                    if isfile(v37) then
                        if delfile then
                            delfile(v37)

                            return
                        end

                        writefile(v37, "")
                    end
                end)
                t1.Config = {}
                t1:Notify("Sys", "0x00: Cache flushed.", 3)
            end
        end
    end)
    local v125 = v7
    local color3_12 = Color3.fromRGB(16, 14, 9)
    local vector2_4 = Vector2.new(0.5, 0)
    local uDim2_24 = UDim2.new(0.5, 0, 0, 10)
    local uDim2_25 = UDim2.new(0, 50, 0, 50)
    local GothamBold3 = Enum.Font.GothamBold
    local v131 = v125("TextButton", {
		Name = "OpenButton",
		Parent = v41,
		BackgroundColor3 = color3_12,
		AnchorPoint = vector2_4,
		Position = uDim2_24,
		Size = uDim2_25,
		Visible = false,
		Text = "AM HUB",
		TextColor3 = v32,
		Font = GothamBold3,
		TextSize = 10,
		AutoButtonColor = false
	})
    local v132 = v7
    local uDim9 = UDim.new(0, 8)
    v132("UICorner", {
		Parent = v131,
		CornerRadius = uDim9
	})
    v7("UIStroke", {
		Parent = v131,
		Color = v32,
		Thickness = 1
	})
    v8(v131, v131)
    local u134 = false
    local function v135()
        if u134 then
            return
        end

        local tween = TweenService:Create(v108, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0)
		})

        tween:Play()
        tween.Completed:Wait()
        v108.Visible = false
        v131.Visible = true
        u134 = false
    end
    local v136 = v7
    local uDim2_26 = UDim2.new(1, -30, 0, 0)
    local uDim2_27 = UDim2.new(0, 30, 0, 30)
    local GothamBold4 = Enum.Font.GothamBold
    local color3_13 = Color3.fromRGB(255, 255, 255)
    v136("TextButton", {
		Parent = v117,
		BackgroundTransparency = 1,
		Position = uDim2_26,
		Size = uDim2_27,
		Font = GothamBold4,
		Text = "X",
		TextColor3 = color3_13,
		TextSize = 14
	}).MouseButton1Click:Connect(function()
        local tween = TweenService:Create(v108, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0)
		})

        tween:Play()
        tween.Completed:Wait()
        v41:Destroy()
    end)
    local v141 = v7
    local uDim2_28 = UDim2.new(1, -60, 0, 0)
    local uDim2_29 = UDim2.new(0, 30, 0, 30)
    local GothamBold5 = Enum.Font.GothamBold
    local color3_14 = Color3.fromRGB(255, 255, 255)
    v141("TextButton", {
		Parent = v117,
		BackgroundTransparency = 1,
		Position = uDim2_28,
		Size = uDim2_29,
		Font = GothamBold5,
		Text = "-",
		TextColor3 = color3_14,
		TextSize = 18
	}).MouseButton1Click:Connect(v135)
    v131.MouseButton1Click:Connect(v135)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == v34 then
            v135()
        end
    end)
    local u146
    local u147
    local v148
    local t4 = {}
    local v150 = v7
    local color3_15 = Color3.fromRGB(0, 0, 0)
    local uDim2_30 = UDim2.new(0, 10, 0, 40)
    local uDim2_31 = UDim2.new(0, 120, 1, -50)
    local AutomaticSizeY = Enum.AutomaticSize.Y
    local uDim2_32 = UDim2.new(0, 0, 0, 0)
    local v156 = v150("ScrollingFrame", {
		Parent = v108,
		BackgroundColor3 = color3_15,
		BackgroundTransparency = 0.8,
		Position = uDim2_30,
		Size = uDim2_31,
		ScrollBarThickness = 0,
		BorderSizePixel = 0,
		AutomaticCanvasSize = AutomaticSizeY,
		CanvasSize = uDim2_32
	})
    local v157 = v7
    local SortOrderLayoutOrder2 = Enum.SortOrder.LayoutOrder
    local uDim10 = UDim.new(0, 5)
    local v160 = v157("UIListLayout", {
		Parent = v156,
		SortOrder = SortOrderLayoutOrder2,
		Padding = uDim10
	})
    local v161 = v7
    local uDim11 = UDim.new(0, 2)
    local uDim12 = UDim.new(0, 10)
    local uDim13 = UDim.new(0, 2)
    local uDim14 = UDim.new(0, 2)
    v161("UIPadding", {
		Parent = v156,
		PaddingTop = uDim11,
		PaddingBottom = uDim12,
		PaddingLeft = uDim13,
		PaddingRight = uDim14
	})
    v160:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        v156.CanvasSize = UDim2.new(0, 0, 0, v160.AbsoluteContentSize.Y + 20)
    end)
    local v166 = v7
    local color3_16 = Color3.fromRGB(60, 60, 60)
    local uDim2_33 = UDim2.new(0, 135, 0, 40)
    local uDim2_34 = UDim2.new(0, 1, 1, -50)
    local v170 = v166("Frame", {
		Parent = v108,
		BackgroundColor3 = color3_16,
		BorderSizePixel = 0,
		Position = uDim2_33,
		Size = uDim2_34
	})
    local v171 = v7
    local color3_17 = Color3.fromRGB(25, 25, 25)
    local uDim2_35 = UDim2.new(0, 140, 0, 40)
    local uDim2_36 = UDim2.new(1, -150, 1, -50)
    local v175 = v171("Frame", {
		Parent = v108,
		BackgroundColor3 = color3_17,
		BackgroundTransparency = 1,
		Position = uDim2_35,
		Size = uDim2_36,
		ClipsDescendants = true
	})
    if v36 then
        local uDim2_37 = UDim2.new(0, 10, 0, 75)
        local uDim2_38 = UDim2.new(0, 120, 1, -85)

        v156.Position = uDim2_37
        v156.Size = uDim2_38

        local uDim2_39 = UDim2.new(0, 135, 0, 75)
        local uDim2_40 = UDim2.new(0, 1, 1, -85)

        v170.Position = uDim2_39
        v170.Size = uDim2_40

        local uDim2_41 = UDim2.new(0, 140, 0, 75)
        local uDim2_42 = UDim2.new(1, -150, 1, -85)

        v175.Position = uDim2_41
        v175.Size = uDim2_42

        local v182 = v7
        local color3_18 = Color3.fromRGB(25, 25, 25)
        local uDim2_43 = UDim2.new(1, -20, 0, 30)
        local uDim2_44 = UDim2.new(0, 10, 0, 35)
        local v186 = v182("Frame", {
			Parent = v108,
			BackgroundColor3 = color3_18,
			Size = uDim2_43,
			Position = uDim2_44
		})
        local v187 = v7
        local uDim15 = UDim.new(0, 6)

        v187("UICorner", {
			Parent = v186,
			CornerRadius = uDim15
		})

        local v189 = v7
        local uDim2_45 = UDim2.new(0, 5, 0, 5)
        local uDim2_46 = UDim2.new(0, 20, 0, 20)
        local color3_19 = Color3.fromRGB(150, 150, 150)

        v189("ImageLabel", {
			Parent = v186,
			BackgroundTransparency = 1,
			Position = uDim2_45,
			Size = uDim2_46,
			Image = "rbxassetid://6031154871",
			ImageColor3 = color3_19
		})

        local v193 = v7
        local uDim2_47 = UDim2.new(0, 30, 0, 0)
        local uDim2_48 = UDim2.new(1, -35, 1, 0)
        local Gotham = Enum.Font.Gotham
        local color3_20 = Color3.fromRGB(255, 255, 255)
        local color3_21 = Color3.fromRGB(120, 120, 120)
        local Left3 = Enum.TextXAlignment.Left

        u146 = v193("TextBox", {
			Parent = v186,
			BackgroundTransparency = 1,
			Position = uDim2_47,
			Size = uDim2_48,
			Font = Gotham,
			PlaceholderText = "Pesquisar...",
			Text = "",
			TextColor3 = color3_20,
			PlaceholderColor3 = color3_21,
			TextSize = 13,
			TextXAlignment = Left3,
			ClearTextOnFocus = false
		})

        local v200 = v7
        local uDim2_49 = UDim2.new(1, 0, 1, 0)
        local uDim2_50 = UDim2.new(0, 0, 0, 0)

        u147 = v200("ScrollingFrame", {
			Parent = v175,
			BackgroundTransparency = 1,
			Size = uDim2_49,
			Visible = false,
			ScrollBarThickness = 3,
			ZIndex = 5,
			CanvasSize = uDim2_50,
			ScrollBarImageColor3 = v32
		})

        local v203 = v7
        local v204 = u147
        local SortOrderLayoutOrder3 = Enum.SortOrder.LayoutOrder
        local uDim16 = UDim.new(0, 6)
        local v207 = v203("UIListLayout", {
			Parent = v204,
			SortOrder = SortOrderLayoutOrder3,
			Padding = uDim16
		})
        local v208 = v7
        local v209 = u147
        local uDim17 = UDim.new(0, 5)
        local uDim18 = UDim.new(0, 8)
        local uDim19 = UDim.new(0, 5)
        local uDim20 = UDim.new(0, 25)

        v208("UIPadding", {
			Parent = v209,
			PaddingLeft = uDim17,
			PaddingRight = uDim18,
			PaddingTop = uDim19,
			PaddingBottom = uDim20
		})
        v207:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            u147.CanvasSize = UDim2.new(0, 0, 0, v207.AbsoluteContentSize.Y + 30)
        end)
        u146:GetPropertyChangedSignal("Text"):Connect(function()
            local v274 = u146.Text:lower()

            if v274 == "" then
                u147.Visible = false

                for _, v in pairs(t4) do
                    v.Instance.Parent = v.OriginalParent
                end

                if v148 then
                    v148.Visible = true

                    return
                end
            else
                u147.Visible = true

                for _, child in pairs(v175:GetChildren()) do
                    local v279 = child:IsA("ScrollingFrame")

                    if v279 then
                        v279 = child ~= u147
                    end

                    if v279 then
                        if not child.Visible then
                        end

                        child.Visible = false
                    end
                end

                for _, v in pairs(t4) do
                    if string.find(v.Name:lower(), v274) then
                        v.Instance.Parent = u147
                        v.Instance.Visible = true
                    else
                        v.Instance.Parent = v.OriginalParent
                    end
                end
            end
        end)
    end
    local t9 = {
		AddTab = function(_, p15, p16)
        local v285 = v7
        local v286 = v156
        local color3_22 = Color3.fromRGB(20, 20, 20)
        local uDim2_51 = UDim2.new(1, 0, 0, 30)
        local v289 = v285("TextButton", {
				Parent = v286,
				BackgroundColor3 = color3_22,
				BackgroundTransparency = 0.8,
				Size = uDim2_51,
				Text = "",
				AutoButtonColor = false
			})
        local v290 = v7
        local uDim21 = UDim.new(0, 4)
        v290("UICorner", {
				Parent = v289,
				CornerRadius = uDim21
			})
        local v292 = v7
        local v293 = v32
        local uDim2_52 = UDim2.new(0, 3, 0, 0)
        local uDim2_53 = UDim2.new(0, 0, 0.5, 0)
        local vector2_5 = Vector2.new(0, 0.5)
        local v297 = v292("Frame", {
				Name = "ActiveBar",
				Parent = v289,
				BackgroundColor3 = v293,
				Size = uDim2_52,
				Position = uDim2_53,
				AnchorPoint = vector2_5,
				BorderSizePixel = 0
			})
        local v298 = v7
        local uDim22 = UDim.new(0, 2)
        v298("UICorner", {
				Parent = v297,
				CornerRadius = uDim22
			})
        local v300 = v7
        local uDim2_54 = UDim2.new(1, -10, 1, 0)
        local uDim2_55 = UDim2.new(0, 5, 0, 0)
        local v303 = v300("Frame", {
				Name = "ContentHolder",
				Parent = v289,
				BackgroundTransparency = 1,
				Size = uDim2_54,
				Position = uDim2_55
			})
        local v304 = v7
        local Horizontal = Enum.FillDirection.Horizontal
        local SortOrderLayoutOrder4 = Enum.SortOrder.LayoutOrder
        local Center = Enum.VerticalAlignment.Center
        local Center2 = Enum.HorizontalAlignment.Center
        local uDim23 = UDim.new(0, 6)
        v304("UIListLayout", {
				Parent = v303,
				FillDirection = Horizontal,
				SortOrder = SortOrderLayoutOrder4,
				VerticalAlignment = Center,
				HorizontalAlignment = Center2,
				Padding = uDim23
			})
        local u310
        if p16 and p16 ~= "" then
            local str = tostring(p16)

            if not string.find(str, "rbxassetid://") then
                str = "rbxassetid://" .. str
            end

            local v312 = v7
            local uDim2_56 = UDim2.new(0, 16, 0, 16)
            local color3_23 = Color3.fromRGB(150, 150, 150)

            u310 = v312("ImageLabel", {
					Parent = v303,
					BackgroundTransparency = 1,
					Size = uDim2_56,
					Image = str,
					ImageColor3 = color3_23,
					LayoutOrder = 1
				})
        end
        local v315 = v7
        local uDim2_57 = UDim2.new(0, 0, 1, 0)
        local AutomaticSizeX = Enum.AutomaticSize.X
        local GothamMedium = Enum.Font.GothamMedium
        local color3_24 = Color3.fromRGB(150, 150, 150)
        local v320 = v315("TextLabel", {
				Parent = v303,
				BackgroundTransparency = 1,
				Size = uDim2_57,
				AutomaticSize = AutomaticSizeX,
				Font = GothamMedium,
				Text = p15,
				TextColor3 = color3_24,
				TextSize = 12,
				LayoutOrder = 2
			})
        local v321 = v7
        local v322 = v175
        local uDim2_58 = UDim2.new(1, 0, 1, 0)
        local uDim2_59 = UDim2.new(0, 0, 0, 0)
        local v325 = v321("ScrollingFrame", {
				Parent = v322,
				BackgroundTransparency = 1,
				Size = uDim2_58,
				ScrollBarThickness = 3,
				Visible = false,
				CanvasSize = uDim2_59,
				ScrollBarImageColor3 = v32,
				BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
				TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
			})
        local v326 = v7
        local SortOrderLayoutOrder5 = Enum.SortOrder.LayoutOrder
        local uDim24 = UDim.new(0, 6)
        local v329 = v326("UIListLayout", {
				Parent = v325,
				SortOrder = SortOrderLayoutOrder5,
				Padding = uDim24
			})
        local v330 = v7
        local uDim25 = UDim.new(0, 5)
        local uDim26 = UDim.new(0, 8)
        local uDim27 = UDim.new(0, 5)
        local uDim28 = UDim.new(0, 30)
        v330("UIPadding", {
				Parent = v325,
				PaddingLeft = uDim25,
				PaddingRight = uDim26,
				PaddingTop = uDim27,
				PaddingBottom = uDim28
			})
        v329:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            v325.CanvasSize = UDim2.new(0, 0, 0, v329.AbsoluteContentSize.Y + 40)
        end)
        v289.MouseButton1Click:Connect(function()
            local v344 = v36
            if v344 then
                v344 = u146.Text ~= ""
            end
            if v344 then
                u146.Text = ""
            end
            for v347, v348 in pairs(v175:GetChildren()) do

                if v348:IsA("ScrollingFrame") and v348 ~= u147 then
                    v348.Visible = false
                end
            end
            for _, child in pairs(v156:GetChildren()) do
                if child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(0.3), {
							BackgroundColor3 = Color3.fromRGB(20, 20, 20),
							BackgroundTransparency = 0.8
						}):Play()

                    local ActiveBar = child:FindFirstChild("ActiveBar")

                    if ActiveBar then
                        TweenService:Create(ActiveBar, TweenInfo.new(0.3), {
								Size = UDim2.new(0, 3, 0, 0)
							}):Play()
                    end

                    local ContentHolder = child:FindFirstChild("ContentHolder")

                    if ContentHolder then
                        local TextLabel = ContentHolder:FindFirstChild("TextLabel")
                        local ImageLabel = ContentHolder:FindFirstChild("ImageLabel")

                        if TextLabel then
                            TweenService:Create(TextLabel, TweenInfo.new(0.3), {
									TextColor3 = Color3.fromRGB(150, 150, 150)
								}):Play()
                        end

                        if ImageLabel then
                            TweenService:Create(ImageLabel, TweenInfo.new(0.3), {
									ImageColor3 = Color3.fromRGB(150, 150, 150)
								}):Play()
                        end
                    end
                end
            end
            v325.Visible = true
            v325.Position = UDim2.new(0, 15, 0, 15)
            v325.BackgroundTransparency = 1
            TweenService:Create(v325, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Position = UDim2.new(0, 0, 0, 0)
				}):Play()
            TweenService:Create(v289, TweenInfo.new(0.3), {
					BackgroundColor3 = Color3.fromRGB(35, 35, 35),
					BackgroundTransparency = 0
				}):Play()
            TweenService:Create(v297, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 3, 0.7, 0)
				}):Play()
            if v320 then
                TweenService:Create(v320, TweenInfo.new(0.3), {
						TextColor3 = v32
					}):Play()
            end
            if u310 then
                TweenService:Create(u310, TweenInfo.new(0.3), {
						ImageColor3 = v32
					}):Play()
            end
            v325.CanvasSize = UDim2.new(0, 0, 0, v329.AbsoluteContentSize.Y + 40)
        end)
        v325.Visible = true
        v289.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        v289.BackgroundTransparency = 0
        v297.Size = UDim2.new(0, 3, 0.7, 0)
        if v320 then
            v320.TextColor3 = v32
        end
        if u310 then
            u310.ImageColor3 = v32
        end
        task.defer(function()
            v325.CanvasSize = UDim2.new(0, 0, 0, v329.AbsoluteContentSize.Y + 40)
        end)
        local t5 = {}
        local n2 = 0
        local function v337(p17, p18)
            n2 += 1
            p18.LayoutOrder = n2

            if v36 then
                local insert = table.insert
                local v358 = t4
                local v359 = v325

                insert(v358, {
						Name = p17,
						Instance = p18,
						OriginalParent = v359
					})
            end

            v325.CanvasSize = UDim2.new(0, 0, 0, v329.AbsoluteContentSize.Y + 40)
        end
        function t5.AddLabel(_, p20)
            local v362 = v7
            local v363 = v325
            local color3_25 = Color3.fromRGB(255, 255, 255)
            local uDim2_60 = UDim2.new(1, -10, 0, 25)
            local v366 = v362("Frame", {
					Parent = v363,
					BackgroundColor3 = color3_25,
					BackgroundTransparency = 1,
					Size = uDim2_60
				})
            local v367 = v7
            local uDim2_61 = UDim2.new(1, 0, 1, 0)
            local Gotham = Enum.Font.Gotham
            local color3_26 = Color3.fromRGB(255, 255, 255)
            local Center3 = Enum.TextXAlignment.Center
            local v372 = v367("TextLabel", {
					Parent = v366,
					BackgroundTransparency = 1,
					Size = uDim2_61,
					Font = Gotham,
					Text = p20,
					TextColor3 = color3_26,
					TextSize = 12,
					TextXAlignment = Center3,
					TextWrapped = true
				})

            v337(p20, v366)

            return {
					Set = function(_, p22, p23)
                v372.Text = tostring(p23 ~= nil and p23 or p22)
            end
				}
        end
        function t5.AddButton(_, p25, p26)
            local v376 = v7
            local v377 = v325
            local color3_27 = Color3.fromRGB(255, 255, 255)
            local uDim2_62 = UDim2.new(1, -10, 0, 35)
            local Gotham = Enum.Font.Gotham
            local color3_28 = Color3.fromRGB(255, 255, 255)
            local Left4 = Enum.TextXAlignment.Left
            local v383 = v376("TextButton", {
					Parent = v377,
					BackgroundColor3 = color3_27,
					BackgroundTransparency = 0.95,
					Size = uDim2_62,
					Font = Gotham,
					Text = p25,
					TextColor3 = color3_28,
					TextSize = 12,
					TextXAlignment = Left4,
					AutoButtonColor = false
				})
            local v384 = v7
            local uDim29 = UDim.new(0, 4)

            v384("UICorner", {
					Parent = v383,
					CornerRadius = uDim29
				})

            local v386 = v7
            local uDim30 = UDim.new(0, 12)

            v386("UIPadding", {
					Parent = v383,
					PaddingLeft = uDim30
				})
            v383.MouseButton1Click:Connect(function()
                p26()
                TweenService:Create(v383, TweenInfo.new(0.1), {
						BackgroundColor3 = v32,
						BackgroundTransparency = 0.2
					}):Play()
                task.wait(0.1)
                TweenService:Create(v383, TweenInfo.new(0.2), {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 0.95
					}):Play()
            end)
            v337(p25, v383)
        end
        function t5.AddToggle(_, p28, p29, p30)
            if not p29 then
                p29 = {}
            end

            local v392 = p29.Flag or p28
            local u393 = p29.Default or false
            local v394 = v7
            local v395 = v325
            local color3_29 = Color3.fromRGB(255, 255, 255)
            local uDim2_63 = UDim2.new(1, -10, 0, 35)
            local Gotham = Enum.Font.Gotham
            local color3_30 = Color3.fromRGB(255, 255, 255)
            local Left5 = Enum.TextXAlignment.Left
            local v401 = v394("TextButton", {
					Parent = v395,
					BackgroundColor3 = color3_29,
					BackgroundTransparency = 0.95,
					Size = uDim2_63,
					Font = Gotham,
					Text = p28,
					TextColor3 = color3_30,
					TextSize = 12,
					TextXAlignment = Left5,
					AutoButtonColor = false
				})
            local v402 = v7
            local uDim31 = UDim.new(0, 4)

            v402("UICorner", {
					Parent = v401,
					CornerRadius = uDim31
				})

            local v404 = v7
            local uDim32 = UDim.new(0, 12)

            v404("UIPadding", {
					Parent = v401,
					PaddingLeft = uDim32
				})

            local v406 = v7
            local color3_31 = Color3.fromRGB(80, 80, 80)
            local uDim2_64 = UDim2.new(1, -25, 0.5, -5)
            local uDim2_65 = UDim2.new(0, 10, 0, 10)
            local v410 = v406("Frame", {
					Parent = v401,
					BackgroundColor3 = color3_31,
					Position = uDim2_64,
					Size = uDim2_65
				})
            local v411 = v7
            local uDim33 = UDim.new(0, 2)

            v411("UICorner", {
					Parent = v410,
					CornerRadius = uDim33
				})

            local function v413(p31)
                if p31 ~= nil then
                    u393 = p31
                else
                    u393 = not u393
                end

                if v392 then
                    local Config = t1.Config
                    Config[v392] = u393
                    t1:SaveConfig()
                end

                task.spawn(function()
                    p30(u393)
                end)

                local v625 = TweenService
                local v626 = v410
                local tweenInfo = TweenInfo.new(0.2)
                local v628 = u393 and v32

                if not v628 then
                    v628 = Color3.fromRGB(80, 80, 80)
                end

                v625:Create(v626, tweenInfo, {
						BackgroundColor3 = v628
					}):Play()
            end

            v401.MouseButton1Click:Connect(function()
                v413()
            end)
            v337(p28, v401)

            local v414 = v392

            if v414 then
                v414 = t1.Config[v392] ~= nil
            end

            if v414 then
                v413(t1.Config[v392])
            else
                v413(u393)
            end

            return {
					Set = function(_, p33, p34)
                local v632 = p34 ~= nil and p34 or p33

                if type(v632) == "boolean" then
                    v413(v632)
                end
            end
				}
        end
        function t5.AddTextBox(_, p36, p37)
            local v418 = v7
            local v419 = v325
            local color3_32 = Color3.fromRGB(255, 255, 255)
            local uDim2_66 = UDim2.new(1, -10, 0, 35)
            local v422 = v418("Frame", {
					Parent = v419,
					BackgroundColor3 = color3_32,
					BackgroundTransparency = 0.95,
					Size = uDim2_66
				})
            local v423 = v7
            local uDim34 = UDim.new(0, 4)

            v423("UICorner", {
					Parent = v422,
					CornerRadius = uDim34
				})

            local v425 = v7
            local uDim2_67 = UDim2.new(0.6, 0, 1, 0)
            local uDim2_68 = UDim2.new(0, 0, 0, 0)
            local Gotham = Enum.Font.Gotham
            local color3_33 = Color3.fromRGB(255, 255, 255)
            local Left6 = Enum.TextXAlignment.Left
            local v431 = v425("TextLabel", {
					Parent = v422,
					BackgroundTransparency = 1,
					Size = uDim2_67,
					Position = uDim2_68,
					Font = Gotham,
					Text = p36,
					TextColor3 = color3_33,
					TextSize = 12,
					TextXAlignment = Left6
				})
            local v432 = v7
            local uDim35 = UDim.new(0, 12)

            v432("UIPadding", {
					Parent = v431,
					PaddingLeft = uDim35
				})

            local v434 = v7
            local color3_34 = Color3.fromRGB(20, 20, 20)
            local uDim2_69 = UDim2.new(1, -110, 0.5, -10)
            local uDim2_70 = UDim2.new(0, 100, 0, 20)
            local Gotham3 = Enum.Font.Gotham
            local color3_35 = Color3.fromRGB(200, 200, 200)
            local color3_36 = Color3.fromRGB(100, 100, 100)
            local v441 = v434("TextBox", {
					Parent = v422,
					BackgroundColor3 = color3_34,
					BackgroundTransparency = 0,
					Position = uDim2_69,
					Size = uDim2_70,
					Font = Gotham3,
					Text = "",
					PlaceholderText = "...",
					TextColor3 = color3_35,
					PlaceholderColor3 = color3_36,
					TextSize = 12,
					ClearTextOnFocus = false
				})
            local v442 = v7
            local uDim36 = UDim.new(0, 4)

            v442("UICorner", {
					Parent = v441,
					CornerRadius = uDim36
				})
            v441.FocusLost:Connect(function()
                p37(v441.Text)
            end)
            v337(p36, v422)

            return {
					Set = function(_, p39, p40)
                local v636 = p40 ~= nil and p40 or p39

                v441.Text = tostring(v636)
                p37((tostring(v636)))
            end
				}
        end
        function t5.AddColorPicker(_, p42, p43, p44, p45)
            if not p43 then
                p43 = Color3.fromRGB(255, 255, 255)
            end
            if not p45 then
                p45 = {}
            end
            local v449 = p45.Flag or p42
            local u450 = p43
            local u451 = false
            local v452 = v7
            local v453 = v325
            local color3_37 = Color3.fromRGB(255, 255, 255)
            local uDim2_71 = UDim2.new(1, -10, 0, 35)
            local v456 = v452("Frame", {
					Parent = v453,
					BackgroundColor3 = color3_37,
					BackgroundTransparency = 0.95,
					Size = uDim2_71,
					ClipsDescendants = true
				})
            local v457 = v7
            local uDim37 = UDim.new(0, 4)
            v457("UICorner", {
					Parent = v456,
					CornerRadius = uDim37
				})
            local v459 = v7
            local uDim2_72 = UDim2.new(1, 0, 0, 35)
            local Gotham = Enum.Font.Gotham
            local color3_38 = Color3.fromRGB(255, 255, 255)
            local Left7 = Enum.TextXAlignment.Left
            local v464 = v459("TextButton", {
					Parent = v456,
					BackgroundTransparency = 1,
					Size = uDim2_72,
					Font = Gotham,
					Text = p42,
					TextColor3 = color3_38,
					TextSize = 12,
					TextXAlignment = Left7,
					AutoButtonColor = false
				})
            local v465 = v7
            local uDim38 = UDim.new(0, 12)
            v465("UIPadding", {
					Parent = v464,
					PaddingLeft = uDim38
				})
            local v467 = v7
            local v468 = u450
            local uDim2_73 = UDim2.new(1, -40, 0.5, -8)
            local uDim2_74 = UDim2.new(0, 25, 0, 16)
            local v471 = v467("Frame", {
					Parent = v464,
					BackgroundColor3 = v468,
					Position = uDim2_73,
					Size = uDim2_74
				})
            local v472 = v7
            local uDim39 = UDim.new(0, 4)
            v472("UICorner", {
					Parent = v471,
					CornerRadius = uDim39
				})
            local v474 = v7
            local color3_39 = Color3.fromRGB(255, 255, 255)
            v474("UIStroke", {
					Parent = v471,
					Color = color3_39,
					Thickness = 1,
					Transparency = 0.5
				})
            local v476 = v7
            local color3_40 = Color3.fromRGB(20, 20, 20)
            local uDim2_75 = UDim2.new(0, 0, 0, 35)
            local uDim2_76 = UDim2.new(1, 0, 0, 0)
            local v480 = v476("Frame", {
					Parent = v456,
					BackgroundColor3 = color3_40,
					BackgroundTransparency = 1,
					Position = uDim2_75,
					Size = uDim2_76,
					Visible = true
				})
            local function v481(_, p47, p48)
                local v640 = v7
                local v641 = v480
                local color3_41 = Color3.fromRGB(30, 30, 30)
                local uDim2_77 = UDim2.new(0, 10, 0, p48)
                local uDim2_78 = UDim2.new(1, -20, 0, 20)
                local v645 = v640("Frame", {
						Parent = v641,
						BackgroundColor3 = color3_41,
						Position = uDim2_77,
						Size = uDim2_78
					})
                local v646 = v7
                local uDim40 = UDim.new(0, 4)

                v646("UICorner", {
						Parent = v645,
						CornerRadius = uDim40
					})

                local v648 = v7
                local uDim2_79 = UDim2.new(0, 0, 1, 0)
                local uDim2_80 = UDim2.new(0, 25, 0, 0)
                local v651 = v648("Frame", {
						Parent = v645,
						BackgroundColor3 = p47,
						Size = uDim2_79,
						Position = uDim2_80
					})
                local v652 = v7
                local uDim2_81 = UDim2.new(1, -25, 1, 0)
                local uDim2_82 = UDim2.new(0, 25, 0, 0)

                return v652("TextButton", {
						Parent = v645,
						BackgroundTransparency = 1,
						Size = uDim2_81,
						Position = uDim2_82,
						Text = ""
					}), v651, v645
            end
            local v482, v483, v484 = v481("R", Color3.fromRGB(255, 50, 50), 5)
            local v485 = v483
            local v486, v487, v488 = v481("G", Color3.fromRGB(50, 255, 50), 30)
            local v489 = v487
            local v490, v491, v492 = v481("B", Color3.fromRGB(50, 50, 255), 55)
            local v493 = v491
            local function v494(p49)
                u450 = p49

                if v449 then
                    local Config = t1.Config
                    local v657 = v449
                    local R = p49.R
                    local G = p49.G
                    local B = p49.B

                    Config[v657] = {
							R = R,
							G = G,
							B = B
						}
                    t1:SaveConfig()
                end

                TweenService:Create(v485, TweenInfo.new(0.1), {
						Size = UDim2.new(p49.R, 0, 1, 0)
					}):Play()
                TweenService:Create(v489, TweenInfo.new(0.1), {
						Size = UDim2.new(p49.G, 0, 1, 0)
					}):Play()
                TweenService:Create(v493, TweenInfo.new(0.1), {
						Size = UDim2.new(p49.B, 0, 1, 0)
					}):Play()
                TweenService:Create(v471, TweenInfo.new(0.1), {
						BackgroundColor3 = p49
					}):Play()
                task.spawn(function()
                    p44(p49)
                end)
            end
            local function v495(p50, p51, p52)
                local v664 = math.clamp((p50.Position.X - p52.AbsolutePosition.X - 25) / (p52.AbsoluteSize.X - 25), 0, 1)

                p51.Size = UDim2.new(v664, 0, 1, 0)

                local v665 = math.clamp(v485.Size.X.Scale, 0, 1)
                local v666 = math.clamp(v489.Size.X.Scale, 0, 1)
                local v667 = math.clamp(v493.Size.X.Scale, 0, 1)
                local color3_42 = Color3.new(v665, v666, v667)

                v494(color3_42)
            end
            for v498, v499 in pairs({
					{
						v482,
						v485,
						v484
					},
					{
						v486,
						v489,
						v488
					},
					{
						v490,
						v493,
						v492
					}
				}) do

                local v500 = v499[1]
                local v501 = v499[2]
                local v502 = v499[3]
                local u503 = false

                v500.InputBegan:Connect(function(input)
                    local v670 = input.UserInputType == Enum.UserInputType.MouseButton1

                    if not v670 then
                        v670 = input.UserInputType == Enum.UserInputType.Touch
                    end

                    if v670 then
                        u503 = true
                        v495(input, v501, v502)
                    end
                end)
                v500.InputEnded:Connect(function(input)
                    local v672 = input.UserInputType == Enum.UserInputType.MouseButton1

                    if not v672 then
                        v672 = input.UserInputType == Enum.UserInputType.Touch
                    end

                    if v672 then
                        u503 = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    local v674 = u503

                    if v674 then
                        v674 = input.UserInputType == Enum.UserInputType.MouseMovement

                        if not v674 then
                            v674 = input.UserInputType == Enum.UserInputType.Touch
                        end
                    end

                    if v674 then
                        v495(input, v501, v502)
                    end
                end)
            end
            v464.MouseButton1Click:Connect(function()
                u451 = not u451

                local v675 = not u451 and 35 or 115

                TweenService:Create(v456, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, -10, 0, v675)
					}):Play()
                task.wait(0.35)
                v325.CanvasSize = UDim2.new(0, 0, 0, v329.AbsoluteContentSize.Y + 40)
            end)
            v337(p42, v456)
            local v504 = v449
            if v504 then
                v504 = t1.Config[v449]
            end
            if v504 then
                local v505 = t1.Config[v449]

                v494(Color3.new(v505.R, v505.G, v505.B))
            else
                v494(u450)
            end

            return {
					Set = function(_, p54, p55)
                local v679 = p55 ~= nil and p55 or p54

                if typeof(v679) == "Color3" then
                    v494(v679)
                end
            end
				}
        end
        function t5.AddSlider(_, p57, p58, p59)
            local v510 = p58.Min or 0
            local v511 = p58.Max or 100
            local v512 = p58.Default or v510
            local v513 = p58.Flag or p57
            local u514 = v512
            local v515 = v7
            local v516 = v325
            local color3_43 = Color3.fromRGB(255, 255, 255)
            local uDim2_83 = UDim2.new(1, -10, 0, 48)
            local v519 = v515("Frame", {
					Parent = v516,
					BackgroundColor3 = color3_43,
					BackgroundTransparency = 0.95,
					Size = uDim2_83
				})
            local v520 = v7
            local uDim41 = UDim.new(0, 4)
            v520("UICorner", {
					Parent = v519,
					CornerRadius = uDim41
				})
            local v522 = v7
            local uDim2_84 = UDim2.new(0, 0, 0, 5)
            local uDim2_85 = UDim2.new(1, -80, 0, 20)
            local Gotham = Enum.Font.Gotham
            local color3_44 = Color3.fromRGB(255, 255, 255)
            local Left8 = Enum.TextXAlignment.Left
            local v528 = v522("TextLabel", {
					Parent = v519,
					BackgroundTransparency = 1,
					Position = uDim2_84,
					Size = uDim2_85,
					Font = Gotham,
					Text = p57,
					TextColor3 = color3_44,
					TextSize = 12,
					TextXAlignment = Left8
				})
            local v529 = v7
            local uDim42 = UDim.new(0, 12)
            v529("UIPadding", {
					Parent = v528,
					PaddingLeft = uDim42
				})
            local v531 = v7
            local uDim2_86 = UDim2.new(1, -60, 0, 5)
            local uDim2_87 = UDim2.new(0, 50, 0, 20)
            local Gotham4 = Enum.Font.Gotham
            local str = tostring(v512)
            local color3_45 = Color3.fromRGB(200, 200, 200)
            local Right = Enum.TextXAlignment.Right
            local v538 = v531("TextBox", {
					Parent = v519,
					BackgroundTransparency = 1,
					Position = uDim2_86,
					Size = uDim2_87,
					Font = Gotham4,
					Text = str,
					TextColor3 = color3_45,
					TextSize = 12,
					TextXAlignment = Right,
					ClearTextOnFocus = false,
					ZIndex = 2
				})
            local v539 = v7
            local color3_46 = Color3.fromRGB(20, 20, 20)
            local uDim2_88 = UDim2.new(0, 10, 0, 28)
            local uDim2_89 = UDim2.new(1, -20, 0, 12)
            local v543 = v539("Frame", {
					Parent = v519,
					BackgroundColor3 = color3_46,
					Position = uDim2_88,
					Size = uDim2_89
				})
            local v544 = v7
            local uDim43 = UDim.new(0, 4)
            v544("UICorner", {
					Parent = v543,
					CornerRadius = uDim43
				})
            local v546 = v7
            local v547 = v32
            local uDim2_90 = UDim2.new(0, 0, 1, 0)
            local v549 = v546("Frame", {
					Parent = v543,
					BackgroundColor3 = v547,
					Size = uDim2_90
				})
            local v550 = v7
            local uDim44 = UDim.new(0, 4)
            v550("UICorner", {
					Parent = v549,
					CornerRadius = uDim44
				})
            local v552 = v7
            local uDim2_91 = UDim2.new(0, 0, 0, 0)
            local uDim2_92 = UDim2.new(1, 0, 1, 0)
            local v555 = v552("TextButton", {
					Parent = v519,
					BackgroundTransparency = 1,
					Position = uDim2_91,
					Size = uDim2_92,
					Text = "",
					ZIndex = 1
				})
            local function v556(p60)
                local v681 = math.clamp(p60, v510, v511)
                local v682 = if v511 ~= v510 then (v681 - v510) / (v511 - v510) else 0

                TweenService:Create(v549, TweenInfo.new(0.05), {
						Size = UDim2.new(v682, 0, 1, 0)
					}):Play()
                v538.Text = tostring(v681)
                u514 = v681

                if v513 then
                    t1.Config[v513] = v681
                    t1:SaveConfig()
                end

                task.spawn(function()
                    p59(v681)
                end)
            end
            v538.FocusLost:Connect(function()
                local num = tonumber(v538.Text)

                if num then
                    v556(num)

                    return
                end

                v538.Text = tostring(u514)
            end)
            local u557 = false
            local u558
            v555.InputBegan:Connect(function(input)
                local v685 = input.UserInputType == Enum.UserInputType.MouseButton1

                if not v685 then
                    v685 = input.UserInputType == Enum.UserInputType.Touch
                end

                if v685 then
                    u557 = true
                    u558 = input

                    local v686 = math.clamp((input.Position.X - v543.AbsolutePosition.X) / v543.AbsoluteSize.X, 0, 1)

                    v556((math.floor(v510 + (v511 - v510) * v686)))
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                local v688 = input == u558

                if not v688 then
                    v688 = input.UserInputType == Enum.UserInputType.MouseButton1

                    if not v688 then
                        v688 = input.UserInputType == Enum.UserInputType.Touch
                    end
                end

                if v688 then
                    u557 = false
                    u558 = nil
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                local v690 = u557

                if v690 then
                    v690 = input == u558

                    if not v690 then
                        v690 = input.UserInputType == Enum.UserInputType.MouseMovement

                        if not v690 then
                            v690 = input.UserInputType == Enum.UserInputType.Touch
                        end
                    end
                end

                if v690 then
                    local v691 = math.clamp((input.Position.X - v543.AbsolutePosition.X) / v543.AbsoluteSize.X, 0, 1)

                    v556((math.floor(v510 + (v511 - v510) * v691)))
                end
            end)
            v337(p57, v519)
            local v559 = v513
            if v559 then
                v559 = t1.Config[v513] ~= nil
            end
            if v559 then
                v556(t1.Config[v513])
            else
                v556(v512)
            end

            return {
					Set = function(_, p62, p63)
                local v695 = p63 ~= nil and p63 or p62

                v556(tonumber(v695) or v510)
            end
				}
        end
        function t5.AddDropdown(_, p65, p66, p67)
            local u564 = p66.Values or {}
            local v565 = p66.Default or ""
            local v566 = p66.Multi or false
            local v567 = p66.Flag or p65
            local u568 = false
            local t6 = {}
            local u570 = v565
            local v571 = v566
            if v571 then
                v571 = type(v565) == "table"
            end
            if v571 then
                t6 = v565
            end
            local v573 = v325
            local color3_47 = Color3.fromRGB(255, 255, 255)
            local uDim2_93 = UDim2.new(1, -10, 0, 35)
            local t7 = {
					Parent = v573,
					BackgroundColor3 = color3_47,
					BackgroundTransparency = 0.95,
					Size = uDim2_93,
					ClipsDescendants = true
				}
            local Frame = Instance.new("Frame")
            for k, v in pairs(t7) do
                Frame[k] = v
            end
            local v580 = Frame
            local v581 = v7
            local uDim45 = UDim.new(0, 4)
            v581("UICorner", {
					Parent = v580,
					CornerRadius = uDim45
				})
            local v583 = v7
            local uDim2_94 = UDim2.new(1, 0, 0, 35)
            local Gotham = Enum.Font.Gotham
            local color3_48 = Color3.fromRGB(255, 255, 255)
            local Left9 = Enum.TextXAlignment.Left
            local v588 = v583("TextButton", {
					Parent = v580,
					BackgroundTransparency = 1,
					Size = uDim2_94,
					Font = Gotham,
					Text = p65,
					TextColor3 = color3_48,
					TextSize = 12,
					TextXAlignment = Left9,
					AutoButtonColor = false
				})
            local v589 = v7
            local uDim46 = UDim.new(0, 12)
            v589("UIPadding", {
					Parent = v588,
					PaddingLeft = uDim46
				})
            local v591 = v7
            local uDim2_95 = UDim2.new(1, -25, 0, 0)
            local uDim2_96 = UDim2.new(0, 25, 1, 0)
            local GothamBold6 = Enum.Font.GothamBold
            local color3_49 = Color3.fromRGB(200, 200, 200)
            local v596 = v591("TextLabel", {
					Parent = v588,
					BackgroundTransparency = 1,
					Position = uDim2_95,
					Size = uDim2_96,
					Font = GothamBold6,
					Text = "v",
					TextColor3 = color3_49,
					TextSize = 12
				})
            local v597 = v7
            local color3_50 = Color3.fromRGB(12, 12, 12)
            local uDim2_97 = UDim2.new(0, 0, 0, 35)
            local uDim2_98 = UDim2.new(1, 0, 0, 0)
            local AutomaticSizeY2 = Enum.AutomaticSize.Y
            local uDim2_99 = UDim2.new(0, 0, 0, 0)
            local v603 = v597("ScrollingFrame", {
					Parent = v580,
					BackgroundColor3 = color3_50,
					BackgroundTransparency = 0,
					Position = uDim2_97,
					Size = uDim2_98,
					ScrollBarThickness = 2,
					BorderSizePixel = 0,
					AutomaticCanvasSize = AutomaticSizeY2,
					CanvasSize = uDim2_99
				})
            local v604 = v7
            local uDim47 = UDim.new(0, 6)
            v604("UICorner", {
					Parent = v603,
					CornerRadius = uDim47
				})
            local v606 = v7
            local SortOrderLayoutOrder6 = Enum.SortOrder.LayoutOrder
            local uDim48 = UDim.new(0, 4)
            v606("UIListLayout", {
					Parent = v603,
					SortOrder = SortOrderLayoutOrder6,
					Padding = uDim48
				})
            local v609 = v7
            local uDim49 = UDim.new(0, 5)
            local uDim50 = UDim.new(0, 5)
            local uDim51 = UDim.new(0, 5)
            local uDim52 = UDim.new(0, 5)
            v609("UIPadding", {
					Parent = v603,
					PaddingLeft = uDim49,
					PaddingRight = uDim50,
					PaddingTop = uDim51,
					PaddingBottom = uDim52
				})
            local t8 = {}
            local function v615()
                if v566 then
                    local n3 = 0

                    for _, v in pairs(t6) do
                        if v then
                            n3 += 1
                        end
                    end

                    local v699 = v588
                    local v700 = n3 == 0

                    if v700 then
                        v700 = p65 .. " (Nenhum)"
                    end

                    if not v700 then
                        v700 = p65 .. " (" .. n3 .. ")"
                    end

                    v699.Text = v700

                    return
                end

                v588.Text = p65 .. ": " .. tostring(u570)
            end
            local function v616()
                u568 = not u568

                local v701 = math.min(#u564 * 29 + 10, 150)
                local v702 = TweenService
                local v703 = v580
                local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                local new = UDim2.new
                local v706 = u568

                if v706 then
                    v706 = 35 + v701 + 5
                end

                v702:Create(v703, tweenInfo, {
						Size = new(1, -10, 0, v706 or 35)
					}):Play()
                TweenService:Create(v603, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, u568 and v701 or 0)
					}):Play()
                v596.Text = not u568 and "v" or "^"
                task.wait(0.35)
                v325.CanvasSize = UDim2.new(0, 0, 0, v329.AbsoluteContentSize.Y + 40)
            end
            v588.MouseButton1Click:Connect(v616)
            local function v617(p68)
                if v566 then
                    local v708 = type(p68) == "table" and p68

                    if not v708 then
                        v708 = {}
                    end

                    t6 = v708

                    if v567 then
                        local Config = t1.Config
                        Config[v567] = t6
                        t1:SaveConfig()
                    end

                    task.spawn(function()
                        p67(t6)
                    end)
                else
                    u570 = p68

                    if v567 then
                        local Config = t1.Config
                        Config[v567] = u570
                        t1:SaveConfig()
                    end

                    task.spawn(function()
                        p67(p68)
                    end)
                end

                v615()

                for _, child in pairs(v603:GetChildren()) do
                    if child:IsA("TextButton") then
                        if v566 then
                            local v715 = t6[child.Text] and v32

                            if not v715 then
                                v715 = Color3.fromRGB(200, 200, 200)
                            end

                            child.TextColor3 = v715
                        else
                            local v716 = child.Text == tostring(u570) and v32

                            if not v716 then
                                v716 = Color3.fromRGB(200, 200, 200)
                            end

                            child.TextColor3 = v716
                        end
                    end
                end
            end
            function t8.Refresh(_, p70)
                if not p70 then
                    p70 = u564
                end
                u564 = p70
                for v721, v722 in pairs(v603:GetChildren()) do

                    if v722:IsA("TextButton") then
                        v722:Destroy()
                    end
                end
                for _, v in pairs(u564) do
                    local v725 = v
                    local v726 = v7
                    local v727 = v603
                    local color3_51 = Color3.fromRGB(25, 25, 25)
                    local uDim2_100 = UDim2.new(1, 0, 0, 25)
                    local Gotham5 = Enum.Font.Gotham
                    local color3_52 = Color3.fromRGB(200, 200, 200)
                    local v732 = v726("TextButton", {
							Parent = v727,
							BackgroundColor3 = color3_51,
							Size = uDim2_100,
							Font = Gotham5,
							Text = v725,
							TextColor3 = color3_52,
							TextSize = 11,
							AutoButtonColor = false
						})
                    local v733 = v7
                    local uDim53 = UDim.new(0, 4)

                    v733("UICorner", {
							Parent = v732,
							CornerRadius = uDim53
						})
                    v732.MouseButton1Click:Connect(function()
                        if v566 then
                            local v741 = t6[v725]

                            t6[v725] = not v741
                            v617(t6)

                            return
                        end

                        local v742 = v725

                        v617(v742)
                        v616()
                    end)
                end
                local v735 = v617
                local v736 = v566
                if v736 then
                    v736 = t6
                end
                if not v736 then
                    v736 = u570
                end
                v735(v736)
            end
            t8:Refresh(u564)
            local v618 = v567
            if v618 then
                v618 = t1.Config[v567] ~= nil
            end
            if v618 then
                v617(t1.Config[v567])
            end
            function t8.Set(_, p72, p73)
                local v740 = p73 ~= nil and p73 or p72

                v617(v740)
            end
            v337(p65, v580)

            return t8
        end

        return t5
    end
	}
    v108.Visible = true
    TweenService:Create(v108, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = uDim2_20
	}):Play()
    task.spawn(function()
        local MarketplaceService = game:GetService("MarketplaceService")
        local u339 = MarketplaceService
        local ok5, result5 = pcall(function()
            return u339:GetProductInfo(game.PlaceId)
        end)
        if ok5 then
            if result5 then
                result5 = result5.Name
            end

            ok5 = result5
        end
        local v342 = ok5 or ".gg/Gvk5BeWtxz"
        t1:Notify("AM HUB", "AM HUB Loaded! [" .. v342 .. "]", 8)
    end)

    return t9
end
return t1
