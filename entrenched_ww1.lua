--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║            Entrenched WW1 GUI v1.0                        ║
    ║   Silent Aim | No Recoil | No Spread | Hitbox           ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[Entrenched WW1] Loading GUI v1.0...")

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
    warn("[Entrenched WW1] PlayerGui not found!")
    PlayerGui = LocalPlayer
end

-- Global state
getgenv().EntrenchedWW1 = getgenv().EntrenchedWW1 or {
    Version = "1.0",
    Enabled = {},
    Connections = {},
    HitboxCache = {},
    OriginalValues = {}
}

-- Cleanup old GUI
if PlayerGui:FindFirstChild("EntrenchedWW1GUI") then
    PlayerGui:FindFirstChild("EntrenchedWW1GUI"):Destroy()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EntrenchedWW1GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999999
ScreenGui.Parent = PlayerGui

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 680, 0, 500)
MainContainer.Position = UDim2.new(0.5, -340, 0.5, -250)
MainContainer.BackgroundTransparency = 1
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.Parent = ScreenGui

-- Background
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainContainer

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(139, 90, 43)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Gradient
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 25, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 15, 10))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(35, 28, 20)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Color3.fromRGB(160, 110, 60)
HeaderStroke.Thickness = 1
HeaderStroke.Transparency = 0.5
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
Icon.Text = "🪖"
Icon.TextColor3 = Color3.fromRGB(139, 90, 43)
Icon.Font = Enum.Font.GothamBold
Icon.TextSize = 28
Icon.Parent = TitleContainer

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 28)
Title.Position = UDim2.new(0, 50, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "ENTRENCHED WW1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleContainer

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -50, 0, 18)
Subtitle.Position = UDim2.new(0, 50, 0, 34)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "v1.0 | Trench Warfare System"
Subtitle.TextColor3 = Color3.fromRGB(180, 140, 100)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 12
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TitleContainer

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "Minimize"
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -100, 0.5, -20)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 38, 28)
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
Content.ScrollBarImageColor3 = Color3.fromRGB(139, 90, 43)
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
    frame.BackgroundColor3 = Color3.fromRGB(35, 28, 20)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 60, 40)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 220, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 52, 0, 28)
    toggle.Position = UDim2.new(1, -62, 0.5, -14)
    toggle.BackgroundColor3 = Color3.fromRGB(70, 55, 40)
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 22, 0, 22)
    toggleCircle.Position = UDim2.new(0, 3, 0.5, -11)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 180, 150)
    toggleCircle.Parent = toggle
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(139, 90, 43)
            }):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -25, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(70, 55, 40)
            }):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(200, 180, 150)
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
    frame.BackgroundColor3 = Color3.fromRGB(35, 28, 20)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 60, 40)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(230, 220, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 8)
    sliderBg.Position = UDim2.new(0, 15, 1, -18)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 40, 30)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(139, 90, 43)
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

-- ===== ADVANCED SILENT AIM =====
do
    getgenv().EntrenchedWW1.SilentAimFOV = 150
    getgenv().EntrenchedWW1.SilentAimTeamCheck = true
    getgenv().EntrenchedWW1.SilentAimPrediction = true
    
    createSlider(Content, "🎯 Silent Aim FOV", 50, 500, 150, function(value)
        getgenv().EntrenchedWW1.SilentAimFOV = value
    end)
    
    createToggle(Content, "👥 Silent Aim Team Check", function(enabled)
        getgenv().EntrenchedWW1.SilentAimTeamCheck = enabled
        print("[Silent Aim] Team Check:", enabled and "ON" or "OFF")
    end)
    
    createToggle(Content, "🔮 Silent Aim Prediction", function(enabled)
        getgenv().EntrenchedWW1.SilentAimPrediction = enabled
        print("[Silent Aim] Prediction:", enabled and "ON" or "OFF")
    end)
    
    createToggle(Content, "🎯 Silent Aim (Advanced)", function(enabled)
        getgenv().EntrenchedWW1.Enabled.SilentAim = enabled
        print("[Silent Aim]:", enabled and "ON" or "OFF")
        
        if enabled then
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                
                if getgenv().EntrenchedWW1.Enabled.SilentAim and method == "FireServer" then
                    -- Check for common shoot event names
                    local eventName = self.Name:lower()
                    if eventName:find("shoot") or eventName:find("fire") or eventName:find("hit") or eventName:find("damage") then
                        local camera = workspace.CurrentCamera
                        local myChar = LocalPlayer.Character
                        if not myChar then return oldNamecall(self, ...) end
                        
                        local closestPlayer = nil
                        local closestDistance = getgenv().EntrenchedWW1.SilentAimFOV
                        
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                -- Team check
                                if getgenv().EntrenchedWW1.SilentAimTeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                                    continue
                                end
                                
                                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                                local head = player.Character:FindFirstChild("Head")
                                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                                
                                if humanoid and humanoid.Health > 0 and head and hrp then
                                    local targetPos = head.Position
                                    
                                    -- Prediction
                                    if getgenv().EntrenchedWW1.SilentAimPrediction and hrp.AssemblyLinearVelocity then
                                        local velocity = hrp.AssemblyLinearVelocity
                                        local distance = (targetPos - camera.CFrame.Position).Magnitude
                                        local bulletSpeed = 1000 -- Adjust based on game
                                        local travelTime = distance / bulletSpeed
                                        targetPos = targetPos + (velocity * travelTime)
                                    end
                                    
                                    local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
                                    
                                    if onScreen then
                                        local mousePos = UserInputService:GetMouseLocation()
                                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                        
                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = player
                                        end
                                    end
                                end
                            end
                        end
                        
                        if closestPlayer and closestPlayer.Character then
                            local head = closestPlayer.Character:FindFirstChild("Head")
                            local hrp = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
                            
                            if head and hrp then
                                local targetPos = head.Position
                                
                                -- Apply prediction
                                if getgenv().EntrenchedWW1.SilentAimPrediction and hrp.AssemblyLinearVelocity then
                                    local velocity = hrp.AssemblyLinearVelocity
                                    local distance = (targetPos - camera.CFrame.Position).Magnitude
                                    local bulletSpeed = 1000
                                    local travelTime = distance / bulletSpeed
                                    targetPos = targetPos + (velocity * travelTime)
                                end
                                
                                -- Try to find position argument
                                for i, arg in ipairs(args) do
                                    if typeof(arg) == "Vector3" then
                                        args[i] = targetPos
                                        break
                                    end
                                end
                                
                                return oldNamecall(self, unpack(args))
                            end
                        end
                    end
                end
                
                return oldNamecall(self, ...)
            end)
            
            print("[Silent Aim] Advanced hook enabled")
        end
    end)
end

-- ===== NO RECOIL & NO SPREAD =====
do
    local weaponConnection = nil
    local frameCounter = 0
    
    createToggle(Content, "🔫 No Recoil", function(enabled)
        getgenv().EntrenchedWW1.Enabled.NoRecoil = enabled
        print("[No Recoil]:", enabled and "ON" or "OFF")
        
        if enabled and not weaponConnection then
            weaponConnection = RunService.Heartbeat:Connect(function()
                frameCounter = frameCounter + 1
                if frameCounter % 5 ~= 0 then return end
                
                local char = LocalPlayer.Character
                if not char then return end
                
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    for _, obj in ipairs(tool:GetDescendants()) do
                        if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                            local name = obj.Name:lower()
                            
                            -- No Recoil
                            if getgenv().EntrenchedWW1.Enabled.NoRecoil then
                                if name:find("recoil") or name:find("kickback") or name:find("kick") then
                                    if not getgenv().EntrenchedWW1.OriginalValues[obj] then
                                        getgenv().EntrenchedWW1.OriginalValues[obj] = obj.Value
                                    end
                                    obj.Value = 0
                                end
                            end
                            
                            -- No Spread
                            if getgenv().EntrenchedWW1.Enabled.NoSpread then
                                if name:find("spread") or name:find("accuracy") or name:find("deviation") then
                                    if not getgenv().EntrenchedWW1.OriginalValues[obj] then
                                        getgenv().EntrenchedWW1.OriginalValues[obj] = obj.Value
                                    end
                                    obj.Value = 0
                                end
                            end
                        end
                    end
                end
            end)
            
            table.insert(getgenv().EntrenchedWW1.Connections, weaponConnection)
        elseif not enabled and not getgenv().EntrenchedWW1.Enabled.NoSpread then
            if weaponConnection then
                weaponConnection:Disconnect()
                weaponConnection = nil
            end
            
            -- Restore recoil values
            for obj, original in pairs(getgenv().EntrenchedWW1.OriginalValues) do
                if obj and obj.Parent and obj.Name:lower():find("recoil") then
                    obj.Value = original
                    getgenv().EntrenchedWW1.OriginalValues[obj] = nil
                end
            end
        end
    end)
    
    createToggle(Content, "🎯 No Spread", function(enabled)
        getgenv().EntrenchedWW1.Enabled.NoSpread = enabled
        print("[No Spread]:", enabled and "ON" or "OFF")
        
        if enabled and not weaponConnection then
            weaponConnection = RunService.Heartbeat:Connect(function()
                frameCounter = frameCounter + 1
                if frameCounter % 5 ~= 0 then return end
                
                local char = LocalPlayer.Character
                if not char then return end
                
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    for _, obj in ipairs(tool:GetDescendants()) do
                        if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                            local name = obj.Name:lower()
                            
                            -- No Recoil
                            if getgenv().EntrenchedWW1.Enabled.NoRecoil then
                                if name:find("recoil") or name:find("kickback") or name:find("kick") then
                                    if not getgenv().EntrenchedWW1.OriginalValues[obj] then
                                        getgenv().EntrenchedWW1.OriginalValues[obj] = obj.Value
                                    end
                                    obj.Value = 0
                                end
                            end
                            
                            -- No Spread
                            if getgenv().EntrenchedWW1.Enabled.NoSpread then
                                if name:find("spread") or name:find("accuracy") or name:find("deviation") then
                                    if not getgenv().EntrenchedWW1.OriginalValues[obj] then
                                        getgenv().EntrenchedWW1.OriginalValues[obj] = obj.Value
                                    end
                                    obj.Value = 0
                                end
                            end
                        end
                    end
                end
            end)
            
            table.insert(getgenv().EntrenchedWW1.Connections, weaponConnection)
        elseif not enabled and not getgenv().EntrenchedWW1.Enabled.NoRecoil then
            if weaponConnection then
                weaponConnection:Disconnect()
                weaponConnection = nil
            end
            
            -- Restore spread values
            for obj, original in pairs(getgenv().EntrenchedWW1.OriginalValues) do
                if obj and obj.Parent and obj.Name:lower():find("spread") then
                    obj.Value = original
                    getgenv().EntrenchedWW1.OriginalValues[obj] = nil
                end
            end
        end
    end)
end

-- ===== ADVANCED HITBOX EXPANDER (HEAD ONLY) =====
do
    getgenv().EntrenchedWW1.HitboxSize = 10
    getgenv().EntrenchedWW1.HitboxTeamCheck = true
    
    local hitboxConnection = nil
    local frameCounter = 0
    
    createSlider(Content, "🎯 Head Hitbox Size", 5, 50, 10, function(value)
        getgenv().EntrenchedWW1.HitboxSize = value
    end)
    
    createToggle(Content, "👥 Hitbox Team Check", function(enabled)
        getgenv().EntrenchedWW1.HitboxTeamCheck = enabled
        print("[Hitbox] Team Check:", enabled and "ON" or "OFF")
    end)
    
    createToggle(Content, "🎯 Head Hitbox Expander", function(enabled)
        getgenv().EntrenchedWW1.Enabled.Hitbox = enabled
        print("[Hitbox] Head Expander:", enabled and "ON" or "OFF")
        
        if enabled then
            hitboxConnection = RunService.Heartbeat:Connect(function()
                frameCounter = frameCounter + 1
                if frameCounter % 10 ~= 0 then return end -- Every 10 frames
                
                local size = getgenv().EntrenchedWW1.HitboxSize or 10
                local teamCheck = getgenv().EntrenchedWW1.HitboxTeamCheck
                
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        local char = player.Character
                        if char then
                            -- Team check
                            if teamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                                continue
                            end
                            
                            -- Check if character has humanoid (is alive)
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            if not humanoid or humanoid.Health <= 0 then
                                continue
                            end
                            
                            -- Only expand HEAD
                            local head = char:FindFirstChild("Head")
                            if head and head:IsA("BasePart") then
                                -- Cache original
                                if not getgenv().EntrenchedWW1.HitboxCache[head] then
                                    getgenv().EntrenchedWW1.HitboxCache[head] = {
                                        OriginalSize = head.Size,
                                        OriginalTransparency = head.Transparency,
                                        OriginalCanCollide = head.CanCollide
                                    }
                                end
                                
                                -- Expand HEAD hitbox (INVISIBLE)
                                pcall(function()
                                    head.Size = Vector3.new(size, size, size)
                                    head.Transparency = 1 -- Completely invisible
                                    head.CanCollide = false
                                    head.Massless = true
                                end)
                            end
                        end
                    end
                end
            end)
            
            table.insert(getgenv().EntrenchedWW1.Connections, hitboxConnection)
        else
            if hitboxConnection then
                hitboxConnection:Disconnect()
                hitboxConnection = nil
            end
            
            -- Restore all hitboxes
            for part, data in pairs(getgenv().EntrenchedWW1.HitboxCache) do
                if part and part.Parent then
                    pcall(function()
                        part.Size = data.OriginalSize
                        part.Transparency = data.OriginalTransparency
                        part.CanCollide = data.OriginalCanCollide
                    end)
                end
            end
            getgenv().EntrenchedWW1.HitboxCache = {}
            print("[Hitbox] All heads restored")
        end
    end)
end

-- ===== ESP SYSTEM =====
do
    local ESPEnabled = false
    local ESPBoxEnabled = false
    local ESPNameEnabled = false
    local ESPHealthEnabled = false
    local ESPDistanceEnabled = false
    local ESPTracerEnabled = false
    local ESPTeamCheck = true
    
    local ESPColor = Color3.fromRGB(139, 90, 43)
    local ESPTeamColor = Color3.fromRGB(100, 200, 100)
    local ESPObjects = {}
    local ESPConnections = {}
    local frameCount = 0
    
    local function createESP(player)
        if player == LocalPlayer then return end
        if ESPObjects[player] then return end
        
        local espData = {
            player = player,
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
        nameText.Text = player.Name
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
        healthBar.Color = Color3.fromRGB(0, 255, 0)
        healthBar.Thickness = 1
        healthBar.Transparency = 1
        healthBar.Filled = true
        espData.drawings.healthBar = healthBar
        
        -- Distance
        local distanceText = Drawing.new("Text")
        distanceText.Visible = false
        distanceText.Color = Color3.fromRGB(200, 180, 150)
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
        
        ESPObjects[player] = espData
    end
    
    local function removeESP(player)
        local espData = ESPObjects[player]
        if espData then
            for _, drawing in pairs(espData.drawings) do
                drawing:Remove()
            end
            ESPObjects[player] = nil
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
        
        for player, espData in pairs(ESPObjects) do
            if not player or not player.Parent then
                removeESP(player)
                continue
            end
            
            local char = player.Character
            if not char then
                for _, drawing in pairs(espData.drawings) do
                    drawing.Visible = false
                end
                continue
            end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            
            if not hrp or not head or not humanoid then continue end
            
            -- Team Check
            local color = ESPColor
            if ESPTeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
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
                    espData.drawings.box.Color = color
                    espData.drawings.box.Visible = true
                else
                    espData.drawings.box.Visible = false
                    espData.drawings.boxOutline.Visible = false
                end
                
                -- Name ESP
                if ESPNameEnabled then
                    espData.drawings.name.Position = Vector2.new(hrpPos.X, headPos.Y - 20)
                    espData.drawings.name.Color = color
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
                    espData.drawings.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
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
                    espData.drawings.tracer.Color = color
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
    
    -- ESP Toggles
    createToggle(Content, "👁️ Enable ESP", function(enabled)
        ESPEnabled = enabled
        
        if enabled then
            print("[ESP] Enabled")
            
            for _, player in ipairs(Players:GetPlayers()) do
                createESP(player)
            end
            
            local conn = RunService.RenderStepped:Connect(function()
                if ESPEnabled then
                    updateESP()
                end
            end)
            table.insert(ESPConnections, conn)
            
            local conn2 = Players.PlayerAdded:Connect(function(player)
                if ESPEnabled then
                    task.wait(1)
                    createESP(player)
                end
            end)
            table.insert(ESPConnections, conn2)
            
            local conn3 = Players.PlayerRemoving:Connect(function(player)
                removeESP(player)
            end)
            table.insert(ESPConnections, conn3)
        else
            print("[ESP] Disabled")
            
            for _, conn in ipairs(ESPConnections) do
                conn:Disconnect()
            end
            ESPConnections = {}
            
            for player, _ in pairs(ESPObjects) do
                removeESP(player)
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
    
    createToggle(Content, "👥 ESP Team Check", function(enabled)
        ESPTeamCheck = enabled
        print("[ESP] Team Check:", enabled and "ON" or "OFF")
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
            Size = UDim2.new(0, 680, 0, 500)
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
            print("[Entrenched WW1] Mouse: ENABLED")
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            print("[Entrenched WW1] Mouse: DISABLED")
        end
    end
end)

-- Intro animation
MainContainer.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 680, 0, 500)
}):Play()

print("[Entrenched WW1] GUI v1.0 loaded!")
print("[Entrenched WW1] Press T to toggle GUI")
print("[Entrenched WW1] Press U to toggle Mouse")
