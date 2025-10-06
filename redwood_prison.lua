--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║         Redwood Prison Reworked v1.0                      ║
    ║   Guard ESP | Aimbot | Infinite Ammo | Team Check        ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[Redwood Prison] Loading...")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- Wait for PlayerGui
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
if not PlayerGui then
    PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
end

-- Global state
getgenv().RedwoodPrison = getgenv().RedwoodPrison or {
    Version = "1.0",
    Enabled = {},
    Connections = {},
    ESPObjects = {},
    TeamCheck = true
}

-- Cleanup old GUI
if PlayerGui:FindFirstChild("RedwoodPrisonGUI") then
    PlayerGui:FindFirstChild("RedwoodPrisonGUI"):Destroy()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedwoodPrisonGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999999
ScreenGui.Parent = PlayerGui

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 650, 0, 500)
MainContainer.Position = UDim2.new(0.5, -325, 0.5, -250)
MainContainer.BackgroundTransparency = 1
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.Parent = ScreenGui

-- Background
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainContainer

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(200, 50, 50)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 0, 30)
Title.Position = UDim2.new(0, 50, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "🚔 REDWOOD PRISON v1.0"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -100, 0, 18)
Subtitle.Position = UDim2.new(0, 50, 0, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Guard ESP & Combat System"
Subtitle.TextColor3 = Color3.fromRGB(200, 100, 100)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 12
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
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

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -30, 1, -80)
Content.Position = UDim2.new(0, 15, 0, 70)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 6
Content.ScrollBarImageColor3 = Color3.fromRGB(200, 50, 50)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, 10)
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Parent = Content

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 10)
ContentPadding.PaddingLeft = UDim.new(0, 10)
ContentPadding.PaddingRight = UDim.new(0, 10)
ContentPadding.PaddingBottom = UDim.new(0, 10)
ContentPadding.Parent = Content

-- Helper: Create Toggle
local function createToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 52, 0, 28)
    toggle.Position = UDim2.new(1, -62, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    toggle.Text = ""
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 22, 0, 22)
    toggleCircle.Position = UDim2.new(0, 3, 0.5, -11)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 200)
    toggleCircle.Parent = toggle
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -25, 0.5, -11), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -11), BackgroundColor3 = Color3.fromRGB(150, 150, 200)}):Play()
        end
        callback(state)
    end)
    
    return frame
end

-- Helper: Create Slider
local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 58)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(255, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 8)
    sliderBg.Position = UDim2.new(0, 15, 1, -18)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
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
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. ": " .. tostring(value)
            callback(value)
        end
    end)
    
    return frame
end

-- Helper: Get Player Team
local function getPlayerTeam(player)
    if player.Team then
        return player.Team.Name
    end
    return "Unknown"
end

-- Helper: Is Guard
local function isGuard(player)
    local team = getPlayerTeam(player)
    return team:lower():find("guard") or team:lower():find("police") or team:lower():find("cop")
end

-- Helper: Find Closest Guard
local function findClosestGuard()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    
    local myPos = myChar.HumanoidRootPart.Position
    local closest = nil
    local closestDist = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Team check
            if getgenv().RedwoodPrison.TeamCheck and not isGuard(player) then
                continue
            end
            
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and hrp then
                local dist = (hrp.Position - myPos).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = player
                end
            end
        end
    end
    
    return closest
end

-- ===== TEAM CHECK =====
print("[Team Check] Initializing...")

createToggle(Content, "👥 Team Check (Target Guards Only)", function(enabled)
    getgenv().RedwoodPrison.TeamCheck = enabled
    print("[Team Check]", enabled and "ON" or "OFF")
end)

-- Set default to true
task.spawn(function()
    task.wait(0.1)
    getgenv().RedwoodPrison.TeamCheck = true
end)

-- ===== GUARD ESP =====
print("[Guard ESP] Initializing...")

local ESPEnabled = false
local ESPBox = false
local ESPName = false
local ESPHealth = false
local ESPDistance = false
local ESPTeam = false

createToggle(Content, "👁️ Enable Guard ESP", function(enabled)
    ESPEnabled = enabled
    print("[Guard ESP]", enabled and "ON" or "OFF")
    
    if not enabled then
        for _, data in pairs(getgenv().RedwoodPrison.ESPObjects) do
            for _, drawing in pairs(data.drawings) do
                drawing:Remove()
            end
        end
        getgenv().RedwoodPrison.ESPObjects = {}
    end
end)

createToggle(Content, "📦 Box ESP", function(enabled)
    ESPBox = enabled
end)

createToggle(Content, "📝 Name ESP", function(enabled)
    ESPName = enabled
end)

createToggle(Content, "❤️ Health ESP", function(enabled)
    ESPHealth = enabled
end)

createToggle(Content, "📏 Distance ESP", function(enabled)
    ESPDistance = enabled
end)

createToggle(Content, "👮 Team ESP", function(enabled)
    ESPTeam = enabled
end)

local function createESP(player)
    if player == LocalPlayer then return end
    if getgenv().RedwoodPrison.ESPObjects[player] then return end
    
    local data = {drawings = {}}
    
    data.drawings.box = Drawing.new("Square")
    data.drawings.box.Visible = false
    data.drawings.box.Color = Color3.fromRGB(255, 50, 50)
    data.drawings.box.Thickness = 2
    data.drawings.box.Filled = false
    
    data.drawings.name = Drawing.new("Text")
    data.drawings.name.Visible = false
    data.drawings.name.Color = Color3.fromRGB(255, 50, 50)
    data.drawings.name.Text = player.Name
    data.drawings.name.Size = 16
    data.drawings.name.Center = true
    data.drawings.name.Outline = true
    
    data.drawings.health = Drawing.new("Text")
    data.drawings.health.Visible = false
    data.drawings.health.Color = Color3.fromRGB(50, 255, 50)
    data.drawings.health.Size = 14
    data.drawings.health.Center = true
    data.drawings.health.Outline = true
    
    data.drawings.distance = Drawing.new("Text")
    data.drawings.distance.Visible = false
    data.drawings.distance.Color = Color3.fromRGB(200, 200, 200)
    data.drawings.distance.Size = 14
    data.drawings.distance.Center = true
    data.drawings.distance.Outline = true
    
    data.drawings.team = Drawing.new("Text")
    data.drawings.team.Visible = false
    data.drawings.team.Color = Color3.fromRGB(255, 200, 50)
    data.drawings.team.Size = 14
    data.drawings.team.Center = true
    data.drawings.team.Outline = true
    
    getgenv().RedwoodPrison.ESPObjects[player] = data
end

local espFrame = 0
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end
    
    espFrame = espFrame + 1
    if espFrame % 2 ~= 0 then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Only show guards if team check is enabled
            if getgenv().RedwoodPrison.TeamCheck and not isGuard(player) then
                if getgenv().RedwoodPrison.ESPObjects[player] then
                    for _, drawing in pairs(getgenv().RedwoodPrison.ESPObjects[player].drawings) do
                        drawing.Visible = false
                    end
                end
                continue
            end
            
            createESP(player)
            
            local data = getgenv().RedwoodPrison.ESPObjects[player]
            if data and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local head = player.Character:FindFirstChild("Head")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                
                if hrp and head and humanoid then
                    local hrpPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                    
                    if onScreen then
                        local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        local legPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                        
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height / 2
                        
                        if ESPBox then
                            data.drawings.box.Size = Vector2.new(width, height)
                            data.drawings.box.Position = Vector2.new(hrpPos.X - width/2, headPos.Y)
                            data.drawings.box.Visible = true
                        else
                            data.drawings.box.Visible = false
                        end
                        
                        if ESPName then
                            data.drawings.name.Position = Vector2.new(hrpPos.X, headPos.Y - 20)
                            data.drawings.name.Visible = true
                        else
                            data.drawings.name.Visible = false
                        end
                        
                        if ESPHealth then
                            data.drawings.health.Text = math.floor(humanoid.Health) .. " HP"
                            data.drawings.health.Position = Vector2.new(hrpPos.X, headPos.Y - 5)
                            data.drawings.health.Visible = true
                        else
                            data.drawings.health.Visible = false
                        end
                        
                        if ESPDistance then
                            local myChar = LocalPlayer.Character
                            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                local dist = (hrp.Position - myChar.HumanoidRootPart.Position).Magnitude
                                data.drawings.distance.Text = math.floor(dist) .. "m"
                                data.drawings.distance.Position = Vector2.new(hrpPos.X, legPos.Y + 5)
                                data.drawings.distance.Visible = true
                            end
                        else
                            data.drawings.distance.Visible = false
                        end
                        
                        if ESPTeam then
                            data.drawings.team.Text = getPlayerTeam(player)
                            data.drawings.team.Position = Vector2.new(hrpPos.X, legPos.Y + 20)
                            data.drawings.team.Visible = true
                        else
                            data.drawings.team.Visible = false
                        end
                    else
                        for _, drawing in pairs(data.drawings) do
                            drawing.Visible = false
                        end
                    end
                end
            end
        end
    end
end)

-- ===== AIMBOT =====
print("[Aimbot] Initializing...")
getgenv().RedwoodPrison.AimbotFOV = 200
getgenv().RedwoodPrison.AimbotSmooth = 5

createSlider(Content, "🎯 Aimbot FOV", 50, 500, 200, function(value)
    getgenv().RedwoodPrison.AimbotFOV = value
end)

createSlider(Content, "   Aimbot Smooth", 1, 20, 5, function(value)
    getgenv().RedwoodPrison.AimbotSmooth = value
end)

createToggle(Content, "🎯 Aimbot (Hold Right Click)", function(enabled)
    getgenv().RedwoodPrison.Enabled.Aimbot = enabled
    print("[Aimbot]", enabled and "ON" or "OFF")
end)

RunService.RenderStepped:Connect(function()
    if not getgenv().RedwoodPrison.Enabled.Aimbot then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local closest = nil
    local closestDist = getgenv().RedwoodPrison.AimbotFOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Team check
            if getgenv().RedwoodPrison.TeamCheck and not isGuard(player) then
                continue
            end
            
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local head = player.Character:FindFirstChild("Head")
            
            if humanoid and humanoid.Health > 0 and head then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    
    if closest and closest.Character then
        local head = closest.Character:FindFirstChild("Head")
        if head then
            local targetPos = head.Position
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.new(camera.CFrame.Position, targetPos)
            
            local smooth = getgenv().RedwoodPrison.AimbotSmooth
            camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 / smooth)
        end
    end
end)

-- ===== INFINITE AMMO =====
print("[Infinite Ammo] Initializing...")

createToggle(Content, "∞ Infinite Ammo", function(enabled)
    getgenv().RedwoodPrison.Enabled.InfiniteAmmo = enabled
    print("[Infinite Ammo]", enabled and "ON" or "OFF")
end)

local ammoFrame = 0
RunService.Heartbeat:Connect(function()
    if not getgenv().RedwoodPrison.Enabled.InfiniteAmmo then return end
    
    ammoFrame = ammoFrame + 1
    if ammoFrame % 3 ~= 0 then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                local name = obj.Name:lower()
                if name:find("ammo") or name:find("mag") or name:find("clip") or name:find("bullet") or name:find("round") then
                    obj.Value = 999
                end
            end
        end
        
        local config = tool:FindFirstChild("Configuration") or tool:FindFirstChild("Config") or tool:FindFirstChild("Settings")
        if config then
            for _, obj in ipairs(config:GetChildren()) do
                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                    local name = obj.Name:lower()
                    if name:find("ammo") or name:find("mag") or name:find("clip") then
                        obj.Value = 999
                    end
                end
            end
        end
    end
    
    -- Check backpack
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                for _, obj in ipairs(tool:GetDescendants()) do
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        local name = obj.Name:lower()
                        if name:find("ammo") or name:find("mag") or name:find("clip") then
                            obj.Value = 999
                        end
                    end
                end
            end
        end
    end
end)

-- Keyboard shortcuts
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.T then
        MainContainer.Visible = not MainContainer.Visible
    end
end)

-- Intro animation
MainContainer.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 650, 0, 500)
}):Play()

print("[Redwood Prison] Loaded!")
print("[Redwood Prison] Press T to toggle GUI")
