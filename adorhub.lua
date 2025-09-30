--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                      AdorHUB v2.0                         ║
    ║              Universal Roblox Script Hub                  ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

-- Cleanup eski GUI
if getgenv().AdorHUB then
    pcall(function()
        if getgenv().AdorHUB.ScreenGui then
            getgenv().AdorHUB.ScreenGui:Destroy()
        end
        if getgenv().AdorHUB.Connections then
            for _, conn in pairs(getgenv().AdorHUB.Connections) do
                conn:Disconnect()
            end
        end
    end)
    print("[AdorHUB] Eski GUI temizlendi")
end

-- Global state
getgenv().AdorHUB = {
    Version = "2.0",
    ScreenGui = nil,
    Connections = {},
    Enabled = {}
}

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdorHUB"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui
getgenv().AdorHUB.ScreenGui = ScreenGui

-- Main Frame (Modern Design)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Gradient Background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Glow Effect (Shadow)
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Title Gradient
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 50, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 50, 200))
}
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

-- Logo/Icon
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 40, 0, 40)
Logo.Position = UDim2.new(0, 10, 0, 5)
Logo.BackgroundTransparency = 1
Logo.Text = "🎮"
Logo.TextSize = 28
Logo.Font = Enum.Font.SourceSansBold
Logo.Parent = TitleBar

-- Title Text
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0, 55, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "AdorHUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0, 200, 0, 15)
Subtitle.Position = UDim2.new(0, 55, 0, 32)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Universal Script Hub v1.0"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 160)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 7.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Close hover effect
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -85, 0, 7.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeBtn

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 140, 1, -60)
TabContainer.Position = UDim2.new(0, 10, 0, 55)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 10)
TabCorner.Parent = TabContainer

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 8)
TabList.Parent = TabContainer

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.PaddingLeft = UDim.new(0, 10)
TabPadding.PaddingRight = UDim.new(0, 10)
TabPadding.Parent = TabContainer

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(0, 430, 1, -60)
ContentContainer.Position = UDim2.new(0, 160, 0, 55)
ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentContainer

-- Tab System
local tabs = {}
local currentTab = nil

local function createTab(name, icon, color)
    -- Tab Button
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -10, 0, 40)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = TabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabBtn
    
    -- Tab Icon
    local tabIcon = Instance.new("TextLabel")
    tabIcon.Size = UDim2.new(0, 30, 0, 30)
    tabIcon.Position = UDim2.new(0, 5, 0, 5)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Text = icon
    tabIcon.TextSize = 20
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
    tabLabel.TextSize = 14
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
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    tabContent.Visible = false
    tabContent.Parent = ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = tabContent
    
    -- Auto-update canvas size
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.Parent = tabContent
    
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
    
    -- Hover effect
    tabBtn.MouseEnter:Connect(function()
        if currentTab ~= name then
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if currentTab ~= name then
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
        end
    end)
    
    return tabContent
end

-- Create Tabs
local PlayerTab = createTab("Player", "🏃", Color3.fromRGB(100, 150, 255))
local CombatTab = createTab("Combat", "⚔️", Color3.fromRGB(255, 100, 100))
local VisualsTab = createTab("Visuals", "👁️", Color3.fromRGB(100, 255, 150))
local MiscTab = createTab("Misc", "⚙️", Color3.fromRGB(200, 150, 255))

-- Open first tab
tabs["Player"].button.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
tabs["Player"].icon.TextColor3 = Color3.fromRGB(255, 255, 255)
tabs["Player"].label.TextColor3 = Color3.fromRGB(255, 255, 255)
tabs["Player"].content.Visible = true
currentTab = "Player"

-- Dragging System
do
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Close Button
CloseBtn.MouseButton1Click:Connect(function()
    -- Fade out animation
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.3)
    
    -- Cleanup
    pcall(function()
        if getgenv().AdorHUB.Connections then
            for _, conn in pairs(getgenv().AdorHUB.Connections) do
                conn:Disconnect()
            end
        end
        ScreenGui:Destroy()
    end)
    
    getgenv().AdorHUB = nil
    print("[AdorHUB] GUI kapatıldı")
end)

-- Minimize Button
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 50)}):Play()
        MinimizeBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 400)}):Play()
        MinimizeBtn.Text = "−"
    end
end)

-- Intro Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 600, 0, 400)
}):Play()

-- Welcome notification
task.wait(0.5)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "AdorHUB",
    Text = "Başarıyla yüklendi! v1.0",
    Duration = 3
})

-- Helper function to create buttons
local function createButton(parent, text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(
            math.min(color.R + 0.1, 1),
            math.min(color.G + 0.1, 1),
            math.min(color.B + 0.1, 1)
        )}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end)
    
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    
    return btn
end

-- Helper function to create toggle buttons
local function createToggle(parent, text, color, callback)
    local enabled = false
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.BackgroundColor3 = color
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        if not enabled then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(
                math.min(color.R + 0.1, 1),
                math.min(color.G + 0.1, 1),
                math.min(color.B + 0.1, 1)
            )}):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if not enabled then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
        end
    end)
    
    -- Click handler
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = text .. ": " .. (enabled and "ON" or "OFF")
        
        if enabled then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 200, 100)}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
        end
        
        print("[AdorHUB] " .. text .. " toggled: " .. tostring(enabled))
        
        if callback then
            local success, err = pcall(function()
                callback(enabled)
            end)
            if not success then
                warn("[AdorHUB] Error in " .. text .. " callback: " .. tostring(err))
            end
        end
    end)
    
    return btn, function() return enabled end
end

-- Helper function to create slider
local function createSlider(parent, text, min, max, default, callback)
    local value = default
    
    -- Container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 70)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Slider Background
    local sliderBG = Instance.new("Frame")
    sliderBG.Size = UDim2.new(1, -20, 0, 8)
    sliderBG.Position = UDim2.new(0, 10, 0, 35)
    sliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    sliderBG.BorderSizePixel = 0
    sliderBG.Parent = container
    
    local sliderBGCorner = Instance.new("UICorner")
    sliderBGCorner.CornerRadius = UDim.new(0, 4)
    sliderBGCorner.Parent = sliderBG
    
    -- Slider Fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBG
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 4)
    sliderFillCorner.Parent = sliderFill
    
    -- Min/Max Labels
    local minLabel = Instance.new("TextLabel")
    minLabel.Size = UDim2.new(0, 40, 0, 15)
    minLabel.Position = UDim2.new(0, 10, 0, 50)
    minLabel.BackgroundTransparency = 1
    minLabel.Text = tostring(min)
    minLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    minLabel.TextSize = 11
    minLabel.Font = Enum.Font.Gotham
    minLabel.TextXAlignment = Enum.TextXAlignment.Left
    minLabel.Parent = container
    
    local maxLabel = Instance.new("TextLabel")
    maxLabel.Size = UDim2.new(0, 40, 0, 15)
    maxLabel.Position = UDim2.new(1, -50, 0, 50)
    maxLabel.BackgroundTransparency = 1
    maxLabel.Text = tostring(max)
    maxLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    maxLabel.TextSize = 11
    maxLabel.Font = Enum.Font.Gotham
    maxLabel.TextXAlignment = Enum.TextXAlignment.Right
    maxLabel.Parent = container
    
    -- Slider interaction
    local dragging = false
    
    sliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderBG.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local sliderPos = sliderBG.AbsolutePosition.X
            local sliderSize = sliderBG.AbsoluteSize.X
            local relativePos = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            value = math.floor(min + (relativePos * (max - min)))
            label.Text = text .. ": " .. value
            
            if callback then
                callback(value)
            end
        end
    end)
    
    return container, function() return value end, function(newValue)
        value = math.clamp(newValue, min, max)
        local relativePos = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
        if label then
            label.Text = text .. ": " .. value
        end
    end
end

-- ===== PLAYER TAB =====
do
    -- Speed Hack with Slider
    getgenv().AdorHUB.Enabled.Speed = false
    getgenv().AdorHUB.SpeedValue = 100
    
    createToggle(PlayerTab, "🏃 Speed Hack", Color3.fromRGB(100, 150, 255), function(enabled)
        getgenv().AdorHUB.Enabled.Speed = enabled
        print("[AdorHUB] Speed Hack: " .. tostring(enabled))
        
        if not enabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 16
            end
        end
    end)
    
    createSlider(PlayerTab, "   Speed Value", 16, 500, 100, function(value)
        getgenv().AdorHUB.SpeedValue = value
        print("[AdorHUB] Speed set to: " .. value)
    end)
    
    -- Speed Loop (Always running)
    RunService.Heartbeat:Connect(function()
        if getgenv().AdorHUB.Enabled.Speed then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = getgenv().AdorHUB.SpeedValue
            end
        end
    end)
    
    -- Super Jump
    getgenv().AdorHUB.Enabled.Jump = false
    
    createToggle(PlayerTab, "🦘 Super Jump", Color3.fromRGB(150, 100, 255), function(enabled)
        getgenv().AdorHUB.Enabled.Jump = enabled
        print("[AdorHUB] Super Jump: " .. tostring(enabled))
        
        if not enabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = 50
            end
        end
    end)
    
    -- Jump Loop
    RunService.Heartbeat:Connect(function()
        if getgenv().AdorHUB.Enabled.Jump then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = 120
            end
        end
    end)
    
    -- Infinite Jump
    getgenv().AdorHUB.Enabled.InfJump = false
    
    createToggle(PlayerTab, "♾️ Infinite Jump", Color3.fromRGB(255, 150, 100), function(enabled)
        getgenv().AdorHUB.Enabled.InfJump = enabled
        print("[AdorHUB] Infinite Jump: " .. tostring(enabled))
    end)
    
    -- Infinite Jump Handler
    UserInputService.JumpRequest:Connect(function()
        if getgenv().AdorHUB.Enabled.InfJump then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    
    -- Fly with Slider
    local flyEnabled = false
    local flyConn
    local flySpeed = 50
    local flyBG, flyBV
    
    createToggle(PlayerTab, "✈️ Fly Mode", Color3.fromRGB(100, 200, 255), function(enabled)
        flyEnabled = enabled
        
        if enabled then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = char.HumanoidRootPart
            flyBG = Instance.new("BodyGyro")
            flyBG.P = 9e4
            flyBG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            flyBG.cframe = hrp.CFrame
            flyBG.Parent = hrp
            
            flyBV = Instance.new("BodyVelocity")
            flyBV.velocity = Vector3.new(0, 0, 0)
            flyBV.maxForce = Vector3.new(9e9, 9e9, 9e9)
            flyBV.Parent = hrp
            
            flyConn = RunService.Heartbeat:Connect(function()
                if not flyEnabled then return end
                
                local cam = workspace.CurrentCamera
                local direction = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + (cam.CFrame.LookVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - (cam.CFrame.LookVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - (cam.CFrame.RightVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + (cam.CFrame.RightVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + (Vector3.new(0, flySpeed, 0))
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - (Vector3.new(0, flySpeed, 0))
                end
                
                if flyBV then
                    flyBV.velocity = direction
                end
                if flyBG then
                    flyBG.cframe = cam.CFrame
                end
            end)
            
            getgenv().AdorHUB.Connections.Fly = flyConn
        else
            if flyConn then 
                flyConn:Disconnect()
                flyConn = nil
            end
            if flyBG then flyBG:Destroy() flyBG = nil end
            if flyBV then flyBV:Destroy() flyBV = nil end
        end
    end)
    
    createSlider(PlayerTab, "   Fly Speed", 10, 200, 50, function(value)
        flySpeed = value
    end)
    
    -- Noclip
    getgenv().AdorHUB.Enabled.Noclip = false
    
    createToggle(PlayerTab, "👻 Noclip", Color3.fromRGB(200, 100, 255), function(enabled)
        getgenv().AdorHUB.Enabled.Noclip = enabled
        print("[AdorHUB] Noclip: " .. tostring(enabled))
        
        if not enabled then
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end)
    
    -- Noclip Loop
    RunService.Stepped:Connect(function()
        if getgenv().AdorHUB.Enabled.Noclip then
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
    
    -- God Mode (Advanced - Anti-Damage + Force Field)
    getgenv().AdorHUB.Enabled.God = false
    
    createToggle(PlayerTab, "🛡️ God Mode", Color3.fromRGB(255, 200, 100), function(enabled)
        getgenv().AdorHUB.Enabled.God = enabled
        print("[AdorHUB] God Mode: " .. tostring(enabled))
        
        local char = LocalPlayer.Character
        if char then
            -- Remove existing force field
            local existingFF = char:FindFirstChild("ForceField")
            if existingFF then
                existingFF:Destroy()
            end
            
            if enabled then
                -- Add invisible force field
                local ff = Instance.new("ForceField")
                ff.Visible = false
                ff.Name = "AdorHUB_FF"
                ff.Parent = char
            end
        end
    end)
    
    -- God Mode Loop (Optimized for FPS)
    local godFrameCount = 0
    RunService.Heartbeat:Connect(function()
        if getgenv().AdorHUB.Enabled.God then
            godFrameCount = godFrameCount + 1
            
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    -- 1. Restore health instantly (every frame - critical)
                    if hum.Health < hum.MaxHealth then
                        hum.Health = hum.MaxHealth
                    end
                    
                    -- 2. Prevent death states (every frame - critical)
                    if hum.Health <= 0 then
                        hum.Health = hum.MaxHealth
                    end
                    
                    -- 3. Remove negative effects (every 10 frames - not critical)
                    if godFrameCount % 10 == 0 then
                        for _, effect in pairs(hum:GetChildren()) do
                            if effect:IsA("NumberValue") and effect.Name == "creator" then
                                pcall(function() effect:Destroy() end)
                            end
                        end
                    end
                end
                
                -- 4. Ensure force field exists (every 30 frames - not critical)
                if godFrameCount % 30 == 0 then
                    if not char:FindFirstChild("AdorHUB_FF") then
                        local ff = Instance.new("ForceField")
                        ff.Visible = false
                        ff.Name = "AdorHUB_FF"
                        ff.Parent = char
                    end
                end
                
                -- 5. Remove damage indicators (every 20 frames - not critical)
                if godFrameCount % 20 == 0 then
                    for _, obj in pairs(char:GetDescendants()) do
                        if obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                            pcall(function() obj:Destroy() end)
                        end
                    end
                end
            end
        else
            -- Remove force field when disabled
            local char = LocalPlayer.Character
            if char then
                local ff = char:FindFirstChild("AdorHUB_FF")
                if ff then
                    ff:Destroy()
                end
            end
        end
    end)
    
    -- God Mode: Prevent death on respawn
    LocalPlayer.CharacterAdded:Connect(function(char)
        if getgenv().AdorHUB.Enabled.God then
            task.wait(0.1)
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.Health = hum.MaxHealth
                
                -- Add force field
                local ff = Instance.new("ForceField")
                ff.Visible = false
                ff.Name = "AdorHUB_FF"
                ff.Parent = char
            end
        end
    end)
    
    -- Teleport to Mouse
    createButton(PlayerTab, "🎯 Teleport to Mouse", Color3.fromRGB(150, 150, 255), function()
        local mouse = LocalPlayer:GetMouse()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and mouse.Hit then
            char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)
    
    -- Reset Character
    createButton(PlayerTab, "🔄 Reset Character", Color3.fromRGB(200, 100, 100), function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end)
end

-- ===== COMBAT TAB =====
do
    -- No Recoil
    local recoilConn
    createToggle(CombatTab, "🎯 No Recoil", Color3.fromRGB(150, 100, 200), function(enabled)
        if enabled then
            recoilConn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            for _, obj in ipairs(tool:GetDescendants()) do
                                if (obj:IsA("NumberValue") or obj:IsA("IntValue")) then
                                    local name = string.lower(obj.Name)
                                    if string.find(name, "recoil") then
                                        obj.Value = 0
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            if recoilConn then recoilConn:Disconnect() end
        end
    end)
    
    -- No Spread
    local spreadConn
    createToggle(CombatTab, "💥 No Spread", Color3.fromRGB(255, 150, 100), function(enabled)
        if enabled then
            spreadConn = RunService.Heartbeat:Connect(function()
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
            end)
        else
            if spreadConn then spreadConn:Disconnect() end
        end
    end)
    
    -- Silent Aim
    getgenv().AdorHUB.Enabled.SilentAim = false
    getgenv().AdorHUB.SilentAimFOV = 200
    
    createToggle(CombatTab, "🎯 Silent Aim", Color3.fromRGB(255, 100, 150), function(enabled)
        getgenv().AdorHUB.Enabled.SilentAim = enabled
        print("[AdorHUB] Silent Aim: " .. tostring(enabled))
    end)
    
    createSlider(CombatTab, "   Silent Aim FOV", 50, 500, 200, function(value)
        getgenv().AdorHUB.SilentAimFOV = value
    end)
    
    -- Silent Aim Hook
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if getgenv().AdorHUB.Enabled.SilentAim and (method == "FireServer" or method == "InvokeServer") then
            -- Find closest player
            local camera = workspace.CurrentCamera
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myPos = myChar.HumanoidRootPart.Position
                local closestPlayer = nil
                local closestDist = getgenv().AdorHUB.SilentAimFOV
                
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        local head = player.Character:FindFirstChild("Head")
                        if hrp and head then
                            local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                            if onScreen then
                                local mousePos = UserInputService:GetMouseLocation()
                                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    closestPlayer = player
                                end
                            end
                        end
                    end
                end
                
                -- Redirect to closest player's head
                if closestPlayer and closestPlayer.Character then
                    local head = closestPlayer.Character:FindFirstChild("Head")
                    if head then
                        -- Modify args to target head
                        for i, arg in ipairs(args) do
                            if typeof(arg) == "Vector3" then
                                args[i] = head.Position
                            elseif typeof(arg) == "CFrame" then
                                args[i] = head.CFrame
                            end
                        end
                    end
                end
            end
        end
        
        return oldNamecall(self, unpack(args))
    end)
    
    -- Hitbox Expander (Real Hitbox)
    getgenv().AdorHUB.Enabled.Hitbox = false
    getgenv().AdorHUB.HitboxSize = 20
    
    createToggle(CombatTab, "📦 Hitbox Expander", Color3.fromRGB(200, 100, 200), function(enabled)
        getgenv().AdorHUB.Enabled.Hitbox = enabled
        print("[AdorHUB] Hitbox Expander: " .. tostring(enabled))
        
        if not enabled then
            -- Restore normal head size
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        head.Size = Vector3.new(2, 1, 1)
                        head.Transparency = 0
                        head.CanCollide = true
                    end
                end
            end
        end
    end)
    
    createSlider(CombatTab, "   Hitbox Size", 5, 50, 20, function(value)
        getgenv().AdorHUB.HitboxSize = value
        print("[AdorHUB] Hitbox size set to: " .. value)
    end)
    
    -- Hitbox Loop (Ultra Optimized - Only Head, Every 5 frames)
    local hitboxFrameCount = 0
    RunService.Heartbeat:Connect(function()
        if getgenv().AdorHUB.Enabled.Hitbox then
            hitboxFrameCount = hitboxFrameCount + 1
            if hitboxFrameCount % 5 ~= 0 then return end -- Update every 5 frames for max FPS
            
            local size = getgenv().AdorHUB.HitboxSize
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        head.Size = Vector3.new(size, size, size)
                        head.Transparency = 0.7
                        head.CanCollide = false
                        head.Massless = true
                    end
                end
            end
        end
    end)
end

-- ===== VISUALS TAB =====
do
    -- ESP System (Advanced)
    local ESPEnabled = false
    local ESPBoxEnabled = true
    local ESPNameEnabled = true
    local ESPHealthEnabled = true
    local ESPDistanceEnabled = true
    local ESPTracerEnabled = false
    local ESPObjects = {}
    local ESPUpdateConn
    
    -- Helper function to create ESP for a player
    local function createESP(player)
        if player == LocalPlayer then return end
        if ESPObjects[player] then return end
        
        local function setupESP()
            local char = player.Character
            if not char then return end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChild("Humanoid")
            if not hrp or not humanoid then return end
            
            local espData = {}
            
            -- Box ESP (Drawing)
            if Drawing then
                espData.boxOutline = Drawing.new("Square")
                espData.boxOutline.Visible = false
                espData.boxOutline.Color = Color3.new(0, 0, 0)
                espData.boxOutline.Thickness = 3
                espData.boxOutline.Filled = false
                
                espData.box = Drawing.new("Square")
                espData.box.Visible = false
                espData.box.Color = Color3.new(1, 1, 1)
                espData.box.Thickness = 1
                espData.box.Filled = false
                
                -- Tracer
                espData.tracer = Drawing.new("Line")
                espData.tracer.Visible = false
                espData.tracer.Color = Color3.new(1, 1, 1)
                espData.tracer.Thickness = 1
            end
            
            -- Billboard GUI (Name, Health, Distance)
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESP_" .. player.Name
            billboard.Adornee = hrp
            billboard.Size = UDim2.new(0, 200, 0, 100)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = hrp
            
            -- Name Label
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0, 20)
            nameLabel.Position = UDim2.new(0, 0, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 14
            nameLabel.Parent = billboard
            
            -- Health Bar Background
            local healthBarBG = Instance.new("Frame")
            healthBarBG.Size = UDim2.new(0, 100, 0, 6)
            healthBarBG.Position = UDim2.new(0.5, -50, 0, 25)
            healthBarBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            healthBarBG.BorderSizePixel = 0
            healthBarBG.Parent = billboard
            
            local healthBarBGCorner = Instance.new("UICorner")
            healthBarBGCorner.CornerRadius = UDim.new(0, 3)
            healthBarBGCorner.Parent = healthBarBG
            
            -- Health Bar Fill
            local healthBar = Instance.new("Frame")
            healthBar.Size = UDim2.new(1, 0, 1, 0)
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            healthBar.BorderSizePixel = 0
            healthBar.Parent = healthBarBG
            
            local healthBarCorner = Instance.new("UICorner")
            healthBarCorner.CornerRadius = UDim.new(0, 3)
            healthBarCorner.Parent = healthBar
            
            -- Health Text
            local healthLabel = Instance.new("TextLabel")
            healthLabel.Size = UDim2.new(1, 0, 0, 15)
            healthLabel.Position = UDim2.new(0, 0, 0, 35)
            healthLabel.BackgroundTransparency = 1
            healthLabel.Text = "100/100"
            healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            healthLabel.TextStrokeTransparency = 0
            healthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            healthLabel.Font = Enum.Font.Gotham
            healthLabel.TextSize = 12
            healthLabel.Parent = billboard
            
            -- Distance Label
            local distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(1, 0, 0, 15)
            distLabel.Position = UDim2.new(0, 0, 0, 52)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = "0m"
            distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            distLabel.TextStrokeTransparency = 0
            distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            distLabel.Font = Enum.Font.Gotham
            distLabel.TextSize = 11
            distLabel.Parent = billboard
            
            espData.billboard = billboard
            espData.nameLabel = nameLabel
            espData.healthBar = healthBar
            espData.healthLabel = healthLabel
            espData.distLabel = distLabel
            espData.character = char
            espData.humanoid = humanoid
            
            ESPObjects[player] = espData
        end
        
        setupESP()
        
        -- Respawn handling
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if ESPEnabled then
                if ESPObjects[player] then
                    -- Clean old ESP
                    local oldData = ESPObjects[player]
                    if oldData.billboard then oldData.billboard:Destroy() end
                    if oldData.box then oldData.box:Remove() end
                    if oldData.boxOutline then oldData.boxOutline:Remove() end
                    if oldData.tracer then oldData.tracer:Remove() end
                    ESPObjects[player] = nil
                end
                createESP(player)
            end
        end)
    end
    
    -- Update ESP
    local function updateESP()
        if not ESPEnabled then return end
        
        local camera = workspace.CurrentCamera
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        local myPos = myChar.HumanoidRootPart.Position
        
        for player, data in pairs(ESPObjects) do
            if player and player.Character then
                local char = player.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChild("Humanoid")
                
                if hrp and humanoid then
                    -- Distance
                    local distance = (hrp.Position - myPos).Magnitude
                    
                    -- Update visibility based on settings
                    if data.nameLabel then
                        data.nameLabel.Visible = ESPNameEnabled
                    end
                    if data.healthBar and data.healthLabel then
                        data.healthBar.Parent.Visible = ESPHealthEnabled
                        data.healthLabel.Visible = ESPHealthEnabled
                        
                        -- Update health
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        data.healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                        
                        -- Health color
                        if healthPercent > 0.6 then
                            data.healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                        elseif healthPercent > 0.3 then
                            data.healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                        else
                            data.healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        end
                        
                        data.healthLabel.Text = string.format("%d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                    end
                    if data.distLabel then
                        data.distLabel.Visible = ESPDistanceEnabled
                        data.distLabel.Text = string.format("%.0fm", distance)
                    end
                    
                    -- Box ESP
                    if data.box and data.boxOutline then
                        local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)
                        
                        if onScreen and ESPBoxEnabled then
                            local head = char:FindFirstChild("Head")
                            local headPos = head and camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or vector
                            local legPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                            
                            local height = math.abs(headPos.Y - legPos.Y)
                            local width = height / 2
                            
                            data.boxOutline.Size = Vector2.new(width, height)
                            data.boxOutline.Position = Vector2.new(vector.X - width/2, vector.Y - height/2)
                            data.boxOutline.Visible = true
                            
                            data.box.Size = Vector2.new(width, height)
                            data.box.Position = Vector2.new(vector.X - width/2, vector.Y - height/2)
                            data.box.Visible = true
                            
                            -- Distance-based color
                            local color = distance < 50 and Color3.new(1, 0, 0) or distance < 100 and Color3.new(1, 1, 0) or Color3.new(1, 1, 1)
                            data.box.Color = color
                        else
                            data.box.Visible = false
                            data.boxOutline.Visible = false
                        end
                    end
                    
                    -- Tracer
                    if data.tracer and ESPTracerEnabled then
                        local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local screenSize = camera.ViewportSize
                            data.tracer.From = Vector2.new(screenSize.X / 2, screenSize.Y)
                            data.tracer.To = Vector2.new(vector.X, vector.Y)
                            data.tracer.Visible = true
                            
                            local color = distance < 50 and Color3.new(1, 0, 0) or distance < 100 and Color3.new(1, 1, 0) or Color3.new(1, 1, 1)
                            data.tracer.Color = color
                        else
                            data.tracer.Visible = false
                        end
                    elseif data.tracer then
                        data.tracer.Visible = false
                    end
                else
                    -- Character invalid, recreate ESP
                    if data.billboard then data.billboard:Destroy() end
                    if data.box then data.box:Remove() end
                    if data.boxOutline then data.boxOutline:Remove() end
                    if data.tracer then data.tracer:Remove() end
                    ESPObjects[player] = nil
                    createESP(player)
                end
            end
        end
    end
    
    -- Main ESP Toggle
    createToggle(VisualsTab, "👁️ ESP Master", Color3.fromRGB(100, 255, 150), function(enabled)
        ESPEnabled = enabled
        
        if enabled then
            -- Create ESP for all existing players
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    task.spawn(function()
                        createESP(player)
                    end)
                end
            end
            
            -- Handle new players joining
            Players.PlayerAdded:Connect(function(player)
                if ESPEnabled and player ~= LocalPlayer then
                    task.wait(1) -- Wait for character to load
                    createESP(player)
                end
            end)
            
            -- Handle player leaving
            Players.PlayerRemoving:Connect(function(player)
                if ESPObjects[player] then
                    local data = ESPObjects[player]
                    pcall(function()
                        if data.billboard then data.billboard:Destroy() end
                        if data.box then data.box:Remove() end
                        if data.boxOutline then data.boxOutline:Remove() end
                        if data.tracer then data.tracer:Remove() end
                    end)
                    ESPObjects[player] = nil
                end
            end)
            
            -- Continuous check for missing ESP (every 5 seconds)
            task.spawn(function()
                while ESPEnabled do
                    task.wait(5)
                    if ESPEnabled then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and not ESPObjects[player] then
                                print("[AdorHUB] Creating missing ESP for: " .. player.Name)
                                createESP(player)
                            end
                        end
                    end
                end
            end)
            
            -- Update loop (optimized - every 2 frames)
            local espFrameCount = 0
            ESPUpdateConn = RunService.RenderStepped:Connect(function()
                espFrameCount = espFrameCount + 1
                if espFrameCount % 2 == 0 then -- Update every 2 frames for FPS
                    updateESP()
                end
            end)
            
            print("[AdorHUB] ESP Master enabled")
        else
            if ESPUpdateConn then
                ESPUpdateConn:Disconnect()
                ESPUpdateConn = nil
            end
            
            -- Clean all ESP
            for player, data in pairs(ESPObjects) do
                pcall(function()
                    if data.billboard then data.billboard:Destroy() end
                    if data.box then data.box:Remove() end
                    if data.boxOutline then data.boxOutline:Remove() end
                    if data.tracer then data.tracer:Remove() end
                end)
            end
            ESPObjects = {}
            
            print("[AdorHUB] ESP Master disabled")
        end
    end)
    
    -- ESP Options (All visible by default)
    local espBoxBtn = createToggle(VisualsTab, "📦 ESP Box", Color3.fromRGB(150, 200, 255), function(enabled)
        ESPBoxEnabled = enabled
        print("[AdorHUB] ESP Box: " .. tostring(enabled))
    end)
    
    local espNameBtn = createToggle(VisualsTab, "📝 ESP Name", Color3.fromRGB(255, 200, 150), function(enabled)
        ESPNameEnabled = enabled
        print("[AdorHUB] ESP Name: " .. tostring(enabled))
    end)
    
    local espHealthBtn = createToggle(VisualsTab, "❤️ ESP Health", Color3.fromRGB(255, 150, 150), function(enabled)
        ESPHealthEnabled = enabled
        print("[AdorHUB] ESP Health: " .. tostring(enabled))
    end)
    
    local espDistBtn = createToggle(VisualsTab, "📏 ESP Distance", Color3.fromRGB(200, 200, 255), function(enabled)
        ESPDistanceEnabled = enabled
        print("[AdorHUB] ESP Distance: " .. tostring(enabled))
    end)
    
    local espTracerBtn = createToggle(VisualsTab, "📍 ESP Tracer", Color3.fromRGB(255, 255, 150), function(enabled)
        ESPTracerEnabled = enabled
        print("[AdorHUB] ESP Tracer: " .. tostring(enabled))
    end)
    
    -- Chams (Wallhack)
    getgenv().AdorHUB.Enabled.Chams = false
    
    createToggle(VisualsTab, "🌈 Chams", Color3.fromRGB(200, 100, 255), function(enabled)
        getgenv().AdorHUB.Enabled.Chams = enabled
        print("[AdorHUB] Chams: " .. tostring(enabled))
        
        if not enabled then
            -- Remove all chams
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part:FindFirstChild("AdorHUB_Cham") then
                            part.AdorHUB_Cham:Destroy()
                        end
                    end
                end
            end
        end
    end)
    
    -- Chams Loop
    RunService.Heartbeat:Connect(function()
        if getgenv().AdorHUB.Enabled.Chams then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            if not part:FindFirstChild("AdorHUB_Cham") then
                                local highlight = Instance.new("SurfaceGui")
                                highlight.Name = "AdorHUB_Cham"
                                highlight.Face = Enum.NormalId.Front
                                highlight.AlwaysOnTop = true
                                highlight.Parent = part
                                
                                local frame = Instance.new("Frame")
                                frame.Size = UDim2.new(1, 0, 1, 0)
                                frame.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
                                frame.BackgroundTransparency = 0.5
                                frame.BorderSizePixel = 0
                                frame.Parent = highlight
                                
                                -- Add to all faces
                                for _, face in pairs(Enum.NormalId:GetEnumItems()) do
                                    local sg = highlight:Clone()
                                    sg.Face = face
                                    sg.Parent = part
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- ===== MISC TAB =====
do
    -- Credits
    local creditsLabel = Instance.new("TextLabel")
    creditsLabel.Size = UDim2.new(1, -20, 0, 80)
    creditsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    creditsLabel.Text = "AdorHUB v2.0\n\nCreated by Lahmacun581\nUniversal Script Hub"
    creditsLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    creditsLabel.TextSize = 14
    creditsLabel.Font = Enum.Font.Gotham
    creditsLabel.Parent = MiscTab
    
    local creditsCorner = Instance.new("UICorner")
    creditsCorner.CornerRadius = UDim.new(0, 8)
    creditsCorner.Parent = creditsLabel
end

print("[AdorHUB] GUI başarıyla yüklendi!")
print("[AdorHUB] Versiyon: 1.0")
print("[AdorHUB] Tüm özellikler aktif!")
print("[AdorHUB] Hazır!")
