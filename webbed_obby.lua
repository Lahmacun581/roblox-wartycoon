--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║           Webbed 2 Player Obby GUI v1.0                   ║
    ║        Fly | Infinite Jump | Partner Teleport             ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[Webbed Obby] Loading GUI v1.0...")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Global state
getgenv().WebbedObby = getgenv().WebbedObby or {
    Version = "1.0",
    Flying = false,
    InfiniteJump = false,
    Speed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    Connections = {}
}

-- Cleanup eski GUI
if PlayerGui:FindFirstChild("WebbedObbyGUI") then
    PlayerGui:FindFirstChild("WebbedObbyGUI"):Destroy()
end

-- Ana ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WebbedObbyGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
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
Title.Text = "🕸️ Webbed 2 Player Obby"
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

-- ===== INFINITE JUMP =====
createToggle("♾️ Infinite Jump", function(enabled)
    getgenv().WebbedObby.InfiniteJump = enabled
    
    if enabled then
        print("[Webbed Obby] Infinite Jump: ON")
        
        local conn = UserInputService.JumpRequest:Connect(function()
            if getgenv().WebbedObby.InfiniteJump then
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
        
        table.insert(getgenv().WebbedObby.Connections, conn)
    else
        print("[Webbed Obby] Infinite Jump: OFF")
    end
end)

-- ===== ADVANCED FLY MODE (Spiderman Compatible) =====
createSlider("✈️ Fly Speed", 10, 200, 50, function(value)
    getgenv().WebbedObby.FlySpeed = value
end)

createToggle("✈️ Fly Mode (E to toggle)", function(enabled)
    getgenv().WebbedObby.Flying = enabled
    
    if enabled then
        print("[Webbed Obby] Advanced Fly Mode: ON (Press E to fly)")
        
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
            print("[Fly] Started - WASD to move, Space/Shift for up/down, E to stop")
            
            -- Disable character physics
            humanoid.PlatformStand = true
            
            -- Remove existing physics objects
            for _, obj in ipairs(hrp:GetChildren()) do
                if obj:IsA("BodyMover") then
                    obj:Destroy()
                end
            end
            
            -- Create new physics objects with stronger force
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
            
            -- Disable all body parts collision
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            -- Main fly loop
            controlConn = RunService.Heartbeat:Connect(function()
                if not flying or not getgenv().WebbedObby.Flying then
                    if bodyVelocity then bodyVelocity:Destroy() end
                    if bodyGyro then bodyGyro:Destroy() end
                    if humanoid then humanoid.PlatformStand = false end
                    if controlConn then controlConn:Disconnect() end
                    
                    -- Restore collision
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                    return
                end
                
                -- Keep physics disabled
                if humanoid then
                    humanoid.PlatformStand = true
                end
                
                -- Keep collision disabled
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                
                local camera = workspace.CurrentCamera
                local moveDirection = Vector3.new()
                
                -- WASD movement
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
                
                -- Up/Down movement
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0)
                end
                
                -- Apply velocity
                if moveDirection.Magnitude > 0 then
                    bodyVelocity.Velocity = moveDirection.Unit * getgenv().WebbedObby.FlySpeed
                else
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
                
                -- Apply rotation
                bodyGyro.CFrame = camera.CFrame
            end)
        end
        
        local function stopFlying()
            flying = false
            
            -- Clean up physics objects
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
            if bodyGyro then
                bodyGyro:Destroy()
                bodyGyro = nil
            end
            
            -- Restore character
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
                
                -- Restore collision
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
        
        -- E key toggle
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
        
        table.insert(getgenv().WebbedObby.Connections, flyingConn)
    else
        print("[Webbed Obby] Fly Mode: OFF")
        -- Disconnect all fly connections
        for _, conn in ipairs(getgenv().WebbedObby.Connections) do
            pcall(function() conn:Disconnect() end)
        end
        getgenv().WebbedObby.Connections = {}
        
        -- Restore character
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

-- ===== TELEPORT TO PARTNER =====
createButton("👥 Teleport to Partner", function()
    local char = LocalPlayer.Character
    if not char then
        print("[Teleport] No character found")
        return
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        print("[Teleport] No HumanoidRootPart found")
        return
    end
    
    -- Find partner (other player in game)
    local partner = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            partner = player
            break
        end
    end
    
    if not partner then
        print("[Teleport] No partner found in game")
        return
    end
    
    local partnerHrp = partner.Character:FindFirstChild("HumanoidRootPart")
    if not partnerHrp then
        print("[Teleport] Partner has no HumanoidRootPart")
        return
    end
    
    -- Teleport
    hrp.CFrame = partnerHrp.CFrame * CFrame.new(3, 0, 0)
    print("[Teleport] Teleported to " .. partner.Name)
end)

-- ===== FIND CHECKPOINTS =====
createButton("🔍 Find Checkpoints (F9)", function()
    print("\n[Webbed Obby] === CHECKPOINT SCAN ===")
    
    local checkpoints = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (
            obj.Name:lower():find("checkpoint") or
            obj.Name:lower():find("check") or
            obj.Name:lower():find("spawn") or
            obj.Name:lower():find("stage")
        ) then
            table.insert(checkpoints, obj)
            print(string.format("[%d] %s - %s", #checkpoints, obj.Name, obj:GetFullName()))
        end
    end
    
    print(string.format("[Webbed Obby] Found %d checkpoints\n", #checkpoints))
end)

-- ===== ANTI-FALL =====
createToggle("🛡️ Anti-Fall (Auto Respawn)", function(enabled)
    if enabled then
        print("[Anti-Fall] Enabled")
        
        local conn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Position.Y < -50 then
                    -- Respawn character
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Health = 0
                        print("[Anti-Fall] Respawned (fell below Y=-50)")
                    end
                end
            end
        end)
        
        table.insert(getgenv().WebbedObby.Connections, conn)
    else
        print("[Anti-Fall] Disabled")
    end
end)

-- ===== NOCLIP =====
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
        
        table.insert(getgenv().WebbedObby.Connections, conn)
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

-- ===== MISC =====
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

print("[Webbed Obby] GUI v1.0 loaded! Press T to toggle.")
print("[Webbed Obby] Fly: Enable toggle, then press E to start flying")
