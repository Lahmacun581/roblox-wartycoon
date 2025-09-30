--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                      AdorHUB v1.0                         ║
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
    Version = "1.0",
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
    
    local btn = createButton(parent, text .. ": OFF", color, function()
        enabled = not enabled
        btn.Text = text .. ": " .. (enabled and "ON" or "OFF")
        
        if enabled then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 200, 100)}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
        end
        
        if callback then
            callback(enabled)
        end
    end)
    
    return btn, function() return enabled end
end

-- ===== PLAYER TAB =====
do
    -- Speed Hack
    local speedConn
    createToggle(PlayerTab, "🏃 Speed Hack (100)", Color3.fromRGB(100, 150, 255), function(enabled)
        if enabled then
            speedConn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = 100
                end
            end)
            getgenv().AdorHUB.Connections.Speed = speedConn
        else
            if speedConn then speedConn:Disconnect() end
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 16
            end
        end
    end)
    
    -- Super Jump
    local jumpConn
    createToggle(PlayerTab, "🦘 Super Jump (120)", Color3.fromRGB(150, 100, 255), function(enabled)
        if enabled then
            jumpConn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.JumpPower = 120
                end
            end)
            getgenv().AdorHUB.Connections.Jump = jumpConn
        else
            if jumpConn then jumpConn:Disconnect() end
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = 50
            end
        end
    end)
    
    -- Infinite Jump
    local infJumpConn
    createToggle(PlayerTab, "♾️ Infinite Jump", Color3.fromRGB(255, 150, 100), function(enabled)
        if enabled then
            infJumpConn = UserInputService.JumpRequest:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            getgenv().AdorHUB.Connections.InfJump = infJumpConn
        else
            if infJumpConn then infJumpConn:Disconnect() end
        end
    end)
    
    -- Fly
    local flying = false
    local flyConn
    local flySpeed = 50
    createToggle(PlayerTab, "✈️ Fly Mode", Color3.fromRGB(100, 200, 255), function(enabled)
        flying = enabled
        
        if enabled then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = char.HumanoidRootPart
            local bg = Instance.new("BodyGyro")
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = hrp.CFrame
            bg.Parent = hrp
            
            local bv = Instance.new("BodyVelocity")
            bv.velocity = Vector3.new(0, 0, 0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = hrp
            
            flyConn = RunService.Heartbeat:Connect(function()
                if not flying then return end
                
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
                
                bv.velocity = direction
                bg.cframe = cam.CFrame
            end)
            
            getgenv().AdorHUB.Connections.Fly = flyConn
        else
            if flyConn then flyConn:Disconnect() end
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                if hrp:FindFirstChild("BodyGyro") then hrp.BodyGyro:Destroy() end
                if hrp:FindFirstChild("BodyVelocity") then hrp.BodyVelocity:Destroy() end
            end
        end
    end)
    
    -- Noclip
    local noclipping = false
    local noclipConn
    createToggle(PlayerTab, "👻 Noclip", Color3.fromRGB(200, 100, 255), function(enabled)
        noclipping = enabled
        
        if enabled then
            noclipConn = RunService.Stepped:Connect(function()
                if not noclipping then return end
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            getgenv().AdorHUB.Connections.Noclip = noclipConn
        else
            if noclipConn then noclipConn:Disconnect() end
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
    
    -- God Mode (Anti-Damage)
    local godConn
    createToggle(PlayerTab, "🛡️ God Mode", Color3.fromRGB(255, 200, 100), function(enabled)
        if enabled then
            godConn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    local hum = char.Humanoid
                    if hum.Health < hum.MaxHealth then
                        hum.Health = hum.MaxHealth
                    end
                end
            end)
            getgenv().AdorHUB.Connections.God = godConn
        else
            if godConn then godConn:Disconnect() end
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
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local StarterGui = game:GetService("StarterGui")
    
    -- Infinite Ammo
    local ammoConn
    createToggle(CombatTab, "🔫 Infinite Ammo", Color3.fromRGB(255, 100, 100), function(enabled)
        if enabled then
            ammoConn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            for _, obj in ipairs(tool:GetDescendants()) do
                                if (obj:IsA("IntValue") or obj:IsA("NumberValue")) then
                                    local name = string.lower(obj.Name)
                                    if string.find(name, "ammo") or string.find(name, "clip") or string.find(name, "mag") then
                                        obj.Value = 999
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            if ammoConn then ammoConn:Disconnect() end
        end
    end)
    
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
    
    -- Hitbox Expander
    local hitboxConn
    createToggle(CombatTab, "📦 Hitbox Expander", Color3.fromRGB(200, 100, 200), function(enabled)
        if enabled then
            hitboxConn = RunService.Heartbeat:Connect(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(20, 20, 20)
                            hrp.Transparency = 0.8
                            hrp.CanCollide = false
                        end
                    end
                end
            end)
        else
            if hitboxConn then hitboxConn:Disconnect() end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                    end
                end
            end
        end
    end)
end

-- ===== VISUALS TAB =====
do
    local ESPEnabled = false
    local ESPObjects = {}
    
    -- ESP Toggle
    createToggle(VisualsTab, "👁️ ESP", Color3.fromRGB(100, 255, 150), function(enabled)
        ESPEnabled = enabled
        
        if enabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local char = player.Character
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Adornee = hrp
                        billboard.Size = UDim2.new(0, 200, 0, 60)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = hrp
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = player.Name
                        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
                        nameLabel.TextStrokeTransparency = 0.5
                        nameLabel.Font = Enum.Font.GothamBold
                        nameLabel.TextSize = 16
                        nameLabel.Parent = billboard
                        
                        local distLabel = Instance.new("TextLabel")
                        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
                        distLabel.BackgroundTransparency = 1
                        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                        distLabel.TextStrokeTransparency = 0.5
                        distLabel.Font = Enum.Font.Gotham
                        distLabel.TextSize = 14
                        distLabel.Parent = billboard
                        
                        ESPObjects[player] = {billboard = billboard, distLabel = distLabel}
                    end
                end
            end
            
            -- Update distances
            RunService.Heartbeat:Connect(function()
                if not ESPEnabled then return end
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local myPos = myChar.HumanoidRootPart.Position
                    for player, data in pairs(ESPObjects) do
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
                            data.distLabel.Text = string.format("%.0f studs", dist)
                        end
                    end
                end
            end)
        else
            for player, data in pairs(ESPObjects) do
                if data.billboard then
                    data.billboard:Destroy()
                end
            end
            ESPObjects = {}
        end
    end)
end

-- ===== MISC TAB =====
do
    -- Credits
    local creditsLabel = Instance.new("TextLabel")
    creditsLabel.Size = UDim2.new(1, -20, 0, 80)
    creditsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    creditsLabel.Text = "AdorHUB v1.0\n\nCreated by Lahmacun581\nUniversal Script Hub"
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
