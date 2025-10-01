--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║         Military Warfare Tycoon GUI v3.0                  ║
    ║    Ultimate Remote Scanner + Auto Features + Teleport     ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[Military Warfare Tycoon] Loading GUI v3.0...")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Global state
getgenv().MilitaryWarfare = getgenv().MilitaryWarfare or {
    Version = "3.0",
    AutoCollect = false,
    RemoteSpy = false,
    SpyConnections = {},
    FoundRemotes = {},
    AutoBuy = false
}

-- Cleanup eski GUI
if PlayerGui:FindFirstChild("MilitaryWarfareGUI") then
    PlayerGui:FindFirstChild("MilitaryWarfareGUI"):Destroy()
end

-- Ana ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MilitaryWarfareGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 550)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -275)
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
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 270, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💰 Military Warfare Tycoon v3.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Status Label (header'da)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.Size = UDim2.new(0, 250, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 10)
StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
StatusLabel.Text = "✅ v3.0 Hazır"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = Header

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusLabel

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

-- Tab System
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, 0, 0, 40)
TabBar.Position = UDim2.new(0, 0, 0, 50)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 5)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 10)
TabPadding.PaddingTop = UDim.new(0, 5)
TabPadding.Parent = TabBar

-- Tab Content Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -20, 1, -110)
TabContainer.Position = UDim2.new(0, 10, 0, 100)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Helper: Update Status
local function setStatus(msg, color)
    StatusLabel.Text = msg
    StatusLabel.TextColor3 = color or Color3.fromRGB(200, 200, 200)
end

-- Helper: Create Tab
local currentTab = nil
local function createTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "Tab"
    tabBtn.Size = UDim2.new(0, 130, 0, 30)
    tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tabBtn.Text = icon .. " " .. name
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 13
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = TabBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tabBtn
    
    local content = Instance.new("ScrollingFrame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 6
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Visible = false
    content.Parent = TabContainer
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 10)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = content
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, child in ipairs(TabContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") then child.Visible = false end
        end
        for _, btn in ipairs(TabBar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        content.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = content
    end)
    
    return content
end

-- Helper: Create Button
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.AutoButtonColor = true
    btn.Parent = parent
    
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

-- Helper: Create TextBox
local function createTextBox(parent, placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 40)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    return box
end

-- Helper: Create Toggle
local function createToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Parent = parent
    
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

-- Create Tabs
local ScannerTab = createTab("Scanner", "🔍")
local MoneyTab = createTab("Money", "💰")
local TycoonTab = createTab("Tycoon", "🏭")
local MiscTab = createTab("Misc", "⚙️")

-- Show first tab
ScannerTab.Visible = true
for _, btn in ipairs(TabBar:GetChildren()) do
    if btn:IsA("TextButton") and btn.Name == "ScannerTab" then
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        break
    end
end

-- ===== SCANNER TAB =====
createButton(ScannerTab, "🔎 Tüm Remote'ları Tara (F9)", function()
    getgenv().MilitaryWarfare.FoundRemotes = {}
    setStatus("🔍 Taranıyor...", Color3.fromRGB(255, 200, 100))
    
    local count = 0
    local containers = {ReplicatedStorage, workspace, game:GetService("Players")}
    
    print("\n[MWT] === FULL REMOTE SCAN ===")
    for _, container in ipairs(containers) do
        for _, obj in ipairs(container:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                count = count + 1
                table.insert(getgenv().MilitaryWarfare.FoundRemotes, {obj = obj, path = obj:GetFullName()})
                print(string.format("[%d] %s (%s)", count, obj:GetFullName(), obj.ClassName))
            end
        end
    end
    print(string.format("[MWT] Found %d remotes\n", count))
    setStatus(string.format("✅ %d remote bulundu", count), Color3.fromRGB(100, 255, 100))
end)

createButton(ScannerTab, "💰 Para Remote'larını Filtrele", function()
    local keywords = {
        "cash", "money", "coin", "gold", "currency", "gem", "dollar", "credit", "balance",
        "buy", "purchase", "claim", "reward", "collect", "give", "add", "grant", "earn"
    }
    
    local function isMoneyRelated(name)
        local lower = name:lower()
        for _, kw in ipairs(keywords) do
            if lower:find(kw) then return true end
        end
        return false
    end
    
    local found = 0
    print("\n[MWT] === MONEY REMOTES ===")
    for _, data in ipairs(getgenv().MilitaryWarfare.FoundRemotes) do
        if isMoneyRelated(data.obj.Name) then
            found = found + 1
            print(string.format("[MONEY %d] %s", found, data.path))
        end
    end
    print(string.format("[MWT] %d money remotes\n", found))
    setStatus(string.format("💰 %d para remote'u", found), Color3.fromRGB(100, 255, 100))
end)

createToggle(ScannerTab, "🛰️ Remote Spy (Gerçek Zamanlı)", function(enabled)
    getgenv().MilitaryWarfare.RemoteSpy = enabled
    if enabled then
        print("\n[MWT] Remote Spy: ON")
        setStatus("🛰️ Remote Spy aktif", Color3.fromRGB(100, 255, 100))
        -- Hook all remotes
        for _, data in ipairs(getgenv().MilitaryWarfare.FoundRemotes) do
            local remote = data.obj
            if remote:IsA("RemoteEvent") then
                local conn = remote.OnClientEvent:Connect(function(...)
                    print(string.format("[SPY] %s fired: %s", remote.Name, table.concat({...}, ", ")))
                end)
                table.insert(getgenv().MilitaryWarfare.SpyConnections, conn)
            end
        end
    else
        print("[MWT] Remote Spy: OFF")
        setStatus("✅ v3.0 Hazır", Color3.fromRGB(100, 255, 100))
        for _, conn in ipairs(getgenv().MilitaryWarfare.SpyConnections) do
            conn:Disconnect()
        end
        getgenv().MilitaryWarfare.SpyConnections = {}
    end
end)

-- ===== MONEY TAB =====
local AmountBox = createTextBox(MoneyTab, "Miktar (varsayılan: 10000)")

createButton(MoneyTab, "⚡ Akıllı Para Tara ve Dene", function()
    local amount = tonumber(AmountBox.Text) or 10000
    setStatus("⚡ Deneniyor...", Color3.fromRGB(255, 200, 100))
    
    local keywords = {
        "cash", "money", "coin", "gold", "currency", "gem", "dollar", "credit", "balance",
        "buy", "purchase", "claim", "reward", "collect", "give", "add", "grant", "earn", "payout"
    }
    
    -- 20+ argüman kombinasyonu
    local argCombinations = {
        {amount},
        {amount, "Cash"},
        {amount, "Money"},
        {amount, "Coins"},
        {"Cash", amount},
        {"Money", amount},
        {LocalPlayer, amount},
        {amount, LocalPlayer},
        {amount, true},
        {amount, false},
        {amount, 1},
        {amount, 2},
        {amount, "Player"},
        {LocalPlayer.UserId, amount},
        {amount, LocalPlayer.UserId},
        {amount, "Grant"},
        {amount, "Add"},
        {amount, "Give"},
        {true, amount},
        {},
    }
    
    local function isMoneyRelated(name)
        local lower = name:lower()
        for _, kw in ipairs(keywords) do
            if lower:find(kw) then return true end
        end
        return false
    end
    
    local found, tried = 0, 0
    print(string.format("\n[MWT] === SMART MONEY TEST (Amount: %d) ===", amount))
    
    local containers = {ReplicatedStorage, workspace, game:GetService("Players"), LocalPlayer:FindFirstChild("PlayerGui")}
    for _, container in ipairs(containers) do
        if container then
            for _, obj in ipairs(container:GetDescendants()) do
                if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and isMoneyRelated(obj.Name) then
                    found = found + 1
                    print(string.format("\n[FOUND %d] %s", found, obj:GetFullName()))
                    
                    for i, args in ipairs(argCombinations) do
                        tried = tried + 1
                        pcall(function()
                            if obj:IsA("RemoteEvent") then
                                if #args > 0 then obj:FireServer(table.unpack(args)) else obj:FireServer() end
                            else
                                if #args > 0 then obj:InvokeServer(table.unpack(args)) else obj:InvokeServer() end
                            end
                        end)
                        local argsStr = #args > 0 and table.concat(args, ", ") or "no args"
                        print(string.format("  [%d] %s", i, argsStr))
                        task.wait(0.03)
                    end
                end
            end
        end
    end
    
    print(string.format("\n[MWT] Complete: %d remotes, %d attempts\n", found, tried))
    setStatus(string.format("✅ %d remote, %d deneme", found, tried), Color3.fromRGB(100, 255, 100))
end)

createButton(MoneyTab, "🎯 DataHandler Remote'larını Dene", function()
    local amount = tonumber(AmountBox.Text) or 10000
    setStatus("🎯 DataHandler'lar deneniyor...", Color3.fromRGB(255, 200, 100))
    
    -- Bilinen DataHandler remote'ları
    local dataHandlers = {
        "dataHandler_9341237", "dataHandler_9879030", "dataHandler_5235357",
        "dataHandler_6507857", "dataHandler_7707912", "dataHandler_4133473",
        "dataHandler_6384480", "dataHandler_2772023", "dataHandler_5524901",
        "dataHandler_3722364", "dataHandler_6948897", "dataHandler_8518108",
        "dataHandler_7572474", "dataHandler_3288977", "dataHandler_5305658",
        "dataHandler_5440748", "dataHandler_4692503", "dataHandler_8528604",
        "dataHandler_8519813", "dataHandler_1263870", "DataHandler_8365882",
        "DataHandler_360873", "DataHandler_069801", "DataHandler_865881",
        "DataHandler_369899", "DataHandler_861817", "DataHandler_3GHIJKLMNOPQ4",
        "DataHandler_483946", "DataHandler_739201", "DataHandler_827482",
        "DataHandler_827843", "DataHandler_716259", "DataHandler_710450",
        "DataHandler_702553", "DataHandler_723053", "DataHandler_754754"
    }
    
    -- Argüman kombinasyonları (DataHandler'lar için özel)
    local argSets = {
        {"AddCash", amount},
        {"AddMoney", amount},
        {"GiveCash", amount},
        {"SetCash", amount},
        {"UpdateCash", amount},
        {"Cash", amount},
        {"Money", amount},
        {amount, "Cash"},
        {amount, "Money"},
        {LocalPlayer, "Cash", amount},
        {LocalPlayer, "Money", amount},
        {"Cash", LocalPlayer, amount},
        {LocalPlayer.UserId, amount},
        {amount, LocalPlayer.UserId},
        {"AddCurrency", amount},
        {"Currency", amount},
        {amount},
    }
    
    local tried = 0
    print("\n[MWT] === DATAHANDLER TEST ===")
    print(string.format("[INFO] Amount: %d", amount))
    
    for _, handlerName in ipairs(dataHandlers) do
        local remote = ReplicatedStorage:FindFirstChild(handlerName)
        if not remote then
            remote = ReplicatedStorage.Remotes:FindFirstChild(handlerName)
        end
        
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            print(string.format("\n[FOUND] %s", handlerName))
            
            for i, args in ipairs(argSets) do
                tried = tried + 1
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(table.unpack(args))
                    else
                        remote:InvokeServer(table.unpack(args))
                    end
                end)
                
                local argsStr = table.concat(args, ", ")
                print(string.format("  [%d] %s", i, argsStr))
                task.wait(0.05)
            end
        end
    end
    
    print(string.format("\n[MWT] DataHandler test complete: %d attempts\n", tried))
    setStatus(string.format("✅ %d deneme yapıldı", tried), Color3.fromRGB(100, 255, 100))
end)

createButton(MoneyTab, "💎 CoreSync & PromptCashUI Dene", function()
    local amount = tonumber(AmountBox.Text) or 10000
    setStatus("💎 Özel remote'lar deneniyor...", Color3.fromRGB(255, 200, 100))
    
    local specialRemotes = {
        {name = "CoreSync", args = {
            {amount, "Cash"},
            {"Cash", amount},
            {"AddCash", amount},
            {LocalPlayer, amount},
        }},
        {name = "PromptCashUI", args = {
            {amount},
            {amount, true},
            {true, amount},
        }},
        {name = "StoreRecipient", args = {
            {"Cash", amount},
            {amount, "Cash"},
        }},
        {name = "UpdatePlayerSettings", args = {
            {"Cash", amount},
            {"Money", amount},
        }},
    }
    
    local tried = 0
    print("\n[MWT] === SPECIAL REMOTES TEST ===")
    
    for _, remoteData in ipairs(specialRemotes) do
        local remote = ReplicatedStorage:FindFirstChild(remoteData.name)
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            print(string.format("\n[TESTING] %s", remoteData.name))
            
            for i, args in ipairs(remoteData.args) do
                tried = tried + 1
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(table.unpack(args))
                    else
                        remote:InvokeServer(table.unpack(args))
                    end
                end)
                
                local argsStr = table.concat(args, ", ")
                print(string.format("  [%d] %s", i, argsStr))
                task.wait(0.05)
            end
        end
    end
    
    print(string.format("\n[MWT] Special remotes test: %d attempts\n", tried))
    setStatus(string.format("✅ %d deneme", tried), Color3.fromRGB(100, 255, 100))
end)

local RemotePathBox = createTextBox(MoneyTab, "Remote path (örn: game.ReplicatedStorage.AddCash)")

createButton(MoneyTab, "🚀 Manuel Remote Tetikle", function()
    local path = RemotePathBox.Text
    local amount = tonumber(AmountBox.Text) or 10000
    
    if path == "" then
        setStatus("⚠️ Remote path gir!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local success, err = pcall(function()
        local remote = loadstring("return " .. path)()
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            if remote:IsA("RemoteEvent") then
                remote:FireServer(amount)
            else
                remote:InvokeServer(amount)
            end
            print(string.format("[MANUAL] %s(%d)", path, amount))
            setStatus("✅ Gönderildi", Color3.fromRGB(100, 255, 100))
        else
            setStatus("❌ Remote bulunamadı", Color3.fromRGB(255, 100, 100))
        end
    end)
    
    if not success then
        setStatus("❌ Hata", Color3.fromRGB(255, 100, 100))
        warn(err)
    end
end)

-- ===== TYCOON TAB =====
createToggle(TycoonTab, "🤖 Auto Collect (Tycoon Paraları)", function(enabled)
    getgenv().MilitaryWarfare.AutoCollect = enabled
    if enabled then
        setStatus("🤖 Auto Collect: ON", Color3.fromRGB(100, 255, 100))
        spawn(function()
            while getgenv().MilitaryWarfare.AutoCollect do
                pcall(function()
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("collect") or obj.Name:lower():find("cash") or obj.Name:lower():find("money") then
                            if obj:IsA("Part") or obj:IsA("MeshPart") then
                                local char = LocalPlayer.Character
                                if char and char:FindFirstChild("HumanoidRootPart") then
                                    firetouchinterest(char.HumanoidRootPart, obj, 0)
                                    firetouchinterest(char.HumanoidRootPart, obj, 1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    else
        setStatus("✅ v3.0 Hazır", Color3.fromRGB(100, 255, 100))
    end
end)

createButton(TycoonTab, "🏗️ Tüm Upgrade'leri Tara", function()
    local found = 0
    print("\n[MWT] === UPGRADE SCAN ===")
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("upgrade") or obj.Name:lower():find("buy") or obj.Name:lower():find("button") then
            if obj:IsA("ClickDetector") or obj:IsA("ProximityPrompt") then
                found = found + 1
                print(string.format("[%d] %s", found, obj:GetFullName()))
            end
        end
    end
    print(string.format("[MWT] %d upgrades found\n", found))
    setStatus(string.format("🏗️ %d upgrade bulundu", found), Color3.fromRGB(100, 255, 100))
end)

createToggle(TycoonTab, "⚙️ Auto Buy (Tüm Upgrade'ler)", function(enabled)
    getgenv().MilitaryWarfare.AutoBuy = enabled
    if enabled then
        setStatus("⚙️ Auto Buy: ON", Color3.fromRGB(100, 255, 100))
        spawn(function()
            while getgenv().MilitaryWarfare.AutoBuy do
                pcall(function()
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ClickDetector") then
                            if obj.Parent and (obj.Parent.Name:lower():find("buy") or obj.Parent.Name:lower():find("upgrade")) then
                                fireclickdetector(obj)
                            end
                        elseif obj:IsA("ProximityPrompt") then
                            fireproximityprompt(obj)
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    else
        setStatus("✅ v3.0 Hazır", Color3.fromRGB(100, 255, 100))
    end
end)

-- ===== MISC TAB =====
createButton(MiscTab, "🔄 Rejoin Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

createButton(MiscTab, "🌐 Server Hop (Yeni Server)", function()
    local TeleportService = game:GetService("TeleportService")
    local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    for _, server in ipairs(servers.data) do
        if server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
            break
        end
    end
end)

createButton(MiscTab, "📋 Copy Remote Listesi", function()
    local list = {}
    for i, data in ipairs(getgenv().MilitaryWarfare.FoundRemotes) do
        table.insert(list, data.path)
    end
    setclipboard(table.concat(list, "\n"))
    setStatus("📋 Kopyalandı!", Color3.fromRGB(100, 255, 100))
end)

createButton(MiscTab, "🗑️ GUI'yi Kapat", function()
    ScreenGui:Destroy()
end)

-- Klavye kısayolu
local visible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.T then
        visible = not visible
        MainFrame.Visible = visible
    end
end)

print("[Military Warfare Tycoon] GUI v3.0 loaded! Press T to toggle.")
setStatus("✅ v3.0 Hazır - T ile aç/kapat", Color3.fromRGB(100, 255, 100))
