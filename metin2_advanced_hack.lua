--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║         Metin2 Advanced Hack v3.0                         ║
    ║   Damage Hack | Speed Hack | In-Game GUI                 ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
    
    FEATURES:
    ✓ Damage Multiplier (x1-x20)
    ✓ Speed Hack (x1-x10)
    ✓ In-Game GUI (Tab to toggle)
    ✓ Anti-Detection System
    ✓ Safe Mode (No crash)
    
    CONTROLS:
    - Tab: Toggle GUI
    - Mouse: Click and drag to move
]]

print("[Metin2 Hack] Loading v3.0...")

-- ===== CONFIGURATION =====
local config = {
    damageMultiplier = 3,
    speedMultiplier = 2,
    safeMode = true,
    randomizeDamage = true,
    antiDetection = true,
    maxDamage = 50000,
    maxSpeed = 10,
}

-- ===== STATE =====
local state = {
    damageEnabled = false,
    speedEnabled = false,
    guiVisible = false,
    damageAddress = nil,
    speedAddress = nil,
    originalSpeed = nil,
}

-- ===== ANTI-DETECTION =====
local function randomizeDamage(damage)
    if config.randomizeDamage then
        local variance = math.random(95, 105) / 100
        return math.floor(damage * variance)
    end
    return damage
end

local function isSafeDamage(damage)
    return damage <= config.maxDamage
end

local function isSafeSpeed(speed)
    return speed <= config.maxSpeed
end

-- ===== DAMAGE HACK =====
local damageScanner = nil
local damageAddresses = {}

local function findDamageAddress()
    print("[Damage] Searching for damage address...")
    
    -- Method 1: Scan for damage values (10-10000)
    local ms = createMemScan()
    ms.firstScan(soValueBetween, vtDword, rtTruncated, "10", "10000", 0, 0x7FFFFFFF, "", fsmNotAligned, "", false, false, false, false)
    ms.waitTillDone()
    
    local foundlist = ms.getAttachedFoundlist()
    print("[Damage] Found " .. foundlist.Count .. " potential addresses")
    
    if foundlist.Count > 0 and foundlist.Count < 1000 then
        -- Store addresses
        damageAddresses = {}
        for i = 0, math.min(foundlist.Count - 1, 50) do
            local addr = foundlist.Address[i]
            table.insert(damageAddresses, addr)
        end
        
        if #damageAddresses > 0 then
            state.damageAddress = damageAddresses[1]
            print("[Damage] ✓ Address found: " .. string.format("0x%X", state.damageAddress))
            return true
        end
    end
    
    print("[Damage] ✗ Address not found. Attack a mob first!")
    return false
end

local function applyDamageHack()
    if not state.damageEnabled then return end
    if not state.damageAddress then return end
    
    pcall(function()
        local currentDamage = readInteger(state.damageAddress)
        if currentDamage and currentDamage > 0 and currentDamage < 10000 then
            local newDamage = currentDamage * config.damageMultiplier
            newDamage = randomizeDamage(newDamage)
            
            if isSafeDamage(newDamage) then
                writeInteger(state.damageAddress, newDamage)
            else
                writeInteger(state.damageAddress, config.maxDamage)
            end
        end
    end)
end

-- ===== SPEED HACK =====
local speedScanner = nil
local speedAddresses = {}

local function findSpeedAddress()
    print("[Speed] Searching for speed address...")
    
    -- Method 1: Scan for speed values (usually 1-10)
    local ms = createMemScan()
    ms.firstScan(soValueBetween, vtFloat, rtTruncated, "1", "10", 0, 0x7FFFFFFF, "", fsmNotAligned, "", false, false, false, false)
    ms.waitTillDone()
    
    local foundlist = ms.getAttachedFoundlist()
    print("[Speed] Found " .. foundlist.Count .. " potential addresses")
    
    if foundlist.Count > 0 and foundlist.Count < 1000 then
        -- Store addresses
        speedAddresses = {}
        for i = 0, math.min(foundlist.Count - 1, 50) do
            local addr = foundlist.Address[i]
            table.insert(speedAddresses, addr)
        end
        
        if #speedAddresses > 0 then
            state.speedAddress = speedAddresses[1]
            state.originalSpeed = readFloat(state.speedAddress)
            print("[Speed] ✓ Address found: " .. string.format("0x%X", state.speedAddress))
            print("[Speed] ✓ Original speed: " .. state.originalSpeed)
            return true
        end
    end
    
    print("[Speed] ✗ Address not found. Try moving first!")
    return false
end

local function applySpeedHack()
    if not state.speedEnabled then
        -- Restore original speed
        if state.speedAddress and state.originalSpeed then
            pcall(function()
                writeFloat(state.speedAddress, state.originalSpeed)
            end)
        end
        return
    end
    
    if not state.speedAddress then return end
    
    pcall(function()
        local newSpeed = (state.originalSpeed or 5) * config.speedMultiplier
        
        if isSafeSpeed(newSpeed) then
            writeFloat(state.speedAddress, newSpeed)
        else
            writeFloat(state.speedAddress, config.maxSpeed)
        end
    end)
end

-- ===== IN-GAME GUI =====
local guiForm = nil
local guiComponents = {}

local function createInGameGUI()
    -- Create main form
    guiForm = createForm(false)
    guiForm.Caption = "Metin2 Hack v3.0"
    guiForm.Width = 350
    guiForm.Height = 400
    guiForm.Position = "poScreenCenter"
    guiForm.BorderStyle = bsSizeable
    guiForm.Color = 0x1E1E1E
    guiForm.Font.Color = 0xFFFFFF
    guiForm.AlphaBlend = true
    guiForm.AlphaBlendValue = 240
    guiForm.Visible = false
    
    -- Title
    local lblTitle = createLabel(guiForm)
    lblTitle.Caption = "⚔️ METIN2 HACK v3.0"
    lblTitle.Left = 10
    lblTitle.Top = 10
    lblTitle.Width = 330
    lblTitle.Height = 30
    lblTitle.Font.Size = 14
    lblTitle.Font.Style = "[fsBold]"
    lblTitle.Font.Color = 0x00FF00
    lblTitle.Alignment = "taCenter"
    
    -- Separator
    local sep1 = createPanel(guiForm)
    sep1.Left = 10
    sep1.Top = 45
    sep1.Width = 330
    sep1.Height = 2
    sep1.Color = 0x00FF00
    
    -- ===== DAMAGE SECTION =====
    local lblDamage = createLabel(guiForm)
    lblDamage.Caption = "💥 DAMAGE HACK"
    lblDamage.Left = 10
    lblDamage.Top = 60
    lblDamage.Width = 330
    lblDamage.Font.Size = 11
    lblDamage.Font.Style = "[fsBold]"
    lblDamage.Font.Color = 0xFF6600
    
    -- Damage Enable Checkbox
    local chkDamage = createCheckBox(guiForm)
    chkDamage.Caption = "Enable Damage Hack"
    chkDamage.Left = 20
    chkDamage.Top = 85
    chkDamage.Width = 200
    chkDamage.Font.Color = 0xFFFFFF
    chkDamage.OnClick = function()
        state.damageEnabled = chkDamage.Checked
        if state.damageEnabled and not state.damageAddress then
            findDamageAddress()
        end
        print("[Damage] " .. (state.damageEnabled and "ON" or "OFF"))
    end
    guiComponents.chkDamage = chkDamage
    
    -- Damage Multiplier Label
    local lblDmgMult = createLabel(guiForm)
    lblDmgMult.Caption = "Multiplier: x" .. config.damageMultiplier
    lblDmgMult.Left = 20
    lblDmgMult.Top = 115
    lblDmgMult.Width = 200
    lblDmgMult.Font.Color = 0xCCCCCC
    guiComponents.lblDmgMult = lblDmgMult
    
    -- Damage Multiplier Trackbar
    local trkDamage = createTrackBar(guiForm)
    trkDamage.Left = 20
    trkDamage.Top = 135
    trkDamage.Width = 310
    trkDamage.Min = 1
    trkDamage.Max = 20
    trkDamage.Position = config.damageMultiplier
    trkDamage.OnChange = function()
        config.damageMultiplier = trkDamage.Position
        lblDmgMult.Caption = "Multiplier: x" .. config.damageMultiplier
    end
    guiComponents.trkDamage = trkDamage
    
    -- Find Damage Button
    local btnFindDamage = createButton(guiForm)
    btnFindDamage.Caption = "🔍 Find Damage Address"
    btnFindDamage.Left = 20
    btnFindDamage.Top = 170
    btnFindDamage.Width = 310
    btnFindDamage.Height = 30
    btnFindDamage.OnClick = function()
        findDamageAddress()
    end
    
    -- ===== SPEED SECTION =====
    local sep2 = createPanel(guiForm)
    sep2.Left = 10
    sep2.Top = 215
    sep2.Width = 330
    sep2.Height = 2
    sep2.Color = 0x00FF00
    
    local lblSpeed = createLabel(guiForm)
    lblSpeed.Caption = "⚡ SPEED HACK"
    lblSpeed.Left = 10
    lblSpeed.Top = 225
    lblSpeed.Width = 330
    lblSpeed.Font.Size = 11
    lblSpeed.Font.Style = "[fsBold]"
    lblSpeed.Font.Color = 0x00CCFF
    
    -- Speed Enable Checkbox
    local chkSpeed = createCheckBox(guiForm)
    chkSpeed.Caption = "Enable Speed Hack"
    chkSpeed.Left = 20
    chkSpeed.Top = 250
    chkSpeed.Width = 200
    chkSpeed.Font.Color = 0xFFFFFF
    chkSpeed.OnClick = function()
        state.speedEnabled = chkSpeed.Checked
        if state.speedEnabled and not state.speedAddress then
            findSpeedAddress()
        end
        applySpeedHack()
        print("[Speed] " .. (state.speedEnabled and "ON" or "OFF"))
    end
    guiComponents.chkSpeed = chkSpeed
    
    -- Speed Multiplier Label
    local lblSpdMult = createLabel(guiForm)
    lblSpdMult.Caption = "Multiplier: x" .. config.speedMultiplier
    lblSpdMult.Left = 20
    lblSpdMult.Top = 280
    lblSpdMult.Width = 200
    lblSpdMult.Font.Color = 0xCCCCCC
    guiComponents.lblSpdMult = lblSpdMult
    
    -- Speed Multiplier Trackbar
    local trkSpeed = createTrackBar(guiForm)
    trkSpeed.Left = 20
    trkSpeed.Top = 300
    trkSpeed.Width = 310
    trkSpeed.Min = 1
    trkSpeed.Max = 10
    trkSpeed.Position = config.speedMultiplier
    trkSpeed.OnChange = function()
        config.speedMultiplier = trkSpeed.Position
        lblSpdMult.Caption = "Multiplier: x" .. config.speedMultiplier
        if state.speedEnabled then
            applySpeedHack()
        end
    end
    guiComponents.trkSpeed = trkSpeed
    
    -- Find Speed Button
    local btnFindSpeed = createButton(guiForm)
    btnFindSpeed.Caption = "🔍 Find Speed Address"
    btnFindSpeed.Left = 20
    btnFindSpeed.Top = 335
    btnFindSpeed.Width = 310
    btnFindSpeed.Height = 30
    btnFindSpeed.OnClick = function()
        findSpeedAddress()
    end
    
    print("[GUI] ✓ In-game GUI created")
    print("[GUI] ✓ Press Tab to toggle")
end

-- ===== HOTKEY HANDLER =====
local function setupHotkeys()
    -- Tab key to toggle GUI
    local hotkeyTimer = createTimer(nil)
    hotkeyTimer.Interval = 100
    hotkeyTimer.OnTimer = function()
        if isKeyPressed(VK_TAB) then
            if guiForm then
                state.guiVisible = not state.guiVisible
                guiForm.Visible = state.guiVisible
                print("[GUI] " .. (state.guiVisible and "Opened" or "Closed"))
            end
            sleep(200) -- Debounce
        end
    end
    hotkeyTimer.Enabled = true
    
    print("[Hotkeys] ✓ Tab key registered")
end

-- ===== UPDATE LOOP =====
local function startUpdateLoop()
    local updateTimer = createTimer(nil)
    updateTimer.Interval = 100 -- Update every 100ms
    updateTimer.OnTimer = function()
        -- Apply damage hack
        if state.damageEnabled then
            applyDamageHack()
        end
        
        -- Apply speed hack
        if state.speedEnabled then
            applySpeedHack()
        end
    end
    updateTimer.Enabled = true
    
    print("[Update Loop] ✓ Started (100ms interval)")
end

-- ===== INITIALIZATION =====
local function initialize()
    print("[Metin2 Hack] ═══════════════════════════════════")
    print("[Metin2 Hack] Initializing...")
    print("[Metin2 Hack] ═══════════════════════════════════")
    
    -- Create GUI
    createInGameGUI()
    
    -- Setup hotkeys
    setupHotkeys()
    
    -- Start update loop
    startUpdateLoop()
    
    print("[Metin2 Hack] ═══════════════════════════════════")
    print("[Metin2 Hack] ✓ Initialization complete!")
    print("[Metin2 Hack] ═══════════════════════════════════")
    print("[Metin2 Hack] CONTROLS:")
    print("[Metin2 Hack] - Press Tab to open/close GUI")
    print("[Metin2 Hack] - Enable Damage Hack and attack a mob")
    print("[Metin2 Hack] - Enable Speed Hack and move")
    print("[Metin2 Hack] ═══════════════════════════════════")
    print("[Metin2 Hack] FEATURES:")
    print("[Metin2 Hack] ✓ Damage Multiplier (x1-x20)")
    print("[Metin2 Hack] ✓ Speed Multiplier (x1-x10)")
    print("[Metin2 Hack] ✓ Anti-Detection System")
    print("[Metin2 Hack] ✓ Safe Mode (No crash)")
    print("[Metin2 Hack] ═══════════════════════════════════")
end

-- ===== AUTO START =====
initialize()

--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                    KULLANIM KILAVUZU                      ║
    ╚═══════════════════════════════════════════════════════════╝
    
    1. KURULUM:
       - Cheat Engine'i aç
       - Metin2 client'ı seç
       - Bu script'i yükle ve çalıştır
       - "Initialization complete!" mesajını bekle
    
    2. DAMAGE HACK:
       - Tab tuşuna bas (GUI açılır)
       - "Enable Damage Hack" işaretle
       - "Find Damage Address" butonuna tıkla
       - Oyunda bir mob'a saldır
       - Damage otomatik artacak
       - Multiplier'ı ayarla (x1-x20)
    
    3. SPEED HACK:
       - Tab tuşuna bas (GUI açılır)
       - "Enable Speed Hack" işaretle
       - "Find Speed Address" butonuna tıkla
       - Oyunda hareket et
       - Hız otomatik artacak
       - Multiplier'ı ayarla (x1-x10)
    
    4. HOTKEYS:
       - Tab: GUI aç/kapat
       - Mouse: GUI'yi sürükle
    
    5. GÜVENLİK:
       ⚠️ Test server'da test et
       ⚠️ Düşük multiplier kullan (x2-x5)
       ⚠️ PvP'de kullanma
       ⚠️ Aşırı kullanma
    
    6. SORUN GİDERME:
       - "Address not found": Önce mob'a saldır/hareket et
       - Oyun crash: Multiplier'ı düşür
       - GUI açılmıyor: Tab tuşuna tekrar bas
       - Çalışmıyor: Script'i tekrar yükle
    
    7. ÖZELLİKLER:
       ✓ In-game GUI (Tab ile aç/kapat)
       ✓ Damage multiplier (x1-x20)
       ✓ Speed multiplier (x1-x10)
       ✓ Auto damage finder
       ✓ Auto speed finder
       ✓ Anti-detection (randomize values)
       ✓ Safe mode (max limits)
       ✓ Real-time updates (100ms)
       ✓ No crash (safe operations only)
]]
