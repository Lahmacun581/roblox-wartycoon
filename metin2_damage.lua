--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║            Metin2 Damage Multiplier                       ║
    ║         Cheat Engine Lua Script                           ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
    
    KULLANIM:
    1. Cheat Engine'i aç
    2. Metin2 client'ı seç (metin2client.bin)
    3. Table -> Show Cheat Table Lua Script
    4. Bu kodu yapıştır
    5. Execute Script
]]

print("[Metin2 Damage] Loading...")

-- ===== CONFIGURATION =====
local damageMultiplier = 5  -- 5x damage (değiştirilebilir)
local updateInterval = 100  -- 100ms update

-- ===== DAMAGE FINDER =====
local function findDamageValue()
    print("[Metin2 Damage] Searching for damage value...")
    
    -- Method 1: Exact Value Search
    local ms = createMemScan()
    ms.firstScan(soExactValue, vtDword, rtTruncated, "0", "", 0, 0xFFFFFFFF, "", fsmNotAligned, "", false, false, false, false)
    ms.waitTillDone()
    
    local foundlist = createFoundList(ms)
    foundlist.initialize()
    
    if foundlist.Count > 0 then
        print("[Metin2 Damage] Found " .. foundlist.Count .. " addresses")
        return foundlist.Address[0]
    end
    
    return nil
end

-- ===== DAMAGE MULTIPLIER =====
local function multiplyDamage(address, multiplier)
    if address then
        local currentValue = readInteger(address)
        if currentValue and currentValue > 0 then
            local newValue = currentValue * multiplier
            writeInteger(address, newValue)
            print("[Metin2 Damage] " .. currentValue .. " -> " .. newValue .. " (x" .. multiplier .. ")")
            return true
        end
    end
    return false
end

-- ===== AUTO DAMAGE MULTIPLIER =====
local damageAddress = nil
local timer = nil

local function updateDamage()
    if damageAddress then
        multiplyDamage(damageAddress, damageMultiplier)
    end
end

local function startDamageMultiplier()
    print("[Metin2 Damage] Starting damage multiplier...")
    
    -- Find damage address
    damageAddress = findDamageValue()
    
    if damageAddress then
        print("[Metin2 Damage] Damage address found: " .. string.format("0x%X", damageAddress))
        
        -- Create timer for auto update
        timer = createTimer(getMainForm())
        timer.Interval = updateInterval
        timer.OnTimer = updateDamage
        timer.Enabled = true
        
        print("[Metin2 Damage] Damage multiplier started! (x" .. damageMultiplier .. ")")
    else
        print("[Metin2 Damage] ERROR: Damage address not found!")
        print("[Metin2 Damage] Try attacking a mob first, then run the script again.")
    end
end

local function stopDamageMultiplier()
    if timer then
        timer.Enabled = false
        timer.destroy()
        timer = nil
    end
    print("[Metin2 Damage] Damage multiplier stopped.")
end

-- ===== MANUAL DAMAGE SEARCH =====
local function manualDamageSearch()
    print("[Metin2 Damage] Manual damage search...")
    print("[Metin2 Damage] 1. Attack a mob and note the damage")
    print("[Metin2 Damage] 2. Search for that value (Exact Value, 4 Bytes)")
    print("[Metin2 Damage] 3. Attack again and filter by new damage")
    print("[Metin2 Damage] 4. Repeat until you find the address")
    print("[Metin2 Damage] 5. Right-click -> Change value -> Multiply by " .. damageMultiplier)
end

-- ===== POINTER SCAN =====
local function pointerScan(address)
    print("[Metin2 Damage] Starting pointer scan for address: " .. string.format("0x%X", address))
    
    local ps = createPointerScanner()
    ps.pointerScan(address, 5, 0x1000, true, true, true, true)
    
    print("[Metin2 Damage] Pointer scan started. This may take a while...")
end

-- ===== GUI =====
local function createGUI()
    local form = createForm(false)
    form.Caption = "Metin2 Damage Multiplier"
    form.Width = 400
    form.Height = 300
    form.Position = "poScreenCenter"
    
    -- Multiplier Label
    local lblMultiplier = createLabel(form)
    lblMultiplier.Caption = "Damage Multiplier:"
    lblMultiplier.Left = 20
    lblMultiplier.Top = 20
    
    -- Multiplier Edit
    local edtMultiplier = createEdit(form)
    edtMultiplier.Text = tostring(damageMultiplier)
    edtMultiplier.Left = 150
    edtMultiplier.Top = 20
    edtMultiplier.Width = 100
    
    -- Start Button
    local btnStart = createButton(form)
    btnStart.Caption = "Start Damage Multiplier"
    btnStart.Left = 20
    btnStart.Top = 60
    btnStart.Width = 200
    btnStart.OnClick = function()
        damageMultiplier = tonumber(edtMultiplier.Text) or 5
        startDamageMultiplier()
    end
    
    -- Stop Button
    local btnStop = createButton(form)
    btnStop.Caption = "Stop Damage Multiplier"
    btnStop.Left = 20
    btnStop.Top = 100
    btnStop.Width = 200
    btnStop.OnClick = function()
        stopDamageMultiplier()
    end
    
    -- Manual Search Button
    local btnManual = createButton(form)
    btnManual.Caption = "Manual Search Guide"
    btnManual.Left = 20
    btnManual.Top = 140
    btnManual.Width = 200
    btnManual.OnClick = function()
        manualDamageSearch()
    end
    
    -- Info Label
    local lblInfo = createLabel(form)
    lblInfo.Caption = "1. Set multiplier value\n2. Attack a mob\n3. Click 'Start Damage Multiplier'\n4. Your damage will be multiplied!"
    lblInfo.Left = 20
    lblInfo.Top = 180
    lblInfo.AutoSize = false
    lblInfo.Width = 360
    lblInfo.Height = 80
    lblInfo.WordWrap = true
    
    form.show()
end

-- ===== AUTO START =====
print("[Metin2 Damage] Loaded!")
print("[Metin2 Damage] Creating GUI...")
createGUI()

--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                    KULLANIM KILAVUZU                      ║
    ╚═══════════════════════════════════════════════════════════╝
    
    YÖNTEM 1: Otomatik (Kolay)
    1. Bir mob'a saldır
    2. "Start Damage Multiplier" butonuna tıkla
    3. Damage otomatik olarak çarpılacak
    
    YÖNTEM 2: Manuel (Daha Güvenilir)
    1. Bir mob'a saldır ve damage'i not et (örn: 150)
    2. Cheat Engine'de "Exact Value" seç
    3. "4 Bytes" seç
    4. 150 yaz ve "First Scan"
    5. Tekrar saldır ve yeni damage'i not et (örn: 180)
    6. 180 yaz ve "Next Scan"
    7. Tekrar et, tek adres kalana kadar
    8. Adresi bul, sağ tık -> "Change value"
    9. Değeri x5 ile çarp (örn: 150 -> 750)
    
    YÖNTEM 3: Pointer Scan (Kalıcı)
    1. Manuel yöntemle damage adresini bul
    2. "Pointer Scan" butonuna tıkla
    3. Pointer'ları bul
    4. Bir sonraki oyun açılışında pointer kullan
    
    ÖNEMLİ NOTLAR:
    - Çok yüksek değer kullanma (x10'dan fazla)
    - Anti-cheat tespit edebilir
    - Sadece PvE'de kullan
    - PvP'de ban yeme riski yüksek
    
    SORUN GİDERME:
    - "Address not found" hatası: Önce mob'a saldır
    - Damage değişmiyor: Manuel yöntemi kullan
    - Oyun crash oluyor: Multiplier'ı düşür
]]
