--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                D-Day GUI v1.0                             ║
    ║     Advanced ESP | Combat | Optimized Performance        ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[D-Day] Loading GUI v1.0...")

-- Wait for game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(1) -- Extra safety delay

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for PlayerGui with timeout
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
if not PlayerGui then
    LocalPlayer:WaitForChild("PlayerGui", 5)
    PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
end

if not PlayerGui then
    warn("[D-Day] PlayerGui not found! Creating temporary GUI parent...")
    PlayerGui = LocalPlayer
end

-- Global state
getgenv().DDay = getgenv().DDay or {
    Version = "1.0",
    Enabled = {},
    Connections = {},
    ESPObjects = {},
    OriginalValues = {}
}

-- Cleanup eski GUI
if PlayerGui:FindFirstChild("DDayGUI") then
    PlayerGui:FindFirstChild("DDayGUI"):Destroy()
end

-- Ana ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DDayGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999999 -- En üstte
ScreenGui.Parent = PlayerGui

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 750, 0, 550)
MainContainer.Position = UDim2.new(0.5, -375, 0.5, -275)
MainContainer.BackgroundTransparency = 1
MainContainer.Active = true
MainContainer.Draggable = true -- Sürüklenebilir
MainContainer.Parent = ScreenGui

-- Background
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainContainer

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 80, 60)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Gradient
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 22, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 18))
}
Gradient.Rotation = 135
Gradient.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 65)
Header.BackgroundColor3 = Color3.fromRGB(30, 28, 25)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Color3.fromRGB(120, 100, 80)
HeaderStroke.Thickness = 1
HeaderStroke.Transparency = 0.5
HeaderStroke.Parent = Header

-- Title Container
local TitleContainer = Instance.new("Frame")
TitleContainer.Size = UDim2.new(0, 350, 1, 0)
TitleContainer.Position = UDim2.new(0, 25, 0, 0)
TitleContainer.BackgroundTransparency = 1
TitleContainer.Parent = Header

local Icon = Instance.new("TextLabel")
Icon.Size = UDim2.new(0, 45, 0, 45)
Icon.Position = UDim2.new(0, 0, 0.5, -22.5)
Icon.BackgroundTransparency = 1
Icon.Text = "🎖️"
Icon.TextColor3 = Color3.fromRGB(200, 150, 100)
Icon.Font = Enum.Font.GothamBold
Icon.TextSize = 32
Icon.Parent = TitleContainer

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 0, 32)
Title.Position = UDim2.new(0, 60, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "D-DAY"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleContainer

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -60, 0, 18)
Subtitle.Position = UDim2.new(0, 60, 0, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "v1.0 | Advanced Combat System"
Subtitle.TextColor3 = Color3.fromRGB(180, 160, 140)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 13
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TitleContainer

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "Minimize"
MinimizeBtn.Size = UDim2.new(0, 45, 0, 45)
MinimizeBtn.Position = UDim2.new(1, -110, 0.5, -22.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 42, 38)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 20
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = Header

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 12)
MinimizeCorner.Parent = MinimizeBtn

local MinimizeStroke = Instance.new("UIStroke")
MinimizeStroke.Color = Color3.fromRGB(150, 130, 100)
MinimizeStroke.Thickness = 1
MinimizeStroke.Transparency = 0.5
MinimizeStroke.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 45, 0, 45)
CloseBtn.Position = UDim2.new(1, -55, 0.5, -22.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 12)
CloseCorner.Parent = CloseBtn

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(220, 100, 90)
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
TabBar.Size = UDim2.new(0, 170, 1, -85)
TabBar.Position = UDim2.new(0, 15, 0, 75)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 14)
TabBarCorner.Parent = TabBar

local TabBarStroke = Instance.new("UIStroke")
TabBarStroke.Color = Color3.fromRGB(70, 70, 80)
TabBarStroke.Thickness = 1
TabBarStroke.Transparency = 0.6
TabBarStroke.Parent = TabBar

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 10)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 12)
TabPadding.PaddingLeft = UDim.new(0, 12)
TabPadding.PaddingRight = UDim.new(0, 12)
TabPadding.Parent = TabBar

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -210, 1, -85)
ContentContainer.Position = UDim2.new(0, 195, 0, 75)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Helper: Create Tab
local tabs = {}
local currentTab = nil

local function createTab(name, icon, color)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "Tab"
    tabBtn.Size = UDim2.new(1, 0, 0, 50)
    tabBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Text = ""
    tabBtn.Parent = TabBar
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 12)
    tabCorner.Parent = tabBtn
    
    local tabStroke = Instance.new("UIStroke")
    tabStroke.Color = color
    tabStroke.Thickness = 0
    tabStroke.Transparency = 1
    tabStroke.Parent = tabBtn
    
    local tabIcon = Instance.new("TextLabel")
    tabIcon.Size = UDim2.new(0, 35, 0, 35)
    tabIcon.Position = UDim2.new(0, 12, 0.5, -17.5)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Text = icon
    tabIcon.TextColor3 = Color3.fromRGB(160, 160, 170)
    tabIcon.Font = Enum.Font.GothamBold
    tabIcon.TextSize = 20
    tabIcon.Parent = tabBtn
    
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, -55, 1, 0)
    tabLabel.Position = UDim2.new(0, 52, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = name
    tabLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
    tabLabel.Font = Enum.Font.GothamMedium
    tabLabel.TextSize = 15
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Parent = tabBtn
    
    local content = Instance.new("ScrollingFrame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 8
    content.ScrollBarImageColor3 = color
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Visible = false
    content.Parent = ContentContainer
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 12)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 12)
    contentPadding.PaddingLeft = UDim.new(0, 12)
    contentPadding.PaddingRight = UDim.new(0, 12)
    contentPadding.PaddingBottom = UDim.new(0, 12)
    contentPadding.Parent = content
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.content.Visible = false
            TweenService:Create(tab.button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(32, 32, 38)
            }):Play()
            TweenService:Create(tab.stroke, TweenInfo.new(0.2), {
                Thickness = 0,
                Transparency = 1
            }):Play()
            tab.icon.TextColor3 = Color3.fromRGB(160, 160, 170)
            tab.label.TextColor3 = Color3.fromRGB(160, 160, 170)
        end
        
        content.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(42, 42, 50)
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
    btn.Size = UDim2.new(1, -12, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(42, 42, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 11)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90, 90, 110)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(52, 52, 65)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(130, 130, 160),
            Transparency = 0.2
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(42, 42, 50)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(90, 90, 110),
            Transparency = 0.6
        }):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Helper: Create Toggle
local function createToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 11)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 70, 85)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -75, 1, 0)
    label.Position = UDim2.new(0, 18, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 55, 0, 30)
    toggle.Position = UDim2.new(1, -65, 0.5, -15)
    toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 24, 0, 24)
    toggleCircle.Position = UDim2.new(0, 3, 0.5, -12)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(210, 210, 230)
    toggleCircle.Parent = toggle
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(120, 200, 120)
            }):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -27, 0.5, -12),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(70, 70, 90)
            }):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -12),
                BackgroundColor3 = Color3.fromRGB(210, 210, 230)
            }):Play()
        end
        callback(state)
    end)
    
    return frame, toggle
end

-- Helper: Create Slider
local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 11)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 70, 85)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -25, 0, 24)
    label.Position = UDim2.new(0, 12, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -35, 0, 10)
    sliderBg.Position = UDim2.new(0, 18, 1, -20)
    sliderBg.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(120, 150, 255)
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
local CombatTab = createTab("Combat", "⚔️", Color3.fromRGB(220, 100, 100))
local ESPTab = createTab("ESP", "👁️", Color3.fromRGB(150, 120, 255))
local PlayerTab = createTab("Player", "🏃", Color3.fromRGB(100, 180, 255))
local MiscTab = createTab("Misc", "⚙️", Color3.fromRGB(180, 180, 100))

-- Show first tab
if tabs["Combat"] then
    tabs["Combat"].content.Visible = true
    tabs["Combat"].button.BackgroundColor3 = Color3.fromRGB(42, 42, 50)
    tabs["Combat"].stroke.Thickness = 2
    tabs["Combat"].stroke.Transparency = 0
    tabs["Combat"].icon.TextColor3 = tabs["Combat"].color
    tabs["Combat"].label.TextColor3 = Color3.fromRGB(255, 255, 255)
end

-- ===== COMBAT TAB (OPTIMIZED) =====
do
    -- Combat loop for weapon mods
    local weaponConnection = nil
    local frameCounter = 0
    
    -- No Spread
    createToggle(CombatTab, "🎯 No Spread", function(enabled)
        getgenv().DDay.Enabled.NoSpread = enabled
        print("[Combat] No Spread:", enabled and "ON" or "OFF")
        
        if enabled then
            weaponConnection = RunService.Heartbeat:Connect(function()
                frameCounter = frameCounter + 1
                if frameCounter % 5 ~= 0 then return end -- Every 5 frames
                
                local char = LocalPlayer.Character
                if not char then return end
                
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    local config = tool:FindFirstChild("Config") or tool:FindFirstChild("Configuration")
                    if config then
                        for _, value in ipairs(config:GetChildren()) do
                            if value:IsA("NumberValue") then
                                local name = value.Name:lower()
                                if name:find("spread") or name:find("accuracy") then
                                    if not getgenv().DDay.OriginalValues[value] then
                                        getgenv().DDay.OriginalValues[value] = value.Value
                                    end
                                    value.Value = 0
                                end
                            end
                        end
                    end
                end
            end)
            
            table.insert(getgenv().DDay.Connections, weaponConnection)
        else
            if weaponConnection then
                weaponConnection:Disconnect()
                weaponConnection = nil
            end
            
            -- Restore original values
            for value, original in pairs(getgenv().DDay.OriginalValues) do
                if value and value.Parent and value.Name:lower():find("spread") then
                    value.Value = original
                    getgenv().DDay.OriginalValues[value] = nil
                end
            end
        end
    end)
    
    -- Advanced Hitbox Expander
    getgenv().DDay.HitboxSize = 10
    getgenv().DDay.HitboxPart = "HumanoidRootPart" -- Default
    getgenv().DDay.HitboxTeamCheck = true -- Don't expand teammates
    
    local hitboxConnection = nil
    local hitboxCache = {} -- Cache for performance
    
    createSlider(CombatTab, "📏 Hitbox Size", 5, 50, 10, function(value)
        getgenv().DDay.HitboxSize = value
    end)
    
    -- Hitbox Part Selection
    local hitboxParts = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso"}
    local currentPartIndex = 1
    
    createButton(CombatTab, "🎯 Hitbox Part: HumanoidRootPart", function()
        currentPartIndex = currentPartIndex + 1
        if currentPartIndex > #hitboxParts then
            currentPartIndex = 1
        end
        
        getgenv().DDay.HitboxPart = hitboxParts[currentPartIndex]
        
        -- Update button text
        for _, child in ipairs(CombatTab:GetChildren()) do
            if child:IsA("TextButton") and child.Text:find("Hitbox Part:") then
                child.Text = "🎯 Hitbox Part: " .. hitboxParts[currentPartIndex]
                break
            end
        end
        
        print("[Hitbox] Part changed to:", hitboxParts[currentPartIndex])
    end)
    
    createToggle(CombatTab, "👥 Hitbox Team Check", function(enabled)
        getgenv().DDay.HitboxTeamCheck = enabled
        print("[Hitbox] Team Check:", enabled and "ON (Takım korunuyor)" or "OFF")
    end)
    
    createToggle(CombatTab, "🎯 Hitbox Expander", function(enabled)
        getgenv().DDay.Enabled.Hitbox = enabled
        print("[Hitbox] Expander:", enabled and "ON" or "OFF")
        
        if enabled then
            hitboxConnection = RunService.Heartbeat:Connect(function()
                frameCounter = frameCounter + 1
                if frameCounter % 10 ~= 0 then return end -- Every 10 frames for performance
                
                local size = getgenv().DDay.HitboxSize or 10
                local partName = getgenv().DDay.HitboxPart or "HumanoidRootPart"
                local teamCheck = getgenv().DDay.HitboxTeamCheck
                
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        -- Team Check
                        if teamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                            -- Skip teammates
                            continue
                        end
                        
                        local part = player.Character:FindFirstChild(partName)
                        if part and part:IsA("BasePart") then
                            -- Cache check
                            if not hitboxCache[part] then
                                hitboxCache[part] = {
                                    OriginalSize = part.Size,
                                    OriginalTransparency = part.Transparency
                                }
                            end
                            
                            -- Expand hitbox
                            part.Size = Vector3.new(size, size, size)
                            part.Transparency = 0.5
                            part.CanCollide = false
                            part.Massless = true
                        end
                    end
                end
            end)
            
            table.insert(getgenv().DDay.Connections, hitboxConnection)
        else
            if hitboxConnection then
                hitboxConnection:Disconnect()
                hitboxConnection = nil
            end
            
            -- Restore all hitboxes
            for part, data in pairs(hitboxCache) do
                if part and part.Parent then
                    part.Size = data.OriginalSize
                    part.Transparency = data.OriginalTransparency
                end
            end
            hitboxCache = {}
        end
    end)
end

-- ===== OPTIMIZED ESP SYSTEM =====
do
    local ESPEnabled = false
    local ESPBoxEnabled = false
    local ESPNameEnabled = false
    local ESPHealthEnabled = false
    local ESPDistanceEnabled = false
    local ESPTracerEnabled = false
    local ESPSkeletonEnabled = false
    local ESPTeamCheck = true -- Takımdakileri gösterme (varsayılan: açık)
    
    local ESPColor = Color3.fromRGB(220, 100, 100)
    local ESPObjects = {}
    local ESPConnections = {}
    
    -- FPS Optimization: Update every 2 frames
    local frameCount = 0
    
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
        
        -- Skeleton (simplified for performance)
        local skeletonLines = {}
        for i = 1, 6 do -- Reduced from 14 to 6 for FPS
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
        
        -- FPS Optimization: Update every 2 frames
        frameCount = frameCount + 1
        if frameCount % 2 ~= 0 then return end
        
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
            
            -- Team Check: Takımdakileri gösterme
            if ESPTeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                -- Takım arkadaşı, ESP gösterme
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
            
            local hrpPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                local distance = (hrp.Position - myHrp.Position).Magnitude
                
                -- Box ESP
                if ESPBoxEnabled then
                    espData.drawings.boxOutline.Size = Vector2.new(width, height)
                    espData.drawings.boxOutline.Position = Vector2.new(hrpPos.X - width/2, headPos.Y)
                    espData.drawings.boxOutline.Visible = true
                    
                    espData.drawings.box.Size = Vector2.new(width, height)
                    espData.drawings.box.Position = Vector2.new(hrpPos.X - width/2, headPos.Y)
                    espData.drawings.box.Visible = true
                else
                    espData.drawings.box.Visible = false
                    espData.drawings.boxOutline.Visible = false
                end
                
                -- Name ESP
                if ESPNameEnabled then
                    espData.drawings.name.Position = Vector2.new(hrpPos.X, headPos.Y - 20)
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
                else
                    espData.drawings.healthBarBg.Visible = false
                    espData.drawings.healthBar.Visible = false
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
                    espData.drawings.tracer.Visible = true
                else
                    espData.drawings.tracer.Visible = false
                end
                
                -- Skeleton ESP (simplified)
                if ESPSkeletonEnabled then
                    local simplePairs = {
                        {"Head", "UpperTorso"},
                        {"UpperTorso", "LowerTorso"},
                        {"UpperTorso", "LeftUpperArm"},
                        {"UpperTorso", "RightUpperArm"},
                        {"LowerTorso", "LeftUpperLeg"},
                        {"LowerTorso", "RightUpperLeg"}
                    }
                    
                    for i, pair in ipairs(simplePairs) do
                        local part1 = char:FindFirstChild(pair[1])
                        local part2 = char:FindFirstChild(pair[2])
                        
                        if part1 and part2 and espData.drawings.skeleton[i] then
                            local pos1, vis1 = camera:WorldToViewportPoint(part1.Position)
                            local pos2, vis2 = camera:WorldToViewportPoint(part2.Position)
                            
                            if vis1 and vis2 then
                                espData.drawings.skeleton[i].From = Vector2.new(pos1.X, pos1.Y)
                                espData.drawings.skeleton[i].To = Vector2.new(pos2.X, pos2.Y)
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
    createToggle(ESPTab, "👁️ Enable ESP", function(enabled)
        ESPEnabled = enabled
        
        if enabled then
            print("[ESP] Enabled (Optimized)")
            
            for _, player in ipairs(Players:GetPlayers()) do
                createESP(player)
            end
            
            local conn = RunService.RenderStepped:Connect(function()
                if ESPEnabled then
                    updateESP()
                end
            end)
            table.insert(ESPConnections, conn)
            
            local conn2 = Players.PlayerAdded:Connect(function(player)
                if ESPEnabled then
                    task.wait(1)
                    createESP(player)
                end
            end)
            table.insert(ESPConnections, conn2)
            
            local conn3 = Players.PlayerRemoving:Connect(function(player)
                removeESP(player)
            end)
            table.insert(ESPConnections, conn3)
        else
            print("[ESP] Disabled")
            
            for _, conn in ipairs(ESPConnections) do
                conn:Disconnect()
            end
            ESPConnections = {}
            
            for player, _ in pairs(ESPObjects) do
                removeESP(player)
            end
        end
    end)
    
    createToggle(ESPTab, "📦 Box ESP", function(enabled)
        ESPBoxEnabled = enabled
    end)
    
    createToggle(ESPTab, "📝 Name ESP", function(enabled)
        ESPNameEnabled = enabled
    end)
    
    createToggle(ESPTab, "❤️ Health ESP", function(enabled)
        ESPHealthEnabled = enabled
    end)
    
    createToggle(ESPTab, "📏 Distance ESP", function(enabled)
        ESPDistanceEnabled = enabled
    end)
    
    createToggle(ESPTab, "📍 Tracer ESP", function(enabled)
        ESPTracerEnabled = enabled
    end)
    
    createToggle(ESPTab, "💀 Skeleton ESP", function(enabled)
        ESPSkeletonEnabled = enabled
    end)
    
    createToggle(ESPTab, "👥 Team Check (Takımı Gizle)", function(enabled)
        ESPTeamCheck = enabled
        print("[ESP] Team Check:", enabled and "ON (Takım gizli)" or "OFF (Herkesi göster)")
    end)
end

-- Placeholder content for other tabs
createToggle(PlayerTab, "🏃 Speed Hack", function(enabled)
    print("[Player] Speed Hack:", enabled)
end)

createToggle(PlayerTab, "✈️ Fly Mode", function(enabled)
    print("[Player] Fly Mode:", enabled)
end)

createButton(MiscTab, "🔄 Rejoin Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- Minimize functionality
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 350, 0, 65)
        }):Play()
        MinimizeBtn.Text = "□"
    else
        TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 750, 0, 550)
        }):Play()
        MinimizeBtn.Text = "—"
    end
end)

-- Draggable (MainContainer.Draggable = true olduğu için otomatik çalışır)
-- Ek kod gerekmez, Roblox otomatik handle eder

-- Klavye kısayolları
local visible = true
local mouseEnabled = false

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    -- T = Toggle GUI
    if input.KeyCode == Enum.KeyCode.T then
        visible = not visible
        MainContainer.Visible = visible
    end
    
    -- U = Toggle Mouse
    if input.KeyCode == Enum.KeyCode.U then
        mouseEnabled = not mouseEnabled
        UserInputService.MouseIconEnabled = mouseEnabled
        
        if mouseEnabled then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            print("[D-Day] Mouse: ENABLED (Press U to disable)")
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            print("[D-Day] Mouse: DISABLED (Press U to enable)")
        end
    end
end)

-- Intro animation
MainContainer.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 750, 0, 550)
}):Play()

print("[D-Day] GUI v1.0 loaded!")
print("[D-Day] Press T to toggle GUI")
print("[D-Day] Press U to toggle Mouse")
print("[D-Day] ESP optimized for 60+ FPS")
