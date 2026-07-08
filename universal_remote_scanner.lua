--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║            Universal Remote Scanner v1.0                   ║
    ║                by Lahmacun581 / AdorHUB                    ║
    ╚═══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

if getgenv().UniversalRemoteScanner then
    pcall(function()
        if getgenv().UniversalRemoteScanner.ScreenGui then
            getgenv().UniversalRemoteScanner.ScreenGui:Destroy()
        end
        if getgenv().UniversalRemoteScanner.Connections then
            for _, conn in pairs(getgenv().UniversalRemoteScanner.Connections) do
                conn:Disconnect()
            end
        end
    end)
end

getgenv().UniversalRemoteScanner = {
    Connections = {}
}

local function makeUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UniversalRemoteScannerGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    getgenv().UniversalRemoteScanner.ScreenGui = screenGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 460, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -230, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 14)
    mainCorner.Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Universal Remote Scanner"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0, 4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local scanButton = Instance.new("TextButton")
    scanButton.Size = UDim2.new(0, 130, 0, 40)
    scanButton.Position = UDim2.new(0, 14, 0, 54)
    scanButton.BackgroundColor3 = Color3.fromRGB(100, 170, 255)
    scanButton.Text = "Scan Remotes"
    scanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    scanButton.Font = Enum.Font.GothamBold
    scanButton.TextSize = 15
    scanButton.Parent = mainFrame

    local clearButton = Instance.new("TextButton")
    clearButton.Size = UDim2.new(0, 110, 0, 40)
    clearButton.Position = UDim2.new(0, 154, 0, 54)
    clearButton.BackgroundColor3 = Color3.fromRGB(120, 120, 140)
    clearButton.Text = "Clear"
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.Font = Enum.Font.GothamBold
    clearButton.TextSize = 15
    clearButton.Parent = mainFrame

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0, 280, 0, 40)
    infoLabel.Position = UDim2.new(0, 284, 0, 54)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Scan workspace + ReplicatedStorage + Players"
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.TextSize = 14
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextYAlignment = Enum.TextYAlignment.Center
    infoLabel.Parent = mainFrame

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, -28, 1, -118)
    listFrame.Position = UDim2.new(0, 14, 0, 108)
    listFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    listFrame.BorderSizePixel = 0
    listFrame.Parent = mainFrame

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = listFrame

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -12, 1, -12)
    scrollFrame.Position = UDim2.new(0, 6, 0, 6)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.Parent = listFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = scrollFrame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 6)
    padding.PaddingLeft = UDim.new(0, 6)
    padding.PaddingRight = UDim.new(0, 6)
    padding.Parent = scrollFrame

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
    end)

    local function clearResults()
        for _, child in ipairs(scrollFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
    end

    local function addResult(text)
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, 0, 0, 36)
        item.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        item.BorderSizePixel = 0
        item.Parent = scrollFrame

        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 10)
        itemCorner.Parent = item

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(235, 235, 255)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextWrapped = true
        label.Parent = item
    end

    local function isRemoteObject(obj)
        return obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")
    end

    local function scanServices()
        clearResults()
        local found = 0
        local services = {
            workspace,
            game:GetService("ReplicatedStorage"),
            game:GetService("ReplicatedFirst"),
            game:GetService("StarterGui"),
            Players,
        }

        for _, root in ipairs(services) do
            for _, obj in ipairs(root:GetDescendants()) do
                if isRemoteObject(obj) then
                    local path = obj:GetFullName()
                    local kind = obj.ClassName
                    addResult(string.format("[%s] %s", kind, path))
                    found = found + 1
                end
            end
        end

        if found == 0 then
            addResult("No remote events or functions found.")
        else
            addResult(string.format("Found %d remote(s).", found))
        end
    end

    scanButton.MouseButton1Click:Connect(scanServices)
    clearButton.MouseButton1Click:Connect(clearResults)

    return screenGui
end

makeUI()
print("[UniversalRemoteScanner] GUI loaded")
