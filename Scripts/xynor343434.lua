--[[
    ═══════════════════════════════════════════════════════════════
                    XYNOR HUB 3.0 - COMPLETE REDESIGN
                    Premium UI/UX · Modern · Professional
                    Loader → Draggable Icon → Main UI
    ═══════════════════════════════════════════════════════════════
--]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════
-- EASING FUNCTIONS
-- ═══════════════════════════════════════════════════════════════
local function tweenSmooth(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
end

local function tweenBounce(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), props)
end

local function tweenSpring(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props)
end

-- ═══════════════════════════════════════════════════════════════
-- BLUR EFFECT
-- ═══════════════════════════════════════════════════════════════
local BlurMod = Instance.new("BlurEffect")
BlurMod.Size = 0
BlurMod.Parent = Lighting

local function setBlur(intensity, duration)
    duration = duration or 0.3
    tweenSmooth(BlurMod, duration, { Size = intensity }):Play()
end

-- ═══════════════════════════════════════════════════════════════
-- THEME (Premium Pastel)
-- ═══════════════════════════════════════════════════════════════
local Theme = {
    Primary = Color3.fromRGB(147, 112, 219),
    PrimaryDark = Color3.fromRGB(125, 80, 190),
    PrimaryLight = Color3.fromRGB(171, 145, 235),
    Accent = Color3.fromRGB(255, 143, 133),
    AccentDark = Color3.fromRGB(255, 112, 100),
    White = Color3.fromRGB(255, 255, 255),
    Cream = Color3.fromRGB(255, 252, 245),
    WarmWhite = Color3.fromRGB(248, 246, 243),
    LightGray = Color3.fromRGB(240, 238, 235),
    TextPrimary = Color3.fromRGB(55, 45, 65),
    TextSecondary = Color3.fromRGB(95, 85, 115),
    TextMuted = Color3.fromRGB(140, 130, 150),
    Border = Color3.fromRGB(220, 215, 205),
    BorderHover = Color3.fromRGB(200, 195, 185),
    Panel = Color3.fromRGB(255, 253, 250),
    PanelHover = Color3.fromRGB(252, 248, 244),
    Success = Color3.fromRGB(129, 199, 132),
    Danger = Color3.fromRGB(239, 154, 154),
    Warning = Color3.fromRGB(255, 211, 105),
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
-- LOADER (COMPLEX PREMIUM VERSION)
-- ═══════════════════════════════════════════════════════════════
local function CreateLoader()
    local Parent = getGuiParent()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XynorLoader_v3"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Parent

    setBlur(8, 0)

    -- Partículas flotantes de colores
    local particleColors = {
        Theme.Primary, Theme.Accent,
        Color3.fromRGB(129, 199, 132),
        Color3.fromRGB(255, 211, 105),
        Color3.fromRGB(171, 145, 235),
        Color3.fromRGB(255, 183, 178),
        Color3.fromRGB(159, 168, 218),
        Color3.fromRGB(144, 202, 249),
    }

    local function createParticle()
        local shapes = {"Circle", "Triangle", "Star"}
        local shapeType = shapes[math.random(#shapes)]
        local size = math.random(15, 45)
        local startX = math.random(-300, 300)
        local startY = math.random(-200, 200)

        local particle
        if shapeType == "Circle" then
            particle = Instance.new("Frame")
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0.5, 0)
            corner.Parent = particle
        elseif shapeType == "Triangle" then
            particle = Instance.new("Frame")
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 3)
            corner.Parent = particle
        else
            particle = Instance.new("Frame")
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = particle
        end

        particle.Size = UDim2.fromOffset(size, size)
        particle.Position = UDim2.new(0.5, startX, 0.5, startY)
        particle.BackgroundColor3 = particleColors[math.random(#particleColors)]
        particle.BackgroundTransparency = 1
        particle.BorderSizePixel = 0
        particle.AnchorPoint = Vector2.new(0.5, 0.5)
        particle.Parent = ScreenGui

        local rotationSpeed = math.random(100, 300)
        local floatSpeed = math.random(2, 4)
        local startTime = os.clock()
        local duration = math.random(2, 4)

        tweenSmooth(particle, 0.5, { BackgroundTransparency = 0.6 }):Play()

        local conn = RunService.RenderStepped:Connect(function()
            if not particle.Parent then
                conn:Disconnect()
                return
            end
            local elapsed = os.clock() - startTime
            if elapsed > duration then
                tweenSmooth(particle, 0.4, { BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 0) }):Play()
                task.wait(0.5)
                particle:Destroy()
                conn:Disconnect()
                return
            end
            local yOffset = math.sin(elapsed * floatSpeed) * 80
            local newY = startY + yOffset - (elapsed * 30)
            particle.Position = UDim2.new(0.5, startX + math.sin(elapsed * 2) * 30, 0.5, newY)
            particle.Rotation = elapsed * rotationSpeed
        end)
    end

    -- Generador de partículas
    task.spawn(function()
        local frameCount = 0
        while RunService.RenderStepped:Wait() do
            frameCount = frameCount + 1
            if frameCount % 6 == 0 then
                task.spawn(createParticle)
            end
        end
    end)

    -- Container principal
    local Container = Instance.new("Frame")
    Container.Size = UDim2.fromOffset(420, 320)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.BackgroundColor3 = Theme.White
    Container.BorderSizePixel = 0
    Container.ClipsDescendants = true
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Visible = false
    Container.Parent = ScreenGui

    local cScale = Instance.new("UIScale")
    cScale.Scale = 0.85
    cScale.Parent = Container

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 24)
    cCorner.Parent = Container

    -- Sombras multilayer
    local shadow1 = Instance.new("Frame")
    shadow1.Size = UDim2.new(1, 6, 1, 6)
    shadow1.Position = UDim2.new(0, -3, 0, -3)
    shadow1.BackgroundColor3 = Color3.fromRGB(180, 175, 170)
    shadow1.BackgroundTransparency = 0.88
    shadow1.BorderSizePixel = 0
    shadow1.ZIndex = Container.ZIndex - 2
    shadow1.Parent = Container

    local s1C = Instance.new("UICorner")
    s1C.CornerRadius = UDim.new(0, 28)
    s1C.Parent = shadow1

    local shadow2 = Instance.new("Frame")
    shadow2.Size = UDim2.new(1, 12, 1, 12)
    shadow2.Position = UDim2.new(0, -6, 0, -6)
    shadow2.BackgroundColor3 = Color3.fromRGB(160, 155, 150)
    shadow2.BackgroundTransparency = 0.92
    shadow2.BorderSizePixel = 0
    shadow2.ZIndex = Container.ZIndex - 3
    shadow2.Parent = Container

    local s2C = Instance.new("UICorner")
    s2C.CornerRadius = UDim.new(0, 30)
    s2C.Parent = shadow2

    -- Top accent con glow
    local topAccent = Instance.new("Frame")
    topAccent.Size = UDim2.new(1, 0, 0, 5)
    topAccent.Position = UDim2.new(0, 0, 0, 0)
    topAccent.BackgroundColor3 = Theme.Primary
    topAccent.BorderSizePixel = 0
    topAccent.Parent = Container

    local taC = Instance.new("UICorner")
    taC.CornerRadius = UDim.new(0, 4)
    taC.Parent = topAccent

    local glowLine = Instance.new("Frame")
    glowLine.Size = UDim2.new(1, -40, 0, 2)
    glowLine.Position = UDim2.new(0, 20, 0, 8)
    glowLine.BackgroundColor3 = Theme.Primary
    glowLine.BorderSizePixel = 0
    glowLine.BackgroundTransparency = 0.5
    glowLine.Parent = Container

    local glC = Instance.new("UICorner")
    glC.CornerRadius = UDim.new(1, 0)
    glC.Parent = glowLine

    -- Logo section
    local LogoSection = Instance.new("Frame")
    LogoSection.Size = UDim2.new(1, 0, 0, 100)
    LogoSection.Position = UDim2.new(0, 0, 0, 35)
    LogoSection.BackgroundTransparency = 1
    LogoSection.Parent = Container

    -- Decoraciones
    for i = 1, 3 do
        local decor = Instance.new("Frame")
        decor.Size = UDim2.fromOffset(4 + i*2, 4 + i*2)
        decor.Position = UDim2.new(0, 30 - i*8, 0, 90 - i*6)
        decor.BackgroundColor3 = Theme.Primary
        decor.BackgroundTransparency = 0.7 - i*0.15
        decor.BorderSizePixel = 0
        decor.Parent = LogoSection

        local dc = Instance.new("UICorner")
        dc.CornerRadius = UDim.new(1, 0)
        dc.Parent = decor
    end

    local MainTitle = Instance.new("TextLabel")
    MainTitle.Size = UDim2.new(1, -60, 0.5, 0)
    MainTitle.Position = UDim2.new(0, 30, 0, 8)
    MainTitle.BackgroundTransparency = 1
    MainTitle.Text = "XYNOR"
    MainTitle.TextColor3 = Theme.TextPrimary
    MainTitle.Font = Enum.Font.GothamBlack
    MainTitle.TextSize = 38
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    MainTitle.TextTransparency = 1
    MainTitle.Parent = LogoSection

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, -60, 0, 20)
    SubTitle.Position = UDim2.new(0, 30, 0.5, -5)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Premium Hub v3"
    SubTitle.TextColor3 = Theme.Accent
    SubTitle.Font = Enum.Font.GothamMedium
    SubTitle.TextSize = 14
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.TextTransparency = 1
    SubTitle.Parent = LogoSection

    -- Progress Bar
    local ProgressBg = Instance.new("Frame")
    ProgressBg.Size = UDim2.new(1, -80, 0, 6)
    ProgressBg.Position = UDim2.new(0, 40, 0, 110)
    ProgressBg.BackgroundColor3 = Theme.LightGray
    ProgressBg.BorderSizePixel = 0
    ProgressBg.Parent = Container

    local pbC = Instance.new("UICorner")
    pbC.CornerRadius = UDim.new(1, 0)
    pbC.Parent = ProgressBg

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = Theme.Primary
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = ProgressBg

    local pbFillCorner = Instance.new("UICorner")
    pbFillCorner.CornerRadius = UDim.new(1, 0)
    pbFillCorner.Parent = ProgressBar

    local ProgressText = Instance.new("TextLabel")
    ProgressText.Size = UDim2.new(1, 0, 0, 20)
    ProgressText.Position = UDim2.new(0, 0, 0, 125)
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
    DotsFrame.Size = UDim2.new(0, 60, 0, 20)
    DotsFrame.Position = UDim2.new(0.5, -30, 0, 150)
    DotsFrame.BackgroundTransparency = 1
    DotsFrame.Parent = Container

    local dots = {}
    for i = 1, 3 do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.fromOffset(8, 8)
        dot.Position = UDim2.new(0, (i - 1) * 24, 0.5, -4)
        dot.BackgroundColor3 = Theme.TextMuted
        dot.BorderSizePixel = 0
        dot.Parent = DotsFrame

        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot

        dots[i] = dot
    end

    -- Key Input Frame
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(1, -40, 0, 90)
    KeyFrame.Position = UDim2.new(0, 20, 0, 175)
    KeyFrame.BackgroundColor3 = Theme.White
    KeyFrame.BackgroundTransparency = 1
    KeyFrame.Visible = false
    KeyFrame.Parent = Container

    local KeyPrompt = Instance.new("TextLabel")
    KeyPrompt.Size = UDim2.new(1, 0, 0, 20)
    KeyPrompt.Position = UDim2.new(0, 0, 0, 0)
    KeyPrompt.BackgroundTransparency = 1
    KeyPrompt.Text = "Enter Access Key"
    KeyPrompt.TextColor3 = Theme.TextSecondary
    KeyPrompt.Font = Enum.Font.GothamMedium
    KeyPrompt.TextSize = 12
    KeyPrompt.TextXAlignment = Enum.TextXAlignment.Center
    KeyPrompt.Parent = KeyFrame

    local InputBg = Instance.new("Frame")
    InputBg.Size = UDim2.new(1, 0, 0, 36)
    InputBg.Position = UDim2.new(0, 0, 0, 22)
    InputBg.BackgroundColor3 = Theme.WarmWhite
    InputBg.BorderSizePixel = 0
    InputBg.Parent = KeyFrame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = InputBg

    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Theme.Border
    inputStroke.Thickness = 1.5
    inputStroke.Parent = InputBg

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -20, 1, 0)
    KeyInput.Position = UDim2.fromOffset(10, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.PlaceholderText = "Enter key..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Theme.TextPrimary
    KeyInput.PlaceholderColor3 = Theme.TextMuted
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 14
    KeyInput.TextXAlignment = Enum.TextXAlignment.Center
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = InputBg

    local ValidateBtn = Instance.new("TextButton")
    ValidateBtn.Size = UDim2.new(1, 0, 0, 34)
    ValidateBtn.Position = UDim2.new(0, 0, 0, 65)
    ValidateBtn.BackgroundColor3 = Theme.Primary
    ValidateBtn.Text = "VALIDATE"
    ValidateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValidateBtn.Font = Enum.Font.GothamSemibold
    ValidateBtn.TextSize = 13
    ValidateBtn.BorderSizePixel = 0
    ValidateBtn.Parent = KeyFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = ValidateBtn

    local FeedbackLabel = Instance.new("TextLabel")
    FeedbackLabel.Size = UDim2.new(1, 0, 0, 18)
    FeedbackLabel.Position = UDim2.new(0, 0, 0, -22)
    FeedbackLabel.BackgroundTransparency = 1
    FeedbackLabel.Text = ""
    FeedbackLabel.TextColor3 = Theme.Danger
    FeedbackLabel.Font = Enum.Font.Gotham
    FeedbackLabel.TextSize = 11
    FeedbackLabel.TextXAlignment = Enum.TextXAlignment.Center
    FeedbackLabel.Parent = ValidateBtn

    -- Animación de entrada completa
    task.spawn(function()
        task.wait(0.1)
        Container.Visible = true
        Container.Size = UDim2.fromOffset(0, 0)
        tweenSpring(Container, 0.6, { Scale = 1, Size = UDim2.fromOffset(420, 320) }):Play()

        task.wait(0.2)
        tweenSpring(MainTitle, 0.7, { TextTransparency = 0, TextSize = 40 }):Play()
        task.wait(0.15)
        tweenSpring(SubTitle, 0.6, { TextTransparency = 0 }):Play()

        local loadTween = tweenSmooth(ProgressBar, 2.2, { Size = UDim2.new(1, 0, 1, 0) })
        loadTween:Play()
        task.wait(0.3)
        tweenSmooth(ProgressText, 0.4, { TextTransparency = 0 }):Play()

        task.wait(2.0)
        loadTween:Cancel()
        ProgressBar.Size = UDim2.new(1, 0, 1, 0)

        -- Ocultar progreso con animación
        tweenSmooth(ProgressBg, 0.5, { BackgroundTransparency = 0.9, Position = UDim2.new(0, 40, 0, 70) }):Play()
        tweenSmooth(ProgressBar, 0.3, { BackgroundTransparency = 1 }):Play()
        tweenSmooth(ProgressText, 0.3, { TextTransparency = 1 }):Play()
        tweenSmooth(topAccent, 0.3, { BackgroundTransparency = 1 }):Play()
        tweenSmooth(MainTitle, 0.3, { TextTransparency = 0.4 }):Play()
        tweenSmooth(SubTitle, 0.3, { TextTransparency = 0.4 }):Play()

        task.wait(0.2)

        -- Animar dots
        for i, dot in ipairs(dots) do
            task.wait(0.1)
            tweenSpring(dot, 0.3, { BackgroundTransparency = 0.3, Size = UDim2.fromOffset(10, 10) }):Play()
            task.wait(0.1)
            tweenSpring(dot, 0.2, { BackgroundTransparency = 0, Size = UDim2.fromOffset(8, 8) }):Play()
        end

        task.wait(0.2)
        KeyFrame.Visible = true
        tweenSmooth(KeyFrame, 0.5, { BackgroundTransparency = 0 }):Play()

        task.wait(0.1)
        tweenSmooth(KeyPrompt, 0.4, { TextTransparency = 0 }):Play()

        task.wait(0.05)
        tweenSmooth(InputBg, 0.4, { BackgroundTransparency = 0 }):Play()

        task.wait(0.05)
        tweenSmooth(inputStroke, 0.4, { Transparency = 0 }):Play()
        tweenSmooth(KeyInput, 0.4, { TextTransparency = 0 }):Play()

        task.wait(0.08)
        tweenSpring(ValidateBtn, 0.5, { TextTransparency = 0 }):Play()

        -- Hover
        ValidateBtn.MouseEnter:Connect(function()
            tweenSmooth(ValidateBtn, 0.2, { BackgroundColor3 = Theme.PrimaryDark, Size = UDim2.new(1, 4, 0, 36) }):Play()
        end)
        ValidateBtn.MouseLeave:Connect(function()
            tweenSmooth(ValidateBtn, 0.15, { BackgroundColor3 = Theme.Primary, Size = UDim2.new(1, 0, 0, 34) }):Play()
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
    ScreenGui.Name = "XynorHub_v3"
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

    local glassStroke = Instance.new("UIStroke")
    glassStroke.Color = Theme.Border
    glassStroke.Thickness = 1
    glassStroke.Transparency = 0.5
    glassStroke.Parent = GlassOverlay

    -- Main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(180, 180)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Theme.White
    MainFrame.BorderSizePixel = 0
    MainFrame.BackgroundTransparency = 1
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    MainFrame.ZIndex = 2

    local mfC = Instance.new("UICorner")
    mfC.CornerRadius = UDim.new(0, 20)
    mfC.Parent = MainFrame

    -- Glass panel
    local GlassPanel = Instance.new("Frame")
    GlassPanel.Size = UDim2.new(1, 0, 1, 0)
    GlassPanel.Position = UDim2.new(0, 0, 0, 0)
    GlassPanel.BackgroundColor3 = Theme.Panel
    GlassPanel.BackgroundTransparency = 0.92
    GlassPanel.BorderSizePixel = 0
    GlassPanel.Parent = MainFrame
    GlassPanel.ZIndex = 0

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
    Topbar.ZIndex = 3

    local tbC = Instance.new("UICorner")
    tbC.CornerRadius = UDim.new(0, 20)
    tbC.Parent = Topbar

    local tbBorder = Instance.new("Frame")
    tbBorder.Size = UDim2.new(1, 0, 0, 1)
    tbBorder.Position = UDim2.new(0, 0, 1, -1)
    tbBorder.BackgroundColor3 = Theme.Border
    tbBorder.BackgroundTransparency = 0.5
    tbBorder.BorderSizePixel = 0
    tbBorder.Parent = Topbar

    local tbFix = Instance.new("Frame")
    tbFix.Size = UDim2.new(1, 0, 0, 10)
    tbFix.Position = UDim2.new(0, 0, 1, -10)
    tbFix.BackgroundColor3 = Theme.Panel
    tbFix.BorderSizePixel = 0
    tbFix.Parent = Topbar

    local topAccent = Instance.new("Frame")
    topAccent.Size = UDim2.new(1, -40, 0, 2)
    topAccent.Position = UDim2.new(0, 20, 0, 0)
    topAccent.BackgroundColor3 = Theme.Primary
    topAccent.BorderSizePixel = 0
    topAccent.Parent = Topbar

    local taC = Instance.new("UICorner")
    taC.CornerRadius = UDim.new(1, 0)
    taC.Parent = topAccent

    local accentGlow = Instance.new("Frame")
    accentGlow.Size = UDim2.new(1, -40, 0, 4)
    accentGlow.Position = UDim2.new(0, 20, 0, 2)
    accentGlow.BackgroundColor3 = Theme.Primary
    accentGlow.BorderSizePixel = 0
    accentGlow.BackgroundTransparency = 0.6
    accentGlow.Parent = Topbar

    local agC = Instance.new("UICorner")
    agC.CornerRadius = UDim.new(1, 0)
    agC.Parent = accentGlow

    -- Title
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(0, 200, 0.5, 0)
    TitleLbl.Position = UDim2.fromOffset(14, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = "Xynor Hub"
    TitleLbl.TextColor3 = Theme.TextPrimary
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = isMobile and 14 or 16
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Topbar

    local CreditLbl = Instance.new("TextLabel")
    CreditLbl.Size = UDim2.new(0, 200, 0.5, 0)
    CreditLbl.Position = UDim2.new(0, 14, 0.5, 0)
    CreditLbl.BackgroundTransparency = 1
    CreditLbl.Text = "Premium Edition"
    CreditLbl.TextColor3 = Theme.Accent
    CreditLbl.Font = Enum.Font.Gotham
    CreditLbl.TextSize = isMobile and 11 or 12
    CreditLbl.TextXAlignment = Enum.TextXAlignment.Left
    CreditLbl.Parent = Topbar

    -- Controls
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

    local minC = Instance.new("UICorner")
    minC.CornerRadius = UDim.new(1, 0)
    minC.Parent = MinBtn

    local minStroke = Instance.new("UIStroke")
    minStroke.Color = Theme.Border
    minStroke.Thickness = 1
    minStroke.Parent = MinBtn

    MinBtn.MouseEnter:Connect(function()
        tweenSmooth(MinBtn, 0.1, { BackgroundColor3 = Color3.fromRGB(255, 170, 80) }):Play()
    end)
    MinBtn.MouseLeave:Connect(function()
        tweenSmooth(MinBtn, 0.1, { BackgroundColor3 = Color3.fromRGB(255, 200, 100) }):Play()
    end)

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

    local clsC = Instance.new("UICorner")
    clsC.CornerRadius = UDim.new(1, 0)
    clsC.Parent = CloseBtn

    local clsStroke = Instance.new("UIStroke")
    clsStroke.Color = Theme.PrimaryDark
    clsStroke.Thickness = 1
    clsStroke.Parent = CloseBtn

    CloseBtn.MouseEnter:Connect(function()
        tweenSmooth(CloseBtn, 0.1, { BackgroundColor3 = Theme.PrimaryDark }):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        tweenSmooth(CloseBtn, 0.1, { BackgroundColor3 = Theme.Primary }):Play()
    end)

    -- Content
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -Topbar.AbsoluteSize.Y)
    ContentFrame.Position = UDim2.new(0, 0, 0, Topbar.AbsoluteSize.Y)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- Tabs (simplificado)
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
        tweenSpring(MainFrame, 0.35, { Size = UDim2.fromOffset(winW, winH), BackgroundTransparency = 0 }):Play()
        task.wait(0.08)
        tweenExpo(Topbar, 0.2, { BackgroundTransparency = 0 }):Play()
        task.delay(0.02, function()
            tweenExpo(tbFix, 0.2, { BackgroundTransparency = 0 }):Play()
        end)
        tweenCirc(topAccent, 0.35, { Size = UDim2.new(1, 0, 0, 2) }):Play()
        task.wait(0.05)
        tweenSine(TitleLbl, 0.18, { TextTransparency = 0 }):Play()
        task.delay(0.03, function()
            tweenSine(CreditLbl, 0.18, { TextTransparency = 0 }):Play()
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

    local oc = Instance.new("UICorner")
    oc.CornerRadius = UDim.new(0, 8)
    oc.Parent = OpenBtn

    local os = Instance.new("UIStroke")
    os.Color = Theme.Primary
    os.Thickness = 2
    os.Parent = OpenBtn

    OpenBtn.MouseEnter:Connect(function()
        tweenSmooth(OpenBtn, 0.15, { BackgroundColor3 = Theme.Primary }):Play()
    end)
    OpenBtn.MouseLeave:Connect(function()
        tweenSmooth(OpenBtn, 0.15, { BackgroundColor3 = Theme.PrimaryDark }):Play()
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
        tweenSpring(MainFrame, 0.25, { Size = UDim2.fromOffset(winW, 0), BackgroundTransparency = 1 }):Play()
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
-- LAUNCH ICON (ARRÄSTRABLE) - Con asset ID 91032354785729
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
    -- Posición inicial: centrada
    IconContainer.Position = UDim2.new(0.5, -60, 0.5, -60)
    IconContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    IconContainer.BackgroundTransparency = 1
    IconContainer.Parent = ScreenGui

    -- Botón icono principal
    local IconBtn = Instance.new("ImageButton")
    IconBtn.Size = UDim2.fromOffset(90, 90)
    IconBtn.Position = UDim2.new(0, 15, 0, 15)  -- Centrado en el contenedor
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

    -- Anillo pulsante exterior
    local pulseRing = Instance.new("Frame")
    pulseRing.Size = UDim2.fromOffset(110, 110)
    pulseRing.Position = UDim2.new(0, 5, 0, 5)
    pulseRing.AnchorPoint = Vector2.new(0, 0)
    pulseRing.BackgroundColor3 = Theme.Primary
    pulseRing.BackgroundTransparency = 0.9
    pulseRing.BorderSizePixel = 0
    pulseRing.ZIndex = IconBtn.ZIndex - 1
    pulseRing.Parent = IconContainer

    local prc = Instance.new("UICorner")
    prC_CornerRadius = UDim.new(0, 24)
    prC.Parent = pulseRing

    -- Animación pulso
    task.spawn(function()
        while ScreenGui.Parent do
            tweenSmooth(pulseRing, 1.5, { BackgroundTransparency = 0.7, Size = UDim2.fromOffset(115, 115) }):Play()
            task.wait(0.75)
            if ScreenGui.Parent then
                tweenSmooth(pulseRing, 1.5, { BackgroundTransparency = 0.95, Size = UDim2.fromOffset(105, 105) }):Play()
                task.wait(0.75)
            end
        end
    end)

    -- Hover
    IconBtn.MouseEnter:Connect(function()
        tweenSpring(IconBtn, 0.2, { Size = UDim2.fromOffset(100, 100) }):Play()
    end)
    IconBtn.MouseLeave:Connect(function()
        tweenSmooth(IconBtn, 0.2, { Size = UDim2.fromOffset(90, 90) }):Play()
    end)

    -- Lógica de drag y click
    local dragData = {
        dragging = false,
        startPos = nil,
        startTime = nil,
        initialPos = nil
    }

    local function openHub()
        tweenSpring(IconBtn, 0.15, { Size = UDim2.fromOffset(0, 0) }):Play()
        tweenSmooth(pulseRing, 0.2, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }):Play()
        tweenSmooth(overlay, 0.3, { BackgroundTransparency = 1 }):Play()
        task.wait(0.3)
        setBlur(0, 0.4)
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
    tweenSpring(IconBtn, 0.6, { Size = UDim2.fromOffset(90, 90), ImageTransparency = 0 }):Play()
    tweenSmooth(pulseRing, 0.5, { Size = UDim2.fromOffset(110, 110), BackgroundTransparency = 0.9 }):Play()
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

    -- Animación de entrada
    task.wait(0.1)
    loader.Container.Visible = true
    tweenSpring(loader.Container, 0.6, { Scale = 1, Size = UDim2.fromOffset(420, 320) }):Play()

    task.wait(0.2)
    tweenSpring(MainTitle, 0.7, { TextTransparency = 0, TextSize = 40 }):Play()
    task.wait(0.15)
    tweenSpring(SubTitle, 0.6, { TextTransparency = 0 }):Play()

    local loadTween = tweenSmooth(loader.ProgressBar, 2.2, { Size = UDim2.new(1, 0, 1, 0) })
    loadTween:Play()
    task.wait(0.3)
    tweenSmooth(loader.ProgressText, 0.4, { TextTransparency = 0 }):Play()

    task.wait(2.0)
    loadTween:Cancel()
    loader.ProgressBar.Size = UDim2.new(1, 0, 1, 0)

    -- Ocultar progreso
    tweenSmooth(loader.ProgressBg, 0.5, { BackgroundTransparency = 0.9, Position = UDim2.new(0, 40, 0, 70) }):Play()
    tweenSmooth(loader.ProgressBar, 0.3, { BackgroundTransparency = 1 }):Play()
    tweenSmooth(loader.ProgressText, 0.3, { TextTransparency = 1 }):Play()
    tweenSmooth(topAccent, 0.3, { BackgroundTransparency = 1 }):Play()
    tweenSmooth(MainTitle, 0.3, { TextTransparency = 0.4 }):Play()
    tweenSmooth(SubTitle, 0.3, { TextTransparency = 0.4 }):Play()

    task.wait(0.2)

    -- Dots
    for i, dot in ipairs(dots) do
        task.wait(0.1)
        tweenSpring(dot, 0.3, { BackgroundTransparency = 0.3, Size = UDim2.fromOffset(10, 10) }):Play()
        task.wait(0.1)
        tweenSpring(dot, 0.2, { BackgroundTransparency = 0, Size = UDim2.fromOffset(8, 8) }):Play()
    end

    task.wait(0.2)
    loader.KeyFrame.Visible = true
    tweenSmooth(loader.KeyFrame, 0.5, { BackgroundTransparency = 0 }):Play()

    task.wait(0.1)
    tweenSmooth(loader.KeyPrompt, 0.4, { TextTransparency = 0 }):Play()

    task.wait(0.05)
    tweenSmooth(loader.InputBg, 0.4, { BackgroundTransparency = 0 }):Play()

    task.wait(0.05)
    tweenSmooth(inputStroke, 0.4, { Transparency = 0 }):Play()
    tweenSmooth(loader.KeyInput, 0.4, { TextTransparency = 0 }):Play()

    task.wait(0.08)
    tweenSpring(loader.SubmitBtn, 0.5, { TextTransparency = 0 }):Play()

    -- Auto-validar key guardada
    task.wait(4.5)
    if loader.Gui and loader.Gui.Parent then
        local savedKey = KeySystem:GetSaved()
        if savedKey and KeySystem:Check(savedKey) then
            loader.Feedback.Text = "✓ Key verified"
            loader.Feedback.TextColor3 = Theme.Success
            task.wait(0.5)

            -- Cerrar loader
            tweenSmooth(loader.Container, 0.4, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }):Play()
            tweenSmooth(loader.KeyFrame, 0.3, { BackgroundTransparency = 1 }):Play()
            task.wait(0.3)
            loader.Gui:Destroy()
            task.wait(0.3)

            -- Mostrar icono arrastrable
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

            tweenSmooth(loader.Container, 0.4, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }):Play()
            tweenSmooth(loader.KeyFrame, 0.3, { BackgroundTransparency = 1 }):Play()
            task.wait(0.3)
            loader.Gui:Destroy()
            task.wait(0.3)

            CreateLaunchIcon()
        else
            loader.Feedback.Text = "✗ Invalid key"
            loader.Feedback.TextColor3 = Theme.Danger
            tweenSpring(loader.SubmitBtn, 0.15, { Position = UDim2.new(0, 6, 0.5, -17) }):Play()
            task.wait(0.08)
            tweenSpring(loader.SubmitBtn, 0.2, { Position = UDim2.new(0, 0, 0.5, -17) }):Play()
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
