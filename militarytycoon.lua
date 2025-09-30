--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║           Military Tycoon GUI v2.0 Advanced              ║
    ║                  by Lahmacun581                           ║
    ║         Tab System | ESP | Weapons | Auto Farm           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[Military Tycoon] Loading GUI v2.0...")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Global state
getgenv().MilitaryTycoon = getgenv().MilitaryTycoon or {
    Version = "2.0",
    Enabled = {},
    Values = {},
    Connections = {}
}

-- Cleanup old GUI
if PlayerGui:FindFirstChild("MilitaryTycoonGUI") then
    PlayerGui:FindFirstChild("MilitaryTycoonGUI"):Destroy()
    print("[Military Tycoon] Old GUI removed")
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MilitaryTycoonGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 450)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 25)
TitleFix.Position = UDim2.new(0, 0, 1, -25)
TitleFix.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

-- Title Text
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚔️ Military Tycoon v2.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    print("[Military Tycoon] GUI closed")
end)

-- Tab Container (Left Side)
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 140, 1, -60)
TabContainer.Position = UDim2.new(0, 5, 0, 55)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TabContainer.BorderSizePixel = 0
TabContainer.ScrollBarThickness = 4
TabContainer.ScrollBarImageColor3 = Color3.fromRGB(50, 150, 50)
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.Parent = MainFrame

Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 10)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabContainer

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
end)

-- Content Container (Right Side)
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(0, 430, 1, -60)
ContentContainer.Position = UDim2.new(0, 160, 0, 55)
ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 10)

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
    
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)
    
    -- Icon
    local tabIcon = Instance.new("TextLabel")
    tabIcon.Size = UDim2.new(0, 30, 0, 30)
    tabIcon.Position = UDim2.new(0, 5, 0, 5)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Text = icon
    tabIcon.TextSize = 18
    tabIcon.Font = Enum.Font.GothamBold
    tabIcon.TextColor3 = Color3.fromRGB(150, 150, 160)
    tabIcon.Parent = tabBtn
    
    -- Label
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
    
    -- Content
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, -20, 1, -20)
    tabContent.Position = UDim2.new(0, 10, 0, 10)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(50, 150, 50)
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
    
    -- Click handler
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
local CombatTab = createTab("Combat", "⚔️", Color3.fromRGB(255, 100, 100))
local PlayerTab = createTab("Player", "🏃", Color3.fromRGB(100, 150, 255))
local VisualsTab = createTab("Visuals", "👁️", Color3.fromRGB(100, 255, 150))

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

local function createButton(parent, text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = parent
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
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

print("[Military Tycoon] GUI Framework loaded")
print("[Military Tycoon] Loading features...")

-- ===== TYCOON TAB =====
do
    -- Auto Collect Cash (Teleport to Cash)
    getgenv().MilitaryTycoon.Enabled.AutoCash = false
    createToggle(TycoonTab, "💰 Auto Collect Cash", function(enabled)
        getgenv().MilitaryTycoon.Enabled.AutoCash = enabled
    end)
    
    local cashFrameCount = 0
    RunService.Heartbeat:Connect(function()
        if getgenv().MilitaryTycoon.Enabled.AutoCash then
            cashFrameCount = cashFrameCount + 1
            if cashFrameCount % 60 ~= 0 then return end
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local closestCash = nil
                local closestDist = math.huge
                
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj:FindFirstChild("Humanoid") then
                        local name = string.lower(obj.Name)
                        if string.find(name, "cash") or string.find(name, "money") then
                            local dist = (obj.Position - hrp.Position).Magnitude
                            if dist < closestDist and dist < 200 then
                                closestDist = dist
                                closestCash = obj
                            end
                        end
                    end
                end
                
                if closestCash then
                    pcall(function()
                        hrp.CFrame = closestCash.CFrame + Vector3.new(0, 3, 0)
                    end)
                end
            end
        end
    end)
    
    -- Auto Upgrade (Green Buttons)
    getgenv().MilitaryTycoon.Enabled.AutoUpgrade = false
    createToggle(TycoonTab, "🏗️ Auto Upgrade Tycoon", function(enabled)
        getgenv().MilitaryTycoon.Enabled.AutoUpgrade = enabled
    end)
    
    local upgradeFrameCount = 0
    RunService.Heartbeat:Connect(function()
        if getgenv().MilitaryTycoon.Enabled.AutoUpgrade then
            upgradeFrameCount = upgradeFrameCount + 1
            if upgradeFrameCount % 30 ~= 0 then return end
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ClickDetector") or obj:IsA("ProximityPrompt") then
                    local parent = obj.Parent
                    if parent and parent:IsA("BasePart") then
                        -- Yeşil renk kontrolü
                        if parent.Color == Color3.fromRGB(0, 255, 0) or 
                           parent.Color == Color3.fromRGB(0, 170, 0) or
                           parent.BrickColor == BrickColor.new("Lime green") or
                           parent.BrickColor == BrickColor.new("Green") then
                            
                            pcall(function()
                                if obj:IsA("ClickDetector") then
                                    fireclickdetector(obj)
                                elseif obj:IsA("ProximityPrompt") then
                                    fireproximityprompt(obj)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end)
    
    createButton(TycoonTab, "🏭 TP to My Tycoon", Color3.fromRGB(100, 150, 255), function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Model") then
                    local name = string.lower(obj.Name)
                    if string.find(name, "tycoon") or string.find(name, "base") then
                        local spawn = obj:FindFirstChild("Spawn") or obj:FindFirstChildWhichIsA("SpawnLocation")
                        if spawn then
                            char.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
                            break
                        end
                    end
                end
            end
        end
    end)
end

-- ===== COMBAT TAB =====
do
    -- Infinite Ammo
    getgenv().MilitaryTycoon.Enabled.InfAmmo = false
    createToggle(CombatTab, "🔫 Infinite Ammo", function(enabled)
        getgenv().MilitaryTycoon.Enabled.InfAmmo = enabled
    end)
    
    RunService.Heartbeat:Connect(function()
        if getgenv().MilitaryTycoon.Enabled.InfAmmo then
            local char = LocalPlayer.Character
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, obj in ipairs(tool:GetDescendants()) do
                            if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                                local name = string.lower(obj.Name)
                                if string.find(name, "ammo") or string.find(name, "mag") then
                                    obj.Value = 999
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- Fast Reload
    getgenv().MilitaryTycoon.Enabled.FastReload = false
    createToggle(CombatTab, "⚡ Fast Reload", function(enabled)
        getgenv().MilitaryTycoon.Enabled.FastReload = enabled
    end)
    
    RunService.Heartbeat:Connect(function()
        if getgenv().MilitaryTycoon.Enabled.FastReload then
            local char = LocalPlayer.Character
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, obj in ipairs(tool:GetDescendants()) do
                            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                                local name = string.lower(obj.Name)
                                if string.find(name, "reload") then
                                    obj.Value = 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- No Recoil
    getgenv().MilitaryTycoon.Enabled.NoRecoil = false
    createToggle(CombatTab, "🎯 No Recoil", function(enabled)
        getgenv().MilitaryTycoon.Enabled.NoRecoil = enabled
    end)
    
    RunService.Heartbeat:Connect(function()
        if getgenv().MilitaryTycoon.Enabled.NoRecoil then
            local char = LocalPlayer.Character
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, obj in ipairs(tool:GetDescendants()) do
                            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                                local name = string.lower(obj.Name)
                                if string.find(name, "recoil") then
                                    obj.Value = 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- No Spread
    getgenv().MilitaryTycoon.Enabled.NoSpread = false
    createToggle(CombatTab, "💥 No Spread", function(enabled)
        getgenv().MilitaryTycoon.Enabled.NoSpread = enabled
    end)
    
    RunService.Heartbeat:Connect(function()
        if getgenv().MilitaryTycoon.Enabled.NoSpread then
            local char = LocalPlayer.Character
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, obj in ipairs(tool:GetDescendants()) do
                            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                                local name = string.lower(obj.Name)
                                if string.find(name, "spread") or string.find(name, "accuracy") then
                                    obj.Value = 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- ===== PLAYER TAB =====
do
    -- Speed
    getgenv().MilitaryTycoon.Enabled.Speed = false
    createToggle(PlayerTab, "🏃 Speed Hack (100)", function(enabled)
        getgenv().MilitaryTycoon.Enabled.Speed = enabled
        if not enabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 16
            end
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if getgenv().MilitaryTycoon.Enabled.Speed then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 100
            end
        end
    end)
    
    -- Jump
    getgenv().MilitaryTycoon.Enabled.Jump = false
    createToggle(PlayerTab, "🦘 Super Jump", function(enabled)
        getgenv().MilitaryTycoon.Enabled.Jump = enabled
        if not enabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = 50
            end
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if getgenv().MilitaryTycoon.Enabled.Jump then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = 120
            end
        end
    end)
    
    -- Fly
    getgenv().MilitaryTycoon.Enabled.Fly = false
    local flyBG, flyBV
    
    createToggle(PlayerTab, "✈️ Fly Mode", function(enabled)
        getgenv().MilitaryTycoon.Enabled.Fly = enabled
        
        if enabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
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
            end
        else
            if flyBG then flyBG:Destroy() flyBG = nil end
            if flyBV then flyBV:Destroy() flyBV = nil end
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if getgenv().MilitaryTycoon.Enabled.Fly then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local cam = workspace.CurrentCamera
                local direction = Vector3.new(0, 0, 0)
                local speed = 50
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + (cam.CFrame.LookVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - (cam.CFrame.LookVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - (cam.CFrame.RightVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + (cam.CFrame.RightVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, speed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - Vector3.new(0, speed, 0)
                end
                
                if flyBV then
                    flyBV.velocity = direction
                end
                if flyBG then
                    flyBG.cframe = cam.CFrame
                end
            end
        end
    end)
    
    -- Noclip
    getgenv().MilitaryTycoon.Enabled.Noclip = false
    createToggle(PlayerTab, "👻 Noclip", function(enabled)
        getgenv().MilitaryTycoon.Enabled.Noclip = enabled
    end)
    
    RunService.Stepped:Connect(function()
        if getgenv().MilitaryTycoon.Enabled.Noclip then
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
    
    -- God Mode
    getgenv().MilitaryTycoon.Enabled.God = false
    createToggle(PlayerTab, "🛡️ God Mode", function(enabled)
        getgenv().MilitaryTycoon.Enabled.God = enabled
    end)
    
    local godFrameCount = 0
    RunService.Heartbeat:Connect(function()
        if getgenv().MilitaryTycoon.Enabled.God then
            godFrameCount = godFrameCount + 1
            if godFrameCount % 10 ~= 0 then return end
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                if hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end
        end
    end)
    
    createButton(PlayerTab, "🎯 TP to Mouse", Color3.fromRGB(100, 150, 255), function()
        local mouse = LocalPlayer:GetMouse()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and mouse.Hit then
            char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)
    
    createButton(PlayerTab, "🔄 Reset", Color3.fromRGB(200, 100, 100), function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end)
end

-- ===== VISUALS TAB =====
do
    -- ESP System
    local ESPEnabled = false
    local ESPObjects = {}
    
    createToggle(VisualsTab, "👁️ ESP Master", function(enabled)
        ESPEnabled = enabled
        
        if not enabled then
            for player, data in pairs(ESPObjects) do
                if data.billboard then data.billboard:Destroy() end
            end
            ESPObjects = {}
        end
    end)
    
    local function createESP(player)
        if player == LocalPlayer then return end
        if ESPObjects[player] then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Parent = billboard
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0 studs"
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextSize = 12
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextStrokeTransparency = 0
        distLabel.Parent = billboard
        
        ESPObjects[player] = {
            billboard = billboard,
            nameLabel = nameLabel,
            distLabel = distLabel
        }
        
        local function updateESP()
            if not ESPEnabled then return end
            
            local char = player.Character
            local myChar = LocalPlayer.Character
            
            if char and char:FindFirstChild("HumanoidRootPart") and myChar and myChar:FindFirstChild("HumanoidRootPart") then
                billboard.Adornee = char.HumanoidRootPart
                billboard.Parent = char.HumanoidRootPart
                
                local dist = (char.HumanoidRootPart.Position - myChar.HumanoidRootPart.Position).Magnitude
                distLabel.Text = math.floor(dist) .. " studs"
            else
                billboard.Parent = nil
            end
        end
        
        RunService.RenderStepped:Connect(updateESP)
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            task.spawn(function()
                createESP(player)
            end)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        if ESPEnabled then
            task.wait(1)
            createESP(player)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if ESPObjects[player] then
            if ESPObjects[player].billboard then
                ESPObjects[player].billboard:Destroy()
            end
            ESPObjects[player] = nil
        end
    end)
    
    -- Credits
    local creditsLabel = Instance.new("TextLabel")
    creditsLabel.Size = UDim2.new(1, -10, 0, 60)
    creditsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    creditsLabel.Text = "⚔️ Military Tycoon v2.0\nMade by Lahmacun581\nFull Featured"
    creditsLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    creditsLabel.TextSize = 13
    creditsLabel.Font = Enum.Font.Gotham
    creditsLabel.Parent = VisualsTab
    
    Instance.new("UICorner", creditsLabel).CornerRadius = UDim.new(0, 8)
end

print("[Military Tycoon] All features loaded!")
print("[Military Tycoon] GUI v2.0 ready!")
print("[Military Tycoon] Total: 15 features")
