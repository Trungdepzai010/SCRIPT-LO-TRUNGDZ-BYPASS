-- ============================================================
-- TrungDz — BYPASSED ez Free
-- ============================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StatsService = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local player = LocalPlayer
local camera = workspace.CurrentCamera

local function checkFarmOK() return workspace:FindFirstChild("Computers") ~= nil end

local parent = nil
pcall(function() parent = gethui and gethui() or CoreGui end)
if not parent then parent = LocalPlayer:WaitForChild("PlayerGui") end
if parent:FindFirstChild("KhangLeCustomTuner") then parent.KhangLeCustomTuner:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhangLeCustomTuner"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = parent

local function makeHeaderDraggable(header, frame)
    header.Active = true
    local dragging, dragInput, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local HUB_BG    = Color3.fromRGB(10, 14, 22)
local HUB_SIDE  = Color3.fromRGB(14, 20, 32)
local CARD_BG   = Color3.fromRGB(18, 26, 40)
local themeColor = Color3.fromRGB(0, 229, 160)
local ACCENT2   = Color3.fromRGB(56, 189, 248)
local TXT_DIM   = Color3.fromRGB(150, 165, 185)

local function rainbowAt(t)
    return Color3.fromHSV((t * 0.06) % 1, 1, 1)
end

local menuRainbow = true
local menuFixedColor = Color3.fromRGB(0, 229, 160)
local floatRainbow = true
local floatFixedColor = Color3.fromRGB(0, 229, 160)
local floatRGB = {}

local function addRGBStroke(btn)
    local s = Instance.new("UIStroke", btn)
    s.Name = "RGB"; s.Thickness = 2.4
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Transparency = 0; s.Color = rainbowAt(0)
    table.insert(floatRGB, s)
    return s
end

local ControlPanel, freecamMenuFrame, hideFloatBtn
local HubFrame, hubClose, hubHeader, hubStroke, statPanel
local farmSwitch, farmNote
local bodyOpenBtn, fcOpenBtn
local ToggleFloatMenuBtn
local lblStat1, lblStat2, lblTime, lblWork, lblRPNow, lblRPEarned
local farmRPStart = 0
local lastRPValue = 0
local afkActive = false
local afkStartTime = 0
local afkRPStart = 0
local afkOverlay, afkTimeLbl, afkRPNowLbl, afkRPEarnedLbl
local AFK_FPS = 15
local showAutoTFloat = false
local farmOffice = false
local ofAnswers, ofPrints = 0, 0
local activeMode, farmStart = nil, 0
local antiAfk, optFPS = true, false

do
    local vu = game:GetService("VirtualUser")
    local lp = game:GetService("Players").LocalPlayer
    lp.Idled:Connect(function()
        if not antiAfk then return end
        pcall(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new(0, 0))
            task.wait(0.5)
            vu:ReleaseController()
        end)
    end)
    task.spawn(function()
        while true do
            task.wait(240)
            if antiAfk then
                pcall(function()
                    local cam = workspace.CurrentCamera
                    if cam then cam.CFrame = cam.CFrame * CFrame.Angles(0, 0.0001, 0) end
                end)
            end
        end
    end)
end
_G._officeStop = nil

local function makeFloatBtn(icon, color, yPos)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 48, 0, 48); b.Position = UDim2.new(0, 25, yPos, 0)
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15); b.TextColor3 = color
    b.Text = icon; b.TextSize = 22; b.Font = Enum.Font.GothamBold
    b.Draggable = true; b.ZIndex = 10; b.Parent = ScreenGui
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    return b
end

local ToggleBtn = makeFloatBtn("👑", themeColor, 0.4)
local AutoTFloatingBtn = makeFloatBtn("🕹️", Color3.fromRGB(255, 100, 0), 0.53); AutoTFloatingBtn.Visible = false
local BodyManagerFloatingBtn = makeFloatBtn("🚗", Color3.fromRGB(0, 230, 180), 0.66); BodyManagerFloatingBtn.Visible = false
local FreecamFloatingBtn = makeFloatBtn("📷", Color3.fromRGB(255, 255, 255), 0.79); FreecamFloatingBtn.Visible = false

task.spawn(function()
    local t = 0
    while true do
        task.wait(0.03); t = t + 0.15
        local cMenu, cFloat
        if menuRainbow then cMenu = rainbowAt(t) else cMenu = menuFixedColor end
        if floatRainbow then cFloat = rainbowAt(t) else cFloat = floatFixedColor end
        if hubStroke and hubStroke.Parent then
            hubStroke.Color = cMenu
            if hubHeader then hubHeader.TextColor3 = cMenu end
            if ToggleBtn then ToggleBtn.TextColor3 = cMenu end
        end
        for _, s in ipairs(floatRGB) do
            if s and s.Parent then s.Color = cFloat; s.Transparency = 0 end
        end
    end
end)

do
    statPanel = Instance.new("Frame")
    statPanel.Size = UDim2.new(0, 250, 0, 165)
    statPanel.Position = UDim2.new(0, 76, 0.5, 20)
    statPanel.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
    statPanel.BackgroundTransparency = 0.15
    statPanel.BorderSizePixel = 0
    statPanel.Active = true; statPanel.Draggable = true
    statPanel.Visible = false; statPanel.ZIndex = 9
    statPanel.Parent = ScreenGui
    Instance.new("UICorner", statPanel).CornerRadius = UDim.new(0, 10)
    local so = Instance.new("UIStroke", statPanel)
    so.Name = "RainbowBorder"; so.Thickness = 2
    so.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; so.Color = rainbowAt(0)
    task.spawn(function()
        local t = 0
        while true do task.wait(0.03); t = t + 0.15
            if so and so.Parent then so.Color = rainbowAt(t) end
        end
    end)
    local t1 = Instance.new("TextLabel", statPanel)
    t1.Size = UDim2.new(1, -20, 0, 24); t1.Position = UDim2.new(0, 10, 0, 4)
    t1.BackgroundTransparency = 1; t1.Text = "🌾 Office Status"
    t1.TextColor3 = Color3.fromRGB(255, 140, 40); t1.TextSize = 13
    t1.Font = Enum.Font.GothamBold; t1.TextXAlignment = Enum.TextXAlignment.Left; t1.ZIndex = 10
    local function sl(y)
        local l = Instance.new("TextLabel", statPanel)
        l.Size = UDim2.new(1, -20, 0, 18); l.Position = UDim2.new(0, 10, 0, y)
        l.BackgroundTransparency = 1; l.Text = ""
        l.TextColor3 = Color3.fromRGB(200, 220, 240); l.TextSize = 11
        l.Font = Enum.Font.GothamMedium; l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd; l.ZIndex = 10
        return l
    end
    lblStat1 = sl(32); lblStat2 = sl(50); lblTime = sl(68)
    lblRPNow = sl(90); lblRPNow.TextColor3 = Color3.fromRGB(120, 220, 255)
    lblRPEarned = sl(108); lblRPEarned.TextColor3 = Color3.fromRGB(0, 255, 120)
    lblWork = sl(130); lblWork.TextColor3 = Color3.fromRGB(255, 200, 80)
end

local function setStatus(t) if lblWork then lblWork.Text = "📍 " .. t end end
local function fmtTime(s)
    s = math.floor(s)
    local h = math.floor(s / 3600); local m = math.floor((s % 3600) / 60); local sec = s % 60
    if h > 0 then return string.format("%d:%02d:%02d", h, m, sec) end
    return string.format("%02d:%02d", m, sec)
end
local function refreshStatPanel()
    if activeMode == "office" then
        lblStat1.Text = "🧮 Lượt giải: " .. ofAnswers
        lblStat2.Text = "🖨️ Lượt in: " .. ofPrints
    end
end
local function getRP()
    local pd = game.Players.LocalPlayer:FindFirstChild("PlayerData")
    local rp = pd and pd:FindFirstChild("RPValue")
    return rp and rp.Value or nil
end
local function fmtRP(n)
    if not n then return "--" end
    if n >= 1e9 then return string.format("%.2fB", n / 1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n / 1e6)
    elseif n >= 1e3 then return string.format("%.1fK", n / 1e3)
    else return tostring(math.floor(n)) end
end

local _popupTS = nil
local function spawnRPPopup(delta)
    if not statPanel or not statPanel.Parent or not lblRPEarned then return end
    if not _popupTS then _popupTS = game:GetService("TextService") end
    local textW = 200
    pcall(function()
        local sz = _popupTS:GetTextSize(lblRPEarned.Text, lblRPEarned.TextSize, lblRPEarned.Font, Vector2.new(1000, 20))
        textW = sz.X
    end)
    local startX = 10 + textW + 6
    local popup = Instance.new("TextLabel", statPanel)
    popup.Size = UDim2.new(0, 120, 0, 18); popup.Position = UDim2.new(0, startX, 0, 108)
    popup.BackgroundTransparency = 1; popup.Text = "+" .. fmtRP(delta)
    popup.TextColor3 = Color3.fromRGB(0, 255, 120); popup.TextSize = lblRPEarned.TextSize - 1
    popup.Font = lblRPEarned.Font; popup.TextXAlignment = Enum.TextXAlignment.Left
    popup.TextStrokeTransparency = 0.4; popup.TextStrokeColor3 = Color3.fromRGB(0, 60, 0); popup.ZIndex = 20
    task.spawn(function()
        local dur = 1.2; local t0 = os.clock()
        while popup and popup.Parent do
            local t = math.min((os.clock() - t0) / dur, 1)
            local ease = t * t
            popup.Position = UDim2.new(0, startX, 0, 108 - 14 * ease)
            popup.TextTransparency = ease; popup.TextStrokeTransparency = 0.4 + 0.6 * ease
            if t >= 1 then break end
            task.wait(0.03)
        end
        if popup then popup:Destroy() end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            if activeMode == "office" and farmStart > 0 then
                if lblTime then lblTime.Text = "⏱ Thời gian: " .. fmtTime(os.clock() - farmStart) end
                local rp = getRP()
                if rp then
                    if lblRPNow then lblRPNow.Text = "💰 Hiện tại: " .. fmtRP(rp) end
                    local earned = rp - farmRPStart
                    if lblRPEarned then lblRPEarned.Text = "📈 Farm được: +" .. fmtRP(earned) end
                    if lastRPValue > 0 and rp > lastRPValue then pcall(spawnRPPopup, rp - lastRPValue) end
                    lastRPValue = rp
                end
            end
        end)
    end
end)

local perfOn, perfLocked = false, false
local perfFrame = Instance.new("Frame")
perfFrame.Size = UDim2.new(0, 160, 0, 40); perfFrame.Position = UDim2.new(1, -170, 0, 96)
perfFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12); perfFrame.BackgroundTransparency = 0.35
perfFrame.BorderSizePixel = 0; perfFrame.Visible = false; perfFrame.ZIndex = 50
perfFrame.Active = true; perfFrame.Draggable = true; perfFrame.Parent = ScreenGui
Instance.new("UICorner", perfFrame).CornerRadius = UDim.new(0, 8)
local perfLabel = Instance.new("TextLabel", perfFrame)
perfLabel.Size = UDim2.new(1, -12, 1, -8); perfLabel.Position = UDim2.new(0, 6, 0, 4)
perfLabel.BackgroundTransparency = 1; perfLabel.Text = "FPS: -- | Ping: --"
perfLabel.TextColor3 = Color3.fromRGB(140, 255, 140); perfLabel.TextSize = 11
perfLabel.Font = Enum.Font.GothamBold; perfLabel.TextXAlignment = Enum.TextXAlignment.Left; perfLabel.ZIndex = 51

local function getPing()
    local p = 0
    pcall(function() p = StatsService:GetNetworkPing() end)
    if (not p) or p <= 0 then pcall(function() p = player:GetNetworkPing() end) end
    if p and p > 0 and p < 1 then p = p * 1000 end
    return math.floor(p or 0)
end
local fpsFrames = 0
RunService.RenderStepped:Connect(function() fpsFrames = fpsFrames + 1 end)

do
    afkOverlay = Instance.new("Frame", ScreenGui)
    afkOverlay.Size = UDim2.new(1, 0, 1, 0); afkOverlay.Position = UDim2.new(0, 0, 0, 0)
    afkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0); afkOverlay.BorderSizePixel = 0
    afkOverlay.ZIndex = 9999; afkOverlay.Visible = false

    local t1 = Instance.new("TextLabel", afkOverlay)
    t1.Size = UDim2.new(1, 0, 0, 36); t1.Position = UDim2.new(0, 0, 0, 60)
    t1.BackgroundTransparency = 1; t1.Text = "🌙 CHẾ ĐỘ TREO MÁY"
    t1.TextColor3 = Color3.fromRGB(120, 220, 255); t1.TextSize = 22; t1.Font = Enum.Font.GothamBold; t1.ZIndex = 10000

    afkTimeLbl = Instance.new("TextLabel", afkOverlay)
    afkTimeLbl.Size = UDim2.new(1, 0, 0, 30); afkTimeLbl.Position = UDim2.new(0, 0, 0, 120)
    afkTimeLbl.BackgroundTransparency = 1; afkTimeLbl.Text = "⏱ 00:00"
    afkTimeLbl.TextColor3 = Color3.fromRGB(200, 200, 220); afkTimeLbl.TextSize = 18; afkTimeLbl.Font = Enum.Font.GothamBold; afkTimeLbl.ZIndex = 10000

    afkRPNowLbl = Instance.new("TextLabel", afkOverlay)
    afkRPNowLbl.Size = UDim2.new(1, 0, 0, 30); afkRPNowLbl.Position = UDim2.new(0, 0, 0, 160)
    afkRPNowLbl.BackgroundTransparency = 1; afkRPNowLbl.Text = "💰 Hiện tại: --"
    afkRPNowLbl.TextColor3 = Color3.fromRGB(120, 220, 255); afkRPNowLbl.TextSize = 16; afkRPNowLbl.Font = Enum.Font.GothamBold; afkRPNowLbl.ZIndex = 10000

    afkRPEarnedLbl = Instance.new("TextLabel", afkOverlay)
    afkRPEarnedLbl.Size = UDim2.new(1, 0, 0, 30); afkRPEarnedLbl.Position = UDim2.new(0, 0, 0, 192)
    afkRPEarnedLbl.BackgroundTransparency = 1; afkRPEarnedLbl.Text = "📈 Kiếm: +0"
    afkRPEarnedLbl.TextColor3 = Color3.fromRGB(0, 255, 120); afkRPEarnedLbl.TextSize = 16; afkRPEarnedLbl.Font = Enum.Font.GothamBold; afkRPEarnedLbl.ZIndex = 10000

    local stopBtn = Instance.new("TextButton", afkOverlay)
    stopBtn.Size = UDim2.new(0, 180, 0, 44); stopBtn.Position = UDim2.new(0.5, -90, 0, 260)
    stopBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 60); stopBtn.Text = "TẮT TREO MÁY"
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255); stopBtn.TextSize = 14; stopBtn.Font = Enum.Font.GothamBold; stopBtn.ZIndex = 10000
    Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 10)

    stopBtn.MouseButton1Click:Connect(function()
        afkActive = false; afkOverlay.Visible = false
        if writefile then pcall(writefile, "afkMode.txt", "0") end
        if _G._setAFKToggle then _G._setAFKToggle(false) end
    end)
end

function _G.startAFK()
    afkActive = true; afkStartTime = os.clock(); afkRPStart = getRP() or 0
    if afkOverlay then afkOverlay.Visible = true end
    if HubFrame then HubFrame.Visible = false end
    if freecamMenuFrame then freecamMenuFrame.Visible = false end
    if writefile then pcall(writefile, "afkMode.txt", "1") end
end

function _G.stopAFK()
    afkActive = false
    if afkOverlay then afkOverlay.Visible = false end
    if writefile then pcall(writefile, "afkMode.txt", "0") end
end

task.spawn(function()
    while true do task.wait(0.5)
        if afkActive and afkTimeLbl then
            afkTimeLbl.Text = "⏱ " .. fmtTime(os.clock() - afkStartTime)
            local rp = getRP()
            if rp then
                afkRPNowLbl.Text = "💰 Hiện tại: " .. fmtRP(rp)
                afkRPEarnedLbl.Text = "📈 Kiếm: +" .. fmtRP(rp - afkRPStart)
            end
        end
    end
end)

task.spawn(function()
    while true do task.wait(1)
        local fps = fpsFrames; fpsFrames = 0
        if perfOn then perfLabel.Text = string.format("FPS: %d | Ping: %dms", fps, getPing()) end
    end
end)

local hideNameOn, customName = false, ""
local function getChar() return LocalPlayer.Character end
local function hideNameTags()
    local c = getChar(); if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end) end
    for _, d in ipairs(c:GetDescendants()) do
        if d:IsA("BillboardGui") then pcall(function() d.Enabled = false end) end
    end
end
local function showNameTags()
    local c = getChar(); if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer end) end
    for _, d in ipairs(c:GetDescendants()) do
        if d:IsA("BillboardGui") then pcall(function() d.Enabled = true end) end
    end
end
local function applyCustomName()
    local c = getChar(); if not c then return end
    pcall(function() LocalPlayer.DisplayName = customName end)
    local myName = LocalPlayer.Name
    for _, d in ipairs(c:GetDescendants()) do
        if d:IsA("BillboardGui") then
            for _, t in ipairs(d:GetDescendants()) do
                if t:IsA("TextLabel") and t.Text:find(myName, 1, true) then t.Text = customName end
            end
        end
    end
end
local function watchChar(c)
    if not c then return end
    c.DescendantAdded:Connect(function(d)
        if d:IsA("BillboardGui") then
            if hideNameOn then pcall(function() d.Enabled = false end) end
            if customName ~= "" then task.wait(0.2); applyCustomName() end
        end
    end)
end
LocalPlayer.CharacterAdded:Connect(function(c)
    watchChar(c); task.wait(0.5)
    if hideNameOn then hideNameTags() end
    if customName ~= "" then applyCustomName() end
end)
if LocalPlayer.Character then watchChar(LocalPlayer.Character) end
task.spawn(function()
    while true do task.wait(1)
        if hideNameOn then hideNameTags() end
    end
end)

-- ============================================================
-- KHỞI TẠO GIAO DIỆN & TẤT CẢ LOGIC GỐC
-- ============================================================
do
    HubFrame = Instance.new("Frame")
    HubFrame.Size = UDim2.new(0, 480, 0, 350)
    HubFrame.Position = UDim2.new(0.5, -240, 0.5, -175)
    HubFrame.BackgroundColor3 = HUB_SIDE
    HubFrame.BorderSizePixel = 0; HubFrame.Active = true; HubFrame.Visible = false
    HubFrame.ClipsDescendants = false; HubFrame.ZIndex = 8; HubFrame.Parent = ScreenGui
    Instance.new("UICorner", HubFrame).CornerRadius = UDim.new(0, 12)
    hubStroke = Instance.new("UIStroke", HubFrame)
    hubStroke.Color = rainbowAt(0); hubStroke.Thickness = 1.5; hubStroke.Transparency = 0.25

    hubHeader = Instance.new("TextLabel", HubFrame)
    hubHeader.Size = UDim2.new(1, -40, 0, 34); hubHeader.Position = UDim2.new(0, 12, 0, 0)
    hubHeader.BackgroundTransparency = 1; hubHeader.Text = "👑 KHANGLE DDS HUB"
    hubHeader.TextColor3 = rainbowAt(0); hubHeader.TextSize = 13
    hubHeader.Font = Enum.Font.GothamBold; hubHeader.TextXAlignment = Enum.TextXAlignment.Left
    hubHeader.ZIndex = 18
    makeHeaderDraggable(hubHeader, HubFrame)

    hubClose = Instance.new("TextButton", HubFrame)
    hubClose.Size = UDim2.new(0, 26, 0, 26); hubClose.Position = UDim2.new(1, -30, 0, 4)
    hubClose.BackgroundTransparency = 1; hubClose.TextColor3 = TXT_DIM
    hubClose.Text = "✕"; hubClose.TextSize = 14; hubClose.Font = Enum.Font.GothamBold; hubClose.ZIndex = 19

    local sidebar = Instance.new("Frame", HubFrame)
    sidebar.Size = UDim2.new(0, 96, 1, -34); sidebar.Position = UDim2.new(0, 0, 0, 34)
    sidebar.BackgroundTransparency = 1; sidebar.BorderSizePixel = 0; sidebar.ZIndex = 14

    local content = Instance.new("Frame", HubFrame)
    content.Size = UDim2.new(1, -104, 1, -42); content.Position = UDim2.new(0, 100, 0, 34)
    content.BackgroundColor3 = HUB_BG; content.BorderSizePixel = 0; content.ClipsDescendants = false
    content.ZIndex = 10
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 12)

    local pages, navBtns = {}, {}
    local function addPage(name)
        if pages[name] then return pages[name] end
        local pg = Instance.new("Frame", content)
        pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1
        pg.ClipsDescendants = false; pg.Visible = false; pg.ZIndex = 11
        pages[name] = pg
        return pg
    end
    local function selectPage(name)
        for n, pg in pairs(pages) do pg.Visible = (n == name) end
        for n, b in pairs(navBtns) do
            if n == name then
                b.BackgroundColor3 = Color3.fromRGB(24, 36, 54); b.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                b.BackgroundColor3 = Color3.fromRGB(18, 26, 40); b.TextColor3 = TXT_DIM
            end
        end
    end
    local navIndex = 0
    local function addNav(name, icon)
        local b = Instance.new("TextButton", sidebar)
        b.Size = UDim2.new(1, -12, 0, 40); b.Position = UDim2.new(0, 6, 0, 6 + navIndex * 44)
        b.BackgroundColor3 = Color3.fromRGB(18, 26, 40)
        b.Text = icon .. " " .. name; b.TextColor3 = TXT_DIM; b.TextSize = 11
        b.Font = Enum.Font.GothamBold; b.ZIndex = 15
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        navIndex = navIndex + 1; navBtns[name] = b
        b.MouseButton1Click:Connect(function() selectPage(name) end)
        addPage(name); return b
    end

    addNav("TUNER", "🎛️"); addNav("CHUNG", "🧰")
    addNav("FARMING", "💼"); addNav("SETTINGS", "⚙️")

    local tunerPage = pages["TUNER"]
    local chungPage = pages["CHUNG"]
    local farmingPage = pages["FARMING"]
    local settingsPage = pages["SETTINGS"]

    -- TUNER PAGE LOGIC
    local function createInput(name, dv, posY, pg)
        local lbl = Instance.new("TextLabel", pg)
        lbl.Size = UDim2.new(0.9, 0, 0, 14); lbl.Position = UDim2.new(0.05, 0, 0, posY)
        lbl.BackgroundTransparency = 1; lbl.Text = name
        lbl.TextColor3 = Color3.fromRGB(210, 210, 210); lbl.TextSize = 10
        lbl.Font = Enum.Font.GothamMedium; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 12
        local box = Instance.new("TextBox", pg)
        box.Size = UDim2.new(0.9, 0, 0, 24); box.Position = UDim2.new(0.05, 0, 0, posY + 14)
        box.BackgroundColor3 = Color3.fromRGB(22, 22, 28); box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.Text = tostring(dv); box.TextSize = 11; box.Font = Enum.Font.GothamBold
        box.BorderSizePixel = 0; box.ZIndex = 12
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        local st = Instance.new("UIStroke", box); st.Color = Color3.fromRGB(60, 60, 75); st.Thickness = 1
        return box
    end
    local hpBox = createInput("💪 Hệ số Mã lực (Mặc định: 5.0)", "5.0", 6, tunerPage)
    local rpmBox = createInput("🔥 Cộng thêm Tua máy - RPM (Mặc định: 3500)", "3500", 48, tunerPage)
    local gearRatioBox = createInput("⚙️ Tỷ số truyền số - Ratio Gear (Mặc định: 0.9)", "0.9", 90, tunerPage)
    local finalDriveBox = createInput("⛓️ Tỷ số truyền cuối - Final Drive (Mặc định: 0.9)", "0.9", 132, tunerPage)
    local Status = Instance.new("TextLabel", tunerPage)
    Status.Size = UDim2.new(0.9, 0, 0, 18); Status.Position = UDim2.new(0.05, 0, 0, 174)
    Status.BackgroundTransparency = 1; Status.Text = "Trạng thái: Sẵn sàng."
    Status.TextColor3 = Color3.fromRGB(255, 200, 0); Status.TextSize = 10
    Status.Font = Enum.Font.GothamBold; Status.TextXAlignment = Enum.TextXAlignment.Center; Status.ZIndex = 12
    local InjectBtn = Instance.new("TextButton", tunerPage)
    InjectBtn.Size = UDim2.new(0.9, 0, 0, 28); InjectBtn.Position = UDim2.new(0.05, 0, 0, 194)
    InjectBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100); InjectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    InjectBtn.Text = "⚡ ÁP DỤNG TUNER"; InjectBtn.TextSize = 11
    InjectBtn.Font = Enum.Font.GothamBold; InjectBtn.ZIndex = 12
    Instance.new("UICorner", InjectBtn).CornerRadius = UDim.new(0, 7)
    ToggleFloatMenuBtn = Instance.new("TextButton", tunerPage)
    ToggleFloatMenuBtn.Size = UDim2.new(0.9, 0, 0, 28); ToggleFloatMenuBtn.Position = UDim2.new(0.05, 0, 0, 226)
    ToggleFloatMenuBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); ToggleFloatMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleFloatMenuBtn.Text = "🕹️ NÚT NỔI AUTO T: ĐANG TẮT"; ToggleFloatMenuBtn.TextSize = 11
    ToggleFloatMenuBtn.Font = Enum.Font.GothamBold; ToggleFloatMenuBtn.ZIndex = 12
    Instance.new("UICorner", ToggleFloatMenuBtn).CornerRadius = UDim.new(0, 7)

    local statusThread, tunedModels = nil, setmetatable({}, { __mode = "k" })
    local function setStatusTmp(msg, color, delay)
        if not Status or not Status.Parent then return end
        if statusThread then task.cancel(statusThread); statusThread = nil end
        Status.Text = msg; Status.TextColor3 = color
        statusThread = task.delay(delay or 3, function()
            if Status and Status.Parent then
                Status.Text = "Trạng thái: Sẵn sàng."; Status.TextColor3 = Color3.fromRGB(255, 200, 0)
            end
        end)
    end
    InjectBtn.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        local isInVehicle = seat and (seat:IsA("VehicleSeat") or seat:IsA("Seat"))
        if not isInVehicle then setStatusTmp("❌ Hãy ngồi lên xe rồi bấm áp dụng nhé!", Color3.fromRGB(255, 50, 50)); return end
        local vehicleModel = seat.Parent
        if vehicleModel and tunedModels[vehicleModel] then
            setStatusTmp("⚠ Xe này đã tune rồi — respawn xe để apply", Color3.fromRGB(255, 180, 60), 4); return
        end
        local hpMult = tonumber(hpBox.Text) or 5.0
        local rpmAdd = tonumber(rpmBox.Text) or 3500
        local gearMult = tonumber(gearRatioBox.Text) or 0.8
        local finalMult = tonumber(finalDriveBox.Text) or 0.8
        local count = 0
        local charParts = {}
        if char then
            for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then charParts[p] = true end end
            local hrp = char:FindFirstChild("HumanoidRootPart"); if hrp then charParts[hrp] = true end
        end
        local function isCharOwned(t)
            local ok1, res1 = pcall(function()
                for _, v in pairs(t) do if typeof(v) == "Instance" and charParts[v] then return true end end
                return false
            end)
            return ok1 and res1
        end
        local SPEED_KEYS = { topspeed=true, maxspeed=true, speedlimit=true, maxvelocity=true, topspeedkmh=true, maxthrottle=true, limiter=true }
        local POWER_KEYS = { horsepower=true, torque=true, maxpower=true }
        local RPM_KEYS = { redline=true, maxrpm=true, rpm=true }
        local GEAR_KEYS = { gearratio=true, finaldrive=true }
        local GEAR_TBL = { gearratios=true, gears=true }
        local DRAG_KEYS = { drag=true, dragcoefficient=true, airresistance=true }
        local seen = {}
        local tuneVisited = 0
        local lastYieldTime = os.clock()

        local function tuneTable(t, depth)
            if depth > 8 or seen[t] then return end
            if type(t) ~= "table" then return end
            if isCharOwned(t) then return end
            tuneVisited = tuneVisited + 1
            if tuneVisited > 2000000 then return end
            seen[t] = true
            pcall(setreadonly, t, false)
            local cc = 0
            for k, v in pairs(t) do
                cc = cc + 1
                if cc >= 50 then
                    cc = 0
                    if os.clock() - lastYieldTime > 0.03 then task.wait(); lastYieldTime = os.clock() end
                end
                if type(k) == "string" then
                    local lk = k:lower()
                    local vt = type(v)
                    if vt == "number" then
                        local nv
                        if SPEED_KEYS[lk] and v > 0 then nv = v * 1.6
                        elseif POWER_KEYS[lk] then nv = v * hpMult
                        elseif RPM_KEYS[lk] and v >= 1000 then nv = v + rpmAdd
                        elseif GEAR_KEYS[lk] and v > 0 then nv = v * gearMult
                        elseif DRAG_KEYS[lk] and v > 0 then nv = v * 0.7 end
                        if nv then pcall(rawset, t, k, nv); count = count + 1 end
                    elseif vt == "table" then
                        if GEAR_TBL[lk] then
                            pcall(setreadonly, v, false)
                            for i, g in pairs(v) do
                                if type(g) == "number" then pcall(rawset, v, i, g * gearMult); count = count + 1 end
                            end
                        else tuneTable(v, depth + 1) end
                    end
                elseif type(v) == "table" then tuneTable(v, depth + 1) end
            end
        end

        if typeof(getgc) == "function" then
            task.spawn(function()
                tuneVisited = 0; lastYieldTime = os.clock()
                local gcList = getgc(true)
                for _, obj in pairs(gcList) do
                    if typeof(obj) == "table" then pcall(tuneTable, obj, 1) end
                    if os.clock() - lastYieldTime > 0.03 then task.wait(); lastYieldTime = os.clock() end
                end
            end)
        end
        if vehicleModel then
            for _, obj in pairs(vehicleModel:GetDescendants()) do
                pcall(function()
                    for an, av in pairs(obj:GetAttributes()) do
                        if type(av) == "number" then
                            local ln = an:lower()
                            if ln:find("topspeed") or ln:find("maxspeed") or ln:find("speedlimit") or ln:find("maxvelocity") then
                                obj:SetAttribute(an, av * 1.6); count = count + 1
                            elseif ln:find("horsepower") or ln:find("power") or ln:find("torque") then
                                obj:SetAttribute(an, av * hpMult); count = count + 1
                            elseif ln:find("drag") then obj:SetAttribute(an, av * 0.7); count = count + 1 end
                        end
                    end
                end)
                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                    pcall(function()
                        local name = obj.Name:lower()
                        if name:find("topspeed") or name:find("maxspeed") or name:find("speedlimit") then
                            obj.Value = obj.Value * 1.6; count = count + 1
                        elseif name:find("horsepower") or name:find("power") or name:find("torque") then
                            obj.Value = obj.Value * hpMult; count = count + 1
                        elseif name:find("rpm") or name:find("redline") then
                            if obj.Value >= 1000 then obj.Value = obj.Value + rpmAdd; count = count + 1 end
                        elseif name:find("gear") or name:find("ratio") then
                            obj.Value = obj.Value * gearMult; count = count + 1
                        elseif name:find("drive") then obj.Value = obj.Value * finalMult; count = count + 1
                        elseif name:find("drag") then obj.Value = obj.Value * 0.7; count = count + 1 end
                    end)
                end
            end
        end
        task.spawn(function()
            setStatusTmp("⏳ Đang tune…", Color3.fromRGB(255, 200, 80), 30)
            task.wait(0.1)
            local lastCount = -1
            while tuneVisited ~= lastCount do lastCount = tuneVisited; task.wait(0.3) end
            if count == 0 then setStatusTmp("⚠ Không tìm thấy gì để tune", Color3.fromRGB(255, 180, 60), 4)
            else
                if vehicleModel then tunedModels[vehicleModel] = true end
                setStatusTmp("✔ Đã xong (xuống xe lên lại)", Color3.fromRGB(0, 255, 120), 5)
            end
        end)
    end)

    -- TAB CHUNG LOGIC
    local scroll = Instance.new("ScrollingFrame", chungPage)
    scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 260); scroll.ScrollBarThickness = 4; scroll.ZIndex = 12

    local function makeCard(par, y, title, desc, col)
        local card = Instance.new("Frame", par)
        card.Size = UDim2.new(1, -8, 0, 110); card.Position = UDim2.new(0, 4, 0, y)
        card.BackgroundColor3 = CARD_BG; card.BorderSizePixel = 0; card.ZIndex = 12
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
        local cs = Instance.new("UIStroke", card); cs.Color = col; cs.Thickness = 1; cs.Transparency = 0.4
        local t = Instance.new("TextLabel", card)
        t.Size = UDim2.new(1, -24, 0, 20); t.Position = UDim2.new(0, 12, 0, 8)
        t.BackgroundTransparency = 1; t.Text = title; t.TextColor3 = col; t.TextSize = 12
        t.Font = Enum.Font.GothamBold; t.TextXAlignment = Enum.TextXAlignment.Left; t.ZIndex = 13
        local d = Instance.new("TextLabel", card)
        d.Size = UDim2.new(1, -24, 0, 34); d.Position = UDim2.new(0, 12, 0, 30)
        d.BackgroundTransparency = 1; d.Text = desc; d.TextColor3 = TXT_DIM; d.TextSize = 10
        d.Font = Enum.Font.GothamMedium; d.TextXAlignment = Enum.TextXAlignment.Left; d.TextWrapped = true; d.ZIndex = 13
        return card
    end
    local cardBody = makeCard(scroll, 0, "🚗 THÁO DÀN ÁO — quản lý part xe", "BẬT = hiện nút nổi 🚗 để dùng.\nTẮT = ẩn nút nổi, đóng bảng.", Color3.fromRGB(0, 230, 180))
    bodyOpenBtn = Instance.new("TextButton", cardBody)
    bodyOpenBtn.Size = UDim2.new(0.9, 0, 0, 28); bodyOpenBtn.Position = UDim2.new(0.05, 0, 0, 70)
    bodyOpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); bodyOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    bodyOpenBtn.Text = "🚗 DÀN ÁO: ĐANG TẮT"; bodyOpenBtn.TextSize = 10; bodyOpenBtn.Font = Enum.Font.GothamBold; bodyOpenBtn.ZIndex = 13
    Instance.new("UICorner", bodyOpenBtn).CornerRadius = UDim.new(0, 6)

    local cardFc = makeCard(scroll, 120, "📷 FREECAM CINEMATIC — quay phim", "BẬT = hiện nút nổi 📷 để dùng.\nTẮT = ẩn nút nổi, đóng menu.", Color3.fromRGB(100, 150, 255))
    fcOpenBtn = Instance.new("TextButton", cardFc)
    fcOpenBtn.Size = UDim2.new(0.9, 0, 0, 28); fcOpenBtn.Position = UDim2.new(0.05, 0, 0, 70)
    fcOpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); fcOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    fcOpenBtn.Text = "📷 FREECAM: ĐANG TẮT"; fcOpenBtn.TextSize = 10; fcOpenBtn.Font = Enum.Font.GothamBold; fcOpenBtn.ZIndex = 13
    Instance.new("UICorner", fcOpenBtn).CornerRadius = UDim.new(0, 6)

    -- TAB FARMING LOGIC
    local farmScroll = Instance.new("ScrollingFrame", farmingPage)
    farmScroll.Size = UDim2.new(1, 0, 1, 0); farmScroll.BackgroundTransparency = 1; farmScroll.BorderSizePixel = 0
    farmScroll.CanvasSize = UDim2.new(0, 0, 0, 160); farmScroll.ScrollBarThickness = 4; farmScroll.ZIndex = 12

    local function makeSwitch(par, posY)
        local track = Instance.new("TextButton", par)
        track.Size = UDim2.new(0, 52, 0, 26); track.Position = UDim2.new(1, -64, 0, posY)
        track.BackgroundColor3 = Color3.fromRGB(60, 60, 70); track.Text = ""; track.ZIndex = 14
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
        local knob = Instance.new("Frame", track)
        knob.Size = UDim2.new(0, 20, 0, 20); knob.Position = UDim2.new(0, 3, 0.5, -10)
        knob.BackgroundColor3 = Color3.fromRGB(235, 235, 235); knob.ZIndex = 15
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local on = false
        local function set(v)
            on = v
            track.BackgroundColor3 = v and themeColor or Color3.fromRGB(60, 60, 70)
            knob.Position = v and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        end
        return { track = track, knob = knob, set = set, isOn = function() return on end }
    end
    local cardFarm = makeCard(farmScroll, 0, "🌾 OFFICE AUTOFARM — farm văn phòng", "Tự ngồi ghế, giải toán & in ấn.\nSố liệu hiện trong bảng status khi bật.", ACCENT2)
    farmSwitch = makeSwitch(cardFarm, 10)
    farmNote = Instance.new("TextLabel", cardFarm)
    farmNote.Size = UDim2.new(1, -24, 0, 16); farmNote.Position = UDim2.new(0, 12, 0, 86)
    farmNote.BackgroundTransparency = 1; farmNote.Text = ""
    farmNote.TextColor3 = Color3.fromRGB(255, 120, 80); farmNote.TextSize = 10
    farmNote.Font = Enum.Font.GothamBold; farmNote.TextXAlignment = Enum.TextXAlignment.Left; farmNote.TextWrapped = true; farmNote.ZIndex = 13

    -- TAB SETTINGS LOGIC
    local settingsScroll = Instance.new("ScrollingFrame", settingsPage)
    settingsScroll.Size = UDim2.new(1, 0, 1, 0); settingsScroll.BackgroundTransparency = 1; settingsScroll.BorderSizePixel = 0
    settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0); settingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    settingsScroll.ScrollBarThickness = 4; settingsScroll.ZIndex = 12
    local settingsList = Instance.new("UIListLayout", settingsScroll)
    settingsList.Padding = UDim.new(0, 6); settingsList.SortOrder = Enum.SortOrder.LayoutOrder

    local function makeSection(order, title, defaultOpen)
        local section = Instance.new("Frame", settingsScroll)
        section.Size = UDim2.new(1, -8, 0, 0); section.AutomaticSize = Enum.AutomaticSize.Y
        section.BackgroundTransparency = 1; section.LayoutOrder = order
        local sl = Instance.new("UIListLayout", section); sl.Padding = UDim.new(0, 0); sl.SortOrder = Enum.SortOrder.LayoutOrder
        local header = Instance.new("TextButton", section)
        header.Size = UDim2.new(1, 0, 0, 28); header.LayoutOrder = 1
        header.BackgroundColor3 = Color3.fromRGB(24, 32, 48); header.TextColor3 = Color3.fromRGB(255, 255, 255)
        header.TextSize = 11; header.Font = Enum.Font.GothamBold; header.TextXAlignment = Enum.TextXAlignment.Left
        header.ZIndex = 14; Instance.new("UICorner", header).CornerRadius = UDim.new(0, 6)
        local hp = Instance.new("UIPadding", header); hp.PaddingLeft = UDim.new(0, 8)
        local content = Instance.new("Frame", section)
        content.Size = UDim2.new(1, 0, 0, 0); content.AutomaticSize = Enum.AutomaticSize.Y
        content.LayoutOrder = 2; content.BackgroundColor3 = Color3.fromRGB(18, 24, 36)
        content.BorderSizePixel = 0; content.Visible = defaultOpen or false; content.ZIndex = 13
        Instance.new("UICorner", content).CornerRadius = UDim.new(0, 6)
        local cl = Instance.new("UIListLayout", content); cl.Padding = UDim.new(0, 4); cl.SortOrder = Enum.SortOrder.LayoutOrder
        local isOpen = defaultOpen or false
        header.Text = (isOpen and "▼ " or "▶ ") .. title
        header.MouseButton1Click:Connect(function()
            isOpen = not isOpen; content.Visible = isOpen; header.Text = (isOpen and "▼ " or "▶ ") .. title
        end)
        return content
    end

    local function makeToggle(parent, order, defaultOn, labelOn, labelOff, colorOn, colorOff, cb)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, 0, 0, 28); b.LayoutOrder = order
        b.TextColor3 = Color3.fromRGB(255, 255, 255); b.TextSize = 10; b.Font = Enum.Font.GothamBold; b.ZIndex = 14
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        local on = defaultOn
        local function paint()
            b.Text = on and labelOn or labelOff
            b.BackgroundColor3 = on and colorOn or colorOff
        end
        paint()
        b.MouseButton1Click:Connect(function() on = not on; paint(); cb(on) end)
        return b
    end

    local perfSection = makeSection(3, "⚡ Hiệu năng", false)
    makeToggle(perfSection, 3, false, "📊 FPS/PING: BẬT", "📊 FPS/PING: TẮT",
        Color3.fromRGB(0, 150, 120), Color3.fromRGB(60, 60, 70),
        function(v) perfOn = v; perfFrame.Visible = v end)

    selectPage("TUNER")

    local function applyFarmAvailability()
        local ok = checkFarmOK()
        if ok then
            farmNote.Text = ""
            farmSwitch.track.Active = true
            farmSwitch.track.AutoButtonColor = true
        else
            farmNote.Text = "⚠ Chỉ hoạt động ở Surakarta"
            farmSwitch.track.Active = false
            farmSwitch.track.AutoButtonColor = false
            farmSwitch.track.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
            farmSwitch.knob.BackgroundColor3 = Color3.fromRGB(120, 120, 125)
        end
    end
    applyFarmAvailability()
end

-- ============================================================
-- AUTO T LOGIC
-- ============================================================
do
    local autoTActive = false
    ToggleFloatMenuBtn.MouseButton1Click:Connect(function()
        showAutoTFloat = not showAutoTFloat
        AutoTFloatingBtn.Visible = showAutoTFloat
        if showAutoTFloat then
            ToggleFloatMenuBtn.Text = "🕹️ NÚT NỔI AUTO T: ĐANG BẬT"
            ToggleFloatMenuBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        else
            ToggleFloatMenuBtn.Text = "🕹️ NÚT NỔI AUTO T: ĐANG TẮT"
            ToggleFloatMenuBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            autoTActive = false
            AutoTFloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.T, false, game) end)
        end
    end)
    AutoTFloatingBtn.MouseButton1Click:Connect(function()
        autoTActive = not autoTActive
        if autoTActive then
            AutoTFloatingBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            pcall(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.T, false, game) end)
        else
            AutoTFloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.T, false, game) end)
        end
    end)
end

-- ============================================================
-- THÁO DÀN ÁO LOGIC GỐC
-- ============================================================
do
    local currentVehicle, selectedPart, selectedParentContainer = nil, nil, nil
    local modeActive = false
    local originalParents, originalTransparencies, originalColors, originalMaterials, originalDecalTransparencies = {}, {}, {}, {}, {}
    local modelPartsList, currentIndex, lastSelectedPart = {}, 1, nil

    ControlPanel = Instance.new("Frame", ScreenGui)
    ControlPanel.Name = "ControlPanel"
    ControlPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    ControlPanel.Position = UDim2.new(0.5, 190, 0.5, -175)
    ControlPanel.Size = UDim2.new(0, 280, 0, 350)
    ControlPanel.Visible = false; ControlPanel.Active = true; ControlPanel.Draggable = true; ControlPanel.ZIndex = 9
    Instance.new("UICorner", ControlPanel).CornerRadius = UDim.new(0, 12)
    local ControlStroke = Instance.new("UIStroke", ControlPanel)
    ControlStroke.Color = Color3.fromRGB(0, 230, 180); ControlStroke.Thickness = 1.5
    local ControlTitle = Instance.new("TextLabel", ControlPanel)
    ControlTitle.BackgroundTransparency = 1; ControlTitle.Position = UDim2.new(0, 15, 0, 10)
    ControlTitle.Size = UDim2.new(1, -30, 0, 25); ControlTitle.Font = Enum.Font.GothamBold
    ControlTitle.Text = "🚗 QUẢN LÝ & THÁO DÀN ÁO"; ControlTitle.TextColor3 = Color3.fromRGB(0, 230, 180)
    ControlTitle.TextSize = 12; ControlTitle.TextXAlignment = Enum.TextXAlignment.Left
    makeHeaderDraggable(ControlTitle, ControlPanel)
    local ToggleModeBtn = Instance.new("TextButton", ControlPanel)
    ToggleModeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    ToggleModeBtn.Position = UDim2.new(0, 15, 0, 42); ToggleModeBtn.Size = UDim2.new(1, -30, 0, 32)
    ToggleModeBtn.Font = Enum.Font.GothamBold; ToggleModeBtn.Text = "Chế độ Soi & Tháo: TẮT"
    ToggleModeBtn.TextColor3 = Color3.fromRGB(255, 80, 80); ToggleModeBtn.TextSize = 11
    Instance.new("UICorner", ToggleModeBtn).CornerRadius = UDim.new(0, 8)
    local StatusText = Instance.new("TextLabel", ControlPanel)
    StatusText.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    StatusText.Position = UDim2.new(0, 15, 0, 80); StatusText.Size = UDim2.new(1, -30, 0, 50)
    StatusText.Font = Enum.Font.Gotham; StatusText.Text = " Part: Chưa chọn\nCụm: Chưa chọn\nSố part trong cụm: 0"
    StatusText.TextColor3 = Color3.fromRGB(220, 220, 220); StatusText.TextSize = 10
    StatusText.TextXAlignment = Enum.TextXAlignment.Left; StatusText.TextYAlignment = Enum.TextYAlignment.Center
    Instance.new("UICorner", StatusText).CornerRadius = UDim.new(0, 6)
    local function mkBtn(name, y, x, w, col)
        local b = Instance.new("TextButton", ControlPanel)
        b.BackgroundColor3 = col or Color3.fromRGB(45, 45, 55)
        b.Position = UDim2.new(0, x, 0, y); b.Size = UDim2.new(0, w, 0, 30)
        b.Font = Enum.Font.GothamBold; b.Name = name; b.Text = name
        b.TextColor3 = Color3.fromRGB(255, 255, 255); b.TextSize = 10
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        return b
    end
    local HidePartBtn = mkBtn("Tháo Part Này", 140, 15, 120, Color3.fromRGB(50, 50, 65))
    local HideCompBtn = mkBtn("Tháo Cả Cụm", 140, 145, 120, Color3.fromRGB(50, 50, 65))
    local PrevPartBtn = mkBtn("◀ Mảnh Trước", 176, 15, 120, Color3.fromRGB(40, 90, 110))
    local NextPartBtn = mkBtn("Mảnh Sau ▶", 176, 145, 120, Color3.fromRGB(40, 90, 110))
    local DeselectBtn = mkBtn("Bỏ Chọn", 212, 15, 120, Color3.fromRGB(50, 50, 65))
    local ScanBtn = Instance.new("TextButton", ControlPanel)
    ScanBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45); ScanBtn.Position = UDim2.new(0, 145, 0, 212)
    ScanBtn.Size = UDim2.new(0, 120, 0, 30); ScanBtn.Font = Enum.Font.GothamBold
    ScanBtn.Text = "Quét Lại Xe"; ScanBtn.TextColor3 = Color3.fromRGB(255, 200, 0); ScanBtn.TextSize = 10
    Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 6)
    local RestoreBtn = mkBtn("Khôi Phục Toàn Bộ", 248, 15, 250, Color3.fromRGB(160, 40, 40))

    BodyManagerFloatingBtn.MouseButton1Click:Connect(function()
        ControlPanel.Visible = not ControlPanel.Visible
        if ControlPanel.Visible then BodyManagerFloatingBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 100)
        else BodyManagerFloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15) end
    end)
end

-- ============================================================
-- FREECAM CINEMATIC LOGIC GỐC
-- ============================================================
do
    freecamMenuFrame = Instance.new("Frame", ScreenGui)
    freecamMenuFrame.Size = UDim2.new(0, 300, 0, 230); freecamMenuFrame.Position = UDim2.new(0.5, -150, 0.5, -115)
    freecamMenuFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 21); freecamMenuFrame.BackgroundTransparency = 0.12
    freecamMenuFrame.Visible = false; freecamMenuFrame.ZIndex = 15
    Instance.new("UICorner", freecamMenuFrame).CornerRadius = UDim.new(0, 14)

    local freecamMenuTitle = Instance.new("TextLabel", freecamMenuFrame)
    freecamMenuTitle.Size = UDim2.new(1, 0, 0, 42); freecamMenuTitle.BackgroundTransparency = 1
    freecamMenuTitle.Text = "Freecam Cinematic"; freecamMenuTitle.TextColor3 = Color3.fromRGB(230, 230, 240)
    freecamMenuTitle.TextSize = 15; freecamMenuTitle.Font = Enum.Font.GothamBold; freecamMenuTitle.ZIndex = 16

    local function mkBtn(y, txt, col)
        local b = Instance.new("TextButton", freecamMenuFrame)
        b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, y)
        b.BackgroundColor3 = col; b.Text = txt; b.TextColor3 = Color3.fromRGB(235, 235, 245)
        b.TextSize = 12; b.Font = Enum.Font.GothamBold; b.ZIndex = 16
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        return b
    end
    local freecamToggleBtn = mkBtn(42, "Freecam: OFF", Color3.fromRGB(45, 45, 58))
    local followBtn = mkBtn(78, "Khóa Tầm: OFF", Color3.fromRGB(50, 50, 68))

    FreecamFloatingBtn.MouseButton1Click:Connect(function()
        freecamMenuFrame.Visible = not freecamMenuFrame.Visible
    end)
end

-- ============================================================
-- OFFICE AUTOFARM LOGIC GỐC
-- ============================================================
do
    local JobEvents = ReplicatedStorage:WaitForChild("JobEvents", 10)
    local TeamChangeRequest = JobEvents and JobEvents:WaitForChild("TeamChangeRequest", 5)
    local GenerateQuestion = JobEvents and JobEvents:WaitForChild("GenerateQuestion")
    local CorrectAnswer = JobEvents and JobEvents:WaitForChild("CorrectAnswer")
    local AssignPrintJob = JobEvents and JobEvents:WaitForChild("AssignPrintJob")
    local ClearPrintJob = JobEvents and JobEvents:WaitForChild("ClearPrintJob")

    if GenerateQuestion then
        GenerateQuestion.OnClientEvent:Connect(function(...)
            ofAnswers = ofAnswers + 1
            refreshStatPanel()
        end)
    end

    farmSwitch.track.MouseButton1Click:Connect(function()
        if not checkFarmOK() then return end
        farmOffice = not farmOffice
        if farmOffice then
            activeMode = "office"
            farmStart = os.clock()
            farmRPStart = getRP() or 0
            lastRPValue = farmRPStart
            statPanel.Visible = true
            farmSwitch.set(true)
            setStatus("Khởi động Office AutoFarm")
            if TeamChangeRequest then
                pcall(function() TeamChangeRequest:FireServer("Office Worker", 11378976, 0, 0, "Detector") end)
            end
        else
            activeMode = nil
            statPanel.Visible = false
            farmSwitch.set(false)
            setStatus("Đã tắt Farm")
        end
    end)
end

-- ============================================================
-- KẾT NỐI NÚT CHÍNH MỞ HUB
-- ============================================================
ToggleBtn.MouseButton1Click:Connect(function()
    if HubFrame then HubFrame.Visible = not HubFrame.Visible end
end)

hubClose.MouseButton1Click:Connect(function()
    if HubFrame then HubFrame.Visible = false end
end)

bodyOpenBtn.MouseButton1Click:Connect(function()
    local bState = ControlPanel.Visible
    ControlPanel.Visible = not bState
    BodyManagerFloatingBtn.Visible = not bState
    bodyOpenBtn.Text = not bState and "🚗 DÀN ÁO: ĐANG BẬT" or "🚗 DÀN ÁO: ĐANG TẮT"
    bodyOpenBtn.BackgroundColor3 = not bState and Color3.fromRGB(0, 150, 120) or Color3.fromRGB(30, 30, 40)
end)

fcOpenBtn.MouseButton1Click:Connect(function()
    local fState = freecamMenuFrame.Visible
    freecamMenuFrame.Visible = not fState
    FreecamFloatingBtn.Visible = not fState
    fcOpenBtn.Text = not fState and "📷 FREECAM: ĐANG BẬT" or "📷 FREECAM: ĐANG TẮT"
    fcOpenBtn.BackgroundColor3 = not fState and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(30, 30, 40)
end)

addRGBStroke(ToggleBtn)
addRGBStroke(AutoTFloatingBtn)
addRGBStroke(BodyManagerFloatingBtn)
addRGBStroke(FreecamFloatingBtn)

print("TrungDz - Bypassed Free")
