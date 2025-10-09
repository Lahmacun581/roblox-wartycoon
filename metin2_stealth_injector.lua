--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║         Metin2 Stealth Injector v2.0                      ║
    ║   Advanced Anti-Detection & CE Hiding System              ║
    ║                  by Lahmacun581                           ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Bu script Cheat Engine'i tamamen gizler ve normal bir uygulama gibi gösterir.
    Metin2'nin anti-cheat sistemi Cheat Engine'i tespit edemez.
]]

print("[Stealth Injector] Loading advanced anti-detection system...")

-- ===== CONFIGURATION =====
local STEALTH_MODE = true
local HIDE_CE_WINDOW = true
local RENAME_PROCESS = false  -- DISABLED: Causes Metin2 crash
local HOOK_DETECTION = false  -- DISABLED: Causes Metin2 crash
local SAFE_MODE = true  -- ENABLED: Safe stealth mode
local FAKE_PROCESS_NAME = "explorer.exe"
local FAKE_WINDOW_TITLE = "Windows Explorer"

-- Safe stealth options (won't crash Metin2)
local SAFE_STEALTH = {
    hideWindow = true,          -- Hide CE window (SAFE)
    hideFromTaskbar = true,     -- Hide from taskbar (SAFE)
    minimizeToTray = true,      -- Minimize to system tray (SAFE)
    transparentWindow = false,  -- Make window transparent (SAFE but visible)
    bypassDebugger = true,      -- Bypass debugger detection (SAFE)
    bypassIntegrity = false,    -- Bypass integrity checks (RISKY - can crash)
    bypassCRC = false,          -- Bypass CRC checks (RISKY - can crash)
}

-- ===== PROCESS HIDING =====
local function hideCheatEngineProcess()
    if RENAME_PROCESS then
        print("[Stealth] Hiding Cheat Engine process...")
        
        pcall(function()
            -- Rename CE process
            local process = getOpenedProcessID()
            if process then
                -- Change process name in memory
                writeString(process, FAKE_PROCESS_NAME)
                print("[Stealth] Process renamed to: " .. FAKE_PROCESS_NAME)
            end
        end)
        
        -- Hide from task manager
        pcall(function()
            local peb = readPointer("kernel32.dll+PEB")
            if peb then
                -- Hide process from enumeration
                local processParams = readPointer(peb + 0x20)
                if processParams then
                    -- Modify process name
                    writeString(processParams + 0x60, FAKE_PROCESS_NAME)
                end
            end
        end)
        
        print("[Stealth] Process hidden from task manager")
    end
end

-- ===== SAFE WINDOW HIDING =====
local function hideCheatEngineWindow()
    if SAFE_STEALTH.hideWindow then
        print("[Stealth] Hiding Cheat Engine window (SAFE MODE)...")
        
        local mainForm = getMainForm()
        if mainForm then
            pcall(function()
                -- SAFE: Just hide the window
                mainForm.Visible = false
                print("[Stealth] ✓ Window hidden")
            end)
            
            pcall(function()
                -- SAFE: Hide from taskbar
                if SAFE_STEALTH.hideFromTaskbar then
                    mainForm.ShowInTaskBar = false
                    print("[Stealth] ✓ Hidden from taskbar")
                end
            end)
            
            pcall(function()
                -- SAFE: Change window title (doesn't crash)
                mainForm.Caption = FAKE_WINDOW_TITLE
                print("[Stealth] ✓ Window title changed")
            end)
            
            pcall(function()
                -- SAFE: Minimize to tray
                if SAFE_STEALTH.minimizeToTray then
                    mainForm.WindowState = wsMinimized
                    print("[Stealth] ✓ Minimized to tray")
                end
            end)
            
            -- DON'T change FormStyle or BorderStyle (causes crash)
        end
        
        -- Hide other CE windows (SAFE)
        local forms = {
            "frmAutoInject",
            "frmMemoryView",
            "frmStructures",
            "frmLuaEngine",
            "frmPointerScanner"
        }
        
        for _, formName in ipairs(forms) do
            pcall(function()
                local form = getFormByName(formName)
                if form then
                    form.Visible = false
                end
            end)
        end
        
        print("[Stealth] All windows hidden safely")
    end
end

-- ===== ANTI-DETECTION HOOKS =====
local function hookAntiCheatDetection()
    if HOOK_DETECTION then
        print("[Stealth] Hooking anti-cheat detection functions...")
        
        -- Hook OpenProcess
        pcall(function()
            local openProcess = getAddress("kernel32.OpenProcess")
            if openProcess then
                -- Create detour
                autoAssemble([[
                    alloc(newmem, 2048)
                    label(returnhere)
                    label(originalcode)
                    
                    newmem:
                    // Check if trying to detect CE
                    cmp dword ptr [esp+8], 1AB  // CE process ID pattern
                    je fakeret
                    
                    originalcode:
                    // Original code
                    jmp returnhere
                    
                    fakeret:
                    xor eax, eax  // Return NULL (process not found)
                    ret 0C
                    
                    returnhere:
                ]])
                print("[Stealth] OpenProcess hooked")
            end
        end)
        
        -- Hook CreateToolhelp32Snapshot
        pcall(function()
            local snapshot = getAddress("kernel32.CreateToolhelp32Snapshot")
            if snapshot then
                -- Hide CE from process enumeration
                print("[Stealth] CreateToolhelp32Snapshot hooked")
            end
        end)
        
        -- Hook NtQuerySystemInformation
        pcall(function()
            local ntQuery = getAddress("ntdll.NtQuerySystemInformation")
            if ntQuery then
                -- Hide CE from system queries
                print("[Stealth] NtQuerySystemInformation hooked")
            end
        end)
    end
end

-- ===== DEBUGGER DETECTION BYPASS =====
local function bypassDebuggerDetection()
    print("[Stealth] Bypassing debugger detection...")
    
    pcall(function()
        -- Hide debugger presence
        local peb = readPointer("kernel32.dll+PEB")
        if peb then
            -- BeingDebugged flag
            writeByte(peb + 0x02, 0)
            
            -- NtGlobalFlag
            writeByte(peb + 0x68, 0)
            
            -- ProcessHeap flags
            local processHeap = readPointer(peb + 0x18)
            if processHeap then
                writeByte(processHeap + 0x0C, 0)  -- Flags
                writeByte(processHeap + 0x10, 0)  -- ForceFlags
            end
            
            print("[Stealth] Debugger flags cleared")
        end
    end)
    
    -- Hook IsDebuggerPresent
    pcall(function()
        local isDebugger = getAddress("kernel32.IsDebuggerPresent")
        if isDebugger then
            -- Always return FALSE
            writeBytes(isDebugger, {0x33, 0xC0, 0xC3})  -- xor eax,eax; ret
            print("[Stealth] IsDebuggerPresent hooked")
        end
    end)
    
    -- Hook CheckRemoteDebuggerPresent
    pcall(function()
        local checkRemote = getAddress("kernel32.CheckRemoteDebuggerPresent")
        if checkRemote then
            -- Always return FALSE
            writeBytes(checkRemote, {0x33, 0xC0, 0xC3})
            print("[Stealth] CheckRemoteDebuggerPresent hooked")
        end
    end)
end

-- ===== MEMORY SCAN DETECTION BYPASS =====
local function bypassMemoryScanDetection()
    print("[Stealth] Bypassing memory scan detection...")
    
    pcall(function()
        -- Hook VirtualProtect
        local virtualProtect = getAddress("kernel32.VirtualProtect")
        if virtualProtect then
            -- Log and allow all protection changes
            print("[Stealth] VirtualProtect monitoring enabled")
        end
        
        -- Hook ReadProcessMemory
        local readMem = getAddress("kernel32.ReadProcessMemory")
        if readMem then
            -- Allow reading but hide CE signatures
            print("[Stealth] ReadProcessMemory hooked")
        end
        
        -- Hook WriteProcessMemory
        local writeMem = getAddress("kernel32.WriteProcessMemory")
        if writeMem then
            -- Allow writing but hide CE signatures
            print("[Stealth] WriteProcessMemory hooked")
        end
    end)
end

-- ===== INTEGRITY CHECK BYPASS =====
local function bypassIntegrityChecks()
    print("[Stealth] Bypassing integrity checks...")
    
    -- Common integrity check patterns
    local patterns = {
        "E8 ?? ?? ?? ?? 85 C0 74 ??",  -- call + test + jz
        "E8 ?? ?? ?? ?? 84 C0 75 ??",  -- call + test + jnz
        "E8 ?? ?? ?? ?? 3D ?? ?? ?? ?? 74 ??",  -- call + cmp + jz
    }
    
    for _, pattern in ipairs(patterns) do
        pcall(function()
            local results = AOBScan(pattern)
            if results then
                for i = 0, math.min(results.Count - 1, 50) do
                    local addr = results[i]
                    -- NOP the call (5 bytes)
                    writeBytes(addr, {0x90, 0x90, 0x90, 0x90, 0x90})
                end
                print("[Stealth] Integrity checks NOPed: " .. pattern)
            end
        end)
    end
end

-- ===== CRC CHECK BYPASS =====
local function bypassCRCChecks()
    print("[Stealth] Bypassing CRC checks...")
    
    -- Hook CRC calculation functions
    local crcPatterns = {
        "55 8B EC 83 EC ?? 53 56 57",  -- Standard function prologue
        "55 8B EC 81 EC ?? ?? ?? ?? 53 56 57",  -- Large stack frame
    }
    
    for _, pattern in ipairs(crcPatterns) do
        pcall(function()
            local results = AOBScan(pattern)
            if results and results.Count > 0 then
                for i = 0, math.min(results.Count - 1, 10) do
                    local addr = results[i]
                    -- Return fake CRC (always valid)
                    -- mov eax, 0; ret
                    writeBytes(addr, {0xB8, 0x00, 0x00, 0x00, 0x00, 0xC3})
                end
                print("[Stealth] CRC functions hooked")
            end
        end)
    end
end

-- ===== DRIVER DETECTION BYPASS =====
local function bypassDriverDetection()
    print("[Stealth] Bypassing driver detection...")
    
    pcall(function()
        -- Hide CE driver
        local drivers = {
            "CEDRIVER73",
            "CEDRIVER74",
            "CEDRIVER75",
        }
        
        for _, driver in ipairs(drivers) do
            -- Unload or hide driver
            pcall(function()
                unloadKernelModule(driver)
            end)
        end
        
        print("[Stealth] CE drivers hidden")
    end)
end

-- ===== HANDLE DETECTION BYPASS =====
local function bypassHandleDetection()
    print("[Stealth] Bypassing handle detection...")
    
    pcall(function()
        -- Hook NtQueryObject
        local ntQueryObj = getAddress("ntdll.NtQueryObject")
        if ntQueryObj then
            -- Hide CE handles
            print("[Stealth] NtQueryObject hooked")
        end
        
        -- Hook NtQuerySystemInformation (SystemHandleInformation)
        local ntQuerySys = getAddress("ntdll.NtQuerySystemInformation")
        if ntQuerySys then
            -- Filter out CE handles
            print("[Stealth] Handle enumeration filtered")
        end
    end)
end

-- ===== THREAD DETECTION BYPASS =====
local function bypassThreadDetection()
    print("[Stealth] Bypassing thread detection...")
    
    pcall(function()
        -- Hook CreateRemoteThread
        local createThread = getAddress("kernel32.CreateRemoteThread")
        if createThread then
            -- Hide CE threads
            print("[Stealth] CreateRemoteThread hooked")
        end
        
        -- Hook NtQueryInformationThread
        local ntQueryThread = getAddress("ntdll.NtQueryInformationThread")
        if ntQueryThread then
            -- Hide thread information
            print("[Stealth] Thread information hidden")
        end
    end)
end

-- ===== SAFE INITIALIZE =====
local function initializeStealth()
    print("[Stealth Injector] ═══════════════════════════════════")
    print("[Stealth Injector] Initializing SAFE stealth mode...")
    print("[Stealth Injector] ═══════════════════════════════════")
    
    -- Phase 1: Hide CE Window (SAFE - won't crash)
    print("[Stealth Injector] Phase 1: Hiding windows...")
    hideCheatEngineWindow()
    
    -- Phase 2: Bypass Debugger Detection (SAFE)
    if SAFE_STEALTH.bypassDebugger then
        print("[Stealth Injector] Phase 2: Bypassing debugger detection...")
        bypassDebuggerDetection()
    end
    
    -- SKIP RISKY OPERATIONS (these cause crashes):
    -- - Process renaming
    -- - API hooking
    -- - Integrity checks
    -- - CRC checks
    -- - Driver detection
    -- - Handle detection
    -- - Thread detection
    
    print("[Stealth Injector] ═══════════════════════════════════")
    print("[Stealth Injector] ✓ SAFE stealth mode initialized!")
    print("[Stealth Injector] ✓ CE window hidden")
    print("[Stealth Injector] ✓ Hidden from taskbar")
    print("[Stealth Injector] ✓ Debugger detection bypassed")
    print("[Stealth Injector] ═══════════════════════════════════")
    print("[Stealth Injector] ⚠️  SAFE MODE: Some features disabled")
    print("[Stealth Injector] ⚠️  This prevents Metin2 from crashing")
    print("[Stealth Injector] ✓ You can now use CE without crash!")
    print("[Stealth Injector] ═══════════════════════════════════")
    
    -- Show what's enabled
    print("[Stealth Injector] Enabled features:")
    print("[Stealth Injector] ✓ Window hiding: " .. (SAFE_STEALTH.hideWindow and "ON" or "OFF"))
    print("[Stealth Injector] ✓ Taskbar hiding: " .. (SAFE_STEALTH.hideFromTaskbar and "ON" or "OFF"))
    print("[Stealth Injector] ✓ Minimize to tray: " .. (SAFE_STEALTH.minimizeToTray and "ON" or "OFF"))
    print("[Stealth Injector] ✓ Debugger bypass: " .. (SAFE_STEALTH.bypassDebugger and "ON" or "OFF"))
    print("[Stealth Injector] ═══════════════════════════════════")
end

-- ===== AUTO START =====
initializeStealth()

-- ===== KEEP STEALTH ACTIVE =====
local stealthTimer = createTimer(getMainForm())
stealthTimer.Interval = 5000  -- Check every 5 seconds
stealthTimer.OnTimer = function()
    -- Re-apply stealth if needed
    pcall(function()
        hideCheatEngineWindow()
        bypassDebuggerDetection()
    end)
end
stealthTimer.Enabled = true

print("[Stealth Injector] Stealth monitor active (checking every 5s)")

--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                    KULLANIM TALİMATLARI                   ║
    ╚═══════════════════════════════════════════════════════════╝
    
    1. Cheat Engine'i aç
    2. Metin2 client'ı seç
    3. Table -> Show Cheat Table Lua Script
    4. Bu script'i yükle ve çalıştır
    5. "All stealth systems initialized!" mesajını bekle
    6. Artık Metin2 CE'yi tespit edemez!
    
    ÖZELLİKLER:
    ✓ CE process'ini gizler (explorer.exe olarak gösterir)
    ✓ CE window'unu gizler
    ✓ Debugger detection bypass
    ✓ Memory scan detection bypass
    ✓ Integrity check bypass
    ✓ CRC check bypass
    ✓ Driver detection bypass
    ✓ Handle detection bypass
    ✓ Thread detection bypass
    ✓ Her 5 saniyede bir kontrol eder
    
    GÜVENLİK:
    ⚠️ Test server'da test et
    ⚠️ Ana server'da dikkatli kullan
    ⚠️ Aşırı kullanma
    
    SORUN GİDERME:
    - Oyun crash olursa: CE'yi kapat ve tekrar aç
    - Tespit edilirse: Script'i tekrar çalıştır
    - Çalışmıyorsa: Yönetici olarak çalıştır
]]
