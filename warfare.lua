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
local VirtualUser = game:GetService("VirtualUser")

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
    
    -- (moved) Item ESP is initialized under the Visuals section

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

-- ===== PLAYER TAB =====
do
    -- Defaults
    getgenv().WarfareTycoon.PlayerWalkSpeed = getgenv().WarfareTycoon.PlayerWalkSpeed or 16
    getgenv().WarfareTycoon.PlayerJumpPower = getgenv().WarfareTycoon.PlayerJumpPower or 50
    getgenv().WarfareTycoon.Enabled.Spectate = getgenv().WarfareTycoon.Enabled.Spectate or false
    getgenv().WarfareTycoon._SpectateIndex = getgenv().WarfareTycoon._SpectateIndex or 1

    local function applyPlayerStats()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum.WalkSpeed = getgenv().WarfareTycoon.PlayerWalkSpeed
                hum.JumpPower = getgenv().WarfareTycoon.PlayerJumpPower
            end)
        end
    end

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.25)
        applyPlayerStats()
    end)
    applyPlayerStats()

    createSlider(PlayerTab, "🏃 WalkSpeed", 10, 150, getgenv().WarfareTycoon.PlayerWalkSpeed, function(v)
        getgenv().WarfareTycoon.PlayerWalkSpeed = v
        applyPlayerStats()
    end)

    createSlider(PlayerTab, "🦘 JumpPower", 25, 200, getgenv().WarfareTycoon.PlayerJumpPower, function(v)
        getgenv().WarfareTycoon.PlayerJumpPower = v
        applyPlayerStats()
    end)

    createToggle(PlayerTab, "🎥 Spectate", function(enabled)
        getgenv().WarfareTycoon.Enabled.Spectate = enabled
        if not enabled then
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or workspace.CurrentCamera.CameraSubject
        end
    end)

    createButton(PlayerTab, "◀ Prev Target", function()
        local list = Players:GetPlayers()
        if #list == 0 then return end
        getgenv().WarfareTycoon._SpectateIndex = ((getgenv().WarfareTycoon._SpectateIndex - 2) % #list) + 1
    end)

    createButton(PlayerTab, "Next Target ▶", function()
        local list = Players:GetPlayers()
        if #list == 0 then return end
        getgenv().WarfareTycoon._SpectateIndex = (getgenv().WarfareTycoon._SpectateIndex % #list) + 1
    end)

    RunService.RenderStepped:Connect(function()
        if not getgenv().WarfareTycoon.Enabled.Spectate then return end
        local list = Players:GetPlayers()
        if #list < 2 then return end
        local idx = getgenv().WarfareTycoon._SpectateIndex
        local target = list[idx]
        if target == LocalPlayer then
            idx = (idx % #list) + 1
            target = list[idx]
            getgenv().WarfareTycoon._SpectateIndex = idx
        end
        if target and target.Character then
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                workspace.CurrentCamera.CameraSubject = hum
            end
        end
    end)

    local function getHRP(character)
        return character and character:FindFirstChild("HumanoidRootPart")
    end
    local function tpTo(cf)
        local hrp = getHRP(LocalPlayer.Character)
        if hrp and cf then
            pcall(function()
                hrp.CFrame = cf
            end)
        end
    end

    createButton(PlayerTab, "📍 TP to Mouse", function()
        local mouse = LocalPlayer:GetMouse()
        local pos = mouse.Hit and mouse.Hit.p
        if pos then
            tpTo(CFrame.new(pos + Vector3.new(0, 4, 0)))
        end
    end)

    createButton(PlayerTab, "🏭 TP to My Tycoon", function()
        local targetCF
        pcall(function()
            for _, m in ipairs(workspace:GetChildren()) do
                if m:IsA("Model") then
                    local ownerAttr = nil
                    pcall(function() ownerAttr = m:GetAttribute("Owner") end)
                    if (ownerAttr and tostring(ownerAttr) == LocalPlayer.Name) or string.find(string.lower(m.Name), string.lower(LocalPlayer.Name)) then
                        local base = m:FindFirstChildWhichIsA("BasePart")
                        if base then targetCF = base.CFrame + Vector3.new(0, 4, 0) break end
                    end
                end
            end
        end)
        if not targetCF then
            local nearest, best = nil, math.huge
            local myHrp = getHRP(LocalPlayer.Character)
            for _, m in ipairs(workspace:GetChildren()) do
                if m:IsA("Model") and string.find(string.lower(m.Name), "tycoon") then
                    local base = m:FindFirstChildWhichIsA("BasePart")
                    if base and myHrp then
                        local d = (base.Position - myHrp.Position).Magnitude
                        if d < best then best = d nearest = base end
                    end
                end
            end
            if nearest then targetCF = nearest.CFrame + Vector3.new(0, 4, 0) end
        end
        tpTo(targetCF)
    end)

    createButton(PlayerTab, "🎯 TP to Spectate Target", function()
        local list = Players:GetPlayers()
        local idx = getgenv().WarfareTycoon._SpectateIndex
        local target = list[idx]
        if target and target ~= LocalPlayer and target.Character then
            local thrp = getHRP(target.Character)
            if thrp then
                tpTo(thrp.CFrame * CFrame.new(0, 0, -3))
            end
        end
    end)
end
-- (removed: moved PLAYER TAB below)

-- (moved) Player tab content is initialized later, after tabs are created

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

-- Simple button helper
local function createButton(parent, text, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        if onClick then pcall(onClick) end
    end)
    return btn
end

-- ===== TYCOON TAB =====
do
    -- Auto Collect (Near only, no TP/Bring)
    getgenv().WarfareTycoon.Enabled.AutoCollect = false
    createToggle(TycoonTab, "💰 Auto Collect Cash (Near)", function(enabled)
        getgenv().WarfareTycoon.Enabled.AutoCollect = enabled
    end)

    -- Auto Claim/Upgrade (Near only)
    getgenv().WarfareTycoon.Enabled.AutoClaim = false
    createToggle(TycoonTab, "🏗️ Auto Claim / Upgrade (Near)", function(enabled)
        getgenv().WarfareTycoon.Enabled.AutoClaim = enabled
    end)

    local function isNear(pos, maxDist)
        local char = LocalPlayer.Character
        if not (char and char:FindFirstChild("HumanoidRootPart")) then return false end
        return (char.HumanoidRootPart.Position - pos).Magnitude <= maxDist
    end

    local tickCount = 0
    RunService.Heartbeat:Connect(function()
        tickCount += 1
        if tickCount % 6 ~= 0 then return end -- ~10x/sec

        -- Auto Collect
        if getgenv().WarfareTycoon.Enabled.AutoCollect then
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        local lname = string.lower(obj.Name)
                        local action = string.lower(obj.ActionText or "")
                        local otext = string.lower(obj.ObjectText or "")
                        local parentName = string.lower(obj.Parent and obj.Parent.Name or "")
                        if lname:find("cash") or lname:find("collect") or lname:find("money")
                           or action:find("collect") or action:find("cash") or otext:find("cash")
                           or parentName:find("cash") or parentName:find("collect") then
                            if obj.Parent and obj.Parent:IsA("BasePart") and isNear(obj.Parent.Position, 25) then
                                pcall(function() fireproximityprompt(obj) end)
                            end
                        end
                    elseif obj:IsA("ClickDetector") then
                        local lname = string.lower(obj.Name)
                        local parentName = string.lower(obj.Parent and obj.Parent.Name or "")
                        if lname:find("cash") or lname:find("collect") or lname:find("money")
                           or parentName:find("cash") or parentName:find("collect") then
                            if obj.Parent and obj.Parent:IsA("BasePart") and isNear(obj.Parent.Position, 20) then
                                pcall(function() fireclickdetector(obj) end)
                            end
                        end
                    end
                end
            end)
        end

        -- Auto Claim/Upgrade
        if getgenv().WarfareTycoon.Enabled.AutoClaim then
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        local lname = string.lower(obj.Name)
                        local action = string.lower(obj.ActionText or "")
                        local otext = string.lower(obj.ObjectText or "")
                        local parentName = string.lower(obj.Parent and obj.Parent.Name or "")
                        if lname:find("buy") or lname:find("upgrade") or lname:find("purchase") or lname:find("claim")
                           or action:find("buy") or action:find("upgrade") or action:find("purchase") or action:find("claim")
                           or otext:find("buy") or otext:find("upgrade") or otext:find("purchase") or otext:find("claim")
                           or parentName:find("buy") or parentName:find("upgrade") or parentName:find("purchase") or parentName:find("claim") then
                            if obj.Parent and obj.Parent:IsA("BasePart") and isNear(obj.Parent.Position, 22) then
                                pcall(function() fireproximityprompt(obj) end)
                            end
                        end
                    elseif obj:IsA("ClickDetector") then
                        local lname = string.lower(obj.Name)
                        local parentName = string.lower(obj.Parent and obj.Parent.Name or "")
                        if lname:find("buy") or lname:find("upgrade") or lname:find("purchase") or lname:find("claim")
                           or parentName:find("buy") or parentName:find("upgrade") or parentName:find("purchase") or parentName:find("claim") then
                            if obj.Parent and obj.Parent:IsA("BasePart") and isNear(obj.Parent.Position, 18) then
                                pcall(function() fireclickdetector(obj) end)
                            end
                        end
                    end
                end
            end)
        end
    end)
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
                        -- Also try Attributes and Configurations inside the tool
                        -- Attributes
                        pcall(function()
                            local attrs = tool:GetAttributes()
                            for k, v in pairs(attrs) do
                                local lk = string.lower(k)
                                if type(v) == "number" and (lk:find("spread") or lk:find("accuracy") or lk:find("bloom")) then
                                    tool:SetAttribute(k, 0)
                                end
                            end
                        end)
                        -- Configuration objects
                        for _, cfg in ipairs(tool:GetDescendants()) do
                            if cfg:IsA("Configuration") then
                                for _, val in ipairs(cfg:GetDescendants()) do
                                    if val:IsA("NumberValue") or val:IsA("IntValue") then
                                        local ln = string.lower(val.Name)
                                        if ln:find("spread") or ln:find("accuracy") or ln:find("bloom") then
                                            val.Value = 0
                                        end
                                    end
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
    getgenv().WarfareTycoon.HitboxState = getgenv().WarfareTycoon.HitboxState or {}
    
    createToggle(CombatTab, "📦 Hitbox Expander", function(enabled)
        getgenv().WarfareTycoon.Enabled.Hitbox = enabled
        
        if not enabled then
            -- Restore ALL tracked parts to their original state
            local state = getgenv().WarfareTycoon.HitboxState
            for player, parts in pairs(state) do
                for part, orig in pairs(parts) do
                    if typeof(part) == "Instance" and part.Parent then
                        pcall(function()
                            part.Size = orig.Size
                            part.Transparency = orig.Transparency
                            part.CanCollide = orig.CanCollide
                            part.Massless = orig.Massless
                        end)
                    end
                end
            end
            getgenv().WarfareTycoon.HitboxState = {}
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
            local state = getgenv().WarfareTycoon.HitboxState

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    -- Reset any PREVIOUSLY enlarged parts for this player that are not the current target part
                    local tracked = state[player]
                    if tracked then
                        for trackedPart, orig in pairs(tracked) do
                            if typeof(trackedPart) == "Instance" and trackedPart.Parent then
                                if trackedPart.Name ~= partName then
                                    pcall(function()
                                        trackedPart.Size = orig.Size
                                        trackedPart.Transparency = orig.Transparency
                                        trackedPart.CanCollide = orig.CanCollide
                                        trackedPart.Massless = orig.Massless
                                    end)
                                    tracked[trackedPart] = nil
                                end
                            else
                                tracked[trackedPart] = nil
                            end
                        end
                        if next(tracked) == nil then state[player] = nil end
                    end

                    -- Enlarge CURRENT target part
                    local part = player.Character:FindFirstChild(partName)
                    if part and part:IsA("BasePart") then
                        -- Save original state once
                        state[player] = state[player] or {}
                        if not state[player][part] then
                            state[player][part] = {
                                Size = part.Size,
                                Transparency = part.Transparency,
                                CanCollide = part.CanCollide,
                                Massless = part.Massless,
                            }
                        end
                        -- Apply enlarged state
                        pcall(function()
                            part.Size = Vector3.new(size, size, size)
                            part.Transparency = 0.5
                            part.CanCollide = false
                            part.Massless = true
                        end)
                    end
                end
            end
        end
    end)
end

print("[Warfare Tycoon] Combat features loaded!")
print("[Warfare Tycoon] Features: No Spread, Hitbox Expander")

-- Extend Combat: Infinite Ammo, Rapid Fire, Infinite Range, Silent Aim
do
    -- Infinite Ammo
    getgenv().WarfareTycoon.Enabled.InfiniteAmmo = false
    createToggle(CombatTab, "🔫 Infinite Ammo", function(enabled)
        getgenv().WarfareTycoon.Enabled.InfiniteAmmo = enabled
    end)

    -- Rapid Fire
    getgenv().WarfareTycoon.Enabled.RapidFire = false
    createToggle(CombatTab, "🔥 Rapid Fire", function(enabled)
        getgenv().WarfareTycoon.Enabled.RapidFire = enabled
    end)

    -- Infinite Range
    getgenv().WarfareTycoon.Enabled.InfiniteRange = false
    createToggle(CombatTab, "🎯 Infinite Range", function(enabled)
        getgenv().WarfareTycoon.Enabled.InfiniteRange = enabled
    end)

    -- Apply weapon edits each frame (throttled)
    local weaponTick = 0
    RunService.Heartbeat:Connect(function()
        weaponTick += 1
        if weaponTick % 5 ~= 0 then return end

        local char = LocalPlayer.Character
        if not char then return end

        for _, tool in ipairs(char:GetChildren()) do
            if not tool:IsA("Tool") then continue end
            for _, obj in ipairs(tool:GetDescendants()) do
                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                    local n = string.lower(obj.Name)
                    -- Infinite Ammo
                    if getgenv().WarfareTycoon.Enabled.InfiniteAmmo then
                        if string.find(n, "ammo") or string.find(n, "mag") or string.find(n, "clip") then
                            obj.Value = 999999
                        end
                    end
                    -- Rapid Fire
                    if getgenv().WarfareTycoon.Enabled.RapidFire then
                        if string.find(n, "firerate") or string.find(n, "fire_rate") or string.find(n, "cooldown") or string.find(n, "delay") then
                            obj.Value = 0
                        end
                    end
                    -- Infinite Range
                    if getgenv().WarfareTycoon.Enabled.InfiniteRange then
                        if string.find(n, "range") or string.find(n, "distance") then
                            obj.Value = 999999
                        end
                    end
                end
            end
        end
    end)

    -- Silent Aim
    getgenv().WarfareTycoon.Enabled.SilentAim = false
    getgenv().WarfareTycoon.SilentAimFOV = 200
    createToggle(CombatTab, "🎪 Silent Aim", function(enabled)
        getgenv().WarfareTycoon.Enabled.SilentAim = enabled
    end)

    if not getgenv().WarfareTycoon._SilentAimHooked then
        -- Only try to hook if hookmetamethod exists (executor API)
        if typeof(hookmetamethod) == "function" then
            getgenv().WarfareTycoon._SilentAimHooked = true
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod and getnamecallmethod() or ""

            -- AntiKick: block Player:Kick()
            if getgenv().WarfareTycoon.Enabled and getgenv().WarfareTycoon.Enabled.AntiKick then
                if method == "Kick" and (self == LocalPlayer or tostring(self) == LocalPlayer.Name) then
                    print("[AntiKick] Blocked Kick() call")
                    return nil
                end
            end

            -- RemoteBlocker: block suspicious remotes
            if getgenv().WarfareTycoon.Enabled and getgenv().WarfareTycoon.Enabled.RemoteBlocker then
                if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
                    local n = string.lower(self.Name)
                    local full = (self.GetFullName and self:GetFullName() or self.Name)
                    local suspicious = {
                        "anticheat","anti_cheat","ban","kick","log","detect","exploit","cheat","report","flag"
                    }
                    local flagged = false
                    for _, p in ipairs(suspicious) do
                        if n:find(p) or string.lower(full):find(p) then flagged = true break end
                    end
                    if flagged then
                        print("[RemoteBlocker] Blocked: " .. full .. " (" .. method .. ")")
                        return nil
                    end
                end
            end

            local function getClosestPlayer()
                local cam = workspace.CurrentCamera
                local closest, bestDist = nil, getgenv().WarfareTycoon.SilentAimFOV
                local mousePos = UserInputService:GetMouseLocation()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                        local head = plr.Character.Head
                        local sp, onScreen = cam:WorldToViewportPoint(head.Position)
                        if onScreen then
                            local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                            if d < bestDist then
                                bestDist = d
                                closest = head
                            end
                        end
                    end
                end
                return closest
            end

            -- Optional Remote Logger to F9 (with arg previews)
            if getgenv().WarfareTycoon.Enabled and getgenv().WarfareTycoon.Enabled.RemoteLogger and (method == "FireServer" or method == "InvokeServer") then
                pcall(function()
                    local function preview(v, depth)
                        depth = depth or 0
                        local t = typeof(v)
                        if t == "string" then
                            if #v > 120 then v = v:sub(1,117).."..." end
                            return string.format('"%s"', v)
                        elseif t == "number" or t == "boolean" then
                            return tostring(v)
                        elseif t == "Vector3" then
                            return string.format("Vector3(%0.1f,%0.1f,%0.1f)", v.X, v.Y, v.Z)
                        elseif t == "CFrame" then
                            return "CFrame(...)"
                        elseif t == "Instance" then
                            return string.format("Instance<%s>:%s", v.ClassName, v:GetFullName())
                        elseif t == "table" then
                            if depth >= 1 then return "{...}" end
                            local parts, n = {}, 0
                            for k,val in pairs(v) do
                                parts[#parts+1] = tostring(k).."="..preview(val, depth+1)
                                n = n + 1
                                if n >= 5 then break end
                            end
                            return "{"..table.concat(parts, ", ").."}"
                        else
                            return t
                        end
                    end
                    local full = (self and self.GetFullName and self:GetFullName() or tostring(self))
                    local atypes, apreviews = {}, {}
                    for i, a in ipairs(args) do
                        atypes[#atypes+1] = typeof(a)
                        apreviews[#apreviews+1] = preview(a)
                    end
                    print(string.format("[REMOTE] %s (%s) types: [ %s ] previews: [ %s ]", full, method, table.concat(atypes, ", "), table.concat(apreviews, ", ")))
                end)
            end

            if getgenv().WarfareTycoon.Enabled.SilentAim and (method == "FireServer" or method == "InvokeServer") then
                local target = getClosestPlayer()
                if target then
                    for i, a in ipairs(args) do
                        if typeof(a) == "Vector3" then
                            args[i] = target.Position
                        elseif typeof(a) == "CFrame" then
                            args[i] = target.CFrame
                        end
                    end
                end
                return oldNamecall(self, unpack(args))
            end

            return oldNamecall(self, ...)
            end)
        else
            print("[Warfare Tycoon] hookmetamethod not available; SilentAim/Remote logger/AntiKick via hook disabled.")
        end
    end
    
    -- Triggerbot
    getgenv().WarfareTycoon.Enabled.Triggerbot = false
    createToggle(CombatTab, "🧠 Triggerbot", function(enabled)
        getgenv().WarfareTycoon.Enabled.Triggerbot = enabled
    end)

    local mouse = LocalPlayer:GetMouse()
    local lastFire = 0
    RunService.RenderStepped:Connect(function()
        if not getgenv().WarfareTycoon.Enabled.Triggerbot then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        -- Raycast towards mouse
        local origin = cam.CFrame.Position
        local dir = (mouse.Hit and (mouse.Hit.p - origin).Unit or cam.CFrame.LookVector) * 1000
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {LocalPlayer.Character}
        params.FilterType = Enum.RaycastFilterType.Blacklist
        local result = workspace:Raycast(origin, dir, params)
        if result and result.Instance then
            local inst = result.Instance
            local model = inst:FindFirstAncestorOfClass("Model")
            if model and model ~= LocalPlayer.Character then
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local t = tick()
                    if t - lastFire > 0.12 then
                        lastFire = t
                        -- Activate current tool if any
                        local char = LocalPlayer.Character
                        if char then
                            for _, tool in ipairs(char:GetChildren()) do
                                if tool:IsA("Tool") then
                                    pcall(function() tool:Activate() end)
                                end
                            end
                        end
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
    
    createToggle(VisualsTab, "👁️ ESP Master", function(enabled)
        ESPEnabled = enabled
        
        if not enabled then
            for player, data in pairs(getgenv().WarfareTycoon.ESPObjects) do
                if data.billboard then data.billboard:Destroy() end
                if data.box then data.box:Remove() end
                if data.boxOutline then data.boxOutline:Remove() end
            end
            getgenv().WarfareTycoon.ESPObjects = {}
        end
    end)
    
    createToggle(VisualsTab, "📦 ESP Box", function(enabled)
        ESPBoxEnabled = enabled
    end)
    
    createToggle(VisualsTab, "📝 ESP Name", function(enabled)
        ESPNameEnabled = enabled
    end)
    
    createToggle(VisualsTab, "❤️ ESP Health", function(enabled)
        ESPHealthEnabled = enabled
    end)
    
    createToggle(VisualsTab, "📏 ESP Distance", function(enabled)
        ESPDistanceEnabled = enabled
    end)
    
    -- Header for Visuals to ensure content is visible
    do
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, -10, 0, 30)
        header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        header.Text = "👁️ Visuals Controls"
        header.TextColor3 = Color3.fromRGB(255, 255, 255)
        header.TextSize = 14
        header.Font = Enum.Font.GothamBold
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Position = UDim2.new(0, 5, 0, 0)
        header.Parent = VisualsTab
        Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)
    end
    
    local function createESP(player)
        if player == LocalPlayer then return end
        if getgenv().WarfareTycoon.ESPObjects[player] then return end
        
        local espData = {}
        
        -- Billboard (Name, Health, Distance)
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 100, 0, 80)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Parent = billboard
        
        local healthLabel = Instance.new("TextLabel")
        healthLabel.Size = UDim2.new(1, 0, 0.33, 0)
        healthLabel.Position = UDim2.new(0, 0, 0.33, 0)
        healthLabel.BackgroundTransparency = 1
        healthLabel.Text = "100 HP"
        healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        healthLabel.TextSize = 12
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextStrokeTransparency = 0
        healthLabel.Parent = billboard
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.33, 0)
        distLabel.Position = UDim2.new(0, 0, 0.66, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0 studs"
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextSize = 12
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextStrokeTransparency = 0
        distLabel.Parent = billboard
        
        -- Box ESP (Drawing API)
        if Drawing then
            espData.boxOutline = Drawing.new("Square")
            espData.boxOutline.Visible = false
            espData.boxOutline.Color = Color3.new(0, 0, 0)
            espData.boxOutline.Thickness = 3
            espData.boxOutline.Filled = false
            
            espData.box = Drawing.new("Square")
            espData.box.Visible = false
            espData.box.Color = Color3.new(1, 0, 0)
            espData.box.Thickness = 1
            espData.box.Filled = false
        end
        
        espData.billboard = billboard
        espData.nameLabel = nameLabel
        espData.healthLabel = healthLabel
        espData.distLabel = distLabel
        
        getgenv().WarfareTycoon.ESPObjects[player] = espData
        
        local function updateESP()
            if not ESPEnabled then return end
            
            local char = player.Character
            local myChar = LocalPlayer.Character
            
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local hum = char.Humanoid
                
                -- Billboard
                billboard.Adornee = hrp
                billboard.Parent = hrp
                
                -- Distance
                local dist = (hrp.Position - myChar.HumanoidRootPart.Position).Magnitude
                if ESPDistanceEnabled then
                    distLabel.Text = math.floor(dist) .. " studs"
                    distLabel.Visible = true
                else
                    distLabel.Visible = false
                end
                
                -- Name
                nameLabel.Visible = ESPNameEnabled
                
                -- Health
                if ESPHealthEnabled then
                    local health = math.floor(hum.Health)
                    local maxHealth = math.floor(hum.MaxHealth)
                    healthLabel.Text = health .. " HP"
                    
                    -- Color based on health
                    local healthPercent = health / maxHealth
                    if healthPercent > 0.5 then
                        healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif healthPercent > 0.25 then
                        healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                    healthLabel.Visible = true
                else
                    healthLabel.Visible = false
                end
                
                -- Box
                if Drawing then
                    local camera = workspace.CurrentCamera
                    local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                    
                    if onScreen then
                        local headPos = camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
                        local legPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                        
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height / 2
                        
                        if ESPBoxEnabled and espData.box then
                            espData.box.Size = Vector2.new(width, height)
                            espData.box.Position = Vector2.new(screenPos.X - width/2, screenPos.Y - height/2)
                            espData.box.Visible = true
                            
                            espData.boxOutline.Size = Vector2.new(width, height)
                            espData.boxOutline.Position = Vector2.new(screenPos.X - width/2, screenPos.Y - height/2)
                            espData.boxOutline.Visible = true
                        else
                            if espData.box then espData.box.Visible = false end
                            if espData.boxOutline then espData.boxOutline.Visible = false end
                        end
                    else
                        if espData.box then espData.box.Visible = false end
                        if espData.boxOutline then espData.boxOutline.Visible = false end
                    end
                end
            else
                billboard.Parent = nil
                if espData.box then espData.box.Visible = false end
                if espData.boxOutline then espData.boxOutline.Visible = false end
            end
        end
        
        RunService.RenderStepped:Connect(updateESP)
    end
    
    -- Create ESP for all players
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            task.spawn(function()
                createESP(player)
            end)
        end
    end
    
    -- Handle new players
    Players.PlayerAdded:Connect(function(player)
        if ESPEnabled then
            task.wait(1)
            createESP(player)
        end
    end)
    
    -- Handle player leaving
    Players.PlayerRemoving:Connect(function(player)
        if getgenv().WarfareTycoon.ESPObjects[player] then
            if getgenv().WarfareTycoon.ESPObjects[player].billboard then
                getgenv().WarfareTycoon.ESPObjects[player].billboard:Destroy()
            end
            if getgenv().WarfareTycoon.ESPObjects[player].box then
                getgenv().WarfareTycoon.ESPObjects[player].box:Remove()
            end
            if getgenv().WarfareTycoon.ESPObjects[player].boxOutline then
                getgenv().WarfareTycoon.ESPObjects[player].boxOutline:Remove()
            end
            getgenv().WarfareTycoon.ESPObjects[player] = nil
        end
    end)
end

print("[Warfare Tycoon] Visual features loaded!")
print("[Warfare Tycoon] Features: ESP (Box, Name, Health, Distance)")

-- ===== MISC TAB =====
do
    -- Remote Logger Toggle (F9 console)
    getgenv().WarfareTycoon.Enabled.RemoteLogger = getgenv().WarfareTycoon.Enabled.RemoteLogger or false
    createToggle(MiscTab, "🛰️ Live Remote Logger (F9)", function(enabled)
        getgenv().WarfareTycoon.Enabled.RemoteLogger = enabled
        if enabled then
            print("[Warfare Tycoon] Live Remote Logger: ON")
        else
            print("[Warfare Tycoon] Live Remote Logger: OFF")
        end
    end)

    -- One-time scanner button
    createButton(MiscTab, "🔎 Scan Remotes (prints to F9)", function()
        local found = 0
        local function scan(container)
            for _, d in ipairs(container:GetDescendants()) do
                if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") or d:IsA("BindableEvent") or d:IsA("BindableFunction") then
                    found += 1
                    print(string.format("[SCAN] %s (%s)", d:GetFullName(), d.ClassName))
                end
            end
        end
        print("[SCAN] Scanning ReplicatedStorage and Workspace for remotes...")
        pcall(function() scan(game:GetService("ReplicatedStorage")) end)
        pcall(function() scan(workspace) end)
        print("[SCAN] Done. Found " .. tostring(found) .. " remotes.")
    end)

    -- Money-related scanner button
    createButton(MiscTab, "💰 Scan Money Remotes (F9)", function()
        local moneyPatterns = {
            "cash", "money", "coin", "coins", "gold", "bucks", "gem", "gems",
            "buy", "upgrade", "purchase", "claim", "reward", "payout", "give", "add"
        }
        local function isMoneyLike(name)
            local ln = string.lower(name or "")
            for _, p in ipairs(moneyPatterns) do
                if ln:find(p) then return true end
            end
            return false
        end
        local found = 0
        local function scan(container)
            for _, d in ipairs(container:GetDescendants()) do
                if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) and (isMoneyLike(d.Name) or isMoneyLike(d:GetFullName())) then
                    found += 1
                    print(string.format("[MONEY] %s (%s)", d:GetFullName(), d.ClassName))
                end
            end
        end
        print("[MONEY] Scanning common services for money remotes...")
        pcall(function() scan(game:GetService("ReplicatedStorage")) end)
        pcall(function() scan(workspace) end)
        pcall(function() scan(game:GetService("Players")) end)
        pcall(function() scan(game:GetService("StarterGui")) end)
        pcall(function() scan(game:GetService("StarterPack")) end)
        print("[MONEY] Done. Found " .. tostring(found) .. " candidates.")
    end)
end

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
