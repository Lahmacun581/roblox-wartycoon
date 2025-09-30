-- Royale High Yardımcı GUI (Taşınabilir, FOV, RemoteEvent Aracı)
-- Bu script bir LocalScript/executor ile çalıştırılmalıdır.

-- Varsa eski GUI/FOV'u temizle
if getgenv().RHGUI then
    if getgenv().RHGUI.ScreenGui then
        getgenv().RHGUI.ScreenGui:Destroy()
    end
    if getgenv().RHGUI.FOVCircle then
        getgenv().RHGUI.FOVCircle:Remove()
    end
end
getgenv().RHGUI = {}

-- Servisler
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

-- İsteğe bağlı FOV çemberi (Drawing varsa)
local fovCircle = Drawing and Drawing.new and Drawing.new("Circle") or nil
if fovCircle then
    fovCircle.Radius = 180
    fovCircle.Visible = true
    fovCircle.Color = Color3.fromRGB(255, 105, 180)
    fovCircle.Thickness = 1
    fovCircle.NumSides = 24
    fovCircle.Position = Vector2.new(0, 0)
    getgenv().RHGUI.FOVCircle = fovCircle
end

-- RemoteEvent bulucu (isim ile esnek arama)
local function resolveRemoteEventByName(root, name)
    if not root or not name or name == "" then return nil end
    local direct = root:FindFirstChild(name, true)
    if direct and direct:IsA("RemoteEvent") then return direct end
    local lname = string.lower(name)
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("RemoteEvent") and string.find(string.lower(d.Name), lname, 1, true) then
            return d
        end
    end
    return nil
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoyaleHighGUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 10
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui
getgenv().RHGUI.ScreenGui = ScreenGui

-- Ana pencere
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 230)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -115)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Royale High GUI"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 22)
CloseBtn.Position = UDim2.new(1, -36, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TitleBar

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -8, 1, -38)
Content.Position = UDim2.new(0, 4, 0, 34)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- FOV toggle
local FOVToggle = Instance.new("TextButton")
FOVToggle.Size = UDim2.new(0, 120, 0, 28)
FOVToggle.Position = UDim2.new(0, 10, 0, 8)
FOVToggle.BackgroundColor3 = Color3.fromRGB(80, 50, 120)
FOVToggle.TextColor3 = Color3.fromRGB(255,255,255)
FOVToggle.Text = "FOV: " .. (fovCircle and (fovCircle.Visible and "Açık" or "Kapalı") or "Yok")
FOVToggle.Font = Enum.Font.SourceSansBold
FOVToggle.TextSize = 16
FOVToggle.Parent = Content

FOVToggle.MouseButton1Click:Connect(function()
    if fovCircle then
        fovCircle.Visible = not fovCircle.Visible
        FOVToggle.Text = "FOV: " .. (fovCircle.Visible and "Açık" or "Kapalı")
    else
        pcall(function()
            StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Drawing desteklenmiyor"; Duration = 2})
        end)
    end
end)

-- Spy (namecall hook) - RemoteEvent/Function çağrılarını yakala
local SpyActive = false
local SpyHooked = false
local SpyEntries = {}
local SpySelectedIndex = nil

-- Spy paneli (floating)
local SpyFrame = Instance.new("Frame")
SpyFrame.Name = "RemoteSpy"
SpyFrame.Size = UDim2.new(0, 420, 0, 260)
SpyFrame.Position = UDim2.new(0, 420, 0, 80)
SpyFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
SpyFrame.BorderSizePixel = 0
SpyFrame.Visible = false
SpyFrame.Active = true
SpyFrame.ZIndex = 60
SpyFrame.Parent = ScreenGui

local SpyTitle = Instance.new("TextLabel")
SpyTitle.Size = UDim2.new(1, -80, 0, 28)
SpyTitle.Position = UDim2.new(0, 8, 0, 0)
SpyTitle.BackgroundTransparency = 1
SpyTitle.Text = "Remote Spy"
SpyTitle.TextColor3 = Color3.fromRGB(255,255,255)
SpyTitle.TextSize = 16
SpyTitle.Font = Enum.Font.SourceSansBold
SpyTitle.TextXAlignment = Enum.TextXAlignment.Left
SpyTitle.ZIndex = 61
SpyTitle.Parent = SpyFrame

local SpyClose = Instance.new("TextButton")
SpyClose.Size = UDim2.new(0, 28, 0, 20)
SpyClose.Position = UDim2.new(1, -36, 0, 4)
SpyClose.BackgroundColor3 = Color3.fromRGB(60,60,60)
SpyClose.BorderSizePixel = 0
SpyClose.Text = "X"
SpyClose.TextColor3 = Color3.fromRGB(255,120,120)
SpyClose.Font = Enum.Font.SourceSansBold
SpyClose.TextSize = 16
SpyClose.ZIndex = 61
SpyClose.Parent = SpyFrame

local SpyFilter = Instance.new("TextBox")
SpyFilter.Size = UDim2.new(0, 200, 0, 24)
SpyFilter.Position = UDim2.new(0, 8, 0, 32)
SpyFilter.BackgroundColor3 = Color3.fromRGB(35,35,35)
SpyFilter.TextColor3 = Color3.fromRGB(255,255,255)
SpyFilter.PlaceholderText = "filtre: diamond, gem, currency..."
SpyFilter.Font = Enum.Font.SourceSans
SpyFilter.TextSize = 16
SpyFilter.ZIndex = 61
SpyFilter.Parent = SpyFrame

local SpyToggle = Instance.new("TextButton")
SpyToggle.Size = UDim2.new(0, 90, 0, 24)
SpyToggle.Position = UDim2.new(0, 216, 0, 32)
SpyToggle.BackgroundColor3 = Color3.fromRGB(80, 120, 50)
SpyToggle.TextColor3 = Color3.fromRGB(255,255,255)
SpyToggle.Text = "Spy: Kapalı"
SpyToggle.Font = Enum.Font.SourceSansBold
SpyToggle.TextSize = 16
SpyToggle.ZIndex = 61
SpyToggle.Parent = SpyFrame

local SpyUseBtn = Instance.new("TextButton")
SpyUseBtn.Size = UDim2.new(0, 90, 0, 24)
SpyUseBtn.Position = UDim2.new(0, 314, 0, 32)
SpyUseBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 40)
SpyUseBtn.TextColor3 = Color3.fromRGB(255,255,255)
SpyUseBtn.Text = "Kullan"
SpyUseBtn.Font = Enum.Font.SourceSansBold
SpyUseBtn.TextSize = 16
SpyUseBtn.ZIndex = 61
SpyUseBtn.Parent = SpyFrame

local SpyList = Instance.new("ScrollingFrame")
SpyList.Size = UDim2.new(1, -16, 1, -64)
SpyList.Position = UDim2.new(0, 8, 0, 60)
SpyList.BackgroundColor3 = Color3.fromRGB(24,24,24)
SpyList.BorderSizePixel = 0
SpyList.ScrollBarThickness = 6
SpyList.ZIndex = 61
SpyList.Parent = SpyFrame

local SpyLayout = Instance.new("UIListLayout")
SpyLayout.FillDirection = Enum.FillDirection.Vertical
SpyLayout.Padding = UDim.new(0, 4)
SpyLayout.Parent = SpyList

local SpyPad = Instance.new("UIPadding")
SpyPad.PaddingTop = UDim.new(0, 6)
SpyPad.PaddingBottom = UDim.new(0, 6)
SpyPad.PaddingLeft = UDim.new(0, 6)
SpyPad.PaddingRight = UDim.new(0, 6)
SpyPad.Parent = SpyList

-- Spy panel sürükleme
local spyDragging, spyDragStart, spyStartPos = false, nil, nil
SpyTitle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        spyDragging = true
        spyDragStart = input.Position
        spyStartPos = SpyFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then spyDragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if spyDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - spyDragStart
        SpyFrame.Position = UDim2.new(spyStartPos.X.Scale, spyStartPos.X.Offset + delta.X, spyStartPos.Y.Scale, spyStartPos.Y.Offset + delta.Y)
    end
end)
SpyClose.MouseButton1Click:Connect(function() SpyFrame.Visible = false end)

-- Spy açma butonu ana Content'e
local OpenSpyBtn = Instance.new("TextButton")
OpenSpyBtn.Size = UDim2.new(0, 90, 0, 28)
OpenSpyBtn.Position = UDim2.new(0, 260, 0, 8)
OpenSpyBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 40)
OpenSpyBtn.TextColor3 = Color3.fromRGB(255,255,255)
OpenSpyBtn.Text = "Spy"
OpenSpyBtn.Font = Enum.Font.SourceSansBold
OpenSpyBtn.TextSize = 16
OpenSpyBtn.Parent = Content
OpenSpyBtn.MouseButton1Click:Connect(function()
    -- Ortam desteklemiyorsa bilgilendir
    local hasRaw = (type(getrawmetatable) == "function")
    local hasName = (type(getnamecallmethod) == "function")
    if not hasRaw or not hasName then
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Spy desteklenmiyor (executor)"; Duration = 2}) end)
        return
    end
    SpyFrame.Visible = not SpyFrame.Visible
end)

local function addSpyEntry(obj, method, args)
    local name = obj.Name
    local parentName = obj.Parent and obj.Parent.Name or "?"
    local preview = ""
    if args and #args > 0 then
        local first = args[1]
        preview = typeof(first) .. ": " .. tostring(first)
    end
    local line = string.format("[%s] %s (%s)  |  %s", method, name, parentName, preview)
    table.insert(SpyEntries, {object = obj, method = method, text = line, args = args})
    -- filtre uygula
    local filter = string.lower(SpyFilter.Text or "")
    if filter == "" or string.find(string.lower(line), filter, 1, true) then
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(1, -12, 0, 22)
        item.BackgroundColor3 = Color3.fromRGB(35,35,35)
        item.TextColor3 = Color3.fromRGB(230,230,230)
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.Font = Enum.Font.SourceSans
        item.TextSize = 14
        item.ZIndex = 62
        item.Text = line
        item.Parent = SpyList
        item.MouseButton1Click:Connect(function()
            if obj and obj:IsA("RemoteEvent") then
                SelectedRemote = obj
                CurrentRemoteName = obj.Name
                NameBox.Text = obj.Name
                SpySelectedIndex = #SpyEntries
                pcall(function()
                    StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Seçildi: " .. obj.Name; Duration = 2})
                end)
            end
        end)
    end
end

local function rebuildSpyList()
    for _, c in ipairs(SpyList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local filter = string.lower(SpyFilter.Text or "")
    for _, e in ipairs(SpyEntries) do
        if filter == "" or string.find(string.lower(e.text), filter, 1, true) then
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, -12, 0, 22)
            item.BackgroundColor3 = Color3.fromRGB(35,35,35)
            item.TextColor3 = Color3.fromRGB(230,230,230)
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.Font = Enum.Font.SourceSans
            item.TextSize = 14
            item.ZIndex = 62
            item.Text = e.text
            item.Parent = SpyList
            local obj = e.object
            local idx = _
            item.MouseButton1Click:Connect(function()
                if obj and obj:IsA("RemoteEvent") then
                    SelectedRemote = obj
                    CurrentRemoteName = obj.Name
                    NameBox.Text = obj.Name
                    SpySelectedIndex = idx
                    pcall(function()
                        StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Seçildi: " .. obj.Name; Duration = 2})
                    end)
                end
            end)
        end
    end
end
SpyFilter:GetPropertyChangedSignal("Text"):Connect(rebuildSpyList)
SpyUseBtn.MouseButton1Click:Connect(rebuildSpyList)

-- Spy: yakalanan çağrıyı aynı argümanlarla yeniden çalıştır
local ReplayBtn = Instance.new("TextButton")
ReplayBtn.Size = UDim2.new(0, 90, 0, 24)
ReplayBtn.Position = UDim2.new(0, 314, 0, 4)
ReplayBtn.BackgroundColor3 = Color3.fromRGB(70, 100, 160)
ReplayBtn.TextColor3 = Color3.fromRGB(255,255,255)
ReplayBtn.Text = "Replay"
ReplayBtn.Font = Enum.Font.SourceSansBold
ReplayBtn.TextSize = 16
ReplayBtn.ZIndex = 61
ReplayBtn.Parent = SpyFrame
ReplayBtn.MouseButton1Click:Connect(function()
    local idx = SpySelectedIndex
    if not idx or not SpyEntries[idx] then
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Seçim yok"; Duration = 2}) end)
        return
    end
    local entry = SpyEntries[idx]
    local obj = entry.object
    if not obj or not obj:IsDescendantOf(game) then
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Geçersiz remote"; Duration = 2}) end)
        return
    end
    if entry.method == "FireServer" and obj:IsA("RemoteEvent") then
        pcall(function() obj:FireServer(unpack(entry.args or {})) end)
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Replay gönderildi"; Duration = 2}) end)
    elseif entry.method == "InvokeServer" and obj:IsA("RemoteFunction") then
        pcall(function() obj:InvokeServer(unpack(entry.args or {})) end)
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Replay invoke"; Duration = 2}) end)
    else
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Uyumsuz tür"; Duration = 2}) end)
    end
end)

-- Spy: hazır filtre butonları
local function makeFilterBtn(text, x)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 90, 0, 20)
    b.Position = UDim2.new(0, x, 0, 4)
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Text = text
    b.Font = Enum.Font.SourceSans
    b.TextSize = 14
    b.ZIndex = 61
    b.Parent = SpyFrame
    b.MouseButton1Click:Connect(function()
        SpyFilter.Text = string.lower(text)
        rebuildSpyList()
    end)
    return b
end
makeFilterBtn("diamonds", 8)
makeFilterBtn("gem", 102)
makeFilterBtn("currency", 196)
makeFilterBtn("reward", 290)
local ClearFilter = Instance.new("TextButton")
ClearFilter.Size = UDim2.new(0, 90, 0, 20)
ClearFilter.Position = UDim2.new(0, 384, 0, 4)
ClearFilter.BackgroundColor3 = Color3.fromRGB(80,40,40)
ClearFilter.TextColor3 = Color3.fromRGB(255,255,255)
ClearFilter.Text = "clear"
ClearFilter.Font = Enum.Font.SourceSans
ClearFilter.TextSize = 14
ClearFilter.ZIndex = 61
ClearFilter.Parent = SpyFrame
ClearFilter.MouseButton1Click:Connect(function()
    SpyFilter.Text = ""
    rebuildSpyList()
end)

local function ensureHook()
    if SpyHooked then return true end
    local ok, mt = pcall(function() return getrawmetatable(game) end)
    local ok2, getn = pcall(function() return getnamecallmethod end)
    if not ok or not ok2 or not mt then return false end
    local setro = setreadonly or make_writeable or function() end
    local old
    pcall(function()
        setro(mt, false)
        old = mt.__namecall
        mt.__namecall = function(self, ...)
            local method
            pcall(function() method = getnamecallmethod() end)
            local args = {...}
            if SpyActive and (method == "FireServer" or method == "InvokeServer") and (typeof(self) == "Instance") and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
                pcall(function() addSpyEntry(self, method, args) end)
            end
            return old(self, ...)
        end
        setro(mt, true)
    end)
    SpyHooked = old ~= nil
    return SpyHooked
end

SpyToggle.MouseButton1Click:Connect(function()
    if not SpyHooked then
        if not ensureHook() then
            pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Spy desteklenmiyor"; Duration = 2}) end)
            return
        end
    end
    SpyActive = not SpyActive
    SpyToggle.Text = "Spy: " .. (SpyActive and "Açık" or "Kapalı")
end)
-- RemoteEvent araçları
local CurrentRemoteName = "AddDiamonds" -- örnek isim, değiştirilebilir
local SelectedRemote = resolveRemoteEventByName(ReplicatedStorage, CurrentRemoteName)

local NameBox = Instance.new("TextBox")
NameBox.Size = UDim2.new(0, 170, 0, 28)
NameBox.Position = UDim2.new(0, 10, 0, 44)
NameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NameBox.TextColor3 = Color3.fromRGB(255,255,255)
NameBox.PlaceholderText = "Remote adı (örn. AddDiamonds)"
NameBox.Text = CurrentRemoteName
NameBox.Font = Enum.Font.SourceSans
NameBox.TextSize = 16
NameBox.Parent = Content

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0, 90, 0, 28)
RefreshBtn.Position = UDim2.new(0, 190, 0, 44)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(70, 120, 70)
RefreshBtn.TextColor3 = Color3.fromRGB(255,255,255)
RefreshBtn.Text = "Yenile"
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 16
RefreshBtn.Parent = Content

local ListBtn = Instance.new("TextButton")
ListBtn.Size = UDim2.new(0, 90, 0, 28)
ListBtn.Position = UDim2.new(0, 290, 0, 44)
ListBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 40)
ListBtn.TextColor3 = Color3.fromRGB(255,255,255)
ListBtn.Text = "Listele"
ListBtn.Font = Enum.Font.SourceSansBold
ListBtn.TextSize = 16
ListBtn.Parent = Content

-- Hızlı artış butonları (elmas/para için pratik)
local Quick1 = Instance.new("TextButton")
Quick1.Size = UDim2.new(0, 60, 0, 24)
Quick1.Position = UDim2.new(0, 10, 0, 150)
Quick1.BackgroundColor3 = Color3.fromRGB(45, 120, 45)
Quick1.TextColor3 = Color3.fromRGB(255,255,255)
Quick1.Text = "+1"
Quick1.Font = Enum.Font.SourceSansBold
Quick1.TextSize = 16
Quick1.Parent = Content

local Quick100 = Instance.new("TextButton")
Quick100.Size = UDim2.new(0, 60, 0, 24)
Quick100.Position = UDim2.new(0, 80, 0, 150)
Quick100.BackgroundColor3 = Color3.fromRGB(45, 100, 140)
Quick100.TextColor3 = Color3.fromRGB(255,255,255)
Quick100.Text = "+100"
Quick100.Font = Enum.Font.SourceSansBold
Quick100.TextSize = 16
Quick100.Parent = Content

local Quick1000 = Instance.new("TextButton")
Quick1000.Size = UDim2.new(0, 60, 0, 24)
Quick1000.Position = UDim2.new(0, 150, 0, 150)
Quick1000.BackgroundColor3 = Color3.fromRGB(100, 60, 160)
Quick1000.TextColor3 = Color3.fromRGB(255,255,255)
Quick1000.Text = "+1000"
Quick1000.Font = Enum.Font.SourceSansBold
Quick1000.TextSize = 16
Quick1000.Parent = Content

local function quickSend(n)
    if not SelectedRemote then refreshRemote() end
    if SelectedRemote then
        SelectedRemote:FireServer(n)
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Gönderildi: " .. tostring(n); Duration = 2}) end)
    else
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Remote yok"; Duration = 2}) end)
    end
end
Quick1.MouseButton1Click:Connect(function() quickSend(1) end)
Quick100.MouseButton1Click:Connect(function() quickSend(100) end)
Quick1000.MouseButton1Click:Connect(function() quickSend(1000) end)

-- Bağımsız liste paneli
local DD = Instance.new("Frame")
DD.Name = "RemoteList"
DD.Size = UDim2.new(0, 340, 0, 240)
DD.Position = UDim2.new(0, 60, 0, 80)
DD.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
DD.BorderSizePixel = 0
DD.Visible = false
DD.Active = true
DD.ZIndex = 50
DD.Parent = ScreenGui

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
DDTitle.Parent = DD

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
DDClose.Parent = DD

local DDList = Instance.new("ScrollingFrame")
DDList.Size = UDim2.new(1, -16, 1, -40)
DDList.Position = UDim2.new(0, 8, 0, 32)
DDList.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
DDList.BorderSizePixel = 0
DDList.ScrollBarThickness = 6
DDList.ZIndex = 51
DDList.Parent = DD

local UIL = Instance.new("UIListLayout")
UIL.FillDirection = Enum.FillDirection.Vertical
UIL.Padding = UDim.new(0, 4)
UIL.Parent = DDList

local UIP = Instance.new("UIPadding")
UIP.PaddingTop = UDim.new(0, 6)
UIP.PaddingBottom = UDim.new(0, 6)
UIP.PaddingLeft = UDim.new(0, 6)
UIP.PaddingRight = UDim.new(0, 6)
UIP.Parent = DDList

-- DD sürükleme
local ddDragging = false
local ddDragStart, ddStartPos
DDTitle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        ddDragging = true
        ddDragStart = input.Position
        ddStartPos = DD.Position
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
        DD.Position = UDim2.new(ddStartPos.X.Scale, ddStartPos.X.Offset + delta.X, ddStartPos.Y.Scale, ddStartPos.Y.Offset + delta.Y)
    end
end)
DDClose.MouseButton1Click:Connect(function()
    DD.Visible = false
end)

-- Listeyi doldur
local function populateList()
    for _, c in ipairs(DDList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local evs = {}
    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if d:IsA("RemoteEvent") then table.insert(evs, d) end
    end
    table.sort(evs, function(a,b) return a.Name:lower() < b.Name:lower() end)
    for _, ev in ipairs(evs) do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(1, -12, 0, 24)
        item.BackgroundColor3 = Color3.fromRGB(35,35,35)
        item.TextColor3 = Color3.fromRGB(230,230,230)
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.AutoButtonColor = true
        item.Font = Enum.Font.SourceSans
        item.TextSize = 16
        item.Text = ev.Name .. "  (" .. ev.Parent.Name .. ")"
        item.ZIndex = 52
        item.Parent = DDList
        item.MouseButton1Click:Connect(function()
            if ev and ev:IsA("RemoteEvent") then
                SelectedRemote = ev
                CurrentRemoteName = ev.Name
                NameBox.Text = ev.Name
                pcall(function()
                    StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Seçildi: " .. ev.Name; Duration = 2})
                end)
            end
            DD.Visible = false
        end)
    end
end

ListBtn.MouseButton1Click:Connect(function()
    if DD.Visible then
        DD.Visible = false
    else
        populateList()
        DD.Visible = true
    end
end)

local function refreshRemote()
    CurrentRemoteName = (NameBox.Text and NameBox.Text ~= "") and NameBox.Text or CurrentRemoteName
    SelectedRemote = resolveRemoteEventByName(ReplicatedStorage, CurrentRemoteName)
    local msg = SelectedRemote and ("Event bulundu: " .. SelectedRemote:GetFullName()) or ("Event yok: " .. tostring(CurrentRemoteName))
    pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = msg; Duration = 2}) end)
end
RefreshBtn.MouseButton1Click:Connect(refreshRemote)
refreshRemote()

-- Remote fire butonları
local FireNoArgs = Instance.new("TextButton")
FireNoArgs.Size = UDim2.new(0, 160, 0, 28)
FireNoArgs.Position = UDim2.new(0, 10, 0, 80)
FireNoArgs.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
FireNoArgs.TextColor3 = Color3.fromRGB(255,255,255)
FireNoArgs.Text = "Fire (args yok)"
FireNoArgs.Font = Enum.Font.SourceSansBold
FireNoArgs.TextSize = 16
FireNoArgs.Parent = Content

local ValueBox = Instance.new("TextBox")
ValueBox.Size = UDim2.new(0, 120, 0, 28)
ValueBox.Position = UDim2.new(0, 180, 0, 80)
ValueBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
ValueBox.TextColor3 = Color3.fromRGB(255,255,255)
ValueBox.PlaceholderText = "Sayı (örn. 1000)"
ValueBox.Text = "1000"
ValueBox.Font = Enum.Font.SourceSans
ValueBox.TextSize = 16
ValueBox.Parent = Content

local FireWithValue = Instance.new("TextButton")
FireWithValue.Size = UDim2.new(0, 160, 0, 28)
FireWithValue.Position = UDim2.new(0, 10, 0, 114)
FireWithValue.BackgroundColor3 = Color3.fromRGB(50, 100, 160)
FireWithValue.TextColor3 = Color3.fromRGB(255,255,255)
FireWithValue.Text = "Fire (sayı ile)"
FireWithValue.Font = Enum.Font.SourceSansBold
FireWithValue.TextSize = 16
FireWithValue.Parent = Content

-- Serbest argüman girişi (JSON veya basit tipler)
local ArgsBox = Instance.new("TextBox")
ArgsBox.Size = UDim2.new(0, 330, 0, 28)
ArgsBox.Position = UDim2.new(0, 10, 0, 182)
ArgsBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
ArgsBox.TextColor3 = Color3.fromRGB(255,255,255)
ArgsBox.PlaceholderText = "Argüman(lar): Örn 100 | \"DailyLogin\" | [100,\"key\",true]"
ArgsBox.Text = "[100]"
ArgsBox.Font = Enum.Font.SourceSans
ArgsBox.TextSize = 16
ArgsBox.Parent = Content

local FireWithArgs = Instance.new("TextButton")
FireWithArgs.Size = UDim2.new(0, 160, 0, 28)
FireWithArgs.Position = UDim2.new(0, 10, 0, 216)
FireWithArgs.BackgroundColor3 = Color3.fromRGB(160, 90, 50)
FireWithArgs.TextColor3 = Color3.fromRGB(255,255,255)
FireWithArgs.Text = "Fire (args ile)"
FireWithArgs.Font = Enum.Font.SourceSansBold
FireWithArgs.TextSize = 16
FireWithArgs.Parent = Content

local function parseArgs(text)
    if not text or text == "" then return {} end
    -- JSON array dene
    if string.sub(text,1,1) == "[" then
        local ok, arr = pcall(function() return HttpService:JSONDecode(text) end)
        if ok and type(arr) == "table" then return arr end
    end
    -- Tekil tip: number/bool/string
    if text == "true" then return {true} end
    if text == "false" then return {false} end
    local num = tonumber(text)
    if num ~= nil then return {num} end
    -- quoted string "..."
    local m = string.match(text, '^%s*"(.*)"%s*$')
    if m then return {m} end
    -- pipe ayracıyla çoklu basit değerler: 100|"key"|true
    if string.find(text, "|") then
        local parts = {}
        for token in string.gmatch(text, "[^|]+") do
            token = token:gsub("^%s+", ""):gsub("%s+$", "")
            if token == "true" then table.insert(parts, true)
            elseif token == "false" then table.insert(parts, false)
            elseif tonumber(token) then table.insert(parts, tonumber(token))
            else
                local sm = string.match(token, '^%s*"(.*)"%s*$')
                table.insert(parts, sm or token)
            end
        end
        return parts
    end
    return {text}
end

FireWithArgs.MouseButton1Click:Connect(function()
    if not SelectedRemote then refreshRemote() end
    if not SelectedRemote then
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Remote yok"; Duration = 2}) end)
        return
    end
    local args = parseArgs(ArgsBox.Text)
    SelectedRemote:FireServer(unpack(args))
    pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Args gönderildi"; Duration = 2}) end)
end)

FireNoArgs.MouseButton1Click:Connect(function()
    if not SelectedRemote then refreshRemote() end
    if SelectedRemote then
        SelectedRemote:FireServer()
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Gönderildi (args yok)"; Duration = 2}) end)
    else
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Remote yok"; Duration = 2}) end)
    end
end)

FireWithValue.MouseButton1Click:Connect(function()
    if not SelectedRemote then refreshRemote() end
    local n = tonumber(ValueBox.Text)
    if SelectedRemote and n then
        SelectedRemote:FireServer(n)
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Gönderildi: " .. n; Duration = 2}) end)
    else
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "RH"; Text = "Remote veya sayı geçersiz"; Duration = 2}) end)
    end
end)

-- Ana pencere sürükleme
local dragging, dragStart, startPos = false, nil, nil
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Kapatma/ESC temizliği
local function destroyAll()
    if getgenv().RHGUI and getgenv().RHGUI.FOVCircle then
        getgenv().RHGUI.FOVCircle:Remove()
        getgenv().RHGUI.FOVCircle = nil
    end
    if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
end
CloseBtn.MouseButton1Click:Connect(destroyAll)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        destroyAll()
    end
end)

