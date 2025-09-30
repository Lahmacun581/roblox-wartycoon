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

-- FOV Circle (örnek)
local fovCircle = Drawing and Drawing.new and Drawing.new("Circle") or nil
if fovCircle then
    fovCircle.Radius = 200
    fovCircle.Visible = true
    fovCircle.Color = Color3.fromRGB(212, 34, 255)
    fovCircle.Thickness = 1
    fovCircle.Position = Vector2.new(0, 0)
    -- FOV Circle'ı global kaydet
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

-- Ana çerçeve (boş)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 420)          -- genişletildi
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- tam ortada
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = false
MainFrame.Parent = ScreenGui

-- UI Corner for rounded edges
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Başlık çubuğu (tasarım amaçlı, sürüklemek için kullanışlı)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 28)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TitleBar.BorderSizePixel = 0
TitleBar.Active = true
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "War Tycoon GUI v2.0"  -- başlık eklendi
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.SourceSansSemibold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar
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

-- İçerik alanı (şimdilik boş, sonra ekleyeceğiz)
local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -8, 1, -36)
    Content.Position = UDim2.new(0, 4, 0, 32)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.Parent = MainFrame
    
    -- Para ekleme butonu
    local AddMoneyBtn = Instance.new("TextButton")
    AddMoneyBtn.Size = UDim2.new(0, 150, 0, 30)
    AddMoneyBtn.Position = UDim2.new(0, 10, 0, 10)
    AddMoneyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    AddMoneyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AddMoneyBtn.Text = "Fire Remote"
    AddMoneyBtn.Font = Enum.Font.SourceSansBold
    AddMoneyBtn.TextSize = 16
    AddMoneyBtn.Parent = Content
    
    local AddMoneyCorner = Instance.new("UICorner")
    AddMoneyCorner.CornerRadius = UDim.new(0, 6)
    AddMoneyCorner.Parent = AddMoneyBtn
    
    -- Collector Value Manipulator
    local CollectorBtn = Instance.new("TextButton")
    CollectorBtn.Size = UDim2.new(0, 150, 0, 30)
    CollectorBtn.Position = UDim2.new(0, 170, 0, 10)
    CollectorBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
    CollectorBtn.TextColor3 = Color3.fromRGB(255,255,255)
    CollectorBtn.Text = "Find Collectors"
    CollectorBtn.Font = Enum.Font.SourceSansBold
    CollectorBtn.TextSize = 16
    CollectorBtn.Parent = Content
    
    local CollectorCorner = Instance.new("UICorner")
    CollectorCorner.CornerRadius = UDim.new(0, 6)
    CollectorCorner.Parent = CollectorBtn
    
    -- Collector bulucu ve manipulator
    local function findAndModifyCollectors()
        local found = 0
        local workspace = game:GetService("Workspace")
        
        -- Workspace'deki tüm nesneleri tara
        for _, obj in ipairs(workspace:GetDescendants()) do
            -- "Collector", "Dispenser", "Cash" gibi isimler ara
            local name = string.lower(obj.Name)
            if string.find(name, "collect") or string.find(name, "dispens") or string.find(name, "cash") then
                -- Value, Amount, Money gibi NumberValue'lar ara
                for _, child in ipairs(obj:GetDescendants()) do
                    if child:IsA("NumberValue") or child:IsA("IntValue") then
                        local childName = string.lower(child.Name)
                        if string.find(childName, "value") or string.find(childName, "amount") or string.find(childName, "money") or string.find(childName, "cash") then
                            -- Değeri artır
                            local oldValue = child.Value
                            child.Value = child.Value + 100000
                            found = found + 1
                            print(string.format("[Collector] %s.%s: %d -> %d", obj.Name, child.Name, oldValue, child.Value))
                        end
                    end
                end
            end
        end
        
        local msg = found > 0 and ("Bulundu: " .. found .. " collector") or "Collector bulunamadı"
        pcall(function()
            StarterGui:SetCore("SendNotification", {Title = "WarTycoon"; Text = msg; Duration = 2})
        end)
        ScanResult.Text = msg .. "\n+$100000 eklendi"
    end
    
    CollectorBtn.MouseButton1Click:Connect(findAndModifyCollectors)
    
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

-- GUI'yi sürüklenebilir yapmak (düzeltilmiş)
local dragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Kapatma butonuna tıklanınca GUI'yi yok et
CloseBtn.MouseButton1Click:Connect(function()
    if getgenv().WarTycoonGUI and getgenv().WarTycoonGUI.FOVCircle then
        getgenv().WarTycoonGUI.FOVCircle:Remove()
        getgenv().WarTycoonGUI.FOVCircle = nil
    end
    if ScreenGui and ScreenGui.Parent then
        ScreenGui:Destroy()
    end
end)
-- Optional: ESC ile kapatma (isteğe bağlı)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        if getgenv().WarTycoonGUI and getgenv().WarTycoonGUI.FOVCircle then
            getgenv().WarTycoonGUI.FOVCircle:Remove()
            getgenv().WarTycoonGUI.FOVCircle = nil
        end
        if ScreenGui and ScreenGui.Parent then
            ScreenGui:Destroy()
        end
    end
end)
