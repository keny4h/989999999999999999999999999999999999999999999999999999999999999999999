--[[
    ═══════════════════════════════════════════════════════════════
                         XYNOR HUB v3.0
                    LOADER → ICONO → UI PRINCIPAL
    ═══════════════════════════════════════════════════════════════
--]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════
-- TWEENS
-- ═══════════════════════════════════════════════════════════════
local function tween(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
end

local smooth = tween
local elastic = function(o,d,p) return tween(o,d,p,Enum.EasingStyle.Elastic) end
local spring = function(o,d,p) return tween(o,d,p,Enum.EasingStyle.Back) end

-- ═══════════════════════════════════════════════════════════════
-- THEME
-- ═══════════════════════════════════════════════════════════════
local Theme = {
    Primary = Color3.fromRGB(147, 112, 219),
    PrimaryDark = Color3.fromRGB(125, 80, 190),
    White = Color3.fromRGB(255, 255, 255),
    WarmWhite = Color3.fromRGB(248, 246, 243),
    LightGray = Color3.fromRGB(240, 238, 235),
    TextPrimary = Color3.fromRGB(55, 45, 65),
    TextSecondary = Color3.fromRGB(95, 85, 115),
    TextMuted = Color3.fromRGB(140, 130, 150),
    Border = Color3.fromRGB(220, 215, 205),
    Panel = Color3.fromRGB(255, 253, 250),
    Success = Color3.fromRGB(129, 199, 132),
    Danger = Color3.fromRGB(239, 154, 154),
}

-- ═══════════════════════════════════════════════════════════════
-- GET GUI PARENT
-- ═══════════════════════════════════════════════════════════════
local function getGuiParent()
    if gethui then return gethui() end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- ═══════════════════════════════════════════════════════════════
-- KEY SYSTEM
-- ═══════════════════════════════════════════════════════════════
local KeySystem = {
    StorageName = "XynorKey_v3",
    ValidKeys = {"123", "xynor", "premium", "beta", "v3", "xynorhub", "kenyah"}
}

function KeySystem:GetSaved()
    local success, result = pcall(function()
        if readfile then return readfile(self.StorageName) end
        return nil
    end)
    return success and result or nil
end

function KeySystem:Save(key)
    pcall(function()
        if writefile then writefile(self.StorageName, key) end
    end)
end

function KeySystem:Check(key)
    key = string.lower(key or "")
    for _, valid in ipairs(self.ValidKeys) do
        if key == string.lower(valid) then return true end
    end
    return false
end

-- ═══════════════════════════════════════════════════════════════
-- LOADER
-- ═══════════════════════════════════════════════════════════════
local function CreateLoader()
    local Parent = getGuiParent()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XynorLoader"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Parent

    -- Container
    local Container = Instance.new("Frame")
    Container.Size = UDim2.fromOffset(380, 280)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.BackgroundColor3 = Theme.White
    Container.BorderSizePixel = 0
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Visible = false
    Container.Parent = ScreenGui

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 20)
    cCorner.Parent = Container

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, -4)
    shadow.BackgroundColor3 = Color3.fromRGB(160, 155, 150)
    shadow.BackgroundTransparency = 0.9
    shadow.BorderSizePixel = 0
    shadow.ZIndex = Container.ZIndex - 1
    shadow.Parent = Container
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0, 24); sc.Parent = shadow

    local topAccent = Instance.new("Frame")
    topAccent.Size = UDim2.new(1, 0, 0, 4)
    topAccent.Position = UDim2.new(0, 0, 0, 0)
    topAccent.BackgroundColor3 = Theme.Primary
    topAccent.BorderSizePixel = 0
    topAccent.Parent = Container

    -- Logo section
    local LogoSection = Instance.new("Frame")
    LogoSection.Size = UDim2.new(1, 0, 0, 80)
    LogoSection.Position = UDim2.new(0, 0, 0, 20)
    LogoSection.BackgroundTransparency = 1
    LogoSection.Parent = Container

    local MainTitle = LogoSection:FindFirstChildWhichIsA("TextLabel") or Instance.new("TextLabel")
    MainTitle.Size = UDim2.new(1, -60, 0.5, 0)
    MainTitle.Position = UDim2.new(0, 30, 0, 0)
    MainTitle.BackgroundTransparency = 1
    MainTitle.Text = "XYNOR"
    MainTitle.TextColor3 = Theme.TextPrimary
    MainTitle.Font = Enum.Font.GothamBlack
    MainTitle.TextSize = 30
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    MainTitle.TextTransparency = 1
    MainTitle.Parent = LogoSection

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, -60, 0, 18)
    SubTitle.Position = UDim2.new(0, 30, 0.5, 0)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Premium Hub v3"
    SubTitle.TextColor3 = Theme.Primary
    SubTitle.Font = Enum.Font.GothamMedium
    SubTitle.TextSize = 12
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.TextTransparency = 1
    SubTitle.Parent = LogoSection

    -- Progress bar
    local ProgressBg = Instance.new("Frame")
    ProgressBg.Size = UDim2.new(1, -80, 0, 5)
    ProgressBg.Position = UDim2.new(0, 40, 0, 105)
    ProgressBg.BackgroundColor3 = Theme.LightGray
    ProgressBg.BorderSizePixel = 0
    ProgressBg.Parent = Container
    local pbc = Instance.new("UICorner"); pbc.CornerRadius = UDim.new(1, 0); pbc.Parent = ProgressBg

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = Theme.Primary
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = ProgressBg
    local pfc = Instance.new("UICorner"); pfc.CornerRadius = UDim.new(1, 0); pfc.Parent = ProgressBar

    local ProgressText = Instance.new("TextLabel")
    ProgressText.Size = UDim2.new(1, 0, 0, 18)
    ProgressText.Position = UDim2.new(0, 0, 0, 118)
    ProgressText.BackgroundTransparency = 1
    ProgressText.Text = "Loading..."
    ProgressText.TextColor3 = Theme.TextSecondary
    ProgressText.Font = Enum.Font.Gotham
    ProgressText.TextSize = 11
    ProgressText.TextXAlignment = Enum.TextXAlignment.Center
    ProgressText.TextTransparency = 1
    ProgressText.Parent = Container

    -- Dots
    local DotsFrame = Instance.new("Frame")
    DotsFrame.Size = UDim2.new(0, 50, 0, 12)
    DotsFrame.Position = UDim2.new(0.5, -25, 0, 145)
    DotsFrame.BackgroundTransparency = 1
    DotsFrame.Parent = Container

    local dots = {}
    for i = 1, 3 do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.fromOffset(6, 6)
        dot.Position = UDim2.new(0, (i-1)*18, 0.5, -3)
        dot.BackgroundColor3 = Theme.TextMuted
        dot.BackgroundTransparency = 1
        dot.BorderSizePixel = 0
        dot.Parent = DotsFrame
        local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(1, 0); dc.Parent = dot
        dots[i] = dot
    end

    -- Key input
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(1, -40, 0, 80)
    KeyFrame.Position = UDim2.new(0, 20, 0, 165)
    KeyFrame.BackgroundColor3 = Theme.White
    KeyFrame.BackgroundTransparency = 1
    KeyFrame.Visible = false
    KeyFrame.Parent = Container

    local KeyPrompt = Instance.new("TextLabel")
    KeyPrompt.Size = UDim2.new(1, 0, 0, 18)
    KeyPrompt.Position = UDim2.new(0, 0, 0, 0)
    KeyPrompt.BackgroundTransparency = 1
    KeyPrompt.Text = "Enter Access Key"
    KeyPrompt.TextColor3 = Theme.TextSecondary
    KeyPrompt.Font = Enum.Font.GothamMedium
    KeyPrompt.TextSize = 12
    KeyPrompt.TextXAlignment = Enum.TextXAlignment.Center
    KeyPrompt.TextTransparency = 1
    KeyPrompt.Parent = KeyFrame

    local InputBg = Instance.new("Frame")
    InputBg.Size = UDim2.new(1, 0, 0, 32)
    InputBg.Position = UDim2.new(0, 0, 0, 18)
    InputBg.BackgroundColor3 = Theme.WarmWhite
    InputBg.BorderSizePixel = 0
    InputBg.BackgroundTransparency = 1
    InputBg.Parent = KeyFrame
    local ibc = Instance.new("UICorner"); ibc.CornerRadius = UDim.new(0, 8); ibc.Parent = InputBg

    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Theme.Border
    inputStroke.Thickness = 1.5
    inputStroke.Transparency = 1
    inputStroke.Parent = InputBg

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -16, 1, 0)
    KeyInput.Position = UDim2.fromOffset(8, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.PlaceholderText = "Enter key..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Theme.TextPrimary
    KeyInput.PlaceholderColor3 = Theme.TextMuted
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 13
    KeyInput.TextXAlignment = Enum.TextXAlignment.Center
    KeyInput.ClearTextOnFocus = false
    KeyInput.TextTransparency = 1
    KeyInput.Parent = InputBg

    local ValidateBtn = Instance.new("TextButton")
    ValidateBtn.Size = UDim2.new(1, 0, 0, 30)
    ValidateBtn.Position = UDim2.new(0, 0, 0, 56)
    ValidateBtn.BackgroundColor3 = Theme.Primary
    ValidateBtn.Text = "VALIDATE"
    ValidateBtn.TextColor3 = Theme.White
    ValidateBtn.Font = Enum.Font.GothamSemibold
    ValidateBtn.TextSize = 12
    ValidateBtn.BorderSizePixel = 0
    ValidateBtn.TextTransparency = 1
    ValidateBtn.Parent = KeyFrame
    local vbc = Instance.new("UICorner"); vbc.CornerRadius = UDim.new(0, 8); vbc.Parent = ValidateBtn

    local FeedbackLabel = Instance.new("TextLabel")
    FeedbackLabel.Size = UDim2.new(1, 0, 0, 16)
    FeedbackLabel.Position = UDim2.new(0, 0, 0, -20)
    FeedbackLabel.BackgroundTransparency = 1
    FeedbackLabel.Text = ""
    FeedbackLabel.TextColor3 = Theme.Danger
    FeedbackLabel.Font = Enum.Font.Gotham
    FeedbackLabel.TextSize = 10
    FeedbackLabel.TextXAlignment = Enum.TextXAlignment.Center
    FeedbackLabel.Parent = ValidateBtn

    -- Animación de entrada
    task.spawn(function()
        task.wait(0.05)
        Container.Visible = true
        Container.Size = UDim2.fromOffset(0, 0)
        smooth(Container, 0.4, { Size = UDim2.fromOffset(380, 280) }):Play()

        task.wait(0.15)
        smooth(MainTitle, 0.5, { TextTransparency = 0 }):Play()
        task.wait(0.1)
        smooth(SubTitle, 0.5, { TextTransparency = 0 }):Play()

        local loadTween = smooth(ProgressBar, 2.0, { Size = UDim2.new(1, 0, 1, 0) })
        loadTween:Play()
        task.wait(0.3)
        smooth(ProgressText, 0.3, { TextTransparency = 0 }):Play()

        task.wait(2.0)
        loadTween:Cancel()
        ProgressBar.Size = UDim2.new(1, 0, 1, 0)

        smooth(ProgressBg, 0.5, { BackgroundTransparency = 0.9, Position = UDim2.new(0, 40, 0, 70) }):Play()
        smooth(ProgressBar, 0.3, { BackgroundTransparency = 1 }):Play()
        smooth(ProgressText, 0.3, { TextTransparency = 1 }):Play()
        smooth(topAccent, 0.3, { BackgroundTransparency = 1 }):Play()
        smooth(MainTitle, 0.3, { TextTransparency = 0.4 }):Play()
        smooth(SubTitle, 0.3, { TextTransparency = 0.4 }):Play()

        task.wait(0.15)
        for i, dot in ipairs(dots) do
            task.wait(0.1)
            smooth(dot, 0.25, { BackgroundTransparency = 0, Size = UDim2.fromOffset(9, 9) }):Play()
        end

        task.wait(0.2)
        KeyFrame.Visible = true
        smooth(KeyFrame, 0.5, { BackgroundTransparency = 0 }):Play()

        task.wait(0.1)
        smooth(KeyPrompt, 0.3, { TextTransparency = 0 }):Play()

        task.wait(0.05)
        smooth(InputBg, 0.3, { BackgroundTransparency = 0 }):Play()

        task.wait(0.05)
        smooth(inputStroke, 0.3, { Transparency = 0 }):Play()
        smooth(KeyInput, 0.3, { TextTransparency = 0 }):Play()

        task.wait(0.08)
        elastic(ValidateBtn, 0.4, { TextTransparency = 0 }):Play()

        -- Hover
        ValidateBtn.MouseEnter:Connect(function()
            elastic(ValidateBtn, 0.2, { BackgroundColor3 = Theme.PrimaryDark, Size = UDim2.new(1, 6, 0, 34) }):Play()
        end)
        ValidateBtn.MouseLeave:Connect(function()
            smooth(ValidateBtn, 0.15, { BackgroundColor3 = Theme.Primary, Size = UDim2.new(1, 0, 0, 30) }):Play()
        end)
    end)

    return {
        Gui = ScreenGui,
        KeyInput = KeyInput,
        SubmitBtn = ValidateBtn,
        Feedback = FeedbackLabel,
        Container = Container,
        KeyFrame = KeyFrame,
        ProgressText = ProgressText,
        ProgressBar = ProgressBar
    }
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN WINDOW BUILDER
-- ═══════════════════════════════════════════════════════════════
local function BuildMainWindow()
    local isMobile = UserInputService.TouchEnabled
    local winW = isMobile and 500 or 620
    local winH = isMobile and 400 or 520

    local Parent = getGuiParent()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XynorHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = Parent

    -- Glass overlay
    local GlassOverlay = Instance.new("Frame")
    GlassOverlay.Size = UDim2.new(1, 0, 1, 0)
    GlassOverlay.BackgroundColor3 = Theme.White
    GlassOverlay.BackgroundTransparency = 0.85
    GlassOverlay.BorderSizePixel = 0
    GlassOverlay.Parent = ScreenGui

    local glassC = Instance.new("UICorner")
    glassC.CornerRadius = UDim.new(0, 20)
    glassC.Parent = GlassOverlay

    -- Main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Theme.White
    MainFrame.BorderSizePixel = 0
    MainFrame.BackgroundTransparency = 1
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local mfC = Instance.new("UICorner")
    mfC.CornerRadius = UDim.new(0, 20)
    mfC.Parent = MainFrame

    -- Glass panel
    local GlassPanel = Instance.new("Frame")
    GlassPanel.Size = UDim2.new(1, 0, 1, 0)
    GlassPanel.BackgroundColor3 = Theme.Panel
    GlassPanel.BackgroundTransparency = 0.92
    GlassPanel.BorderSizePixel = 0
    GlassPanel.Parent = MainFrame

    local gpC = Instance.new("UICorner")
    gpC.CornerRadius = UDim.new(0, 20)
    gpC.Parent = GlassPanel

    -- Outer glow
    local outerGlow = Instance.new("Frame")
    outerGlow.Size = UDim2.new(1, 12, 1, 12)
    outerGlow.Position = UDim2.new(0, -6, 0, -6)
    outerGlow.BackgroundColor3 = Theme.Primary
    outerGlow.BackgroundTransparency = 0.94
    outerGlow.BorderSizePixel = 0
    outerGlow.ZIndex = MainFrame.ZIndex - 2
    outerGlow.Parent = MainFrame

    local ogC = Instance.new("UICorner")
    ogC.CornerRadius = UDim.new(0, 26)
    ogC.Parent = outerGlow

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, isMobile and 46 or 52)
    Topbar.Position = UDim2.new(0, 0, 0, 0)
    Topbar.BackgroundColor3 = Theme.Panel
    Topbar.BorderSizePixel = 0
    Topbar.BackgroundTransparency = 0.85
    Topbar.Parent = MainFrame

    local tbC = Instance.new("UICorner")
    tbC.CornerRadius = UDim.new(0, 20)
    tbC.Parent = Topbar

    local topAccent = Instance.new("Frame")
    topAccent.Size = UDim2.new(1, -40, 0, 2)
    topAccent.Position = UDim2.new(0, 20, 0, 0)
    topAccent.BackgroundColor3 = Theme.Primary
    topAccent.BorderSizePixel = 0
    topAccent.Parent = Topbar
    local tac = Instance.new("UICorner"); tac.CornerRadius = UDim.new(1, 0); tac.Parent = topAccent

    -- Title
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(0, 200, 0.5, 0)
    TitleLbl.Position = UDim2.fromOffset(16, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = "Xynor Hub"
    TitleLbl.TextColor3 = Theme.TextPrimary
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = isMobile and 14 or 16
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Topbar

    local CreditLbl = Instance.new("TextLabel")
    CreditLbl.Size = UDim2.new(0, 200, 0.5, 0)
    CreditLbl.Position = UDim2.new(0, 16, 0.5, 0)
    CreditLbl.BackgroundTransparency = 1
    CreditLbl.Text = "Premium Edition"
    CreditLbl.TextColor3 = Theme.Primary
    CreditLbl.Font = Enum.Font.Gotham
    CreditLbl.TextSize = isMobile and 10 or 11
    CreditLbl.TextXAlignment = Enum.TextXAlignment.Left
    CreditLbl.Parent = Topbar

    -- Botones
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.fromOffset(22, 22)
    MinBtn.Position = UDim2.new(1, -70, 0.5, -11)
    MinBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Color3.fromRGB(30, 20, 25)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 16
    MinBtn.BorderSizePixel = 0
    MinBtn.Parent = Topbar
    local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(1, 0); mc.Parent = MinBtn
    local ms = Instance.new("UIStroke"); ms.Color = Theme.Border; ms.Thickness = 1; ms.Parent = MinBtn

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.fromOffset(22, 22)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -11)
    CloseBtn.BackgroundColor3 = Theme.Primary
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Theme.White
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 12
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = Topbar
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(1, 0); cc.Parent = CloseBtn
    local cs = Instance.new("UIStroke"); cs.Color = Theme.PrimaryDark; cs.Thickness = 1; cs.Parent = CloseBtn

    -- Content
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -Topbar.AbsoluteSize.Y)
    ContentFrame.Position = UDim2.new(0, 0, 0, Topbar.AbsoluteSize.Y)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    local TabPanel = Instance.new("ScrollingFrame")
    TabPanel.Size = UDim2.new(0, 160, 1, 0)
    TabPanel.BackgroundColor3 = Color3.fromRGB(6, 2, 2)
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

    local Separator = Instance.new("Frame")
    Separator.Size = UDim2.new(0, 1, 1, 0)
    Separator.Position = UDim2.fromOffset(160, 0)
    Separator.BackgroundColor3 = Theme.Border
    Separator.BorderSizePixel = 0
    Separator.BackgroundTransparency = 1
    Separator.Parent = ContentFrame

    local PageHolder = Instance.new("Frame")
    PageHolder.Size = UDim2.new(1, -161, 1, 0)
    PageHolder.Position = UDim2.fromOffset(161, 0)
    PageHolder.BackgroundTransparency = 1
    PageHolder.ClipsDescendants = true
    PageHolder.Parent = ContentFrame

    -- Animación de apertura
    task.spawn(function()
        smooth(MainFrame, 0.35, { Size = UDim2.fromOffset(winW, winH), BackgroundTransparency = 0 }):Play()
        task.wait(0.08)
        smooth(Topbar, 0.2, { BackgroundTransparency = 0 }):Play()
        smooth(topAccent, 0.35, { Size = UDim2.new(1, 0, 0, 2) }):Play()
        task.wait(0.05)
        smooth(TitleLbl, 0.18, { TextTransparency = 0 }):Play()
        task.delay(0.03, function()
            smooth(CreditLbl, 0.18, { TextTransparency = 0 }):Play()
        end)
        task.delay(0.04)
        smooth(MinBtn, 0.15, { BackgroundTransparency = 0 }):Play()
        task.delay(0.02, function()
            smooth(CloseBtn, 0.15, { BackgroundTransparency = 0 }):Play()
        end)
        task.delay(0.05)
        smooth(TabPanel, 0.2, { BackgroundTransparency = 0 }):Play()
        smooth(Separator, 0.2, { BackgroundTransparency = 0 }):Play()
    end)

    -- Drag
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
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                           startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Botón flotante (minimizado)
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Name = "XynorOpenBtn"
    OpenBtn.Size = UDim2.fromOffset(80, 30)
    OpenBtn.Position = UDim2.new(0, 10, 0.5, -15)
    OpenBtn.BackgroundColor3 = Theme.PrimaryDark
    OpenBtn.Text = "Xynor"
    OpenBtn.TextColor3 = Theme.White
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 13
    OpenBtn.BorderSizePixel = 0
    OpenBtn.Visible = false
    OpenBtn.Parent = ScreenGui
    local oc = Instance.new("UICorner"); oc.CornerRadius = UDim.new(0, 8); oc.Parent = OpenBtn
    local os = Instance.new("UIStroke"); os.Color = Theme.Primary; os.Thickness = 2; os.Parent = OpenBtn

    OpenBtn.MouseEnter:Connect(function()
        smooth(OpenBtn, 0.15, { BackgroundColor3 = Theme.Primary }):Play()
    end)
    OpenBtn.MouseLeave:Connect(function()
        smooth(OpenBtn, 0.15, { BackgroundColor3 = Theme.PrimaryDark }):Play()
    end)

    MinBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)

    OpenBtn.MouseButton1Click:Connect(function()
        OpenBtn.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.fromOffset(winW, winH)
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        spring(MainFrame, 0.25, {Size = UDim2.fromOffset(winW, 0), BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Topbar = Topbar,
        ContentFrame = ContentFrame,
        TabPanel = TabPanel,
        PageHolder = PageHolder,
        OpenBtn = OpenBtn
    }
end

-- ═══════════════════════════════════════════════════════════════
-- LAUNCH ICON (ARRÄSTRABLE)
-- ═══════════════════════════════════════════════════════════════
local function CreateLaunchIcon()
    local Parent = getGuiParent()

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XynorLaunchIcon"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Parent

    -- Overlay de fondo
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Theme.White
    overlay.BackgroundTransparency = 0.85
    overlay.BorderSizePixel = 0
    overlay.Parent = ScreenGui

    local ovC = Instance.new("UICorner")
    ovC.CornerRadius = UDim.new(0, 20)
    ovC.Parent = overlay

    -- Contenedor del icono (arrastrable)
    local IconContainer = Instance.new("Frame")
    IconContainer.Size = UDim2.fromOffset(120, 120)
    -- Posición inicial centrada
    local parentSize = Parent.AbsoluteSize
    IconContainer.Position = UDim2.new(0, (parentSize.X - 120)//2, 0, (parentSize.Y - 120)//2)
    IconContainer.AnchorPoint = Vector2.new(0, 0)
    IconContainer.BackgroundTransparency = 1
    IconContainer.Parent = ScreenGui

    -- Botón icono
    local IconBtn = Instance.new("ImageButton")
    IconBtn.Size = UDim2.fromOffset(90, 90)
    IconBtn.Position = UDim2.new(0, 15, 0, 15)  -- Centrado dentro del contenedor
    IconBtn.AnchorPoint = Vector2.new(0, 0)
    IconBtn.BackgroundColor3 = Theme.White
    IconBtn.Image = "rbxassetid://91032354785729"
    IconBtn.ScaleType = Enum.ScaleType.Fit
    IconBtn.BorderSizePixel = 0
    IconBtn.Parent = IconContainer

    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, 22)
    ic.Parent = IconBtn

    local iStroke = Instance.new("UIStroke")
    iStroke.Color = Theme.Border
    iStroke.Thickness = 2
    iStroke.Transparency = 0.3
    iStroke.Parent = IconBtn

    -- Anillo pulsante
    local pulseRing = Instance.new("Frame")
    pulseRing.Size = UDim2.fromOffset(110, 110)
    pulseRing.Position = UDim2.new(0, 5, 0, 5)  -- Centrado
    pulseRing.AnchorPoint = Vector2.new(0, 0)
    pulseRing.BackgroundColor3 = Theme.Primary
    pulseRing.BackgroundTransparency = 0.9
    pulseRing.BorderSizePixel = 0
    pulseRing.ZIndex = IconBtn.ZIndex - 1
    pulseRing.Parent = IconContainer

    local prc = Instance.new("UICorner")
    prc.CornerRadius = UDim.new(0, 24)
    prc.Parent = pulseRing

    -- Animación de pulso
    task.spawn(function()
        while ScreenGui.Parent do
            smooth(pulseRing, 1.5, { BackgroundTransparency = 0.7, Size = UDim2.fromOffset(115, 115) }):Play()
            task.wait(0.75)
            if ScreenGui.Parent then
                smooth(pulseRing, 1.5, { BackgroundTransparency = 0.95, Size = UDim2.fromOffset(105, 105) }):Play()
                task.wait(0.75)
            end
        end
    end)

    -- Hover effect
    IconBtn.MouseEnter:Connect(function()
        elastic(IconBtn, 0.2, { Size = UDim2.fromOffset(100, 100) }):Play()
    end)
    IconBtn.MouseLeave:Connect(function()
        smooth(IconBtn, 0.2, { Size = UDim2.fromOffset(90, 90) }):Play()
    end)

    -- Lógica de arrastre y click
    local dragData = {
        dragging = false,
        startPos = nil,
        startTime = nil,
        initialPos = nil
    }

    local function openHub()
        spring(IconBtn, 0.15, { Size = UDim2.fromOffset(0, 0) }):Play()
        smooth(pulseRing, 0.2, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }):Play()
        smooth(overlay, 0.3, { BackgroundTransparency = 1 }):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
        runMainHub()
    end

    IconBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragData.dragging = false
            dragData.startPos = input.Position
            dragData.startTime = os.clock()
            dragData.initialPos = Vector2.new(IconContainer.Position.X.Offset, IconContainer.Position.Y.Offset)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragData.startPos and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragData.startPos
            if delta.Magnitude > 5 then
                dragData.dragging = true
            end
            if dragData.dragging then
                local newX = dragData.initialPos.X + delta.X
                local newY = dragData.initialPos.Y + delta.Y
                IconContainer.Position = UDim2.new(0, newX, 0, newY)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragData.startPos then
                if not dragData.dragging then
                    -- Click sin arrastre → abrir UI
                    openHub()
                end
                dragData.dragging = false
                dragData.startPos = nil
                dragData.startTime = nil
                dragData.initialPos = nil
            end
        end
    end)

    -- Animación de entrada
    IconBtn.Size = UDim2.fromOffset(0, 0)
    IconBtn.ImageTransparency = 1
    pulseRing.Size = UDim2.fromOffset(0, 0)

    task.wait(0.1)
    elastic(IconBtn, 0.6, { Size = UDim2.fromOffset(90, 90), ImageTransparency = 0 }):Play()
    smooth(pulseRing, 0.5, { Size = UDim2.fromOffset(110, 110), BackgroundTransparency = 0.9 }):Play()
end

-- ═══════════════════════════════════════════════════════════════
-- RUN MAIN HUB
-- ═══════════════════════════════════════════════════════════════
local function runMainHub()
    local win = BuildMainWindow()
    print("✅ Ventana principal abierta")
end

-- ═══════════════════════════════════════════════════════════════
-- ENTRY POINT
-- ═══════════════════════════════════════════════════════════════

task.spawn(function()
    local loader = CreateLoader()

    -- Animación de entrada del loader
    task.wait(0.05)
    loader.Container.Visible = true
    smooth(loader.Container, 0.4, { Size = UDim2.fromOffset(380, 280) }):Play()

    task.wait(0.15)
    smooth(MainTitle, 0.5, { TextTransparency = 0 }):Play()
    task.wait(0.1)
    smooth(SubTitle, 0.5, { TextTransparency = 0 }):Play()

    local loadTween = smooth(loader.ProgressBar, 2.0, { Size = UDim2.new(1, 0, 1, 0) })
    loadTween:Play()
    task.wait(0.3)
    smooth(loader.ProgressText, 0.3, { TextTransparency = 0 }):Play()

    task.wait(2.0)
    loadTween:Cancel()
    loader.ProgressBar.Size = UDim2.new(1, 0, 1, 0)

    smooth(loader.ProgressBg, 0.5, { BackgroundTransparency = 0.9, Position = UDim2.new(0, 40, 0, 70) }):Play()
    smooth(loader.ProgressBar, 0.3, { BackgroundTransparency = 1 }):Play()
    smooth(loader.ProgressText, 0.3, { TextTransparency = 1 }):Play()
    smooth(topAccent, 0.3, { BackgroundTransparency = 1 }):Play()
    smooth(MainTitle, 0.3, { TextTransparency = 0.4 }):Play()
    smooth(SubTitle, 0.3, { TextTransparency = 0.4 }):Play()

    task.wait(0.15)
    for i, dot in ipairs(dots) do
        task.wait(0.1)
        smooth(dot, 0.25, { BackgroundTransparency = 0, Size = UDim2.fromOffset(9, 9) }):Play()
    end

    task.wait(0.2)
    loader.KeyFrame.Visible = true
    smooth(loader.KeyFrame, 0.5, { BackgroundTransparency = 0 }):Play()

    task.wait(0.1)
    smooth(loader.KeyPrompt, 0.3, { TextTransparency = 0 }):Play()

    task.wait(0.05)
    smooth(loader.InputBg, 0.3, { BackgroundTransparency = 0 }):Play()

    task.wait(0.05)
    smooth(inputStroke, 0.3, { Transparency = 0 }):Play()
    smooth(loader.KeyInput, 0.3, { TextTransparency = 0 }):Play()

    task.wait(0.08)
    elastic(loader.SubmitBtn, 0.4, { TextTransparency = 0 }):Play()

    -- Hover del botón
    loader.SubmitBtn.MouseEnter:Connect(function()
        elastic(loader.SubmitBtn, 0.2, { BackgroundColor3 = Theme.PrimaryDark, Size = UDim2.new(1, 6, 0, 34) }):Play()
    end)
    loader.SubmitBtn.MouseLeave:Connect(function()
        smooth(loader.SubmitBtn, 0.15, { BackgroundColor3 = Theme.Primary, Size = UDim2.new(1, 0, 0, 30) }):Play()
    end)

    -- Auto-validar key guardada
    task.wait(4.5)
    if loader.Gui and loader.Gui.Parent then
        local savedKey = KeySystem:GetSaved()
        if savedKey and KeySystem:Check(savedKey) then
            loader.Feedback.Text = "✓ Key verified"
            loader.Feedback.TextColor3 = Theme.Success
            task.wait(0.5)

            smooth(loader.Container, 0.4, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }):Play()
            smooth(loader.KeyFrame, 0.3, { BackgroundTransparency = 1 }):Play()
            task.wait(0.3)
            loader.Gui:Destroy()
            task.wait(0.3)
            CreateLaunchIcon()
        end
    end

    -- Validación manual
    loader.SubmitBtn.MouseButton1Click:Connect(function()
        local key = loader.KeyInput.Text
        if KeySystem:Check(key) then
            KeySystem:Save(key)
            loader.Feedback.Text = "✓ Access granted"
            loader.Feedback.TextColor3 = Theme.Success
            task.wait(0.5)

            smooth(loader.Container, 0.4, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }):Play()
            smooth(loader.KeyFrame, 0.3, { BackgroundTransparency = 1 }):Play()
            task.wait(0.3)
            loader.Gui:Destroy()
            task.wait(0.3)
            CreateLaunchIcon()
        else
            loader.Feedback.Text = "✗ Invalid key"
            loader.Feedback.TextColor3 = Theme.Danger
            spring(loader.SubmitBtn, 0.15, { Position = UDim2.new(0, 6, 0.5, -17) }):Play()
            task.wait(0.08)
            spring(loader.SubmitBtn, 0.2, { Position = UDim2.new(0, 0, 0.5, -17) }):Play()
        end
    end)

    -- Enter para validar
    loader.KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            loader.SubmitBtn.MouseButton1Click:Fire()
        end
    end)
end)

print("✨ Xynor Hub v3.0 initialized")
