-- Basit Sıfır GUI (Taşınabilir + Kapatma Butonu)
-- Yerleştirme: Bu kodu bir LocalScript içine koy veya executor ile çalıştır.
-- GUI, PlayerGui içine eklenir.

-- Eğer daha önce script çalıştıysa, temizle
if getgenv().WarTycoonGUI then
    if getgenv().WarTycoonGUI.ScreenGui then
        getgenv().WarTycoonGUI.ScreenGui:Destroy()
    end
    if getgenv().WarTycoonGUI.FOVCircle then
        getgenv().WarTycoonGUI.FOVCircle:Remove()
    end
end

-- Yeni GUI ve FOV Circle için tablo
getgenv().WarTycoonGUI = getgenv().WarTycoonGUI or {}

-- FOV Circle (gelişmiş)
local fovCircle = Drawing and Drawing.new and Drawing.new("Circle") or nil
if fovCircle then
    fovCircle.Radius = 150
    fovCircle.Visible = false  -- Başlangıçta kapalı
    fovCircle.Color = Color3.fromRGB(70, 130, 180)
    fovCircle.Thickness = 2
    fovCircle.NumSides = 64  -- Daha yuvarlak
    fovCircle.Filled = false
    fovCircle.Transparency = 0.8
    getgenv().WarTycoonGUI.FOVCircle = fovCircle
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- RemoteEvent bulucu (isim esnekliği ve descendant araması ile)
local function resolveRemoteEventByName(root, name)
    if not root or not name or name == "" then return nil end
    -- Önce doğrudan isim (recursive)
    local direct = root:FindFirstChild(name, true)
    if direct and direct:IsA("RemoteEvent") then return direct end
    -- İsim benzerliği ile tarama (descendants)
    local lname = string.lower(name)
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("RemoteEvent") and string.find(string.lower(d.Name), lname, 1, true) then
            return d
        end
    end
    return nil
end

-- ScreenGui oluştur
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WarTycoonGUI"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 10
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui
-- Global tabloya kaydet
getgenv().WarTycoonGUI.ScreenGui = ScreenGui

-- Ana çerçeve (genişletildi)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 380)          -- optimize edildi
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- tam ortada
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = false
MainFrame.Parent = ScreenGui

-- UI Corner for rounded edges
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Gradient background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
}
Gradient.Rotation = 90
Gradient.Parent = MainFrame

-- Başlık çubuğu (modern)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Active = true
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
}
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "💣 War Tycoon GUI v2.5"  -- emoji eklendi
TitleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0, 200, 0, 15)
Subtitle.Position = UDim2.new(0, 8, 0, 18)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "by Lahmacun581"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.SourceSans
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TitleBar
-- Kapat (X) butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 28, 0, 20)
CloseBtn.Position = UDim2.new(1, -36, 0, 4)
CloseBtn.AnchorPoint = Vector2.new(0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

-- Hover effect
CloseBtn.MouseEnter:Connect(function()
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
end)
CloseBtn.MouseLeave:Connect(function()
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

-- ===== SÜRÜKLEME SİSTEMİ (HEMEN BURADA) =====
do
    local isDragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and isDragging then
            updateInput(input)
        end
    end)
end

-- ===== KAPATMA SİSTEMİ (HEMEN BURADA) =====
CloseBtn.MouseButton1Click:Connect(function()
    print("[DEBUG] Close button clicked!")
    
    -- FOV Circle temizle
    pcall(function()
        if getgenv().WarTycoonGUI and getgenv().WarTycoonGUI.FOVCircle then
            getgenv().WarTycoonGUI.FOVCircle:Remove()
            getgenv().WarTycoonGUI.FOVCircle = nil
        end
    end)
    
    -- ScreenGui yok et
    pcall(function()
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end)
    
    -- Global temizle
    getgenv().WarTycoonGUI = nil
    
    print("[DEBUG] GUI closed successfully!")
end)

-- Sekme butonları (Tabs)
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -16, 0, 35)
TabBar.Position = UDim2.new(0, 8, 0, 43)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8)
TabLayout.Parent = TabBar

-- Sekme içerikleri için container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -16, 1, -90)
ContentContainer.Position = UDim2.new(0, 8, 0, 85)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Tab sistemi
local currentTab = nil
local tabs = {}

local function createTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 100, 0, 30)
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    tabBtn.Text = icon .. " " .. name
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 13
    tabBtn.Parent = TabBar
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.Visible = false
    tabContent.Parent = ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tabContent
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 8)
    contentPadding.PaddingLeft = UDim.new(0, 8)
    contentPadding.PaddingRight = UDim.new(0, 8)
    contentPadding.Parent = tabContent
    
    tabs[name] = {button = tabBtn, content = tabContent}
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
            tab.content.Visible = false
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabContent.Visible = true
        currentTab = name
    end)
    
    return tabContent
end

-- Sekmeleri oluştur
local MainTab = createTab("Main", "💰")
local FarmTab = createTab("Farm", "⚡")
local PlayerTab = createTab("Player", "👤")
local MiscTab = createTab("Misc", "⚙️")

-- İlk sekmeyi aç
tabs["Main"].button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
tabs["Main"].button.TextColor3 = Color3.fromRGB(255, 255, 255)
tabs["Main"].content.Visible = true
currentTab = "Main"

-- ===== MAIN TAB: RemoteEvent Araçları =====
local MainContent = MainTab

    -- RemoteEvent adı girişi
    local NameBox = Instance.new("TextBox")
    NameBox.Size = UDim2.new(1, -16, 0, 35)
    NameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    NameBox.TextColor3 = Color3.fromRGB(255,255,255)
    NameBox.PlaceholderText = "🔍 Event adı (AddMoney, CollectCash...)"
    NameBox.Text = "AddMoney"
    NameBox.Font = Enum.Font.SourceSans
    NameBox.TextSize = 16
    NameBox.Parent = MainContent
    local NameBoxCorner = Instance.new("UICorner")
    NameBoxCorner.CornerRadius = UDim.new(0, 6)
    NameBoxCorner.Parent = NameBox
    
    -- Yenile butonu
    local RefreshBtn = Instance.new("TextButton")
    RefreshBtn.Size = UDim2.new(0.48, -4, 0, 35)
    RefreshBtn.BackgroundColor3 = Color3.fromRGB(70, 120, 70)
    RefreshBtn.TextColor3 = Color3.fromRGB(255,255,255)
    RefreshBtn.Text = "🔄 Yenile"
    RefreshBtn.Font = Enum.Font.SourceSansBold
    RefreshBtn.TextSize = 16
    RefreshBtn.Parent = MainContent
    local RefreshCorner = Instance.new("UICorner")
    RefreshCorner.CornerRadius = UDim.new(0, 6)
    RefreshCorner.Parent = RefreshBtn
    
    -- Listele butonu
    local ListBtn = Instance.new("TextButton")
    ListBtn.Size = UDim2.new(0.48, -4, 0, 35)
    ListBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 140)
    ListBtn.TextColor3 = Color3.fromRGB(255,255,255)
    ListBtn.Text = "📋 Listele"
    ListBtn.Font = Enum.Font.SourceSansBold
    ListBtn.TextSize = 16
    ListBtn.Parent = MainContent
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 6)
    ListCorner.Parent = ListBtn
    
    -- Fire Remote butonu
    local AddMoneyBtn = Instance.new("TextButton")
    AddMoneyBtn.Size = UDim2.new(1, -16, 0, 40)
    AddMoneyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    AddMoneyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AddMoneyBtn.Text = "💥 Fire Remote ($100,000)"
    AddMoneyBtn.Font = Enum.Font.SourceSansBold
    AddMoneyBtn.TextSize = 18
    AddMoneyBtn.Parent = MainContent
    local AddMoneyCorner = Instance.new("UICorner")
    AddMoneyCorner.CornerRadius = UDim.new(0, 8)
    AddMoneyCorner.Parent = AddMoneyBtn
    
-- ===== FARM TAB: Auto Farm Araçları =====
local FarmContent = FarmTab

    -- Spam Collect butonu
    local AddToCollectorBtn = Instance.new("TextButton")
    AddToCollectorBtn.Size = UDim2.new(1, -16, 0, 45)
    AddToCollectorBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    AddToCollectorBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AddToCollectorBtn.Text = "⚡ Spam Collect (Toggle)"
    AddToCollectorBtn.Font = Enum.Font.SourceSansBold
    AddToCollectorBtn.TextSize = 18
    AddToCollectorBtn.Parent = FarmContent
    local AddToCollectorCorner = Instance.new("UICorner")
    AddToCollectorCorner.CornerRadius = UDim.new(0, 8)
    AddToCollectorCorner.Parent = AddToCollectorBtn
    
    -- Auto Collect butonu
    local AutoCollectBtn = Instance.new("TextButton")
    AutoCollectBtn.Size = UDim2.new(1, -16, 0, 40)
    AutoCollectBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    AutoCollectBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AutoCollectBtn.Text = "🧡 Auto Collect All"
    AutoCollectBtn.Font = Enum.Font.SourceSansBold
    AutoCollectBtn.TextSize = 16
    AutoCollectBtn.Parent = FarmContent
    local AutoCollectCorner = Instance.new("UICorner")
    AutoCollectCorner.CornerRadius = UDim.new(0, 6)
    AutoCollectCorner.Parent = AutoCollectBtn
    
    -- Scan Cash/Money butonu
    local ScanBtn = Instance.new("TextButton")
    ScanBtn.Size = UDim2.new(1, -16, 0, 40)
    ScanBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 140)
    ScanBtn.TextColor3 = Color3.fromRGB(255,255,255)
    ScanBtn.Text = "🔍 Scan Cash/Money Events"
    ScanBtn.Font = Enum.Font.SourceSansBold
    ScanBtn.TextSize = 16
    ScanBtn.Parent = FarmContent
    local ScanCorner = Instance.new("UICorner")
    ScanCorner.CornerRadius = UDim.new(0, 6)
    ScanCorner.Parent = ScanBtn
    
    -- Scan Result
    local ScanResult = Instance.new("TextLabel")
    ScanResult.Size = UDim2.new(1, -16, 0, 80)
    ScanResult.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ScanResult.TextColor3 = Color3.fromRGB(200,200,200)
    ScanResult.Text = "Sonuç: Henüz taranmadı"
    ScanResult.Font = Enum.Font.SourceSans
    ScanResult.TextSize = 14
    ScanResult.TextWrapped = true
    ScanResult.TextXAlignment = Enum.TextXAlignment.Left
    ScanResult.TextYAlignment = Enum.TextYAlignment.Top
    ScanResult.Parent = FarmContent
    local ScanResultCorner = Instance.new("UICorner")
    ScanResultCorner.CornerRadius = UDim.new(0, 6)
    ScanResultCorner.Parent = ScanResult
    
-- ===== PLAYER TAB: ESP, FOV, Teleport =====
local PlayerContent = PlayerTab

    -- FOV Toggle
    local FOVToggle = Instance.new("TextButton")
    FOVToggle.Size = UDim2.new(1, -16, 0, 40)
    FOVToggle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    FOVToggle.TextColor3 = Color3.fromRGB(255,255,255)
    FOVToggle.Text = "🎯 FOV Circle: OFF"
    FOVToggle.Font = Enum.Font.SourceSansBold
    FOVToggle.TextSize = 16
    FOVToggle.Parent = PlayerContent
    local FOVCorner = Instance.new("UICorner")
    FOVCorner.CornerRadius = UDim.new(0, 6)
    FOVCorner.Parent = FOVToggle
    
    FOVToggle.MouseButton1Click:Connect(function()
        if fovCircle then
            fovCircle.Visible = not fovCircle.Visible
            FOVToggle.Text = "🎯 FOV Circle: " .. (fovCircle.Visible and "ON" or "OFF")
            FOVToggle.BackgroundColor3 = fovCircle.Visible and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(70, 130, 180)
        end
    end)
    
    -- FOV Size Slider
    local FOVSizeLabel = Instance.new("TextLabel")
    FOVSizeLabel.Size = UDim2.new(1, -16, 0, 25)
    FOVSizeLabel.BackgroundTransparency = 1
    FOVSizeLabel.Text = "📍 FOV Size: 150"
    FOVSizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    FOVSizeLabel.Font = Enum.Font.SourceSansBold
    FOVSizeLabel.TextSize = 14
    FOVSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    FOVSizeLabel.Parent = PlayerContent
    
    local FOVSliderBG = Instance.new("Frame")
    FOVSliderBG.Size = UDim2.new(1, -16, 0, 8)
    FOVSliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    FOVSliderBG.BorderSizePixel = 0
    FOVSliderBG.Parent = PlayerContent
    local FOVSliderBGCorner = Instance.new("UICorner")
    FOVSliderBGCorner.CornerRadius = UDim.new(0, 4)
    FOVSliderBGCorner.Parent = FOVSliderBG
    
    local FOVSliderFill = Instance.new("Frame")
    FOVSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    FOVSliderFill.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    FOVSliderFill.BorderSizePixel = 0
    FOVSliderFill.Parent = FOVSliderBG
    local FOVSliderFillCorner = Instance.new("UICorner")
    FOVSliderFillCorner.CornerRadius = UDim.new(0, 4)
    FOVSliderFillCorner.Parent = FOVSliderFill
    
    local draggingSlider = false
    FOVSliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
        end
    end)
    
    FOVSliderBG.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local sliderPos = FOVSliderBG.AbsolutePosition.X
            local sliderSize = FOVSliderBG.AbsoluteSize.X
            local relativePos = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            
            FOVSliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            
            local fovSize = math.floor(50 + (relativePos * 350)) -- 50-400 arası
            FOVSizeLabel.Text = "📍 FOV Size: " .. fovSize
            
            if fovCircle then
                fovCircle.Radius = fovSize
            end
        end
    end)
    
    -- ESP Toggle
    local ESPEnabled = false
    local ESPObjects = {}
    local ESPToggle = Instance.new("TextButton")
    ESPToggle.Size = UDim2.new(1, -16, 0, 40)
    ESPToggle.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
    ESPToggle.TextColor3 = Color3.fromRGB(255,255,255)
    ESPToggle.Text = "👁️ ESP: OFF"
    ESPToggle.Font = Enum.Font.SourceSansBold
    ESPToggle.TextSize = 16
    ESPToggle.Parent = PlayerContent
    local ESPCorner = Instance.new("UICorner")
    ESPCorner.CornerRadius = UDim.new(0, 6)
    ESPCorner.Parent = ESPToggle
    
    -- ESP Functions
    local function createESP(player)
        if not player.Character or ESPObjects[player] or player == LocalPlayer then return end
        local char = player.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_" .. player.Name
        billboard.Adornee = hrp
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = hrp
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextSize = 16
        nameLabel.Parent = billboard
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextStrokeTransparency = 0.5
        distLabel.Font = Enum.Font.SourceSans
        distLabel.TextSize = 14
        distLabel.Parent = billboard
        
        ESPObjects[player] = {billboard = billboard, distLabel = distLabel}
    end
    
    local function removeESP(player)
        if ESPObjects[player] then
            if ESPObjects[player].billboard then
                ESPObjects[player].billboard:Destroy()
            end
            ESPObjects[player] = nil
        end
    end
    
    local function updateESP()
        if not ESPEnabled then return end
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        local myPos = myChar.HumanoidRootPart.Position
        
        for player, data in pairs(ESPObjects) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
                data.distLabel.Text = string.format("%.0f studs", dist)
            end
        end
    end
    
    ESPToggle.MouseButton1Click:Connect(function()
        ESPEnabled = not ESPEnabled
        ESPToggle.Text = "👁️ ESP: " .. (ESPEnabled and "ON" or "OFF")
        ESPToggle.BackgroundColor3 = ESPEnabled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(200, 100, 50)
        
        if ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
        else
            for player, _ in pairs(ESPObjects) do
                removeESP(player)
            end
        end
    end)
    
    Players.PlayerAdded:Connect(function(player)
        if ESPEnabled and player ~= LocalPlayer then
            task.wait(1)
            createESP(player)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        removeESP(player)
    end)
    
    RunService.Heartbeat:Connect(updateESP)
    
    -- FOV Circle pozisyon güncelleyici
    RunService.RenderStepped:Connect(function()
        if fovCircle and fovCircle.Visible then
            local camera = workspace.CurrentCamera
            local viewportSize = camera.ViewportSize
            fovCircle.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
        end
    end)
    
    -- Teleport List
    local TPList = Instance.new("ScrollingFrame")
    TPList.Size = UDim2.new(1, -16, 0, 120)
    TPList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TPList.BorderSizePixel = 0
    TPList.ScrollBarThickness = 4
    TPList.Parent = PlayerContent
    
    local TPLayout = Instance.new("UIListLayout")
    TPLayout.FillDirection = Enum.FillDirection.Vertical
    TPLayout.Padding = UDim.new(0, 4)
    TPLayout.Parent = TPList
    
    local TPPad = Instance.new("UIPadding")
    TPPad.PaddingTop = UDim.new(0, 6)
    TPPad.PaddingLeft = UDim.new(0, 6)
    TPPad.PaddingRight = UDim.new(0, 6)
    TPPad.Parent = TPList
    
    local TPCorner = Instance.new("UICorner")
    TPCorner.CornerRadius = UDim.new(0, 6)
    TPCorner.Parent = TPList
    
    local function smoothTP(targetPos)
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        
        local startPos = hrp.Position
        local distance = (targetPos - startPos).Magnitude
        local steps = math.ceil(distance / 50)
        
        for i = 1, steps do
            local alpha = i / steps
            local newPos = startPos:Lerp(targetPos, alpha)
            hrp.CFrame = CFrame.new(newPos)
            task.wait(0.05 + math.random() * 0.03)
        end
    end
    
    local function updateTPList()
        for _, child in ipairs(TPList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -12, 0, 28)
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.Text = "🚀 " .. player.Name
                btn.Font = Enum.Font.SourceSans
                btn.TextSize = 14
                btn.Parent = TPList
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        smoothTP(player.Character.HumanoidRootPart.Position)
                        pcall(function()
                            StarterGui:SetCore("SendNotification", {Title = "WarTycoon"; Text = "TP: " .. player.Name; Duration = 2})
                        end)
                    end
                end)
            end
        end
    end
    
    updateTPList()
    Players.PlayerAdded:Connect(function() task.wait(1) updateTPList() end)
    Players.PlayerRemoving:Connect(updateTPList)
    
    -- Refresh TP Button
    local RefreshTPBtn = Instance.new("TextButton")
    RefreshTPBtn.Size = UDim2.new(1, -16, 0, 35)
    RefreshTPBtn.BackgroundColor3 = Color3.fromRGB(70, 120, 70)
    RefreshTPBtn.TextColor3 = Color3.fromRGB(255,255,255)
    RefreshTPBtn.Text = "🔄 Refresh Teleport List"
    RefreshTPBtn.Font = Enum.Font.SourceSansBold
    RefreshTPBtn.TextSize = 14
    RefreshTPBtn.Parent = PlayerContent
    local RefreshTPCorner = Instance.new("UICorner")
    RefreshTPCorner.CornerRadius = UDim.new(0, 6)
    RefreshTPCorner.Parent = RefreshTPBtn
    RefreshTPBtn.MouseButton1Click:Connect(updateTPList)
    
    -- Infinite Ammo Toggle
    local InfAmmoEnabled = false
    local InfAmmoBtn = Instance.new("TextButton")
    InfAmmoBtn.Size = UDim2.new(1, -16, 0, 40)
    InfAmmoBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 100)
    InfAmmoBtn.TextColor3 = Color3.fromRGB(255,255,255)
    InfAmmoBtn.Text = "🔫 Infinite Ammo: OFF"
    InfAmmoBtn.Font = Enum.Font.SourceSansBold
    InfAmmoBtn.TextSize = 16
    InfAmmoBtn.Parent = PlayerContent
    local InfAmmoCorner = Instance.new("UICorner")
    InfAmmoCorner.CornerRadius = UDim.new(0, 6)
    InfAmmoCorner.Parent = InfAmmoBtn
    
    local ammoConnection
    InfAmmoBtn.MouseButton1Click:Connect(function()
        InfAmmoEnabled = not InfAmmoEnabled
        InfAmmoBtn.Text = "🔫 Infinite Ammo: " .. (InfAmmoEnabled and "ON" or "OFF")
        InfAmmoBtn.BackgroundColor3 = InfAmmoEnabled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(200, 50, 100)
        
        if InfAmmoEnabled then
            ammoConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            -- Ammo değerlerini bul ve maksimuma çıkar
                            for _, obj in ipairs(tool:GetDescendants()) do
                                if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                                    local name = string.lower(obj.Name)
                                    if string.find(name, "ammo") or string.find(name, "clip") or string.find(name, "mag") then
                                        obj.Value = 999
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            if ammoConnection then
                ammoConnection:Disconnect()
                ammoConnection = nil
            end
        end
    end)
    
    -- No Recoil Toggle
    local NoRecoilEnabled = false
    local NoRecoilBtn = Instance.new("TextButton")
    NoRecoilBtn.Size = UDim2.new(1, -16, 0, 40)
    NoRecoilBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
    NoRecoilBtn.TextColor3 = Color3.fromRGB(255,255,255)
    NoRecoilBtn.Text = "🎯 No Recoil: OFF"
    NoRecoilBtn.Font = Enum.Font.SourceSansBold
    NoRecoilBtn.TextSize = 16
    NoRecoilBtn.Parent = PlayerContent
    local NoRecoilCorner = Instance.new("UICorner")
    NoRecoilCorner.CornerRadius = UDim.new(0, 6)
    NoRecoilCorner.Parent = NoRecoilBtn
    
    NoRecoilBtn.MouseButton1Click:Connect(function()
        NoRecoilEnabled = not NoRecoilEnabled
        NoRecoilBtn.Text = "🎯 No Recoil: " .. (NoRecoilEnabled and "ON" or "OFF")
        NoRecoilBtn.BackgroundColor3 = NoRecoilEnabled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(150, 100, 200)
        
        if NoRecoilEnabled then
            -- Recoil değerlerini sıfırla
            RunService.Heartbeat:Connect(function()
                if not NoRecoilEnabled then return end
                local char = LocalPlayer.Character
                if char then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            for _, obj in ipairs(tool:GetDescendants()) do
                                if obj:IsA("NumberValue") then
                                    local name = string.lower(obj.Name)
                                    if string.find(name, "recoil") or string.find(name, "spread") then
                                        obj.Value = 0
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    -- Silent Aim Toggle
    local SilentAimEnabled = false
    local SilentAimBtn = Instance.new("TextButton")
    SilentAimBtn.Size = UDim2.new(1, -16, 0, 45)
    SilentAimBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    SilentAimBtn.TextColor3 = Color3.fromRGB(255,255,255)
    SilentAimBtn.Text = "🎯 Silent Aim: OFF"
    SilentAimBtn.Font = Enum.Font.SourceSansBold
    SilentAimBtn.TextSize = 18
    SilentAimBtn.Parent = PlayerContent
    local SilentAimCorner = Instance.new("UICorner")
    SilentAimCorner.CornerRadius = UDim.new(0, 8)
    SilentAimCorner.Parent = SilentAimBtn
    
    local function getClosestPlayer()
        local camera = workspace.CurrentCamera
        local mousePos = UserInputService:GetMouseLocation()
        local closestPlayer = nil
        local shortestDistance = math.huge
        local maxDistance = fovCircle and fovCircle.Radius or 200 -- Fallback
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local char = player.Character
                local head = char:FindFirstChild("Head")
                if head then
                    local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if distance < maxDistance and distance < shortestDistance then
                            shortestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
        
        return closestPlayer
    end
    
    -- Silent Aim hook (sadece bir kez)
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Parantez düzeltildi
        if SilentAimEnabled and method == "FireServer" and (self.Name:find("Fire") or self.Name:find("Shoot") or self.Name:find("Gun")) then
            local target = getClosestPlayer()
            if target and target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head then
                    -- İlk argüman pozisyon ise değiştir
                    if typeof(args[1]) == "Vector3" then
                        args[1] = head.Position
                    elseif typeof(args[2]) == "Vector3" then
                        args[2] = head.Position
                    end
                end
            end
        end
        
        return oldNamecall(self, unpack(args))
    end)
    
    SilentAimBtn.MouseButton1Click:Connect(function()
        SilentAimEnabled = not SilentAimEnabled
        SilentAimBtn.Text = "🎯 Silent Aim: " .. (SilentAimEnabled and "ON" or "OFF")
        SilentAimBtn.BackgroundColor3 = SilentAimEnabled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(200, 50, 50)
        
        if SilentAimEnabled then
            pcall(function()
                StarterGui:SetCore("SendNotification", {Title = "WarTycoon"; Text = "Silent Aim aktif! FOV içindeki hedeflere otomatik nisan alır."; Duration = 3})
            end)
            print("[SILENT AIM] Enabled - FOV Radius: " .. (fovCircle and fovCircle.Radius or "N/A"))
        else
            print("[SILENT AIM] Disabled")
        end
    end)
    
-- ===== MISC TAB: Debug Araçları =====
local MiscContent = MiscTab

    -- List All Values butonu
    local ExplorerBtn = Instance.new("TextButton")
    ExplorerBtn.Size = UDim2.new(1, -16, 0, 40)
    ExplorerBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    ExplorerBtn.TextColor3 = Color3.fromRGB(255,255,255)
    ExplorerBtn.Text = "📊 List All Values (F9)"
    ExplorerBtn.Font = Enum.Font.SourceSansBold
    ExplorerBtn.TextSize = 16
    ExplorerBtn.Parent = MiscContent
    local ExplorerCorner = Instance.new("UICorner")
    ExplorerCorner.CornerRadius = UDim.new(0, 6)
    ExplorerCorner.Parent = ExplorerBtn
    
    -- Gelişmiş Collector bulucu ve manipulator
    local function findAndModifyCollectors()
        local found = 0
        local results = {}
        local workspace = game:GetService("Workspace")
        
        -- 1. Tüm NumberValue ve IntValue'ları tara (geniş tarama)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                local name = string.lower(obj.Name)
                local parentName = obj.Parent and string.lower(obj.Parent.Name) or ""
                
                -- Para ile ilgili anahtar kelimeler
                local keywords = {"cash", "money", "value", "amount", "collect", "currency", "coin", "dollar"}
                local isMatch = false
                
                for _, kw in ipairs(keywords) do
                    if string.find(name, kw) or string.find(parentName, kw) then
                        isMatch = true
                        break
                    end
                end
                
                if isMatch and obj.Value >= 0 then
                    local oldValue = obj.Value
                    obj.Value = obj.Value + 100000
                    found = found + 1
                    local path = obj:GetFullName()
                    table.insert(results, string.format("%s: %d -> %d", path, oldValue, obj.Value))
                    print("[Collector] " .. path .. ": " .. oldValue .. " -> " .. obj.Value)
                end
            end
        end
        
        -- 2. Player'a ait Tycoon/Base ara
        local playerName = LocalPlayer.Name
        for _, obj in ipairs(workspace:GetChildren()) do
            local name = string.lower(obj.Name)
            if string.find(name, "tycoon") or string.find(name, "base") or string.find(name, string.lower(playerName)) then
                -- Bu objenin içindeki tüm value'ları tara
                for _, child in ipairs(obj:GetDescendants()) do
                    if (child:IsA("NumberValue") or child:IsA("IntValue")) and child.Value >= 0 then
                        local oldValue = child.Value
                        child.Value = child.Value + 100000
                        found = found + 1
                        table.insert(results, string.format("%s: %d -> %d", child:GetFullName(), oldValue, child.Value))
                    end
                end
            end
        end
        
        -- Sonuçları göster
        if found > 0 then
            local msg = "Bulundu: " .. found .. " value"
            pcall(function()
                StarterGui:SetCore("SendNotification", {Title = "WarTycoon"; Text = msg; Duration = 2})
            end)
            ScanResult.Text = msg .. "\n" .. table.concat(results, "\n"):sub(1, 200)
        else
            local msg = "Hiçbir value bulunamadı!\nExplorer'da manuel kontrol et"
            pcall(function()
                StarterGui:SetCore("SendNotification", {Title = "WarTycoon"; Text = "Value bulunamadı"; Duration = 2})
            end)
            ScanResult.Text = msg
        end
    end
    
    CollectorBtn.MouseButton1Click:Connect(findAndModifyCollectors)
    
    -- Debug: Tüm Workspace objeleri listele
    local ExplorerBtn = Instance.new("TextButton")
    ExplorerBtn.Size = UDim2.new(0, 140, 0, 28)
    ExplorerBtn.Position = UDim2.new(0, 330, 0, 10)
    ExplorerBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    ExplorerBtn.TextColor3 = Color3.fromRGB(255,255,255)
    ExplorerBtn.Text = "List All Values"
    ExplorerBtn.Font = Enum.Font.SourceSansBold
    ExplorerBtn.TextSize = 14
    ExplorerBtn.Parent = Content
    
    local ExplorerCorner = Instance.new("UICorner")
    ExplorerCorner.CornerRadius = UDim.new(0, 6)
    ExplorerCorner.Parent = ExplorerBtn
    
    local function listAllValues()
        local values = {}
        local workspace = game:GetService("Workspace")
        
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                table.insert(values, string.format("%s = %d", obj:GetFullName(), obj.Value))
            end
        end
        
        if #values > 0 then
            print("=== TÜM VALUES ===")
            for i, v in ipairs(values) do
                print(i .. ". " .. v)
                if i >= 50 then break end -- İlk 50 tane
            end
            ScanResult.Text = "Console'da " .. #values .. " value listelendi\n(F9 aç ve kontrol et)"
        else
            ScanResult.Text = "Hiçbir value bulunamadı"
        end
    end
    
    ExplorerBtn.MouseButton1Click:Connect(listAllValues)
    
    -- Auto Collect: ProximityPrompt tetikleyici
    local AutoCollectBtn = Instance.new("TextButton")
    AutoCollectBtn.Size = UDim2.new(0, 140, 0, 28)
    AutoCollectBtn.Position = UDim2.new(0, 330, 0, 50)
    AutoCollectBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    AutoCollectBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AutoCollectBtn.Text = "Auto Collect All"
    AutoCollectBtn.Font = Enum.Font.SourceSansBold
    AutoCollectBtn.TextSize = 16
    AutoCollectBtn.Parent = Content
    
    local AutoCollectCorner = Instance.new("UICorner")
    AutoCollectCorner.CornerRadius = UDim.new(0, 6)
    AutoCollectCorner.Parent = AutoCollectBtn
    
    local function autoCollect()
        local collected = 0
        local workspace = game:GetService("Workspace")
        
        -- Tüm ProximityPrompt'ları bul ve tetikle
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local parent = obj.Parent
                local parentName = parent and string.lower(parent.Name) or ""
                
                -- Para toplama ile ilgili prompt'ları bul
                if string.find(parentName, "collect") or string.find(parentName, "cash") or string.find(parentName, "money") then
                    -- ProximityPrompt'u tetikle
                    pcall(function()
                        fireproximityprompt(obj)
                        collected = collected + 1
                    end)
                end
            end
        end
        
        -- Tüm BillboardGui'lerdeki "Toplanacak" yazılarını bul
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BillboardGui") then
                for _, child in ipairs(obj:GetDescendants()) do
                    if child:IsA("TextLabel") then
                        local text = string.lower(child.Text)
                        if string.find(text, "toplanacak") or string.find(text, "collect") then
                            -- Parent objesindeki ProximityPrompt'u bul
                            local prompt = obj.Parent:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then
                                pcall(function()
                                    fireproximityprompt(prompt)
                                    collected = collected + 1
                                end)
                            end
                        end
                    end
                end
            end
        end
        
        local msg = collected > 0 and ("Toplanan: " .. collected .. " collector") or "ProximityPrompt bulunamadı"
        pcall(function()
            StarterGui:SetCore("SendNotification", {Title = "WarTycoon"; Text = msg; Duration = 2})
        end)
        ScanResult.Text = msg
    end
    
    AutoCollectBtn.MouseButton1Click:Connect(autoCollect)
    
    -- Collector'a Para Ekle (CollectCashEvent Spam)
    local AddToCollectorBtn = Instance.new("TextButton")
    AddToCollectorBtn.Size = UDim2.new(0, 150, 0, 30)
    AddToCollectorBtn.Position = UDim2.new(0, 170, 0, 10)
    AddToCollectorBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    AddToCollectorBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AddToCollectorBtn.Text = "Spam Collect"
    AddToCollectorBtn.Font = Enum.Font.SourceSansBold
    AddToCollectorBtn.TextSize = 16
    AddToCollectorBtn.Parent = Content
    
    local AddToCollectorCorner = Instance.new("UICorner")
    AddToCollectorCorner.CornerRadius = UDim.new(0, 6)
    AddToCollectorCorner.Parent = AddToCollectorBtn
    
    local spamming = false
    local spamConnection
    
    local function spamCollect()
        if spamming then
            -- Durdur
            spamming = false
            if spamConnection then
                spamConnection:Disconnect()
                spamConnection = nil
            end
            AddToCollectorBtn.Text = "Spam Collect"
            AddToCollectorBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
            return
        end
        
        -- Başlat
        spamming = true
        AddToCollectorBtn.Text = "STOP Spam"
        AddToCollectorBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        
        -- CollectCashEvent'i bul
        local collectEvent = resolveRemoteEventByName(ReplicatedStorage, "CollectCash")
        if not collectEvent then
            collectEvent = resolveRemoteEventByName(ReplicatedStorage, "Collect")
        end
        
        if collectEvent then
            pcall(function()
                StarterGui:SetCore("SendNotification", {Title = "WarTycoon"; Text = "Spam başlatıldı: " .. collectEvent.Name; Duration = 2})
            end)
            
            -- Her 0.1 saniyede bir CollectCashEvent'i çağır
            spamConnection = RunService.Heartbeat:Connect(function()
                if spamming then
                    pcall(function()
                        collectEvent:FireServer()
                    end)
                end
            end)
        else
            spamming = false
            AddToCollectorBtn.Text = "Spam Collect"
            AddToCollectorBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
            pcall(function()
                StarterGui:SetCore("SendNotification", {Title = "WarTycoon"; Text = "CollectCash event bulunamadı!"; Duration = 2})
            end)
        end
    end
    
    AddToCollectorBtn.MouseButton1Click:Connect(spamCollect)
    
    -- AddMoney RemoteEvent adı ayarlanabilir
    local CurrentAddMoneyName = "AddMoney"
    local AddMoneyRemote = resolveRemoteEventByName(ReplicatedStorage, CurrentAddMoneyName)

    -- RemoteEvent adı girişi
    local NameBox = Instance.new("TextBox")
    NameBox.Size = UDim2.new(0, 150, 0, 28)
    NameBox.Position = UDim2.new(0, 10, 0, 50)
    NameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    NameBox.TextColor3 = Color3.fromRGB(255,255,255)
    NameBox.PlaceholderText = "Event adı (AddMoney)"
    NameBox.Text = CurrentAddMoneyName
    NameBox.Font = Enum.Font.SourceSans
    NameBox.TextSize = 16
    NameBox.Parent = Content
    
    local NameBoxCorner = Instance.new("UICorner")
    NameBoxCorner.CornerRadius = UDim.new(0, 6)
    NameBoxCorner.Parent = NameBox

    -- Yenile butonu
    local RefreshBtn = Instance.new("TextButton")
    RefreshBtn.Size = UDim2.new(0, 90, 0, 28)
    RefreshBtn.Position = UDim2.new(0, 170, 0, 50)
    RefreshBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 120)
    RefreshBtn.TextColor3 = Color3.fromRGB(255,255,255)
    RefreshBtn.Text = "Yenile"
    RefreshBtn.Font = Enum.Font.SourceSansBold
    RefreshBtn.TextSize = 16
    RefreshBtn.Parent = Content
    
    local RefreshCorner = Instance.new("UICorner")
    RefreshCorner.CornerRadius = UDim.new(0, 6)
    RefreshCorner.Parent = RefreshBtn

    -- Listele butonu (kandideleri aç/kapat)
    local ListBtn = Instance.new("TextButton")
    ListBtn.Size = UDim2.new(0, 90, 0, 28)
    ListBtn.Position = UDim2.new(0, 270, 0, 50)
    ListBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 40)
    ListBtn.TextColor3 = Color3.fromRGB(255,255,255)
    ListBtn.Text = "Listele"
    ListBtn.Font = Enum.Font.SourceSansBold
    ListBtn.TextSize = 16
    ListBtn.Parent = Content
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 6)
    ListCorner.Parent = ListBtn

    -- Auto-scan: cash/money RemoteEvent'lerini bul
    local ScanBtn = Instance.new("TextButton")
    ScanBtn.Size = UDim2.new(0, 150, 0, 28)
    ScanBtn.Position = UDim2.new(0, 10, 0, 88)
    ScanBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 140)
    ScanBtn.TextColor3 = Color3.fromRGB(255,255,255)
    ScanBtn.Text = "Scan Cash/Money"
    ScanBtn.Font = Enum.Font.SourceSansBold
    ScanBtn.TextSize = 16
    ScanBtn.Parent = Content
    
    local ScanCorner = Instance.new("UICorner")
    ScanCorner.CornerRadius = UDim.new(0, 6)
    ScanCorner.Parent = ScanBtn

    local ScanResult = Instance.new("TextLabel")
    ScanResult.Size = UDim2.new(0, 290, 0, 60)
    ScanResult.Position = UDim2.new(0, 10, 0, 124)
    ScanResult.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ScanResult.TextColor3 = Color3.fromRGB(200,200,200)
    ScanResult.Text = "Sonuç: Henüz taranmadı"
    ScanResult.Font = Enum.Font.SourceSans
    ScanResult.TextSize = 14
    ScanResult.TextWrapped = true
    ScanResult.TextXAlignment = Enum.TextXAlignment.Left
    ScanResult.TextYAlignment = Enum.TextYAlignment.Top
    ScanResult.Parent = Content
    
    local ScanResultCorner = Instance.new("UICorner")
    ScanResultCorner.CornerRadius = UDim.new(0, 6)
    ScanResultCorner.Parent = ScanResult

    local function scanCashMoney()
        local keywords = {"cash", "money", "currency", "coin", "dollar", "add", "give", "collect", "dispenser", "value", "amount"}
        local found = {}
        for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                local lname = string.lower(d.Name)
                for _, kw in ipairs(keywords) do
                    if string.find(lname, kw, 1, true) then
                        table.insert(found, d)
                        break
                    end
                end
            end
        end
        if #found == 0 then
            ScanResult.Text = "Sonuç: Cash/Money RemoteEvent bulunamadı"
        else
            local lines = {"Bulunan RemoteEvent'ler:"}
            for i, ev in ipairs(found) do
                table.insert(lines, i .. ". " .. ev.Name .. " (" .. (ev.Parent and ev.Parent.Name or "?") .. ")")
            end
            ScanResult.Text = table.concat(lines, "\n")
            -- İlk bulunanı otomatik seç
            if found[1] then
                CurrentAddMoneyName = found[1].Name
                AddMoneyRemote = found[1]
                NameBox.Text = found[1].Name
                pcall(function()
                    StarterGui:SetCore("SendNotification", {Title = "WarTycoon"; Text = "Auto-seçildi: " .. found[1].Name; Duration = 2})
                end)
            end
        end
    end

    ScanBtn.MouseButton1Click:Connect(scanCashMoney)

    -- ESP Toggle
    local ESPEnabled = false
    local ESPObjects = {}
    local ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0, 140, 0, 28)
    ESPBtn.Position = UDim2.new(0, 170, 0, 88)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
    ESPBtn.TextColor3 = Color3.fromRGB(255,255,255)
    ESPBtn.Text = "ESP: Kapalı"
    ESPBtn.Font = Enum.Font.SourceSansBold
    ESPBtn.TextSize = 16
    ESPBtn.Parent = Content
    
    local ESPCorner = Instance.new("UICorner")
    ESPCorner.CornerRadius = UDim.new(0, 6)
    ESPCorner.Parent = ESPBtn

    local function createESP(player)
        if not player.Character or ESPObjects[player] then return end
        local char = player.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_" .. player.Name
        billboard.Adornee = hrp
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = hrp
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextSize = 16
        nameLabel.Parent = billboard
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextStrokeTransparency = 0.5
        distLabel.Font = Enum.Font.SourceSans
        distLabel.TextSize = 14
        distLabel.Parent = billboard
        
        ESPObjects[player] = {billboard = billboard, distLabel = distLabel}
    end

    local function removeESP(player)
        if ESPObjects[player] then
            if ESPObjects[player].billboard then
                ESPObjects[player].billboard:Destroy()
            end
            ESPObjects[player] = nil
        end
    end

    local function updateESP()
        if not ESPEnabled then return end
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        local myPos = myChar.HumanoidRootPart.Position
        
        for player, data in pairs(ESPObjects) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
                data.distLabel.Text = string.format("%.0f studs", dist)
            end
        end
    end

    ESPBtn.MouseButton1Click:Connect(function()
        ESPEnabled = not ESPEnabled
        ESPBtn.Text = "ESP: " .. (ESPEnabled and "Çalışıyor" or "Kapalı")
        if ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
        else
            for player, _ in pairs(ESPObjects) do
                removeESP(player)
            end
        end
    end)

    Players.PlayerAdded:Connect(function(player)
        if ESPEnabled and player ~= LocalPlayer then
            task.wait(1)
            createESP(player)
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        removeESP(player)
    end)

    game:GetService("RunService").Heartbeat:Connect(updateESP)

    -- Teleport Panel
    local TPList = Instance.new("ScrollingFrame")
    TPList.Size = UDim2.new(0, 220, 0, 160)
    TPList.Position = UDim2.new(0, 10, 0, 192)
    TPList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TPList.BorderSizePixel = 0
    TPList.ScrollBarThickness = 6
    TPList.Parent = Content

    local TPLayout = Instance.new("UIListLayout")
    TPLayout.FillDirection = Enum.FillDirection.Vertical
    TPLayout.Padding = UDim.new(0, 4)
    TPLayout.Parent = TPList

    local TPPad = Instance.new("UIPadding")
    TPPad.PaddingTop = UDim.new(0, 6)
    TPPad.PaddingLeft = UDim.new(0, 6)
    TPPad.PaddingRight = UDim.new(0, 6)
    TPPad.Parent = TPList

    local TPLabel = Instance.new("TextLabel")
    TPLabel.Size = UDim2.new(0, 220, 0, 20)
    TPLabel.Position = UDim2.new(0, 10, 0, 360)
    TPLabel.BackgroundTransparency = 1
    TPLabel.Text = "Teleport (Tıkla)"
    TPLabel.TextColor3 = Color3.fromRGB(255,255,255)
    TPLabel.Font = Enum.Font.SourceSansBold
    TPLabel.TextSize = 14
    TPLabel.TextXAlignment = Enum.TextXAlignment.Left
    TPLabel.Parent = Content

    local function smoothTP(targetPos)
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        
        -- Bypass: küçük adımlarla TP (anti-cheat bypass)
        local startPos = hrp.Position
        local distance = (targetPos - startPos).Magnitude
        local steps = math.ceil(distance / 50) -- 50 stud adımlar
        
        for i = 1, steps do
            local alpha = i / steps
            local newPos = startPos:Lerp(targetPos, alpha)
            hrp.CFrame = CFrame.new(newPos)
            task.wait(0.05 + math.random() * 0.03) -- randomize timing
        end
    end

    local function updateTPList()
        for _, child in ipairs(TPList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -12, 0, 24)
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.Text = player.Name
                btn.Font = Enum.Font.SourceSans
                btn.TextSize = 14
                btn.Parent = TPList
                
                btn.MouseButton1Click:Connect(function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        smoothTP(player.Character.HumanoidRootPart.Position)
                        pcall(function()
                            StarterGui:SetCore("SendNotification", {Title = "WarTycoon"; Text = "TP: " .. player.Name; Duration = 2})
                        end)
                    end
                end)
            end
        end
    end

    updateTPList()
    Players.PlayerAdded:Connect(function() task.wait(1) updateTPList() end)
    Players.PlayerRemoving:Connect(updateTPList)

    local RefreshTPBtn = Instance.new("TextButton")
    RefreshTPBtn.Size = UDim2.new(0, 100, 0, 24)
    RefreshTPBtn.Position = UDim2.new(0, 240, 0, 192)
    RefreshTPBtn.BackgroundColor3 = Color3.fromRGB(70, 120, 70)
    RefreshTPBtn.TextColor3 = Color3.fromRGB(255,255,255)
    RefreshTPBtn.Text = "Yenile"
    RefreshTPBtn.Font = Enum.Font.SourceSansBold
    RefreshTPBtn.TextSize = 14
    RefreshTPBtn.Parent = Content
    RefreshTPBtn.MouseButton1Click:Connect(updateTPList)

    -- Anti-Detection: Humanoid simülasyonu
    local BypassLabel = Instance.new("TextLabel")
    BypassLabel.Size = UDim2.new(0, 220, 0, 20)
    BypassLabel.Position = UDim2.new(0, 240, 0, 224)
    BypassLabel.BackgroundTransparency = 1
    BypassLabel.Text = "⚠️ Bypass Aktif"
    BypassLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    BypassLabel.Font = Enum.Font.SourceSansBold
    BypassLabel.TextSize = 14
    BypassLabel.TextXAlignment = Enum.TextXAlignment.Left
    BypassLabel.Parent = Content

    -- Bypass: RemoteEvent gönderimlerini randomize et
    local oldFireServer = AddMoneyRemote and AddMoneyRemote.FireServer
    if AddMoneyRemote then
        local function safeFireServer(self, ...)
            task.wait(math.random(10, 50) / 1000) -- 10-50ms gecikme
            return oldFireServer(self, ...)
        end
        -- Hook bypass (opsiyonel)
    end

    -- Bağımsız, sürüklenebilir RemoteEvent listesi (floating panel)
    local DropdownContainer = Instance.new("Frame")
    DropdownContainer.Name = "EventDropdown"
    DropdownContainer.Size = UDim2.new(0, 330, 0, 220)
    DropdownContainer.Position = UDim2.new(0, 50, 0, 80)
    DropdownContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    DropdownContainer.BorderSizePixel = 0
    DropdownContainer.Visible = false
    DropdownContainer.Active = true
    DropdownContainer.ZIndex = 50
    DropdownContainer.Parent = ScreenGui

    local DDTitle = Instance.new("TextLabel")
    DDTitle.Size = UDim2.new(1, -40, 0, 28)
    DDTitle.Position = UDim2.new(0, 8, 0, 0)
    DDTitle.BackgroundTransparency = 1
    DDTitle.Text = "RemoteEvents"
    DDTitle.TextColor3 = Color3.fromRGB(255,255,255)
    DDTitle.TextSize = 16
    DDTitle.Font = Enum.Font.SourceSansBold
    DDTitle.TextXAlignment = Enum.TextXAlignment.Left
    DDTitle.ZIndex = 51
    DDTitle.Parent = DropdownContainer

    local DDClose = Instance.new("TextButton")
    DDClose.Size = UDim2.new(0, 28, 0, 20)
    DDClose.Position = UDim2.new(1, -36, 0, 4)
    DDClose.BackgroundColor3 = Color3.fromRGB(60,60,60)
    DDClose.BorderSizePixel = 0
    DDClose.Text = "X"
    DDClose.TextColor3 = Color3.fromRGB(255, 120, 120)
    DDClose.Font = Enum.Font.SourceSansBold
    DDClose.TextSize = 16
    DDClose.ZIndex = 51
    DDClose.Parent = DropdownContainer

    local DDList = Instance.new("ScrollingFrame")
    DDList.Name = "List"
    DDList.Size = UDim2.new(1, -16, 1, -40)
    DDList.Position = UDim2.new(0, 8, 0, 32)
    DDList.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    DDList.BorderSizePixel = 0
    DDList.ScrollBarThickness = 6
    DDList.ZIndex = 51
    DDList.Parent = DropdownContainer

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Vertical
    Layout.Padding = UDim.new(0, 4)
    Layout.Parent = DDList

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 6)
    Padding.PaddingBottom = UDim.new(0, 6)
    Padding.PaddingLeft = UDim.new(0, 6)
    Padding.PaddingRight = UDim.new(0, 6)
    Padding.Parent = DDList

    -- DropdownContainer sürükleme
    local ddDragging = false
    local ddDragStart = nil
    local ddStartPos = nil
    DDTitle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ddDragging = true
            ddDragStart = input.Position
            ddStartPos = DropdownContainer.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    ddDragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if ddDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - ddDragStart
            DropdownContainer.Position = UDim2.new(
                ddStartPos.X.Scale,
                ddStartPos.X.Offset + delta.X,
                ddStartPos.Y.Scale,
                ddStartPos.Y.Offset + delta.Y
            )
        end
    end)
    DDClose.MouseButton1Click:Connect(function()
        DropdownContainer.Visible = false
    end)

    local function populateDropdown()
        -- temizle
        for _, child in ipairs(DDList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        -- tüm RemoteEvent'leri topla
        local events = {}
        for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                table.insert(events, d)
            end
        end
        table.sort(events, function(a, b) return a.Name:lower() < b.Name:lower() end)
        -- buton ekle
        for _, ev in ipairs(events) do
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, -12, 0, 24)
            item.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            item.TextColor3 = Color3.fromRGB(230,230,230)
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.AutoButtonColor = true
            item.Font = Enum.Font.SourceSans
            item.TextSize = 16
            item.Text = ev.Name .. "  (" .. ev.Parent.Name .. ")"
            item.ZIndex = 52
            item.Parent = DDList
            item.MouseButton1Click:Connect(function()
                NameBox.Text = ev.Name
                DropdownContainer.Visible = false
                -- mevcut isim güncellensin ve hemen çözüm denensin
                CurrentAddMoneyName = ev.Name
                AddMoneyRemote = ev
                pcall(function()
                    StarterGui:SetCore("SendNotification", { Title = "WarTycoon"; Text = "Seçildi: " .. ev.Name; Duration = 2; })
                end)
            end)
        end
    end

    ListBtn.MouseButton1Click:Connect(function()
        if DropdownContainer.Visible then
            DropdownContainer.Visible = false
        else
            populateDropdown()
            DropdownContainer.Visible = true
        end
    end)

    local function refreshAddMoney()
        CurrentAddMoneyName = (NameBox.Text and NameBox.Text ~= "") and NameBox.Text or "AddMoney"
        AddMoneyRemote = resolveRemoteEventByName(ReplicatedStorage, CurrentAddMoneyName)
        local msg
        if AddMoneyRemote then
            msg = ("Event bulundu: %s"):format(AddMoneyRemote:GetFullName())
        else
            msg = ("Event bulunamadı: %s"):format(CurrentAddMoneyName)
        end
        pcall(function()
            StarterGui:SetCore("SendNotification", { Title = "WarTycoon"; Text = msg; Duration = 2; })
        end)
    end

    RefreshBtn.MouseButton1Click:Connect(refreshAddMoney)
    -- ilk deneme
    refreshAddMoney()

    -- Butona tıklanınca para ekle (gerekirse tekrar çöz)
    AddMoneyBtn.MouseButton1Click:Connect(function()
        if not AddMoneyRemote then
            refreshAddMoney()
        end
        if AddMoneyRemote then
            AddMoneyRemote:FireServer(100000)
            pcall(function()
                StarterGui:SetCore("SendNotification", { Title = "WarTycoon"; Text = "+$100000 gönderildi"; Duration = 2; })
            end)
        else
            warn("AddMoney RemoteEvent bulunamadı! Girdi: " .. tostring(CurrentAddMoneyName))
            pcall(function()
                StarterGui:SetCore("SendNotification", { Title = "WarTycoon"; Text = "Event bulunamadı"; Duration = 3; })
            end)
        end
    end)

-- Sürükleme ve kapatma yukarıda tanımlandı (satır 155-230)
