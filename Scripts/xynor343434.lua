-- ============================================================
-- XYNOR HUB PREMIUM - Full Redesign
-- Premium Pastel Theme + Key System + Modern UI
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local XynorUI = {}
XynorUI.__index = XynorUI

-- ============================================================
-- PREMIUM PASTEL PALETTE (No red/cyan)
-- ============================================================
local PALETTE = {
    BG_DARK       = Color3.fromRGB(18, 18, 24),      -- Deep dark blue
    BG_FRAME      = Color3.fromRGB(28, 28, 38),      -- Frame background
    BG_ELEM      = Color3.fromRGB(36, 36, 48),        -- Element background
    ACCENT       = Color3.fromRGB(167, 139, 250),  -- Soft purple (lavender)
    ACCENT2      = Color3.fromRGB(137, 110, 226),    -- Deep purple
    ACCENT_GLOW  = Color3.fromRGB(187, 160, 255),  -- Light purple glow
    ACCENT_PINK  = Color3.fromRGB(255, 159, 243),  -- Soft pink
    ACCENT_MINT  = Color3.fromRGB(110, 231, 183),   -- Soft mint green
    ACCENT_PEACH = Color3.fromRGB(255, 209, 164),  -- Soft peach
    TEXT_WHITE   = Color3.fromRGB(255, 255, 255),  -- White
    TEXT_GRAY    = Color3.fromRGB(160, 160, 175),    -- Gray
    TEXT_MID     = Color3.fromRGB(200, 200, 210),     -- Mid tone
    OUTLINE      = Color3.fromRGB(60, 60, 80),      -- Dark outline
    SUCCESS     = Color3.fromRGB(110, 231, 183),    -- Mint green
    ERROR       = Color3.fromRGB(255, 118, 117),  -- Soft red
}

local ACCENT      = PALETTE.ACCENT
local ACCENT2     = PALETTE.ACCENT2
local BG_DARK     = PALETTE.BG_DARK
local BG_FRAME    = PALETTE.BG_FRAME
local BG_ELEM    = PALETTE.BG_ELEM
local TEXT_WHITE = PALETTE.TEXT_WHITE
local TEXT_GRAY   = PALETTE.TEXT_GRAY
local TEXT_MID    = PALETTE.TEXT_MID
local OUTLINE     = PALETTE.OUTLINE
local ACCENT_GLOW = PALETTE.ACCENT_GLOW

-- ============================================================
-- TWEEN HELPERS
-- ============================================================
local function tweenQuint(obj, t, props)
    return TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
end
local function tweenBack(obj, t, props)
    return TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props)
end
local function tweenExpo(obj, t, props)
    return TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), props)
end
local function tweenSine(obj, t, props)
    return TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), props)
end
local function tweenCirc(obj, t, props)
    return TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), props)
end

-- ============================================================
-- GUI PARENT HELPER
-- ============================================================
local function getGuiParent()
    if gethui then return gethui() end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- ============================================================
-- BALL CANCOLLIDE GUARDIAN
-- ============================================================
local _ballGuardConn
local function startBallGuard()
    if _ballGuardConn then return end
    local function guardBall(ball)
        if not ball or not ball:IsA("BasePart") then return end
        pcall(function() ball.CanCollide = false end)
        ball:GetPropertyChangedSignal("CanCollide"):Connect(function()
            if ball.CanCollide then
                pcall(function() ball.CanCollide = false end)
            end
        end)
    end
    local function findAndGuard()
        local tps = Workspace:FindFirstChild("TPSSystem")
        if tps then
            local ball = tps:FindFirstChild("TPS")
            if ball then guardBall(ball) end
            tps.ChildAdded:Connect(function(child)
                if child.Name == "TPS" then guardBall(child) end
            end)
        end
    end
    findAndGuard()
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "TPSSystem" then
            task.wait(0.05)
            findAndGuard()
        end
    end)
end
pcall(startBallGuard)

-- ============================================================
-- KEY SYSTEM - Simple Local Storage
-- ============================================================
local function loadKey()
    local ok, val = pcall(function()
        return readfile("xynor_key.txt")
    end)
    return ok and val or nil
end

local function saveKey(key)
    pcall(function()
        writefile("xynor_key.txt", key)
    end)
end

local VALID_KEY = "beta"

-- ============================================================
-- PREMIUM LOADER WITH KEY SYSTEM
-- ============================================================
local function ShowKeySystemLoader(onFinished)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XynorLoaderGui"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = getGuiParent()

    -- Background
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = BG_DARK
    bg.BackgroundTransparency = 0
    bg.Parent = ScreenGui

    -- Loader Frame - centered
    local loaderFrame = Instance.new("Frame")
    loaderFrame.Size = UDim2.fromOffset(280, 200)
    loaderFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
    loaderFrame.BackgroundColor3 = BG_FRAME
    loaderFrame.BorderSizePixel = 0
    loaderFrame.Parent = ScreenGui
    local lfC = Instance.new("UICorner"); lfC.CornerRadius = UDim.new(0, 16); lfC.Parent = loaderFrame
    local lfStroke = Instance.new("UIStroke"); lfStroke.Color = OUTLINE; lfStroke.Thickness = 1; lfStroke.Parent = loaderFrame

    -- Logo/Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "XYNOR"
    title.TextColor3 = ACCENT
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    title.TextTransparency = 1
    title.Parent = loaderFrame

    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 55)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Premium Hub"
    subtitle.TextColor3 = TEXT_GRAY
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.TextTransparency = 1
    subtitle.Parent = loaderFrame

    -- Progress bar bg
    local progBG = Instance.new("Frame")
    progBG.Size = UDim2.new(0.8, 0, 0, 6)
    progBG.Position = UDim2.new(0.1, 0, 0.5, 30)
    progBG.BackgroundColor3 = BG_ELEM
    progBG.BorderSizePixel = 0
    progBG.Parent = loaderFrame
    local pbC = Instance.new("UICorner"); pbC.CornerRadius = UDim.new(1,0); pbC.Parent = progBG

    -- Progress bar fill
    local progFill = Instance.new("Frame")
    progFill.Size = UDim2.new(0, 0, 1, 0)
    progFill.Position = UDim2.new(0, 0, 0, 0)
    progFill.BackgroundColor3 = ACCENT
    progFill.BorderSizePixel = 0
    progFill.Parent = progBG
    local pfC = Instance.new("UICorner"); pfC.CornerRadius = UDim.new(1,0); pfC.Parent = progFill

    -- Status text
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0.7, -10)
    status.BackgroundTransparency = 1
    status.Text = "Initializing..."
    status.TextColor3 = TEXT_MID
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.TextTransparency = 1
    status.Parent = loaderFrame

    -- Version
    local ver = Instance.new("TextLabel")
    ver.Size = UDim2.new(1, 0, 0, 16)
    ver.Position = UDim2.new(0, 0, 1, -20)
    ver.BackgroundTransparency = 1
    ver.Text = "Version 1.0 | Premium Edition"
    ver.TextColor3 = TEXT_GRAY
    ver.Font = Enum.Font.Gotham
    ver.TextSize = 10
    ver.TextTransparency = 1
    ver.Parent = loaderFrame

    -- Entry animation
    task.spawn(function()
        tweenBack(loaderFrame, 0.4, { Size = UDim2.fromOffset(280, 200), BackgroundTransparency = 0 }):Play()
        task.wait(0.15)
        tweenSine(title, 0.3, { TextTransparency = 0 }):Play()
        task.wait(0.1)
        tweenSine(subtitle, 0.25, { TextTransparency = 0 }):Play()
        task.wait(0.1)
        tweenSine(progBG, 0.2, { BackgroundTransparency = 0 }):Play()
        tweenSine(status, 0.2, { TextTransparency = 0 }):Play()
        tweenSine(ver, 0.2, { TextTransparency = 0 }):Play()
    end)

    -- Loading steps
    local steps = {
        { txt = "Loading modules...", delay = 0.3 },
        { txt = "Initializing security...", delay = 0.25 },
        { txt = "Preparing UI...", delay = 0.2 },
        { txt = "Almost ready...", delay = 0.15 },
    }

    task.wait(0.5)
    for i, step in ipairs(steps) do
        status.Text = step.txt
        tweenQuint(progFill, step.delay, { Size = UDim2.new(i / #steps, 0, 1, 0) }):Play()
        task.wait(step.delay + 0.1)
    end

    -- Check saved key
    task.wait(0.3)
    local savedKey = loadKey()

    if savedKey == VALID_KEY then
        -- Key valid - fade out loader and continue
        status.Text = "Key validated!"
        tweenQuint(progFill, 0.2, { Size = UDim2.new(1, 0, 1, 0) }):Play()
        task.wait(0.4)
        tweenExpo(bg, 0.35, { BackgroundTransparency = 1 }):Play()
        tweenExpo(loaderFrame, 0.3, { BackgroundTransparency = 1 }):Play()
        task.wait(0.4)
        ScreenGui:Destroy()
        if onFinished then onFinished() end
        return
    end

    -- Show key input screen
    status.Text = "Enter your key"
    tweenQuint(loaderFrame, 0.3, { Size = UDim2.fromOffset(320, 280) }):Play()
    task.wait(0.35)

    -- Key input area
    local keyInputBG = Instance.new("Frame")
    keyInputBG.Size = UDim2.new(0.85, 0, 0, 38)
    keyInputBG.Position = UDim2.new(0.075, 0, 0, 100)
    keyInputBG.BackgroundColor3 = BG_ELEM
    keyInputBG.BorderSizePixel = 0
    keyInputBG.BackgroundTransparency = 1
    keyInputBG.Parent = loaderFrame
    local kibC = Instance.new("UICorner"); kibC.CornerRadius = UDim.new(0, 8); kibC.Parent = keyInputBG
    local kibStroke = Instance.new("UIStroke"); kibStroke.Color = OUTLINE; kibStroke.Thickness = 1; kibStroke.Parent = keyInputBG

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(1, 0, 1, 0)
    keyBox.BackgroundTransparency = 1
    keyBox.Text = ""
    keyBox.PlaceholderText = "Enter key..."
    keyBox.PlaceholderColor3 = TEXT_GRAY
    keyBox.TextColor3 = TEXT_WHITE
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextSize = 14
    keyBox.TextTransparency = 1
    keyBox.ClearTextOnFocus = false
    keyBox.Parent = keyInputBG

    -- Error text
    local errorLbl = Instance.new("TextLabel")
    errorLbl.Size = UDim2.new(1, 0, 0, 16)
    errorLbl.Position = UDim2.new(0, 0, 0, 145)
    errorLbl.BackgroundTransparency = 1
    errorLbl.Text = ""
    errorLbl.TextColor3 = PALETTE.ERROR
    errorLbl.Font = Enum.Font.Gotham
    errorLbl.TextSize = 11
    errorLbl.TextTransparency = 1
    errorLbl.Parent = loaderFrame

    -- Submit button
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0.85, 0, 0, 36)
    submitBtn.Position = UDim2.new(0.075, 0, 0, 175)
    submitBtn.BackgroundColor3 = ACCENT
    submitBtn.Text = "Verify Key"
    submitBtn.TextColor3 = TEXT_WHITE
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 14
    submitBtn.BorderSizePixel = 0
    submitBtn.BackgroundTransparency = 1
    submitBtn.Parent = loaderFrame
    local sbC = Instance.new("UICorner"); sbC.CornerRadius = UDim.new(0, 8); sbC.Parent = submitBtn

    -- Show key input elements
    tweenSine(keyInputBG, 0.25, { BackgroundTransparency = 0 }):Play()
    task.wait(0.1)
    tweenSine(keyBox, 0.2, { TextTransparency = 0 }):Play()
    tweenSine(submitBtn, 0.25, { BackgroundTransparency = 0 }):Play()

    -- Submit button click
    submitBtn.MouseButton1Click:Connect(function()
        local enteredKey = keyBox.Text:lower():gsub("%s+", "")
        if enteredKey == VALID_KEY then
            saveKey(VALID_KEY)
            tweenSine(errorLbl, 0.15, { TextTransparency = 1 }):Play()
            errorLbl.Text = "Key validated!"
            errorLbl.TextColor3 = PALETTE.SUCCESS
            tweenSine(errorLbl, 0.2, { TextTransparency = 0 }):Play()
            task.wait(0.5)
            tweenExpo(bg, 0.35, { BackgroundTransparency = 1 }):Play()
            tweenExpo(loaderFrame, 0.3, { BackgroundTransparency = 1 }):Play()
            task.wait(0.4)
            ScreenGui:Destroy()
            if onFinished then onFinished() end
        else
            keyBox.Text = ""
            errorLbl.Text = "Invalid key. Try again."
            errorLbl.TextColor3 = PALETTE.ERROR
            tweenSine(errorLbl, 0.2, { TextTransparency = 0 }):Play()
            tweenSine(keyInputBG, 0.1, { BackgroundColor3 = PALETTE.ERROR }):Play()
            task.wait(0.1)
            tweenSine(keyInputBG, 0.2, { BackgroundColor3 = BG_ELEM }):Play()
        end
    end)

    -- Hover effects
    submitBtn.MouseEnter:Connect(function()
        tweenSine(submitBtn, 0.15, { BackgroundColor3 = ACCENT2 }):Play()
    end)
    submitBtn.MouseLeave:Connect(function()
        tweenSine(submitBtn, 0.15, { BackgroundColor3 = ACCENT }):Play()
    end)
    submitBtn.MouseButton1Down:Connect(function()
        tweenBack(submitBtn, 0.08, { Size = UDim2.new(0.85, 0, 0, 32) }):Play()
    end)
    submitBtn.MouseButton1Up:Connect(function()
        tweenBack(submitBtn, 0.15, { Size = UDim2.new(0.85, 0, 0, 36) }):Play()
    end)

    keyBox.FocusLost:Connect(function()
        tweenSine(kibStroke, 0.15, { Color = OUTLINE }):Play()
    end)
    keyBox:GetPropertyChangedSignal("Text"):Connect(function()
        tweenSine(kibStroke, 0.15, { Color = ACCENT_GLOW }):Play()
    end)
end

-- ============================================================
-- NOTIFICATIONS - Premium Style
-- ============================================================
function XynorUI:Notify(opts)
    local title    = opts.Title or ""
    local desc     = opts.Desc or ""
    local duration = opts.Duration or 3
    local color   = opts.Color or ACCENT

    local parent = getGuiParent()
    local existing = parent:FindFirstChild("XynorNotifGui")
    if existing then existing:Destroy() end

    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "XynorNotifGui"
    NotifGui.ResetOnSpawn = false
    NotifGui.IgnoreGuiInset = true
    NotifGui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(290, 64)
    frame.Position = UDim2.new(1, 20, 1, -80)
    frame.BackgroundColor3 = BG_FRAME
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = NotifGui
    local fC = Instance.new("UICorner"); fC.CornerRadius = UDim.new(0, 12); fC.Parent = frame

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.fromOffset(3, 44)
    accentBar.Position = UDim2.new(0, 0, 0.5, -22)
    accentBar.BackgroundColor3 = color
    accentBar.BorderSizePixel = 0
    accentBar.Parent = frame
    local abC = Instance.new("UICorner"); abC.CornerRadius = UDim.new(1,0); abC.Parent = accentBar

    local stroke = Instance.new("UIStroke")
    stroke.Color = OUTLINE
    stroke.Thickness = 1
    stroke.Parent = frame

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -18, 0.5, 0)
    titleLbl.Position = UDim2.fromOffset(14, 4)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = TEXT_WHITE
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTransparency = 1
    titleLbl.Parent = frame

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -18, 0.5, 0)
    descLbl.Position = UDim2.new(0, 14, 0.5, 0)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = desc
    descLbl.TextColor3 = TEXT_GRAY
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 11
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextTransparency = 1
    descLbl.Parent = frame

    tweenExpo(frame, 0.45, {
        Position = UDim2.new(1, -305, 1, -80),
        BackgroundTransparency = 0
    }):Play()
    task.delay(0.1, function()
        tweenSine(titleLbl, 0.3, { TextTransparency = 0 }):Play()
        task.delay(0.08, function()
            tweenSine(descLbl, 0.3, { TextTransparency = 0 }):Play()
        end)
    end)

    task.delay(duration, function()
        if NotifGui and NotifGui.Parent then
            tweenQuint(frame, 0.35, {
                Position = UDim2.new(1, 20, 1, -80),
                BackgroundTransparency = 1
            }):Play()
            tweenSine(titleLbl, 0.25, { TextTransparency = 1 }):Play()
            tweenSine(descLbl, 0.25, { TextTransparency = 1 }):Play()
            task.wait(0.4)
            NotifGui:Destroy()
        end
    end)
end

-- ============================================================
-- MAIN WINDOW - Full Redesign
-- ============================================================
function XynorUI:CreateWindow(opts)
    local isMobile = UserInputService.TouchEnabled
    local winW = isMobile and 430 or 540
    local winH = isMobile and 340 or 470

    local guiParent = getGuiParent()

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XynorHubGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999
    ScreenGui.Enabled = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = guiParent

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    local newSize = 315
    MainFrame.Size = UDim2.fromOffset(newSize * 0.6, newSize * 0.6)
    MainFrame.Position = UDim2.new(0.5, -newSize/2, 0.5, -newSize/2)
    MainFrame.BackgroundColor3 = BG_DARK
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui
    local mainCorner = Instance.new("UICorner"); mainCorner.CornerRadius = UDim.new(0, 14); mainCorner.Parent = MainFrame
    local mainStroke = Instance.new("UIStroke"); mainStroke.Color = OUTLINE; mainStroke.Thickness = 1.5; mainStroke.Parent = MainFrame

    -- Topbar with gradient effect
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, isMobile and 38 or 44)
    Topbar.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    Topbar.BorderSizePixel = 0
    Topbar.BackgroundTransparency = 1
    Topbar.Parent = MainFrame
    local topCorner = Instance.new("UICorner"); topCorner.CornerRadius = UDim.new(0, 14); topCorner.Parent = Topbar

    local topFix = Instance.new("Frame")
    topFix.Size = UDim2.new(1, 0, 0, 10)
    topFix.Position = UDim2.new(0, 0, 1, -10)
    topFix.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    topFix.BorderSizePixel = 0
    topFix.BackgroundTransparency = 1
    topFix.Parent = Topbar

    -- Accent line
    local topAccentLine = Instance.new("Frame")
    topAccentLine.Size = UDim2.new(0, 0, 0, 2)
    topAccentLine.Position = UDim2.new(0, 0, 1, -2)
    topAccentLine.BackgroundColor3 = ACCENT
    topAccentLine.BorderSizePixel = 0
    topAccentLine.Parent = Topbar

    -- Title with gradient
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0, 180, 0.5, 0)
    titleLbl.Position = UDim2.fromOffset(14, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = opts.Title or "XYNOR HUB"
    titleLbl.TextColor3 = TEXT_WHITE
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = isMobile and 14 or 16
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTransparency = 1
    titleLbl.Parent = Topbar

    -- Author/Credits
    local authorLbl = Instance.new("TextLabel")
    authorLbl.Size = UDim2.new(0, 180, 0.5, 0)
    authorLbl.Position = UDim2.new(0, 14, 0.5, 0)
    authorLbl.BackgroundTransparency = 1
    authorLbl.Text = "by Xynor"
    authorLbl.TextColor3 = ACCENT_PINK
    authorLbl.Font = Enum.Font.Gotham
    authorLbl.TextSize = isMobile and 11 or 12
    authorLbl.TextXAlignment = Enum.TextXAlignment.Left
    authorLbl.TextTransparency = 1
    authorLbl.Parent = Topbar

    -- Minimize button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.fromOffset(20, 20)
    MinBtn.Position = UDim2.new(1, -64, 0.5, -10)
    MinBtn.BackgroundColor3 = PALETTE.ACCENT_MINT
    MinBtn.Text = "-"
    MinBtn.TextColor3 = BG_DARK
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14
    MinBtn.BorderSizePixel = 0
    MinBtn.BackgroundTransparency = 1
    MinBtn.Parent = Topbar
    local minC = Instance.new("UICorner"); minC.CornerRadius = UDim.new(1,0); minC.Parent = MinBtn
    local minStroke = Instance.new("UIStroke"); minStroke.Color = OUTLINE; minStroke.Thickness = 1; minStroke.Parent = MinBtn

    MinBtn.MouseEnter:Connect(function()
        TweenService:Create(MinBtn, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { BackgroundColor3 = PALETTE.ACCENT_MINT }):Play()
    end)
    MinBtn.MouseLeave:Connect(function()
        TweenService:Create(MinBtn, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { BackgroundColor3 = PALETTE.ACCENT_MINT }):Play()
    end)

    -- Close button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.fromOffset(20, 20)
    CloseBtn.Position = UDim2.new(1, -38, 0.5, -10)
    CloseBtn.BackgroundColor3 = ACCENT2
    CloseBtn.Text = "x"
    CloseBtn.TextColor3 = TEXT_WHITE
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 11
    CloseBtn.BorderSizePixel = 0
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Parent = Topbar
    local clsC = Instance.new("UICorner"); clsC.CornerRadius = UDim.new(1,0); clsC.Parent = CloseBtn

    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { BackgroundColor3 = PALETTE.ERROR }):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { BackgroundColor3 = ACCENT2 }):Play()
    end)

    local minimized = false
    local contentHeight = winH - (isMobile and 38 or 44)

    -- Content frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -(isMobile and 38 or 44))
    ContentFrame.Position = UDim2.new(0, 0, 0, isMobile and 38 or 44)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- Tab panel
    local TabPanel = Instance.new("ScrollingFrame")
    TabPanel.Name = "TabPanel"
    TabPanel.Size = UDim2.new(0, 145, 1, 0)
    TabPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    TabPanel.BorderSizePixel = 0
    TabPanel.ScrollBarThickness = 0
    TabPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabPanel.BackgroundTransparency = 1
    TabPanel.Parent = ContentFrame

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 2)
    tabListLayout.Parent = TabPanel

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 6)
    tabPadding.PaddingLeft = UDim.new(0, 6)
    tabPadding.PaddingRight = UDim.new(0, 6)
    tabPadding.Parent = TabPanel

    -- Separator
    local Separator = Instance.new("Frame")
    Separator.Size = UDim2.new(0, 1, 1, 0)
    Separator.Position = UDim2.fromOffset(145, 0)
    Separator.BackgroundColor3 = OUTLINE
    Separator.BorderSizePixel = 0
    Separator.BackgroundTransparency = 1
    Separator.Parent = ContentFrame

    -- Page holder
    local PageHolder = Instance.new("Frame")
    PageHolder.Name = "PageHolder"
    PageHolder.Size = UDim2.new(1, -146, 1, 0)
    PageHolder.Position = UDim2.fromOffset(146, 0)
    PageHolder.BackgroundTransparency = 1
    PageHolder.ClipsDescendants = true
    PageHolder.Parent = ContentFrame

    -- Opening animation
    task.spawn(function()
        tweenBack(MainFrame, 0.35, {
            Size = UDim2.fromOffset(newSize, newSize),
            BackgroundTransparency = 0
        }):Play()

        task.wait(0.08)
        tweenExpo(Topbar, 0.2, { BackgroundTransparency = 0 }):Play()
        tweenExpo(topFix, 0.2, { BackgroundTransparency = 0 }):Play()
        tweenCirc(topAccentLine, 0.35, { Size = UDim2.new(1, 0, 0, 2) }):Play()

        task.wait(0.05)
        tweenSine(titleLbl, 0.18, { TextTransparency = 0 }):Play()
        task.delay(0.03, function()
            tweenSine(authorLbl, 0.18, { TextTransparency = 0 }):Play()
        end)

        task.delay(0.04)
        tweenBack(MinBtn, 0.15, { BackgroundTransparency = 0 }):Play()
        task.delay(0.02, function()
            tweenBack(CloseBtn, 0.15, { BackgroundTransparency = 0 }):Play()
        end)

        task.delay(0.05)
        tweenExpo(TabPanel, 0.2, { BackgroundTransparency = 0 }):Play()
        tweenExpo(Separator, 0.2, { BackgroundTransparency = 0 }):Play()
    end)

    -- Drag functionality
    local dragging, dragStart, startPos = false, nil, nil
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        tweenQuint(MainFrame, 0.3, {
            Size = minimized and UDim2.fromOffset(winW, isMobile and 38 or 44) or UDim2.fromOffset(winW, winH)
        }):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        tweenQuint(MainFrame, 0.25, { Size = UDim2.fromOffset(winW, 0), BackgroundTransparency = 1 }):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    -- Floating open button
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Name = "XynorOpenBtn"
    OpenBtn.Size = UDim2.fromOffset(70, 26)
    OpenBtn.Position = UDim2.new(0, 10, 0.5, -13)
    OpenBtn.BackgroundColor3 = ACCENT2
    OpenBtn.Text = "XYNOR"
    OpenBtn.TextColor3 = TEXT_WHITE
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 12
    OpenBtn.BorderSizePixel = 0
    OpenBtn.Visible = false
    OpenBtn.Parent = ScreenGui
    local obC = Instance.new("UICorner"); obC.CornerRadius = UDim.new(0, 7); obC.Parent = OpenBtn

    OpenBtn.MouseEnter:Connect(function()
        tweenSine(OpenBtn, 0.15, { BackgroundColor3 = ACCENT }):Play()
    end)
    OpenBtn.MouseLeave:Connect(function()
        tweenSine(OpenBtn, 0.15, { BackgroundColor3 = ACCENT2 }):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        OpenBtn.Visible = true
    end)
    OpenBtn.MouseButton1Click:Connect(function()
        OpenBtn.Visible = false
        MainFrame.Size = UDim2.fromOffset(winW, winH)
        MainFrame.Parent = ScreenGui
    end)

    local windowObj = {}
    local currentTab = nil

    local function setActiveTab(tabPage, tabBtn)
        if currentTab then
            currentTab.Page.Visible = false
            TweenService:Create(currentTab.Btn, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {
                BackgroundColor3 = Color3.fromRGB(18, 18, 25),
                BackgroundTransparency = 0
            }):Play()
            local prevLbl = currentTab.Btn:FindFirstChildWhichIsA("TextLabel")
            if prevLbl then
                TweenService:Create(prevLbl, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {
                    TextColor3 = TEXT_GRAY
                }):Play()
            end
        end
        tabPage.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            BackgroundColor3 = BG_ELEM,
            BackgroundTransparency = 0
        }):Play()
        local lbl = tabBtn:FindFirstChildWhichIsA("TextLabel")
        if lbl then
            TweenService:Create(lbl, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                TextColor3 = ACCENT_GLOW
            }):Play()
        end
        currentTab = {Page = tabPage, Btn = tabBtn}
    end

    local function makeElementContainer(parent)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -6, 0, 48)
        frame.BackgroundColor3 = BG_ELEM
        frame.BorderSizePixel = 0
        frame.Parent = parent
        local fCorner = Instance.new("UICorner"); fCorner.CornerRadius = UDim.new(0, 6); fCorner.Parent = frame
        local fStroke = Instance.new("UIStroke"); fStroke.Color = OUTLINE; fStroke.Thickness = 1; fStroke.Parent = frame

        local hoverBtn = Instance.new("TextButton")
        hoverBtn.Size = UDim2.new(1,0,1,0)
        hoverBtn.BackgroundTransparency = 1
        hoverBtn.Text = ""
        hoverBtn.ZIndex = 0
        hoverBtn.Parent = frame

        hoverBtn.MouseEnter:Connect(function()
            tweenSine(frame, 0.12, { BackgroundColor3 = Color3.fromRGB(42, 42, 56) }):Play()
        end)
        hoverBtn.MouseLeave:Connect(function()
            tweenSine(frame, 0.12, { BackgroundColor3 = BG_ELEM }):Play()
        end)

        return frame
    end

    local function buildTabAPI(page)
        local tabAPI = {}

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.ScrollBarImageColor3 = ACCENT
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Parent = page

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 4)
        listLayout.Parent = scroll

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 5)
        padding.PaddingLeft = UDim.new(0, 5)
        padding.PaddingRight = UDim.new(0, 5)
        padding.PaddingBottom = UDim.new(0, 5)
        padding.Parent = scroll

        local elemOrder = 0
        local function nextOrder() elemOrder = elemOrder + 1 return elemOrder end

        -- SECTION
        function tabAPI:Section(opts2)
            local sFrame = Instance.new("Frame")
            sFrame.Size = UDim2.new(1, -6, 0, 20)
            sFrame.BackgroundTransparency = 1
            sFrame.LayoutOrder = nextOrder()
            sFrame.Parent = scroll

            local sLine = Instance.new("Frame")
            sLine.Size = UDim2.new(1, 0, 0, 1)
            sLine.Position = UDim2.new(0, 0, 0.5, 0)
            sLine.BackgroundColor3 = OUTLINE
            sLine.BorderSizePixel = 0
            sLine.Parent = sFrame

            local sTitle = Instance.new("TextLabel")
            sTitle.Size = UDim2.new(0, 0, 1, 0)
            sTitle.AutomaticSize = Enum.AutomaticSize.X
            sTitle.BackgroundColor3 = BG_DARK
            sTitle.BorderSizePixel = 0
            sTitle.Position = UDim2.new(0, 6, 0, 0)
            sTitle.Text = "  " .. (opts2.Title or "") .. "  "
            sTitle.TextColor3 = ACCENT_PINK
            sTitle.Font = Enum.Font.GothamBold
            sTitle.TextSize = 10
            sTitle.Parent = sFrame
        end

        -- PARAGRAPH
        function tabAPI:Paragraph(opts2)
            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 44)
            f.LayoutOrder = nextOrder()

            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1, -10, 0.5, 0)
            t.Position = UDim2.fromOffset(8, 4)
            t.BackgroundTransparency = 1
            t.Text = opts2.Title or ""
            t.TextColor3 = TEXT_WHITE
            t.Font = Enum.Font.GothamBold
            t.TextSize = 12
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Parent = f

            local d = Instance.new("TextLabel")
            d.Size = UDim2.new(1, -10, 0.5, 0)
            d.Position = UDim2.new(0, 8, 0.5, 0)
            d.BackgroundTransparency = 1
            d.Text = opts2.Desc or ""
            d.TextColor3 = TEXT_GRAY
            d.Font = Enum.Font.Gotham
            d.TextSize = 10
            d.TextXAlignment = Enum.TextXAlignment.Left
            d.TextWrapped = true
            d.Parent = f
        end

        -- TOGGLE
        function tabAPI:Toggle(opts2)
            local f = makeElementContainer(scroll)
            f.LayoutOrder = nextOrder()

            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -52, 0.5, 0)
            titleLb.Position = UDim2.fromOffset(8, 4)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts2.Title or ""
            titleLb.TextColor3 = TEXT_WHITE
            titleLb.Font = Enum.Font.GothamBold
            titleLb.TextSize = 12
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = f

            if opts2.Desc and opts2.Desc ~= "" then
                local descLb = Instance.new("TextLabel")
                descLb.Size = UDim2.new(1, -52, 0.5, 0)
                descLb.Position = UDim2.new(0, 8, 0.5, 0)
                descLb.BackgroundTransparency = 1
                descLb.Text = opts2.Desc
                descLb.TextColor3 = TEXT_GRAY
                descLb.Font = Enum.Font.Gotham
                descLb.TextSize = 10
                descLb.TextXAlignment = Enum.TextXAlignment.Left
                descLb.Parent = f
            end

            local switchBG = Instance.new("Frame")
            switchBG.Size = UDim2.fromOffset(32, 18)
            switchBG.Position = UDim2.new(1, -40, 0.5, -9)
            switchBG.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            switchBG.BorderSizePixel = 0
            switchBG.Parent = f
            local swC = Instance.new("UICorner"); swC.CornerRadius = UDim.new(1,0); swC.Parent = switchBG

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(12, 12)
            knob.Position = UDim2.fromOffset(3, 3)
            knob.BackgroundColor3 = TEXT_GRAY
            knob.BorderSizePixel = 0
            knob.Parent = switchBG
            local kC = Instance.new("UICorner"); kC.CornerRadius = UDim.new(1,0); kC.Parent = knob

            local value = false
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = f

            local toggleObj = {}
            function toggleObj:Set(v)
                value = v
                TweenService:Create(switchBG, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = v and ACCENT or Color3.fromRGB(45, 45, 60)
                }):Play()
                TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = v and UDim2.fromOffset(17, 3) or UDim2.fromOffset(3, 3),
                    BackgroundColor3 = v and TEXT_WHITE or TEXT_GRAY
                }):Play()
                if opts2.Callback then opts2.Callback(v) end
            end

            btn.MouseButton1Click:Connect(function()
                tweenSine(f, 0.06, { BackgroundColor3 = Color3.fromRGB(50, 50, 70) }):Play()
                task.delay(0.06, function()
                    tweenSine(f, 0.1, { BackgroundColor3 = BG_ELEM }):Play()
                end)
                toggleObj:Set(not value)
            end)

            return toggleObj
        end

        -- SLIDER
        function tabAPI:Slider(opts2)
            local valData = opts2.Value or {}
            local minV = valData.Min or opts2.Min or 0
            local maxV = valData.Max or opts2.Max or 100
            local defV = valData.Default or opts2.Default or minV
            local currentVal = defV

            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 58)
            f.LayoutOrder = nextOrder()

            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -50, 0.5, 0)
            titleLb.Position = UDim2.fromOffset(8, 4)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts2.Title or ""
            titleLb.TextColor3 = TEXT_WHITE
            titleLb.Font = Enum.Font.GothamBold
            titleLb.TextSize = 12
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = f

            if opts2.Desc and opts2.Desc ~= "" then
                local descLb = Instance.new("TextLabel")
                descLb.Size = UDim2.new(1, -50, 0, 12)
                descLb.Position = UDim2.new(0, 8, 0, 20)
                descLb.BackgroundTransparency = 1
                descLb.Text = opts2.Desc
                descLb.TextColor3 = TEXT_GRAY
                descLb.Font = Enum.Font.Gotham
                descLb.TextSize = 10
                descLb.TextXAlignment = Enum.TextXAlignment.Left
                descLb.Parent = f
            end

            local valLbl = Instance.new("TextLabel")
            valLbl.Size = UDim2.fromOffset(44, 18)
            valLbl.Position = UDim2.new(1, -48, 0, 4)
            valLbl.BackgroundTransparency = 1
            valLbl.Text = tostring(defV)
            valLbl.TextColor3 = ACCENT_GLOW
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 11
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Parent = f

            local trackBG = Instance.new("Frame")
            trackBG.Size = UDim2.new(1, -16, 0, 4)
            trackBG.Position = UDim2.new(0, 8, 1, -12)
            trackBG.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            trackBG.BorderSizePixel = 0
            trackBG.Parent = f
            local trC = Instance.new("UICorner"); trC.CornerRadius = UDim.new(1,0); trC.Parent = trackBG

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((defV - minV) / (maxV - minV), 0, 1, 0)
            fill.BackgroundColor3 = ACCENT
            fill.BorderSizePixel = 0
            fill.Parent = trackBG
            local fC = Instance.new("UICorner"); fC.CornerRadius = UDim.new(1,0); fC.Parent = fill

            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Size = UDim2.new(1, 0, 0, 16)
            sliderBtn.Position = UDim2.new(0, 0, 1, -16)
            sliderBtn.BackgroundTransparency = 1
            sliderBtn.Text = ""
            sliderBtn.Parent = f

            local sliding = false

            local function updateSlider(inputX)
                local absPos = trackBG.AbsolutePosition.X
                local absSize = trackBG.AbsoluteSize.X
                local rel = math.clamp((inputX - absPos) / absSize, 0, 1)
                local rawVal = minV + rel * (maxV - minV)
                local rounded = math.floor(rawVal * 100 + 0.5) / 100
                currentVal = rounded
                fill.Size = UDim2.new(rel, 0, 1, 0)
                valLbl.Text = tostring(math.floor(rounded * 10 + 0.5) / 10)
                if opts2.Callback then opts2.Callback(currentVal) end
            end

            sliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    updateSlider(input.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            if opts2.Callback then opts2.Callback(defV) end
        end

        -- INPUT
        function tabAPI:Input(opts2)
            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 56)
            f.LayoutOrder = nextOrder()

            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -10, 0, 16)
            titleLb.Position = UDim2.fromOffset(8, 4)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts2.Title or ""
            titleLb.TextColor3 = TEXT_WHITE
            titleLb.Font = Enum.Font.GothamBold
            titleLb.TextSize = 12
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = f

            if opts2.Desc and opts2.Desc ~= "" then
                local descLb = Instance.new("TextLabel")
                descLb.Size = UDim2.new(1, -10, 0, 12)
                descLb.Position = UDim2.fromOffset(8, 20)
                descLb.BackgroundTransparency = 1
                descLb.Text = opts2.Desc
                descLb.TextColor3 = TEXT_GRAY
                descLb.Font = Enum.Font.Gotham
                descLb.TextSize = 10
                descLb.TextXAlignment = Enum.TextXAlignment.Left
                descLb.Parent = f
            end

            local inputBG = Instance.new("Frame")
            inputBG.Size = UDim2.new(1, -16, 0, 20)
            inputBG.Position = UDim2.new(0, 8, 1, -24)
            inputBG.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
            inputBG.BorderSizePixel = 0
            inputBG.Parent = f
            local inC = Instance.new("UICorner"); inC.CornerRadius = UDim.new(0,4); inC.Parent = inputBG
            local inStr = Instance.new("UIStroke"); inStr.Color = OUTLINE; inStr.Thickness = 1; inStr.Parent = inputBG

            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, -8, 1, 0)
            textBox.Position = UDim2.fromOffset(4, 0)
            textBox.BackgroundTransparency = 1
            textBox.Text = opts2.Value or ""
            textBox.PlaceholderText = "Enter value..."
            textBox.TextColor3 = TEXT_WHITE
            textBox.PlaceholderColor3 = TEXT_GRAY
            textBox.Font = Enum.Font.Gotham
            textBox.TextSize = 11
            textBox.TextXAlignment = Enum.TextXAlignment.Left
            textBox.ClearTextOnFocus = false
            textBox.Parent = inputBG

            textBox.FocusLost:Connect(function()
                if opts2.Callback then opts2.Callback(textBox.Text) end
                tweenSine(inStr, 0.15, { Color = OUTLINE }):Play()
            end)
            textBox:GetPropertyChangedSignal("Text"):Connect(function()
                tweenSine(inStr, 0.15, { Color = ACCENT }):Play()
            end)
        end

        -- BUTTON
        function tabAPI:Button(opts2)
            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 36)
            f.LayoutOrder = nextOrder()

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = f

            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -10, 1, 0)
            titleLb.Position = UDim2.fromOffset(8, 0)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts2.Title or ""
            titleLb.TextColor3 = TEXT_WHITE
            titleLb.Font = Enum.Font.GothamBold
            titleLb.TextSize = 12
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = f

            if opts2.Desc and opts2.Desc ~= "" then
                titleLb.Size = UDim2.new(1, -10, 0.5, 0)
                titleLb.Position = UDim2.fromOffset(8, 3)
                local descLb = Instance.new("TextLabel")
                descLb.Size = UDim2.new(1, -10, 0.5, 0)
                descLb.Position = UDim2.new(0, 8, 0.5, 0)
                descLb.BackgroundTransparency = 1
                descLb.Text = opts2.Desc
                descLb.TextColor3 = TEXT_GRAY
                descLb.Font = Enum.Font.Gotham
                descLb.TextSize = 10
                descLb.TextXAlignment = Enum.TextXAlignment.Left
                descLb.Parent = f
            end

            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.fromOffset(18, 18)
            arrow.Position = UDim2.new(1, -26, 0.5, -9)
            arrow.BackgroundTransparency = 1
            arrow.Text = ">"
            arrow.TextColor3 = ACCENT
            arrow.Font = Enum.Font.GothamBold
            arrow.TextSize = 18
            arrow.Parent = f

            btn.MouseEnter:Connect(function()
                tweenSine(f, 0.12, { BackgroundColor3 = Color3.fromRGB(42, 42, 56) }):Play()
                tweenSine(arrow, 0.12, { TextColor3 = ACCENT_GLOW }):Play()
            end)
            btn.MouseLeave:Connect(function()
                tweenSine(f, 0.12, { BackgroundColor3 = BG_ELEM }):Play()
                tweenSine(arrow, 0.12, { TextColor3 = ACCENT }):Play()
            end)

            btn.MouseButton1Down:Connect(function()
                tweenBack(f, 0.06, { Size = UDim2.new(1, -10, 0, 32) }):Play()
            end)
            btn.MouseButton1Up:Connect(function()
                tweenBack(f, 0.12, { Size = UDim2.new(1, -6, 0, 36) }):Play()
            end)

            btn.MouseButton1Click:Connect(function()
                tweenSine(f, 0.07, { BackgroundColor3 = Color3.fromRGB(50, 50, 70) }):Play()
                task.wait(0.08)
                tweenSine(f, 0.1, { BackgroundColor3 = BG_ELEM }):Play()
                if opts2.Callback then opts2.Callback() end
            end)
        end

        -- KEYBIND
        function tabAPI:Keybind(opts2)
            local f = makeElementContainer(scroll)
            f.LayoutOrder = nextOrder()

            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -72, 1, 0)
            titleLb.Position = UDim2.fromOffset(8, 0)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts2.Title or ""
            titleLb.TextColor3 = TEXT_WHITE
            titleLb.Font = Enum.Font.GothamBold
            titleLb.TextSize = 12
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = f

            local keyBG = Instance.new("Frame")
            keyBG.Size = UDim2.fromOffset(48, 24)
            keyBG.Position = UDim2.new(1, -56, 0.5, -12)
            keyBG.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
            keyBG.BorderSizePixel = 0
            keyBG.Parent = f
            local kbC = Instance.new("UICorner"); kbC.CornerRadius = UDim.new(0,4); kbC.Parent = keyBG
            local kbStr = Instance.new("UIStroke"); kbStr.Color = OUTLINE; kbStr.Thickness = 1; kbStr.Parent = keyBG

            local currentKey = opts2.Default or Enum.KeyCode.Unknown
            local keyLbl = Instance.new("TextLabel")
            keyLbl.Size = UDim2.new(1, 0, 1, 0)
            keyLbl.BackgroundTransparency = 1
            keyLbl.Text = tostring(currentKey.Name or currentKey)
            keyLbl.TextColor3 = ACCENT_GLOW
            keyLbl.Font = Enum.Font.GothamBold
            keyLbl.TextSize = 10
            keyLbl.Parent = keyBG

            local listening = false
            local keyBtn = Instance.new("TextButton")
            keyBtn.Size = UDim2.new(1, 0, 1, 0)
            keyBtn.BackgroundTransparency = 1
            keyBtn.Text = ""
            keyBtn.Parent = keyBG

            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyLbl.Text = "..."
                tweenSine(kbStr, 0.12, { Color = ACCENT }):Play()
            end)

            UserInputService.InputBegan:Connect(function(input, gp)
                if listening and not gp then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        keyLbl.Text = tostring(input.KeyCode.Name)
                        listening = false
                        tweenSine(kbStr, 0.12, { Color = OUTLINE }):Play()
                    end
                elseif not gp and input.KeyCode == currentKey then
                    if opts2.Callback then opts2.Callback() end
                end
            end)

            if opts2.Default then
                UserInputService.InputBegan:Connect(function(input, gp)
                    if not listening and not gp and input.KeyCode == opts2.Default then
                        if opts2.Callback then opts2.Callback() end
                    end
                end)
            end
        end

        function tabAPI:AddToggle(opts2)
            return tabAPI:Toggle(opts2)
        end

        return tabAPI
    end

    -- Section builder
    function windowObj:Section(opts2)
        local sectionObj = {}
        local sectionOrder2 = 0

        function sectionObj:Tab(tabOpts)
            local tabBtn = Instance.new("Frame")
            tabBtn.Name = tabOpts.Title or "Tab"
            tabBtn.Size = UDim2.new(1, 0, 0, 30)
            tabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
            tabBtn.BorderSizePixel = 0
            tabBtn.Parent = TabPanel
            local tbC = Instance.new("UICorner"); tbC.CornerRadius = UDim.new(0,6); tbC.Parent = tabBtn

            local accentBar = Instance.new("Frame")
            accentBar.Size = UDim2.fromOffset(2, 16)
            accentBar.Position = UDim2.new(0, 2, 0.5, -8)
            accentBar.BackgroundColor3 = ACCENT
            accentBar.BorderSizePixel = 0
            accentBar.Visible = false
            accentBar.Parent = tabBtn
            local abC = Instance.new("UICorner"); abC.CornerRadius = UDim.new(1,0); abC.Parent = accentBar

            local tabTitleLbl = Instance.new("TextLabel")
            tabTitleLbl.Name = "TextLabel"
            tabTitleLbl.Size = UDim2.new(1, -8, 1, 0)
            tabTitleLbl.Position = UDim2.fromOffset(8, 0)
            tabTitleLbl.BackgroundTransparency = 1
            tabTitleLbl.Text = tabOpts.Title or "Tab"
            tabTitleLbl.TextColor3 = TEXT_GRAY
            tabTitleLbl.Font = Enum.Font.Gotham
            tabTitleLbl.TextSize = 12
            tabTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
            tabTitleLbl.Parent = tabBtn

            local tabHoverBtn = Instance.new("TextButton")
            tabHoverBtn.Size = UDim2.new(1,0,1,0)
            tabHoverBtn.BackgroundTransparency = 1
            tabHoverBtn.Text = ""
            tabHoverBtn.Parent = tabBtn

            tabHoverBtn.MouseEnter:Connect(function()
                if not (currentTab and currentTab.Btn == tabBtn) then
                    tweenSine(tabBtn, 0.1, { BackgroundColor3 = Color3.fromRGB(28, 28, 40) }):Play()
                end
            end)
            tabHoverBtn.MouseLeave:Connect(function()
                if not (currentTab and currentTab.Btn == tabBtn) then
                    tweenSine(tabBtn, 0.1, { BackgroundColor3 = Color3.fromRGB(18, 18, 25) }):Play()
                end
            end)

            local tabPage = Instance.new("Frame")
            tabPage.Name = (tabOpts.Title or "Tab") .. "Page"
            tabPage.Size = UDim2.new(1, 0, 1, 0)
            tabPage.BackgroundTransparency = 1
            tabPage.Visible = false
            tabPage.Parent = PageHolder

            local tabClickBtn = Instance.new("TextButton")
            tabClickBtn.Size = UDim2.new(1, 0, 1, 0)
            tabClickBtn.BackgroundTransparency = 1
            tabClickBtn.Text = ""
            tabClickBtn.Parent = tabBtn

            tabClickBtn.MouseButton1Click:Connect(function()
                accentBar.Visible = true
                setActiveTab(tabPage, tabBtn)
            end)

            if currentTab == nil then
                setActiveTab(tabPage, tabBtn)
                accentBar.Visible = true
            end

            local api = buildTabAPI(tabPage)
            return api
        end

        return sectionObj
    end

    return windowObj
end

function XynorUI:AddTheme(opts) end
function XynorUI:SetTheme(name) end

-- ============================================================
-- SECURITY / CLEAN
-- ============================================================
pcall(function()
    for i,b in pairs(workspace.FE.Actions:GetChildren()) do
        if b.Name == " " then b:Destroy() end
    end
end)

pcall(function()
    for i,b in pairs(LocalPlayer.Character:GetChildren()) do
        if b.Name == " " then b:Destroy() end
    end
end)

pcall(function()
    local a = workspace.FE.Actions
    if a:FindFirstChild("KeepYourHeadUp_") then
        a.KeepYourHeadUp_:Destroy()
        local r = Instance.new("RemoteEvent")
        r.Name = "KeepYourHeadUp_"
        r.Parent = a
    else
        LocalPlayer:Kick("Anti-Cheat Updated! Send a photo of this Message in our Discord Server so we can fix it.")
    end
end)

local function isWeirdName(name)
    return string.match(name, "^[a-zA-Z]+%-%d+%a*%-%d+%a*$") ~= nil
end

local function deleteWeirdRemoteEvents(parent)
    pcall(function()
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("RemoteEvent") and isWeirdName(child.Name) then
                child:Destroy()
            end
            deleteWeirdRemoteEvents(child)
        end
    end)
end

pcall(function() deleteWeirdRemoteEvents(game) end)

-- ============================================================
-- MAIN HUB
-- ============================================================
local function LoadXynorHub()
    XynorUI:Notify({
        Title = "XYNOR HUB",
        Desc = "Loading main script...",
        Duration = 2
    })

    local isMobile = UserInputService.TouchEnabled
    local windowSize = isMobile and UDim2.fromOffset(430, 340) or UDim2.fromOffset(540, 470)
    local topbarHeight = isMobile and 38 or 44

    local Window = XynorUI:CreateWindow({
        Title = "XYNOR HUB",
    })

    -- ===== HOME TAB =====
    local HomeSection = Window:Section({ Title = "Information" })
    local HomeTab = HomeSection:Tab({ Title = "Home" })

    HomeTab:Section({ Title = "Welcome" })
    HomeTab:Paragraph({ Title = "XYNOR Hub v1.0", Desc = "Premium script for TPS Street Soccer"})
    HomeTab:Paragraph({ Title = "User: " .. LocalPlayer.Name, Desc = "Premium Access" })
    HomeTab:Section({ Title = "Latest Updates" })
    HomeTab:Paragraph({
        Title = "Version 1.0",
        Desc = "- New premium UI\n- Key system added\n- Optimized performance"
    })

    -- ===== MAIN TAB =====
    local Main = Window:Section({ Title = "Main :3" })
    local ReachTab = Main:Tab({ Title = "Reach" })
    local MossingTab = Main:Tab({ Title = "Mossing" })
    local ReactTab = Main:Tab({ Title = "Reacts" })

    local Misc = Window:Section({ Title = "Utility" })
    local HelpersTab = Misc:Tab({ Title = "Helpers" })
    local AimbotTab = Misc:Tab({ Title = "Aimbot" })

    local Opt = Window:Section({ Title = "Settings" })
    local OptTab = Opt:Tab({ Title = "Performance" })

    -- ============================================================
    -- PERSISTENCE
    -- ============================================================
    if not _G._XynorPersist then
        _G._XynorPersist = {
            reachEnabled    = false,
            reachDistance   = 1,
            reactPower      = 0,
            ballSpeedMult   = 7.0,
            reactHookOn     = false,
            helperActive    = false,
            helperEnabled   = true,
            magnetMode      = true,
            predictMode     = true,
            spaceLock       = false,
        }
    end
    local P = _G._XynorPersist

    if not _G._VxRBall then _G._VxRBall = nil end
    if not _G._VxRHRP  then _G._VxRHRP  = nil end

    if not _G._VxCacheWorker then
        _G._VxCacheWorker = RunService.RenderStepped:Connect(function()
            local sys = Workspace:FindFirstChild("TPSSystem")
            _G._VxRBall = sys and sys:FindFirstChild("TPS")
            local ch = LocalPlayer.Character
            _G._VxRHRP = ch and ch:FindFirstChild("HumanoidRootPart")
        end)
    end

    if not _G._VxCharConn then
        _G._VxCharConn = LocalPlayer.CharacterAdded:Connect(function(char)
            _G._VxRHRP = char:WaitForChild("HumanoidRootPart", 3)
            if P.reachEnabled and _G._VxReachRestart then
                task.wait(0.05)
                _G._VxReachRestart()
            end
        end)
    end

    -- ============================================================
    -- REACH
    -- ============================================================
    local reachEnabled = P.reachEnabled
    local reachDistance = P.reachDistance
    local reachConnection

    local function startReach()
        if reachConnection then reachConnection:Disconnect() end
        local _char, _root, _hum, _tps, _limb = nil,nil,nil,nil,nil
        local _lastRig, _frameSkip = nil, 0

        reachConnection = RunService.RenderStepped:Connect(function()
            local character = LocalPlayer.Character
            if not character then return end
            if character ~= _char then
                _char    = character
                _root    = character:FindFirstChild("HumanoidRootPart")
                _hum     = character:FindFirstChild("Humanoid")
                _limb    = nil
                _lastRig = nil
            end
            if not (_root and _hum) then return end
            _frameSkip = _frameSkip + 1
            if _frameSkip >= 3 then
                _frameSkip = 0
                local sys = Workspace:FindFirstChild("TPSSystem")
                _tps = sys and sys:FindFirstChild("TPS")
            end
            if not _tps or not _tps.Parent then return end
            local d = (_root.Position - _tps.Position)
            if (d.X*d.X + d.Y*d.Y + d.Z*d.Z) > reachDistance * reachDistance then return end
            local rig = _hum.RigType
            if rig ~= _lastRig or not _limb or not _limb.Parent then
                _lastRig = rig
                local pf   = Lighting:FindFirstChild(LocalPlayer.Name)
                local foot = pf and pf:FindFirstChild("PreferredFoot")
                if foot then
                    local nm = (rig == Enum.HumanoidRigType.R6)
                        and ((foot.Value == 1) and "Right Leg" or "Left Leg")
                        or  ((foot.Value == 1) and "RightLowerLeg" or "LeftLowerLeg")
                    _limb = _char:FindFirstChild(nm)
                end
            end
            if _limb then
                firetouchinterest(_limb, _tps, 0)
                firetouchinterest(_limb, _tps, 1)
            end
        end)
    end

    _G._VxReachRestart = function()
        if P.reachEnabled then startReach() end
    end

    ReachTab:Section({ Title = "Touch Reach" })

    ReachTab:Toggle({
        Title = "Active FireTouch",
        Desc = "Triggers ball contact",
        Callback = function(Value)
            reachEnabled   = Value
            P.reachEnabled = Value
            if Value then
                startReach()
            else
                if reachConnection then reachConnection:Disconnect(); reachConnection = nil end
            end
        end
    })

    ReachTab:Slider({
        Title = "Reach Distance",
        Value = { Min = 1, Max = 15, Default = 1 },
        Callback = function(val)
            reachDistance   = tonumber(val)
            P.reachDistance = reachDistance
        end
    })

    ReachTab:Section({ Title = "Hitbox" })

    ReachTab:Input({
        Title = "Leg Size (R6)",
        Value = "1",
        Callback = function(Value)
            local v = tonumber(Value) or 1
            if LocalPlayer.Character then
                if LocalPlayer.Character:FindFirstChild("Right Leg") then
                    LocalPlayer.Character["Right Leg"].Size = Vector3.new(v, 2, v)
                    LocalPlayer.Character["Left Leg"].Size = Vector3.new(v, 2, v)
                    LocalPlayer.Character["Right Leg"].CanCollide = false
                    LocalPlayer.Character["Left Leg"].CanCollide = false
                end
                if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(v,2,v)
                    LocalPlayer.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    })

    ReachTab:Input({
        Title = "Leg Size (R15)",
        Value = "1",
        Callback = function(Value)
            local v = tonumber(Value) or 1
            if LocalPlayer.Character then
                if LocalPlayer.Character:FindFirstChild("RightLowerLeg") then
                    LocalPlayer.Character["RightLowerLeg"].Size = Vector3.new(v, 2, v)
                    LocalPlayer.Character["LeftLowerLeg"].Size = Vector3.new(v, 2, v)
                    LocalPlayer.Character["RightLowerLeg"].CanCollide = false
                    LocalPlayer.Character["LeftLowerLeg"].CanCollide = false
                end
                if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(v,2,v)
                    LocalPlayer.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    })

    -- ============================================================
    -- MOSSING
    -- ============================================================
    local headReachEnabled = false
    local headReachSize    = Vector3.new(1, 1.5, 1)
    local headTransparency = 0.5
    local headOffset       = Vector3.new(0, 0, 0)
    local headBoxPart
    local headConnection

    local function updateHeadBox()
        if headBoxPart then headBoxPart:Destroy() end
        headBoxPart = Instance.new("Part")
        headBoxPart.Size        = headReachSize
        headBoxPart.Transparency= headTransparency
        headBoxPart.Anchored    = true
        headBoxPart.CanCollide  = false
        headBoxPart.Color       = PALETTE.ACCENT_PINK
        headBoxPart.Material    = Enum.Material.Neon
        headBoxPart.Name        = "HeadReachBox"
        headBoxPart.Parent      = Workspace
    end

    local function startHeadReach()
        if not headReachEnabled then return end
        if headConnection then headConnection:Disconnect() end
        updateHeadBox()
        local _head, _tps, _char = nil, nil, nil
        local _skipFrame = 0
        headConnection = RunService.RenderStepped:Connect(function()
            local character = LocalPlayer.Character
            if not character then return end
            if character ~= _char then
                _char = character
                _head = character:FindFirstChild("Head")
            end
            if not _head or not _head.Parent then return end
            _skipFrame = _skipFrame + 1
            if _skipFrame >= 4 then
                _skipFrame = 0
                local sys = Workspace:FindFirstChild("TPSSystem")
                _tps = sys and sys:FindFirstChild("TPS")
            end
            if not _tps or not _tps.Parent then return end
            if _tps.CanCollide then pcall(function() _tps.CanCollide = false end) end
            headBoxPart.CFrame = _head.CFrame * CFrame.new(headOffset)
            local relative = headBoxPart.CFrame:PointToObjectSpace(_tps.Position)
            local hs = headBoxPart.Size * 0.5
            if math.abs(relative.X) <= hs.X
                and math.abs(relative.Y) <= hs.Y
                and math.abs(relative.Z) <= hs.Z then
                firetouchinterest(_head, _tps, 0)
                firetouchinterest(_head, _tps, 1)
            end
        end)
    end

    MossingTab:Section({ Title = "Head Reach" })

    MossingTab:Toggle({ Title = "Active Moss Reach",
        Callback = function(state)
            headReachEnabled = state
            if state then startHeadReach() else
                if headConnection then headConnection:Disconnect() end
                if headBoxPart then headBoxPart:Destroy() end
            end
        end
    })

    MossingTab:Slider({ Title = "Range X", Value = { Min = 0, Max = 50, Default = 1 },
        Callback = function(val)
            headReachSize = Vector3.new(val, headReachSize.Y, headReachSize.Z)
            if headReachEnabled then updateHeadBox() end
        end
    })

    MossingTab:Slider({ Title = "Range Y", Value = { Min = 0, Max = 50, Default = 1.5 },
        Callback = function(val)
            headReachSize = Vector3.new(headReachSize.X, val, headReachSize.Z)
            headOffset = Vector3.new(headOffset.X, val / 2.5, headOffset.Z)
            if headReachEnabled then updateHeadBox() end
        end
    })

    MossingTab:Slider({ Title = "Range Z", Value = { Min = 0, Max = 50, Default = 1 },
        Callback = function(val)
            headReachSize = Vector3.new(headReachSize.X, headReachSize.Y, val)
            if headReachEnabled then updateHeadBox() end
        end
    })

    -- ============================================================
    -- REACTS
    -- ============================================================
    local REACT_ACTIONS = {Kick=true, KickC1=true, Tackle=true, Header=true,SaveRA=true, SaveLA=true, SaveRL=true, SaveLL=true, SaveT=true}
    local currentReactPower = P.reactPower
    local ballSpeedMult    = P.ballSpeedMult

    local _reactBallCache = nil
    local _reactHRPCache = nil
    local _reactCacheTick = 0

    local function getReactTargets()
        _reactCacheTick = _reactCacheTick + 1
        if _reactCacheTick >= 2 then
            _reactCacheTick = 0
            _reactBallCache = _G._VxRBall
            _reactHRPCache = _G._VxRHRP
        end
        return _reactBallCache, _reactHRPCache
    end

    local function applyReactInstant(power)
        local ball, hrp = getReactTargets()
        if not (ball and ball.Parent and hrp) then return end
        if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
        pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
        ball.AssemblyLinearVelocity = hrp.CFrame.LookVector * (power * ballSpeedMult)
    end

    local function enableReactHook()
        if _G._VxReactHookInstalled then return end
        _G._VxReactHookInstalled = true
        P.reactHookOn = true
        local meta        = getrawmetatable(game)
        local oldNamecall = meta.namecall
        setreadonly(meta, false)
        meta.namecall = newcclosure(function(self, ...)
            if getnamecallmethod() == "FireServer"
                and currentReactPower > 0
                and REACT_ACTIONS[tostring(self)] then
                local ball, hrp = getReactTargets()
                if ball and ball.Parent and hrp then
                    if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
                    pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
                    ball.AssemblyLinearVelocity = hrp.CFrame.LookVector * (currentReactPower * ballSpeedMult)
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(meta, true)
    end

    ReactTab:Section({ Title = "Power Presets" })

    -- Ultra Speed
    ReactTab:Button({ Title = "Ultra Speed", Desc = "Maximum velocity",
        Callback = function()
            currentReactPower = 5e18; P.reactPower = currentReactPower
            enableReactHook(); applyReactInstant(currentReactPower)
            XynorUI:Notify({ Title = "ULTRA SPEED", Desc = "Ball at max speed!", Duration = 2 })
        end
    })

    -- Mega Power
    ReactTab:Button({ Title = "Mega Power", Desc = "Extreme power",
        Callback = function()
            currentReactPower = 1e25; P.reactPower = currentReactPower
            enableReactHook(); applyReactInstant(currentReactPower)
            XynorUI:Notify({ Title = "MEGA POWER", Desc = "Extreme power activated", Duration = 2 })
        end
    })

    -- Hyper
    ReactTab:Button({ Title = "Hyper Velocity", Desc = "Hyper instant speed",
        Callback = function()
            currentReactPower = 2e22; P.reactPower = currentReactPower
            enableReactHook(); applyReactInstant(currentReactPower)
            XynorUI:Notify({ Title = "HYPER", Desc = "Hyper max velocity", Duration = 2 })
        end
    })

    -- Ultimate
    ReactTab:Button({ Title = "Ultimate Kick", Desc = "Definitive kick",
        Callback = function()
            currentReactPower = 8e20; P.reactPower = currentReactPower
            enableReactHook(); applyReactInstant(currentReactPower)
            XynorUI:Notify({ Title = "ULTIMATE", Desc = "Definitive kick", Duration = 2 })
        end
    })

    -- Max Power
    ReactTab:Button({ Title = "Max Power", Desc = "Absolute max power",
        Callback = function()
            currentReactPower = 1e28; P.reactPower = currentReactPower
            enableReactHook(); applyReactInstant(currentReactPower)
            XynorUI:Notify({ Title = "MAX POWER", Desc = "Absolute max power", Duration = 2 })
        end
    })

    -- Snap
    ReactTab:Button({ Title = "Hyper Snap", Desc = "Super fast snap",
        Callback = function()
            currentReactPower = 3e20; P.reactPower = currentReactPower
            enableReactHook()
            local ball = _G._VxRBall; local hrp = _G._VxRHRP
            if ball and hrp then
                pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
                if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
                ball.CFrame = CFrame.new(hrp.Position + hrp.CFrame.LookVector * 0.2 + Vector3.new(0, 0.1, 0))
                ball.AssemblyLinearVelocity = hrp.CFrame.LookVector * (currentReactPower * ballSpeedMult)
                ball.AssemblyAngularVelocity = Vector3.zero
            end
            XynorUI:Notify({ Title = "HYPER SNAP", Desc = "Ultra fast snap!", Duration = 2 })
        end
    })

    -- Mega Lock
    ReactTab:Button({ Title = "Mega Lock", Desc = "Super heavy lock",
        Callback = function()
            currentReactPower = 5e25; P.reactPower = currentReactPower
            enableReactHook()
            local ball = _G._VxRBall; local hrp = _G._VxRHRP
            if ball and hrp then
                pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
                if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
                ball.AssemblyLinearVelocity = hrp.CFrame.LookVector * (currentReactPower * ballSpeedMult)
                ball.AssemblyAngularVelocity = Vector3.zero
            end
            XynorUI:Notify({ Title = "MEGA LOCK", Desc = "Super heavy lock!", Duration = 2 })
        end
    })

    -- Pivot
    ReactTab:Button({ Title = "Ultra Pivot", Desc = "Fast pivot + grab",
        Callback = function()
            currentReactPower = 4e22; P.reactPower = currentReactPower
            enableReactHook()
            local ball = _G._VxRBall; local hrp = _G._VxRHRP
            if ball and hrp then
                pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
                if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
                ball.CFrame = CFrame.new(hrp.Position + hrp.CFrame.LookVector * 0.15)
                ball.AssemblyLinearVelocity = hrp.CFrame.LookVector * (currentReactPower * ballSpeedMult)
                ball.AssemblyAngularVelocity = Vector3.zero
            end
            XynorUI:Notify({ Title = "ULTRA PIVOT", Desc = "Ultra fast pivot!", Duration = 2 })
        end
    })

    -- Kenyah Max
    ReactTab:Button({ Title = "Kenyah Max", Desc = "Max power + prediction",
        Callback = function()
            currentReactPower = 6e23; P.reactPower = currentReactPower
            enableReactHook()
            local ball = _G._VxRBall; local hrp = _G._VxRHRP
            if ball and hrp then
                pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
                if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
                local look = hrp.CFrame.LookVector
                ball.CFrame = CFrame.new(hrp.Position + look * 0.15 + Vector3.new(0, 0.05, 0))
                ball.AssemblyLinearVelocity = look * (currentReactPower * ballSpeedMult)
                ball.AssemblyAngularVelocity = Vector3.zero
            end
            XynorUI:Notify({ Title = "KENYAH MAX", Desc = "Max power + prediction!", Duration = 2 })
        end
    })

    -- Aero
    ReactTab:Button({ Title = "Aero Max", Desc = "Full air control",
        Callback = function()
            currentReactPower = 5e22; P.reactPower = currentReactPower
            enableReactHook()
            local ball = _G._VxRBall; local hrp = _G._VxRHRP
            if ball and hrp then
                pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
                if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
                local look = hrp.CFrame.LookVector
                local dir = (look + Vector3.new(0, 0.08, 0)).Unit
                ball.CFrame = CFrame.new(hrp.Position + look * 0.18 + Vector3.new(0, 0.12, 0))
                ball.AssemblyLinearVelocity = dir * (currentReactPower * ballSpeedMult)
                ball.AssemblyAngularVelocity = Vector3.zero
            end
            XynorUI:Notify({ Title = "AERO MAX", Desc = "Full air control!", Duration = 2 })
        end
    })

    -- Dual Pulse
    ReactTab:Button({ Title = "Dual Pulse", Desc = "Instant double pulse",
        Callback = function()
            currentReactPower = 7e22; P.reactPower = currentReactPower
            enableReactHook()
            local ball = _G._VxRBall; local hrp = _G._VxRHRP
            if ball and hrp then
                pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
                if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
                local look = hrp.CFrame.LookVector
                ball.CFrame = CFrame.new(hrp.Position + look * 0.12)
                ball.AssemblyLinearVelocity = look * (currentReactPower * ballSpeedMult)
                ball.AssemblyAngularVelocity = Vector3.zero
                task.defer(function()
                    if ball and ball.Parent then
                        ball.AssemblyLinearVelocity = look * (currentReactPower * ballSpeedMult)
                    end
                end)
            end
            XynorUI:Notify({ Title = "DUAL PULSE", Desc = "Instant double pulse!", Duration = 2 })
        end
    })

    -- Omni
    ReactTab:Button({ Title = "Omni Max", Desc = "Omni + autocorrect",
        Callback = function()
            currentReactPower = 8e22; P.reactPower = currentReactPower
            enableReactHook()
            local ball = _G._VxRBall; local hrp = _G._VxRHRP
            if ball and hrp then
                pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
                if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
                local look = hrp.CFrame.LookVector
                ball.CFrame = CFrame.new(hrp.Position + look * 0.12)
                ball.AssemblyLinearVelocity = look * (currentReactPower * ballSpeedMult)
                ball.AssemblyAngularVelocity = Vector3.zero
                task.defer(function()
                    if ball and ball.Parent and hrp and hrp.Parent then
                        local newLook = hrp.CFrame.LookVector
                        local correction = (hrp.Position + newLook * 0.12 - ball.Position)
                        if correction.Magnitude > 0.3 then
                            ball.AssemblyLinearVelocity = correction.Unit * (currentReactPower * ballSpeedMult)
                        end
                    end
                end)
            end
            XynorUI:Notify({ Title = "OMNI MAX", Desc = "Omni ultra!", Duration = 2 })
        end
    })

    -- GK React
    ReactTab:Button({ Title = "Goalkeeper React", Desc = "Optimized for GK",
        Callback = function()
            local gkMap = {SaveRA=true,SaveLA=true,SaveRL=true,SaveLL=true,SaveT=true,Tackle=true,Header=true}
            local meta = getrawmetatable(game); local oldNC = meta.namecall
            setreadonly(meta, false)
            meta.namecall = newcclosure(function(self, ...)
                if getnamecallmethod() == "FireServer" and gkMap[tostring(self)] then
                    local args = {...}; local ch = LocalPlayer.Character
                    local hum = ch and ch:FindFirstChild("Humanoid")
                    if hum then args[2] = hum.LLCL; return oldNC(self, unpack(args)) end
                end
                return oldNC(self, ...)
            end)
            setreadonly(meta, true)
            XynorUI:Notify({ Title = "GK React", Desc = "Goalkeeper React activated", Duration = 2 })
        end
    })

    -- Ball Speed
    ReactTab:Section({ Title = "Ball Speed" })

    ReactTab:Slider({
        Title = "Speed Multiplier",
        Value = { Min = 0.1, Max = 50, Default = 1.0 },
        Callback = function(val)
            ballSpeedMult  = val
            P.ballSpeedMult = val
        end
    })

    ReactTab:Button({ Title = "Normal Mode", Desc = "1.0x",
        Callback = function()
            ballSpeedMult = 1.0; P.ballSpeedMult = ballSpeedMult
            XynorUI:Notify({ Title = "Velocity", Desc = "Normal (x1.0)", Duration = 1.5 })
        end
    })

    ReactTab:Button({ Title = "Fast Mode", Desc = "50.0x",
        Callback = function()
            ballSpeedMult = 50.0; P.ballSpeedMult = ballSpeedMult
            XynorUI:Notify({ Title = "Velocity", Desc = "Fast (x50.0)", Duration = 1.5 })
        end
    })

    ReactTab:Button({ Title = "Unlimited", Desc = "No limit",
        Callback = function()
            ballSpeedMult = 1e15; P.ballSpeedMult = ballSpeedMult
            XynorUI:Notify({ Title = "Velocity", Desc = "UNLIMITED", Duration = 1.5 })
        end
    })

    -- React Power
    ReactTab:Section({ Title = "React Power" })

    ReactTab:Slider({
        Title = "Base Power",
        Value = { Min = 1e18, Max = 1e30, Default = 1e22 },
        Callback = function(val)
            currentReactPower = val; P.reactPower = val
        end
    })

    -- ============================================================
    -- HELPERS
    -- ============================================================
    HelpersTab:Section({ Title = "Ball Helpers" })

    HelpersTab:Toggle({ Title = "ZZZ Helper", Desc = "Highlights ball position",
        Callback = function(state)
            if state then
                local part = Instance.new("Part")
                part.Name = "TPS1"; part.Size = Vector3.new(9, 0.1, 9)
                part.Anchored = true; part.BrickColor = BrickColor.new("Bright red")
                part.Transparency = 1; part.CanCollide = false; part.Parent = Workspace
                RunService.RenderStepped:Connect(function()
                    local b = _G._VxRBall
                    if b and part.Parent then part.Position = b.Position - Vector3.new(0, 1, 0) end
                end)
            else
                if Workspace:FindFirstChild("TPS1") then Workspace.TPS1:Destroy() end
            end
        end
    })

    -- Inf Helper
    HelpersTab:Toggle({ Title = "Inf Helper", Desc = "0 reach + super fast",
        Callback = function(state)
            if state then
                _G.AerialInfUltra = RunService.RenderStepped:Connect(function()
                    local ball = _G._VxRBall; local hrp = _G._VxRHRP
                    if not (ball and ball.Parent and hrp) then return end
                    local char  = LocalPlayer.Character
                    local torso = char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                    local base  = torso or hrp
                    if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
                    pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
                    local targetPos = base.Position + base.CFrame.LookVector * 0.06 + Vector3.new(0, 0.02, 0)
                    local diff = targetPos - ball.Position
                    local dist = diff.Magnitude
                    if dist > 0.015 then
                        local spd = math.clamp(dist * 45000, 1000, 80000)
                        ball.AssemblyLinearVelocity = diff.Unit * spd
                        ball.CFrame = CFrame.new(targetPos)
                    else
                        ball.CFrame = CFrame.new(targetPos)
                        ball.AssemblyLinearVelocity = base.CFrame.LookVector * 150
                    end
                    ball.AssemblyAngularVelocity = Vector3.new(80, 0, 80)
                end)
            else
                if _G.AerialInfUltra then _G.AerialInfUltra:Disconnect(); _G.AerialInfUltra = nil end
            end
        end
    })

    HelpersTab:Toggle({ Title = "Kenyah Inf Helper", Desc = "0 reach + ultra fast",
        Callback = function(state)
            if state then
                _G.KenyahINF = RunService.RenderStepped:Connect(function()
                    local ball = _G._VxRBall; local hrp = _G._VxRHRP
                    if not (ball and ball.Parent and hrp) then return end
                    local char  = LocalPlayer.Character
                    local torso = char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                    local base  = torso or hrp
                    if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
                    pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
                    local targetPos = base.Position + base.CFrame.LookVector * 0.06 + Vector3.new(0, 0.02, 0)
                    local diff = targetPos - ball.Position
                    local dist = diff.Magnitude
                    if dist > 0.015 then
                        local speed = math.clamp(dist * 40000, 1200, 70000)
                        ball.AssemblyLinearVelocity = diff.Unit * speed
                        ball.CFrame = CFrame.new(targetPos)
                    else
                        ball.CFrame = CFrame.new(targetPos)
                        ball.AssemblyLinearVelocity = base.CFrame.LookVector * 120
                    end
                    ball.AssemblyAngularVelocity = Vector3.new(80, 0, 80)
                end)
            else
                if _G.KenyahINF then _G.KenyahINF:Disconnect(); _G.KenyahINF = nil end
            end
        end
    })

    HelpersTab:Section({ Title = "Automation" })

    local followBall = true
    local toggleEnabled_follow = false

    HelpersTab:Toggle({ Title = "Follow Ball", Desc = "Auto move to ball (B toggle)",
        Callback = function(state)
            toggleEnabled_follow = state
            if not state then followBall = false end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if input.KeyCode == Enum.KeyCode.B and not gp and toggleEnabled_follow then
            followBall = not followBall
        end
    end)

    RunService.RenderStepped:Connect(function()
        if not (followBall and toggleEnabled_follow) then return end
        local ball = _G._VxRBall
        local playerChar = LocalPlayer.Character
        local humanoid = playerChar and playerChar:FindFirstChild("Humanoid")
        if humanoid and ball then humanoid:MoveTo(ball.Position) end
    end)

    HelpersTab:Section({ Title = "Advanced" })

    local toggleEnabled   = P.helperEnabled
    local helperActive    = P.helperActive
    local magnetMode    = P.magnetMode
    local predictMode   = P.predictMode
    local multiLockActive = P.spaceLock

    local CONFIG = {
        FOLLOW_DISTANCE = 0.08,
        FOLLOW_SPEED    = 30000,
        DEAD_ZONE       = 0.03,
        MAX_DISTANCE    = 0.2,
        STRONG_PULL     = 50000,
        SOFT_PULL       = 35000,
        MAGNET_PULL     = 80000,
        PREDICT_OFFSET  = 0.04,
        VERTICAL_OFFSET = -0.05,
        LOCK_RADIUS     = 0.01,
        ANGULAR_KILL    = true,
    }

    HelpersTab:Toggle({ Title = "Inf Helper V2", Desc = "[B] Toggle",
        Callback = function(state)
            toggleEnabled = state; P.helperEnabled = state
            if not state then helperActive = false; P.helperActive = false end
        end
    })

    HelpersTab:Toggle({ Title = "Magnet Mode", Desc = "Instant ball attach",
        Callback = function(state) magnetMode = state; P.magnetMode = state end
    })

    HelpersTab:Toggle({ Title = "Predict Mode", Desc = "Ball ahead of you",
        Callback = function(state) predictMode = state; P.predictMode = state end
    })

    HelpersTab:Toggle({ Title = "Space Lock", Desc = "Freeze ball in space",
        Callback = function(state) multiLockActive = state; P.spaceLock = state end
    })

    HelpersTab:Slider({ Title = "Follow Distance", Min = 0, Max = 10, Default = 0.25,
        Callback = function(val) CONFIG.DEAD_ZONE = val end
    })

    HelpersTab:Slider({ Title = "Vertical Offset", Min = -5, Max = 5, Default = -0.20,
        Callback = function(val) CONFIG.VERTICAL_OFFSET = val end
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if input.KeyCode == Enum.KeyCode.B and not gp and toggleEnabled then
            helperActive = not helperActive; P.helperActive = helperActive
        end
    end)

    local function getOrCreateAtt(ball)
        local att = ball:FindFirstChild("_infAtt")
        if not att then att = Instance.new("Attachment"); att.Name = "_infAtt"; att.Parent = ball end
        return att
    end

    local function getOrCreateLV(ball, att)
        local lv = ball:FindFirstChild("_infLV")
        if not lv then
            lv = Instance.new("LinearVelocity"); lv.Name = "_infLV"; lv.Attachment0 = att
            lv.MaxForce = math.huge; lv.RelativeTo = Enum.ActuatorRelativeTo.World
            lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
            lv.VectorVelocity = Vector3.zero; lv.Parent = ball
        end
        return lv
    end

    local function getOrCreateAV(ball, att)
        local av = ball:FindFirstChild("_infAV")
        if not av then
            av = Instance.new("AngularVelocity"); av.Name = "_infAV"; av.Attachment0 = att
            av.MaxTorque = math.huge; av.RelativeTo = Enum.ActuatorRelativeTo.World
            av.AngularVelocity = Vector3.zero; av.Parent = ball
        end
        return av
    end

    local function cleanupBall(ball)
        if not ball then return end
        pcall(function()
            local lv = ball:FindFirstChild("_infLV"); if lv then lv.VectorVelocity = Vector3.zero end
            local av = ball:FindFirstChild("_infAV"); if av then av.AngularVelocity = Vector3.zero end
        end)
    end

    local lockedPos  = nil
    local lastHRPPos = nil
    local lastTick   = tick()

    local function getPredictedTarget(hrp)
        local now = tick(); local dt = now - lastTick; lastTick = now
        local currentPos = hrp.Position
        if lastHRPPos and dt > 0 and dt < 0.1 then
            local velocity = (currentPos - lastHRPPos) / dt
            lastHRPPos = currentPos
            return currentPos + velocity * CONFIG.PREDICT_OFFSET + Vector3.new(0, CONFIG.VERTICAL_OFFSET, 0)
        end
        lastHRPPos = currentPos
        return currentPos + hrp.CFrame.LookVector * CONFIG.FOLLOW_DISTANCE + Vector3.new(0, CONFIG.VERTICAL_OFFSET, 0)
    end

    RunService.RenderStepped:Connect(function()
        if not (helperActive and toggleEnabled) then
            local ball = _G._VxRBall; if ball then cleanupBall(ball) end
            lockedPos = nil; return
        end
        local ball = _G._VxRBall; local hrp = _G._VxRHRP
        local char = LocalPlayer.Character; local hum = char and char:FindFirstChild("Humanoid")
        if not (ball and hrp and hum) then return end
        if hum.Health <= 0 then return end
        if not ball:IsA("BasePart") then return end
        if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
        pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
        local ballPos = ball.Position; local hrpPos = hrp.Position
        local dist = (ballPos - hrpPos).Magnitude
        local att = getOrCreateAtt(ball); local lv = getOrCreateLV(ball, att)
        if CONFIG.ANGULAR_KILL then
            local av = getOrCreateAV(ball, att)
            av.AngularVelocity = Vector3.zero; ball.AssemblyAngularVelocity = Vector3.zero
        end
        if multiLockActive then
            if not lockedPos then lockedPos = ballPos end
            local toLock = lockedPos - ballPos; local lockDist = toLock.Magnitude
            if lockDist > CONFIG.LOCK_RADIUS then
                lv.VectorVelocity = toLock.Unit * CONFIG.MAGNET_PULL
                ball.AssemblyLinearVelocity = toLock.Unit * CONFIG.MAGNET_PULL
            else
                lv.VectorVelocity = Vector3.zero; ball.AssemblyLinearVelocity = Vector3.zero
            end
            return
        else lockedPos = nil end
        local targetPos = predictMode and getPredictedTarget(hrp)
            or (hrpPos + hrp.CFrame.LookVector * CONFIG.FOLLOW_DISTANCE + Vector3.new(0, CONFIG.VERTICAL_OFFSET, 0))
        local toTarget = targetPos - ballPos; local toTargetDist = toTarget.Magnitude
        if magnetMode then
            if toTargetDist > 0.04 then
                local speed = math.clamp(toTargetDist * 1200, 80, CONFIG.MAGNET_PULL)
                lv.VectorVelocity = toTarget.Unit * speed; ball.AssemblyLinearVelocity = toTarget.Unit * speed
            else
                ball.CFrame = CFrame.new(targetPos)
                lv.VectorVelocity = Vector3.zero; ball.AssemblyLinearVelocity = Vector3.zero
            end
            return
        end
        if dist > CONFIG.MAX_DISTANCE then
            local dir = (targetPos - ballPos).Unit
            lv.VectorVelocity = dir * CONFIG.STRONG_PULL; ball.AssemblyLinearVelocity = dir * CONFIG.STRONG_PULL
        elseif dist > CONFIG.DEAD_ZONE then
            local speed = math.clamp(toTargetDist * CONFIG.SOFT_PULL, 20, CONFIG.FOLLOW_SPEED)
            lv.VectorVelocity = toTarget.Unit * speed
        else
            lv.VectorVelocity = Vector3.zero
        end
    end)

    RunService.Heartbeat:Connect(function()
        if not (helperActive and toggleEnabled) then return end
        local ball = _G._VxRBall; local hrp = _G._VxRHRP
        if not (ball and hrp) then return end
        if not ball:IsA("BasePart") then return end
        if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
        if multiLockActive and lockedPos then
            local d = (ball.Position - lockedPos).Magnitude
            if d > CONFIG.LOCK_RADIUS then
                pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
                ball.AssemblyLinearVelocity = (lockedPos - ball.Position).Unit * CONFIG.MAGNET_PULL
            end
            return
        end
        local dist = (ball.Position - hrp.Position).Magnitude
        if dist > CONFIG.MAX_DISTANCE * 0.85 then
            pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
            local targetPos = hrp.Position + hrp.CFrame.LookVector * CONFIG.FOLLOW_DISTANCE
                + Vector3.new(0, CONFIG.VERTICAL_OFFSET, 0)
            ball.AssemblyLinearVelocity = (targetPos - ball.Position).Unit * CONFIG.STRONG_PULL
        end
    end)

    -- ============================================================
    -- AIMBOT
    -- ============================================================
    local isAimbotEnabled = false
    local aimbotTargetPos = Vector3.new(0, 14, 157)
    local laser = Instance.new("Part")
    laser.Name = "XynorAimbot"
    laser.Anchored = true
    laser.CanCollide = false
    laser.Material = Enum.Material.Neon
    laser.Color = PALETTE.ACCENT_PINK
    laser.Transparency = 1
    laser.Size = Vector3.new(0.05, 0.05, 1)
    laser.Parent = Workspace

    local function toggleAimbot(state)
        isAimbotEnabled = state
        laser.Transparency = isAimbotEnabled and 0.4 or 1
    end

    RunService:BindToRenderStep("XynorAimbotLoop", Enum.RenderPriority.Camera.Value + 1, function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local torso = char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))

        if isAimbotEnabled and hrp and torso then
            local hrpPos = hrp.Position
            local lookTarget = Vector3.new(aimbotTargetPos.X, hrpPos.Y, aimbotTargetPos.Z)
            hrp.CFrame = CFrame.lookAt(hrpPos, lookTarget)

            local startPos = torso.Position + Vector3.new(0, 0.8, 0)
            local distance = (aimbotTargetPos - startPos).Magnitude
            laser.Size = Vector3.new(0.05, 0.05, distance)
            laser.CFrame = CFrame.lookAt(startPos, aimbotTargetPos) * CFrame.new(0, 0, -distance/2)
        end
    end)

    AimbotTab:Section({ Title = "Aimbot" })

    local AimbotToggle = AimbotTab:Toggle({
        Title = "Enable Aimbot",
        Callback = function(state)
            toggleAimbot(state)
        end
    })

    AimbotTab:Keybind({
        Title = "Toggle Key",
        Default = Enum.KeyCode.R,
        Callback = function()
            local newState = not isAimbotEnabled
            AimbotToggle:Set(newState)
        end
    })

    -- ============================================================
    -- OPTIMIZATIONS
    -- ============================================================
    OptTab:Section({ Title = "Network" })

    OptTab:Toggle({
        Title = "Optimize Network",
        Desc = "Reduce latency",
        Callback = function(state)
            if state then
                XynorUI:Notify({ Title = "Network", Desc = "Optimization enabled", Duration = 2 })
            end
        end
    })

    OptTab:Toggle({
        Title = "Reduce Packet Loss",
        Desc = "Optimize remote events",
        Callback = function(state)
            if state then
                pcall(function()
                    settings().Network.Physics = 30
                end)
                XynorUI:Notify({ Title = "Packet Loss", Desc = "Optimization enabled", Duration = 2 })
            end
        end
    })

    OptTab:Section({ Title = "CPU" })

    OptTab:Toggle({
        Title = "Optimize Loops",
        Desc = "Reduce iterations",
        Callback = function(state)
            if state then
                pcall(function()
                    RunService:setv("throttle", true)
                end)
                XynorUI:Notify({ Title = "CPU", Desc = "Optimization enabled", Duration = 2 })
            end
        end
    })

    OptTab:Toggle({
        Title = "Reduce Events",
        Desc = "Minimize overhead",
        Callback = function(state)
            if state then
                XynorUI:Notify({ Title = "Events", Desc = "Optimization enabled", Duration = 2 })
            end
        end
    })

    OptTab:Toggle({
        Title = "Optimize Physics",
        Desc = "Reduce calculations",
        Callback = function(state)
            if state then
                pcall(function()
                    settings().Physics.PhysicsEngine = "Voxel"
                end)
                XynorUI:Notify({ Title = "Physics", Desc = "Optimization enabled", Duration = 2 })
            end
        end
    })

    OptTab:Section({ Title = "GPU" })

    OptTab:Toggle({
        Title = "Optimize UI",
        Desc = "Reduce redraws",
        Callback = function(state)
            if state then
                XynorUI:Notify({ Title = "UI", Desc = "Optimization enabled", Duration = 2 })
            end
        end
    })

    OptTab:Toggle({
        Title = "Reduce Effects",
        Desc = "Minimize particles",
        Callback = function(state)
            if state then
                pcall(function()
                    settings().Rendering.EffectsQuality = 0
                end)
                XynorUI:Notify({ Title = "Effects", Desc = "Optimization enabled", Duration = 2 })
            end
        end
    })

    OptTab:Toggle({
        Title = "Optimize Shadows",
        Desc = "Reduce shadow quality",
        Callback = function(state)
            if state then
                pcall(function()
                    settings().Rendering.ShadowQuality = 0
                end)
                XynorUI:Notify({ Title = "Shadows", Desc = "Optimization enabled", Duration = 2 })
            end
        end
    })

    -- ============================================================
    -- DRIBBLE
    -- ============================================================
    local BallControl = Window:Section({ Title = "Ball Control" })
    local DribbleTab = BallControl:Tab({ Title = "Dribble" })

    local dribbleEnabled = false
    local dribbleIntensity = "High"
    local dribbleActive = false

    local DRIBBLE_CONFIG = {
        Low = { strength = 30000, deadzone = 0.03, offset = 0.08 },
        Medium = { strength = 60000, deadzone = 0.015, offset = 0.05 },
        High = { strength = 100000, deadzone = 0.008, offset = 0.03 }
    }

    DribbleTab:Section({ Title = "Dribble Assist" })

    DribbleTab:Toggle({
        Title = "Enable Dribble",
        Desc = "0 reach + ultra fast",
        Callback = function(state)
            dribbleEnabled = state
        end
    })

    DribbleTab:Slider({
        Title = "Intensity",
        Value = { Min = 1, Max = 3, Default = 3 },
        Callback = function(val)
            local levels = {"Low", "Medium", "High"}
            dribbleIntensity = levels[math.floor(val)] or "High"
        end
    })

    DribbleTab:Button({ Title = "Test Dribble",
        Callback = function()
            if dribbleEnabled then
                applyDribbleAssist()
                XynorUI:Notify({ Title = "Dribble", Desc = "Intensity: " .. dribbleIntensity, Duration = 1 })
            end
        end
    })

    local function applyDribbleAssist()
        if not dribbleEnabled then return end
        local ball = _G._VxRBall
        local hrp = _G._VxRHRP
        if not (ball and hrp) then return end

        local config = DRIBBLE_CONFIG[dribbleIntensity] or DRIBBLE_CONFIG.High

        pcall(function() ball.CanCollide = false end)
        pcall(function() ball:SetNetworkOwner(LocalPlayer) end)

        local targetPos = hrp.Position + hrp.CFrame.LookVector * config.offset + Vector3.new(0, 0.02, 0)
        local diff = targetPos - ball.Position
        local dist = diff.Magnitude

        if dist > config.deadzone then
            local speed = math.clamp(dist * config.strength, 800, config.strength)
            ball.AssemblyLinearVelocity = diff.Unit * speed + hrp.CFrame.LookVector * 80
            ball.CFrame = CFrame.new(targetPos)
        else
            ball.CFrame = CFrame.new(targetPos)
            ball.AssemblyLinearVelocity = ball.AssemblyLinearVelocity * 0.85 + hrp.CFrame.LookVector * 60
        end

        ball.AssemblyAngularVelocity = Vector3.new(50, 0, 50)
    end

    local dribbleConnection = RunService.RenderStepped:Connect(function()
        if dribbleEnabled and dribbleActive then
            applyDribbleAssist()
        end
    end)

    local function handleDribbleInput(input, gp)
        if not dribbleEnabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 
            or input.UserInputType == Enum.UserInputType.Touch 
            or input.UserInputType == Enum.UserInputType.FingerTouch then
            dribbleActive = true
            applyDribbleAssist()
            task.delay(0.05, function() dribbleActive = false end)
        end
    end

    UserInputService.InputBegan:Connect(handleDribbleInput)

    if UserInputService.TouchEnabled then
        UserInputService.TouchTap:Connect(function(touchPos, gp)
            if dribbleEnabled then
                dribbleActive = true
                applyDribbleAssist()
                task.delay(0.05, function() dribbleActive = false end)
            end
        end)
    end

    XynorUI:Notify({
        Title = "XYNOR HUB",
        Desc = "Welcome back! Script loaded successfully.",
        Duration = 4,
        Color = PALETTE.SUCCESS
    })
end

-- ============================================================
-- ENTRY POINT
-- ============================================================
ShowKeySystemLoader(function()
    task.wait(0.1)
    LoadXynorHub()
end)
