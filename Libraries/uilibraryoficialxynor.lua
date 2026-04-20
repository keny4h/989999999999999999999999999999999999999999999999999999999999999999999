-- ============================================================
-- XINOR UI LIBRARY - discord : SOON
-- Version 2.0 | Professional UI Library
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer

local XinorUI = {}
XinorUI.__index = XinorUI

-- ============================================================
-- PREMIUM COLOR PALETTE - Modern Dark Theme
-- ============================================================
local PALETTE = {
    BG_DARK       = Color3.fromRGB(10, 10, 14),
    BG_FRAME      = Color3.fromRGB(18, 18, 26),
    BG_ELEM       = Color3.fromRGB(28, 28, 40),
    BG_HOVER      = Color3.fromRGB(38, 38, 55),
    ACCENT        = Color3.fromRGB(88, 166, 255),
    ACCENT2       = Color3.fromRGB(59, 130, 246),
    ACCENT_GLOW   = Color3.fromRGB(115, 180, 255),
    ACCENT_CYAN   = Color3.fromRGB(34, 211, 238),
    ACCENT_GREEN  = Color3.fromRGB(52, 211, 153),
    ACCENT_PINK   = Color3.fromRGB(244, 114, 182),
    ACCENT_ORANGE = Color3.fromRGB(251, 146, 60),
    TEXT_WHITE    = Color3.fromRGB(255, 255, 255),
    TEXT_GRAY     = Color3.fromRGB(140, 140, 155),
    TEXT_MID      = Color3.fromRGB(180, 180, 195),
    OUTLINE       = Color3.fromRGB(50, 50, 70),
    OUTLINE_LIGHT = Color3.fromRGB(70, 70, 95),
    SUCCESS       = Color3.fromRGB(52, 211, 153),
    ERROR         = Color3.fromRGB(248, 113, 113),
    WARNING       = Color3.fromRGB(251, 191, 36),
}

local ACCENT      = PALETTE.ACCENT
local ACCENT2     = PALETTE.ACCENT2
local BG_DARK     = PALETTE.BG_DARK
local BG_FRAME    = PALETTE.BG_FRAME
local BG_ELEM     = PALETTE.BG_ELEM
local BG_HOVER    = PALETTE.BG_HOVER
local TEXT_WHITE  = PALETTE.TEXT_WHITE
local TEXT_GRAY   = PALETTE.TEXT_GRAY
local TEXT_MID    = PALETTE.TEXT_MID
local OUTLINE     = PALETTE.OUTLINE
local ACCENT_GLOW = PALETTE.ACCENT_GLOW

-- ============================================================
-- TWEEN HELPERS - Professional Easing Functions
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

local function tweenBounce(obj, t, props)
    return TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), props)
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
-- IMAGE ID CONSTANTS
-- ============================================================
local BACKGROUND_ID = "rbxassetid://83042365941419"
local LOGO_ID = "rbxassetid://91032354785729"

-- ============================================================
-- NOTIFICATION SYSTEM - Premium Style
-- ============================================================
function XinorUI:Notify(opts)
    local title = opts.Title or ""
    local desc = opts.Desc or ""
    local duration = opts.Duration or 3
    local color = opts.Color or ACCENT
    local icon = opts.Icon or ""

    local parent = getGuiParent()
    local existing = parent:FindFirstChild("XinorNotifGui")
    if existing then existing:Destroy() end

    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "XinorNotifGui"
    NotifGui.ResetOnSpawn = false
    NotifGui.IgnoreGuiInset = true
    NotifGui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(320, 72)
    frame.Position = UDim2.new(1, 20, 1, -90)
    frame.BackgroundColor3 = BG_FRAME
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = NotifGui
    local fC = Instance.new("UICorner"); fC.CornerRadius = UDim.new(0, 14); fC.Parent = frame

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.fromOffset(4, 48)
    accentBar.Position = UDim2.new(0, 0, 0.5, -24)
    accentBar.BackgroundColor3 = color
    accentBar.BorderSizePixel = 0
    accentBar.Parent = frame
    local abC = Instance.new("UICorner"); abC.CornerRadius = UDim.new(1,0); abC.Parent = accentBar

    local stroke = Instance.new("UIStroke")
    stroke.Color = OUTLINE
    stroke.Thickness = 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame

    local iconImg = Instance.new("ImageLabel")
    iconImg.Size = UDim2.fromOffset(32, 32)
    iconImg.Position = UDim2.fromOffset(16, 0)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = icon ~= "" and icon or LOGO_ID
    iconImg.ImageColor3 = color
    iconImg.ImageTransparency = 1
    iconImg.Parent = frame

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -70, 0.5, 0)
    titleLbl.Position = UDim2.fromOffset(58, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = TEXT_WHITE
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTransparency = 1
    titleLbl.Parent = frame

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -70, 0.5, 0)
    descLbl.Position = UDim2.new(0, 58, 0.5, -8)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = desc
    descLbl.TextColor3 = TEXT_GRAY
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 11
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextWrapped = true
    descLbl.TextTransparency = 1
    descLbl.Parent = frame

    tweenExpo(frame, 0.5, {
        Position = UDim2.new(1, -335, 1, -90),
        BackgroundTransparency = 0
    }):Play()

    task.delay(0.15, function()
        tweenSine(iconImg, 0.35, { ImageTransparency = 0 }):Play()
        task.delay(0.05, function()
            tweenSine(titleLbl, 0.3, { TextTransparency = 0 }):Play()
            task.delay(0.05, function()
                tweenSine(descLbl, 0.3, { TextTransparency = 0 }):Play()
            end)
        end)
    end)

    local notifObj = {}
    function notifObj:Close()
        if NotifGui and NotifGui.Parent then
            tweenQuint(frame, 0.35, {
                Position = UDim2.new(1, 20, 1, -90),
                BackgroundTransparency = 1
            }):Play()
            tweenSine(iconImg, 0.25, { ImageTransparency = 1 }):Play()
            tweenSine(titleLbl, 0.25, { TextTransparency = 1 }):Play()
            tweenSine(descLbl, 0.25, { TextTransparency = 1 }):Play()
            task.wait(0.4)
            NotifGui:Destroy()
        end
    end

    task.delay(duration, function()
        notifObj:Close()
    end)

    return notifObj
end

-- ============================================================
-- TOAST NOTIFICATION - Quick Popup
-- ============================================================
function XinorUI:Toast(message, duration)
    return XinorUI:Notify({
        Title = "Xinor UI",
        Desc = message,
        Duration = duration or 2,
        Color = ACCENT
    })
end

-- ============================================================
-- MAIN WINDOW - Advanced Framework
-- ============================================================
function XinorUI:CreateWindow(opts)
    local isMobile = UserInputService.TouchEnabled
    local winW = isMobile and 450 or 560
    local winH = isMobile and 360 or 490

    local guiParent = getGuiParent()

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XinorHubGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999
    ScreenGui.Enabled = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = guiParent

    -- Main Frame with Background
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    local newSize = 340
    MainFrame.Size = UDim2.fromOffset(newSize * 0.6, newSize * 0.6)
    MainFrame.Position = UDim2.new(0.5, -newSize/2, 0.5, -newSize/2)
    MainFrame.BackgroundColor3 = BG_DARK
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui
    local mainCorner = Instance.new("UICorner"); mainCorner.CornerRadius = UDim.new(0, 16); mainCorner.Parent = MainFrame
    local mainStroke = Instance.new("UIStroke"); mainStroke.Color = OUTLINE; mainStroke.Thickness = 1.5; mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; mainStroke.Parent = MainFrame

    -- Background Image
    local BGImage = Instance.new("ImageLabel")
    BGImage.Size = UDim2.new(1, 0, 1, 0)
    BGImage.Position = UDim2.new(0, 0, 0, 0)
    BGImage.BackgroundTransparency = 1
    BGImage.Image = BACKGROUND_ID
    BGImage.ScaleType = Enum.ScaleType.Crop
    BGImage.ImageTransparency = 0.85
    BGImage.Parent = MainFrame

    local BGDarkOverlay = Instance.new("Frame")
    BGDarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    BGDarkOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    BGDarkOverlay.BackgroundTransparency = 0.4
    BGDarkOverlay.BorderSizePixel = 0
    BGDarkOverlay.Parent = MainFrame
    local overlayCorner = Instance.new("UICorner"); overlayCorner.CornerRadius = UDim.new(0, 16); overlayCorner.Parent = BGDarkOverlay

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, isMobile and 40 or 48)
    Topbar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    Topbar.BorderSizePixel = 0
    Topbar.BackgroundTransparency = 1
    Topbar.Parent = MainFrame
    local topCorner = Instance.new("UICorner"); topCorner.CornerRadius = UDim.new(0, 16); topCorner.Parent = Topbar

    local topFix = Instance.new("Frame")
    topFix.Size = UDim2.new(1, 0, 0, 12)
    topFix.Position = UDim2.new(0, 0, 1, -12)
    topFix.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    topFix.BorderSizePixel = 0
    topFix.BackgroundTransparency = 1
    topFix.Parent = Topbar

    -- Accent gradient line
    local topAccentLine = Instance.new("Frame")
    topAccentLine.Size = UDim2.new(0, 0, 0, 2)
    topAccentLine.Position = UDim2.new(0, 0, 1, -2)
    topAccentLine.BackgroundColor3 = ACCENT
    topAccentLine.BorderSizePixel = 0
    topAccentLine.Parent = Topbar

    -- Logo
    local LogoImg = Instance.new("ImageLabel")
    LogoImg.Size = UDim2.fromOffset(28, 28)
    LogoImg.Position = UDim2.fromOffset(12, 0)
    LogoImg.BackgroundTransparency = 1
    LogoImg.Image = LOGO_ID
    LogoImg.ImageColor3 = ACCENT
    LogoImg.ImageTransparency = 1
    LogoImg.Parent = Topbar
    local logoCorner = Instance.new("UICorner"); logoCorner.CornerRadius = UDim.new(0, 6); logoCorner.Parent = LogoImg

    -- Title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0, 160, 0.5, 0)
    titleLbl.Position = UDim2.fromOffset(48, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = opts.Title or "XINOR UI"
    titleLbl.TextColor3 = TEXT_WHITE
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = isMobile and 15 or 17
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTransparency = 1
    titleLbl.Parent = Topbar

    -- Author
    local authorLbl = Instance.new("TextLabel")
    authorLbl.Size = UDim2.new(0, 160, 0.5, 0)
    authorLbl.Position = UDim2.new(0, 48, 0.5, 0)
    authorLbl.BackgroundTransparency = 1
    authorLbl.Text = "by xynor"
    authorLbl.TextColor3 = ACCENT_CYAN
    authorLbl.Font = Enum.Font.Gotham
    authorLbl.TextSize = isMobile and 10 or 11
    authorLbl.TextXAlignment = Enum.TextXAlignment.Left
    authorLbl.TextTransparency = 1
    authorLbl.Parent = Topbar

    -- Minimize Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.fromOffset(24, 24)
    MinBtn.Position = UDim2.new(1, -72, 0.5, -12)
    MinBtn.BackgroundColor3 = PALETTE.ACCENT_GREEN
    MinBtn.Text = "−"
    MinBtn.TextColor3 = BG_DARK
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 16
    MinBtn.BorderSizePixel = 0
    MinBtn.BackgroundTransparency = 1
    MinBtn.Parent = Topbar
    local minC = Instance.new("UICorner"); minC.CornerRadius = UDim.new(0, 6); minC.Parent = MinBtn

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.fromOffset(24, 24)
    CloseBtn.Position = UDim2.new(1, -42, 0.5, -12)
    CloseBtn.BackgroundColor3 = PALETTE.ERROR
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = TEXT_WHITE
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 11
    CloseBtn.BorderSizePixel = 0
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Parent = Topbar
    local clsC = Instance.new("UICorner"); clsC.CornerRadius = UDim.new(0, 6); clsC.Parent = CloseBtn

    local minimized = false
    local contentHeight = winH - (isMobile and 40 or 48)

    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -(isMobile and 40 or 48))
    ContentFrame.Position = UDim2.new(0, 0, 0, isMobile and 40 or 48)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- Tab Panel
    local TabPanel = Instance.new("ScrollingFrame")
    TabPanel.Name = "TabPanel"
    TabPanel.Size = UDim2.new(0, 150, 1, 0)
    TabPanel.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    TabPanel.BorderSizePixel = 0
    TabPanel.ScrollBarThickness = 0
    TabPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabPanel.BackgroundTransparency = 1
    TabPanel.Parent = ContentFrame

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 3)
    tabListLayout.Parent = TabPanel

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 8)
    tabPadding.PaddingLeft = UDim.new(0, 8)
    tabPadding.PaddingRight = UDim.new(0, 8)
    tabPadding.Parent = TabPanel

    -- Separator
    local Separator = Instance.new("Frame")
    Separator.Size = UDim2.new(0, 1, 1, 0)
    Separator.Position = UDim2.fromOffset(150, 0)
    Separator.BackgroundColor3 = OUTLINE
    Separator.BorderSizePixel = 0
    Separator.BackgroundTransparency = 1
    Separator.Parent = ContentFrame

    -- Page Holder
    local PageHolder = Instance.new("Frame")
    PageHolder.Name = "PageHolder"
    PageHolder.Size = UDim2.new(1, -152, 1, 0)
    PageHolder.Position = UDim2.fromOffset(152, 0)
    PageHolder.BackgroundTransparency = 1
    PageHolder.ClipsDescendants = true
    PageHolder.Parent = ContentFrame

    -- Opening Animation
    task.spawn(function()
        tweenBack(MainFrame, 0.4, {
            Size = UDim2.fromOffset(newSize, newSize),
            BackgroundTransparency = 0
        }):Play()

        task.wait(0.1)
        tweenExpo(BGDarkOverlay, 0.25, { BackgroundTransparency = 0.4 }):Play()
        tweenExpo(BGImage, 0.3, { ImageTransparency = 0.8 }):Play()

        task.wait(0.05)
        tweenExpo(Topbar, 0.22, { BackgroundTransparency = 0 }):Play()
        tweenExpo(topFix, 0.22, { BackgroundTransparency = 0 }):Play()
        tweenCirc(topAccentLine, 0.4, { Size = UDim2.new(1, 0, 0, 2) }):Play()

        task.wait(0.03)
        tweenSine(LogoImg, 0.2, { ImageTransparency = 0 }):Play()

        task.wait(0.02)
        tweenSine(titleLbl, 0.2, { TextTransparency = 0 }):Play()
        task.delay(0.02, function()
            tweenSine(authorLbl, 0.2, { TextTransparency = 0 }):Play()
        end)

        task.delay(0.03)
        tweenBack(MinBtn, 0.18, { BackgroundTransparency = 0 }):Play()
        task.delay(0.02, function()
            tweenBack(CloseBtn, 0.18, { BackgroundTransparency = 0 }):Play()
        end)

        task.delay(0.04)
        tweenExpo(TabPanel, 0.22, { BackgroundTransparency = 0 }):Play()
        tweenExpo(Separator, 0.22, { BackgroundTransparency = 0 }):Play()
    end)

    -- Drag Functionality
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

    -- Minimize Button Logic
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tweenQuint(MainFrame, 0.35, {
                Size = UDim2.fromOffset(winW, isMobile and 40 or 44)
            }):Play()
        else
            tweenQuint(MainFrame, 0.3, {
                Size = UDim2.fromOffset(winW, winH)
            }):Play()
        end
    end)

    -- Close Button Logic
    local closed = false
    CloseBtn.MouseButton1Click:Connect(function()
        if closed then return end
        closed = true
        
        tweenQuint(MainFrame, 0.3, { Size = UDim2.fromOffset(winW, 0), BackgroundTransparency = 1 }):Play()
        tweenSine(LogoImg, 0.2, { ImageTransparency = 1 }):Play()
        tweenSine(titleLbl, 0.2, { TextTransparency = 1 }):Play()
        tweenSine(authorLbl, 0.2, { TextTransparency = 1 }):Play()
        tweenSine(MinBtn, 0.15, { BackgroundTransparency = 1 }):Play()
        tweenSine(CloseBtn, 0.15, { BackgroundTransparency = 1 }):Play()
        task.wait(0.35)
        ScreenGui:Destroy()
    end)

    -- Floating Open Button (Circle with Logo)
    local OpenBtn = Instance.new("Frame")
    OpenBtn.Name = "XinorOpenBtn"
    OpenBtn.Size = UDim2.fromOffset(50, 50)
    OpenBtn.Position = UDim2.new(0.5, -25, 0.5, -25)
    OpenBtn.BackgroundColor3 = BG_FRAME
    OpenBtn.BorderSizePixel = 0
    OpenBtn.Visible = false
    OpenBtn.Parent = ScreenGui
    local obC = Instance.new("UICorner"); obC.CornerRadius = UDim.new(0, 25); obC.Parent = OpenBtn
    local obStroke = Instance.new("UIStroke"); obStroke.Color = ACCENT; obStroke.Thickness = 2; obStroke.Parent = OpenBtn

    local OpenBtnImg = Instance.new("ImageLabel")
    OpenBtnImg.Size = UDim2.new(1, -8, 1, -8)
    OpenBtnImg.Position = UDim2.new(0, 4, 0, 4)
    OpenBtnImg.BackgroundTransparency = 1
    OpenBtnImg.Image = LOGO_ID
    OpenBtnImg.ImageColor3 = ACCENT
    OpenBtnImg.Parent = OpenBtn

    local openBtnHover = Instance.new("TextButton")
    openBtnHover.Size = UDim2.new(1, 0, 1, 0)
    openBtnHover.BackgroundTransparency = 1
    openBtnHover.Text = ""
    openBtnHover.Parent = OpenBtn

    openBtnHover.MouseEnter:Connect(function()
        tweenSine(OpenBtn, 0.15, { BackgroundColor3 = BG_ELEM }):Play()
        tweenSine(OpenBtnImg, 0.15, { ImageColor3 = ACCENT_GLOW }):Play()
    end)
    openBtnHover.MouseLeave:Connect(function()
        tweenSine(OpenBtn, 0.15, { BackgroundColor3 = BG_FRAME }):Play()
        tweenSine(OpenBtnImg, 0.15, { ImageColor3 = ACCENT }):Play()
    end)

    openBtnHover.MouseButton1Click:Connect(function()
        OpenBtn.Visible = false
        MainFrame.Size = UDim2.fromOffset(winW, winH)
        MainFrame.Parent = ScreenGui
        tweenBack(MainFrame, 0.25, { Size = UDim2.fromOffset(winW, winH) }):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        OpenBtn.Visible = true
        tweenBack(OpenBtn, 0.3, { Size = UDim2.fromOffset(50, 50), BackgroundTransparency = 0 }):Play()
    end)

    -- Hover effects for topbar buttons
    MinBtn.MouseEnter:Connect(function()
        tweenSine(MinBtn, 0.12, { BackgroundColor3 = PALETTE.ACCENT_GREEN }):Play()
    end)
    MinBtn.MouseLeave:Connect(function()
        tweenSine(MinBtn, 0.12, { BackgroundColor3 = PALETTE.ACCENT_GREEN }):Play()
    end)

    CloseBtn.MouseEnter:Connect(function()
        tweenSine(CloseBtn, 0.12, { BackgroundColor3 = Color3.fromRGB(200, 80, 80) }):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        tweenSine(CloseBtn, 0.12, { BackgroundColor3 = PALETTE.ERROR }):Play()
    end)

    -- Window Object
    local windowObj = {}
    local currentTab = nil

    local function setActiveTab(tabPage, tabBtn)
        if currentTab then
            currentTab.Page.Visible = false
            TweenService:Create(currentTab.Btn, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                BackgroundColor3 = Color3.fromRGB(14, 14, 20),
                BackgroundTransparency = 0
            }):Play()
            local prevLbl = currentTab.Btn:FindFirstChildWhichIsA("TextLabel")
            if prevLbl then
                TweenService:Create(prevLbl, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {
                    TextColor3 = TEXT_GRAY
                }):Play()
            end
            local prevIcon = currentTab.Btn:FindFirstChild("Icon")
            if prevIcon then
                TweenService:Create(prevIcon, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {
                    ImageColor3 = TEXT_GRAY
                }):Play()
            end
        end
        tabPage.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
            BackgroundColor3 = BG_ELEM,
            BackgroundTransparency = 0
        }):Play()
        local lbl = tabBtn:FindFirstChildWhichIsA("TextLabel")
        if lbl then
            TweenService:Create(lbl, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                TextColor3 = ACCENT_GLOW
            }):Play()
        end
        local icon = tabBtn:FindFirstChild("Icon")
        if icon then
            TweenService:Create(icon, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                ImageColor3 = ACCENT
            }):Play()
        end
        currentTab = {Page = tabPage, Btn = tabBtn}
    end

    -- Element Container Factory
    local function makeElementContainer(parent)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -6, 0, 50)
        frame.BackgroundColor3 = BG_ELEM
        frame.BorderSizePixel = 0
        frame.Parent = parent
        local fCorner = Instance.new("UICorner"); fCorner.CornerRadius = UDim.new(0, 8); fCorner.Parent = frame
        local fStroke = Instance.new("UIStroke"); fStroke.Color = OUTLINE; fStroke.Thickness = 1; fStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; fStroke.Parent = frame

        local hoverBtn = Instance.new("TextButton")
        hoverBtn.Size = UDim2.new(1,0,1,0)
        hoverBtn.BackgroundTransparency = 1
        hoverBtn.Text = ""
        hoverBtn.ZIndex = 0
        hoverBtn.Parent = frame

        hoverBtn.MouseEnter:Connect(function()
            tweenSine(frame, 0.12, { BackgroundColor3 = BG_HOVER }):Play()
        end)
        hoverBtn.MouseLeave:Connect(function()
            tweenSine(frame, 0.12, { BackgroundColor3 = BG_ELEM }):Play()
        end)

        return frame
    end

    -- Tab API Builder
    local function buildTabAPI(page)
        local tabAPI = {}

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 4
        scroll.ScrollBarImageColor3 = ACCENT
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Parent = page

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 6)
        listLayout.Parent = scroll

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingLeft = UDim.new(0, 6)
        padding.PaddingRight = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 6)
        padding.Parent = scroll

        local elemOrder = 0
        local function nextOrder() elemOrder = elemOrder + 1 return elemOrder end

        -- SECTION
        function tabAPI:Section(opts2)
            local sFrame = Instance.new("Frame")
            sFrame.Size = UDim2.new(1, -6, 0, 24)
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
            sTitle.Position = UDim2.new(0, 8, 0, 0)
            sTitle.Text = "  " .. (opts2.Title or "") .. "  "
            sTitle.TextColor3 = ACCENT_CYAN
            sTitle.Font = Enum.Font.GothamBold
            sTitle.TextSize = 11
            sTitle.Parent = sFrame

            if opts2.Desc then
                local sDesc = Instance.new("TextLabel")
                sDesc.Size = UDim2.new(0, 0, 1, 0)
                sDesc.AutomaticSize = Enum.AutomaticSize.X
                sDesc.BackgroundColor3 = BG_DARK
                sDesc.BorderSizePixel = 0
                sDesc.Position = UDim2.new(0, sTitle.TextBounds.X + 12, 0, 0)
                sDesc.Text = "  " .. opts2.Desc .. "  "
                sDesc.TextColor3 = TEXT_GRAY
                sDesc.Font = Enum.Font.Gotham
                sDesc.TextSize = 10
                sDesc.Parent = sFrame
            end

            return sFrame
        end

        -- PARAGRAPH
        function tabAPI:Paragraph(opts2)
            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 48)
            f.LayoutOrder = nextOrder()

            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1, -12, 0.5, 0)
            t.Position = UDim2.fromOffset(10, 5)
            t.BackgroundTransparency = 1
            t.Text = opts2.Title or ""
            t.TextColor3 = TEXT_WHITE
            t.Font = Enum.Font.GothamBold
            t.TextSize = 12
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Parent = f

            local d = Instance.new("TextLabel")
            d.Size = UDim2.new(1, -12, 0.5, 0)
            d.Position = UDim2.new(0, 10, 0.5, -2)
            d.BackgroundTransparency = 1
            d.Text = opts2.Desc or ""
            d.TextColor3 = TEXT_GRAY
            d.Font = Enum.Font.Gotham
            d.TextSize = 10
            d.TextXAlignment = Enum.TextXAlignment.Left
            d.TextWrapped = true
            d.Parent = f
        end

        -- LABEL
        function tabAPI:Label(opts2)
            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 32)
            f.LayoutOrder = nextOrder()

            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1, -12, 1, 0)
            t.Position = UDim2.fromOffset(10, 0)
            t.BackgroundTransparency = 1
            t.Text = opts2.Text or ""
            t.TextColor3 = opts2.Color or TEXT_WHITE
            t.Font = opts2.Font or Enum.Font.GothamBold
            t.TextSize = opts2.Size or 12
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Parent = f
        end

        -- TOGGLE - Premium Switch Style
        function tabAPI:Toggle(opts2)
            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 48)
            f.LayoutOrder = nextOrder()

            local iconImg = nil
            if opts2.Icon and opts2.Icon ~= "" then
                iconImg = Instance.new("ImageLabel")
                iconImg.Size = UDim2.fromOffset(24, 24)
                iconImg.Position = UDim2.fromOffset(8, 0)
                iconImg.BackgroundTransparency = 1
                iconImg.Image = opts2.Icon
                iconImg.ImageColor3 = TEXT_GRAY
                iconImg.Parent = f
            end

            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -56, 0.5, 0)
            titleLb.Position = opts2.Icon and UDim2.fromOffset(40, 4) or UDim2.fromOffset(10, 4)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts2.Title or ""
            titleLb.TextColor3 = TEXT_WHITE
            titleLb.Font = Enum.Font.GothamBold
            titleLb.TextSize = 12
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = f

            if opts2.Desc and opts2.Desc ~= "" then
                local descLb = Instance.new("TextLabel")
                descLb.Size = UDim2.new(1, -56, 0.5, 0)
                descLb.Position = opts2.Icon and UDim2.new(0, 40, 0.5, 0) or UDim2.new(0, 10, 0.5, 0)
                descLb.BackgroundTransparency = 1
                descLb.Text = opts2.Desc
                descLb.TextColor3 = TEXT_GRAY
                descLb.Font = Enum.Font.Gotham
                descLb.TextSize = 10
                descLb.TextXAlignment = Enum.TextXAlignment.Left
                descLb.Parent = f
            end

            local switchBG = Instance.new("Frame")
            switchBG.Size = UDim2.fromOffset(40, 22)
            switchBG.Position = UDim2.new(1, -50, 0.5, -11)
            switchBG.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            switchBG.BorderSizePixel = 0
            switchBG.Parent = f
            local swC = Instance.new("UICorner"); swC.CornerRadius = UDim.new(1,0); swC.Parent = switchBG

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(16, 16)
            knob.Position = UDim2.fromOffset(3, 3)
            knob.BackgroundColor3 = TEXT_GRAY
            knob.BorderSizePixel = 0
            knob.Parent = switchBG
            local kC = Instance.new("UICorner"); kC.CornerRadius = UDim.new(1,0); kC.Parent = knob

            local glow = Instance.new("Frame")
            glow.Size = UDim2.new(1, 0, 1, 0)
            glow.Position = UDim2.new(0, 0, 0, 0)
            glow.BackgroundColor3 = ACCENT
            glow.BackgroundTransparency = 1
            glow.BorderSizePixel = 0
            glow.Parent = switchBG
            local glowC = Instance.new("UICorner"); glowC.CornerRadius = UDim.new(1,0); glowC.Parent = glow

            local value = opts2.Default or false
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = f

            local toggleObj = {}
            function toggleObj:Set(v)
                value = v
                TweenService:Create(switchBG, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = v and ACCENT or Color3.fromRGB(40, 40, 55)
                }):Play()
                TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = v and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3),
                    BackgroundColor3 = v and TEXT_WHITE or TEXT_GRAY
                }):Play()
                TweenService:Create(glow, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = v and 0.7 or 1
                }):Play()
                if opts2.Callback then opts2.Callback(v) end
            end

            if opts2.Default then toggleObj:Set(true) end

            btn.MouseButton1Click:Connect(function()
                tweenSine(f, 0.06, { BackgroundColor3 = Color3.fromRGB(45, 45, 65) }):Play()
                task.delay(0.06, function()
                    tweenSine(f, 0.1, { BackgroundColor3 = BG_ELEM }):Play()
                end)
                toggleObj:Set(not value)
            end)

            return toggleObj
        end

        -- SLIDER - Premium Style
        function tabAPI:Slider(opts2)
            local valData = opts2.Value or {}
            local minV = valData.Min or opts2.Min or 0
            local maxV = valData.Max or opts2.Max or 100
            local defV = valData.Default or opts2.Default or minV
            local currentVal = defV

            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 64)
            f.LayoutOrder = nextOrder()

            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -60, 0.5, 0)
            titleLb.Position = UDim2.fromOffset(10, 5)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts2.Title or ""
            titleLb.TextColor3 = TEXT_WHITE
            titleLb.Font = Enum.Font.GothamBold
            titleLb.TextSize = 12
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = f

            if opts2.Desc and opts2.Desc ~= "" then
                local descLb = Instance.new("TextLabel")
                descLb.Size = UDim2.new(1, -60, 0, 14)
                descLb.Position = UDim2.new(0, 10, 0, 20)
                descLb.BackgroundTransparency = 1
                descLb.Text = opts2.Desc
                descLb.TextColor3 = TEXT_GRAY
                descLb.Font = Enum.Font.Gotham
                descLb.TextSize = 10
                descLb.TextXAlignment = Enum.TextXAlignment.Left
                descLb.Parent = f
            end

            local valLbl = Instance.new("TextLabel")
            valLbl.Size = UDim2.fromOffset(50, 20)
            valLbl.Position = UDim2.new(1, -58, 0, 4)
            valLbl.BackgroundTransparency = 1
            valLbl.Text = tostring(defV)
            valLbl.TextColor3 = ACCENT_GLOW
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 12
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Parent = f

            local trackBG = Instance.new("Frame")
            trackBG.Size = UDim2.new(1, -16, 0, 6)
            trackBG.Position = UDim2.new(0, 8, 1, -16)
            trackBG.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            trackBG.BorderSizePixel = 0
            trackBG.Parent = f
            local trC = Instance.new("UICorner"); trC.CornerRadius = UDim.new(1,0); trC.Parent = trackBG

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((defV - minV) / (maxV - minV), 0, 1, 0)
            fill.BackgroundColor3 = ACCENT
            fill.BorderSizePixel = 0
            fill.Parent = trackBG
            local fC = Instance.new("UICorner"); fC.CornerRadius = UDim.new(1,0); fC.Parent = fill

            local fillGlow = Instance.new("Frame")
            fillGlow.Size = UDim2.new((defV - minV) / (maxV - minV), 0, 1, 0)
            fillGlow.BackgroundColor3 = ACCENT_GLOW
            fillGlow.BackgroundTransparency = 0.6
            fillGlow.BorderSizePixel = 0
            fillGlow.Position = UDim2.new(0, 0, 0, -2)
            fillGlow.Parent = trackBG
            local fgC = Instance.new("UICorner"); fgC.CornerRadius = UDim.new(1,0); fgC.Parent = fillGlow

            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Size = UDim2.new(1, 0, 0, 20)
            sliderBtn.Position = UDim2.new(0, 0, 1, -20)
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
                fillGlow.Size = UDim2.new(rel, 0, 1, 0)
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

        -- INPUT - TextBox
        function tabAPI:Input(opts2)
            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 58)
            f.LayoutOrder = nextOrder()

            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -12, 0, 16)
            titleLb.Position = UDim2.fromOffset(10, 5)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts2.Title or ""
            titleLb.TextColor3 = TEXT_WHITE
            titleLb.Font = Enum.Font.GothamBold
            titleLb.TextSize = 12
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = f

            if opts2.Desc and opts2.Desc ~= "" then
                local descLb = Instance.new("TextLabel")
                descLb.Size = UDim2.new(1, -12, 0, 12)
                descLb.Position = UDim2.fromOffset(10, 21)
                descLb.BackgroundTransparency = 1
                descLb.Text = opts2.Desc
                descLb.TextColor3 = TEXT_GRAY
                descLb.Font = Enum.Font.Gotham
                descLb.TextSize = 10
                descLb.TextXAlignment = Enum.TextXAlignment.Left
                descLb.Parent = f
            end

            local inputBG = Instance.new("Frame")
            inputBG.Size = UDim2.new(1, -16, 0, 22)
            inputBG.Position = UDim2.new(0, 8, 1, -28)
            inputBG.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
            inputBG.BorderSizePixel = 0
            inputBG.Parent = f
            local inC = Instance.new("UICorner"); inC.CornerRadius = UDim.new(0, 5); inC.Parent = inputBG
            local inStr = Instance.new("UIStroke"); inStr.Color = OUTLINE; inStr.Thickness = 1; inStr.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; inStr.Parent = inputBG

            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, -10, 1, 0)
            textBox.Position = UDim2.fromOffset(5, 0)
            textBox.BackgroundTransparency = 1
            textBox.Text = opts2.Value or ""
            textBox.PlaceholderText = opts2.Placeholder or "Enter value..."
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

        -- BUTTON - Premium Style
        function tabAPI:Button(opts2)
            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 42)
            f.LayoutOrder = nextOrder()

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = f

            local iconImg = nil
            if opts2.Icon and opts2.Icon ~= "" then
                iconImg = Instance.new("ImageLabel")
                iconImg.Size = UDim2.fromOffset(20, 20)
                iconImg.Position = UDim2.fromOffset(10, 0)
                iconImg.BackgroundTransparency = 1
                iconImg.Image = opts2.Icon
                iconImg.ImageColor3 = ACCENT
                iconImg.Parent = f
            end

            local startX = opts2.Icon and 38 or 10
            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -48, 1, 0)
            titleLb.Position = UDim2.fromOffset(startX, 0)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts2.Title or ""
            titleLb.TextColor3 = TEXT_WHITE
            titleLb.Font = Enum.Font.GothamBold
            titleLb.TextSize = 12
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = f

            if opts2.Desc and opts2.Desc ~= "" then
                titleLb.Size = UDim2.new(1, -48, 0.5, 0)
                titleLb.Position = UDim2.fromOffset(startX, 4)
                local descLb = Instance.new("TextLabel")
                descLb.Size = UDim2.new(1, -48, 0.5, 0)
                descLb.Position = UDim2.new(0, startX, 0.5, 0)
                descLb.BackgroundTransparency = 1
                descLb.Text = opts2.Desc
                descLb.TextColor3 = TEXT_GRAY
                descLb.Font = Enum.Font.Gotham
                descLb.TextSize = 10
                descLb.TextXAlignment = Enum.TextXAlignment.Left
                descLb.Parent = f
            end

            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.fromOffset(20, 20)
            arrow.Position = UDim2.new(1, -30, 0.5, -10)
            arrow.BackgroundTransparency = 1
            arrow.Text = "→"
            arrow.TextColor3 = ACCENT
            arrow.Font = Enum.Font.GothamBold
            arrow.TextSize = 16
            arrow.Parent = f

            btn.MouseEnter:Connect(function()
                tweenSine(f, 0.12, { BackgroundColor3 = BG_HOVER }):Play()
                tweenSine(arrow, 0.12, { TextColor3 = ACCENT_GLOW }):Play()
                if iconImg then tweenSine(iconImg, 0.12, { ImageColor3 = ACCENT_GLOW }):Play() end
            end)
            btn.MouseLeave:Connect(function()
                tweenSine(f, 0.12, { BackgroundColor3 = BG_ELEM }):Play()
                tweenSine(arrow, 0.12, { TextColor3 = ACCENT }):Play()
                if iconImg then tweenSine(iconImg, 0.12, { ImageColor3 = ACCENT }):Play() end
            end)

            btn.MouseButton1Down:Connect(function()
                tweenBack(f, 0.06, { Size = UDim2.new(1, -10, 0, 36) }):Play()
            end)
            btn.MouseButton1Up:Connect(function()
                tweenBack(f, 0.12, { Size = UDim2.new(1, -6, 0, 42) }):Play()
            end)

            btn.MouseButton1Click:Connect(function()
                tweenSine(f, 0.08, { BackgroundColor3 = Color3.fromRGB(50, 50, 70) }):Play()
                task.wait(0.1)
                tweenSine(f, 0.12, { BackgroundColor3 = BG_ELEM }):Play()
                if opts2.Callback then opts2.Callback() end
            end)
        end

        -- KEYBIND
        function tabAPI:Keybind(opts2)
            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 44)
            f.LayoutOrder = nextOrder()

            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -76, 1, 0)
            titleLb.Position = UDim2.fromOffset(10, 0)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts2.Title or ""
            titleLb.TextColor3 = TEXT_WHITE
            titleLb.Font = Enum.Font.GothamBold
            titleLb.TextSize = 12
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = f

            local keyBG = Instance.new("Frame")
            keyBG.Size = UDim2.fromOffset(52, 26)
            keyBG.Position = UDim2.new(1, -60, 0.5, -13)
            keyBG.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
            keyBG.BorderSizePixel = 0
            keyBG.Parent = f
            local kbC = Instance.new("UICorner"); kbC.CornerRadius = UDim.new(0, 5); kbC.Parent = keyBG
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

        -- DROPDOWN
        function tabAPI:Dropdown(opts2)
            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 44)
            f.LayoutOrder = nextOrder()

            local items = opts2.Items or {"Option 1", "Option 2", "Option 3"}
            local selected = opts2.Default or items[1]

            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -60, 0.5, 0)
            titleLb.Position = UDim2.fromOffset(10, 4)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts2.Title or ""
            titleLb.TextColor3 = TEXT_WHITE
            titleLb.Font = Enum.Font.GothamBold
            titleLb.TextSize = 12
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = f

            local selectedLbl = Instance.new("TextLabel")
            selectedLbl.Size = UDim2.new(1, -60, 0.5, 0)
            selectedLbl.Position = UDim2.new(0, 10, 0.5, -2)
            selectedLbl.BackgroundTransparency = 1
            selectedLbl.Text = selected
            selectedLbl.TextColor3 = ACCENT
            selectedLbl.Font = Enum.Font.Gotham
            selectedLbl.TextSize = 10
            selectedLbl.TextXAlignment = Enum.TextXAlignment.Left
            selectedLbl.Parent = f

            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Size = UDim2.new(1, 0, 1, 0)
            dropdownBtn.BackgroundTransparency = 1
            dropdownBtn.Text = ""
            dropdownBtn.Parent = f

            local expandIcon = Instance.new("TextLabel")
            expandIcon.Size = UDim2.fromOffset(20, 20)
            expandIcon.Position = UDim2.new(1, -28, 0.5, -10)
            expandIcon.BackgroundTransparency = 1
            expandIcon.Text = "▼"
            expandIcon.TextColor3 = TEXT_GRAY
            expandIcon.Font = Enum.Font.Gotham
            expandIcon.TextSize = 10
            expandIcon.Parent = f

            local dropdownOpen = false
            local dropdownItems = {}

            local function toggleDropdown()
                dropdownOpen = not dropdownOpen
                if dropdownOpen then
                    tweenSine(expandIcon, 0.2, { Rotation = 180 }):Play()
                    for i, item in ipairs(items) do
                        local itemBtn = Instance.new("TextButton")
                        itemBtn.Size = UDim2.new(1, 0, 0, 28)
                        itemBtn.Position = UDim2.new(0, 0, 0, 44 + (i * 28))
                        itemBtn.BackgroundColor3 = BG_ELEM
                        itemBtn.BorderSizePixel = 0
                        itemBtn.Text = ""
                        itemBtn.Parent = f
                        local itemC = Instance.new("UICorner"); itemC.CornerRadius = UDim.new(0, 6); itemC.Parent = itemBtn

                        local itemLbl = Instance.new("TextLabel")
                        itemLbl.Size = UDim2.new(1, -16, 1, 0)
                        itemLbl.Position = UDim2.fromOffset(8, 0)
                        itemLbl.BackgroundTransparency = 1
                        itemLbl.Text = item
                        itemLbl.TextColor3 = TEXT_WHITE
                        itemLbl.Font = Enum.Font.Gotham
                        itemLbl.TextSize = 11
                        itemLbl.TextXAlignment = Enum.TextXAlignment.Left
                        itemLbl.Parent = itemBtn

                        itemBtn.MouseEnter:Connect(function()
                            tweenSine(itemBtn, 0.1, { BackgroundColor3 = BG_HOVER }):Play()
                        end)
                        itemBtn.MouseLeave:Connect(function()
                            tweenSine(itemBtn, 0.1, { BackgroundColor3 = BG_ELEM }):Play()
                        end)

                        itemBtn.MouseButton1Click:Connect(function()
                            selected = item
                            selectedLbl.Text = item
                            tweenSine(expandIcon, 0.2, { Rotation = 0 }):Play()
                            for _, v in ipairs(dropdownItems) do
                                v:Destroy()
                            end
                            dropdownItems = {}
                            dropdownOpen = false
                            if opts2.Callback then opts2.Callback(item) end
                        end)

                        table.insert(dropdownItems, itemBtn)
                        f.Size = UDim2.new(1, -6, 0, 44 + (#items * 28))
                    end
                else
                    tweenSine(expandIcon, 0.2, { Rotation = 0 }):Play()
                    for _, v in ipairs(dropdownItems) do
                        v:Destroy()
                    end
                    dropdownItems = {}
                    f.Size = UDim2.new(1, -6, 0, 44)
                end
            end

            dropdownBtn.MouseButton1Click:Connect(toggleDropdown)
        end

        -- COLORPICKER (Simplified)
        function tabAPI:ColorPicker(opts2)
            local f = makeElementContainer(scroll)
            f.Size = UDim2.new(1, -6, 0, 48)
            f.LayoutOrder = nextOrder()

            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -56, 0.5, 0)
            titleLb.Position = UDim2.fromOffset(10, 4)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts2.Title or ""
            titleLb.TextColor3 = TEXT_WHITE
            titleLb.Font = Enum.Font.GothamBold
            titleLb.TextSize = 12
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = f

            local colorPreview = Instance.new("Frame")
            colorPreview.Size = UDim2.fromOffset(28, 28)
            colorPreview.Position = UDim2.new(1, -46, 0.5, -14)
            colorPreview.BackgroundColor3 = opts2.Default or ACCENT
            colorPreview.BorderSizePixel = 0
            colorPreview.Parent = f
            local cpC = Instance.new("UICorner"); cpC.CornerRadius = UDim.new(0, 6); cpC.Parent = colorPreview

            local colors = {ACCENT, PALETTE.ACCENT_CYAN, PALETTE.ACCENT_GREEN, PALETTE.ACCENT_PINK, PALETTE.ACCENT_ORANGE, PALETTE.WARNING, PALETTE.ERROR}
            local currentColor = 1

            local colorBtn = Instance.new("TextButton")
            colorBtn.Size = UDim2.new(1, 0, 1, 0)
            colorBtn.BackgroundTransparency = 1
            colorBtn.Text = ""
            colorBtn.Parent = f

            colorBtn.MouseButton1Click:Connect(function()
                currentColor = (currentColor % #colors) + 1
                tweenSine(colorPreview, 0.2, { BackgroundColor3 = colors[currentColor] }):Play()
                if opts2.Callback then opts2.Callback(colors[currentColor]) end
            end)
        end

        function tabAPI:AddToggle(opts2)
            return tabAPI:Toggle(opts2)
        end

        function tabAPI:AddButton(opts2)
            return tabAPI:Button(opts2)
        end

        function tabAPI:AddSlider(opts2)
            return tabAPI:Slider(opts2)
        end

        return tabAPI
    end

    -- Section Builder (Tabs)
    function windowObj:Section(opts2)
        local sectionObj = {}
        local sectionOrder2 = 0

        function sectionObj:Tab(tabOpts)
            local tabBtn = Instance.new("Frame")
            tabBtn.Name = tabOpts.Title or "Tab"
            tabBtn.Size = UDim2.new(1, 0, 0, 36)
            tabBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
            tabBtn.BorderSizePixel = 0
            tabBtn.Parent = TabPanel
            local tbC = Instance.new("UICorner"); tbC.CornerRadius = UDim.new(0, 8); tbC.Parent = tabBtn

            local accentBar = Instance.new("Frame")
            accentBar.Size = UDim2.fromOffset(3, 20)
            accentBar.Position = UDim2.new(0, 3, 0.5, -10)
            accentBar.BackgroundColor3 = ACCENT
            accentBar.BorderSizePixel = 0
            accentBar.Visible = false
            accentBar.Parent = tabBtn

            local tabIcon = nil
            if tabOpts.Icon and tabOpts.Icon ~= "" then
                tabIcon = Instance.new("ImageLabel")
                tabIcon.Name = "Icon"
                tabIcon.Size = UDim2.fromOffset(18, 18)
                tabIcon.Position = UDim2.fromOffset(10, 0)
                tabIcon.BackgroundTransparency = 1
                tabIcon.Image = tabOpts.Icon
                tabIcon.ImageColor3 = TEXT_GRAY
                tabIcon.Parent = tabBtn
            end

            local tabLbl = Instance.new("TextLabel")
            tabLbl.Size = UDim2.new(1, -10, 1, 0)
            tabLbl.Position = UDim2.fromOffset(tabOpts.Icon and 34 or 10, 0)
            tabLbl.BackgroundTransparency = 1
            tabLbl.Text = tabOpts.Title or "Tab"
            tabLbl.TextColor3 = TEXT_GRAY
            tabLbl.Font = Enum.Font.GothamBold
            tabLbl.TextSize = 12
            tabLbl.TextXAlignment = Enum.TextXAlignment.Left
            tabLbl.Parent = tabBtn

            local page = Instance.new("ScrollingFrame")
            page.Name = "Page"
            page.Size = UDim2.new(1, 0, 1, 0)
            page.BackgroundTransparency = 1
            page.BorderSizePixel = 0
            page.ScrollBarThickness = 0
            page.CanvasSize = UDim2.new(0, 0, 0, 0)
            page.AutomaticCanvasSize = Enum.AutomaticSize.Y
            page.Visible = false
            page.Parent = PageHolder

            local tabAPI = buildTabAPI(page)

            tabBtn.MouseEnter:Connect(function()
                if currentTab and currentTab.Btn == tabBtn then return end
                tweenSine(tabBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(22, 22, 32) }):Play()
            end)
            tabBtn.MouseLeave:Connect(function()
                if currentTab and currentTab.Btn == tabBtn then return end
                tweenSine(tabBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(14, 14, 20) }):Play()
            end)

            tabBtn.MouseButton1Click:Connect(function()
                setActiveTab(page, tabBtn)
            end)

            if not currentTab then
                task.delay(0.5, function()
                    setActiveTab(page, tabBtn)
                end)
            end

            return tabAPI
        end

        return sectionObj
    end

    -- Create Info Tab
    function windowObj:CreateInfoTab()
        local tab = self:Section({}):Tab({
            Title = "Info",
            Icon = LOGO_ID
        })

        tab:Section({ Title = "XINOR UI", Desc = "Premium Library" })

        tab:Paragraph({
            Title = "XinorUI v2.0",
            Desc = "Advanced UI Library for Roblox with premium design, smooth animations and professional components."
        })

        tab:Button({
            Title = "Join Discord",
            Desc = "Click to join our community",
            Icon = "rbxassetid://7733658504",
            Callback = function()
                local HTTP = syn and syn.request or http_request or request
                local Success = false
                if HTTP then
                    pcall(function()
                        HTTP({Url = "https://discord.gg/aNkfDP2V", Method = "GET"})
                        Success = true
                    end)
                end
                if not Success then
                    setclipboard("https://discord.gg/aNkfDP2V")
                    XinorUI:Notify({
                        Title = "Discord",
                        Desc = "Link copied to clipboard!",
                        Duration = 3,
                        Color = PALETTE.ACCENT_CYAN
                    })
                end
            end
        })

        tab:Label({
            Text = "Created by xynor",
            Color = ACCENT_CYAN,
            Size = 11
        })

        tab:Label({
            Text = "Version 2.0.0",
            Color = TEXT_GRAY,
            Size = 10
        })

        return tab
    end

    return windowObj
end

-- ============================================================
-- LOADER - Premium Loading Screen
-- ============================================================
function XinorUI:Loader(onFinished)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XinorLoaderGui"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = getGuiParent()

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = BG_DARK
    bg.BackgroundTransparency = 0
    bg.Parent = ScreenGui

    local loaderFrame = Instance.new("Frame")
    loaderFrame.Size = UDim2.fromOffset(300, 220)
    loaderFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
    loaderFrame.BackgroundColor3 = BG_FRAME
    loaderFrame.BorderSizePixel = 0
    loaderFrame.Parent = ScreenGui
    local lfC = Instance.new("UICorner"); lfC.CornerRadius = UDim.new(0, 18); lfC.Parent = loaderFrame
    local lfStroke = Instance.new("UIStroke"); lfStroke.Color = OUTLINE; lfStroke.Thickness = 1.5; lfStroke.Parent = loaderFrame

    local logoImg = Instance.new("ImageLabel")
    logoImg.Size = UDim2.fromOffset(50, 50)
    logoImg.Position = UDim2.new(0.5, -25, 0, 20)
    logoImg.BackgroundTransparency = 1
    logoImg.Image = LOGO_ID
    logoImg.ImageColor3 = ACCENT
    logoImg.ImageTransparency = 1
    logoImg.Parent = loaderFrame
    local logoC = Instance.new("UICorner"); logoC.CornerRadius = UDim.new(0, 10); logoC.Parent = logoImg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 80)
    title.BackgroundTransparency = 1
    title.Text = "XINOR UI"
    title.TextColor3 = TEXT_WHITE
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextTransparency = 1
    title.Parent = loaderFrame

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 110)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Premium UI Library"
    subtitle.TextColor3 = TEXT_GRAY
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 13
    subtitle.TextTransparency = 1
    subtitle.Parent = loaderFrame

    local progBG = Instance.new("Frame")
    progBG.Size = UDim2.new(0.8, 0, 0, 6)
    progBG.Position = UDim2.new(0.1, 0, 0.5, 30)
    progBG.BackgroundColor3 = BG_ELEM
    progBG.BorderSizePixel = 0
    progBG.Parent = loaderFrame
    local pbC = Instance.new("UICorner"); pbC.CornerRadius = UDim.new(1,0); pbC.Parent = progBG

    local progFill = Instance.new("Frame")
    progFill.Size = UDim2.new(0, 0, 1, 0)
    progFill.Position = UDim2.new(0, 0, 0, 0)
    progFill.BackgroundColor3 = ACCENT
    progFill.BorderSizePixel = 0
    progFill.Parent = progBG
    local pfC = Instance.new("UICorner"); pfC.CornerRadius = UDim.new(1,0); pfC.Parent = progFill

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0.7, -10)
    status.BackgroundTransparency = 1
    status.Text = "Initializing..."
    status.TextColor3 = TEXT_MID
    status.Font = Enum.Font.Gotham
    status.TextSize = 11
    status.TextTransparency = 1
    status.Parent = loaderFrame

    local ver = Instance.new("TextLabel")
    ver.Size = UDim2.new(1, 0, 0, 16)
    ver.Position = UDim2.new(0, 0, 1, -20)
    ver.BackgroundTransparency = 1
    ver.Text = "Version 2.0 | Premium "
    ver.TextColor3 = TEXT_GRAY
    ver.Font = Enum.Font.Gotham
    ver.TextSize = 10
    ver.TextTransparency = 1
    ver.Parent = loaderFrame

    task.spawn(function()
        tweenBack(loaderFrame, 0.4, { Size = UDim2.fromOffset(300, 220), BackgroundTransparency = 0 }):Play()
        task.wait(0.15)
        tweenSine(logoImg, 0.3, { ImageTransparency = 0 }):Play()
        task.wait(0.08)
        tweenSine(title, 0.25, { TextTransparency = 0 }):Play()
        task.wait(0.05)
        tweenSine(subtitle, 0.2, { TextTransparency = 0 }):Play()
        task.wait(0.05)
        tweenSine(progBG, 0.2, { BackgroundTransparency = 0 }):Play()
        tweenSine(status, 0.2, { TextTransparency = 0 }):Play()
        tweenSine(ver, 0.2, { TextTransparency = 0 }):Play()
    end)

    local steps = {
        { txt = "Loading modules...", delay = 0.3 },
        { txt = "Initializing UI...", delay = 0.25 },
        { txt = "Preparing components...", delay = 0.2 },
        { txt = "Almost ready...", delay = 0.15 },
    }

    task.wait(0.5)
    for i, step in ipairs(steps) do
        status.Text = step.txt
        tweenQuint(progFill, step.delay, { Size = UDim2.new(i / #steps, 0, 1, 0) }):Play()
        task.wait(step.delay + 0.1)
    end

    task.wait(0.3)
    status.Text = "Ready!"
    tweenQuint(progFill, 0.2, { Size = UDim2.new(1, 0, 1, 0) }):Play()
    task.wait(0.4)
    tweenExpo(bg, 0.4, { BackgroundTransparency = 1 }):Play()
    tweenExpo(loaderFrame, 0.35, { BackgroundTransparency = 1 }):Play()
    task.wait(0.45)
    ScreenGui:Destroy()
    if onFinished then onFinished() end
end

-- ============================================================
-- DRAG FUNCTION
-- ============================================================
function XinorUI:MakeDraggable(frame)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

return XinorUI
