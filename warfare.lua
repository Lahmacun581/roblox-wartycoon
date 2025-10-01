--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              Warfare Tycoon GUI v3.0                      ║
    ║                  by Lahmacun581                           ║
    ║         Modern UI | Minimize | Clean Destroy             ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[Warfare Tycoon] Loading GUI v3.0...")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Global state
getgenv().WarfareTycoon = getgenv().WarfareTycoon or {
    Version = "3.0",
    Enabled = {},
    Connections = {},
    ESPObjects = {}
}

-- Cleanup function
local function cleanup()
    print("[Warfare Tycoon] Cleaning up...")
    
    -- Destroy GUI
    if getgenv().WarfareTycoon.ScreenGui then
        pcall(function()
            getgenv().WarfareTycoon.ScreenGui:Destroy()
        end)
        getgenv().WarfareTycoon.ScreenGui = nil
    end
    
    -- Disconnect all connections
    if getgenv().WarfareTycoon.Connections then
        for _, conn in pairs(getgenv().WarfareTycoon.Connections) do
            pcall(function()
                conn:Disconnect()
            end)
        end
        getgenv().WarfareTycoon.Connections = {}
    end
    
    -- Clean ESP
    if getgenv().WarfareTycoon.ESPObjects then
        for player, data in pairs(getgenv().WarfareTycoon.ESPObjects) do
            pcall(function()
                if data.billboard then data.billboard:Destroy() end
            end)
        end
        getgenv().WarfareTycoon.ESPObjects = {}
    end
    
    -- Reset enabled states
    getgenv().WarfareTycoon.Enabled = {}
    
    print("[Warfare Tycoon] Cleanup complete!")
end

-- Cleanup old GUI if exists
if PlayerGui:FindFirstChild("WarfareTycoonGUI") then
    cleanup()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WarfareTycoonGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

getgenv().WarfareTycoon.ScreenGui = ScreenGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 500)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

-- Shadow effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 15)

-- Gradient for Title Bar
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 50))
}
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 25)
TitleFix.Position = UDim2.new(0, 0, 1, -25)
TitleFix.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

-- Gradient for Fix
local TitleFixGradient = Instance.new("UIGradient")
TitleFixGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 50))
}
TitleFixGradient.Rotation = 90
TitleFixGradient.Parent = TitleFix

-- Title Icon
local TitleIcon = Instance.new("TextLabel")
TitleIcon.Size = UDim2.new(0, 40, 0, 40)
TitleIcon.Position = UDim2.new(0, 10, 0, 5)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Text = "⚔️"
TitleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleIcon.TextSize = 24
TitleIcon.Font = Enum.Font.GothamBold
TitleIcon.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -200, 1, 0)
TitleText.Position = UDim2.new(0, 55, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Warfare Tycoon v3.0"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 20
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -90, 0, 7.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MinimizeBtn.Text = ""
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = TitleBar

Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 8)

-- Minimize Icon (Line)
local MinimizeIcon = Instance.new("Frame")
MinimizeIcon.Size = UDim2.new(0, 16, 0, 2)
MinimizeIcon.Position = UDim2.new(0.5, -8, 0.5, -1)
MinimizeIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MinimizeIcon.BorderSizePixel = 0
MinimizeIcon.Parent = MinimizeBtn

Instance.new("UICorner", MinimizeIcon).CornerRadius = UDim.new(0, 1)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -50, 0, 7.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
CloseBtn.Text = ""
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- Close Icon (X)
local CloseIcon1 = Instance.new("Frame")
CloseIcon1.Size = UDim2.new(0, 16, 0, 2)
CloseIcon1.Position = UDim2.new(0.5, -8, 0.5, -1)
CloseIcon1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseIcon1.BorderSizePixel = 0
CloseIcon1.Rotation = 45
CloseIcon1.Parent = CloseBtn

Instance.new("UICorner", CloseIcon1).CornerRadius = UDim.new(0, 1)

local CloseIcon2 = Instance.new("Frame")
CloseIcon2.Size = UDim2.new(0, 16, 0, 2)
CloseIcon2.Position = UDim2.new(0.5, -8, 0.5, -1)
CloseIcon2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseIcon2.BorderSizePixel = 0
CloseIcon2.Rotation = -45
CloseIcon2.Parent = CloseBtn

Instance.new("UICorner", CloseIcon2).CornerRadius = UDim.new(0, 1)

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -20, 1, -70)
ContentContainer.Position = UDim2.new(0, 10, 0, 60)
ContentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 12)

-- Welcome Container
local WelcomeContainer = Instance.new("Frame")
WelcomeContainer.Size = UDim2.new(1, -40, 0, 200)
WelcomeContainer.Position = UDim2.new(0, 20, 0, 100)
WelcomeContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
WelcomeContainer.BorderSizePixel = 0
WelcomeContainer.Parent = ContentContainer

Instance.new("UICorner", WelcomeContainer).CornerRadius = UDim.new(0, 12)

-- Gradient for Welcome Container
local WelcomeGradient = Instance.new("UIGradient")
WelcomeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
}
WelcomeGradient.Rotation = 45
WelcomeGradient.Parent = WelcomeContainer

-- Welcome Icon
local WelcomeIcon = Instance.new("TextLabel")
WelcomeIcon.Size = UDim2.new(0, 60, 0, 60)
WelcomeIcon.Position = UDim2.new(0.5, -30, 0, 20)
WelcomeIcon.BackgroundTransparency = 1
WelcomeIcon.Text = "⚔️"
WelcomeIcon.TextColor3 = Color3.fromRGB(255, 70, 70)
WelcomeIcon.TextSize = 48
WelcomeIcon.Font = Enum.Font.GothamBold
WelcomeIcon.Parent = WelcomeContainer

-- Welcome Title
local WelcomeTitle = Instance.new("TextLabel")
WelcomeTitle.Size = UDim2.new(1, -20, 0, 30)
WelcomeTitle.Position = UDim2.new(0, 10, 0, 90)
WelcomeTitle.BackgroundTransparency = 1
WelcomeTitle.Text = "Warfare Tycoon GUI v3.0"
WelcomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeTitle.TextSize = 20
WelcomeTitle.Font = Enum.Font.GothamBold
WelcomeTitle.Parent = WelcomeContainer

-- Welcome Subtitle
local WelcomeSubtitle = Instance.new("TextLabel")
WelcomeSubtitle.Size = UDim2.new(1, -20, 0, 60)
WelcomeSubtitle.Position = UDim2.new(0, 10, 0, 125)
WelcomeSubtitle.BackgroundTransparency = 1
WelcomeSubtitle.Text = "Modern UI Design\nReady for feature development\nPress Right Shift to toggle"
WelcomeSubtitle.TextColor3 = Color3.fromRGB(150, 150, 170)
WelcomeSubtitle.TextSize = 14
WelcomeSubtitle.Font = Enum.Font.Gotham
WelcomeSubtitle.TextWrapped = true
WelcomeSubtitle.Parent = WelcomeContainer

-- Minimize/Maximize functionality
local isMinimized = false

MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Minimize
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 300, 0, 50)
        }):Play()
        
        ContentContainer.Visible = false
        
        -- Change icon to maximize (square)
        MinimizeIcon.Size = UDim2.new(0, 12, 0, 12)
        MinimizeIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
        
        print("[Warfare Tycoon] GUI minimized")
    else
        -- Maximize
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 650, 0, 500)
        }):Play()
        
        task.wait(0.3)
        ContentContainer.Visible = true
        
        -- Change icon back to minimize (line)
        MinimizeIcon.Size = UDim2.new(0, 16, 0, 2)
        MinimizeIcon.Position = UDim2.new(0.5, -8, 0.5, -1)
        
        print("[Warfare Tycoon] GUI maximized")
    end
end)

-- Close functionality
CloseBtn.MouseButton1Click:Connect(function()
    print("[Warfare Tycoon] Closing GUI...")
    
    -- Fade out animation
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    }):Play()
    
    for _, child in pairs(MainFrame:GetDescendants()) do
        if child:IsA("GuiObject") then
            TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1,
                TextTransparency = 1
            }):Play()
        end
    end
    
    task.wait(0.3)
    
    -- Complete cleanup
    cleanup()
end)

-- Hover effects for buttons
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = normalColor
        }):Play()
    end)
end

addHoverEffect(MinimizeBtn, Color3.fromRGB(50, 50, 60), Color3.fromRGB(100, 100, 120))
addHoverEffect(CloseBtn, Color3.fromRGB(50, 50, 60), Color3.fromRGB(220, 60, 60))

-- Keybind to toggle GUI (Right Shift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
        
        if MainFrame.Visible then
            print("[Warfare Tycoon] GUI shown (Right Shift)")
        else
            print("[Warfare Tycoon] GUI hidden (Right Shift)")
        end
    end
end)

print("[Warfare Tycoon] GUI v3.0 loaded successfully!")
print("[Warfare Tycoon] Press Right Shift to toggle GUI")
print("[Warfare Tycoon] Ready for feature development!")
