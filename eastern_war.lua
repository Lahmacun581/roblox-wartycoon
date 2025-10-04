--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║            The Eastern War GUI v1.0                       ║
    ║          Modern UI | Smooth Animations                    ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[Eastern War] Loading GUI v1.0...")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Global state
getgenv().EasternWar = getgenv().EasternWar or {
    Version = "1.0",
    Enabled = {},
    Connections = {},
    ESPObjects = {}
}

-- Cleanup eski GUI
if PlayerGui:FindFirstChild("EasternWarGUI") then
    PlayerGui:FindFirstChild("EasternWarGUI"):Destroy()
end

-- Ana ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EasternWarGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 700, 0, 500)
MainContainer.Position = UDim2.new(0.5, -350, 0.5, -250)
MainContainer.BackgroundTransparency = 1
MainContainer.Active = true
MainContainer.Parent = ScreenGui

-- Background with gradient
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainContainer

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 80, 100)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- Gradient overlay
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Color3.fromRGB(100, 100, 120)
HeaderStroke.Thickness = 1
HeaderStroke.Transparency = 0.7
HeaderStroke.Parent = Header

-- Title with icon
local TitleContainer = Instance.new("Frame")
TitleContainer.Size = UDim2.new(0, 300, 1, 0)
TitleContainer.Position = UDim2.new(0, 20, 0, 0)
TitleContainer.BackgroundTransparency = 1
TitleContainer.Parent = Header

local Icon = Instance.new("TextLabel")
Icon.Size = UDim2.new(0, 40, 0, 40)
Icon.Position = UDim2.new(0, 0, 0.5, -20)
Icon.BackgroundTransparency = 1
Icon.Text = "⚔️"
Icon.TextColor3 = Color3.fromRGB(255, 100, 100)
Icon.Font = Enum.Font.GothamBold
Icon.TextSize = 28
Icon.Parent = TitleContainer

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 30)
Title.Position = UDim2.new(0, 50, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "The Eastern War"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleContainer

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -50, 0, 20)
Subtitle.Position = UDim2.new(0, 50, 0, 32)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "v1.0 | Modern Combat GUI"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 170)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 12
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TitleContainer

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "Minimize"
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -100, 0.5, -20)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = Header

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 10)
MinimizeCorner.Parent = MinimizeBtn

local MinimizeStroke = Instance.new("UIStroke")
MinimizeStroke.Color = Color3.fromRGB(100, 100, 255)
MinimizeStroke.Thickness = 1
MinimizeStroke.Transparency = 0.5
MinimizeStroke.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseBtn

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(255, 100, 100)
CloseStroke.Thickness = 1
CloseStroke.Transparency = 0.5
CloseStroke.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0, 150, 1, -80)
TabBar.Position = UDim2.new(0, 10, 0, 70)
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 12)
TabBarCorner.Parent = TabBar

local TabBarStroke = Instance.new("UIStroke")
TabBarStroke.Color = Color3.fromRGB(60, 60, 80)
TabBarStroke.Thickness = 1
TabBarStroke.Transparency = 0.7
TabBarStroke.Parent = TabBar

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 8)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.PaddingLeft = UDim.new(0, 10)
TabPadding.PaddingRight = UDim.new(0, 10)
TabPadding.Parent = TabBar

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -180, 1, -80)
ContentContainer.Position = UDim2.new(0, 170, 0, 70)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Helper: Create Tab
local tabs = {}
local currentTab = nil

local function createTab(name, icon, color)
    -- Tab Button
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "Tab"
    tabBtn.Size = UDim2.new(1, 0, 0, 45)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Text = ""
    tabBtn.Parent = TabBar
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = tabBtn
    
    local tabStroke = Instance.new("UIStroke")
    tabStroke.Color = color
    tabStroke.Thickness = 0
    tabStroke.Transparency = 1
    tabStroke.Parent = tabBtn
    
    -- Tab Icon
    local tabIcon = Instance.new("TextLabel")
    tabIcon.Size = UDim2.new(0, 30, 0, 30)
    tabIcon.Position = UDim2.new(0, 10, 0.5, -15)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Text = icon
    tabIcon.TextColor3 = Color3.fromRGB(150, 150, 170)
    tabIcon.Font = Enum.Font.GothamBold
    tabIcon.TextSize = 18
    tabIcon.Parent = tabBtn
    
    -- Tab Label
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, -50, 1, 0)
    tabLabel.Position = UDim2.new(0, 45, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = name
    tabLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    tabLabel.Font = Enum.Font.GothamMedium
    tabLabel.TextSize = 14
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Parent = tabBtn
    
    -- Tab Content
    local content = Instance.new("ScrollingFrame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 6
    content.ScrollBarImageColor3 = color
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Visible = false
    content.Parent = ContentContainer
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 10)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.Parent = content
    
    -- Tab Click
    tabBtn.MouseButton1Click:Connect(function()
        -- Hide all tabs
        for _, tab in pairs(tabs) do
            tab.content.Visible = false
            TweenService:Create(tab.button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            }):Play()
            TweenService:Create(tab.stroke, TweenInfo.new(0.2), {
                Thickness = 0,
                Transparency = 1
            }):Play()
            tab.icon.TextColor3 = Color3.fromRGB(150, 150, 170)
            tab.label.TextColor3 = Color3.fromRGB(150, 150, 170)
        end
        
        -- Show selected tab
        content.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        }):Play()
        TweenService:Create(tabStroke, TweenInfo.new(0.2), {
            Thickness = 2,
            Transparency = 0
        }):Play()
        tabIcon.TextColor3 = color
        tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        currentTab = content
    end)
    
    tabs[name] = {
        button = tabBtn,
        content = content,
        icon = tabIcon,
        label = tabLabel,
        stroke = tabStroke,
        color = color
    }
    
    return content
end

-- Helper: Create Button
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 100)
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = btn
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(120, 120, 150),
            Transparency = 0.3
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(80, 80, 100),
            Transparency = 0.7
        }):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Helper: Create Toggle
local function createToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 28)
    toggle.Position = UDim2.new(1, -60, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 22, 0, 22)
    toggleCircle.Position = UDim2.new(0, 3, 0.5, -11)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    toggleCircle.Parent = toggle
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(100, 200, 100)
            }):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -25, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            }):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(200, 200, 220)
            }):Play()
        end
        callback(state)
    end)
    
    return frame, toggle
end

-- Helper: Create Slider
local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 8)
    sliderBg.Position = UDim2.new(0, 15, 1, -18)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    local dragging = false
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            
            TweenService:Create(sliderFill, TweenInfo.new(0.1), {
                Size = UDim2.new(percent, 0, 1, 0)
            }):Play()
            label.Text = text .. ": " .. tostring(value)
            callback(value)
        end
    end)
    
    return frame
end

-- Create Tabs
local CombatTab = createTab("Combat", "⚔️", Color3.fromRGB(255, 100, 100))
local PlayerTab = createTab("Player", "🏃", Color3.fromRGB(100, 150, 255))
local VisualsTab = createTab("Visuals", "👁️", Color3.fromRGB(150, 100, 255))
local TeleportTab = createTab("Teleport", "📍", Color3.fromRGB(100, 255, 150))
local MiscTab = createTab("Misc", "⚙️", Color3.fromRGB(255, 200, 100))

-- Show first tab by default
if tabs["Combat"] then
    tabs["Combat"].content.Visible = true
    tabs["Combat"].button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    tabs["Combat"].stroke.Thickness = 2
    tabs["Combat"].stroke.Transparency = 0
    tabs["Combat"].icon.TextColor3 = tabs["Combat"].color
    tabs["Combat"].label.TextColor3 = Color3.fromRGB(255, 255, 255)
end

-- Placeholder content
createButton(CombatTab, "🎯 Aimbot", function()
    print("[Combat] Aimbot clicked")
end)

createToggle(CombatTab, "🔫 No Recoil", function(enabled)
    print("[Combat] No Recoil:", enabled)
end)

createSlider(CombatTab, "🎯 FOV Size", 50, 500, 150, function(value)
    print("[Combat] FOV Size:", value)
end)

createButton(PlayerTab, "🏃 Speed Hack", function()
    print("[Player] Speed Hack clicked")
end)

createToggle(PlayerTab, "✈️ Fly Mode", function(enabled)
    print("[Player] Fly Mode:", enabled)
end)

-- ===== ADVANCED ESP SYSTEM =====
do
    local ESPEnabled = false
    local ESPBoxEnabled = false
    local ESPNameEnabled = false
    local ESPHealthEnabled = false
    local ESPDistanceEnabled = false
    local ESPTracerEnabled = false
    local ESPSkeletonEnabled = false
    local ESPTeamCheck = false
    
    local ESPColor = Color3.fromRGB(255, 100, 100)
    local ESPTeamColor = Color3.fromRGB(100, 255, 100)
    
    local ESPObjects = {}
    local ESPConnections = {}
    
    local function createESP(player)
        if player == LocalPlayer then return end
        if ESPObjects[player] then return end
        
        local espData = {
            player = player,
            drawings = {}
        }
        
        -- Box
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = ESPColor
        box.Thickness = 2
        box.Transparency = 1
        box.Filled = false
        espData.drawings.box = box
        
        local boxOutline = Drawing.new("Square")
        boxOutline.Visible = false
        boxOutline.Color = Color3.fromRGB(0, 0, 0)
        boxOutline.Thickness = 4
        boxOutline.Transparency = 1
        boxOutline.Filled = false
        espData.drawings.boxOutline = boxOutline
        
        -- Name
        local nameText = Drawing.new("Text")
        nameText.Visible = false
        nameText.Color = ESPColor
        nameText.Text = player.Name
        nameText.Size = 16
        nameText.Center = true
        nameText.Outline = true
        nameText.Font = 2
        espData.drawings.name = nameText
        
        -- Health Bar
        local healthBarBg = Drawing.new("Square")
        healthBarBg.Visible = false
        healthBarBg.Color = Color3.fromRGB(0, 0, 0)
        healthBarBg.Thickness = 1
        healthBarBg.Transparency = 0.5
        healthBarBg.Filled = true
        espData.drawings.healthBarBg = healthBarBg
        
        local healthBar = Drawing.new("Square")
        healthBar.Visible = false
        healthBar.Color = Color3.fromRGB(0, 255, 0)
        healthBar.Thickness = 1
        healthBar.Transparency = 1
        healthBar.Filled = true
        espData.drawings.healthBar = healthBar
        
        -- Health Text
        local healthText = Drawing.new("Text")
        healthText.Visible = false
        healthText.Color = Color3.fromRGB(255, 255, 255)
        healthText.Text = "100"
        healthText.Size = 14
        healthText.Center = true
        healthText.Outline = true
        healthText.Font = 2
        espData.drawings.healthText = healthText
        
        -- Distance
        local distanceText = Drawing.new("Text")
        distanceText.Visible = false
        distanceText.Color = Color3.fromRGB(200, 200, 200)
        distanceText.Text = "0m"
        distanceText.Size = 14
        distanceText.Center = true
        distanceText.Outline = true
        distanceText.Font = 2
        espData.drawings.distance = distanceText
        
        -- Tracer
        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = ESPColor
        tracer.Thickness = 2
        tracer.Transparency = 1
        espData.drawings.tracer = tracer
        
        -- Skeleton lines
        local skeletonLines = {}
        local skeletonPairs = {
            {"Head", "UpperTorso"},
            {"UpperTorso", "LowerTorso"},
            {"UpperTorso", "LeftUpperArm"},
            {"LeftUpperArm", "LeftLowerArm"},
            {"LeftLowerArm", "LeftHand"},
            {"UpperTorso", "RightUpperArm"},
            {"RightUpperArm", "RightLowerArm"},
            {"RightLowerArm", "RightHand"},
            {"LowerTorso", "LeftUpperLeg"},
            {"LeftUpperLeg", "LeftLowerLeg"},
            {"LeftLowerLeg", "LeftFoot"},
            {"LowerTorso", "RightUpperLeg"},
            {"RightUpperLeg", "RightLowerLeg"},
            {"RightLowerLeg", "RightFoot"}
        }
        
        for i = 1, #skeletonPairs do
            local line = Drawing.new("Line")
            line.Visible = false
            line.Color = ESPColor
            line.Thickness = 2
            line.Transparency = 1
            skeletonLines[i] = line
        end
        espData.drawings.skeleton = skeletonLines
        
        ESPObjects[player] = espData
    end
    
    local function removeESP(player)
        local espData = ESPObjects[player]
        if espData then
            for _, drawing in pairs(espData.drawings) do
                if type(drawing) == "table" then
                    for _, line in pairs(drawing) do
                        line:Remove()
                    end
                else
                    drawing:Remove()
                end
            end
            ESPObjects[player] = nil
        end
    end
    
    local function updateESP()
        if not ESPEnabled then return end
        
        local camera = workspace.CurrentCamera
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        
        for player, espData in pairs(ESPObjects) do
            if not player or not player.Parent then
                removeESP(player)
                continue
            end
            
            local char = player.Character
            if not char then
                for _, drawing in pairs(espData.drawings) do
                    if type(drawing) == "table" then
                        for _, line in pairs(drawing) do
                            line.Visible = false
                        end
                    else
                        drawing.Visible = false
                    end
                end
                continue
            end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            
            if not hrp or not head or not humanoid then continue end
            
            -- Team check
            local color = ESPColor
            if ESPTeamCheck and player.Team == LocalPlayer.Team then
                color = ESPTeamColor
            end
            
            -- Calculate screen position
            local hrpPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                
                -- Distance
                local distance = (hrp.Position - myHrp.Position).Magnitude
                
                -- Box ESP
                if ESPBoxEnabled then
                    espData.drawings.boxOutline.Size = Vector2.new(width, height)
                    espData.drawings.boxOutline.Position = Vector2.new(hrpPos.X - width/2, headPos.Y)
                    espData.drawings.boxOutline.Visible = true
                    
                    espData.drawings.box.Size = Vector2.new(width, height)
                    espData.drawings.box.Position = Vector2.new(hrpPos.X - width/2, headPos.Y)
                    espData.drawings.box.Color = color
                    espData.drawings.box.Visible = true
                else
                    espData.drawings.box.Visible = false
                    espData.drawings.boxOutline.Visible = false
                end
                
                -- Name ESP
                if ESPNameEnabled then
                    espData.drawings.name.Position = Vector2.new(hrpPos.X, headPos.Y - 20)
                    espData.drawings.name.Color = color
                    espData.drawings.name.Visible = true
                else
                    espData.drawings.name.Visible = false
                end
                
                -- Health ESP
                if ESPHealthEnabled then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barHeight = height
                    local barWidth = 4
                    
                    espData.drawings.healthBarBg.Size = Vector2.new(barWidth, barHeight)
                    espData.drawings.healthBarBg.Position = Vector2.new(hrpPos.X - width/2 - 8, headPos.Y)
                    espData.drawings.healthBarBg.Visible = true
                    
                    espData.drawings.healthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                    espData.drawings.healthBar.Position = Vector2.new(hrpPos.X - width/2 - 8, headPos.Y + barHeight * (1 - healthPercent))
                    espData.drawings.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    espData.drawings.healthBar.Visible = true
                    
                    espData.drawings.healthText.Text = tostring(math.floor(humanoid.Health))
                    espData.drawings.healthText.Position = Vector2.new(hrpPos.X - width/2 - 10, headPos.Y + barHeight/2)
                    espData.drawings.healthText.Visible = true
                else
                    espData.drawings.healthBarBg.Visible = false
                    espData.drawings.healthBar.Visible = false
                    espData.drawings.healthText.Visible = false
                end
                
                -- Distance ESP
                if ESPDistanceEnabled then
                    espData.drawings.distance.Text = string.format("%dm", math.floor(distance))
                    espData.drawings.distance.Position = Vector2.new(hrpPos.X, legPos.Y + 5)
                    espData.drawings.distance.Visible = true
                else
                    espData.drawings.distance.Visible = false
                end
                
                -- Tracer ESP
                if ESPTracerEnabled then
                    local tracerStart = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    espData.drawings.tracer.From = tracerStart
                    espData.drawings.tracer.To = Vector2.new(hrpPos.X, hrpPos.Y)
                    espData.drawings.tracer.Color = color
                    espData.drawings.tracer.Visible = true
                else
                    espData.drawings.tracer.Visible = false
                end
                
                -- Skeleton ESP
                if ESPSkeletonEnabled then
                    local skeletonPairs = {
                        {"Head", "UpperTorso"},
                        {"UpperTorso", "LowerTorso"},
                        {"UpperTorso", "LeftUpperArm"},
                        {"LeftUpperArm", "LeftLowerArm"},
                        {"LeftLowerArm", "LeftHand"},
                        {"UpperTorso", "RightUpperArm"},
                        {"RightUpperArm", "RightLowerArm"},
                        {"RightLowerArm", "RightHand"},
                        {"LowerTorso", "LeftUpperLeg"},
                        {"LeftUpperLeg", "LeftLowerLeg"},
                        {"LeftLowerLeg", "LeftFoot"},
                        {"LowerTorso", "RightUpperLeg"},
                        {"RightUpperLeg", "RightLowerLeg"},
                        {"RightLowerLeg", "RightFoot"}
                    }
                    
                    for i, pair in ipairs(skeletonPairs) do
                        local part1 = char:FindFirstChild(pair[1])
                        local part2 = char:FindFirstChild(pair[2])
                        
                        if part1 and part2 and espData.drawings.skeleton[i] then
                            local pos1, vis1 = camera:WorldToViewportPoint(part1.Position)
                            local pos2, vis2 = camera:WorldToViewportPoint(part2.Position)
                            
                            if vis1 and vis2 then
                                espData.drawings.skeleton[i].From = Vector2.new(pos1.X, pos1.Y)
                                espData.drawings.skeleton[i].To = Vector2.new(pos2.X, pos2.Y)
                                espData.drawings.skeleton[i].Color = color
                                espData.drawings.skeleton[i].Visible = true
                            else
                                espData.drawings.skeleton[i].Visible = false
                            end
                        elseif espData.drawings.skeleton[i] then
                            espData.drawings.skeleton[i].Visible = false
                        end
                    end
                else
                    for _, line in pairs(espData.drawings.skeleton) do
                        line.Visible = false
                    end
                end
            else
                -- Hide all if not on screen
                for _, drawing in pairs(espData.drawings) do
                    if type(drawing) == "table" then
                        for _, line in pairs(drawing) do
                            line.Visible = false
                        end
                    else
                        drawing.Visible = false
                    end
                end
            end
        end
    end
    
    -- ESP Toggles
    createToggle(VisualsTab, "👁️ Enable ESP", function(enabled)
        ESPEnabled = enabled
        getgenv().EasternWar.Enabled.ESP = enabled
        
        if enabled then
            print("[ESP] Enabled")
            
            -- Create ESP for existing players
            for _, player in ipairs(Players:GetPlayers()) do
                createESP(player)
            end
            
            -- Update loop
            local conn = RunService.RenderStepped:Connect(function()
                if ESPEnabled then
                    updateESP()
                end
            end)
            table.insert(ESPConnections, conn)
            
            -- Handle new players
            local conn2 = Players.PlayerAdded:Connect(function(player)
                if ESPEnabled then
                    task.wait(1)
                    createESP(player)
                end
            end)
            table.insert(ESPConnections, conn2)
            
            -- Handle removed players
            local conn3 = Players.PlayerRemoving:Connect(function(player)
                removeESP(player)
            end)
            table.insert(ESPConnections, conn3)
        else
            print("[ESP] Disabled")
            
            -- Disconnect all
            for _, conn in ipairs(ESPConnections) do
                conn:Disconnect()
            end
            ESPConnections = {}
            
            -- Remove all ESP
            for player, _ in pairs(ESPObjects) do
                removeESP(player)
            end
        end
    end)
    
    createToggle(VisualsTab, "📦 Box ESP", function(enabled)
        ESPBoxEnabled = enabled
        print("[ESP] Box:", enabled)
    end)
    
    createToggle(VisualsTab, "📝 Name ESP", function(enabled)
        ESPNameEnabled = enabled
        print("[ESP] Name:", enabled)
    end)
    
    createToggle(VisualsTab, "❤️ Health ESP", function(enabled)
        ESPHealthEnabled = enabled
        print("[ESP] Health:", enabled)
    end)
    
    createToggle(VisualsTab, "📏 Distance ESP", function(enabled)
        ESPDistanceEnabled = enabled
        print("[ESP] Distance:", enabled)
    end)
    
    createToggle(VisualsTab, "📍 Tracer ESP", function(enabled)
        ESPTracerEnabled = enabled
        print("[ESP] Tracer:", enabled)
    end)
    
    createToggle(VisualsTab, "💀 Skeleton ESP", function(enabled)
        ESPSkeletonEnabled = enabled
        print("[ESP] Skeleton:", enabled)
    end)
    
    createToggle(VisualsTab, "👥 Team Check", function(enabled)
        ESPTeamCheck = enabled
        print("[ESP] Team Check:", enabled)
    end)
end

-- Minimize functionality
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 300, 0, 60)
        }):Play()
        MinimizeBtn.Text = "□"
    else
        TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 700, 0, 500)
        }):Play()
        MinimizeBtn.Text = "—"
    end
end)

-- Draggable
local dragging = false
local dragInput, mousePos, framePos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        MainContainer.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- Klavye kısayolu (T = toggle GUI)
local visible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.T then
        visible = not visible
        MainContainer.Visible = visible
    end
end)

-- Intro animation
MainContainer.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 700, 0, 500)
}):Play()

print("[Eastern War] GUI v1.0 loaded! Press T to toggle.")
