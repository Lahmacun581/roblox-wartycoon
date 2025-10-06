--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║            MMC Zombie Project v2.0                        ║
    ║   Advanced Features | ESP | Combat | Survival            ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[MMC Zombie v2] Loading...")

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
getgenv().MMCZombie = getgenv().MMCZombie or {
    Version = "2.0",
    Enabled = {},
    Connections = {},
    ESPObjects = {}
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
MainContainer.Size = UDim2.new(0, 700, 0, 550)
MainContainer.Position = UDim2.new(0.5, -350, 0.5, -275)
MainContainer.BackgroundTransparency = 1
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.Parent = ScreenGui

-- Background
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainContainer

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(50, 200, 50)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(30, 35, 30)
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
Title.Text = "🧟 MMC ZOMBIE PROJECT v2.0"
Title.TextColor3 = Color3.fromRGB(50, 255, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -100, 0, 18)
Subtitle.Position = UDim2.new(0, 50, 0, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Advanced Zombie Survival System"
Subtitle.TextColor3 = Color3.fromRGB(100, 200, 100)
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
Content.ScrollBarImageColor3 = Color3.fromRGB(50, 200, 50)
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
    frame.BackgroundColor3 = Color3.fromRGB(30, 35, 30)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 250, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 52, 0, 28)
    toggle.Position = UDim2.new(1, -62, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 70, 60)
    toggle.Text = ""
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 22, 0, 22)
    toggleCircle.Position = UDim2.new(0, 3, 0.5, -11)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(150, 200, 150)
    toggleCircle.Parent = toggle
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 200, 50)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -25, 0.5, -11), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 70, 60)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -11), BackgroundColor3 = Color3.fromRGB(150, 200, 150)}):Play()
        end
        callback(state)
    end)
    
    return frame
end

-- Helper: Create Slider
local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 58)
    frame.BackgroundColor3 = Color3.fromRGB(30, 35, 30)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(200, 250, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 8)
    sliderBg.Position = UDim2.new(0, 15, 1, -18)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
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

-- Helper: Find Zombies
local function findZombies()
    local zombies = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("zombie") or name:find("infected") or name:find("undead") or name:match("zombie%d+") then
                local humanoid = obj:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    table.insert(zombies, obj)
                end
            end
        end
    end
    return zombies
end

-- ===== ZOMBIE ESP =====
print("[Zombie ESP] Initializing...")

local ESPEnabled = false
local ESPBox = false
local ESPName = false
local ESPHealth = false
local ESPDistance = false

createToggle(Content, "👁️ Enable Zombie ESP", function(enabled)
    ESPEnabled = enabled
    print("[Zombie ESP]", enabled and "ON" or "OFF")
    
    if not enabled then
        for _, data in pairs(getgenv().MMCZombie.ESPObjects) do
            for _, drawing in pairs(data.drawings) do
                drawing:Remove()
            end
        end
        getgenv().MMCZombie.ESPObjects = {}
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

local function createESP(zombie)
    if getgenv().MMCZombie.ESPObjects[zombie] then return end
    
    local data = {drawings = {}}
    
    data.drawings.box = Drawing.new("Square")
    data.drawings.box.Visible = false
    data.drawings.box.Color = Color3.fromRGB(255, 50, 50)
    data.drawings.box.Thickness = 2
    data.drawings.box.Filled = false
    
    data.drawings.name = Drawing.new("Text")
    data.drawings.name.Visible = false
    data.drawings.name.Color = Color3.fromRGB(255, 50, 50)
    data.drawings.name.Text = zombie.Name
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
    
    getgenv().MMCZombie.ESPObjects[zombie] = data
end

local espFrame = 0
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end
    
    espFrame = espFrame + 1
    if espFrame % 2 ~= 0 then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local zombies = findZombies()
    for _, zombie in ipairs(zombies) do
        createESP(zombie)
        
        local data = getgenv().MMCZombie.ESPObjects[zombie]
        if data then
            local hrp = zombie:FindFirstChild("HumanoidRootPart") or zombie:FindFirstChild("Torso")
            local head = zombie:FindFirstChild("Head")
            local humanoid = zombie:FindFirstChildOfClass("Humanoid")
            
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
                else
                    for _, drawing in pairs(data.drawings) do
                        drawing.Visible = false
                    end
                end
            end
        end
    end
end)

-- ===== TRIGGER BOT =====
print("[Trigger Bot] Initializing...")
getgenv().MMCZombie.TriggerBotDelay = 0.1

createSlider(Content, "🎯 Trigger Bot Delay", 0, 500, 100, function(value)
    getgenv().MMCZombie.TriggerBotDelay = value / 1000
end)

createToggle(Content, "🎯 Trigger Bot (Auto Shoot)", function(enabled)
    getgenv().MMCZombie.Enabled.TriggerBot = enabled
    print("[Trigger Bot]", enabled and "ON" or "OFF")
end)

RunService.RenderStepped:Connect(function()
    if not getgenv().MMCZombie.Enabled.TriggerBot then return end
    
    local mouse = LocalPlayer:GetMouse()
    if not mouse then return end
    
    local target = mouse.Target
    if not target then return end
    
    local targetModel = target:FindFirstAncestorOfClass("Model")
    if not targetModel then return end
    
    local name = targetModel.Name:lower()
    if name:find("zombie") or name:find("infected") or name:find("undead") then
        local humanoid = targetModel:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            task.wait(getgenv().MMCZombie.TriggerBotDelay)
            mouse1click()
        end
    end
end)

-- ===== WEAPON MODS =====
print("[Weapon] Initializing...")

createToggle(Content, "∞ Infinite Ammo", function(enabled)
    getgenv().MMCZombie.Enabled.InfiniteAmmo = enabled
    print("[Infinite Ammo]", enabled and "ON" or "OFF")
end)

createToggle(Content, "🔫 No Recoil", function(enabled)
    getgenv().MMCZombie.Enabled.NoRecoil = enabled
    print("[No Recoil]", enabled and "ON" or "OFF")
end)

createToggle(Content, "🎯 No Spread", function(enabled)
    getgenv().MMCZombie.Enabled.NoSpread = enabled
    print("[No Spread]", enabled and "ON" or "OFF")
end)

createToggle(Content, "⚡ Rapid Fire", function(enabled)
    getgenv().MMCZombie.Enabled.RapidFire = enabled
    print("[Rapid Fire]", enabled and "ON" or "OFF")
end)

createToggle(Content, "🚀 Infinite Range", function(enabled)
    getgenv().MMCZombie.Enabled.InfiniteRange = enabled
    print("[Infinite Range]", enabled and "ON" or "OFF")
end)

local weaponFrame = 0
RunService.Heartbeat:Connect(function()
    if not (getgenv().MMCZombie.Enabled.InfiniteAmmo or getgenv().MMCZombie.Enabled.NoRecoil or getgenv().MMCZombie.Enabled.NoSpread or getgenv().MMCZombie.Enabled.RapidFire or getgenv().MMCZombie.Enabled.InfiniteRange) then return end
    
    weaponFrame = weaponFrame + 1
    if weaponFrame % 3 ~= 0 then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                local name = obj.Name:lower()
                
                if getgenv().MMCZombie.Enabled.InfiniteAmmo then
                    if name:find("ammo") or name:find("mag") or name:find("clip") or name:find("bullet") then
                        obj.Value = 999
                    end
                end
                
                if getgenv().MMCZombie.Enabled.NoRecoil then
                    if name:find("recoil") or name:find("kick") then
                        obj.Value = 0
                    end
                end
                
                if getgenv().MMCZombie.Enabled.NoSpread then
                    if name:find("spread") or name:find("accuracy") or name:find("deviation") then
                        obj.Value = 0
                    end
                end
                
                if getgenv().MMCZombie.Enabled.RapidFire then
                    if name:find("firerate") or name:find("fire") or name:find("cooldown") or name:find("delay") then
                        obj.Value = 0.01
                    end
                end
                
                if getgenv().MMCZombie.Enabled.InfiniteRange then
                    if name:find("range") or name:find("distance") or name:find("maxdist") then
                        obj.Value = 9999
                    end
                end
            end
        end
    end
end)

-- ===== SURVIVAL =====
print("[Survival] Initializing...")

createToggle(Content, "❤️ Infinite Health", function(enabled)
    getgenv().MMCZombie.Enabled.InfiniteHealth = enabled
    print("[Infinite Health]", enabled and "ON" or "OFF")
end)

RunService.Heartbeat:Connect(function()
    if not getgenv().MMCZombie.Enabled.InfiniteHealth then return end
    
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
        end
    end
end)

-- ===== MOVEMENT =====
print("[Movement] Initializing...")

createToggle(Content, "✈️ Fly Mode", function(enabled)
    getgenv().MMCZombie.Enabled.Fly = enabled
    print("[Fly Mode]", enabled and "ON" or "OFF")
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if enabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = hrp
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name = "FlyGyro"
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 9e4
        bodyGyro.Parent = hrp
        
        RunService.RenderStepped:Connect(function()
            if not getgenv().MMCZombie.Enabled.Fly then
                if hrp:FindFirstChild("FlyVelocity") then
                    hrp.FlyVelocity:Destroy()
                end
                if hrp:FindFirstChild("FlyGyro") then
                    hrp.FlyGyro:Destroy()
                end
                return
            end
            
            local camera = workspace.CurrentCamera
            local speed = 50
            
            local velocity = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + camera.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - camera.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - camera.CFrame.RightVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + camera.CFrame.RightVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, speed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, speed, 0)
            end
            
            if hrp:FindFirstChild("FlyVelocity") then
                hrp.FlyVelocity.Velocity = velocity
            end
            if hrp:FindFirstChild("FlyGyro") then
                hrp.FlyGyro.CFrame = camera.CFrame
            end
        end)
    else
        if hrp:FindFirstChild("FlyVelocity") then
            hrp.FlyVelocity:Destroy()
        end
        if hrp:FindFirstChild("FlyGyro") then
            hrp.FlyGyro:Destroy()
        end
    end
end)

createToggle(Content, "🧱 No Clip", function(enabled)
    getgenv().MMCZombie.Enabled.NoClip = enabled
    print("[No Clip]", enabled and "ON" or "OFF")
end)

RunService.Stepped:Connect(function()
    if not getgenv().MMCZombie.Enabled.NoClip then return end
    
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ===== DAMAGE MODS =====
print("[Damage] Initializing...")
getgenv().MMCZombie.HeadshotMultiplier = 5

createSlider(Content, "🎯 Headshot Multiplier", 1, 10, 5, function(value)
    getgenv().MMCZombie.HeadshotMultiplier = value
end)

createToggle(Content, "💀 One Shot Kill Zombies", function(enabled)
    getgenv().MMCZombie.Enabled.OneShotKill = enabled
    print("[One Shot Kill]", enabled and "ON" or "OFF")
    
    if enabled then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if getgenv().MMCZombie.Enabled.OneShotKill and method == "FireServer" then
                local eventName = tostring(self.Name):lower()
                if eventName:find("damage") or eventName:find("hit") or eventName:find("shoot") then
                    -- Set damage to 999999
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "number" and arg > 0 and arg < 1000 then
                            args[i] = 999999
                            break
                        end
                    end
                end
            end
            
            return oldNamecall(self, unpack(args))
        end)
    end
end)

createToggle(Content, "🎯 Headshot Damage Boost", function(enabled)
    getgenv().MMCZombie.Enabled.HeadshotBoost = enabled
    print("[Headshot Boost]", enabled and "ON" or "OFF")
    
    if enabled then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if getgenv().MMCZombie.Enabled.HeadshotBoost and method == "FireServer" then
                local eventName = tostring(self.Name):lower()
                if eventName:find("damage") or eventName:find("hit") or eventName:find("headshot") then
                    -- Check if hit part is Head
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "Instance" and arg.Name == "Head" then
                            -- Find damage value and multiply
                            for j, dmg in ipairs(args) do
                                if typeof(dmg) == "number" and dmg > 0 and dmg < 1000 then
                                    args[j] = dmg * getgenv().MMCZombie.HeadshotMultiplier
                                    break
                                end
                            end
                            break
                        end
                    end
                end
            end
            
            return oldNamecall(self, unpack(args))
        end)
    end
end)

-- ===== ZOMBIE CONTROL =====
print("[Zombie Control] Initializing...")

createToggle(Content, "❄️ Freeze Zombies", function(enabled)
    getgenv().MMCZombie.Enabled.FreezeZombies = enabled
    print("[Freeze Zombies]", enabled and "ON" or "OFF")
end)

RunService.Heartbeat:Connect(function()
    if not getgenv().MMCZombie.Enabled.FreezeZombies then return end
    
    local zombies = findZombies()
    for _, zombie in ipairs(zombies) do
        local hrp = zombie:FindFirstChild("HumanoidRootPart") or zombie:FindFirstChild("Torso")
        if hrp then
            hrp.Anchored = true
        end
    end
end)

createToggle(Content, "💀 Kill All Zombies", function(enabled)
    if enabled then
        local zombies = findZombies()
        local count = 0
        
        for _, zombie in ipairs(zombies) do
            local humanoid = zombie:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
                count = count + 1
            end
        end
        
        print("[Kill All] Killed " .. count .. " zombies!")
    end
end)

-- ===== MONEY SYSTEM =====
print("[Money] Initializing...")
getgenv().MMCZombie.MoneyMultiplier = 2

createSlider(Content, "💰 Money/Points Multiplier", 1, 10, 2, function(value)
    getgenv().MMCZombie.MoneyMultiplier = value
end)

createToggle(Content, "💰 Money/Points Boost", function(enabled)
    getgenv().MMCZombie.Enabled.MoneyBoost = enabled
    print("[Money Boost]", enabled and "ON" or "OFF")
    
    if enabled then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if getgenv().MMCZombie.Enabled.MoneyBoost and method == "FireServer" then
                local eventName = tostring(self.Name):lower()
                if eventName:find("money") or eventName:find("cash") or eventName:find("coin") or eventName:find("currency") or eventName:find("point") or eventName:find("credit") then
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "number" and arg > 0 then
                            args[i] = arg * getgenv().MMCZombie.MoneyMultiplier
                            break
                        end
                    end
                end
            end
            
            return oldNamecall(self, unpack(args))
        end)
    end
end)

createToggle(Content, "∞ Infinite Money/Points", function(enabled)
    getgenv().MMCZombie.Enabled.InfiniteMoney = enabled
    print("[Infinite Money]", enabled and "ON" or "OFF")
end)

RunService.Heartbeat:Connect(function()
    if not getgenv().MMCZombie.Enabled.InfiniteMoney then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    -- Find money/points values
    for _, obj in ipairs(LocalPlayer:GetDescendants()) do
        if obj:IsA("NumberValue") or obj:IsA("IntValue") then
            local name = obj.Name:lower()
            if name:find("money") or name:find("cash") or name:find("point") or name:find("coin") or name:find("currency") or name:find("credit") then
                obj.Value = 999999
            end
        end
    end
    
    -- Check PlayerGui
    if PlayerGui then
        for _, obj in ipairs(PlayerGui:GetDescendants()) do
            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                local name = obj.Name:lower()
                if name:find("money") or name:find("cash") or name:find("point") or name:find("coin") or name:find("currency") or name:find("credit") then
                    obj.Value = 999999
                end
            end
        end
    end
end)

createToggle(Content, "🆓 Free Upgrades", function(enabled)
    getgenv().MMCZombie.Enabled.FreeUpgrades = enabled
    print("[Free Upgrades]", enabled and "ON" or "OFF")
    
    if enabled then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if getgenv().MMCZombie.Enabled.FreeUpgrades and method == "InvokeServer" then
                local eventName = tostring(self.Name):lower()
                if eventName:find("buy") or eventName:find("purchase") or eventName:find("upgrade") then
                    -- Make it free
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "number" and arg > 0 then
                            args[i] = 0
                            break
                        end
                    end
                end
            end
            
            return oldNamecall(self, unpack(args))
        end)
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
    Size = UDim2.new(0, 700, 0, 550)
}):Play()

print("[MMC Zombie v2] Loaded!")
print("[MMC Zombie v2] Press T to toggle GUI")
