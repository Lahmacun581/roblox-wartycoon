--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║            Block Spin GUI v1.0                            ║
    ║   Auto Farm | ESP | Combat | Movement                    ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[Block Spin] Loading...")

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
getgenv().BlockSpin = getgenv().BlockSpin or {
    Version = "1.0",
    Enabled = {},
    Connections = {},
    ESPObjects = {},
    Target = nil
}

-- Cleanup old GUI
if PlayerGui:FindFirstChild("BlockSpinGUI") then
    PlayerGui:FindFirstChild("BlockSpinGUI"):Destroy()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlockSpinGUI"
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
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainContainer

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 100, 255)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
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
Title.Text = "⚔️ BLOCK SPIN v1.0"
Title.TextColor3 = Color3.fromRGB(150, 150, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -100, 0, 18)
Subtitle.Position = UDim2.new(0, 50, 0, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Auto Farm & Combat System"
Subtitle.TextColor3 = Color3.fromRGB(120, 120, 200)
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
Content.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
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
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 52, 0, 28)
    toggle.Position = UDim2.new(1, -62, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
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
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -25, 0.5, -11), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
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
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 8)
    sliderBg.Position = UDim2.new(0, 15, 1, -18)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
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

-- Helper: Find Closest Player
local function findClosestPlayer()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    
    local myPos = myChar.HumanoidRootPart.Position
    local closest = nil
    local closestDist = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
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

-- ===== AUTO FARM =====
print("[Auto Farm] Initializing...")
getgenv().BlockSpin.AttackDelay = 0.2
getgenv().BlockSpin.AttackRange = 20

createSlider(Content, "⚔️ Attack Delay", 0.1, 1, 0.2, function(value)
    getgenv().BlockSpin.AttackDelay = value
end)

createSlider(Content, "📏 Attack Range", 10, 50, 20, function(value)
    getgenv().BlockSpin.AttackRange = value
end)

createToggle(Content, "⚔️ Auto Farm (Click)", function(enabled)
    getgenv().BlockSpin.Enabled.AutoFarm = enabled
    print("[Auto Farm]", enabled and "ON" or "OFF")
end)

RunService.RenderStepped:Connect(function()
    if not getgenv().BlockSpin.Enabled.AutoFarm then return end
    
    local target = findClosestPlayer()
    if target and target.Character then
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dist = (hrp.Position - myChar.HumanoidRootPart.Position).Magnitude
            
            if dist <= getgenv().BlockSpin.AttackRange then
                -- Aim at target
                local camera = workspace.CurrentCamera
                if camera then
                    camera.CFrame = CFrame.new(camera.CFrame.Position, hrp.Position)
                end
                
                -- Attack
                task.spawn(function()
                    mouse1click()
                    task.wait(getgenv().BlockSpin.AttackDelay)
                end)
            end
        end
    end
end)

createToggle(Content, "🎯 Auto Aim", function(enabled)
    getgenv().BlockSpin.Enabled.AutoAim = enabled
    print("[Auto Aim]", enabled and "ON" or "OFF")
end)

RunService.RenderStepped:Connect(function()
    if not getgenv().BlockSpin.Enabled.AutoAim then return end
    
    local target = findClosestPlayer()
    if target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local camera = workspace.CurrentCamera
            if camera then
                camera.CFrame = CFrame.new(camera.CFrame.Position, hrp.Position)
            end
        end
    end
end)

createToggle(Content, "⚡ Kill Aura (Advanced)", function(enabled)
    getgenv().BlockSpin.Enabled.KillAura = enabled
    print("[Kill Aura]", enabled and "ON" or "OFF")
end)

local killAuraFrame = 0
RunService.RenderStepped:Connect(function()
    if not getgenv().BlockSpin.Enabled.KillAura then return end
    
    killAuraFrame = killAuraFrame + 1
    if killAuraFrame % 3 ~= 0 then return end
    
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    
    local myHrp = myChar.HumanoidRootPart
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local attackedThisFrame = false
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            
            if humanoid and humanoid.Health > 0 and hrp and head then
                local dist = (hrp.Position - myHrp.Position).Magnitude
                
                if dist <= getgenv().BlockSpin.AttackRange then
                    -- Aim at target
                    camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
                    
                    -- Attack
                    if not attackedThisFrame then
                        task.spawn(function()
                            pcall(function()
                                mouse1press()
                                task.wait(0.05)
                                mouse1release()
                            end)
                        end)
                        attackedThisFrame = true
                        task.wait(getgenv().BlockSpin.AttackDelay)
                    end
                end
            end
        end
    end
end)

createToggle(Content, "🚀 Reach Extender", function(enabled)
    getgenv().BlockSpin.Enabled.ReachExtender = enabled
    print("[Reach Extender]", enabled and "ON" or "OFF")
    
    if enabled then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if getgenv().BlockSpin.Enabled.ReachExtender and method == "FireServer" then
                local eventName = tostring(self.Name):lower()
                if eventName:find("attack") or eventName:find("hit") or eventName:find("damage") or eventName:find("swing") then
                    -- Extend reach by modifying distance/range arguments
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "number" and arg > 0 and arg < 100 then
                            args[i] = 9999
                            break
                        end
                    end
                end
            end
            
            return oldNamecall(self, unpack(args))
        end)
    end
end)

-- ===== PLAYER ESP =====
print("[ESP] Initializing...")

local ESPEnabled = false
local ESPBox = false
local ESPName = false
local ESPHealth = false
local ESPDistance = false

createToggle(Content, "👁️ Enable Player ESP", function(enabled)
    ESPEnabled = enabled
    print("[ESP]", enabled and "ON" or "OFF")
    
    if not enabled then
        for _, data in pairs(getgenv().BlockSpin.ESPObjects) do
            for _, drawing in pairs(data.drawings) do
                drawing:Remove()
            end
        end
        getgenv().BlockSpin.ESPObjects = {}
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

local function createESP(player)
    if player == LocalPlayer then return end
    if getgenv().BlockSpin.ESPObjects[player] then return end
    
    local data = {drawings = {}}
    
    data.drawings.box = Drawing.new("Square")
    data.drawings.box.Visible = false
    data.drawings.box.Color = Color3.fromRGB(100, 100, 255)
    data.drawings.box.Thickness = 2
    data.drawings.box.Filled = false
    
    data.drawings.name = Drawing.new("Text")
    data.drawings.name.Visible = false
    data.drawings.name.Color = Color3.fromRGB(100, 100, 255)
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
    
    getgenv().BlockSpin.ESPObjects[player] = data
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
            createESP(player)
            
            local data = getgenv().BlockSpin.ESPObjects[player]
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

-- ===== MOVEMENT =====
print("[Movement] Initializing...")

createToggle(Content, "⚡ Speed Hack", function(enabled)
    getgenv().BlockSpin.Enabled.Speed = enabled
    print("[Speed Hack]", enabled and "ON" or "OFF")
end)

RunService.Heartbeat:Connect(function()
    if not getgenv().BlockSpin.Enabled.Speed then return end
    
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 50
        end
    end
end)

createToggle(Content, "✈️ Fly Mode", function(enabled)
    getgenv().BlockSpin.Enabled.Fly = enabled
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
            if not getgenv().BlockSpin.Enabled.Fly then
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
    getgenv().BlockSpin.Enabled.NoClip = enabled
    print("[No Clip]", enabled and "ON" or "OFF")
end)

RunService.Stepped:Connect(function()
    if not getgenv().BlockSpin.Enabled.NoClip then return end
    
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ===== DEFENSE =====
print("[Defense] Initializing...")

createToggle(Content, "❤️ Infinite Health", function(enabled)
    getgenv().BlockSpin.Enabled.InfiniteHealth = enabled
    print("[Infinite Health]", enabled and "ON" or "OFF")
end)

RunService.Heartbeat:Connect(function()
    if not getgenv().BlockSpin.Enabled.InfiniteHealth then return end
    
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
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
    Size = UDim2.new(0, 700, 0, 550)
}):Play()

print("[Block Spin] Loaded!")
print("[Block Spin] Press T to toggle GUI")
