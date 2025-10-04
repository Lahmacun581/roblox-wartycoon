--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║           Emergency Hamburg GUI v1.0                      ║
    ║     Speed | Fly | Vehicle Boost | ESP | Teleports        ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[Emergency Hamburg] Loading GUI v1.0...")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Global state
getgenv().EmergencyHamburg = getgenv().EmergencyHamburg or {
    Version = "1.0",
    Speed = 16,
    JumpPower = 50,
    Flying = false,
    FlySpeed = 50,
    VehicleBoost = false,
    VehicleSpeed = 100,
    ESPEnabled = false,
    Connections = {},
    ESPObjects = {}
}

-- Cleanup eski GUI
if PlayerGui:FindFirstChild("EmergencyHamburgGUI") then
    PlayerGui:FindFirstChild("EmergencyHamburgGUI"):Destroy()
end

-- Ana ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EmergencyHamburgGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 450)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 70)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🚑 Emergency Hamburg"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content Area
local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -70)
Content.Position = UDim2.new(0, 10, 0, 60)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 6
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, 10)
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Parent = Content

-- Helper: Create Button
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.AutoButtonColor = true
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 70, 80)
    stroke.Thickness = 1
    stroke.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Helper: Create Toggle
local function createToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 45, 0, 25)
    toggle.Position = UDim2.new(1, -50, 0.5, -12.5)
    toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 11
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            toggle.Text = "ON"
        else
            toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            toggle.Text = "OFF"
        end
        callback(state)
    end)
    
    return frame, toggle
end

-- Helper: Create Slider
local function createSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 1, -15)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 3)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 3)
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

-- ===== SPEED HACK =====
createSlider("🏃 Speed", 16, 200, 16, function(value)
    getgenv().EmergencyHamburg.Speed = value
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
end)

createSlider("🦘 Jump Power", 50, 200, 50, function(value)
    getgenv().EmergencyHamburg.JumpPower = value
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = value
        end
    end
end)

-- ===== FLY MODE =====
createSlider("✈️ Fly Speed", 10, 200, 50, function(value)
    getgenv().EmergencyHamburg.FlySpeed = value
end)

createToggle("✈️ Fly Mode (E to toggle)", function(enabled)
    getgenv().EmergencyHamburg.Flying = enabled
    
    if enabled then
        print("[Emergency Hamburg] Fly Mode: ON (Press E to fly)")
        
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
            print("[Fly] Started - WASD to move, Space/Shift for up/down")
            
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
                if not flying or not getgenv().EmergencyHamburg.Flying then
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
                    bodyVelocity.Velocity = moveDirection.Unit * getgenv().EmergencyHamburg.FlySpeed
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
        
        table.insert(getgenv().EmergencyHamburg.Connections, flyingConn)
    else
        print("[Emergency Hamburg] Fly Mode: OFF")
        for _, conn in ipairs(getgenv().EmergencyHamburg.Connections) do
            pcall(function() conn:Disconnect() end)
        end
        getgenv().EmergencyHamburg.Connections = {}
        
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

-- ===== VEHICLE SPEED BOOST =====
createSlider("🚗 Vehicle Speed", 50, 300, 100, function(value)
    getgenv().EmergencyHamburg.VehicleSpeed = value
end)

createToggle("🚗 Vehicle Speed Boost", function(enabled)
    getgenv().EmergencyHamburg.VehicleBoost = enabled
    
    if enabled then
        print("[Vehicle] Speed Boost: ON")
        
        local conn = RunService.Heartbeat:Connect(function()
            if not getgenv().EmergencyHamburg.VehicleBoost then return end
            
            local char = LocalPlayer.Character
            if char then
                local seat = char:FindFirstChildOfClass("VehicleSeat") or char:FindFirstChild("Seat")
                if seat and seat.Parent then
                    local vehicle = seat.Parent
                    if vehicle:IsA("Model") or vehicle:IsA("VehicleSeat") then
                        for _, part in ipairs(vehicle:GetDescendants()) do
                            if part:IsA("VehicleSeat") then
                                part.MaxSpeed = getgenv().EmergencyHamburg.VehicleSpeed
                            elseif part:IsA("BodyVelocity") or part:IsA("BodyGyro") then
                                part.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            end
                        end
                    end
                end
            end
        end)
        
        table.insert(getgenv().EmergencyHamburg.Connections, conn)
    else
        print("[Vehicle] Speed Boost: OFF")
    end
end)

-- ===== PLAYER ESP =====
createToggle("👁️ Player ESP", function(enabled)
    getgenv().EmergencyHamburg.ESPEnabled = enabled
    
    if enabled then
        print("[ESP] Enabled")
        
        local function createESP(player)
            if player == LocalPlayer then return end
            if getgenv().EmergencyHamburg.ESPObjects[player] then return end
            
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESP"
            billboard.AlwaysOnTop = true
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.Parent = game:GetService("CoreGui")
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 14
            nameLabel.Parent = billboard
            
            local distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = "0m"
            distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            distLabel.TextStrokeTransparency = 0.5
            distLabel.Font = Enum.Font.Gotham
            distLabel.TextSize = 12
            distLabel.Parent = billboard
            
            getgenv().EmergencyHamburg.ESPObjects[player] = {
                billboard = billboard,
                nameLabel = nameLabel,
                distLabel = distLabel
            }
            
            local function updateESP()
                if not getgenv().EmergencyHamburg.ESPEnabled then
                    billboard.Parent = nil
                    return
                end
                
                local char = player.Character
                local myChar = LocalPlayer.Character
                
                if char and myChar then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                    
                    if hrp and myHrp then
                        billboard.Adornee = hrp
                        billboard.Parent = game:GetService("CoreGui")
                        
                        local dist = (hrp.Position - myHrp.Position).Magnitude
                        distLabel.Text = string.format("%dm", math.floor(dist))
                    else
                        billboard.Parent = nil
                    end
                else
                    billboard.Parent = nil
                end
            end
            
            local conn = RunService.Heartbeat:Connect(updateESP)
            table.insert(getgenv().EmergencyHamburg.Connections, conn)
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        
        local conn = Players.PlayerAdded:Connect(function(player)
            if getgenv().EmergencyHamburg.ESPEnabled then
                task.wait(1)
                createESP(player)
            end
        end)
        table.insert(getgenv().EmergencyHamburg.Connections, conn)
        
        local conn2 = Players.PlayerRemoving:Connect(function(player)
            local data = getgenv().EmergencyHamburg.ESPObjects[player]
            if data then
                pcall(function()
                    if data.billboard then data.billboard:Destroy() end
                end)
                getgenv().EmergencyHamburg.ESPObjects[player] = nil
            end
        end)
        table.insert(getgenv().EmergencyHamburg.Connections, conn2)
    else
        print("[ESP] Disabled")
        for player, data in pairs(getgenv().EmergencyHamburg.ESPObjects) do
            pcall(function()
                if data.billboard then data.billboard:Destroy() end
            end)
        end
        getgenv().EmergencyHamburg.ESPObjects = {}
    end
end)

-- ===== TELEPORT LOCATIONS =====
local teleportLocations = {
    {name = "🚓 Police Station", pos = Vector3.new(0, 5, 0)},
    {name = "🚒 Fire Station", pos = Vector3.new(100, 5, 0)},
    {name = "🏥 Hospital", pos = Vector3.new(-100, 5, 0)},
    {name = "🏙️ City Center", pos = Vector3.new(0, 5, 100)}
}

for _, location in ipairs(teleportLocations) do
    createButton(location.name, function()
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(location.pos)
                print("[Teleport] Teleported to " .. location.name)
            end
        end
    end)
end

-- ===== MISC =====
createToggle("👻 Noclip", function(enabled)
    if enabled then
        print("[Noclip] Enabled")
        
        local conn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        table.insert(getgenv().EmergencyHamburg.Connections, conn)
    else
        print("[Noclip] Disabled")
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end)

createButton("🔄 Rejoin Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

createButton("🗑️ Close GUI", function()
    ScreenGui:Destroy()
end)

-- Klavye kısayolu (T = toggle GUI)
local visible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.T then
        visible = not visible
        MainFrame.Visible = visible
    end
end)

print("[Emergency Hamburg] GUI v1.0 loaded! Press T to toggle.")
print("[Emergency Hamburg] Fly: Enable toggle, then press E to start flying")
