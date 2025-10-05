--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║          MMC Zombie Project GUI v1.0                      ║
    ║     Zombie ESP | Fly Mode | Infinite Ammo                ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[MMC Zombie] Loading GUI v1.0...")

-- Wait for game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end
task.wait(1)

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
    LocalPlayer:WaitForChild("PlayerGui", 5)
    PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
end

if not PlayerGui then
    warn("[MMC Zombie] PlayerGui not found!")
    PlayerGui = LocalPlayer
end

-- Global state
getgenv().MMCZombie = getgenv().MMCZombie or {
    Version = "1.0",
    Enabled = {},
    Connections = {},
    ESPObjects = {},
    FlySpeed = 50
}

-- Cleanup old GUI
if PlayerGui:FindFirstChild("MMCZombieGUI") then
    PlayerGui:FindFirstChild("MMCZombieGUI"):Destroy()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MMCZombieGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999999
ScreenGui.Parent = PlayerGui

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 650, 0, 480)
MainContainer.Position = UDim2.new(0.5, -325, 0.5, -240)
MainContainer.BackgroundTransparency = 1
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.Parent = ScreenGui

-- Background
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 18, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainContainer

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 200, 100)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

-- Gradient
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 22, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 12, 8))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(18, 28, 18)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Color3.fromRGB(120, 220, 120)
HeaderStroke.Thickness = 1
HeaderStroke.Transparency = 0.6
HeaderStroke.Parent = Header

-- Title
local TitleContainer = Instance.new("Frame")
TitleContainer.Size = UDim2.new(0, 400, 1, 0)
TitleContainer.Position = UDim2.new(0, 20, 0, 0)
TitleContainer.BackgroundTransparency = 1
TitleContainer.Parent = Header

local Icon = Instance.new("TextLabel")
Icon.Size = UDim2.new(0, 40, 0, 40)
Icon.Position = UDim2.new(0, 0, 0.5, -20)
Icon.BackgroundTransparency = 1
Icon.Text = "🧟"
Icon.TextColor3 = Color3.fromRGB(100, 255, 100)
Icon.Font = Enum.Font.GothamBold
Icon.TextSize = 28
Icon.Parent = TitleContainer

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 28)
Title.Position = UDim2.new(0, 50, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "MMC ZOMBIE PROJECT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleContainer

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -50, 0, 18)
Subtitle.Position = UDim2.new(0, 50, 0, 34)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "v1.0 | Zombie Survival System"
Subtitle.TextColor3 = Color3.fromRGB(150, 200, 150)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 12
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TitleContainer

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "Minimize"
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -100, 0.5, -20)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 45, 35)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = Header

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 10)
MinimizeCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)

-- Content Area
local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -30, 1, -80)
Content.Position = UDim2.new(0, 15, 0, 70)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 6
Content.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 100)
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
    frame.BackgroundColor3 = Color3.fromRGB(22, 32, 22)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 80, 50)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 240, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 52, 0, 28)
    toggle.Position = UDim2.new(1, -62, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 70, 50)
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 22, 0, 22)
    toggleCircle.Position = UDim2.new(0, 3, 0.5, -11)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(180, 200, 180)
    toggleCircle.Parent = toggle
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            }):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -25, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 70, 50)
            }):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(180, 200, 180)
            }):Play()
        end
        callback(state)
    end)
    
    return frame, toggle
end

-- Helper: Create Slider
local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 58)
    frame.BackgroundColor3 = Color3.fromRGB(22, 32, 22)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 80, 50)
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 240, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 8)
    sliderBg.Position = UDim2.new(0, 15, 1, -18)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 50, 35)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
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

-- ===== ZOMBIE ESP SYSTEM =====
do
    local ESPEnabled = false
    local ESPBoxEnabled = false
    local ESPNameEnabled = false
    local ESPHealthEnabled = false
    local ESPDistanceEnabled = false
    local ESPTracerEnabled = false
    
    local ESPColor = Color3.fromRGB(100, 255, 100)
    local ESPObjects = {}
    local ESPConnections = {}
    local frameCount = 0
    
    local function isZombie(model)
        -- Check if model is a zombie (customize based on game)
        if not model or not model:IsA("Model") then return false end
        if model == LocalPlayer.Character then return false end
        
        -- Common zombie identifiers
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if not humanoid then return false end
        
        -- Check if it's a player
        if Players:GetPlayerFromCharacter(model) then return false end
        
        -- Check for zombie-specific properties
        local name = model.Name:lower()
        if name:find("zombie") or name:find("infected") or name:find("undead") then
            return true
        end
        
        -- Check if it's in a Zombies folder
        if model.Parent and (model.Parent.Name == "Zombies" or model.Parent.Name == "Enemies") then
            return true
        end
        
        return true -- Assume it's a zombie if it has humanoid and not a player
    end
    
    local function createESP(zombie)
        if ESPObjects[zombie] then return end
        if not isZombie(zombie) then return end
        
        local espData = {
            zombie = zombie,
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
        nameText.Text = zombie.Name
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
        healthBar.Color = Color3.fromRGB(255, 0, 0)
        healthBar.Thickness = 1
        healthBar.Transparency = 1
        healthBar.Filled = true
        espData.drawings.healthBar = healthBar
        
        -- Distance
        local distanceText = Drawing.new("Text")
        distanceText.Visible = false
        distanceText.Color = Color3.fromRGB(200, 255, 200)
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
        
        ESPObjects[zombie] = espData
    end
    
    local function removeESP(zombie)
        local espData = ESPObjects[zombie]
        if espData then
            for _, drawing in pairs(espData.drawings) do
                drawing:Remove()
            end
            ESPObjects[zombie] = nil
        end
    end
    
    local function updateESP()
        if not ESPEnabled then return end
        
        frameCount = frameCount + 1
        if frameCount % 2 ~= 0 then return end
        
        local camera = workspace.CurrentCamera
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        
        for zombie, espData in pairs(ESPObjects) do
            if not zombie or not zombie.Parent then
                removeESP(zombie)
                continue
            end
            
            local hrp = zombie:FindFirstChild("HumanoidRootPart") or zombie:FindFirstChild("Torso")
            local head = zombie:FindFirstChild("Head")
            local humanoid = zombie:FindFirstChildOfClass("Humanoid")
            
            if not hrp or not head or not humanoid then
                for _, drawing in pairs(espData.drawings) do
                    drawing.Visible = false
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
                    espData.drawings.healthBar.Color = Color3.fromRGB(255, 0, 0)
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
            else
                for _, drawing in pairs(espData.drawings) do
                    drawing.Visible = false
                end
            end
        end
    end
    
    local function scanForZombies()
        for _, model in ipairs(Workspace:GetDescendants()) do
            if isZombie(model) then
                createESP(model)
            end
        end
    end
    
    -- ESP Toggles
    createToggle(Content, "🧟 Enable Zombie ESP", function(enabled)
        ESPEnabled = enabled
        
        if enabled then
            print("[Zombie ESP] Enabled")
            
            scanForZombies()
            
            local conn = RunService.RenderStepped:Connect(function()
                if ESPEnabled then
                    updateESP()
                end
            end)
            table.insert(ESPConnections, conn)
            
            local conn2 = Workspace.DescendantAdded:Connect(function(descendant)
                if ESPEnabled then
                    task.wait(0.1)
                    if isZombie(descendant) then
                        createESP(descendant)
                    end
                end
            end)
            table.insert(ESPConnections, conn2)
            
            local conn3 = Workspace.DescendantRemoving:Connect(function(descendant)
                if ESPObjects[descendant] then
                    removeESP(descendant)
                end
            end)
            table.insert(ESPConnections, conn3)
        else
            print("[Zombie ESP] Disabled")
            
            for _, conn in ipairs(ESPConnections) do
                conn:Disconnect()
            end
            ESPConnections = {}
            
            for zombie, _ in pairs(ESPObjects) do
                removeESP(zombie)
            end
        end
    end)
    
    createToggle(Content, "📦 Box ESP", function(enabled)
        ESPBoxEnabled = enabled
    end)
    
    createToggle(Content, "📝 Name ESP", function(enabled)
        ESPNameEnabled = enabled
    end)
    
    createToggle(Content, "❤️ Health ESP", function(enabled)
        ESPHealthEnabled = enabled
    end)
    
    createToggle(Content, "📏 Distance ESP", function(enabled)
        ESPDistanceEnabled = enabled
    end)
    
    createToggle(Content, "📍 Tracer ESP", function(enabled)
        ESPTracerEnabled = enabled
    end)
end

-- ===== FLY MODE =====
do
    createSlider(Content, "✈️ Fly Speed", 10, 200, 50, function(value)
        getgenv().MMCZombie.FlySpeed = value
    end)
    
    createToggle(Content, "✈️ Fly Mode (E to toggle)", function(enabled)
        getgenv().MMCZombie.Enabled.Fly = enabled
        
        if enabled then
            print("[Fly] Mode: ON (Press E to fly)")
            
            local flying = false
            local flyingConn
            local controlConn
            local bodyVelocity
            local bodyGyro
            
            local function startFlying()
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if not hrp or not humanoid then return end
                
                flying = true
                print("[Fly] Started")
                
                humanoid.PlatformStand = true
                
                for _, obj in ipairs(hrp:GetChildren()) do
                    if obj:IsA("BodyMover") then
                        obj:Destroy()
                    end
                end
                
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Name = "FlyVelocity"
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.P = 1250
                bodyVelocity.Parent = hrp
                
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.Name = "FlyGyro"
                bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bodyGyro.P = 10000
                bodyGyro.D = 500
                bodyGyro.Parent = hrp
                
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                
                controlConn = RunService.Heartbeat:Connect(function()
                    if not flying or not getgenv().MMCZombie.Enabled.Fly then
                        if bodyVelocity then bodyVelocity:Destroy() end
                        if bodyGyro then bodyGyro:Destroy() end
                        if humanoid then humanoid.PlatformStand = false end
                        if controlConn then controlConn:Disconnect() end
                        
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                part.CanCollide = true
                            end
                        end
                        return
                    end
                    
                    if humanoid then
                        humanoid.PlatformStand = true
                    end
                    
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    
                    local camera = workspace.CurrentCamera
                    local moveDirection = Vector3.new()
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection - camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection - camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection = moveDirection + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection = moveDirection - Vector3.new(0, 1, 0)
                    end
                    
                    if moveDirection.Magnitude > 0 then
                        bodyVelocity.Velocity = moveDirection.Unit * getgenv().MMCZombie.FlySpeed
                    else
                        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    end
                    
                    bodyGyro.CFrame = camera.CFrame
                end)
            end
            
            local function stopFlying()
                flying = false
                
                if bodyVelocity then
                    bodyVelocity:Destroy()
                    bodyVelocity = nil
                end
                if bodyGyro then
                    bodyGyro:Destroy()
                    bodyGyro = nil
                end
                
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.PlatformStand = false
                    end
                    
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                end
                
                if controlConn then
                    controlConn:Disconnect()
                    controlConn = nil
                end
                
                print("[Fly] Stopped")
            end
            
            flyingConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == Enum.KeyCode.E then
                    if flying then
                        stopFlying()
                    else
                        startFlying()
                    end
                end
            end)
            
            table.insert(getgenv().MMCZombie.Connections, flyingConn)
        else
            print("[Fly] Mode: OFF")
            for _, conn in ipairs(getgenv().MMCZombie.Connections) do
                pcall(function() conn:Disconnect() end)
            end
            getgenv().MMCZombie.Connections = {}
            
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
                
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end)
end

-- ===== ADVANCED INFINITE AMMO =====
do
    local ammoConnection = nil
    local frameCounter = 0
    
    createToggle(Content, "∞ Infinite Ammo (Advanced)", function(enabled)
        getgenv().MMCZombie.Enabled.InfiniteAmmo = enabled
        
        if enabled then
            print("[Ammo] Infinite: ON (Advanced)")
            
            ammoConnection = RunService.Heartbeat:Connect(function()
                if not getgenv().MMCZombie.Enabled.InfiniteAmmo then return end
                
                frameCounter = frameCounter + 1
                if frameCounter % 5 ~= 0 then return end -- Every 5 frames
                
                local char = LocalPlayer.Character
                if not char then return end
                
                -- Check equipped tool
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    -- Method 1: Direct ammo values
                    for _, obj in ipairs(tool:GetDescendants()) do
                        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                            local name = obj.Name:lower()
                            if name:find("ammo") or name:find("mag") or name:find("clip") or 
                               name:find("current") or name:find("reserve") or name:find("bullet") then
                                obj.Value = 999
                            end
                        end
                    end
                    
                    -- Method 2: Check backpack tools
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    if backpack then
                        for _, backpackTool in ipairs(backpack:GetChildren()) do
                            if backpackTool:IsA("Tool") then
                                for _, obj in ipairs(backpackTool:GetDescendants()) do
                                    if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                                        local name = obj.Name:lower()
                                        if name:find("ammo") or name:find("mag") or name:find("clip") then
                                            obj.Value = 999
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Method 3: Check PlayerGui for ammo displays
                    for _, gui in ipairs(PlayerGui:GetDescendants()) do
                        if gui:IsA("IntValue") or gui:IsA("NumberValue") then
                            local name = gui.Name:lower()
                            if name:find("ammo") or name:find("mag") or name:find("clip") then
                                gui.Value = 999
                            end
                        end
                    end
                end
            end)
            
            table.insert(getgenv().MMCZombie.Connections, ammoConnection)
        else
            print("[Ammo] Infinite: OFF")
            if ammoConnection then
                ammoConnection:Disconnect()
                ammoConnection = nil
            end
        end
    end)
end

-- ===== ZOMBIE HITBOX EXPANDER =====
do
    getgenv().MMCZombie.HitboxSize = 10
    getgenv().MMCZombie.HitboxPart = "HumanoidRootPart"
    
    local hitboxConnection = nil
    local hitboxCache = {}
    local frameCounter = 0
    
    createSlider(Content, "📏 Zombie Hitbox Size", 5, 50, 10, function(value)
        getgenv().MMCZombie.HitboxSize = value
    end)
    
    -- Hitbox Part Selection
    local hitboxParts = {"HumanoidRootPart", "Torso", "Head", "UpperTorso"}
    local currentPartIndex = 1
    
    local partButton = Instance.new("TextButton")
    partButton.Size = UDim2.new(1, -10, 0, 42)
    partButton.BackgroundColor3 = Color3.fromRGB(30, 45, 30)
    partButton.Text = "🎯 Hitbox Part: HumanoidRootPart"
    partButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    partButton.Font = Enum.Font.GothamMedium
    partButton.TextSize = 14
    partButton.AutoButtonColor = false
    partButton.Parent = Content
    
    local partCorner = Instance.new("UICorner")
    partCorner.CornerRadius = UDim.new(0, 10)
    partCorner.Parent = partButton
    
    local partStroke = Instance.new("UIStroke")
    partStroke.Color = Color3.fromRGB(80, 120, 80)
    partStroke.Thickness = 1
    partStroke.Transparency = 0.6
    partStroke.Parent = partButton
    
    partButton.MouseButton1Click:Connect(function()
        currentPartIndex = currentPartIndex + 1
        if currentPartIndex > #hitboxParts then
            currentPartIndex = 1
        end
        
        getgenv().MMCZombie.HitboxPart = hitboxParts[currentPartIndex]
        partButton.Text = "🎯 Hitbox Part: " .. hitboxParts[currentPartIndex]
        
        print("[Hitbox] Part:", hitboxParts[currentPartIndex])
    end)
    
    createToggle(Content, "🎯 Zombie Hitbox Expander", function(enabled)
        getgenv().MMCZombie.Enabled.Hitbox = enabled
        print("[Hitbox] Expander:", enabled and "ON" or "OFF")
        
        if enabled then
            hitboxConnection = RunService.Heartbeat:Connect(function()
                frameCounter = frameCounter + 1
                if frameCounter % 10 ~= 0 then return end -- Every 10 frames
                
                local size = getgenv().MMCZombie.HitboxSize or 10
                local partName = getgenv().MMCZombie.HitboxPart or "HumanoidRootPart"
                
                -- Scan for zombies
                for _, model in ipairs(Workspace:GetDescendants()) do
                    if model:IsA("Model") and model ~= LocalPlayer.Character then
                        local humanoid = model:FindFirstChildOfClass("Humanoid")
                        if humanoid and not Players:GetPlayerFromCharacter(model) then
                            -- It's a zombie
                            local part = model:FindFirstChild(partName)
                            if part and part:IsA("BasePart") then
                                -- Cache original size
                                if not hitboxCache[part] then
                                    hitboxCache[part] = {
                                        OriginalSize = part.Size,
                                        OriginalTransparency = part.Transparency,
                                        OriginalCanCollide = part.CanCollide
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
                end
            end)
            
            table.insert(getgenv().MMCZombie.Connections, hitboxConnection)
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
                    part.CanCollide = data.OriginalCanCollide
                end
            end
            hitboxCache = {}
        end
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
            Size = UDim2.new(0, 650, 0, 480)
        }):Play()
        MinimizeBtn.Text = "—"
    end
end)

-- Keyboard shortcuts
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
            print("[MMC Zombie] Mouse: ENABLED")
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            print("[MMC Zombie] Mouse: DISABLED")
        end
    end
end)

-- Intro animation
MainContainer.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 650, 0, 480)
}):Play()

print("[MMC Zombie] GUI v1.0 loaded!")
print("[MMC Zombie] Press T to toggle GUI")
print("[MMC Zombie] Press U to toggle Mouse")
print("[MMC Zombie] Press E to start flying")
