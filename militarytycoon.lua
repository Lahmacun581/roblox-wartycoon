--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              Military Tycoon GUI v1.0                     ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Global state
getgenv().MilitaryTycoon = getgenv().MilitaryTycoon or {
    Enabled = {},
    Connections = {}
}

-- Cleanup eski GUI
if PlayerGui:FindFirstChild("MilitaryTycoonGUI") then
    PlayerGui:FindFirstChild("MilitaryTycoonGUI"):Destroy()
end

-- Ana GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MilitaryTycoonGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 550)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 25)
TitleFix.Position = UDim2.new(0, 0, 1, -25)
TitleFix.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚔️ Military Tycoon GUI"
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

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -70)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(50, 150, 50)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.Parent = ContentFrame

-- Auto-update canvas size
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
end)

-- Helper function to create toggle
local function createToggle(text, callback)
    local enabled = false
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    btn.Parent = ContentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = text .. ": " .. (enabled and "ON" or "OFF")
        
        if enabled then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 200, 100)}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
        end
        
        if callback then
            pcall(function()
                callback(enabled)
            end)
        end
    end)
    
    return btn
end

-- Helper function to create button
local function createButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = ContentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
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

-- ===== TYCOON FEATURES =====

-- Auto Collect Cash
getgenv().MilitaryTycoon.Enabled.AutoCash = false
createToggle("💰 Auto Collect Cash", function(enabled)
    getgenv().MilitaryTycoon.Enabled.AutoCash = enabled
end)

RunService.Heartbeat:Connect(function()
    if getgenv().MilitaryTycoon.Enabled.AutoCash then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            
            -- Tycoon'daki cash droppers'ı bul
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local name = string.lower(obj.Name)
                    if string.find(name, "cash") or 
                       string.find(name, "money") or 
                       string.find(name, "collect") or
                       string.find(name, "dollar") then
                        
                        -- Para değilse ve oyuncu değilse
                        if not obj:FindFirstChild("Humanoid") then
                            pcall(function()
                                obj.CFrame = hrp.CFrame
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Claim Tycoon Items
getgenv().MilitaryTycoon.Enabled.AutoClaim = false
createToggle("🏗️ Auto Claim Tycoon Items", function(enabled)
    getgenv().MilitaryTycoon.Enabled.AutoClaim = enabled
end)

local claimFrameCount = 0
RunService.Heartbeat:Connect(function()
    if getgenv().MilitaryTycoon.Enabled.AutoClaim then
        claimFrameCount = claimFrameCount + 1
        if claimFrameCount % 30 ~= 0 then return end
        
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            
            -- Tycoon buttons'ları bul
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ClickDetector") or obj:IsA("ProximityPrompt") then
                    local parent = obj.Parent
                    if parent then
                        local name = string.lower(parent.Name)
                        if string.find(name, "button") or 
                           string.find(name, "buy") or 
                           string.find(name, "purchase") or
                           string.find(name, "claim") then
                            
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
    end
end)

-- ===== PLAYER FEATURES =====

-- Speed Hack
getgenv().MilitaryTycoon.Enabled.Speed = false
createToggle("🏃 Speed Hack (100)", function(enabled)
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

-- Jump Power
getgenv().MilitaryTycoon.Enabled.Jump = false
createToggle("🦘 Super Jump", function(enabled)
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

-- Fly Mode
getgenv().MilitaryTycoon.Enabled.Fly = false
local flyBG, flyBV

createToggle("✈️ Fly Mode", function(enabled)
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
createToggle("👻 Noclip", function(enabled)
    getgenv().MilitaryTycoon.Enabled.Noclip = enabled
    
    if not enabled then
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
createToggle("🛡️ God Mode", function(enabled)
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

-- ===== TELEPORT FEATURES =====

-- Teleport to Tycoon
createButton("🏭 Teleport to My Tycoon", Color3.fromRGB(100, 150, 255), function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Tycoon'unu bul (genelde oyuncu adıyla)
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") then
                local name = string.lower(obj.Name)
                if string.find(name, "tycoon") or string.find(name, "base") then
                    -- Tycoon'un spawn noktasını bul
                    local spawn = obj:FindFirstChild("Spawn") or 
                                 obj:FindFirstChild("SpawnLocation") or
                                 obj:FindFirstChildWhichIsA("SpawnLocation")
                    if spawn then
                        char.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
                        break
                    end
                end
            end
        end
    end
end)

-- Teleport to Mouse
createButton("🎯 Teleport to Mouse", Color3.fromRGB(150, 100, 255), function()
    local mouse = LocalPlayer:GetMouse()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and mouse.Hit then
        char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
    end
end)

-- Reset Character
createButton("🔄 Reset Character", Color3.fromRGB(200, 100, 100), function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = 0
    end
end)

-- Credits
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(1, -10, 0, 60)
creditsLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
creditsLabel.Text = "⚔️ Military Tycoon GUI v1.0\nMade by Lahmacun581"
creditsLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
creditsLabel.TextSize = 14
creditsLabel.Font = Enum.Font.Gotham
creditsLabel.Parent = ContentFrame

local creditsCorner = Instance.new("UICorner")
creditsCorner.CornerRadius = UDim.new(0, 8)
creditsCorner.Parent = creditsLabel

print("[Military Tycoon GUI] Successfully loaded!")
print("[Military Tycoon GUI] All features active!")
print("[Military Tycoon GUI] Version: 1.0")
