-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {
	value1 = loadstring(game:HttpGet("https://pastebin.com/raw/KNBjDTZ3"))(),
	value2 = game:GetService("Players"),
	value3 = game:GetService("Workspace")
}
local RunService = game:GetService("RunService")

t2.value4 = game:GetService("UserInputService")
t2.value5 = game:GetService("TeleportService")
t2.value6 = game:GetService("HttpService")
t2.value7 = game:GetService("VirtualUser")
t2.value8 = game:GetService("VirtualInputManager")
t2.value9 = game:GetService("Lighting")
t2.value10 = t2.value2.LocalPlayer
t2.value11 = t2.value3.CurrentCamera
local value1 = t2.value1
local fromRGB = Color3.fromRGB
local CreateWindow = value1.CreateWindow
local v7 = fromRGB(0, 255, 140)
local RightControl = Enum.KeyCode.RightControl
local v9 = CreateWindow(value1, {
	Title = "[AM HUB] • Slayers 2",
	Color = v7,
	MinimizeKey = RightControl,
	Transparent = true,
	SearchBar = true
})
local v10 = v9:AddTab("⚔\239\184\143 Combat", "")
local v11 = v9:AddTab("🌾 Auto Farm", "")
local v12 = v9:AddTab("🏋\239\184\143 Training", "")
local v13 = v9:AddTab("🏪 Shops & NPCs", "")
local v14 = v9:AddTab("🎲 Spin & Set", "")
local v15 = v9:AddTab("🎁 Attributes", "")
local v16 = v9:AddTab("🏃 Movement", "")
local v17 = v9:AddTab("📜 Quests", "")
local v18 = v9:AddTab("🌐 Server & Misc", "")
local v19 = v9:AddTab("🚀 Visuals & FPS", "")
local v20 = v9:AddTab("📊 Stats", "")
local color3 = Color3.fromRGB(255, 60, 60)
local color3_2 = Color3.fromRGB(180, 50, 255)
local color3_3 = Color3.fromRGB(0, 220, 255)
local color3_4 = Color3.fromRGB(255, 215, 0)
local elapsed = os.clock()
t2.value12 = {
	AutoAttack = false,
	AttackRange = 30,
	AttackInterval = 0.08,
	KillAura = false,
	KillAuraRadius = 35,
	InstantKillDamage = false,
	InfiniteStamina = false,
	AntiStun = false,
	GodMode = false,
	AutoEmergencySafe = false,
	EmergencyHPThreshold = 30,
	ResumeAboveHP = 85,
	AutoBossHunt = false,
	SelectedBossTarget = "Zuko",
	AutoFarm = false,
	SelectedMob = "All",
	CustomMobText = "",
	ExactTargetName = false,
	BlacklistFilter = "",
	FarmableNPCsOnly = false,
	AutoQuestBeforeFarm = false,
	AutoNextKillQuest = false,
	ReplaceWrongQuest = false,
	LockQuestTarget = false,
	NoclipWhileFarming = true,
	MaxTargetDistance = 2500,
	FarmDistance = 1.2,
	FarmHeight = 0,
	FarmStyle = "Behind",
	FarmPriority = "Nearest",
	BringMobs = false,
	FreezeMobs = false,
	BringRadius = 40,
	MaxBringMobs = 6,
	AutoSkills = false,
	AutoReturnQuest = false,
	QuestStuckRecovery = false,
	RecoverQuestSec = 30,
	LastTargetLocked = nil,
	LastEquipTime = 0,
	LastQuestAttemptTime = 0,
	CycleAngle = 0,
	SelectedFacility = "Pushups",
	AutoTraining = false,
	SelectedNPC = "Raze (Weapons Shop)",
	SelectedShopItem = "Health Regen Potion",
	TargetRace = "Demon",
	TargetClan = "Kamado",
	StopOnRarity = "Mythic",
	AutoSpinRace = false,
	AutoSpinClan = false,
	AutoStatPoints = false,
	TargetStatCategory = "Strength",
	MasteryWeapon = "Sword",
	TargetBreathing = "Water Breathing",
	WalkSpeed = 16,
	SpeedLock = false,
	JumpPower = 50,
	SpeedEnabled = false,
	JumpEnabled = false,
	Noclip = false,
	InfiniteJump = false,
	FlyEnabled = false,
	FlySpeed = 60,
	SelectedPlayerToTP = "",
	SelectedRegion = "Windy Peak",
	SelectedPOI = "Dock Master / Fishing",
	AutoQuests = false,
	AutoQuestTargetManual = false,
	AutoInteractNearby = false,
	PromptRadius = 25,
	CustomQuestName = "",
	AutoCollectChests = false,
	AutoCollectLoot = false,
	InterruptFarmForLoot = false,
	MaxChestDistance = 1500,
	NearbyLootRadius = 300,
	LootWhitelist = "",
	LootBlacklist = "",
	ChestBlacklist = "",
	IncludeLockedChests = true,
	AutoFishingReel = false,
	TakeFoxfireActive = false,
	EquipToolName = "",
	MobESPEnabled = false,
	MobESPColor = color3,
	BossESPEnabled = false,
	BossESPColor = color3_2,
	PlayerESPEnabled = false,
	PlayerESPColor = color3_3,
	ChestESPEnabled = false,
	ChestESPColor = color3_4,
	FPSBoost = false,
	HidePlayers = false,
	HideEnemies = false,
	FOV = 70,
	SessionStartTime = elapsed,
	MobsKilledCount = 0,
	QuestsCompletedCount = 0,
	ChestsOpenedCount = 0,
	IsUnloaded = false
}
t1.value2 = {}
t1.value1 = {}
t2.value13 = t1.value2
t2.value14 = CFrame.new(-389, 1229.5, -935)

local cFrame = CFrame.new(-227, 1226, -1009)
local cFrame2 = CFrame.new(-389, 1229.5, -935)
local cFrame3 = CFrame.new(150, 1220, -500)
local cFrame4 = CFrame.new(-100, 1225, -800)
local cFrame5 = CFrame.new(-650, 1210, -1200)

t2.value15 = {
	["Windy Peak"] = cFrame,
	Sanctuary = cFrame2,
	["Ouwland Plains"] = cFrame3,
	["Village / Hub"] = cFrame4,
	["Lake / Docks"] = cFrame5
}
local cFrame6 = CFrame.new(-660, 1212, -1220)
local cFrame7 = CFrame.new(-115, 1225, -820)
local cFrame8 = CFrame.new(-90, 1225, -850)
local cFrame9 = CFrame.new(450, 1260, -300)
local cFrame10 = CFrame.new(-800, 1230, -600)
local cFrame11 = CFrame.new(900, 1150, 800)

t2.value16 = {
	["Dock Master / Fishing"] = cFrame6,
	["Blacksmith Togane / Crafting"] = cFrame7,
	["Alchemist Meku"] = cFrame8,
	["Parkour Dungeon"] = cFrame9,
	["Grove Raid"] = cFrame10,
	["Muzan's Lair"] = cFrame11
}
local t3 = {
	"All",
	"Bandit",
	"Zuko",
	"Civilian",
	"Serpent Trainee",
	"Reaper",
	"Datai",
	"Gyutai",
	"Saneri",
	"Akazo",
	"Domae",
	"Enru",
	"Fire Profound Demon",
	"Flame Trainee",
	"Fujiko",
	"Giyen",
	"Greater Demon",
	"Grove Raider",
	"Gyorei",
	"High Demon",
	"Hoyuzo",
	"Hoyuzo Subordinate",
	"Ice Profound Demon",
	"Insect Trainee",
	"Kaiden",
	"Kaiden Subordinate",
	"Kanoe Demon Slayer",
	"Lancer Captain",
	"Lesser Demon",
	"Mizunoe Demon Slayer",
	"Mizunoto",
	"Mother Bear",
	"Nezura",
	"Obari",
	"Prowler Captain",
	"Raid Captain",
	"Reaper Trainee Kuzan",
	"Rengu",
	"Shinora",
	"Soryu Trainee Goki",
	"Sound Trainee",
	"Stone Trainee",
	"Sumari",
	"Tai Chi Trainee Suzume",
	"Tengai",
	"Thunder Trainee",
	"Water Trainee Sabito",
	"Wind Trainee",
	"Yahari",
	"Zentaro",
	"Hand Demon",
	"Muzan",
	"Kokushibo",
	"Akaza",
	"Rogue Slayer"
}
table.sort(t3)
t2.value17 = {
	"zuko",
	"reaper",
	"datai",
	"gyutai",
	"saneri",
	"akazo",
	"domae",
	"enru",
	"muzan",
	"kokushibo",
	"akaza",
	"hand demon",
	"rogue slayer"
}
function t2.value18()
    local Character = t2.value10.Character

    if not Character then
        Character = t2.value10.CharacterAdded:Wait()
    end

    return Character
end
local function v38()
    local v51 = t2.value18()

    if v51 then
        local HumanoidRootPart = v51:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            HumanoidRootPart = v51:FindFirstChild("UpperTorso")
        end

        v51 = HumanoidRootPart
    end

    return v51
end
local function v39(p1)
    local v54 = p1:lower()

    for _, v in ipairs(t2.value17) do
        if v54:find(v, 1, true) then
            return true
        end
    end

    return false
end
local function v40(p2, p3)
    if not p2 or not p3 then
        return false
    end

    if p3 == "All" or p3 == "" then
        return true
    end

    local v59 = p2:lower()
    local v60 = p3:lower()

    if t2.value12.ExactTargetName then
        return v59 == v60
    end

    if v60:find("/") then
        for match in v60:gmatch("[^/]+") do
            local v62 = match:match("^%s*(.-)%s*$")

            if v62 ~= "" and v59:find(v62, 1, true) then
                return true
            end
        end
    end

    return v59:find(v60, 1, true) or v60:find(v59, 1, true)
end
function t2.value19(p4)
    if t2.value12.BlacklistFilter == "" then
        return false
    end

    for match in t2.value12.BlacklistFilter:gmatch("[^,]+") do
        local v50 = match:match("^%s*(.-)%s*$"):lower()

        if v50 ~= "" and p4:lower():find(v50, 1, true) then
            return true
        end
    end

    return false
end
local function v41()
    local t4 = {}

    local function v77(p5)
        local v391 = p5:IsA("Model")

        if v391 then
            v391 = p5 ~= t2.value10.Character
        end

        if v391 then
            local Humanoid = p5:FindFirstChildOfClass("Humanoid")
            local v393 = p5:FindFirstChild("HumanoidRootPart") or p5.PrimaryPart

            if Humanoid then
                local v394 = false

                if Humanoid.Health > 0 then
                    v394 = v393
                end

                Humanoid = v394
            end

            if Humanoid and not t2.value2:GetPlayerFromCharacter(p5) and not t2.value19(p5.Name) then
                table.insert(t4, p5)
            end
        end
    end

    local Humanoids = t2.value3:FindFirstChild("Humanoids")
    local v79 = Humanoids

    if Humanoids then
        v79 = Humanoids:FindFirstChild("Regions")
    end

    if v79 then
        for _, child in ipairs(Humanoids.Regions:GetChildren()) do
            local ActiveNpcs = child:FindFirstChild("ActiveNpcs")

            if ActiveNpcs then
                local GetChildren = ActiveNpcs.GetChildren

                for _, v in ipairs(GetChildren(ActiveNpcs)) do
                    for _, child2 in ipairs(v:GetChildren()) do
                        v77(child2)
                    end
                end
            end
        end
    end

    for _, child in ipairs(t2.value3:GetChildren()) do
        v77(child)
    end

    return t4
end
function t2.value20(p6)
    local v92 = v38()
    if not v92 then
        return nil
    end
    local LockQuestTarget = t2.value12.LockQuestTarget
    if LockQuestTarget then
        LockQuestTarget = t2.value12.LastTargetLocked

        if LockQuestTarget then
            LockQuestTarget = t2.value12.LastTargetLocked.Parent
        end
    end
    if LockQuestTarget then
        local Humanoid = t2.value12.LastTargetLocked:FindFirstChildOfClass("Humanoid")

        if Humanoid and Humanoid.Health > 0 then
            return t2.value12.LastTargetLocked
        end
    end
    local v95 = t2.value12.CustomMobText ~= ""
    if v95 then
        v95 = t2.value12.CustomMobText
    end
    local v96 = v95 or p6
    local t5 = {}
    local v98 = v41()
    local _ipairs = ipairs
    for v102, v103 in _ipairs(v98) do

        local BossOnlyMode = t2.value12.BossOnlyMode

        if BossOnlyMode then
            BossOnlyMode = not v39(v103.Name)
        end

        if not BossOnlyMode then
            local v105 = v40(v103.Name, v96)

            if not v105 then
                local v106 = v40
                local Parent = v103.Parent

                if Parent then
                    Parent = v103.Parent.Name
                end

                if not Parent then
                    Parent = ""
                end

                v105 = v106(Parent, v96)
            end

            if v105 then
                local v108 = v103:FindFirstChild("HumanoidRootPart") or v103.PrimaryPart

                _ipairs = v103:FindFirstChildOfClass("Humanoid")

                local v109 = _ipairs
                local v110 = v108

                if v108 then
                    v110 = v109 and v109.Health > 0
                end

                if v110 then
                    _ipairs = (v92.Position - v108.Position).Magnitude

                    local v111 = _ipairs

                    if v111 <= t2.value12.MaxTargetDistance then
                        _ipairs = table.insert

                        local Health = v109.Health

                        _ipairs(t5, {
							mob = v103,
							dist = v111,
							hp = Health
						})
                    end
                end
            end
        end
    end
    if #t5 == 0 then
        return nil
    end
    if t2.value12.FarmPriority == "Lowest HP" then
        table.sort(t5, function(p7, p8)
            return p7.hp < p8.hp
        end)
    else
        table.sort(t5, function(p9, p10)
            return p9.dist < p10.dist
        end)
    end
    local mob = t5[1].mob
    t2.value12.LastTargetLocked = mob

    return mob
end
function t2.value21()
    if os.clock() - t2.value12.LastEquipTime > 2 then
        t2.value12.LastEquipTime = os.clock()
        pcall(function()
            local PlayerGui = t2.value10:FindFirstChild("PlayerGui")
            local v397 = PlayerGui

            if PlayerGui then
                v397 = PlayerGui:FindFirstChild("ComponentsHolder")
            end

            if v397 then
                local v398 = PlayerGui.ComponentsHolder.BottomHolder.Toolbar.SkillHolder:FindFirstChild("1_ToolPosition")

                if v398 then

                    for v401, v402 in ipairs(getconnections(v398.Activated)) do

                        local v403 = v402

                        pcall(function()
                            v403.Function()
                        end)
                    end
                    for _, v in ipairs(getconnections(v398.MouseButton1Click)) do
                        local v406 = v

                        pcall(function()
                            v406.Function()
                        end)
                    end
                end
            end
        end)
    end
end
function t2.value22(p11)
    local u115 = p11
    t2.value21()
    pcall(function()
        if mouse1click then
            mouse1click()
        end

        local vector2 = Vector2.new(t2.value11.ViewportSize.X / 2, t2.value11.ViewportSize.Y / 2)

        t2.value7:Button1Down(vector2)
        t2.value7:Button1Up(vector2)
        t2.value8:SendMouseButtonEvent(100, 200, 0, true, game, 1)
        t2.value8:SendMouseButtonEvent(100, 200, 0, false, game, 1)

        local v412 = t2.value18()

        if v412 then
            local Tool = v412:FindFirstChildOfClass("Tool")

            if Tool then
                Tool:Activate()
            end
        end

        if t2.value12.InstantKillDamage and u115 then
            local Humanoid = u115:FindFirstChildOfClass("Humanoid")

            if Humanoid and Humanoid.Health > 0 then
                Humanoid:TakeDamage(50)
            end
        end
    end)
end
function t2.value23(p12)
    local v117 = (p12:match("^(%w+)") or p12):lower()

    for _, descendant in ipairs(t2.value3:GetDescendants()) do
        if not (descendant:IsA("Model") and descendant.Name:lower():find(v117)) then
            continue
        end

        local v120 = descendant:FindFirstChild("HumanoidRootPart") or descendant.PrimaryPart

        if v120 then
            return descendant, v120
        end
    end

    return nil, nil
end
function t2.value24(p13)
    if not t2.value12.AutoQuestBeforeFarm then
        return
    end

    if os.clock() - t2.value12.LastQuestAttemptTime < 4 then
        return
    end

    t2.value12.LastQuestAttemptTime = os.clock()
    pcall(function()
        local Event = game.ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent.Event

        Event:FireServer("GetQuest", p13)
        Event:FireServer("AcceptQuest", p13)
        Event:FireServer("ClaimQuest", p13)
    end)
end
function t2.value25(p14, p15, p16, p17, p18)
    local v68 = not p14

    if not v68 then
        v68 = not p14.Parent
    end

    if v68 then
        return
    end

    local v69 = p14:IsA("BasePart") and p14

    if not v69 then
        v69 = p14:FindFirstChild("HumanoidRootPart")

        if not v69 then
            v69 = p14.PrimaryPart

            if not v69 then
                v69 = p14:FindFirstChildWhichIsA("BasePart")
            end
        end
    end

    if not v69 then
        return
    end

    local v70 = t2.value13[p14]

    if v70 then
        if v70.label then
            v70.label.Text = p15
        end

        local highlight = v70.highlight

        if highlight then
            highlight = v70.highlight.Parent
        end

        if highlight then
            v70.highlight.FillColor = p16
            v70.highlight.Enabled = true

            return
        end

        pcall(function()
            local Highlight = Instance.new("Highlight")

            Highlight.Name = "AM_ESP_Highlight"
            Highlight.Adornee = p14
            Highlight.FillColor = p16
            Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            Highlight.FillTransparency = 0.4
            Highlight.OutlineTransparency = 0
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.Enabled = true
            Highlight.Parent = p14
            v70.highlight = Highlight
        end)

        return
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "AM_ESP_Highlight"
    Highlight.Adornee = p14
    Highlight.FillColor = p16
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 0.4
    Highlight.OutlineTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Enabled = true
    pcall(function()
        Highlight.Parent = p14
    end)

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "AM_ESP_Billboard"
    BillboardGui.Adornee = v69
    BillboardGui.Size = UDim2.new(0, 120, 0, 35)
    BillboardGui.StudsOffset = Vector3.new(0, 3.2, 0)
    BillboardGui.AlwaysOnTop = true

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = p16
    TextLabel.TextStrokeTransparency = 0
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextSize = 13
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.Text = p15
    TextLabel.Parent = BillboardGui
    pcall(function()
        BillboardGui.Parent = p14
    end)

    local value13 = t2.value13

    if not p18 then
        p18 = p17 and "chest"

        if not p18 then
            p18 = "mob"
        end
    end

    value13[p14] = {
		highlight = Highlight,
		billboard = BillboardGui,
		label = TextLabel,
		isChest = p17,
		category = p18
	}
end
function t2.value26(p19)
    for k, v in pairs(t2.value13) do
        local v124 = v

        if p19 == v124.category then
            pcall(function()
                if v124.highlight then
                    v124.highlight:Destroy()
                end

                if v124.billboard then
                    v124.billboard:Destroy()
                end
            end)
            t2.value13[k] = nil
        end
    end
end
task.spawn(function()
    while true do
        task.wait(1)
        if t2.value12.IsUnloaded then
            break
        end
        for v130, v131 in pairs(t2.value13) do

            local v132 = v131
            local v133 = not v130.Parent

            if not v133 then
                v133 = not v132.isChest

                if v133 then
                    v133 = v130:FindFirstChildOfClass("Humanoid")

                    if v133 then
                        v133 = v130:FindFirstChildOfClass("Humanoid").Health <= 0
                    end
                end
            end

            if v133 then
                pcall(function()
                    if v132.highlight then
                        v132.highlight:Destroy()
                    end

                    if v132.billboard then
                        v132.billboard:Destroy()
                    end
                end)
                t2.value13[v130] = nil
            end
        end
        local v134 = t2.value18()
        if v134 then
            local HumanoidRootPart = v134:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                HumanoidRootPart = v134:FindFirstChild("UpperTorso")
            end

            v134 = HumanoidRootPart
        end
        if v134 then
            if t2.value12.PlayerESPEnabled then
                for _, player in ipairs(t2.value2:GetPlayers()) do
                    if player ~= t2.value10 and player.Character then
                        local Character = player.Character
                        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                        if Humanoid and Humanoid.Health > 0 then
                            local floor = math.floor
                            local GetPivot = Character.GetPivot
                            local v142 = floor((v134.Position - GetPivot(Character).Position).Magnitude)

                            t2.value25(Character, player.Name .. " [" .. v142 .. "m]", t2.value12.PlayerESPColor, false, "player")
                        end
                    end
                end
            end

            local MobESPEnabled = t2.value12.MobESPEnabled

            if not MobESPEnabled then
                MobESPEnabled = t2.value12.BossESPEnabled
            end

            if MobESPEnabled then
                for _, v in ipairs((v41())) do
                    local Humanoid = v:FindFirstChildOfClass("Humanoid")
                    local v147 = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                    local v148 = Humanoid

                    if Humanoid then
                        v148 = Humanoid.Health > 0 and v147
                    end

                    if v148 then
                        local v149 = v39(v.Name)
                        local v150 = math.floor((v134.Position - v147.Position).Magnitude)
                        local v151 = v149

                        if v149 then
                            v151 = t2.value12.BossESPEnabled
                        end

                        if v151 then
                            t2.value25(v, "👑 " .. v.Name .. " [HP:" .. math.floor(Humanoid.Health) .. "]", t2.value12.BossESPColor, false, "boss")
                        else
                            local v152 = not v149

                            if v152 then
                                v152 = t2.value12.MobESPEnabled
                            end

                            if v152 then
                                t2.value25(v, v.Name .. " [" .. v150 .. "m]", t2.value12.MobESPColor, false, "mob")
                            end
                        end
                    end
                end
            end

            if t2.value12.ChestESPEnabled then
                local Chests = t2.value3:FindFirstChild("Chests")

                if not Chests then
                    Chests = t2.value3:FindFirstChild("Debree")
                end

                if Chests then
                    local _ipairs = ipairs
                    for _, v156 in _ipairs(Chests:GetDescendants()) do
                        local v157 = v156.Name:lower():find("chest")

                        if v157 then
                            v157 = v156:IsA("Model") or v156:IsA("BasePart")
                        end

                        if v157 then
                            t2.value25(v156, "📦 Chest", t2.value12.ChestESPColor, true, "chest")
                        end
                    end
                end

                local LootDrops = t2.value3:FindFirstChild("LootDrops")

                if LootDrops then
                    for _, child in ipairs(LootDrops:GetChildren()) do
                        t2.value25(child, "💎 " .. child.Name, t2.value12.ChestESPColor, true, "chest")
                    end
                end
            end
        end
    end
end)
t2.value4.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.X then
        t2.value12.AutoFarm = not t2.value12.AutoFarm
        t2.value1:Notify("Auto Farm [Key X]", not t2.value12.AutoFarm and "Farm OFF!" or "Farm ON!", 2)
    end
end)
v10:AddLabel("Combat, Kill Aura & Survival Controls")
v10:AddToggle("Auto Attack", {
	Default = false
}, function(p20)
    t2.value12.AutoAttack = p20

    if p20 then
        t2.value1:Notify("Combat", "Auto Attack enabled!", 2)
    end
end)
v10:AddSlider("Auto Attack Range (Studs)", {
	Min = 5,
	Max = 100,
	Default = 30
}, function(p21)
    t2.value12.AttackRange = p21
end)
v10:AddSlider("Attack Interval (Seconds)", {
	Min = 0.04,
	Max = 1,
	Default = 0.08
}, function(p22)
    t2.value12.AttackInterval = p22
end)
v10:AddToggle("💀 Kill Aura", {
	Default = false
}, function(p23)
    t2.value12.KillAura = p23

    if p23 then
        t2.value1:Notify("Kill Aura", "Kill Aura enabled!", 2)
    end
end)
v10:AddSlider("Kill Aura Radius (Studs)", {
	Min = 5,
	Max = 150,
	Default = 35
}, function(p24)
    t2.value12.KillAuraRadius = p24
end)
v10:AddToggle("⚡ Instant Kill / Fast Attack Damage", {
	Default = false
}, function(p25)
    t2.value12.InstantKillDamage = p25
end)
v10:AddToggle("⚡ Infinite Stamina (Always 125)", {
	Default = false
}, function(p26)
    t2.value12.InfiniteStamina = p26
end)
v10:AddToggle("🛡\239\184\143 Anti-Stun / Anti-Ragdoll", {
	Default = false
}, function(p27)
    t2.value12.AntiStun = p27
end)
v10:AddToggle("⭐ God Mode (Auto Health Regen / Anti-Damage)", {
	Default = false
}, function(p28)
    t2.value12.GodMode = p28
end)
v10:AddToggle("🚨 Auto Emergency Safe Zone (Low HP)", {
	Default = false
}, function(p29)
    t2.value12.AutoEmergencySafe = p29
end)
v10:AddSlider("Pause Farm Below HP (%)", {
	Min = 10,
	Max = 60,
	Default = 30
}, function(p30)
    t2.value12.EmergencyHPThreshold = p30
end)
v10:AddSlider("Resume Farm Above HP (%)", {
	Min = 70,
	Max = 100,
	Default = 85
}, function(p31)
    t2.value12.ResumeAboveHP = p31
end)
v10:AddLabel("👑 Boss Hunting & Live Scanner")
t2.value27 = v10:AddLabel("Detected Bosses: Scanning...")
v10:AddToggle("👑 Auto Boss Hunt (Dedicated Mode)", {
	Default = false
}, function(p32)
    t2.value12.AutoBossHunt = p32
    t2.value12.BossOnlyMode = p32

    if p32 then
        t2.value1:Notify("Boss Hunt", "Hunting bosses only!", 3)
    end
end)
v10:AddDropdown("Select Target Boss", {
	Values = {
		"Zuko",
		"Reaper",
		"Datai",
		"Gyutai",
		"Saneri",
		"Akazo",
		"Domae",
		"Muzan",
		"Akaza",
		"Hand Demon"
	},
	Default = "Zuko",
	Multi = false
}, function(p33)
    t2.value12.SelectedBossTarget = p33
end)
v10:AddButton("🚀 Teleport to Selected Boss", function()
    local v177 = t2.value20(t2.value12.SelectedBossTarget)

    if v177 then
        local v178 = v177:FindFirstChild("HumanoidRootPart") or v177.PrimaryPart
        local v179 = v38()

        if v179 and v178 then
            v179.CFrame = v178.CFrame + Vector3.new(0, 5, 0)
            t2.value1:Notify("Boss Teleport", "Teleported to " .. v177.Name, 3)

            return
        end
    else
        t2.value1:Notify("Boss Teleport", "Boss " .. t2.value12.SelectedBossTarget .. " not alive right now.", 3)
    end
end)
v10:AddButton("🔄 Refresh Live Boss List", function()
    local t6 = {}
    for v183, v184 in ipairs((v41())) do

        if v39(v184.Name) then
            local Humanoid = v184:FindFirstChildOfClass("Humanoid")
            local insert = table.insert
            local Name = v184.Name
            local floor = math.floor

            if Humanoid then
                Humanoid = Humanoid.Health
            end

            insert(t6, Name .. " (" .. floor(Humanoid or 0) .. "HP)")
        end
    end
    if #t6 > 0 then
        t2.value27:Set("Live Bosses: " .. table.concat(t6, ", "))

        return
    end
    t2.value27:Set("Live Bosses: None detected.")
end)
task.spawn(function()
    while true do
        task.wait(0.1)

        if t2.value12.IsUnloaded then
            break
        end

        pcall(function()
            local v415 = t2.value18()

            if v415 and v415:FindFirstChildOfClass("Humanoid") then
                local Humanoid = v415:FindFirstChildOfClass("Humanoid")

                if t2.value12.GodMode then
                    Humanoid.Health = Humanoid.MaxHealth
                end

                if t2.value12.InfiniteStamina then
                    local value10Name = t2.value10.Name
                    local value10Name2 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(value10Name)

                    if value10Name2 and value10Name2:FindFirstChild("Stamina") then
                        value10Name2.Stamina.Value = 125
                    end
                end

                if t2.value12.AntiStun and v415:FindFirstChild("RagdollConstraints") then
                    for _, child in ipairs(v415.RagdollConstraints:GetChildren()) do
                        child:Destroy()
                    end
                end

                if t2.value12.AutoEmergencySafe and Humanoid.Health > 0 then
                    local v421 = Humanoid.Health / Humanoid.MaxHealth * 100
                    local v422 = v421 <= t2.value12.EmergencyHPThreshold

                    if v422 then
                        v422 = t2.value12.AutoFarm
                    end

                    if v422 then
                        t2.value12.AutoFarm = false

                        local v423 = t2.value18()

                        if v423 then
                            local HumanoidRootPart = v423:FindFirstChild("HumanoidRootPart")

                            if not HumanoidRootPart then
                                HumanoidRootPart = v423:FindFirstChild("UpperTorso")
                            end

                            v423 = HumanoidRootPart
                        end

                        if v423 then
                            v423.CFrame = t2.value14
                            t2.value1:Notify("EMERGENCY", "HP Low (" .. math.floor(v421) .. "%). Farm paused at Sanctuary!", 4)

                            return
                        end
                    else
                        local v425 = v421 >= t2.value12.ResumeAboveHP

                        if v425 then
                            v425 = not t2.value12.AutoFarm

                            if v425 then
                                v425 = t2.value12.AutoEmergencySafe
                            end
                        end

                        if v425 then
                            t2.value12.AutoFarm = true
                            t2.value1:Notify("EMERGENCY", "HP Restored (" .. math.floor(v421) .. "%). Farm resumed!", 3)
                        end
                    end
                end
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(t2.value12.AttackInterval)

        if t2.value12.IsUnloaded then
            break
        end

        local v189 = v38()
        local v190 = v189

        if v189 then
            v190 = t2.value12.AutoAttack

            if not v190 then
                v190 = t2.value12.KillAura
            end
        end

        if v190 then
            local KillAura = t2.value12.KillAura

            if KillAura then
                KillAura = t2.value12.KillAuraRadius
            end

            if not KillAura then
                KillAura = t2.value12.AttackRange
            end

            for _, v in ipairs((v41())) do
                local v194 = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                local v195 = v194
                local Humanoid = v:FindFirstChildOfClass("Humanoid")

                if v194 then
                    v195 = Humanoid and Humanoid.Health > 0
                end

                if v195 and KillAura >= (v189.Position - v194.Position).Magnitude then
                    t2.value22(v)
                end
            end
        end
    end
end)
t2.value28 = v11:AddLabel("Status: Idle  [Press 'X' to toggle farm]")
v11:AddDropdown("Select Enemy Type", {
	Values = t3,
	Default = "All",
	Multi = false
}, function(p34)
    t2.value12.SelectedMob = p34
end)
v11:AddTextBox("Custom Target Name", function(p35)
    t2.value12.CustomMobText = p35
end)
v11:AddToggle("Exact Target Name Match", {
	Default = false
}, function(p36)
    t2.value12.ExactTargetName = p36
end)
v11:AddTextBox("Blacklist Filter (comma separated)", function(p37)
    t2.value12.BlacklistFilter = p37
end)
v11:AddToggle("🌾 Auto Farm  [Key: X]", {
	Default = false
}, function(p38)
    t2.value12.AutoFarm = p38

    if p38 then
        t2.value28:Set("Status: Farming... [Press X to stop]")
        t2.value1:Notify("Auto Farm", "Started! (Press X to stop)", 3)

        return
    end

    t2.value28:Set("Status: Idle  [Press 'X' to toggle farm]")
    t2.value1:Notify("Auto Farm", "Stopped.", 2)
end)
v11:AddToggle("📜 Auto Quest BEFORE Farm", {
	Default = false
}, function(p39)
    t2.value12.AutoQuestBeforeFarm = p39
end)
v11:AddToggle("⭐ Auto Next KILL Quest by Level", {
	Default = false
}, function(p40)
    t2.value12.AutoNextKillQuest = p40
end)
v11:AddToggle("🔒 Lock Quest Target Until Death", {
	Default = false
}, function(p41)
    t2.value12.LockQuestTarget = p41
end)
v11:AddToggle("Ghost Noclip While Farming", {
	Default = true
}, function(p42)
    t2.value12.NoclipWhileFarming = p42
end)
v11:AddDropdown("Farm Style Position", {
	Values = {
		"Behind",
		"Above",
		"Cycle"
	},
	Default = "Behind",
	Multi = false
}, function(p43)
    t2.value12.FarmStyle = p43
end)
v11:AddDropdown("Target Priority", {
	Values = {
		"Nearest",
		"Lowest HP"
	},
	Default = "Nearest",
	Multi = false
}, function(p44)
    t2.value12.FarmPriority = p44
end)
v11:AddSlider("Horizontal Distance (Studs)", {
	Min = 0.5,
	Max = 10,
	Default = 1.2
}, function(p45)
    t2.value12.FarmDistance = p45
end)
v11:AddSlider("Height Offset (Studs)", {
	Min = -5,
	Max = 15,
	Default = 0
}, function(p46)
    t2.value12.FarmHeight = p46
end)
v11:AddSlider("Max Target Search Distance", {
	Min = 500,
	Max = 5000,
	Default = 2500
}, function(p47)
    t2.value12.MaxTargetDistance = p47
end)
v11:AddToggle("🧲 Bring Mobs (Pull Enemies)", {
	Default = false
}, function(p48)
    t2.value12.BringMobs = p48
end)
v11:AddToggle("❄\239\184\143 Freeze Pulled Mobs", {
	Default = false
}, function(p49)
    t2.value12.FreezeMobs = p49
end)
v11:AddSlider("Bring Radius (Studs)", {
	Min = 10,
	Max = 100,
	Default = 40
}, function(p50)
    t2.value12.BringRadius = p50
end)
v11:AddSlider("Max Bring Mobs Limit", {
	Min = 1,
	Max = 15,
	Default = 6
}, function(p51)
    t2.value12.MaxBringMobs = p51
end)
v11:AddToggle("Auto Skills (Z, X, C, V)", {
	Default = false
}, function(p52)
    t2.value12.AutoSkills = p52
end)
v11:AddToggle("Auto Return Quest When Done", {
	Default = false
}, function(p53)
    t2.value12.AutoReturnQuest = p53
end)
v11:AddToggle("Quest Stuck Recovery", {
	Default = false
}, function(p54)
    t2.value12.QuestStuckRecovery = p54
end)
v11:AddButton("Teleport to Nearest Enemy", function()
    local v218 = t2.value20(t2.value12.SelectedMob)

    if v218 then
        local v219 = v218:FindFirstChild("HumanoidRootPart") or v218.PrimaryPart
        local v220 = t2.value18()

        if v220 then
            local HumanoidRootPart = v220:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                HumanoidRootPart = v220:FindFirstChild("UpperTorso")
            end

            v220 = HumanoidRootPart
        end

        if v220 and v219 then
            v220.CFrame = CFrame.new(v219.Position + Vector3.new(0, 0, 2), v219.Position)
            t2.value1:Notify("Teleport", "Teleported to: " .. v218.Name, 3)

            return
        end
    else
        t2.value1:Notify("Teleport", "No enemy found.", 2)
    end
end)
task.spawn(function()
    local t7 = {
		Enum.KeyCode.Z,
		Enum.KeyCode.X,
		Enum.KeyCode.C,
		Enum.KeyCode.V
	}
    local n1 = 0

    while true do
        task.wait(0.06)

        if t2.value12.IsUnloaded then
            break
        end

        local v224 = v38()

        if v224 then
            local AutoFarm = t2.value12.AutoFarm

            if AutoFarm then
                AutoFarm = t2.value12.NoclipWhileFarming
            end

            if AutoFarm then
                local Character = t2.value10.Character

                if Character then
                    local GetDescendants = Character.GetDescendants

                    for _, v in ipairs(GetDescendants(Character)) do
                        if v:IsA("BasePart") and v.CanCollide then
                            v.CanCollide = false
                        end
                    end
                end
            end

            if t2.value12.BringMobs then
                local n2 = 0

                for _, v in ipairs((v41())) do
                    if n2 >= t2.value12.MaxBringMobs then
                        break
                    end

                    local v233 = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                    local v234 = v233

                    if v234 then
                        v234 = (v224.Position - v233.Position).Magnitude <= t2.value12.BringRadius
                    end

                    if v234 then
                        n2 += 1
                        pcall(function()
                            v233.CFrame = v224.CFrame * CFrame.new(0, 0, -3)
                            v233.AssemblyLinearVelocity = Vector3.zero

                            if t2.value12.FreezeMobs then
                                v233.Anchored = true
                            end
                        end)
                    end
                end
            end

            if t2.value12.AutoFarm then
                local v235 = t2.value20(t2.value12.SelectedMob)

                if v235 then
                    local Humanoid = v235:FindFirstChildOfClass("Humanoid")
                    local v237 = v235:FindFirstChild("HumanoidRootPart") or v235.PrimaryPart
                    local v238 = Humanoid

                    if Humanoid then
                        v238 = Humanoid.Health > 0 and v237
                    end

                    if v238 then
                        t2.value28:Set("Farming: " .. v235.Name .. "  [HP: " .. math.floor(Humanoid.Health) .. "]")
                        t2.value24(v235.Name)
                        pcall(function()
                            local Position = v237.Position
                            local cFrame12

                            if t2.value12.FarmStyle == "Above" then
                                cFrame12 = CFrame.new(v237.Position + Vector3.new(0, 3 + t2.value12.FarmHeight, 0), Position)
                            elseif t2.value12.FarmStyle == "Cycle" then
                                t2.value12.CycleAngle = (t2.value12.CycleAngle + 0.15) % (2 * 3.141592653589793)

                                local vector3 = Vector3.new(math.cos(t2.value12.CycleAngle) * t2.value12.FarmDistance, t2.value12.FarmHeight, math.sin(t2.value12.CycleAngle) * t2.value12.FarmDistance)

                                cFrame12 = CFrame.new(v237.Position + vector3, Position)
                            else
                                local LookVector = v237.CFrame.LookVector
                                local FarmDistance = t2.value12.FarmDistance
                                local _CFrame = CFrame
                                local v432 = LookVector * -FarmDistance

                                cFrame12 = _CFrame.new(v237.Position + v432 + Vector3.new(0, t2.value12.FarmHeight, 0), Position)
                            end

                            v224.CFrame = cFrame12
                            v224.AssemblyLinearVelocity = Vector3.zero
                            t2.value11.CFrame = CFrame.new(t2.value11.CFrame.Position, v237.Position)
                        end)
                        t2.value22(v235)

                        local AutoSkills = t2.value12.AutoSkills

                        if AutoSkills then
                            AutoSkills = os.clock() - n1 > 2.5
                        end

                        if AutoSkills then
                            n1 = os.clock()

                            for _, v in ipairs(t7) do
                                local v242 = v

                                pcall(function()
                                    t2.value8:SendKeyEvent(true, v242, false, game)
                                    task.wait(0.03)
                                    t2.value8:SendKeyEvent(false, v242, false, game)
                                end)
                            end
                        end
                    else
                        t2.value28:Set("Waiting for spawn...")
                    end
                else
                    t2.value28:Set("Waiting for spawn...")
                end
            end
        end
    end
end)
v12:AddLabel("Instant Training & Quick Trainer Teleports")
v12:AddDropdown("Select Training Station", {
	Values = {
		"Pushups",
		"Meditation",
		"Boulder Push",
		"Boulder Split",
		"Aim Training",
		"Cup Game",
		"Squat Rack"
	},
	Default = "Pushups",
	Multi = false
}, function(p55)
    t2.value12.SelectedFacility = p55
end)

local function v42(p56)
    local v245 = t2.value18()

    if v245 then
        local HumanoidRootPart = v245:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            HumanoidRootPart = v245:FindFirstChild("UpperTorso")
        end

        v245 = HumanoidRootPart
    end

    local v247 = v245
    local Training = t2.value3:FindFirstChild("Training")

    if v247 and Training then
        local p56_2 = Training:FindFirstChild(p56)

        if p56_2 then
            local BasePart = p56_2:FindFirstChildWhichIsA("BasePart", true)

            if BasePart then
                pcall(function()
                    v247.CFrame = BasePart.CFrame + Vector3.new(0, 3, 0)
                end)
                task.wait(0.2)

                local ProximityPrompt = p56_2:FindFirstChildWhichIsA("ProximityPrompt", true)

                if ProximityPrompt and fireproximityprompt then
                    fireproximityprompt(ProximityPrompt)
                    t2.value1:Notify("Training", "Completed: " .. p56, 3)

                    return true
                end
            end
        end
    end

    t2.value1:Notify("Warning", "Station not found: " .. p56, 3)

    return false
end
v12:AddButton("⚡ Train Now", function()
    v42(t2.value12.SelectedFacility)
end)
v12:AddToggle("Auto Training (Loop)", {
	Default = false
}, function(p57)
    t2.value12.AutoTraining = p57

    if p57 then
        t2.value1:Notify("Training", "Auto training started!", 2)
    end
end)
v12:AddButton("🌊 Teleport Water Trainer (Sabito)", function()
    local v253 = t2.value20("Water Trainee Sabito")
    local v254 = t2.value18()

    if v254 then
        local HumanoidRootPart = v254:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            HumanoidRootPart = v254:FindFirstChild("UpperTorso")
        end

        v254 = HumanoidRootPart
    end

    if v253 and v254 then
        local v256 = v253:FindFirstChild("HumanoidRootPart") or v253.PrimaryPart

        if v256 then
            v254.CFrame = v256.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)
v12:AddButton("⚡ Teleport Thunder Trainer", function()
    local v257 = t2.value20("Thunder Trainee")
    local v259 = t2.value18()
    if v259 then
        local HumanoidRootPart = v259:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            HumanoidRootPart = v259:FindFirstChild("UpperTorso")
        end

        v259 = HumanoidRootPart
    end
    if v257 and v259 then
        local v261 = v257:FindFirstChild("HumanoidRootPart") or v257.PrimaryPart

        if v261 then
            v259.CFrame = v261.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)
v12:AddButton("🔥 Teleport Flame Trainer", function()
    local v262 = t2.value20("Flame Trainee")
    local v264 = t2.value18()
    if v264 then
        local HumanoidRootPart = v264:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            HumanoidRootPart = v264:FindFirstChild("UpperTorso")
        end

        v264 = HumanoidRootPart
    end
    if v262 and v264 then
        local v266 = v262:FindFirstChild("HumanoidRootPart") or v262.PrimaryPart

        if v266 then
            v264.CFrame = v266.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)
v12:AddButton("🌪\239\184\143 Teleport Wind Trainer", function()
    local v267 = t2.value20("Wind Trainee")
    local v269 = t2.value18()
    if v269 then
        local HumanoidRootPart = v269:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            HumanoidRootPart = v269:FindFirstChild("UpperTorso")
        end

        v269 = HumanoidRootPart
    end
    if v267 and v269 then
        local v271 = v267:FindFirstChild("HumanoidRootPart") or v267.PrimaryPart

        if v271 then
            v269.CFrame = v271.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(1.5)

        if t2.value12.IsUnloaded then
            break
        end

        if t2.value12.AutoTraining then
            v42(t2.value12.SelectedFacility)
        end
    end
end)
v13:AddLabel("NPC Teleports & Remote Interactions")
v13:AddDropdown("Select NPC / Trainer", {
	Values = {
		"Raze (Weapons Shop)",
		"Rika (Potions Shop)",
		"Kona (Quest NPC)",
		"Noote (NPC)",
		"Lucy (NPC)",
		"MoldySugar (NPC)",
		"Kazu (NPC)",
		"Blacksmith Togane",
		"Alchemist Meku",
		"Dock Master"
	},
	Default = "Raze (Weapons Shop)",
	Multi = false
}, function(p58)
    t2.value12.SelectedNPC = p58
end)
v13:AddButton("🚀 Teleport to Selected NPC", function()
    local v273, v274 = t2.value23(t2.value12.SelectedNPC)

    if v273 and v274 then
        local v275 = t2.value18()

        if v275 then
            local HumanoidRootPart = v275:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                HumanoidRootPart = v275:FindFirstChild("UpperTorso")
            end

            v275 = HumanoidRootPart
        end

        if v275 then
            v275.CFrame = v274.CFrame + Vector3.new(0, 3, 0)
            t2.value1:Notify("NPC Teleport", "Teleported to: " .. v273.Name, 3)

            return
        end
    else
        t2.value1:Notify("Warning", "NPC " .. t2.value12.SelectedNPC .. " not found nearby.", 3)
    end
end)
v13:AddDropdown("Select Item to Buy", {
	Values = {
		"Health Regen Potion",
		"Stamina Regen Potion",
		"Fancy Katana"
	},
	Default = "Health Regen Potion",
	Multi = false
}, function(p59)
    t2.value12.SelectedShopItem = p59
end)
v13:AddButton("🛒 Remote Buy Selected Item", function()
    pcall(function()
        local SelectedShopItem = t2.value12.SelectedShopItem
        local v434 = t2.value18()

        if v434 then
            local HumanoidRootPart = v434:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                HumanoidRootPart = v434:FindFirstChild("UpperTorso")
            end

            v434 = HumanoidRootPart
        end

        for _, descendant in ipairs(t2.value3:GetDescendants()) do
            if not (descendant:IsA("ProximityPrompt") and descendant.Parent) then
                continue
            end

            local ParentName = descendant.Parent.Name
            local lower = SelectedShopItem.lower

            if ParentName:lower():find(lower(SelectedShopItem)) then
                local v440 = v434

                if v434 then
                    v440 = descendant.Parent:IsA("BasePart")
                end

                if not v440 then
                    continue
                end

                local CFrame2 = v434.CFrame

                v434.CFrame = descendant.Parent.CFrame + Vector3.new(0, 2, 0)
                task.wait(0.15)

                if fireproximityprompt then
                    fireproximityprompt(descendant)
                end

                task.wait(0.15)
                v434.CFrame = CFrame2
                t2.value1:Notify("Remote Shop", "Purchased: " .. SelectedShopItem, 3)

                return
            end
        end

        t2.value1:Notify("Warning", "Item prompt for " .. SelectedShopItem .. " not found in map.", 3)
    end)
end)
v13:AddButton("🔨 Open Blacksmith Togane (Crafting)", function()
    pcall(function()
        local v442, v443 = t2.value23("Togane")

        if v443 then
            v443 = fireproximityprompt
        end

        if v443 then
            local ProximityPrompt = v442:FindFirstChildWhichIsA("ProximityPrompt", true)

            if ProximityPrompt then
                fireproximityprompt(ProximityPrompt)
            end
        end

        t2.value1:Notify("Crafting", "Togane interaction sent!", 3)
    end)
end)
v13:AddButton("🧪 Open Alchemist Meku", function()
    pcall(function()
        local v445, v446 = t2.value23("Meku")

        if v446 then
            v446 = fireproximityprompt
        end

        if v446 then
            local ProximityPrompt = v445:FindFirstChildWhichIsA("ProximityPrompt", true)

            if ProximityPrompt then
                fireproximityprompt(ProximityPrompt)
            end
        end

        t2.value1:Notify("Alchemist", "Meku interaction sent!", 3)
    end)
end)
v13:AddButton("📜 Print Crafting Recipes to Console", function()
    print("=== SLAYERS 2 CRAFTING RECIPES ===")
    print("- Fancy Katana: 1x Katana + 10x Ore + 500 Wen")
    print("- Health Regen Potion: 2x Spider Lily + 100 Wen")
    print("- Stamina Regen Potion: 2x Blue Herb + 100 Wen")
    t2.value1:Notify("Console", "Crafting recipes printed to console (F9)!", 3)
end)
v14:AddLabel("Infinite Spin — Race, Clan & Conversions")
v14:AddDropdown("Target Race", {
	Values = {
		"Human",
		"Demon",
		"Slayer",
		"Hybrid"
	},
	Default = "Demon",
	Multi = false
}, function(p60)
    t2.value12.TargetRace = p60
end)
v14:AddToggle("🔄 Infinite Spin — Race", {
	Default = false
}, function(p61)
    t2.value12.AutoSpinRace = p61

    if p61 then
        t2.value1:Notify("Spin", "Spinning race until: " .. t2.value12.TargetRace, 3)
    end
end)
v14:AddDropdown("Target Clan", {
	Values = {
		"Kamado",
		"Sabito",
		"Rengoku",
		"Agatsuma",
		"Hashibira",
		"Tomioka",
		"Kochou",
		"Shinazugawa",
		"Tokito",
		"Iguro",
		"Kanroji",
		"Himejima",
		"Tsugikuni",
		"Kibutsuji"
	},
	Default = "Kamado",
	Multi = false
}, function(p62)
    t2.value12.TargetClan = p62
end)
v14:AddDropdown("Stop on Clan Rarity", {
	Values = {
		"Any",
		"Common",
		"Rare",
		"Legendary",
		"Mythic",
		"Supreme"
	},
	Default = "Mythic",
	Multi = false
}, function(p63)
    t2.value12.StopOnRarity = p63
end)
v14:AddButton("🎲 Spin Clan Once (Direct)", function()
    pcall(function()
        game.ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent.Event:FireServer("SpinClan")
        t2.value1:Notify("Spin", "Clan spun 1 time!", 2)
    end)
end)
v14:AddToggle("🔄 Auto Spin Clan", {
	Default = false
}, function(p64)
    t2.value12.AutoSpinClan = p64

    if p64 then
        t2.value1:Notify("Spin", "Spinning clan until: " .. t2.value12.TargetClan, 3)
    end
end)
v14:AddButton("🗡\239\184\143 Auto Become Slayer", function()
    pcall(function()
        game.ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent.Event:FireServer("BecomeSlayer")
        t2.value1:Notify("Class", "Become Slayer request sent!", 3)
    end)
end)
v14:AddButton("🩸 Auto Become Demon", function()
    pcall(function()
        game.ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent.Event:FireServer("BecomeDemon")
        t2.value1:Notify("Class", "Become Demon request sent!", 3)
    end)
end)
v14:AddButton("❤\239\184\143 Restore Full Health", function()
    local v283 = t2.value18()

    if v283 then
        local Humanoid = v283:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.Health = Humanoid.MaxHealth
            t2.value1:Notify("Set", "Health restored!", 2)
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(0.8)

        if t2.value12.IsUnloaded then
            break
        end

        local AutoSpinRace = t2.value12.AutoSpinRace

        if not AutoSpinRace then
            AutoSpinRace = t2.value12.AutoSpinClan
        end

        if AutoSpinRace then
            pcall(function()
                local value10Name = t2.value10.Name
                local Slot1 = game.ReplicatedStorage.Player_Service.Data[value10Name].slots.Slot1
                local Event = game.ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent.Event

                if t2.value12.AutoSpinRace then
                    local Race = Slot1.Race

                    if Race then
                        Race = Slot1.Race.Value
                    end

                    if not Race then
                        Race = ""
                    end

                    if Race:lower() == t2.value12.TargetRace:lower() then
                        t2.value12.AutoSpinRace = false
                        t2.value1:Notify("Spin Success!", "Got race: " .. t2.value12.TargetRace, 6)
                    else
                        Event:FireServer("SpinRace")
                    end
                end

                if t2.value12.AutoSpinClan then
                    local Clan = Slot1.Clan

                    if Clan then
                        Clan = Slot1.Clan.Value
                    end

                    if (Clan or ""):lower() == t2.value12.TargetClan:lower() then
                        t2.value12.AutoSpinClan = false
                        t2.value1:Notify("Spin Success!", "Got clan: " .. t2.value12.TargetClan, 6)

                        return
                    end

                    Event:FireServer("SpinClan")
                end
            end)
        end
    end
end)
v15:AddLabel("Attribute Distribution & Mastery")
v15:AddDropdown("Target Attribute", {
	Values = {
		"Strength",
		"Stamina",
		"Health",
		"Weapon"
	},
	Default = "Strength",
	Multi = false
}, function(p65)
    t2.value12.TargetStatCategory = p65
end)
v15:AddToggle("Auto Apply Stat Points", {
	Default = false
}, function(p66)
    t2.value12.AutoStatPoints = p66
end)
v15:AddDropdown("Weapon Mastery", {
	Values = {
		"Sword",
		"Fists",
		"Breathing",
		"Demon Art"
	},
	Default = "Sword",
	Multi = false
}, function(p67)
    t2.value12.MasteryWeapon = p67
end)
v15:AddDropdown("Target Breathing Style", {
	Values = {
		"Water Breathing",
		"Thunder Breathing",
		"Flame Breathing",
		"Insect Breathing",
		"Serpent Breathing",
		"Stone Breathing",
		"Sound Breathing",
		"Wind Breathing"
	},
	Default = "Water Breathing",
	Multi = false
}, function(p68)
    t2.value12.TargetBreathing = p68
end)
v15:AddButton("Balance Stat Points Now", function()
    pcall(function()
        local Event = game.ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent.Event

        Event:FireServer("AddStatPoint", "Strength", 5)
        Event:FireServer("AddStatPoint", "Health", 5)
        Event:FireServer("AddStatPoint", "Stamina", 5)
        t2.value1:Notify("Attributes", "Stat points balanced!", 3)
    end)
end)
v15:AddButton("📜 Refresh & Print Mastery Progression", function()
    pcall(function()
        local value10Name = t2.value10.Name
        local Slot1 = game.ReplicatedStorage.Player_Service.Data[value10Name].slots.Slot1
        local v456 = Slot1

        if Slot1 then
            v456 = Slot1:FindFirstChild("MasteryProgressionList")
        end

        if v456 then
            print("=== MASTERY PROGRESSION LIST ===")

            for _, child in ipairs(Slot1.MasteryProgressionList:GetChildren()) do
                print("Mastery:", child.Name, "=", (tostring(child.Value)))
            end

            t2.value1:Notify("Mastery", "Printed mastery list to console (F9)!", 3)
        end
    end)
end)
task.spawn(function()
    while true do
        task.wait(1)

        if t2.value12.IsUnloaded then
            break
        end

        if t2.value12.AutoStatPoints then
            pcall(function()
                game.ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent.Event:FireServer("AddStatPoint", t2.value12.TargetStatCategory, 1)
            end)
        end
    end
end)
v16:AddLabel("Speed, Jump, Fly & Horse Controls")
v16:AddToggle("Enable Speed", {
	Default = false
}, function(p69)
    t2.value12.SpeedEnabled = p69

    if not p69 then
        pcall(function()
            local Character = t2.value10.Character
            local v460 = Character and Character:FindFirstChildOfClass("Humanoid")

            if v460 then
                v460.WalkSpeed = 16
            end
        end)
    end
end)
v16:AddSlider("WalkSpeed", {
	Min = 16,
	Max = 300,
	Default = 16
}, function(p70)
    t2.value12.WalkSpeed = p70

    if t2.value12.SpeedEnabled then
        pcall(function()
            local Character = t2.value10.Character

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid")
            end

            if Character then
                Character.WalkSpeed = p70
            end
        end)
    end
end)
v16:AddToggle("Speed Lock (Anti-Slowdown)", {
	Default = false
}, function(p71)
    t2.value12.SpeedLock = p71
end)
v16:AddToggle("Enable Jump", {
	Default = false
}, function(p72)
    t2.value12.JumpEnabled = p72

    if not p72 then
        pcall(function()
            local Character = t2.value10.Character

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid")
            end

            if Character then
                Character.UseJumpPower = false
                Character.JumpPower = 50
            end
        end)
    end
end)
v16:AddSlider("JumpPower", {
	Min = 50,
	Max = 300,
	Default = 50
}, function(p73)
    t2.value12.JumpPower = p73

    if t2.value12.JumpEnabled then
        pcall(function()
            local Character = t2.value10.Character

            if Character then
                Character = Character:FindFirstChildOfClass("Humanoid")
            end

            if Character then
                Character.UseJumpPower = true
                Character.JumpPower = p73
            end
        end)
    end
end)
v16:AddToggle("Infinite Jump", {
	Default = false
}, function(p74)
    t2.value12.InfiniteJump = p74
end)
v16:AddToggle("Noclip (Phase Through Walls)", {
	Default = false
}, function(p75)
    t2.value12.Noclip = p75
end)
v16:AddToggle("🕊\239\184\143 Fly (WASD + Space/Ctrl)", {
	Default = false
}, function(p76)
    t2.value12.FlyEnabled = p76
end)
v16:AddSlider("Fly Speed", {
	Min = 20,
	Max = 250,
	Default = 60
}, function(p77)
    t2.value12.FlySpeed = p77
end)
v16:AddButton("🐴 Teleport to Nearest Horse", function()
    pcall(function()
        local v464 = t2.value18()

        if v464 then
            local HumanoidRootPart = v464:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                HumanoidRootPart = v464:FindFirstChild("UpperTorso")
            end

            v464 = HumanoidRootPart
        end

        local _ipairs = ipairs

        for _, v468 in _ipairs(t2.value3:GetDescendants()) do
            local v469 = v468.Name:lower():find("horse")

            if v469 then
                v469 = v468:IsA("Model")

                if not v469 then
                    v469 = v468:IsA("BasePart")
                end
            end

            if not v469 then
                continue
            end

            local v470 = v468:IsA("BasePart") and v468

            if not v470 then
                v470 = v468:FindFirstChild("HumanoidRootPart") or v468.PrimaryPart
            end

            if v470 and v464 then
                v464.CFrame = v470.CFrame + Vector3.new(0, 3, 0)
                t2.value1:Notify("Horse", "Teleported to horse!", 3)

                return
            end
        end

        t2.value1:Notify("Horse", "No riding horse found nearby.", 3)
    end)
end)
v16:AddButton("🏇 Ride Nearest Horse", function()
    pcall(function()
        for _, descendant in ipairs(t2.value3:GetDescendants()) do
            if not descendant.Name:lower():find("horse") then
                continue
            end

            local ProximityPrompt = descendant:FindFirstChildWhichIsA("ProximityPrompt", true)

            if ProximityPrompt and fireproximityprompt then
                fireproximityprompt(ProximityPrompt)
                t2.value1:Notify("Horse", "Rode nearest horse!", 3)

                return
            end
        end
    end)
end)
v16:AddLabel("🌍 Region & POI Teleports")
v16:AddDropdown("Select Map Region", {
	Values = {
		"Windy Peak",
		"Sanctuary",
		"Ouwland Plains",
		"Village / Hub",
		"Lake / Docks"
	},
	Default = "Windy Peak",
	Multi = false
}, function(p78)
    t2.value12.SelectedRegion = p78
end)
v16:AddButton("🚀 Teleport to Selected Region", function()
    local v300 = t2.value15[t2.value12.SelectedRegion]
    local v301 = t2.value18()

    if v301 then
        local HumanoidRootPart = v301:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            HumanoidRootPart = v301:FindFirstChild("UpperTorso")
        end

        v301 = HumanoidRootPart
    end

    if v300 and v301 then
        v301.CFrame = v300
        t2.value1:Notify("Region", "Teleported to " .. t2.value12.SelectedRegion, 3)
    end
end)
v16:AddDropdown("Select Special POI", {
	Values = {
		"Dock Master / Fishing",
		"Blacksmith Togane / Crafting",
		"Alchemist Meku",
		"Parkour Dungeon",
		"Grove Raid",
		"Muzan's Lair"
	},
	Default = "Dock Master / Fishing",
	Multi = false
}, function(p79)
    t2.value12.SelectedPOI = p79
end)
v16:AddButton("🚀 Teleport to Selected POI", function()
    local v304 = t2.value12.SelectedPOI or "Dock Master / Fishing"
    local v305 = t2.value16[v304]
    local v306 = t2.value18()

    if v306 then
        local HumanoidRootPart = v306:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            HumanoidRootPart = v306:FindFirstChild("UpperTorso")
        end

        v306 = HumanoidRootPart
    end

    if v305 and v306 then
        v306.CFrame = v305
        t2.value1:Notify("POI", "Teleported to " .. v304, 3)
    end
end)

local function v43()
    local t8 = {}

    for _, player in ipairs(t2.value2:GetPlayers()) do
        if player ~= t2.value10 then
            table.insert(t8, player.Name)
        end
    end

    if #t8 == 0 then
        table.insert(t8, "No Other Players")
    end

    return t8
end
local AddDropdown = v16.AddDropdown
local v45 = v43()
local v46 = v43()[1]

AddDropdown(v16, "Select Player to Teleport To", {
	Values = v45,
	Default = v46,
	Multi = false
}, function(p80)
    t2.value12.SelectedPlayerToTP = p80
end)
v16:AddButton("Teleport to Selected Player", function()
    local t2value12SelectedPlayerToTP = t2.value2:FindFirstChild(t2.value12.SelectedPlayerToTP)
    local v313 = t2value12SelectedPlayerToTP

    if t2value12SelectedPlayerToTP then
        v313 = t2value12SelectedPlayerToTP.Character

        if v313 then
            v313 = t2value12SelectedPlayerToTP.Character:FindFirstChild("HumanoidRootPart")
        end
    end

    if v313 then
        local v314 = t2.value18()

        if v314 then
            local HumanoidRootPart = v314:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                HumanoidRootPart = v314:FindFirstChild("UpperTorso")
            end

            v314 = HumanoidRootPart
        end

        if v314 then
            v314.CFrame = t2value12SelectedPlayerToTP.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            t2.value1:Notify("Teleport", "Teleported to " .. t2.value12.SelectedPlayerToTP, 3)
        end
    end
end)
v16:AddButton("🔄 Reset Movement (Default 16 / 50)", function()
    t2.value12.SpeedEnabled = false
    t2.value12.SpeedLock = false
    t2.value12.JumpEnabled = false
    t2.value12.FlyEnabled = false
    t2.value12.WalkSpeed = 16
    t2.value12.JumpPower = 50

    local v316 = t2.value18()
    local v317 = v316

    if v316 then
        v317 = v316:FindFirstChildOfClass("Humanoid")
    end

    if v317 then
        local Humanoid = v316:FindFirstChildOfClass("Humanoid")

        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
        Humanoid.UseJumpPower = false
    end

    t2.value1:Notify("Movement", "Speed and jump reset to default!", 3)
end)
task.spawn(function()
    while true do
        task.wait(0.02)

        if t2.value12.IsUnloaded then
            break
        end

        pcall(function()
            local Character = t2.value10.Character
            local v475 = Character

            if Character then
                v475 = Character:FindFirstChildOfClass("Humanoid")
            end

            if v475 then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                if t2.value12.SpeedEnabled then
                    Humanoid.WalkSpeed = t2.value12.WalkSpeed
                elseif t2.value12.SpeedLock and Humanoid.WalkSpeed < 16 then
                    Humanoid.WalkSpeed = 16
                end

                if t2.value12.JumpEnabled then
                    Humanoid.UseJumpPower = true
                    Humanoid.JumpPower = t2.value12.JumpPower
                end

                if t2.value12.FlyEnabled and HumanoidRootPart then
                    local zero = Vector3.zero

                    if t2.value4:IsKeyDown(Enum.KeyCode.W) then
                        zero += t2.value11.CFrame.LookVector
                    end

                    if t2.value4:IsKeyDown(Enum.KeyCode.S) then
                        zero -= t2.value11.CFrame.LookVector
                    end

                    if t2.value4:IsKeyDown(Enum.KeyCode.D) then
                        zero += t2.value11.CFrame.RightVector
                    end

                    if t2.value4:IsKeyDown(Enum.KeyCode.A) then
                        zero -= t2.value11.CFrame.RightVector
                    end

                    if t2.value4:IsKeyDown(Enum.KeyCode.Space) then
                        zero += Vector3.new(0, 1, 0)
                    end

                    if t2.value4:IsKeyDown(Enum.KeyCode.LeftControl) then
                        zero -= Vector3.new(0, 1, 0)
                    end

                    if zero.Magnitude > 0 then
                        HumanoidRootPart.AssemblyLinearVelocity = zero.Unit * t2.value12.FlySpeed

                        return
                    end

                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end)
    end
end)
t2.value4.JumpRequest:Connect(function()
    if t2.value12.InfiniteJump then
        local Character = t2.value10.Character

        if Character and Character:FindFirstChildOfClass("Humanoid") then
            Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
RunService.Stepped:Connect(function()
    if t2.value12.Noclip then
        local Character = t2.value10.Character

        if Character then
            local GetDescendants = Character.GetDescendants

            for _, v in ipairs(GetDescendants(Character)) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end
end)
v17:AddLabel("Quest Automation & Remote Actions")
v17:AddToggle("Auto Complete Quests", {
	Default = false
}, function(p81)
    t2.value12.AutoQuests = p81
end)
v17:AddToggle("Auto Interact with Nearby Prompts", {
	Default = false
}, function(p82)
    t2.value12.AutoInteractNearby = p82
end)
v17:AddSlider("Interaction Prompt Radius", {
	Min = 10,
	Max = 60,
	Default = 25
}, function(p83)
    t2.value12.PromptRadius = p83
end)
v17:AddButton("🚀 Teleport to Current Quest Objective", function()
    pcall(function()
        local v479 = v38()
        local QuestObjective = t2.value3:FindFirstChild("QuestObjective")

        if not QuestObjective then
            QuestObjective = t2.value3:FindFirstChild("ObjectiveMarker")
        end

        if QuestObjective and v479 then
            local v481 = QuestObjective:IsA("BasePart") and QuestObjective.Position

            if not v481 then
                v481 = QuestObjective:GetPivot().Position
            end

            v479.CFrame = CFrame.new(v481 + Vector3.new(0, 3, 0))
            t2.value1:Notify("Quest", "Teleported to objective!", 3)

            return
        end

        t2.value1:Notify("Quest", "No objective marker active.", 3)
    end)
end)
v17:AddTextBox("Accept Quest by Name", function(p84)
    t2.value12.CustomQuestName = p84
end)
v17:AddButton("✅ Accept Quest", function()
    pcall(function()
        game.ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent.Event:FireServer("GetQuest", t2.value12.CustomQuestName)
        t2.value1:Notify("Quest", "Accept request sent for: " .. t2.value12.CustomQuestName, 3)
    end)
end)
v17:AddButton("❌ Abandon Active Quest", function()
    pcall(function()
        game.ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent.Event:FireServer("AbandonQuest")
        t2.value1:Notify("Quest", "Active quest abandoned!", 3)
    end)
end)
v17:AddButton("📋 Copy Active Quest Name", function()
    pcall(function()
        local _ = t2.value10.Name
        local s1 = "CurrentQuest"

        if setclipboard then
            setclipboard(s1)
            t2.value1:Notify("Clipboard", "Copied quest: " .. s1, 3)
        end
    end)
end)
v17:AddButton("Complete Current Quest Now", function()
    pcall(function()
        game.ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent.Event:FireServer("CompleteQuest")
        t2.value1:Notify("Quests", "Quest completion attempt sent!", 3)
    end)
end)
v17:AddButton("☠\239\184\143 Respawn Character", function()
    local v328 = t2.value18()
    local v329 = v328

    if v328 then
        v329 = v328:FindFirstChildOfClass("Humanoid")
    end

    if v329 then
        v328:FindFirstChildOfClass("Humanoid").Health = 0
    end
end)
task.spawn(function()
    while true do
        task.wait(2.5)

        if t2.value12.IsUnloaded then
            break
        end

        if t2.value12.AutoQuests then
            pcall(function()
                game.ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent.Event:FireServer("CompleteQuest")
            end)
        end

        if t2.value12.AutoInteractNearby then
            pcall(function()
                local v484 = t2.value18()

                if v484 then
                    local HumanoidRootPart = v484:FindFirstChild("HumanoidRootPart")

                    if not HumanoidRootPart then
                        HumanoidRootPart = v484:FindFirstChild("UpperTorso")
                    end

                    v484 = HumanoidRootPart
                end

                if v484 then
                    for _, descendant in ipairs(t2.value3:GetDescendants()) do
                        if descendant:IsA("ProximityPrompt") and descendant.Parent then
                            local v488 = descendant.Parent:IsA("BasePart") and descendant.Parent

                            if not v488 then
                                v488 = descendant.Parent:FindFirstChildWhichIsA("BasePart", true)
                            end

                            if v488 then
                                v488 = (v484.Position - v488.Position).Magnitude <= t2.value12.PromptRadius
                            end

                            if v488 and fireproximityprompt then
                                fireproximityprompt(descendant)
                            end
                        end
                    end
                end
            end)
        end
    end
end)
v18:AddLabel("🎣 Automatic Fishing Bot")
v18:AddButton("🎣 Equip Best Fishing Rod", function()
    pcall(function()
        local PlayerGui = t2.value10:FindFirstChild("PlayerGui")
        local v490 = PlayerGui

        if PlayerGui then
            v490 = PlayerGui:FindFirstChild("ComponentsHolder")
        end

        if v490 then
            local SkillHolder = PlayerGui.ComponentsHolder.BottomHolder.Toolbar.SkillHolder
            local GetChildren = SkillHolder.GetChildren

            for _, v in ipairs(GetChildren(SkillHolder)) do
                if v:IsA("TextButton") then
                    for _, v2 in ipairs(getconnections(v.Activated)) do
                        v2.Function()
                    end
                end
            end
        end

        t2.value1:Notify("Fishing", "Best rod equipped!", 3)
    end)
end)
v18:AddToggle("🐟 Auto Reel on Fishing Bite", {
	Default = false
}, function(p85)
    t2.value12.AutoFishingReel = p85

    if p85 then
        t2.value1:Notify("Fishing", "Auto Reel enabled!", 3)
    end
end)
v18:AddButton("⛵ Go to Dock Master / Fishing Spot", function()
    local v331 = t2.value18()

    if v331 then
        local HumanoidRootPart = v331:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            HumanoidRootPart = v331:FindFirstChild("UpperTorso")
        end

        v331 = HumanoidRootPart
    end

    if v331 then
        v331.CFrame = t2.value16["Dock Master / Fishing"]
        t2.value1:Notify("Fishing", "Teleported to Dock Master!", 3)
    end
end)
v18:AddLabel("🌙 Muzan Live Tracker")
t2.value29 = v18:AddLabel("Muzan Status: Unknown")
v18:AddButton("🔍 Refresh Muzan Status", function()
    for _, descendant in ipairs(t2.value3:GetDescendants()) do
        local v335 = descendant:IsA("Model")

        if v335 then
            v335 = descendant.Name:lower():find("muzan")
        end

        if v335 then
            t2.value29:Set("Muzan Status: 🟢 SPAWNED in server!")
            t2.value1:Notify("Muzan", "Muzan is alive on the map!", 4)

            return
        end
    end

    t2.value29:Set("Muzan Status: 🔴 Not Spawned (Night only)")
end)
v18:AddButton("🚀 Teleport to Muzan", function()
    local v336 = t2.value18()

    if v336 then
        local HumanoidRootPart = v336:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            HumanoidRootPart = v336:FindFirstChild("UpperTorso")
        end

        v336 = HumanoidRootPart
    end

    local _ipairs = ipairs

    for _, v340 in _ipairs(t2.value3:GetDescendants()) do
        local v341 = v340:IsA("Model")

        if v341 then
            v341 = v340.Name:lower():find("muzan") and v336
        end

        if not v341 then
            continue
        end

        local v342 = v340:FindFirstChild("HumanoidRootPart") or v340.PrimaryPart

        if v342 then
            v336.CFrame = v342.CFrame + Vector3.new(0, 3, 0)
            t2.value1:Notify("Muzan", "Teleported to Muzan!", 3)

            return
        end
    end

    t2.value1:Notify("Muzan", "Muzan not found in server.", 3)
end)
v18:AddLabel("📦 Chest & Loot Configuration")
v18:AddToggle("📦 Auto Collect Chests", {
	Default = false
}, function(p86)
    t2.value12.AutoCollectChests = p86
end)
v18:AddToggle("💎 Auto Collect Loot Drops", {
	Default = false
}, function(p87)
    t2.value12.AutoCollectLoot = p87
end)
v18:AddToggle("Interrupt Farm to Collect Loot", {
	Default = false
}, function(p88)
    t2.value12.InterruptFarmForLoot = p88
end)
v18:AddSlider("Max Chest Distance", {
	Min = 200,
	Max = 4000,
	Default = 1500
}, function(p89)
    t2.value12.MaxChestDistance = p89
end)
v18:AddTextBox("Loot Whitelist (comma separated)", function(p90)
    t2.value12.LootWhitelist = p90
end)
v18:AddTextBox("Loot Blacklist (comma separated)", function(p91)
    t2.value12.LootBlacklist = p91
end)
v18:AddButton("🦊 Collect Foxfire Now", function()
    pcall(function()
        local v497 = t2.value18()

        if v497 then
            local HumanoidRootPart = v497:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                HumanoidRootPart = v497:FindFirstChild("UpperTorso")
            end

            v497 = HumanoidRootPart
        end

        for _, descendant in ipairs(t2.value3:GetDescendants()) do
            if descendant.Name:lower():find("foxfire") and v497 then
                local ProximityPrompt = descendant:FindFirstChildWhichIsA("ProximityPrompt", true)

                if ProximityPrompt and fireproximityprompt then
                    v497.CFrame = descendant:GetPivot()
                    task.wait(0.1)
                    fireproximityprompt(ProximityPrompt)
                end
            end
        end

        t2.value1:Notify("Foxfire", "Collected Foxfire!", 3)
    end)
end)
v18:AddLabel("🛠\239\184\143 Tools & Server Management")
v18:AddTextBox("Equip Tool by Name", function(p92)
    t2.value12.EquipToolName = p92
end)
v18:AddButton("Equip Tool", function()
    local v350 = t2.value18()
    local t2value12EquipToolName = t2.value10.Backpack:FindFirstChild(t2.value12.EquipToolName)

    if t2value12EquipToolName and v350 then
        t2value12EquipToolName.Parent = v350
        t2.value1:Notify("Tools", "Equipped: " .. t2.value12.EquipToolName, 3)
    end
end)
v18:AddButton("Unequip All Tools", function()
    local v352 = t2.value18()

    if v352 then
        local GetChildren = v352.GetChildren

        for _, v in ipairs(GetChildren(v352)) do
            if v:IsA("Tool") then
                v.Parent = t2.value10.Backpack
            end
        end

        t2.value1:Notify("Tools", "All tools unequipped!", 2)
    end
end)
v18:AddButton("🔄 Rejoin Current Server", function()
    t2.value1:Notify("Server", "Rejoining...", 3)
    pcall(function()
        t2.value5:TeleportToPlaceInstance(game.PlaceId, game.JobId, t2.value10)
    end)
end)
v18:AddButton("🌐 Server Hop", function()
    t2.value1:Notify("Server", "Finding new server...", 3)
    pcall(function()
        local v502 = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local v503 = game:HttpGet(v502)
        local data = t2.value6:JSONDecode(v503)

        if data and data.data then
            for _, v in ipairs(data.data) do
                local v507 = v.playing < v.maxPlayers

                if v507 then
                    v507 = v.id ~= game.JobId
                end

                if v507 then
                    t2.value5:TeleportToPlaceInstance(game.PlaceId, v.id, t2.value10)

                    return
                end
            end
        end

        t2.value5:Teleport(game.PlaceId, t2.value10)
    end)
end)
v18:AddButton("📋 Copy JobId", function()
    if setclipboard then
        setclipboard(game.JobId)
        t2.value1:Notify("Clipboard", "JobId copied!", 3)
    end
end)
task.spawn(function()
    while true do
        task.wait(0.5)

        if t2.value12.IsUnloaded then
            break
        end

        pcall(function()
            local v508 = t2.value18()

            if v508 then
                local HumanoidRootPart = v508:FindFirstChild("HumanoidRootPart")

                if not HumanoidRootPart then
                    HumanoidRootPart = v508:FindFirstChild("UpperTorso")
                end

                v508 = HumanoidRootPart
            end

            if not v508 then
                return
            end

            if t2.value12.AutoCollectChests then
                local Chests = t2.value3:FindFirstChild("Chests")

                if not Chests then
                    Chests = t2.value3:FindFirstChild("Debree")
                end

                if Chests then
                    for _, descendant in ipairs(Chests:GetDescendants()) do
                        if descendant.Name:lower():find("chest") then
                            local v513 = descendant:IsA("BasePart") and descendant

                            if not v513 then
                                v513 = descendant:FindFirstChildWhichIsA("BasePart", true)
                            end

                            local v514 = v513
                            local ProximityPrompt = descendant:FindFirstChildWhichIsA("ProximityPrompt", true)

                            if v513 then
                                v514 = ProximityPrompt and fireproximityprompt
                            end

                            if v514 and (v508.Position - v513.Position).Magnitude <= t2.value12.MaxChestDistance then
                                v508.CFrame = v513.CFrame + Vector3.new(0, 2, 0)
                                task.wait(0.1)
                                fireproximityprompt(ProximityPrompt)
                            end
                        end
                    end
                end
            end

            if t2.value12.AutoCollectLoot then
                local LootDrops = t2.value3:FindFirstChild("LootDrops")

                if LootDrops then
                    for _, child in ipairs(LootDrops:GetChildren()) do
                        local v519 = child:IsA("BasePart") and child

                        if not v519 then
                            v519 = child:FindFirstChildWhichIsA("BasePart", true)
                        end

                        local v520 = v519

                        if v519 then
                            v520 = (v508.Position - v519.Position).Magnitude <= t2.value12.NearbyLootRadius
                        end

                        if v520 then
                            v508.CFrame = v519.CFrame
                            task.wait(0.04)
                        end
                    end
                end
            end
        end)
    end
end)
v19:AddLabel("👁\239\184\143 Visual ESPs (With Custom Color Pickers)")
v19:AddToggle("Mob ESP", {
	Default = false
}, function(p93)
    t2.value12.MobESPEnabled = p93

    if not p93 then
        t2.value26("mob")
    end
end)
v19:AddColorPicker("Mob ESP Color", Color3.fromRGB(255, 60, 60), function(p94)
    t2.value12.MobESPColor = p94

    for _, v in pairs(t2.value13) do
        if v.category == "mob" then
            if v.highlight then
                v.highlight.FillColor = p94
            end

            if v.label then
                v.label.TextColor3 = p94
            end
        end
    end
end)
v19:AddToggle("👑 Boss ESP", {
	Default = false
}, function(p95)
    t2.value12.BossESPEnabled = p95

    if not p95 then
        t2.value26("boss")
    end
end)
v19:AddColorPicker("Boss ESP Color", Color3.fromRGB(180, 50, 255), function(p96)
    t2.value12.BossESPColor = p96

    for _, v in pairs(t2.value13) do
        if v.category == "boss" then
            if v.highlight then
                v.highlight.FillColor = p96
            end

            if v.label then
                v.label.TextColor3 = p96
            end
        end
    end
end)
v19:AddToggle("Player ESP", {
	Default = false
}, function(p97)
    t2.value12.PlayerESPEnabled = p97

    if not p97 then
        t2.value26("player")
    end
end)
v19:AddColorPicker("Player ESP Color", Color3.fromRGB(0, 220, 255), function(p98)
    t2.value12.PlayerESPColor = p98

    for _, v in pairs(t2.value13) do
        if v.category == "player" then
            if v.highlight then
                v.highlight.FillColor = p98
            end

            if v.label then
                v.label.TextColor3 = p98
            end
        end
    end
end)
v19:AddToggle("📦 Chest & Loot Drops ESP", {
	Default = false
}, function(p99)
    t2.value12.ChestESPEnabled = p99

    if not p99 then
        t2.value26("chest")
    end
end)
v19:AddColorPicker("Chest & Loot ESP Color", Color3.fromRGB(255, 215, 0), function(p100)
    t2.value12.ChestESPColor = p100

    for _, v in pairs(t2.value13) do
        if v.category == "chest" then
            if v.highlight then
                v.highlight.FillColor = p100
            end

            if v.label then
                v.label.TextColor3 = p100
            end
        end
    end
end)
v19:AddLabel("⚡ Performance & Camera Optimization")
v19:AddToggle("🚀 FPS Boost (Remove Particles/Fog)", {
	Default = false
}, function(p101)
    t2.value12.FPSBoost = p101

    if p101 then
        t2.value9.GlobalShadows = false
        t2.value9.FogEnd = 9000000000

        local _ipairs = ipairs

        for _, v375 in _ipairs(t2.value3:GetDescendants()) do
            local v376 = v375:IsA("ParticleEmitter")

            if not v376 then
                v376 = v375:IsA("Smoke")

                if not v376 then
                    v376 = v375:IsA("Fire")

                    if not v376 then
                        v376 = v375:IsA("Sparkles")
                    end
                end
            end

            if v376 then
                _ipairs = "Enabled"
                v375.Enabled = false
            end
        end

        t2.value1:Notify("Performance", "FPS Boost enabled!", 3)

        return
    end

    t2.value9.GlobalShadows = true
end)
v19:AddSlider("Field of View (Camera FOV)", {
	Min = 60,
	Max = 120,
	Default = 70
}, function(p102)
    t2.value12.FOV = p102
    t2.value11.FieldOfView = p102
end)
v19:AddToggle("Hide Players (Ghost Transparency)", {
	Default = false
}, function(p103)
    t2.value12.HidePlayers = p103

    for _, player in ipairs(t2.value2:GetPlayers()) do
        if player ~= t2.value10 and player.Character then
            for _, descendant in ipairs(player.Character:GetDescendants()) do
                local v383 = descendant:IsA("BasePart")

                if not v383 then
                    v383 = descendant:IsA("Decal")
                end

                if v383 then
                    descendant.LocalTransparencyModifier = not p103 and 0 or 1
                end
            end
        end
    end
end)
v19:AddToggle("Hide Enemies (Invisible Mobs)", {
	Default = false
}, function(p104)
    t2.value12.HideEnemies = p104

    for _, v in ipairs((v41())) do
        for _, descendant in ipairs(v:GetDescendants()) do
            if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                descendant.LocalTransparencyModifier = not p104 and 0 or 1
            end
        end
    end
end)
v20:AddLabel("Player Profile & Real-time Metrics")
t2.value30 = v20:AddLabel("Player: " .. t2.value10.Name)
t2.value31 = v20:AddLabel("Session Time: 00:00:00")
t2.value32 = v20:AddLabel("Alive Mobs: —")
v20:AddButton("🔄 Reset Session Stats Counter", function()
    t2.value12.SessionStartTime = os.clock()
    t2.value12.MobsKilledCount = 0
    t2.value12.QuestsCompletedCount = 0
    t2.value1:Notify("Stats", "Session counters reset!", 2)
end)
task.spawn(function()
    while true do
        task.wait(1)

        if t2.value12.IsUnloaded then
            break
        end

        pcall(function()
            local v521 = math.floor(os.clock() - t2.value12.SessionStartTime)
            local v522 = math.floor(v521 / 3600)
            local v523 = math.floor(v521 % 3600 / 60)
            local v524 = v521 % 60

            t2.value31:Set(string.format("Session Time: %02d:%02d:%02d", v522, v523, v524))

            local v525 = #v41()

            t2.value32:Set("Alive Mobs in Map: " .. v525)

            local value10Name = t2.value10.Name
            local value10Name3 = game.ReplicatedStorage.Player_Service.Data:FindFirstChild(value10Name)
            local v528 = value10Name3

            if value10Name3 then
                v528 = value10Name3:FindFirstChild("slots")

                if v528 then
                    v528 = value10Name3.slots:FindFirstChild("Slot1")
                end
            end

            if v528 then
                local Slot1 = value10Name3.slots.Slot1
                local Clan = Slot1:FindFirstChild("Clan")

                if Clan then
                    Clan = Slot1.Clan.Value
                end

                if not Clan then
                    Clan = "n/a"
                end

                local Race = Slot1:FindFirstChild("Race")

                if Race then
                    Race = Slot1.Race.Value
                end

                if not Race then
                    Race = "n/a"
                end

                t2.value30:Set("Player: " .. value10Name .. "  |  Clan: " .. Clan .. "  |  Race: " .. Race)
            end
        end)
    end
end)
