--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║               Tank Battle GUI v2.0                         ║
    ║                  by Lahmacun581                            ║
    ║      Speed Boost | Rapid Fire | Aim Assist | Remote Scan  ║
    ╚═══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function safeDisconnect(conn)
    if conn and typeof(conn.Disconnect) == "function" then
        pcall(function()
            conn:Disconnect()
        end)
    end
end

local function cleanup()
    if getgenv().TankBattle then
        getgenv().TankBattle.Running = false

        if getgenv().TankBattle.ScreenGui then
            pcall(function()
                getgenv().TankBattle.ScreenGui:Destroy()
            end)
            getgenv().TankBattle.ScreenGui = nil
        end

        if getgenv().TankBattle.Connections then
            for _, conn in ipairs(getgenv().TankBattle.Connections) do
                safeDisconnect(conn)
            end
        end

        getgenv().TankBattle.Connections = {}
        getgenv().TankBattle.Remotes = {}
    end
end

cleanup()

getgenv().TankBattle = {
    Version = "2.0",
    Enabled = {
        SpeedBoost = false,
        RapidFire = false,
        AimAssist = false,
        AutoFire = false,
        BypassMode = false,
        ESP = false
    },
    Values = {
        SpeedBoost = 2,
        RapidFireDelay = 0.12,
        AimFOV = 250,
        BypassDelay = 0.12
    },
    Original = {
        WalkSpeed = nil,
        VehicleSpeed = nil
    },
    Remotes = {},
    Connections = {},
    ESPItems = {},
    Status = "Ready",
    Running = true
}

local function setStatus(text)
    if getgenv().TankBattle then
        getgenv().TankBattle.Status = text
        if getgenv().TankBattle.StatusLabel then
            pcall(function()
                getgenv().TankBattle.StatusLabel.Text = "Status: " .. text
            end)
        end
    end
end

local function createGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TankBattleGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    getgenv().TankBattle.ScreenGui = screenGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 560, 0, 480)
    mainFrame.Position = UDim2.new(0.5, -280, 0.5, -240)
    mainFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 48)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Tank Battle Hub v2.0"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 34, 0, 34)
    closeBtn.Position = UDim2.new(1, -44, 0, 7)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 10)
    closeCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        cleanup()
        screenGui:Destroy()
    end)

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -24, 1, -88)
    content.Position = UDim2.new(0, 12, 0, 60)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = content

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 4)
    contentPadding.PaddingLeft = UDim.new(0, 4)
    contentPadding.PaddingRight = UDim.new(0, 4)
    contentPadding.Parent = content

    local function createSection(title)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, 0, 0, 0)
        section.AutomaticSize = Enum.AutomaticSize.Y
        section.BackgroundColor3 = Color3.fromRGB(23, 25, 32)
        section.BorderSizePixel = 0
        section.Parent = content

        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 12)
        sectionCorner.Parent = section

        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, 0, 0, 34)
        header.BackgroundTransparency = 1
        header.Parent = section

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -16, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = Color3.fromRGB(220, 220, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = header

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 8)
        list.Parent = section
        list.SortOrder = Enum.SortOrder.LayoutOrder

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 38)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.Parent = section

        return section
    end

    local function createButton(parent, text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.Parent = parent

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            pcall(callback)
        end)

        return btn
    end

    local function createToggle(parent, text, default, callback)
        local enabled = default
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = enabled and Color3.fromRGB(95, 205, 110) or Color3.fromRGB(120, 120, 140)
        btn.BorderSizePixel = 0
        btn.Text = text .. " : " .. (enabled and "ON" or "OFF")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.Parent = parent

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            btn.BackgroundColor3 = enabled and Color3.fromRGB(95, 205, 110) or Color3.fromRGB(120, 120, 140)
            btn.Text = text .. " : " .. (enabled and "ON" or "OFF")
            callback(enabled)
        end)

        return btn
    end

    local function createSlider(parent, text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 58)
        frame.BackgroundColor3 = Color3.fromRGB(30, 35, 44)
        frame.BorderSizePixel = 0
        frame.Parent = parent

        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 10)
        frameCorner.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0, 10, 0, 6)
        label.BackgroundTransparency = 1
        label.Text = string.format("%s: %s", text, tostring(default))
        label.TextColor3 = Color3.fromRGB(220, 220, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -20, 0, 10)
        bar.Position = UDim2.new(0, 10, 0, 34)
        bar.BackgroundColor3 = Color3.fromRGB(70, 75, 90)
        bar.BorderSizePixel = 0
        bar.Parent = frame

        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(0, 6)
        barCorner.Parent = bar

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(100, 160, 255)
        fill.BorderSizePixel = 0
        fill.Parent = bar

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 6)
        fillCorner.Parent = fill

        local dragging = false

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        bar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        table.insert(getgenv().TankBattle.Connections, UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relative = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local currentValue
                if max <= 1 then
                    currentValue = math.round(min + (relative * (max - min)) * 100) / 100
                else
                    currentValue = math.floor(min + (relative * (max - min)))
                end
                fill.Size = UDim2.new(relative, 0, 1, 0)
                label.Text = string.format("%s: %s", text, tostring(currentValue))
                callback(currentValue)
            end
        end))

        return frame
    end

    local controlsSection = createSection("Vehicle Controls")
    local combatSection = createSection("Combat Utilities")
    local miscSection = createSection("Utility")

    createToggle(controlsSection, "Speed Boost", false, function(enabled)
        getgenv().TankBattle.Enabled.SpeedBoost = enabled
        setStatus(enabled and "Speed boost enabled" or "Speed boost disabled")
    end)

    createSlider(controlsSection, "Speed Multiplier", 1, 5, getgenv().TankBattle.Values.SpeedBoost, function(value)
        getgenv().TankBattle.Values.SpeedBoost = value
        setStatus("Speed multiplier set to " .. tostring(value))
    end)

    createToggle(combatSection, "Rapid Fire", false, function(enabled)
        getgenv().TankBattle.Enabled.RapidFire = enabled
        if enabled then
            setStatus("Rapid fire enabled")
        else
            setStatus("Rapid fire disabled")
        end
    end)

    createSlider(combatSection, "Fire Delay", 0.05, 1, getgenv().TankBattle.Values.RapidFireDelay, function(value)
        getgenv().TankBattle.Values.RapidFireDelay = math.max(value, 0.05)
        setStatus("Fire delay set to " .. string.format("%.2f", getgenv().TankBattle.Values.RapidFireDelay))
    end)

    createToggle(combatSection, "Aim Assist", false, function(enabled)
        getgenv().TankBattle.Enabled.AimAssist = enabled
        setStatus(enabled and "Aim assist enabled" or "Aim assist disabled")
    end)

    createSlider(combatSection, "Aim FOV", 100, 500, getgenv().TankBattle.Values.AimFOV, function(value)
        getgenv().TankBattle.Values.AimFOV = value
        setStatus("Aim FOV set to " .. tostring(value))
    end)

    createToggle(combatSection, "Auto Fire", false, function(enabled)
        getgenv().TankBattle.Enabled.AutoFire = enabled
        setStatus(enabled and "Auto fire enabled" or "Auto fire disabled")
    end)

    createToggle(combatSection, "Bypass Mode", false, function(enabled)
        getgenv().TankBattle.Enabled.BypassMode = enabled
        setStatus(enabled and "Bypass mode enabled" or "Bypass mode disabled")
    end)

    createSlider(combatSection, "Bypass Delay", 0.05, 0.5, getgenv().TankBattle.Values.BypassDelay, function(value)
        getgenv().TankBattle.Values.BypassDelay = math.max(value, 0.05)
        setStatus("Bypass delay set to " .. string.format("%.2f", getgenv().TankBattle.Values.BypassDelay))
    end)

    local function scanRemotes()
        local scanned = {}
        local found = {}
        local roots = {
            workspace,
            game:GetService("ReplicatedStorage"),
            game:GetService("StarterGui"),
            game:GetService("Players")
        }
        local patterns = {"fire", "shoot", "shell", "attack", "tank", "weapon", "gun", "fireserver", "invoke"}

        for _, root in ipairs(roots) do
            if root then
                for _, obj in ipairs(root:GetDescendants()) do
                    if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and not found[obj] then
                        local name = obj.Name:lower()
                        for _, pattern in ipairs(patterns) do
                            if string.find(name, pattern, 1, true) then
                                table.insert(scanned, obj)
                                found[obj] = true
                                break
                            end
                        end
                    end
                end
            end
        end

        return scanned
    end

    createButton(combatSection, "Scan Tank Remotes", Color3.fromRGB(255, 170, 60), function()
        getgenv().TankBattle.Remotes = scanRemotes()
        setStatus(string.format("Scanned %d remotes", #getgenv().TankBattle.Remotes))
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Tank Battle",
                Text = string.format("Found %d likely tank remotes", #getgenv().TankBattle.Remotes),
                Duration = 3
            })
        end)
    end)

    createButton(combatSection, "Clear Remote List", Color3.fromRGB(120, 120, 140), function()
        getgenv().TankBattle.Remotes = {}
        setStatus("Remote list cleared")
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Tank Battle",
                Text = "Remote list cleared.",
                Duration = 2
            })
        end)
    end)

    createButton(miscSection, "Teleport to Nearest Enemy", Color3.fromRGB(100, 170, 255), function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            return
        end

        local myPos = char.HumanoidRootPart.Position
        local nearest, nearestDist = nil, math.huge

        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (target.Character.HumanoidRootPart.Position - myPos).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = target
                end
            end
        end

        if nearest and nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = nearest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, -6)
            setStatus("Teleported near target")
        end
    end)

    createToggle(miscSection, "ESP Overlay", false, function(enabled)
        getgenv().TankBattle.Enabled.ESP = enabled
        setStatus(enabled and "ESP enabled" or "ESP disabled")
    end)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 26)
    statusLabel.Position = UDim2.new(0, 10, 1, -36)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: Ready"
    statusLabel.TextColor3 = Color3.fromRGB(190, 190, 255)
    statusLabel.TextSize = 13
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = mainFrame
    getgenv().TankBattle.StatusLabel = statusLabel

    local function restoreSpeed(char)
        if not char then return end
        if char:FindFirstChild("Humanoid") and getgenv().TankBattle.Original.WalkSpeed then
            pcall(function()
                char.Humanoid.WalkSpeed = getgenv().TankBattle.Original.WalkSpeed
            end)
        end
        local vehicleSeat = char:FindFirstChildOfClass("VehicleSeat")
        if vehicleSeat and getgenv().TankBattle.Original.VehicleSpeed then
            pcall(function()
                vehicleSeat.MaxSpeed = getgenv().TankBattle.Original.VehicleSpeed
            end)
        end
    end

    table.insert(getgenv().TankBattle.Connections, RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            return
        end

        if getgenv().TankBattle.Enabled.SpeedBoost then
            if char:FindFirstChild("Humanoid") and not getgenv().TankBattle.Original.WalkSpeed then
                getgenv().TankBattle.Original.WalkSpeed = char.Humanoid.WalkSpeed
            end

            local vehicleSeat = char:FindFirstChildOfClass("VehicleSeat") or char:FindFirstChildOfClass("Seat")
            if vehicleSeat and vehicleSeat:IsA("VehicleSeat") then
                if not getgenv().TankBattle.Original.VehicleSpeed then
                    getgenv().TankBattle.Original.VehicleSpeed = vehicleSeat.MaxSpeed
                end
                pcall(function()
                    vehicleSeat.MaxSpeed = 70 * getgenv().TankBattle.Values.SpeedBoost
                end)
            elseif char:FindFirstChild("Humanoid") then
                pcall(function()
                    char.Humanoid.WalkSpeed = 16 * getgenv().TankBattle.Values.SpeedBoost
                end)
            end
        elseif char and not getgenv().TankBattle.Enabled.SpeedBoost then
            restoreSpeed(char)
        end

        if getgenv().TankBattle.Enabled.AimAssist then
            local camera = workspace.CurrentCamera
            if camera then
                local root = char.HumanoidRootPart
                local myPos = root.Position
                local bestTarget, bestDistance = nil, math.huge

                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPos = target.Character.HumanoidRootPart.Position
                        local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
                        if onScreen then
                            local mousePos = UserInputService:GetMouseLocation()
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if dist < bestDistance and dist < getgenv().TankBattle.Values.AimFOV then
                                bestDistance = dist
                                bestTarget = target
                            end
                        end
                    end
                end

                if bestTarget and bestTarget.Character and bestTarget.Character:FindFirstChild("HumanoidRootPart") then
                    local lookPos = bestTarget.Character.HumanoidRootPart.Position
                    local targetCFrame = CFrame.new(myPos, lookPos)
                    root.CFrame = root.CFrame:Lerp(targetCFrame, 0.2)
                end
            end
        end

        if getgenv().TankBattle.Enabled.ESP then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local bill = getgenv().TankBattle.ESPItems[player]
                    if not bill then
                        bill = Instance.new("BillboardGui")
                        bill.Size = UDim2.new(0, 180, 0, 40)
                        bill.AlwaysOnTop = true
                        bill.Adornee = player.Character.HumanoidRootPart
                        bill.Parent = screenGui

                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.fromRGB(255, 255, 255)
                        text.TextStrokeTransparency = 0.6
                        text.TextScaled = true
                        text.Font = Enum.Font.GothamBold
                        text.Parent = bill

                        getgenv().TankBattle.ESPItems[player] = bill
                    end
                    local dist = math.floor((player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
                    local label = bill:FindFirstChildOfClass("TextLabel")
                    if label then
                        label.Text = player.Name .. " - " .. dist .. "m"
                    end
                end
            end
        else
            for player, bill in pairs(getgenv().TankBattle.ESPItems) do
                if bill then
                    bill:Destroy()
                end
            end
            getgenv().TankBattle.ESPItems = {}
        end
    end))

    task.spawn(function()
        while getgenv().TankBattle and getgenv().TankBattle.Running do
            if (getgenv().TankBattle.Enabled.RapidFire or getgenv().TankBattle.Enabled.AutoFire) and #getgenv().TankBattle.Remotes > 0 then
                for _, remote in ipairs(getgenv().TankBattle.Remotes) do
                    if not getgenv().TankBattle.Running then
                        break
                    end
                    if remote and remote.Parent then
                        pcall(function()
                            if remote:IsA("RemoteEvent") then
                                remote:FireServer()
                            elseif remote:IsA("RemoteFunction") then
                                remote:InvokeServer()
                            end
                        end)
                    end
                end
            end

            local delay = getgenv().TankBattle.Values.RapidFireDelay
            if getgenv().TankBattle.Enabled.BypassMode then
                delay = delay + math.random() * getgenv().TankBattle.Values.BypassDelay
            end
            if delay < 0.05 then delay = 0.05 end
            task.wait(delay)
            if not getgenv().TankBattle.Enabled.RapidFire and not getgenv().TankBattle.Enabled.AutoFire then
                task.wait(0.1)
            end
        end
    end)

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Tank Battle",
            Text = "Tank Battle Hub loaded.",
            Duration = 3
        })
    end)
end

createGui()
print("[TankBattle] Loaded v2.0")
