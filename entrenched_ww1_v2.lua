--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║            Entrenched WW1 GUI v2.0                        ║
    ║   Advanced Silent Aim | Hitbox | ESP | No Recoil        ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[Entrenched WW1 v2] Loading...")

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
getgenv().EntrenchedWW1 = getgenv().EntrenchedWW1 or {
    Version = "2.0",
    Enabled = {},
    Connections = {},
    HitboxState = {},
    ESPObjects = {}
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
MainContainer.Size = UDim2.new(0, 680, 0, 500)
MainContainer.Position = UDim2.new(0.5, -340, 0.5, -250)
MainContainer.BackgroundTransparency = 1
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.Parent = ScreenGui

-- Background
local MainFrame = Instance.new("Frame")
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

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(35, 28, 20)
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
Title.Text = "🪖 ENTRENCHED WW1 v2.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -100, 0, 18)
Subtitle.Position = UDim2.new(0, 50, 0, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Advanced Combat System"
Subtitle.TextColor3 = Color3.fromRGB(180, 140, 100)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 12
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0.5, -20)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
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
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(139, 90, 43)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -25, 0.5, -11), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 55, 40)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -11), BackgroundColor3 = Color3.fromRGB(200, 180, 150)}):Play()
        end
        callback(state)
    end)
    
    return frame
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
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. ": " .. tostring(value)
            callback(value)
        end
    end)
    
    return frame
end

-- ===== ADVANCED HITBOX EXPANDER =====
print("[Hitbox] Initializing...")
getgenv().EntrenchedWW1.HitboxSize = 15
getgenv().EntrenchedWW1.HitboxState = {}

createSlider(Content, "🎯 Hitbox Size", 5, 50, 15, function(value)
    getgenv().EntrenchedWW1.HitboxSize = value
end)

createToggle(Content, "🎯 Hitbox Expander (Head)", function(enabled)
    getgenv().EntrenchedWW1.Enabled.Hitbox = enabled
    print("[Hitbox]", enabled and "ON" or "OFF")
    
    if not enabled then
        local state = getgenv().EntrenchedWW1.HitboxState
        for player, parts in pairs(state) do
            for part, orig in pairs(parts) do
                if typeof(part) == "Instance" and part.Parent then
                    pcall(function()
                        part.Size = orig.Size
                        part.Transparency = orig.Transparency
                        part.CanCollide = orig.CanCollide
                    end)
                end
            end
        end
        getgenv().EntrenchedWW1.HitboxState = {}
    end
end)

local hitboxFrame = 0
RunService.RenderStepped:Connect(function()
    if not getgenv().EntrenchedWW1.Enabled.Hitbox then return end
    
    hitboxFrame = hitboxFrame + 1
    if hitboxFrame % 3 ~= 0 then return end
    
    local size = getgenv().EntrenchedWW1.HitboxSize
    local state = getgenv().EntrenchedWW1.HitboxState
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local head = player.Character:FindFirstChild("Head")
                if head and head:IsA("BasePart") then
                    state[player] = state[player] or {}
                    if not state[player][head] then
                        state[player][head] = {
                            Size = head.Size,
                            Transparency = head.Transparency,
                            CanCollide = head.CanCollide
                        }
                    end
                    
                    task.spawn(function()
                        pcall(function()
                            head.CanCollide = false
                            head.Massless = true
                            head.Size = Vector3.new(size, size, size)
                            head.Transparency = 1
                        end)
                    end)
                end
            end
        end
    end
end)

-- ===== SILENT AIM =====
print("[Silent Aim] Initializing...")
getgenv().EntrenchedWW1.SilentAimFOV = 300
getgenv().EntrenchedWW1.SilentAimTeamCheck = true

createSlider(Content, "🎯 Silent Aim FOV", 50, 1000, 300, function(value)
    getgenv().EntrenchedWW1.SilentAimFOV = value
end)

createToggle(Content, "👥 Silent Aim Team Check", function(enabled)
    getgenv().EntrenchedWW1.SilentAimTeamCheck = enabled
    print("[Silent Aim] Team Check:", enabled and "ON" or "OFF")
end)

createToggle(Content, "🎯 Silent Aim", function(enabled)
    getgenv().EntrenchedWW1.Enabled.SilentAim = enabled
    print("[Silent Aim]", enabled and "ON" or "OFF")
    
    if enabled then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if getgenv().EntrenchedWW1.Enabled.SilentAim and method == "FireServer" then
                local eventName = tostring(self.Name):lower()
                if eventName:find("shoot") or eventName:find("fire") or eventName:find("hit") or eventName:find("damage") or eventName:find("bullet") then
                    local camera = workspace.CurrentCamera
                    if not camera then return oldNamecall(self, ...) end
                    
                    local closestPlayer = nil
                    local closestDist = getgenv().EntrenchedWW1.SilentAimFOV
                    
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            -- Team check
                            if getgenv().EntrenchedWW1.SilentAimTeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
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
                                        closestPlayer = player
                                    end
                                end
                            end
                        end
                    end
                    
                    if closestPlayer and closestPlayer.Character then
                        local head = closestPlayer.Character:FindFirstChild("Head")
                        if head then
                            for i, arg in ipairs(args) do
                                if typeof(arg) == "Vector3" then
                                    args[i] = head.Position
                                    break
                                end
                            end
                        end
                    end
                end
            end
            
            return oldNamecall(self, unpack(args))
        end)
    end
end)

-- ===== AIMBOT =====
print("[Aimbot] Initializing...")
getgenv().EntrenchedWW1.AimbotFOV = 200
getgenv().EntrenchedWW1.AimbotSmooth = 5
getgenv().EntrenchedWW1.AimbotTeamCheck = true

createSlider(Content, "🎯 Aimbot FOV", 50, 1000, 200, function(value)
    getgenv().EntrenchedWW1.AimbotFOV = value
end)

createSlider(Content, "   Aimbot Smooth", 1, 20, 5, function(value)
    getgenv().EntrenchedWW1.AimbotSmooth = value
end)

createToggle(Content, "👥 Aimbot Team Check", function(enabled)
    getgenv().EntrenchedWW1.AimbotTeamCheck = enabled
    print("[Aimbot] Team Check:", enabled and "ON" or "OFF")
end)

createToggle(Content, "🎯 Aimbot (Hold Right Click)", function(enabled)
    getgenv().EntrenchedWW1.Enabled.Aimbot = enabled
    print("[Aimbot]", enabled and "ON" or "OFF")
end)

RunService.RenderStepped:Connect(function()
    if not getgenv().EntrenchedWW1.Enabled.Aimbot then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local closest = nil
    local closestDist = getgenv().EntrenchedWW1.AimbotFOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Team check
            if getgenv().EntrenchedWW1.AimbotTeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
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
            
            local smooth = getgenv().EntrenchedWW1.AimbotSmooth
            camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 / smooth)
        end
    end
end)

-- ===== TRIGGER BOT =====
print("[Trigger Bot] Initializing...")
getgenv().EntrenchedWW1.TriggerBotDelay = 0.1
getgenv().EntrenchedWW1.TriggerBotTeamCheck = true

createSlider(Content, "🎯 Trigger Bot Delay", 0, 500, 100, function(value)
    getgenv().EntrenchedWW1.TriggerBotDelay = value / 1000
end)

createToggle(Content, "👥 Trigger Bot Team Check", function(enabled)
    getgenv().EntrenchedWW1.TriggerBotTeamCheck = enabled
    print("[Trigger Bot] Team Check:", enabled and "ON" or "OFF")
end)

createToggle(Content, "🎯 Trigger Bot (Auto Shoot)", function(enabled)
    getgenv().EntrenchedWW1.Enabled.TriggerBot = enabled
    print("[Trigger Bot]", enabled and "ON" or "OFF")
end)

RunService.RenderStepped:Connect(function()
    if not getgenv().EntrenchedWW1.Enabled.TriggerBot then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local mouse = LocalPlayer:GetMouse()
    if not mouse then return end
    
    local target = mouse.Target
    if not target then return end
    
    local targetModel = target:FindFirstAncestorOfClass("Model")
    if not targetModel then return end
    
    local targetPlayer = Players:GetPlayerFromCharacter(targetModel)
    if not targetPlayer or targetPlayer == LocalPlayer then return end
    
    -- Team check
    if getgenv().EntrenchedWW1.TriggerBotTeamCheck and targetPlayer.Team and LocalPlayer.Team and targetPlayer.Team == LocalPlayer.Team then
        return
    end
    
    local humanoid = targetModel:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    
    task.wait(getgenv().EntrenchedWW1.TriggerBotDelay)
    mouse1click()
end)

-- ===== ONE SHOT KILL =====
print("[One Shot Kill] Initializing...")

createToggle(Content, "💀 One Shot Kill", function(enabled)
    getgenv().EntrenchedWW1.Enabled.OneShotKill = enabled
    print("[One Shot Kill]", enabled and "ON" or "OFF")
    
    if enabled then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if getgenv().EntrenchedWW1.Enabled.OneShotKill and method == "FireServer" then
                local eventName = tostring(self.Name):lower()
                if eventName:find("damage") or eventName:find("hit") or eventName:find("shoot") then
                    -- Modify damage argument
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

-- ===== INFINITE AMMO =====
print("[Infinite Ammo] Initializing...")

createToggle(Content, "∞ Infinite Ammo", function(enabled)
    getgenv().EntrenchedWW1.Enabled.InfiniteAmmo = enabled
    print("[Infinite Ammo]", enabled and "ON" or "OFF")
end)

local ammoFrame = 0
RunService.Heartbeat:Connect(function()
    if not getgenv().EntrenchedWW1.Enabled.InfiniteAmmo then return end
    
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
    
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, backpackTool in ipairs(backpack:GetChildren()) do
            if backpackTool:IsA("Tool") then
                for _, obj in ipairs(backpackTool:GetDescendants()) do
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

-- ===== NO RECOIL & NO SPREAD =====
print("[Weapon] Initializing...")

createToggle(Content, "🔫 No Recoil", function(enabled)
    getgenv().EntrenchedWW1.Enabled.NoRecoil = enabled
    print("[No Recoil]", enabled and "ON" or "OFF")
end)

createToggle(Content, "🎯 No Spread", function(enabled)
    getgenv().EntrenchedWW1.Enabled.NoSpread = enabled
    print("[No Spread]", enabled and "ON" or "OFF")
end)

createToggle(Content, "⚡ Rapid Fire", function(enabled)
    getgenv().EntrenchedWW1.Enabled.RapidFire = enabled
    print("[Rapid Fire]", enabled and "ON" or "OFF")
end)

createToggle(Content, "🔄 Fast Reload", function(enabled)
    getgenv().EntrenchedWW1.Enabled.FastReload = enabled
    print("[Fast Reload]", enabled and "ON" or "OFF")
end)

createToggle(Content, "🚀 Infinite Range", function(enabled)
    getgenv().EntrenchedWW1.Enabled.InfiniteRange = enabled
    print("[Infinite Range]", enabled and "ON" or "OFF")
end)

local weaponFrame = 0
RunService.Heartbeat:Connect(function()
    if not (getgenv().EntrenchedWW1.Enabled.NoRecoil or getgenv().EntrenchedWW1.Enabled.NoSpread or getgenv().EntrenchedWW1.Enabled.RapidFire or getgenv().EntrenchedWW1.Enabled.FastReload or getgenv().EntrenchedWW1.Enabled.InfiniteRange) then return end
    
    weaponFrame = weaponFrame + 1
    if weaponFrame % 3 ~= 0 then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                local name = obj.Name:lower()
                
                if getgenv().EntrenchedWW1.Enabled.NoRecoil then
                    if name:find("recoil") or name:find("kick") then
                        obj.Value = 0
                    end
                end
                
                if getgenv().EntrenchedWW1.Enabled.NoSpread then
                    if name:find("spread") or name:find("accuracy") or name:find("deviation") then
                        obj.Value = 0
                    end
                end
                
                if getgenv().EntrenchedWW1.Enabled.RapidFire then
                    if name:find("firerate") or name:find("fire") or name:find("cooldown") or name:find("delay") then
                        obj.Value = 0.01
                    end
                end
                
                if getgenv().EntrenchedWW1.Enabled.FastReload then
                    if name:find("reload") then
                        obj.Value = 0.1
                    end
                end
                
                if getgenv().EntrenchedWW1.Enabled.InfiniteRange then
                    if name:find("range") or name:find("distance") or name:find("maxdist") then
                        obj.Value = 9999
                    end
                end
            end
        end
    end
end)

-- ===== ESP SYSTEM =====
print("[ESP] Initializing...")

local ESPEnabled = false
local ESPBox = false
local ESPName = false
local ESPHealth = false
local ESPDistance = false
local ESPTeamCheck = true

createToggle(Content, "👁️ Enable ESP", function(enabled)
    ESPEnabled = enabled
    print("[ESP]", enabled and "ON" or "OFF")
    
    if not enabled then
        for _, data in pairs(getgenv().EntrenchedWW1.ESPObjects) do
            for _, drawing in pairs(data.drawings) do
                drawing:Remove()
            end
        end
        getgenv().EntrenchedWW1.ESPObjects = {}
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

createToggle(Content, "👥 ESP Team Check", function(enabled)
    ESPTeamCheck = enabled
    print("[ESP] Team Check:", enabled and "ON" or "OFF")
end)

local function createESP(player)
    if player == LocalPlayer then return end
    if getgenv().EntrenchedWW1.ESPObjects[player] then return end
    
    local data = {drawings = {}}
    
    data.drawings.box = Drawing.new("Square")
    data.drawings.box.Visible = false
    data.drawings.box.Color = Color3.fromRGB(139, 90, 43)
    data.drawings.box.Thickness = 2
    data.drawings.box.Filled = false
    
    data.drawings.name = Drawing.new("Text")
    data.drawings.name.Visible = false
    data.drawings.name.Color = Color3.fromRGB(139, 90, 43)
    data.drawings.name.Text = player.Name
    data.drawings.name.Size = 16
    data.drawings.name.Center = true
    data.drawings.name.Outline = true
    
    data.drawings.health = Drawing.new("Square")
    data.drawings.health.Visible = false
    data.drawings.health.Color = Color3.fromRGB(0, 255, 0)
    data.drawings.health.Filled = true
    
    data.drawings.distance = Drawing.new("Text")
    data.drawings.distance.Visible = false
    data.drawings.distance.Color = Color3.fromRGB(200, 180, 150)
    data.drawings.distance.Size = 14
    data.drawings.distance.Center = true
    data.drawings.distance.Outline = true
    
    getgenv().EntrenchedWW1.ESPObjects[player] = data
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
            
            local data = getgenv().EntrenchedWW1.ESPObjects[player]
            if data and player.Character then
                -- Team check
                if ESPTeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                    for _, drawing in pairs(data.drawings) do
                        drawing.Visible = false
                    end
                    continue
                end
                
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
                            local healthPercent = humanoid.Health / humanoid.MaxHealth
                            data.drawings.health.Size = Vector2.new(4, height * healthPercent)
                            data.drawings.health.Position = Vector2.new(hrpPos.X - width/2 - 8, headPos.Y + height * (1 - healthPercent))
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
    Size = UDim2.new(0, 680, 0, 500)
}):Play()

print("[Entrenched WW1 v2] Loaded!")
print("[Entrenched WW1 v2] Press T to toggle GUI")
