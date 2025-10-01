--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              Warfare Tycoon GUI v3.0                      ║
    ║                  by Lahmacun581                           ║
    ║         Modern UI | Minimize | Clean Destroy             ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[Warfare Tycoon] Loading GUI v3.0...")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Global state
getgenv().WarfareTycoon = getgenv().WarfareTycoon or {
    Version = "3.0",
    Enabled = {},
    Connections = {},
    ESPObjects = {}
}

-- Cleanup function
local function cleanup()
    print("[Warfare Tycoon] Cleaning up...")
    
    -- Destroy GUI
    if getgenv().WarfareTycoon.ScreenGui then
        pcall(function()
            getgenv().WarfareTycoon.ScreenGui:Destroy()
        end)
        getgenv().WarfareTycoon.ScreenGui = nil
    end
    
    -- Disconnect all connections
    if getgenv().WarfareTycoon.Connections then
        for _, conn in pairs(getgenv().WarfareTycoon.Connections) do
            pcall(function()
                conn:Disconnect()
            end)
        end
        getgenv().WarfareTycoon.Connections = {}
    end
    
    -- Clean ESP
    if getgenv().WarfareTycoon.ESPObjects then
        for player, data in pairs(getgenv().WarfareTycoon.ESPObjects) do
            pcall(function()
                if data.billboard then data.billboard:Destroy() end
            end)
        end
        getgenv().WarfareTycoon.ESPObjects = {}
    end
    
    -- Reset enabled states
    getgenv().WarfareTycoon.Enabled = {}
    
    print("[Warfare Tycoon] Cleanup complete!")
end

-- Cleanup old GUI if exists
if PlayerGui:FindFirstChild("WarfareTycoonGUI") then
    cleanup()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WarfareTycoonGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

getgenv().WarfareTycoon.ScreenGui = ScreenGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 500)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

-- Shadow effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 15)

-- Gradient for Title Bar
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 50))
}
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 25)
TitleFix.Position = UDim2.new(0, 0, 1, -25)
TitleFix.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

-- Gradient for Fix
local TitleFixGradient = Instance.new("UIGradient")
TitleFixGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 50))
}
TitleFixGradient.Rotation = 90
TitleFixGradient.Parent = TitleFix

-- Title Icon
local TitleIcon = Instance.new("TextLabel")
TitleIcon.Size = UDim2.new(0, 40, 0, 40)
TitleIcon.Position = UDim2.new(0, 10, 0, 5)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Text = "⚔️"
TitleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleIcon.TextSize = 24
TitleIcon.Font = Enum.Font.GothamBold
TitleIcon.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -200, 1, 0)
TitleText.Position = UDim2.new(0, 55, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Warfare Tycoon v3.0"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 20
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -90, 0, 7.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MinimizeBtn.Text = ""
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = TitleBar

Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 8)

-- Minimize Icon (Line)
local MinimizeIcon = Instance.new("Frame")
MinimizeIcon.Size = UDim2.new(0, 16, 0, 2)
MinimizeIcon.Position = UDim2.new(0.5, -8, 0.5, -1)
MinimizeIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MinimizeIcon.BorderSizePixel = 0
MinimizeIcon.Parent = MinimizeBtn

Instance.new("UICorner", MinimizeIcon).CornerRadius = UDim.new(0, 1)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -50, 0, 7.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
CloseBtn.Text = ""
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- Close Icon (X)
local CloseIcon1 = Instance.new("Frame")
CloseIcon1.Size = UDim2.new(0, 16, 0, 2)
CloseIcon1.Position = UDim2.new(0.5, -8, 0.5, -1)
CloseIcon1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseIcon1.BorderSizePixel = 0
CloseIcon1.Rotation = 45
CloseIcon1.Parent = CloseBtn

Instance.new("UICorner", CloseIcon1).CornerRadius = UDim.new(0, 1)

local CloseIcon2 = Instance.new("Frame")
CloseIcon2.Size = UDim2.new(0, 16, 0, 2)
CloseIcon2.Position = UDim2.new(0.5, -8, 0.5, -1)
CloseIcon2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseIcon2.BorderSizePixel = 0
CloseIcon2.Rotation = -45
CloseIcon2.Parent = CloseBtn

Instance.new("UICorner", CloseIcon2).CornerRadius = UDim.new(0, 1)

-- Tab Container (Left Sidebar)
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 130, 1, -70)
TabContainer.Position = UDim2.new(0, 10, 0, 60)
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TabContainer.BorderSizePixel = 0
TabContainer.ScrollBarThickness = 4
TabContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 70, 70)
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.Parent = MainFrame

Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 12)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabContainer

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
end)

-- Content Container (Right Side)
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(0, 490, 1, -70)
ContentContainer.Position = UDim2.new(0, 150, 0, 60)
ContentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 12)

-- Tab System
local tabs = {}
local currentTab = nil

local function createTab(name, icon, color)
    -- Tab Button
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -10, 0, 45)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = TabContainer
    
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)
    
    -- Tab Icon
    local tabIcon = Instance.new("TextLabel")
    tabIcon.Size = UDim2.new(0, 30, 0, 30)
    tabIcon.Position = UDim2.new(0, 5, 0, 7.5)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Text = icon
    tabIcon.TextSize = 18
    tabIcon.Font = Enum.Font.GothamBold
    tabIcon.TextColor3 = Color3.fromRGB(150, 150, 160)
    tabIcon.Parent = tabBtn
    
    -- Tab Label
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, -40, 1, 0)
    tabLabel.Position = UDim2.new(0, 40, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = name
    tabLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    tabLabel.TextSize = 13
    tabLabel.Font = Enum.Font.GothamSemibold
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Parent = tabBtn
    
    -- Tab Content
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, -20, 1, -20)
    tabContent.Position = UDim2.new(0, 10, 0, 10)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 70, 70)
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.Visible = false
    tabContent.Parent = ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = tabContent
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    tabs[name] = {
        button = tabBtn,
        content = tabContent,
        icon = tabIcon,
        label = tabLabel,
        color = color
    }
    
    -- Tab Click
    tabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            TweenService:Create(tab.button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
            tab.icon.TextColor3 = Color3.fromRGB(150, 150, 160)
            tab.label.TextColor3 = Color3.fromRGB(150, 150, 160)
            tab.content.Visible = false
        end
        
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
        tabIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabContent.Visible = true
        currentTab = name
    end)
    
    return tabContent
end

-- Create Tabs
local TycoonTab = createTab("Tycoon", "🏭", Color3.fromRGB(50, 150, 50))
local CombatTab = createTab("Combat", "⚔️", Color3.fromRGB(255, 70, 70))
local PlayerTab = createTab("Player", "🏃", Color3.fromRGB(100, 150, 255))
local VisualsTab = createTab("Visuals", "👁️", Color3.fromRGB(150, 100, 255))
local MiscTab = createTab("Misc", "🎮", Color3.fromRGB(255, 200, 0))

-- Initialize all tabs (make them visible briefly to render content)
for _, tab in pairs(tabs) do
    tab.content.Visible = true
end

task.wait(0.1)

-- Then hide all except first
for _, tab in pairs(tabs) do
    tab.content.Visible = false
end

-- Open first tab
tabs["Tycoon"].button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
tabs["Tycoon"].icon.TextColor3 = Color3.fromRGB(255, 255, 255)
tabs["Tycoon"].label.TextColor3 = Color3.fromRGB(255, 255, 255)
tabs["Tycoon"].content.Visible = true

-- Helper Functions
local function createToggle(parent, text, callback)
    local enabled = false
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = text .. ": " .. (enabled and "ON" or "OFF")
        
        if enabled then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 200, 100)}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
        end
        
        if callback then
            pcall(function() callback(enabled) end)
        end
    end)
    
    return btn
end

local function createSlider(parent, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 60)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    container.Parent = parent
    
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 0, 35)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBg.Parent = container
    
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    sliderFill.Parent = sliderBg
    
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 3)
    
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
            local pos = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
            pos = math.clamp(pos, 0, 1)
            
            local value = math.floor(min + (max - min) * pos)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            label.Text = text .. ": " .. value
            
            if callback then
                pcall(function() callback(value) end)
            end
        end
    end)
    
    return container
end

local function createDropdown(parent, text, options, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 45)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    container.Parent = parent
    
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text .. ": " .. options[1]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = container
    
    local currentIndex = 1
    
    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then
            currentIndex = 1
        end
        
        btn.Text = text .. ": " .. options[currentIndex]
        
        if callback then
            pcall(function() callback(options[currentIndex]) end)
        end
    end)
    
    return container
end

-- ===== COMBAT TAB =====
do
    -- No Spread
    getgenv().WarfareTycoon.Enabled.NoSpread = false
    createToggle(CombatTab, "💥 No Spread", function(enabled)
        getgenv().WarfareTycoon.Enabled.NoSpread = enabled
    end)
    
    RunService.Heartbeat:Connect(function()
        if getgenv().WarfareTycoon.Enabled.NoSpread then
            local char = LocalPlayer.Character
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, obj in ipairs(tool:GetDescendants()) do
                            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                                local name = string.lower(obj.Name)
                                if string.find(name, "spread") or string.find(name, "accuracy") or string.find(name, "bloom") then
                                    obj.Value = 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- Hitbox Expander
    getgenv().WarfareTycoon.Enabled.Hitbox = false
    getgenv().WarfareTycoon.HitboxSize = 10
    getgenv().WarfareTycoon.HitboxPart = "Head"
    
    createToggle(CombatTab, "📦 Hitbox Expander", function(enabled)
        getgenv().WarfareTycoon.Enabled.Hitbox = enabled
        
        if not enabled then
            -- Restore original sizes
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local part = player.Character:FindFirstChild(getgenv().WarfareTycoon.HitboxPart)
                    if part and part:IsA("BasePart") then
                        -- Reset to original size
                        if getgenv().WarfareTycoon.HitboxPart == "Head" then
                            part.Size = Vector3.new(2, 1, 1)
                        elseif getgenv().WarfareTycoon.HitboxPart == "Torso" or getgenv().WarfareTycoon.HitboxPart == "UpperTorso" then
                            part.Size = Vector3.new(2, 2, 1)
                        elseif getgenv().WarfareTycoon.HitboxPart == "LeftArm" or getgenv().WarfareTycoon.HitboxPart == "RightArm" then
                            part.Size = Vector3.new(1, 2, 1)
                        elseif getgenv().WarfareTycoon.HitboxPart == "LeftLeg" or getgenv().WarfareTycoon.HitboxPart == "RightLeg" then
                            part.Size = Vector3.new(1, 2, 1)
                        end
                        part.Transparency = 0
                        part.CanCollide = true
                        part.Massless = false
                    end
                end
            end
        end
    end)
    
    createSlider(CombatTab, "   Hitbox Size", 5, 50, 10, function(value)
        getgenv().WarfareTycoon.HitboxSize = value
    end)
    
    createDropdown(CombatTab, "   Hitbox Part", {"Head", "Torso", "UpperTorso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}, function(value)
        getgenv().WarfareTycoon.HitboxPart = value
    end)
    
    local hitboxFrameCount = 0
    RunService.Heartbeat:Connect(function()
        if getgenv().WarfareTycoon.Enabled.Hitbox then
            hitboxFrameCount = hitboxFrameCount + 1
            if hitboxFrameCount % 10 ~= 0 then return end
            
            local size = getgenv().WarfareTycoon.HitboxSize
            local partName = getgenv().WarfareTycoon.HitboxPart
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local part = player.Character:FindFirstChild(partName)
                    if part and part:IsA("BasePart") then
                        part.Size = Vector3.new(size, size, size)
                        part.Transparency = 0.5
                        part.CanCollide = false
                        part.Massless = true
                    end
                end
            end
        end
    end)
end

print("[Warfare Tycoon] Combat features loaded!")
print("[Warfare Tycoon] Features: No Spread, Hitbox Expander")

-- Minimize/Maximize functionality
local isMinimized = false

MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Minimize
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 300, 0, 50)
        }):Play()
        
        ContentContainer.Visible = false
        
        -- Change icon to maximize (square)
        MinimizeIcon.Size = UDim2.new(0, 12, 0, 12)
        MinimizeIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
        
        print("[Warfare Tycoon] GUI minimized")
    else
        -- Maximize
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 650, 0, 500)
        }):Play()
        
        task.wait(0.3)
        ContentContainer.Visible = true
        
        -- Change icon back to minimize (line)
        MinimizeIcon.Size = UDim2.new(0, 16, 0, 2)
        MinimizeIcon.Position = UDim2.new(0.5, -8, 0.5, -1)
        
        print("[Warfare Tycoon] GUI maximized")
    end
end)

-- Close functionality
CloseBtn.MouseButton1Click:Connect(function()
    print("[Warfare Tycoon] Closing GUI...")
    
    -- Fade out animation
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(TitleBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(TabContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(ContentContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    }):Play()
    
    for _, child in pairs(MainFrame:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                TextTransparency = 1
            }):Play()
        end
        if child:IsA("Frame") and child.Name ~= "Shadow" then
            TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1
            }):Play()
        end
    end
    
    task.wait(0.35)
    
    -- Complete cleanup
    cleanup()
end)

-- Hover effects for buttons
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = normalColor
        }):Play()
    end)
end

addHoverEffect(MinimizeBtn, Color3.fromRGB(50, 50, 60), Color3.fromRGB(100, 100, 120))
addHoverEffect(CloseBtn, Color3.fromRGB(50, 50, 60), Color3.fromRGB(220, 60, 60))

-- Keybind to toggle GUI (Right Shift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
        
        if MainFrame.Visible then
            print("[Warfare Tycoon] GUI shown (Right Shift)")
        else
            print("[Warfare Tycoon] GUI hidden (Right Shift)")
        end
    end
end)

print("[Warfare Tycoon] GUI v3.0 loaded successfully!")
print("[Warfare Tycoon] Press Right Shift to toggle GUI")
print("[Warfare Tycoon] Ready for feature development!")
