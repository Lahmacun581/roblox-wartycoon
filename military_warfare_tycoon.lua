--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║         Military Warfare Tycoon GUI v2.0                  ║
    ║         Gelişmiş Remote Scanner + Auto Money Test         ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
]]

print("[Military Warfare Tycoon] Loading GUI v2.0...")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

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
MainFrame.Size = UDim2.new(0, 420, 0, 380)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -190)
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
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💰 Military Warfare Tycoon"
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

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.Size = UDim2.new(1, -10, 0, 30)
StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
StatusLabel.Text = "🔍 Hazır - Remote'ları tara"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 13
StatusLabel.Parent = Content

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusLabel

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

-- Helper: Create TextBox
local function createTextBox(placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 40)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    return box
end

-- Helper: Update Status
local function setStatus(msg, color)
    StatusLabel.Text = msg
    StatusLabel.TextColor3 = color or Color3.fromRGB(200, 200, 200)
end

-- ===== REMOTE SCANNER =====
local foundRemotes = {}

createButton("🔎 Remote'ları Tara (F9'a yazdır)", function()
    foundRemotes = {}
    setStatus("🔍 Taranıyor...", Color3.fromRGB(255, 200, 100))
    
    local count = 0
    local function scan(container, containerName)
        for _, obj in ipairs(container:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                count = count + 1
                local path = obj:GetFullName()
                table.insert(foundRemotes, {obj = obj, path = path})
                print(string.format("[REMOTE %d] %s (%s)", count, path, obj.ClassName))
            end
        end
    end
    
    print("\n[Military Warfare Tycoon] === REMOTE SCAN START ===")
    pcall(function() scan(ReplicatedStorage, "ReplicatedStorage") end)
    pcall(function() scan(workspace, "Workspace") end)
    print(string.format("[Military Warfare Tycoon] === SCAN COMPLETE: %d remotes ===\n", count))
    
    setStatus(string.format("✅ %d remote bulundu (F9)", count), Color3.fromRGB(100, 255, 100))
end)

-- ===== PARA İLE İLGİLİ REMOTE TARA =====
createButton("💰 Para Remote'larını Tara", function()
    setStatus("💰 Para remote'ları aranıyor...", Color3.fromRGB(255, 200, 100))
    
    local moneyKeywords = {
        "cash", "money", "coin", "gold", "currency", "bucks", "gem",
        "buy", "purchase", "claim", "reward", "collect", "give", "add", "grant"
    }
    
    local function isMoneyRelated(name)
        local lower = name:lower()
        for _, kw in ipairs(moneyKeywords) do
            if lower:find(kw) then return true end
        end
        return false
    end
    
    local moneyRemotes = {}
    print("\n[Military Warfare Tycoon] === MONEY REMOTE SCAN ===")
    for i, data in ipairs(foundRemotes) do
        if isMoneyRelated(data.obj.Name) then
            table.insert(moneyRemotes, data)
            print(string.format("[MONEY] %s", data.path))
        end
    end
    print(string.format("[Military Warfare Tycoon] === %d money-related remotes ===\n", #moneyRemotes))
    
    if #moneyRemotes > 0 then
        setStatus(string.format("💰 %d para remote'u bulundu (F9)", #moneyRemotes), Color3.fromRGB(100, 255, 100))
    else
        setStatus("⚠️ Para remote'u bulunamadı", Color3.fromRGB(255, 100, 100))
    end
end)

-- ===== MANUEL REMOTE TETİKLEME =====
local RemotePathBox = createTextBox("Remote path (örn: game.ReplicatedStorage.AddCash)")
local AmountBox = createTextBox("Miktar (örn: 10000)")

createButton("🚀 Remote'u Tetikle (FireServer)", function()
    local path = RemotePathBox.Text
    local amount = tonumber(AmountBox.Text)
    
    if path == "" then
        setStatus("⚠️ Remote path gir!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    if not amount then
        setStatus("⚠️ Geçerli bir miktar gir!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    setStatus("🚀 Gönderiliyor...", Color3.fromRGB(255, 200, 100))
    
    local success, err = pcall(function()
        local remote = loadstring("return " .. path)()
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            if remote:IsA("RemoteEvent") then
                remote:FireServer(amount)
                print(string.format("[FIRE] %s:FireServer(%d)", path, amount))
            else
                local result = remote:InvokeServer(amount)
                print(string.format("[INVOKE] %s:InvokeServer(%d) = %s", path, amount, tostring(result)))
            end
            setStatus(string.format("✅ Gönderildi: %d", amount), Color3.fromRGB(100, 255, 100))
        else
            setStatus("❌ Remote bulunamadı!", Color3.fromRGB(255, 100, 100))
        end
    end)
    
    if not success then
        setStatus("❌ Hata: " .. tostring(err), Color3.fromRGB(255, 100, 100))
        warn("[ERROR]", err)
    end
end)

-- ===== GELİŞMİŞ OTOMATİK PARA EKLEME =====
createButton("⚡ Akıllı Para Tara ve Dene (10000)", function()
    setStatus("🔍 Akıllı tarama başlıyor...", Color3.fromRGB(255, 200, 100))
    
    local amount = 10000
    local tried = 0
    local found = 0
    
    -- Genişletilmiş para anahtar kelimeleri
    local moneyKeywords = {
        "cash", "money", "coin", "gold", "currency", "bucks", "gem", "gems",
        "dollar", "credit", "balance", "wallet", "fund", "payment",
        "buy", "purchase", "claim", "reward", "collect", "give", "add", 
        "grant", "earn", "gain", "receive", "award", "bonus", "payout"
    }
    
    -- Argüman kombinasyonları
    local argCombinations = {
        {amount},                           -- Sadece miktar
        {amount, "Cash"},                   -- Miktar + tip
        {amount, "Money"},
        {"Cash", amount},                   -- Tip + miktar
        {"Money", amount},
        {LocalPlayer, amount},              -- Player + miktar
        {amount, LocalPlayer},
        {amount, true},                     -- Miktar + boolean
        {amount, 1},                        -- Miktar + ID
        {},                                 -- Argümansız (bazı remote'lar sabit değer verir)
    }
    
    local function isMoneyRelated(name)
        local lower = name:lower()
        for _, kw in ipairs(moneyKeywords) do
            if lower:find(kw) then return true end
        end
        return false
    end
    
    local function tryRemote(remote, args)
        local success = pcall(function()
            if remote:IsA("RemoteEvent") then
                if #args > 0 then
                    remote:FireServer(table.unpack(args))
                else
                    remote:FireServer()
                end
            elseif remote:IsA("RemoteFunction") then
                if #args > 0 then
                    remote:InvokeServer(table.unpack(args))
                else
                    remote:InvokeServer()
                end
            end
        end)
        return success
    end
    
    print("\n[Military Warfare Tycoon] === SMART AUTO MONEY TEST ===")
    print(string.format("[INFO] Testing with amount: %d", amount))
    print("[INFO] Scanning all containers...")
    
    -- Tüm container'ları tara
    local containers = {
        ReplicatedStorage,
        workspace,
        game:GetService("Players"),
        LocalPlayer:FindFirstChild("PlayerGui"),
        LocalPlayer:FindFirstChild("Backpack")
    }
    
    for _, container in ipairs(containers) do
        if container then
            for _, obj in ipairs(container:GetDescendants()) do
                if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and isMoneyRelated(obj.Name) then
                    found = found + 1
                    local remotePath = obj:GetFullName()
                    print(string.format("\n[FOUND %d] %s (%s)", found, remotePath, obj.ClassName))
                    
                    -- Her argüman kombinasyonunu dene
                    for i, args in ipairs(argCombinations) do
                        tried = tried + 1
                        local argsStr = "no args"
                        if #args > 0 then
                            local argStrs = {}
                            for _, arg in ipairs(args) do
                                table.insert(argStrs, tostring(arg))
                            end
                            argsStr = table.concat(argStrs, ", ")
                        end
                        
                        local success = tryRemote(obj, args)
                        if success then
                            print(string.format("  [TRY %d] ✓ Args: %s", i, argsStr))
                        else
                            print(string.format("  [TRY %d] ✗ Args: %s", i, argsStr))
                        end
                        
                        task.wait(0.05) -- Spam korumasını atlamak için küçük gecikme
                    end
                end
            end
        end
    end
    
    print(string.format("\n[COMPLETE] Found %d money remotes, tried %d combinations", found, tried))
    
    if found > 0 then
        setStatus(string.format("✅ %d remote bulundu, %d deneme yapıldı", found, tried), Color3.fromRGB(100, 255, 100))
    else
        setStatus("⚠️ Para remote'u bulunamadı", Color3.fromRGB(255, 150, 100))
    end
end)

-- ===== KLAVYE KISAYOLU (T = TOGGLE) =====
local visible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.T then
        visible = not visible
        MainFrame.Visible = visible
    end
end)

print("[Military Warfare Tycoon] GUI loaded! Press T to toggle.")
setStatus("✅ Hazır - T ile aç/kapat", Color3.fromRGB(100, 255, 100))
