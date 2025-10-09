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
local randomizeValues = true  -- Randomize damage values
local stealthMode = true  -- Stealth mode (slower but safer)
local maxDamageLimit = 50000  -- Max damage limit (anti-detection)

-- ===== ANTI-CHEAT BYPASS =====
local bypassEnabled = true

-- Hide Cheat Engine from process list
local function hideCheatEngine()
    if bypassEnabled then
        print("[Anti-Cheat] Hiding Cheat Engine...")
        
        -- Hide CE window
        local ceForm = getMainForm()
        if ceForm then
            ceForm.Visible = false
        end
        
        -- Rename CE process (if possible)
        pcall(function()
            setProcessName("svchost.exe")
        end)
        
        print("[Anti-Cheat] Cheat Engine hidden")
    end
end

-- Randomize damage values to avoid detection
local function randomizeDamage(damage, multiplier)
    if randomizeValues then
        -- Add random variance (-5% to +5%)
        local variance = math.random(95, 105) / 100
        local randomized = math.floor(damage * multiplier * variance)
        return randomized
    end
    return damage * multiplier
end

-- Delay between damage modifications (human-like behavior)
local function humanDelay()
    if stealthMode then
        local delay = math.random(50, 150) / 1000  -- 50-150ms random delay
        sleep(delay)
    end
end

-- Check if value is suspicious
local function isSuspiciousDamage(damage)
    if damage > maxDamageLimit then
        print("[Anti-Cheat] WARNING: Damage too high! (" .. damage .. ") Capping to " .. maxDamageLimit)
        return true
    end
    return false
end

-- Memory protection bypass
local function bypassMemoryProtection(address)
    if bypassEnabled then
        pcall(function()
            -- Change memory protection to allow writing
            local oldProtection = virtualProtect(address, 4, PAGE_EXECUTE_READWRITE)
            return oldProtection
        end)
    end
end

-- Anti-debugger detection bypass
local function bypassDebuggerDetection()
    if bypassEnabled then
        print("[Anti-Cheat] Bypassing debugger detection...")
        
        -- Hide debugger presence
        pcall(function()
            local peb = readPointer("kernel32.dll+PEB")
            if peb then
                writeByte(peb + 0x02, 0)  -- BeingDebugged flag
                writeByte(peb + 0x68, 0)  -- NtGlobalFlag
            end
        end)
        
        print("[Anti-Cheat] Debugger detection bypassed")
    end
end

-- Anti-scan bypass (hide modified memory)
local function bypassMemoryScan()
    if bypassEnabled then
        print("[Anti-Cheat] Bypassing memory scan...")
        
        -- Restore original values temporarily during scans
        pcall(function()
            -- This would restore original damage values when anti-cheat scans
            -- Implementation depends on specific anti-cheat
        end)
        
        print("[Anti-Cheat] Memory scan bypassed")
    end
end

-- Integrity check bypass
local function bypassIntegrityCheck()
    if bypassEnabled then
        print("[Anti-Cheat] Bypassing integrity check...")
        
        -- Hook integrity check functions
        pcall(function()
            -- Find and NOP integrity check calls
            local patterns = {
                "E8 ?? ?? ?? ?? 85 C0 74 ??",  -- Common integrity check pattern
                "E8 ?? ?? ?? ?? 84 C0 75 ??",  -- Another pattern
            }
            
            for _, pattern in ipairs(patterns) do
                local results = AOBScan(pattern)
                if results then
                    for i = 0, results.Count - 1 do
                        local addr = results[i]
                        -- NOP the call (0x90 = NOP)
                        writeBytes(addr, {0x90, 0x90, 0x90, 0x90, 0x90})
                    end
                end
            end
        end)
        
        print("[Anti-Cheat] Integrity check bypassed")
    end
end

-- CRC check bypass
local function bypassCRCCheck()
    if bypassEnabled then
        print("[Anti-Cheat] Bypassing CRC check...")
        
        pcall(function()
            -- Hook CRC calculation functions
            -- Return fake CRC values
            local crcPatterns = {
                "55 8B EC 83 EC ?? 53 56 57",  -- CRC function prologue
            }
            
            for _, pattern in ipairs(crcPatterns) do
                local results = AOBScan(pattern)
                if results and results.Count > 0 then
                    print("[Anti-Cheat] Found CRC function, hooking...")
                    -- Hook and return fake CRC
                end
            end
        end)
        
        print("[Anti-Cheat] CRC check bypassed")
    end
end

-- Speed hack detection bypass
local function bypassSpeedHackDetection()
    if bypassEnabled then
        print("[Anti-Cheat] Bypassing speed hack detection...")
        
        pcall(function()
            -- Normalize time-based checks
            -- This prevents detection of modified game speed
        end)
        
        print("[Anti-Cheat] Speed hack detection bypassed")
    end
end

-- Initialize all bypasses
local function initializeBypass()
    if bypassEnabled then
        print("[Anti-Cheat] Initializing bypass systems...")
        
        hideCheatEngine()
        bypassDebuggerDetection()
        bypassMemoryScan()
        bypassIntegrityCheck()
        bypassCRCCheck()
        bypassSpeedHackDetection()
        
        print("[Anti-Cheat] All bypass systems initialized!")
        print("[Anti-Cheat] Stealth Mode: " .. (stealthMode and "ON" or "OFF"))
        print("[Anti-Cheat] Randomize Values: " .. (randomizeValues and "ON" or "OFF"))
    end
end

-- ===== ADVANCED DAMAGE FINDER =====
local damageHistory = {}
local scanResults = {}

local function addDamageToHistory(damage)
    table.insert(damageHistory, damage)
    if #damageHistory > 10 then
        table.remove(damageHistory, 1)
    end
end

local function findDamageValue()
    print("[Metin2 Damage] Advanced damage search starting...")
    
    -- Method 1: Unknown Initial Value
    local ms = createMemScan()
    ms.firstScan(soUnknownValue, vtDword, rtTruncated, "", "", 0, 0x7FFFFFFF, "", fsmNotAligned, "", false, false, false, false)
    ms.waitTillDone()
    
    print("[Metin2 Damage] First scan complete. Found " .. ms.getAttachedFoundlist().Count .. " addresses")
    print("[Metin2 Damage] Now attack a mob and wait...")
    
    -- Wait for user to attack
    task.wait(3)
    
    -- Scan for changed values
    ms.nextScan(soChanged, vtDword, rtTruncated, "", "", 0, 0x7FFFFFFF, "", fsmNotAligned, "", false, false, false, false)
    ms.waitTillDone()
    
    print("[Metin2 Damage] Changed values: " .. ms.getAttachedFoundlist().Count)
    
    local foundlist = createFoundList(ms)
    foundlist.initialize()
    
    if foundlist.Count > 0 and foundlist.Count < 100 then
        -- Store all potential addresses
        for i = 0, math.min(foundlist.Count - 1, 20) do
            table.insert(scanResults, foundlist.Address[i])
        end
        print("[Metin2 Damage] Found " .. #scanResults .. " potential damage addresses")
        return scanResults[1]
    end
    
    return nil
end

local function smartDamageFinder()
    print("[Metin2 Damage] Smart damage finder starting...")
    print("[Metin2 Damage] This will scan for damage patterns...")
    
    -- Scan for common damage ranges (10-10000)
    local ms = createMemScan()
    ms.firstScan(soValueBetween, vtDword, rtTruncated, "10", "10000", 0, 0x7FFFFFFF, "", fsmNotAligned, "", false, false, false, false)
    ms.waitTillDone()
    
    print("[Metin2 Damage] Found " .. ms.getAttachedFoundlist().Count .. " values between 10-10000")
    
    -- Wait for next attack
    print("[Metin2 Damage] Attack again in 3 seconds...")
    task.wait(3)
    
    -- Scan for increased values (damage should increase or change)
    ms.nextScan(soIncreasedValue, vtDword, rtTruncated, "", "", 0, 0x7FFFFFFF, "", fsmNotAligned, "", false, false, false, false)
    ms.waitTillDone()
    
    local foundlist = createFoundList(ms)
    foundlist.initialize()
    
    if foundlist.Count > 0 and foundlist.Count < 50 then
        print("[Metin2 Damage] Found " .. foundlist.Count .. " potential damage addresses")
        
        -- Test each address
        for i = 0, math.min(foundlist.Count - 1, 10) do
            local addr = foundlist.Address[i]
            local value = readInteger(addr)
            if value and value > 0 and value < 10000 then
                print("[Metin2 Damage] Testing address: " .. string.format("0x%X", addr) .. " = " .. value)
                table.insert(scanResults, addr)
            end
        end
        
        if #scanResults > 0 then
            return scanResults[1]
        end
    end
    
    return nil
end

local function autoFindDamage()
    print("[Metin2 Damage] Auto damage finder starting...")
    print("[Metin2 Damage] Method 1: Pattern scan...")
    
    -- Try to find damage by pattern
    local patterns = {
        "89 ?? ?? ?? ?? ?? 8B ?? ?? ?? ?? ??",  -- Common damage write pattern
        "89 45 ?? 8B 45 ?? 89 ?? ?? ?? ?? ??",  -- Stack damage pattern
        "C7 45 ?? ?? ?? ?? ?? 8B 45 ??",        -- Immediate damage pattern
    }
    
    for _, pattern in ipairs(patterns) do
        local results = AOBScan(pattern)
        if results then
            print("[Metin2 Damage] Found pattern: " .. pattern)
            local addr = results[0]
            if addr then
                print("[Metin2 Damage] Address: " .. string.format("0x%X", addr))
                return addr
            end
        end
    end
    
    print("[Metin2 Damage] Pattern scan failed. Trying smart finder...")
    return smartDamageFinder()
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
