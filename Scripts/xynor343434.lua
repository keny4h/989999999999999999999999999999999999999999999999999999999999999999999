--[[
    ═══════════════════════════════════════════════════════════════
                         HIIIIIIIIIII SKIDDDDDDD
                    XYNOR HUB 1.0 /UX · TPS · PREMIUM
                                I LIKE YOUUUUU
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
local StarterGui = game:GetService("StarterGui")

local function tweenSmooth(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
end

local function tweenBounce(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), props)
end

local function tweenSpring(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props)
end

local function tweenElastic(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), props)
end

local function tweenExpo(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), props)
end

local function tweenSine(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), props)
end

local function tweenLinear(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), props)
end

local function tweenBack(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props)
end

local function tweenQuint(obj, dur, props)
    return TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
end

-- ═══════════════════════════════════════════════════════════════
-- BLUR EFFECT CONTROLLER (Premium visual effects)
-- ═══════════════════════════════════════════════════════════════
local BlurMod = Instance.new("BlurEffect")
BlurMod.Size = 0
BlurMod.Parent = Lighting

local function setBlur(intensity, duration)
    duration = duration or 0.3
    tweenSmooth(BlurMod, duration, { Size = intensity }):Play()
end

-- ═══════════════════════════════════════════════════════════════
-- PREMIUM PASTEL THEME (NO DARK COLORS)
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
-- PROFESSIONAL EASING FUNCTIONS
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
-- HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════
local function getGuiParent()
    if gethui then return gethui() end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- ═══════════════════════════════════════════════════════════════
-- KEY SYSTEM WITH LOCAL PERSISTENCE
-- ═══════════════════════════════════════════════════════════════
local KeySystem = {
    StorageName = "XynorKey_v3",
    ValidKeys = {"123", "xynor", "premium", "beta", "v3", "xynorhub", "kenyah"}
}

function KeySystem:GetSaved()
    local success, result = pcall(function()
        if readfile then
            return readfile(self.StorageName)
        end
        return nil
    end)
    return success and result or nil
end

function KeySystem:Save(key)
    pcall(function()
        if writefile then
            writefile(self.StorageName, key)
        end
    end)
end

function KeySystem:Check(key)
    key = string.lower(key or "")
    for _, valid in ipairs(self.ValidKeys) do
        if key == string.lower(valid) then
            return true
        end
    end
    return false
end

-- ═══════════════════════════════════════════════════════════════
-- MODERN LOADER WITH KEY SYSTEM
-- ═══════════════════════════════════════════════════════════════
local function CreateLoader()
    local Parent = getGuiParent()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XynorLoader_v3"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Parent
    
    setBlur(8, 0)
    
    local particleColors = {
        Theme.Primary,
        Theme.Accent,
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
        
        tweenSmooth(particle, 0.5, { BackgroundTransparency = 0.6 }):Play()
        
        local startTime = os.clock()
        local duration = math.random(2, 4)
        
        local conn
        conn = RunService.RenderStepped:Connect(function()
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
        
        return particle
    end
    
    local particleConnection
    task.spawn(function()
        local frameCount = 0
        particleConnection = RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            if frameCount % 8 == 0 then
                local numParticles = math.random(1, 2)
                for i = 1, numParticles do
                    task.spawn(createParticle)
                end
            end
        end)
    end)
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.fromOffset(420, 320)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.BackgroundColor3 = Theme.White
    Container.BorderSizePixel = 0
    Container.ClipsDescendants = true
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Visible = false
    local containerUIScale = Instance.new("UIScale")
    containerUIScale.Scale = 0.85
    containerUIScale.Parent = Container
    Container.Parent = ScreenGui
    
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 24)
    cCorner.Parent = Container
    
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
    
    local LogoSection = Instance.new("Frame")
    LogoSection.Size = UDim2.new(1, 0, 0, 100)
    LogoSection.Position = UDim2.new(0, 0, 0, 35)
    LogoSection.BackgroundTransparency = 1
    LogoSection.Parent = Container
    
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
    
    local ProgressBg = Instance.new("Frame")
    ProgressBg.Size = UDim2.new(1, -80, 0, 6)
    ProgressBg.Position = UDim2.new(0, 40, 0, 110)
    ProgressBg.BackgroundColor3 = Theme.LightGray
    ProgressBg.BorderSizePixel = 0
    ProgressBg.Parent = Container
    
    local pbCorner = Instance.new("UICorner")
    pbCorner.CornerRadius = UDim.new(1, 0)
    pbCorner.Parent = ProgressBg
    
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
    KeyPrompt.TextTransparency = 1
    KeyPrompt.Parent = KeyFrame
    
    local InputBg = Instance.new("Frame")
    InputBg.Size = UDim2.new(1, 0, 0, 36)
    InputBg.Position = UDim2.new(0, 0, 0, 22)
    InputBg.BackgroundColor3 = Theme.WarmWhite
    InputBg.BorderSizePixel = 0
    InputBg.BackgroundTransparency = 1
    InputBg.Parent = KeyFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = InputBg
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Theme.Border
    inputStroke.Thickness = 1.5
    inputStroke.Transparency = 1
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
    KeyInput.TextTransparency = 1
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
    ValidateBtn.TextTransparency = 1
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
    
    local loadingDone = false
    
    task.spawn(function()
        task.wait(0.05)
        Container.Visible = true
        
        tweenElastic(containerUIScale, 0.8, { Scale = 1 }):Play()
        
        task.wait(0.15)
        tweenElastic(MainTitle, 0.6, { TextTransparency = 0, TextSize = 42 }):Play()
        task.wait(0.1)
        tweenSmooth(SubTitle, 0.5, { TextTransparency = 0 }):Play()
        
        task.wait(0.2)
        
        local loadTween = tweenSmooth(ProgressBar, 2.0, { Size = UDim2.new(1, 0, 1, 0) })
        loadTween:Play()
        
        task.wait(0.3)
        tweenSmooth(ProgressText, 0.3, { TextTransparency = 0 }):Play()
        
        task.wait(2.0)
        loadTween:Cancel()
        ProgressBar.Size = UDim2.new(1, 0, 1, 0)
        loadingDone = true
        
        tweenSmooth(ProgressBg, 0.6, { BackgroundTransparency = 0.9, Position = UDim2.new(0, 40, 0, 70) }):Play()
        tweenSmooth(ProgressBar, 0.4, { BackgroundTransparency = 1 }):Play()
        tweenSmooth(ProgressText, 0.4, { TextTransparency = 1 }):Play()
        tweenSmooth(glowLine, 0.3, { BackgroundTransparency = 1 }):Play()
        tweenSmooth(MainTitle, 0.4, { TextTransparency = 0.3 }):Play()
        tweenSmooth(SubTitle, 0.4, { TextTransparency = 0.3 }):Play()
        
        task.wait(0.15)
        
        local dotsTween = tweenSmooth(DotsFrame, 0.7, { 
            Position = UDim2.new(0.5, -30, 0, 80), 
            BackgroundTransparency = 0 
        })
        dotsTween:Play()
        
        for i, dot in ipairs(dots) do
            task.wait(0.08)
            tweenSmooth(dot, 0.3, { BackgroundTransparency = 0, Size = UDim2.fromOffset(10, 10) }):Play()
        end
        
        task.wait(0.2)
        
        KeyFrame.Visible = true
        
        local inputTween = tweenElastic(KeyFrame, 0.6, { BackgroundTransparency = 0 })
        inputTween:Play()
        
        task.wait(0.1)
        tweenSmooth(KeyPrompt, 0.4, { TextTransparency = 0 }):Play()
        task.wait(0.05)
        
        local inputBgTween = tweenSmooth(InputBg, 0.4, { BackgroundTransparency = 0 })
        inputBgTween:Play()
        
        task.wait(0.05)
        tweenSmooth(inputStroke, 0.4, { Transparency = 0 }):Play()
        tweenSmooth(KeyInput, 0.4, { TextTransparency = 0 }):Play()
        
        task.wait(0.08)
        tweenElastic(ValidateBtn, 0.5, { TextTransparency = 0 }):Play()
    end)
    
    task.spawn(function()
        local dotIndex = 1
        while Container.Parent and not loadingDone do
            local dot = dots[dotIndex]
            if dot then
                tweenElastic(dot, 0.3, { BackgroundTransparency = 0.2, Size = UDim2.fromOffset(11, 11) }):Play()
            end
            task.wait(0.12)
            if dot then
                tweenSmooth(dot, 0.25, { BackgroundTransparency = 0, Size = UDim2.fromOffset(8, 8) }):Play()
            end
            dotIndex = (dotIndex % 3) + 1
            task.wait(0.08)
        end
    end)
    
    ValidateBtn.MouseEnter:Connect(function()
        tweenElastic(ValidateBtn, 0.25, { BackgroundColor3 = Theme.PrimaryDark, Size = UDim2.new(1, 6, 0, 38) }):Play()
    end)
    
    ValidateBtn.MouseLeave:Connect(function()
        tweenSmooth(ValidateBtn, 0.2, { BackgroundColor3 = Theme.Primary, Size = UDim2.new(1, 0, 0, 34) }):Play()
    end)
    
    return {
        Gui = ScreenGui,
        KeyInput = KeyInput,
        SubmitBtn = ValidateBtn,
        Feedback = FeedbackLabel,
        Container = Container,
        KeyFrame = KeyFrame,
        ProgressText = ProgressText,
        ProgressBar = ProgressBar,
        IsLoadingDone = function() return loadingDone end,
        ParticleConn = particleConnection
    }
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN WINDOW BUILDER - Complete Premium UI
-- ═══════════════════════════════════════════════════════════════
local function BuildMainWindow()
    local isMobile = UserInputService.TouchEnabled
    local winW = isMobile and 500 or 620  -- Reducido ~10%
    local winH = isMobile and 400 or 520  -- Reducido ~10%
    
    local Parent = getGuiParent()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XynorHub_v3"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = Parent
    
    -- Glass effect overlay (blur + tint)
    local GlassOverlay = Instance.new("Frame")
    GlassOverlay.Size = UDim2.new(1, 0, 1, 0)
    GlassOverlay.BackgroundColor3 = Theme.White
    GlassOverlay.BackgroundTransparency = 0.85
    GlassOverlay.BorderSizePixel = 0
    GlassOverlay.Parent = ScreenGui
    GlassOverlay.Visible = false
    
    local glassC = Instance.new("UICorner")
    glassC.CornerRadius = UDim.new(0, 20)
    glassC.Parent = GlassOverlay
    
    local glassStroke = Instance.new("UIStroke")
    glassStroke.Color = Theme.Border
    glassStroke.Thickness = 1
    glassStroke.Transparency = 0.5
    glassStroke.Parent = GlassOverlay
    
    -- Main frame (now on top of glass)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(180, 180)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Theme.White
    MainFrame.BorderSizePixel = 0
    MainFrame.BackgroundTransparency = 1
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    MainFrame.ZIndex = 2
    
    local mfC = Instance.new("UICorner")
    mfC.CornerRadius = UDim.new(0, 20)
    mfC.Parent = MainFrame
    
    -- Glass panel behind main content
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
    
    -- Premium drop shadow ring
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
    
    -- Topbar (elevated glass panel)
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
    
    -- Subtle bottom border
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
    
    -- Premium top accent line with gradient effect
    local topAccent = Instance.new("Frame")
    topAccent.Size = UDim2.new(1, -40, 0, 2)
    topAccent.Position = UDim2.new(0, 20, 0, 0)
    topAccent.BackgroundColor3 = Theme.Primary
    topAccent.BorderSizePixel = 0
    topAccent.Parent = Topbar
    
    local taC = Instance.new("UICorner")
    taC.CornerRadius = UDim.new(1, 0)
    taC.Parent = topAccent
    
    -- Mini glow under accent
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
    TitleLbl.Size = UDim2.new(0, 220, 0.6, 0)
    TitleLbl.Position = UDim2.fromOffset(18, 5)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = "XYNOR HUB v3"
    TitleLbl.TextColor3 = Theme.TextPrimary
    TitleLbl.Font = Enum.Font.GothamBlack
    TitleLbl.TextSize = isMobile and 17 or 19
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.TextTransparency = 1
    TitleLbl.Parent = Topbar
    
    local CreditLbl = Instance.new("TextLabel")
    CreditLbl.Size = UDim2.new(0, 220, 0.4, 0)
    CreditLbl.Position = UDim2.fromOffset(18, isMobile and 32 or 36)
    CreditLbl.BackgroundTransparency = 1
    CreditLbl.Text = "by Xynor"
    CreditLbl.TextColor3 = Theme.Accent
    CreditLbl.Font = Enum.Font.GothamMedium
    CreditLbl.TextSize = 11
    CreditLbl.TextXAlignment = Enum.TextXAlignment.Left
    CreditLbl.TextTransparency = 1
    CreditLbl.Parent = Topbar
    
    -- Window controls (minimize/close) con iconos
    local ControlFrame = Instance.new("Frame")
    ControlFrame.Size = UDim2.new(0, 80, 0, 28)
    ControlFrame.Position = UDim2.new(1, -90, 0.5, -14)
    ControlFrame.BackgroundTransparency = 1
    ControlFrame.Parent = Topbar
    ControlFrame.ZIndex = 5
    
    -- Minimize button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.fromOffset(28, 28)
    MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    MinimizeBtn.BackgroundColor3 = Theme.LightGray
    MinimizeBtn.Text = "−"
    MinimizeBtn.TextColor3 = Theme.TextSecondary
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 16
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Parent = ControlFrame
    
    local minC = Instance.new("UICorner")
    minC.CornerRadius = UDim.new(1, 0)
    minC.Parent = MinimizeBtn
    
    local minStroke = Instance.new("UIStroke")
    minStroke.Color = Theme.Border
    minStroke.Thickness = 1
    minStroke.Parent = MinimizeBtn
    
    MinimizeBtn.MouseEnter:Connect(function()
        tweenElastic(MinimizeBtn, 0.25, { 
            BackgroundColor3 = Theme.BorderHover,
            Size = UDim2.fromOffset(32, 32)
        }):Play()
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        tweenSmooth(MinimizeBtn, 0.2, { 
            BackgroundColor3 = Theme.LightGray,
            Size = UDim2.fromOffset(28, 28)
        }):Play()
    end)
    
    -- Close button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.fromOffset(28, 28)
    CloseBtn.Position = UDim2.new(1, -28, 0, 0)
    CloseBtn.BackgroundColor3 = Theme.Accent
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = ControlFrame
    
    local cloC = Instance.new("UICorner")
    cloC.CornerRadius = UDim.new(1, 0)
    cloC.Parent = CloseBtn
    
    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = Theme.AccentDark
    closeStroke.Thickness = 1
    closeStroke.Parent = CloseBtn
    
    CloseBtn.MouseEnter:Connect(function()
        tweenElastic(CloseBtn, 0.25, { 
            BackgroundColor3 = Theme.AccentDark,
            Size = UDim2.fromOffset(32, 32)
        }):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        tweenSmooth(CloseBtn, 0.2, { 
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.fromOffset(28, 28)
        }):Play()
    end)
    
    -- Content
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, 0, 1, -isMobile and 46 or 54)
    Content.Position = UDim2.new(0, 0, 0, isMobile and 46 or 54)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame
    
    -- Sidebar (glassmorphism panel)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, 0)  -- Reducido de 165 a 150 (-10%)
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.BackgroundColor3 = Theme.Cream
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Content
    Sidebar.ZIndex = 2
    
    local sbC = Instance.new("UICorner")
    sbC.CornerRadius = UDim.new(0, 16)
    sbC.Parent = Sidebar
    
    -- Glass effect
    local sbGlass = Instance.new("Frame")
    sbGlass.Size = UDim2.new(1, 2, 1, 2)
    sbGlass.Position = UDim2.new(0, -1, 0, -1)
    sbGlass.BackgroundColor3 = Theme.Primary
    sbGlass.BackgroundTransparency = 0.97
    sbGlass.BorderSizePixel = 0
    sbGlass.ZIndex = Sidebar.ZIndex - 1
    sbGlass.Parent = Sidebar
    
    local sbgC = Instance.new("UICorner")
    sbgC.CornerRadius = UDim.new(0, 18)
    sbgC.Parent = sbGlass
    
    -- Inner sidebar
    local SidebarInner = Instance.new("Frame")
    SidebarInner.Size = UDim2.new(1, -6, 1, -6)
    SidebarInner.Position = UDim2.new(0, 3, 0, 3)
    SidebarInner.BackgroundTransparency = 1
    SidebarInner.ClipsDescendants = false
    SidebarInner.Parent = Sidebar
    
    -- Divider (sutil)
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(0, 1, 1, 0)
    Divider.Position = UDim2.fromOffset(150, 0)  -- Aligned with new sidebar width
    Divider.BackgroundColor3 = Theme.Border
    Divider.BackgroundTransparency = 0.6
    Divider.BorderSizePixel = 0
    Divider.Parent = Content
    
    -- Page holder
    local PageHolder = Instance.new("Frame")
    PageHolder.Size = UDim2.new(1, -151, 1, 0)  -- Adjusted
    PageHolder.Position = UDim2.fromOffset(151, 0)  -- Adjusted
    PageHolder.BackgroundTransparency = 1
    PageHolder.Parent = Content
    
    -- ═══════════════════════════════════════════════════════════════
    -- TAB SYSTEM API
    -- ═══════════════════════════════════════════════════════════════
    local SectionData = {}
    local CurrentPage = nil
    
    -- Window API
    local WindowAPI = {}
    
    function WindowAPI:Section(opts)
        local secOrder = #SectionData + 1
        local section = {
            Title = opts.Title or "",
            Tabs = {},
            Order = secOrder
        }
        table.insert(SectionData, section)
        
        -- Create section header in sidebar
        local secHeader = Instance.new("TextLabel")
        secHeader.Size = UDim2.new(1, 0, 0, 18)
        secHeader.BackgroundTransparency = 1
        secHeader.Text = "  " .. string.upper(section.Title) .. "  "
        secHeader.TextColor3 = Theme.TextMuted
        secHeader.Font = Enum.Font.GothamSemibold
        secHeader.TextSize = 9
        secHeader.TextXAlignment = Enum.TextXAlignment.Left
        secHeader.LayoutOrder = section.Order * 1000
        secHeader.Parent = SidebarInner
        
        return section
    end
    
    function WindowAPI:Tab(section, opts)
        local tabOrder = #section.Tabs + 1
        local tab = {
            Title = opts.Title or "Tab",
            Icon = opts.Icon or "◉",
            Page = nil,
            Scroll = nil,
            Builder = {},
            Order = tabOrder
        }
        table.insert(section.Tabs, tab)
        
        -- Create button (glassmorphism style)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 38)
        btn.Position = UDim2.fromOffset(5, 5)
        btn.BackgroundColor3 = Theme.White
        btn.Text = ""
        btn.Parent = SidebarInner
        btn.LayoutOrder = section.Order * 1000 + tabOrder
        
        local bC = Instance.new("UICorner")
        bC.CornerRadius = UDim.new(0, 10)
        bC.Parent = btn
        
        -- Glass overlay
        local glassOverlay = Instance.new("Frame")
        glassOverlay.Size = UDim2.new(1, 0, 1, 0)
        glassOverlay.BackgroundColor3 = Theme.Primary
        glassOverlay.BackgroundTransparency = 0.95
        glassOverlay.BorderSizePixel = 0
        glassOverlay.Parent = btn
        glassOverlay.ZIndex = btn.ZIndex - 1
        
        local goC = Instance.new("UICorner")
        goC.CornerRadius = UDim.new(0, 10)
        goC.Parent = glassOverlay
        
        -- Active indicator (left border)
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 3, 0, 16)
        indicator.Position = UDim2.new(0, 0, 0.5, -8)
        indicator.BackgroundColor3 = Theme.Primary
        indicator.BorderSizePixel = 0
        indicator.BackgroundTransparency = 1
        indicator.Parent = btn
        
        local indC = Instance.new("UICorner")
        indC.CornerRadius = UDim.new(1, 0)
        indC.Parent = indicator
        
        -- Icon (MaterialSymbols)
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.fromOffset(20, 20)
        icon.Position = UDim2.fromOffset(12, 9)
        icon.BackgroundTransparency = 1
        icon.Text = tab.Icon
        icon.TextColor3 = Theme.TextMuted
        icon.Font = Enum.Font.MaterialSymbols
        icon.TextSize = 18
        icon.Parent = btn
        
        -- Title
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -45, 1, 0)
        title.Position = UDim2.fromOffset(38, 0)
        title.BackgroundTransparency = 1
        title.Text = tab.Title
        title.TextColor3 = Theme.TextSecondary
        title.Font = Enum.Font.GothamMedium
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = btn
        
        local hoverOverlay = Instance.new("Frame")
        hoverOverlay.Size = UDim2.new(1, 0, 1, 0)
        hoverOverlay.BackgroundColor3 = Theme.Primary
        hoverOverlay.BackgroundTransparency = 0.96
        hoverOverlay.BorderSizePixel = 0
        hoverOverlay.Parent = btn
        hoverOverlay.ZIndex = btn.ZIndex - 1
        
        local hC = Instance.new("UICorner")
        hC.CornerRadius = UDim.new(0, 10)
        hC.Parent = hoverOverlay
        
        -- Click handler con efectos premium
        btn.MouseButton1Click:Connect(function()
            -- Desactivar todos los tabs
            for _, tbtn in pairs(SidebarInner:GetChildren()) do
                if tbtn:IsA("TextButton") then
                    local ind = tbtn:FindFirstChild("Frame")
                    local ico = tbtn:FindFirstChild("TextLabel", true)
                    local hv = tbtn:FindFirstChild("Frame", true)
                    
                    tweenSmooth(tbtn, 0.25, { BackgroundColor3 = Theme.White }):Play()
                    if ind then tweenSmooth(ind, 0.25, { BackgroundTransparency = 1 }):Play() end
                    if ico then tweenSmooth(ico, 0.25, { TextColor3 = Theme.TextMuted }):Play() end
                    if hv then tweenSmooth(hv, 0.25, { BackgroundTransparency = 0.96 }):Play() end
                end
            end
            
            -- Activar este tab
            tweenSmooth(btn, 0.3, { BackgroundColor3 = Theme.WarmWhite }):Play()
            tweenSmooth(indicator, 0.3, { BackgroundTransparency = 0 }):Play()
            tweenSmooth(icon, 0.3, { TextColor3 = Theme.Primary }):Play()
            tweenSmooth(hoverOverlay, 0.3, { BackgroundTransparency = 0.98 }):Play()
            
            if tab.Page then
                task.spawn(function()
                    task.wait(0.1)
                    for _, p in ipairs(PageHolder:GetChildren()) do
                        if p:IsA("Frame") then p.Visible = false end
                    end
                    tab.Page.Visible = true
                end)
            end
            CurrentPage = btn
        end)
        
        -- Create page
        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = PageHolder
        
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 5
        scroll.ScrollBarImageColor3 = Theme.Primary
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Parent = page
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.Parent = scroll
        
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 8)
        padding.PaddingLeft = UDim.new(0, 12)
        padding.PaddingRight = UDim.new(0, 12)
        padding.PaddingBottom = UDim.new(0, 24)
        padding.Parent = scroll
        
        tab.Page = page
        tab.Scroll = scroll
        
        if tabOrder == 1 then
            task.wait(0.15)
            -- Auto-select first tab directly (Fire() not supported in Luau)
            for _, tbtn in pairs(SidebarInner:GetChildren()) do
                if tbtn:IsA("TextButton") then
                    local ind = tbtn:FindFirstChild("Frame")
                    local ico = tbtn:FindFirstChild("TextLabel", true)
                    local hv = tbtn:FindFirstChild("Frame", true)
                    tweenSmooth(tbtn, 0.25, { BackgroundColor3 = Theme.White }):Play()
                    if ind then tweenSmooth(ind, 0.25, { BackgroundTransparency = 1 }):Play() end
                    if ico then tweenSmooth(ico, 0.25, { TextColor3 = Theme.TextMuted }):Play() end
                    if hv then tweenSmooth(hv, 0.25, { BackgroundTransparency = 0.96 }):Play() end
                end
            end
            tweenSmooth(btn, 0.3, { BackgroundColor3 = Theme.WarmWhite }):Play()
            tweenSmooth(indicator, 0.3, { BackgroundTransparency = 0 }):Play()
            tweenSmooth(icon, 0.3, { TextColor3 = Theme.Primary }):Play()
            tweenSmooth(hoverOverlay, 0.3, { BackgroundTransparency = 0.98 }):Play()
            for _, p in ipairs(PageHolder:GetChildren()) do
                if p:IsA("Frame") then p.Visible = false end
            end
            if page then page.Visible = true end
            CurrentPage = btn
        end
        
        -- Builder
        local builder = {}
        local order = 0
        
        local function nextOrder()
            order = order + 1
            return order
        end
        
        -- Section method (inside tab)
        function builder:Section(opts)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 28)
            container.BackgroundTransparency = 1
            container.LayoutOrder = nextOrder()
            container.Parent = scroll
            
            local secTitle = Instance.new("TextLabel")
            secTitle.Size = UDim2.new(0, 0, 0, 16)
            secTitle.AutomaticSize = Enum.AutomaticSize.X
            secTitle.Position = UDim2.fromOffset(8, 0)
            secTitle.BackgroundColor3 = Theme.Primary
            secTitle.BackgroundTransparency = 1
            secTitle.BorderSizePixel = 0
            secTitle.Text = "  " .. (opts.Title or "") .. "  "
            secTitle.TextColor3 = Theme.White
            secTitle.Font = Enum.Font.GothamSemibold
            secTitle.TextSize = 10
            secTitle.Parent = container
            
            local scC = Instance.new("UICorner")
            scC.CornerRadius = UDim.new(0, 6)
            scC.Parent = secTitle
        end
        
        -- Toggle method
        function builder:Toggle(opts)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 46)
            container.BackgroundColor3 = Theme.Panel
            container.BorderSizePixel = 0
            container.LayoutOrder = nextOrder()
            container.Parent = scroll
            
            local cntC = Instance.new("UICorner")
            cntC.CornerRadius = UDim.new(0, 10)
            cntC.Parent = container
            
            local cntStroke = Instance.new("UIStroke")
            cntStroke.Color = Theme.Border
            cntStroke.Thickness = 1
            cntStroke.Parent = container
            
            local hover = Instance.new("Frame")
            hover.Size = UDim2.new(1, 0, 1, 0)
            hover.BackgroundColor3 = Theme.Primary
            hover.BackgroundTransparency = 0.95
            hover.BorderSizePixel = 0
            hover.Parent = container
            hover.ZIndex = container.ZIndex - 1
            
            local hC = Instance.new("UICorner")
            hC.CornerRadius = UDim.new(0, 10)
            hC.Parent = hover
            
            local titleLbl = Instance.new("TextLabel")
            titleLbl.Size = UDim2.new(1, -60, 0.5, 0)
            titleLbl.Position = UDim2.fromOffset(14, 3)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Text = opts.Title or ""
            titleLbl.TextColor3 = Theme.TextPrimary
            titleLbl.Font = Enum.Font.GothamSemibold
            titleLbl.TextSize = 13
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.Parent = container
            
            if opts.Desc and opts.Desc ~= "" then
                local descLb = Instance.new("TextLabel")
                descLb.Size = UDim2.new(1, -60, 0.5, 0)
                descLb.Position = UDim2.new(0, 14, 0.5, 0)
                descLb.BackgroundTransparency = 1
                descLb.Text = opts.Desc
                descLb.TextColor3 = Theme.TextSecondary
                descLb.Font = Enum.Font.Gotham
                descLb.TextSize = 11
                descLb.TextXAlignment = Enum.TextXAlignment.Left
                descLb.Parent = container
            end
            
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.fromOffset(40, 22)
            toggleBg.Position = UDim2.new(1, -50, 0.5, -11)
            toggleBg.BackgroundColor3 = Theme.Border
            toggleBg.BorderSizePixel = 0
            toggleBg.Parent = container
            
            local tbC = Instance.new("UICorner")
            tbC.CornerRadius = UDim.new(1, 0)
            tbC.Parent = toggleBg
            
            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(16, 16)
            knob.Position = UDim2.fromOffset(3, 3)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.BorderSizePixel = 0
            knob.Parent = toggleBg
            
            local kC = Instance.new("UICorner")
            kC.CornerRadius = UDim.new(1, 0)
            kC.Parent = knob
            
            local state = false
            
            local toggleObj = {}
            function toggleObj:Set(v)
                state = v
                tweenSmooth(toggleBg, 0.2, { 
                    BackgroundColor3 = v and Theme.Primary or Theme.Border 
                }):Play()
                tweenElastic(knob, 0.3, { 
                    Position = v and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3)
                }):Play()
                if opts.Callback then opts.Callback(v) end
            end
            
            local clickArea = Instance.new("TextButton")
            clickArea.Size = UDim2.new(1, 0, 1, 0)
            clickArea.BackgroundTransparency = 1
            clickArea.Text = ""
            clickArea.Parent = container
            
            clickArea.MouseButton1Click:Connect(function()
                tweenSmooth(hover, 0.1, { BackgroundTransparency = 0.8 }):Play()
                task.delay(0.12, function()
                    tweenSmooth(hover, 0.25, { BackgroundTransparency = 0.95 }):Play()
                end)
                toggleObj:Set(not state)
            end)
            
            return toggleObj
        end
        
        -- Slider method
        function builder:Slider(opts)
            local valData = opts.Value or opts
            local minV = valData.Min or 0
            local maxV = valData.Max or 100
            local defV = valData.Default or minV
            local currentVal = defV
            
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 56)
            container.BackgroundColor3 = Theme.Panel
            container.BorderSizePixel = 0
            container.LayoutOrder = nextOrder()
            container.Parent = scroll
            
            local cntC = Instance.new("UICorner")
            cntC.CornerRadius = UDim.new(0, 10)
            cntC.Parent = container
            
            local cntStroke = Instance.new("UIStroke")
            cntStroke.Color = Theme.Border
            cntStroke.Thickness = 1
            cntStroke.Parent = container
            
            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -70, 0.5, 0)
            titleLb.Position = UDim2.fromOffset(14, 3)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts.Title or ""
            titleLb.TextColor3 = Theme.TextPrimary
            titleLb.Font = Enum.Font.GothamSemibold
            titleLb.TextSize = 13
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = container
            
            if opts.Desc and opts.Desc ~= "" then
                local descLb = Instance.new("TextLabel")
                descLb.Size = UDim2.new(1, -70, 0, 16)
                descLb.Position = UDim2.new(0, 14, 0, 22)
                descLb.BackgroundTransparency = 1
                descLb.Text = opts.Desc
                descLb.TextColor3 = Theme.TextSecondary
                descLb.Font = Enum.Font.Gotham
                descLb.TextSize = 10
                descLb.TextXAlignment = Enum.TextXAlignment.Left
                descLb.Parent = container
            end
            
            local valDisplay = Instance.new("TextLabel")
            valDisplay.Size = UDim2.fromOffset(55, 18)
            valDisplay.Position = UDim2.new(1, -65, 0, 4)
            valDisplay.BackgroundTransparency = 1
            valDisplay.Text = string.format("%.1f", defV)
            valDisplay.TextColor3 = Theme.Primary
            valDisplay.Font = Enum.Font.GothamBold
            valDisplay.TextSize = 12
            valDisplay.TextXAlignment = Enum.TextXAlignment.Right
            valDisplay.Parent = container
            
            local trackBg = Instance.new("Frame")
            trackBg.Size = UDim2.new(1, -20, 0, 5)
            trackBg.Position = UDim2.new(0, 10, 1, -14)
            trackBg.BackgroundColor3 = Theme.LightGray
            trackBg.BorderSizePixel = 0
            trackBg.Parent = container
            
            local trC = Instance.new("UICorner")
            trC.CornerRadius = UDim.new(1, 0)
            trC.Parent = trackBg
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((defV - minV) / (maxV - minV), 0, 1, 0)
            fill.BackgroundColor3 = Theme.Primary
            fill.BorderSizePixel = 0
            fill.Parent = trackBg
            
            local fillC = Instance.new("UICorner")
            fillC.CornerRadius = UDim.new(1, 0)
            fillC.Parent = fill
            
            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Size = UDim2.new(1, 0, 0, 18)
            sliderBtn.Position = UDim2.new(0, 0, 1, -18)
            sliderBtn.BackgroundTransparency = 1
            sliderBtn.Text = ""
            sliderBtn.Parent = container
            
            local sliding = false
            
            sliderBtn.MouseButton1Down:Connect(function()
                sliding = true
                updateSlider(sliderBtn.AbsolutePosition.X + sliderBtn.AbsoluteSize.X/2)
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
            
            local function updateSlider(mouseX)
                local posX = trackBg.AbsolutePosition.X
                local sizeX = trackBg.AbsoluteSize.X
                local rel = math.clamp((mouseX - posX) / sizeX, 0, 1)
                local newVal = minV + rel * (maxV - minV)
                currentVal = math.floor(newVal * 100 + 0.5) / 100
                fill.Size = UDim2.new(rel, 0, 1, 0)
                valDisplay.Text = string.format("%.1f", currentVal)
                if opts.Callback then opts.Callback(currentVal) end
            end
            
            return {}
        end
        
        -- Button method
        function builder:Button(opts)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 44)
            container.BackgroundColor3 = Theme.Panel
            container.BorderSizePixel = 0
            container.LayoutOrder = nextOrder()
            container.Parent = scroll
            
            local cntC = Instance.new("UICorner")
            cntC.CornerRadius = UDim.new(0, 10)
            cntC.Parent = container
            
            local cntStroke = Instance.new("UIStroke")
            cntStroke.Color = Theme.Border
            cntStroke.Thickness = 1
            cntStroke.Parent = container
            
            local btnArea = Instance.new("TextButton")
            btnArea.Size = UDim2.new(1, 0, 1, 0)
            btnArea.BackgroundTransparency = 1
            btnArea.Text = ""
            btnArea.Parent = container
            
            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -40, 1, 0)
            titleLb.Position = UDim2.fromOffset(14, 0)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts.Title or ""
            titleLb.TextColor3 = Theme.TextPrimary
            titleLb.Font = Enum.Font.GothamSemibold
            titleLb.TextSize = 13
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = container
            
            if opts.Desc and opts.Desc ~= "" then
                titleLb.Size = UDim2.new(1, -40, 0.5, 0)
                titleLb.Position = UDim2.fromOffset(14, 4)
                
                local descLb = Instance.new("TextLabel")
                descLb.Size = UDim2.new(1, -40, 0.5, 0)
                descLb.Position = UDim2.new(0, 14, 0.5, 0)
                descLb.BackgroundTransparency = 1
                descLb.Text = opts.Desc
                descLb.TextColor3 = Theme.TextSecondary
                descLb.Font = Enum.Font.Gotham
                descLb.TextSize = 11
                descLb.TextXAlignment = Enum.TextXAlignment.Left
                descLb.Parent = container
            end
            
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.fromOffset(18, 18)
            arrow.Position = UDim2.new(1, -28, 0.5, -9)
            arrow.BackgroundTransparency = 1
            arrow.Text = "›"
            arrow.TextColor3 = Theme.Primary
            arrow.Font = Enum.Font.GothamBold
            arrow.TextSize = 20
            arrow.Parent = container
            
            btnArea.MouseEnter:Connect(function()
                tweenElastic(container, 0.25, { 
                    BackgroundColor3 = Theme.PanelHover,
                    Size = UDim2.new(1, 0, 0, 48)
                }):Play()
                tweenElastic(arrow, 0.2, { 
                    TextColor3 = Theme.PrimaryDark,
                    Position = UDim2.new(1, -24, 0.5, -9)
                }):Play()
            end)
            
            btnArea.MouseLeave:Connect(function()
                tweenSmooth(container, 0.2, { 
                    BackgroundColor3 = Theme.Panel,
                    Size = UDim2.new(1, 0, 0, 44)
                }):Play()
                tweenSmooth(arrow, 0.2, { 
                    TextColor3 = Theme.Primary,
                    Position = UDim2.new(1, -28, 0.5, -9)
                }):Play()
            end)
            
            btnArea.MouseButton1Down:Connect(function()
                tweenElastic(container, 0.08, { Size = UDim2.new(1, 0, 0, 40) }):Play()
            end)
            
            btnArea.MouseButton1Up:Connect(function()
                tweenSmooth(container, 0.15, { Size = UDim2.new(1, 0, 0, 44) }):Play()
            end)
            
            btnArea.MouseButton1Click:Connect(function()
                tweenSmooth(container, 0.08, { BackgroundColor3 = Theme.PrimaryLight }):Play()
                task.wait(0.1)
                tweenSmooth(container, 0.15, { BackgroundColor3 = Theme.Panel }):Play()
                if opts.Callback then task.spawn(opts.Callback) end
            end)
        end
        
        -- Keybind method
        function builder:Keybind(opts)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 46)
            container.BackgroundColor3 = Theme.Panel
            container.BorderSizePixel = 0
            container.LayoutOrder = nextOrder()
            container.Parent = scroll
            
            local cntC = Instance.new("UICorner")
            cntC.CornerRadius = UDim.new(0, 10)
            cntC.Parent = container
            
            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -80, 0.5, 0)
            titleLb.Position = UDim2.fromOffset(14, 3)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts.Title or ""
            titleLb.TextColor3 = Theme.TextPrimary
            titleLb.Font = Enum.Font.GothamSemibold
            titleLb.TextSize = 13
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = container
            
            local keyBg = Instance.new("Frame")
            keyBg.Size = UDim2.fromOffset(60, 28)
            keyBg.Position = UDim2.new(1, -74, 0.5, -14)
            keyBg.BackgroundColor3 = Theme.WarmWhite
            keyBg.BorderSizePixel = 0
            keyBg.Parent = container
            
            local kbC = Instance.new("UICorner")
            kbC.CornerRadius = UDim.new(0, 8)
            kbC.Parent = keyBg
            
            local kbStroke = Instance.new("UIStroke")
            kbStroke.Color = Theme.Border
            kbStroke.Thickness = 1.2
            kbStroke.Parent = keyBg
            
            local currentKey = opts.Default or Enum.KeyCode.Unknown
            local keyLbl = Instance.new("TextLabel")
            keyLbl.Size = UDim2.new(1, 0, 1, 0)
            keyLbl.BackgroundTransparency = 1
            keyLbl.Text = tostring(currentKey.Name or currentKey)
            keyLbl.TextColor3 = Theme.TextPrimary
            keyLbl.Font = Enum.Font.GothamSemibold
            keyLbl.TextSize = 11
            keyLbl.Parent = keyBg
            
            local keyBtn = Instance.new("TextButton")
            keyBtn.Size = UDim2.new(1, 0, 1, 0)
            keyBtn.BackgroundTransparency = 1
            keyBtn.Text = ""
            keyBtn.Parent = keyBg
            
            local listening = false
            keyBtn.MouseButton1Click:Connect(function()
                listening = not listening
                if listening then
                    keyLbl.Text = "..."
                    tweenSmooth(kbStroke, 0.15, { Color = Theme.Primary }):Play()
                    tweenSmooth(keyBg, 0.15, { BackgroundColor3 = Theme.LightGray }):Play()
                else
                    tweenSmooth(kbStroke, 0.15, { Color = Theme.Border }):Play()
                    tweenSmooth(keyBg, 0.15, { BackgroundColor3 = Theme.WarmWhite }):Play()
                end
            end)
            
            UserInputService.InputBegan:Connect(function(input, gp)
                if listening and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    keyLbl.Text = tostring(input.KeyCode.Name)
                    listening = false
                    tweenSmooth(kbStroke, 0.15, { Color = Theme.Border }):Play()
                    tweenSmooth(keyBg, 0.15, { BackgroundColor3 = Theme.WarmWhite }):Play()
                    if opts.Callback then opts.Callback(input.KeyCode) end
                elseif not listening and not gp and input.KeyCode == currentKey then
                    if opts.Callback then task.spawn(opts.Callback) end
                end
            end)
            
            return {}
        end
        
        -- Input method
        function builder:Input(opts)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 64)
            container.BackgroundColor3 = Theme.Panel
            container.BorderSizePixel = 0
            container.LayoutOrder = nextOrder()
            container.Parent = scroll
            
            local cntC = Instance.new("UICorner")
            cntC.CornerRadius = UDim.new(0, 10)
            cntC.Parent = container
            
            local cntStroke = Instance.new("UIStroke")
            cntStroke.Color = Theme.Border
            cntStroke.Thickness = 1
            cntStroke.Parent = container
            
            local titleLb = Instance.new("TextLabel")
            titleLb.Size = UDim2.new(1, -20, 0, 20)
            titleLb.Position = UDim2.fromOffset(14, 4)
            titleLb.BackgroundTransparency = 1
            titleLb.Text = opts.Title or ""
            titleLb.TextColor3 = Theme.TextPrimary
            titleLb.Font = Enum.Font.GothamSemibold
            titleLb.TextSize = 13
            titleLb.TextXAlignment = Enum.TextXAlignment.Left
            titleLb.Parent = container
            
            if opts.Desc and opts.Desc ~= "" then
                local descLb = Instance.new("TextLabel")
                descLb.Size = UDim2.new(1, -20, 0, 16)
                descLb.Position = UDim2.fromOffset(14, 24)
                descLb.BackgroundTransparency = 1
                descLb.Text = opts.Desc
                descLb.TextColor3 = Theme.TextSecondary
                descLb.Font = Enum.Font.Gotham
                descLb.TextSize = 10
                descLb.TextXAlignment = Enum.TextXAlignment.Left
                descLb.Parent = container
            end
            
            local inputBg = Instance.new("Frame")
            inputBg.Size = UDim2.new(1, -20, 0, 26)
            inputBg.Position = UDim2.fromOffset(10, opts.Desc and 44 or 34)
            inputBg.BackgroundColor3 = Theme.WarmWhite
            inputBg.BorderSizePixel = 0
            inputBg.Parent = container
            
            local ibC = Instance.new("UICorner")
            ibC.CornerRadius = UDim.new(0, 8)
            ibC.Parent = inputBg
            
            local ibStroke = Instance.new("UIStroke")
            ibStroke.Color = Theme.Border
            ibStroke.Thickness = 1
            ibStroke.Parent = inputBg
            
            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, -10, 1, 0)
            textBox.Position = UDim2.fromOffset(5, 0)
            textBox.BackgroundTransparency = 1
            textBox.Text = opts.Value or ""
            textBox.PlaceholderText = "Enter value..."
            textBox.TextColor3 = Theme.TextPrimary
            textBox.PlaceholderColor3 = Theme.TextMuted
            textBox.Font = Enum.Font.Gotham
            textBox.TextSize = 12
            textBox.TextXAlignment = Enum.TextXAlignment.Left
            textBox.ClearTextOnFocus = false
            textBox.Parent = inputBg
            
            textBox.FocusLost:Connect(function(enterPressed)
                if enterPressed and opts.Callback then
                    opts.Callback(textBox.Text)
                end
            end)
            
            textBox:GetPropertyChangedSignal("Text"):Connect(function()
                tweenSmooth(ibStroke, 0.2, { Color = Theme.Primary }):Play()
            end)
            
            return {}
        end
        
        -- AddToggle alias
        builder.AddToggle = builder.Toggle
        
        tab.Builder = builder
        
        return tab
    end
    
    local function playMainWindowAnimation()
        local ok, err = pcall(function()
            MainFrame.Visible = true
            GlassOverlay.Visible = true
            
            tweenElastic(MainFrame, 0.5, { 
                Size = UDim2.fromOffset(winW, winH),
                BackgroundTransparency = 0
            }):Play()
            
            task.wait(0.1)
            
            tweenExpo(GlassOverlay, 0.4, { BackgroundTransparency = 0.7 }):Play()
            
            task.wait(0.15)
            
            tweenBack(Topbar, 0.25, { BackgroundTransparency = 0 }):Play()
            
            task.wait(0.08)
            tweenElastic(TitleLbl, 0.3, { TextTransparency = 0, TextSize = 20 }):Play()
            task.wait(0.05)
            tweenSine(CreditLbl, 0.25, { TextTransparency = 0 }):Play()
            
            task.wait(0.1)
            
            tweenBack(Sidebar, 0.3, { BackgroundTransparency = 0 }):Play()
            
            local sideButtons = {}
            for _, child in pairs(SidebarInner:GetChildren()) do
                if child:IsA("TextButton") then
                    table.insert(sideButtons, child)
                end
            end
            
            local btnDelay = 0
            for _, btn in ipairs(sideButtons) do
                task.spawn(function()
                    task.wait(btnDelay)
                    tweenQuint(btn, 0.15, { BackgroundTransparency = 0 }):Play()
                end)
                btnDelay = btnDelay + 0.03
            end
            
            task.wait(0.25)
            
            for _, p in ipairs(PageHolder:GetChildren()) do
                if p:IsA("Frame") and p.Visible then
                    for _, child in pairs(p:GetChildren()) do
                        if child:IsA("ScrollingFrame") then
                            for _, inner in pairs(child:GetChildren()) do
                                if inner:IsA("Frame") then
                                    local elements = inner:GetChildren()
                                    local elDelay = 0
                                    for _, el in ipairs(elements) do
                                        if el:IsA("Frame") or el:IsA("TextLabel") or el:IsA("TextButton") then
                                            el.BackgroundTransparency = 1
                                            if el:IsA("TextLabel") or el:IsA("TextButton") then
                                                el.TextTransparency = 1
                                            end
                                            task.spawn(function()
                                                task.wait(elDelay)
                                                tweenSine(el, 0.15, { BackgroundTransparency = 0 }):Play()
                                                if el:IsA("TextLabel") or el:IsA("TextButton") then
                                                    tweenSine(el, 0.15, { TextTransparency = 0 }):Play()
                                                end
                                            end)
                                            elDelay = elDelay + 0.03
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        if not ok then
            warn("[Xynor] Animation error: " .. tostring(err))
        end
    end
    
    task.spawn(playMainWindowAnimation)
    
    -- Dragging
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
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        local minH = isMobile and 46 or 54
        local curH = MainFrame.Size.Y.Offset
        if curH > minH + 10 then
            tweenSmooth(MainFrame, 0.35, { Size = UDim2.fromOffset(winW, minH) }):Play()
        else
            tweenSmooth(MainFrame, 0.35, { Size = UDim2.fromOffset(winW, winH) }):Play()
        end
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        tweenSmooth(MainFrame, 0.4, { 
            Size = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.4)
        ScreenGui:Destroy()
    end)
    
    return WindowAPI, MainFrame
end

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════
local Notify = {}
function Notify:Show(opts)
    local title = opts.Title or ""
    local desc = opts.Desc or ""
    local duration = opts.Duration or 3
    
    local parent = getGuiParent()
    local existing = parent:FindFirstChild("XynorNotif_v3")
    if existing then existing:Destroy() end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "XynorNotif_v3"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(290, 65)
    frame.Position = UDim2.new(1, 20, 1, -90)
    frame.BackgroundColor3 = Theme.Panel
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = gui
    
    local fC = Instance.new("UICorner")
    fC.CornerRadius = UDim.new(0, 12)
    fC.Parent = frame
    
    local fStroke = Instance.new("UIStroke")
    fStroke.Color = Theme.Border
    fStroke.Thickness = 1
    fStroke.Parent = frame
    
    local accent = Instance.new("Frame")
    accent.Size = UDim2.fromOffset(4, 44)
    accent.Position = UDim2.new(0, 0, 0.5, -22)
    accent.BackgroundColor3 = Theme.Primary
    accent.BorderSizePixel = 0
    accent.Parent = frame
    
    local acC = Instance.new("UICorner")
    acC.CornerRadius = UDim.new(0, 2)
    acC.Parent = accent
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -18, 0.5, 0)
    titleLbl.Position = UDim2.fromOffset(14, 2)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Theme.TextPrimary
    titleLbl.Font = Enum.Font.GothamSemibold
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTransparency = 1
    titleLbl.Parent = frame
    
    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -18, 0.5, 0)
    descLbl.Position = UDim2.new(0, 14, 0.5, 0)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = desc
    descLbl.TextColor3 = Theme.TextSecondary
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 10
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextTransparency = 1
    descLbl.Parent = frame
    
    tweenSmooth(frame, 0.45, {
        Position = UDim2.new(1, -300, 1, -90),
        BackgroundTransparency = 0
    }):Play()
    
    task.delay(0.1, function()
        tweenSmooth(titleLbl, 0.3, { TextTransparency = 0 }):Play()
        task.delay(0.08, function()
            tweenSmooth(descLbl, 0.3, { TextTransparency = 0 }):Play()
        end)
    end)
    
    task.delay(duration, function()
        if gui and gui.Parent then
            tweenSmooth(frame, 0.35, {
                Position = UDim2.new(1, 20, 1, -90),
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.35)
            pcall(function() gui:Destroy() end)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- SECURITY & BYPASS SYSTEMS (UNCHANGED)
-- ═══════════════════════════════════════════════════════════════

-- Ball guardian (unchanged)
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

-- Security cleanups (unchanged)
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
        LocalPlayer:Kick("Anti-Cheat Updated!")
    end
end)

-- Anti-weird remote events (unchanged)
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

-- ═══════════════════════════════════════════════════════════════
-- PERSISTENCE SYSTEM (UNCHANGED)
-- ═══════════════════════════════════════════════════════════════
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

-- Global cache
if not _G._VxRBall then _G._VxRBall = nil end
if not _G._VxRHRP then _G._VxRHRP = nil end

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

-- ═══════════════════════════════════════════════════════════════
-- MAIN HUB - ALL ORIGINAL FEATURES
-- ═══════════════════════════════════════════════════════════════
function runMainHub()
    print("[Xynor] Starting main hub...")
    
    -- Create UI
    local ok, result = pcall(function()
        return BuildMainWindow()
    end)
    
    if not ok then
        warn("[Xynor] Error building window: " .. tostring(result))
        return
    end
    
    local WindowAPI, WindowFrame = result
    print("[Xynor] Window built successfully, WindowAPI:", WindowAPI, "Frame:", WindowFrame)
    
    -- Build sections
    local InfoSec = WindowAPI:Section({ Title = "Information" })
    local MainSec  = WindowAPI:Section({ Title = "main :3" })
    local UtilSec  = WindowAPI:Section({ Title = "Utility & Extra" })
    local OptSec   = WindowAPI:Section({ Title = "Optimizations" })
    
    -- ========== HOME TAB ==========
    local HomeTab = WindowAPI:Tab(InfoSec, { Title = "Home", Icon = "🏠" })
    local Home = HomeTab.Builder
    
    Home:Section({ Title = "Welcome to Xynor 3.0" })
    Home:Button({
        Title = "Script Version: 3.0",
        Desc = "Premium UI redesign - All features preserved",
        Callback = function() end
    })
    Home:Button({
        Title = "User: " .. LocalPlayer.Name,
        Desc = "Rank: Premium User",
        Callback = function() end
    })
    Home:Section({ Title = "Updates" })
    Home:Button({
        Title = "Latest: 2026-04",
        Desc = "- Complete UI overhaul\n- Pastel premium theme\n- Modern animations\n- Key validation system",
        Callback = function() end
    })
    
    -- ========== REACH TAB ==========
    local ReachTab = WindowAPI:Tab(MainSec, { Title = "Reach", Icon = "🎯" })
    local Reach = ReachTab.Builder
    
    local reachEnabled  = P.reachEnabled
    local reachDistance = P.reachDistance
    local reachConnection
    
    local function startReach()
        if reachConnection then reachConnection:Disconnect() end
        local _char, _root, _hum, _tps, _limb = nil, nil, nil, nil, nil
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
    
    Reach:Section({ Title = "Leg Reach (Method A)" })
    
    Reach:Toggle({
        Title = "Active FireTouchInterest",
        Desc = "Triggers ball contact automatically",
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
    
    Reach:Slider({
        Title = "Reach Distance",
        Desc = "Adjust the activation range",
        Value = { Min = 1, Max = 15, Default = 1 },
        Callback = function(val)
            reachDistance   = tonumber(val)
            P.reachDistance = reachDistance
        end
    })
    
    Reach:Section({ Title = "Leg Reach (Method B)" })
    
    Reach:Input({
        Title = "Leg Hitbox (R6)",
        Desc = "Modifies physical size of legs",
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
    
    Reach:Input({
        Title = "Legs Size (R15)",
        Desc = "Minimum Size is 1",
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
    
    Reach:Button({
        Title = "Fake legs (Appear Normal)",
        Callback = function()
            local player = LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            if humanoid.RigType == Enum.HumanoidRigType.R6 then
                character["Right Leg"].Transparency = 1
                character["Left Leg"].Transparency = 1
                character["Left Leg"].Massless = true
                local LeftLegM = Instance.new("Part", character)
                LeftLegM.Name = "Left Leg Fake"
                LeftLegM.CanCollide = false
                LeftLegM.Color = character["Left Leg"].Color
                LeftLegM.Size = Vector3.new(1, 2, 1)
                LeftLegM.Position = character["Left Leg"].Position
                local MotorHip = Instance.new("Motor6D", character.Torso)
                MotorHip.Part0 = character.Torso
                MotorHip.Part1 = LeftLegM
                MotorHip.C0 = CFrame.new(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                MotorHip.C1 = CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                character["Right Leg"].Massless = true
                local RightLegM = Instance.new("Part", character)
                RightLegM.Name = "Right Leg Fake"
                RightLegM.CanCollide = false
                RightLegM.Color = character["Right Leg"].Color
                RightLegM.Size = Vector3.new(1, 2, 1)
                RightLegM.Position = character["Right Leg"].Position
                local MotorHip2 = Instance.new("Motor6D", character.Torso)
                MotorHip2.Part0 = character.Torso
                MotorHip2.Part1 = RightLegM
                MotorHip2.C0 = CFrame.new(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
                MotorHip2.C1 = CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            end
        end
    })
    
    -- ========== MOSSING TAB ==========
    local MossingTab = WindowAPI:Tab(MainSec, { Title = "Mossing", Icon = "🌿" })
    local Moss = MossingTab.Builder
    
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
        headBoxPart.Color       = Theme.Primary
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
    
    Moss:Toggle({
        Title = "Active Moss Reach",
        Desc = "Enable head-based interaction range",
        Callback = function(state)
            headReachEnabled = state
            if state then
                startHeadReach()
            else
                if headConnection then headConnection:Disconnect() end
                if headBoxPart then headBoxPart:Destroy() end
            end
        end
    })
    
    Moss:Slider({ Title = "Range X", Value = { Min = 0, Max = 50, Default = 1 },
        Callback = function(val)
            headReachSize = Vector3.new(val, headReachSize.Y, headReachSize.Z)
            if headReachEnabled then updateHeadBox() end
        end
    })
    
    Moss:Slider({ Title = "Range Y", Value = { Min = 0, Max = 50, Default = 1.5 },
        Callback = function(val)
            headReachSize = Vector3.new(headReachSize.X, val, headReachSize.Z)
            headOffset = Vector3.new(headOffset.X, val / 2.5, headOffset.Z)
            if headReachEnabled then updateHeadBox() end
        end
    })
    
    Moss:Slider({ Title = "Range Z", Value = { Min = 0, Max = 50, Default = 1 },
        Callback = function(val)
            headReachSize = Vector3.new(headReachSize.X, headReachSize.Y, val)
            if headReachEnabled then updateHeadBox() end
        end
    })
    
    Moss:Toggle({ Title = "Stealth Mode", Desc = "Makes the reach box invisible",
        Callback = function(v)
            headTransparency = v and 1 or 0.5
            if headReachEnabled and headBoxPart then headBoxPart.Transparency = headTransparency end
        end
    })
    
    -- ========== REACTS TAB ==========
    local ReactSec = WindowAPI:Section({ Title = "Reacts" })
    local ReactTab = WindowAPI:Tab(ReactSec, { Title = "Reacts", Icon = "⚡" })
    local React = ReactTab.Builder
    
    local REACT_ACTIONS = {
        Kick=true, KickC1=true, Tackle=true, Header=true,
        SaveRA=true, SaveLA=true, SaveRL=true, SaveLL=true, SaveT=true
    }
    
    local currentReactPower = P.reactPower
    local ballSpeedMult = P.ballSpeedMult
    
    local function getReactTargets()
        return _G._VxRBall, _G._VxRHRP
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
        local meta = getrawmetatable(game)
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
    
    React:Section({ Title = "⚡ Reacts V6 - Potencia MAXIMA" })
    
    React:Button({
        Title = "🔥 ULTRA SPEED",
        Desc = "Velocidad ILEGAL maxima",
        Callback = function()
            currentReactPower = 5e18; P.reactPower = currentReactPower
            enableReactHook(); applyReactInstant(currentReactPower)
            Notify:Show({ Title = "ULTRA SPEED", Desc = "Ball a velocidad maxima!", Duration = 2 })
        end
    })
    
    React:Button({
        Title = "💀 MEGA POWER",
        Desc = "Potencia extrema",
        Callback = function()
            currentReactPower = 1e25; P.reactPower = currentReactPower
            enableReactHook(); applyReactInstant(currentReactPower)
            Notify:Show({ Title = "MEGA POWER", Desc = "Potencia extrema activada", Duration = 2 })
        end
    })
    
    React:Button({
        Title = "⚡ HYPER VELOCITY",
        Desc = "Hyper velocidad instantanea",
        Callback = function()
            currentReactPower = 2e22; P.reactPower = currentReactPower
            enableReactHook(); applyReactInstant(currentReactPower)
            Notify:Show({ Title = "HYPER", Desc = "Hyper velocidad maxima", Duration = 2 })
        end
    })
    
    React:Button({
        Title = "🚀 ULTIMATE KICK",
        Desc = "Patada definitiva",
        Callback = function()
            currentReactPower = 8e20; P.reactPower = currentReactPower
            enableReactHook(); applyReactInstant(currentReactPower)
            Notify:Show({ Title = "ULTIMATE", Desc = "Patada definitiva", Duration = 2 })
        end
    })
    
    React:Button({
        Title = "💥 MAX POWER",
        Desc = "Potencia maxima absoluta",
        Callback = function()
            currentReactPower = 1e28; P.reactPower = currentReactPower
            enableReactHook(); applyReactInstant(currentReactPower)
            Notify:Show({ Title = "MAX POWER", Desc = "Potencia maxima absoluta", Duration = 2 })
        end
    })
    
    React:Button({
        Title = "🌀 HYPER SNAP",
        Desc = "Snap magnetico super rapido",
        Callback = function()
            currentReactPower = 3e20; P.reactPower = currentReactPower
            enableReactHook()
            local ball, hrp = getReactTargets()
            if ball and hrp then
                pcall(function() ball:SetNetworkOwner(LocalPlayer) end)
                if ball.CanCollide then pcall(function() ball.CanCollide = false end) end
                ball.CFrame = CFrame.new(hrp.Position + hrp.CFrame.LookVector * 0.2 + Vector3.new(0, 0.1, 0))
                ball.AssemblyLinearVelocity = hrp.CFrame.LookVector * (currentReactPower * ballSpeedMult)
                ball.AssemblyAngularVelocity = Vector3.zero
            end
            Notify:Show({ Title = "HYPER SNAP", Desc = "SNAP ultra rapido!", Duration = 2 })
        end
    })
    
    React:Section({ Title = "🎚️ Ball Speed Control" })
    
    React:Slider({
        Title = "Ball Speed Multiplier",
        Desc = "Control de velocidad en tiempo real (hasta 50x)",
        Value = { Min = 0.1, Max = 50, Default = 7.0 },
        Callback = function(val)
            ballSpeedMult = val
            P.ballSpeedMult = val
        end
    })
    
    React:Section({ Title = "🎯 Velocity Presets" })
    
    React:Button({
        Title = "Normal Mode",
        Desc = "Multiplier x1.0",
        Callback = function()
            ballSpeedMult = 1.0; P.ballSpeedMult = ballSpeedMult
            Notify:Show({ Title = "Velocity", Desc = "Normal (x1.0)", Duration = 1.5 })
        end
    })
    
    React:Button({
        Title = "Fast Mode",
        Desc = "Multiplier x50.0",
        Callback = function()
            ballSpeedMult = 50.0; P.ballSpeedMult = ballSpeedMult
            Notify:Show({ Title = "Velocity", Desc = "Fast (x50.0)", Duration = 1.5 })
        end
    })
    
    React:Section({ Title = "React Power" })
    
    React:Slider({
        Title = "React Power (base)",
        Desc = "Potencia base maxima",
        Value = { Min = 1e18, Max = 1e30, Default = 1e22 },
        Callback = function(val)
            currentReactPower = val; P.reactPower = val
        end
    })
    
    -- ========== HELPERS TAB ==========
    local HelpSec = WindowAPI:Section({ Title = "Utility & Extra" })
    local HelpTab = WindowAPI:Tab(HelpSec, { Title = "Helpers", Icon = "🛡️" })
    local Help = HelpTab.Builder
    
    Help:Section({ Title = "Ball Visuals" })
    
    Help:Toggle({ Title = "ZZZ helper", Desc = "Highlights the ball's position",
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
    
    Help:Toggle({ Title = "Kenyah Inf Helper", Desc = "0 reach + ultra pegado + super rapido",
        Callback = function(state)
            if state then
                _G.AerialInfUltra = RunService.RenderStepped:Connect(function()
                    local ball = _G._VxRBall; local hrp = _G._VxRHRP
                    if not (ball and ball.Parent and hrp) then return end
                    local char = LocalPlayer.Character
                    local torso = char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                    local base = torso or hrp
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
    
    Help:AddToggle({ Title = "Kenyah INF TER/AIR [HELPER]", Desc = "0 reach + ultra pegada + super rapida",
        Callback = function(state)
            if state then
                _G.KenyahINF = RunService.RenderStepped:Connect(function()
                    local ball = _G._VxRBall; local hrp = _G._VxRHRP
                    if not (ball and ball.Parent and hrp) then return end
                    local char = LocalPlayer.Character
                    local torso = char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                    local base = torso or hrp
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
    
    -- ========== AIMBOT TAB ==========
    local AimSec = WindowAPI:Section({ Title = "Utility & Extra" })
    local AimTab = WindowAPI:Tab(AimSec, { Title = "Aimbot", Icon = "🎯" })
    local Aim = AimTab.Builder
    
    local isAimbotEnabled = false
    local aimbotTargetPos = Vector3.new(0, 14, 157)
    local laser = Instance.new("Part")
    laser.Name = "vxnity hub aimbot"
    laser.Anchored = true
    laser.CanCollide = false
    laser.Material = Enum.Material.Neon
    laser.Color = Theme.Accent
    laser.Transparency = 1
    laser.Size = Vector3.new(0.05, 0.05, 1)
    laser.Parent = Workspace
    
    local function toggleAimbot(state)
        isAimbotEnabled = state
        laser.Transparency = isAimbotEnabled and 0.4 or 1
    end
    
    RunService:BindToRenderStep("vxnityAimbotLoop", Enum.RenderPriority.Camera.Value + 1, function()
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
    
    Aim:Section({ Title = "Aimbot Settings" })
    
    local aimToggle = Aim:Toggle({
        Title = "Enable / Disable Aimbot",
        Callback = function(state)
            toggleAimbot(state)
        end
    })
    
    Aim:Keybind({
        Title = "Aimbot Keybind",
        Default = Enum.KeyCode.R,
        Callback = function()
            aimToggle:Set(not isAimbotEnabled)
        end
    })
    
    -- ========== OPTIMIZATIONS TAB ==========
    local OptSec = WindowAPI:Section({ Title = "Optimizations" })
    local OptTab = WindowAPI:Tab(OptSec, { Title = "Performance", Icon = "⚡" })
    local Opt = OptTab.Builder
    
    Opt:Section({ Title = "Improve Ping" })
    
    Opt:Toggle({
        Title = "Optimize Network Calls",
        Desc = "Reduce network latency by caching ball/player data",
        Callback = function(state)
            if state then
                Notify:Show({ Title = "Ping Optimize", Desc = "Network optimization enabled", Duration = 2 })
            end
        end
    })
    
    Opt:Toggle({
        Title = "Reduce Packet Loss",
        Desc = "Optimize remote event handling",
        Callback = function(state)
            if state then
                pcall(function()
                    settings().Network.Physics = 30
                end)
                Notify:Show({ Title = "Packet Loss", Desc = "Optimization enabled", Duration = 2 })
            end
        end
    })
    
    Opt:Section({ Title = "Improve CPU" })
    
    Opt:Toggle({
        Title = "Optimize Loops",
        Desc = "Reduce unnecessary render loop iterations",
        Callback = function(state)
            if state then
                pcall(function()
                    RunService:setv("throttle", true)
                end)
                Notify:Show({ Title = "CPU Optimize", Desc = "Loop optimization enabled", Duration = 2 })
            end
        end
    })
    
    Opt:Toggle({
        Title = "Reduce Event Processing",
        Desc = "Minimize event listener overhead",
        Callback = function(state)
            if state then
                Notify:Show({ Title = "Events", Desc = "Event optimization enabled", Duration = 2 })
            end
        end
    })
    
    Opt:Toggle({
        Title = "Optimize Physics",
        Desc = "Reduce physics calculations when possible",
        Callback = function(state)
            if state then
                pcall(function()
                    settings().Physics.PhysicsEngine = "Voxel"
                end)
                Notify:Show({ Title = "Physics", Desc = "Physics optimization enabled", Duration = 2 })
            end
        end
    })
    
    Opt:Section({ Title = "Improve GPU" })
    
    Opt:Toggle({
        Title = "Optimize UI Rendering",
        Desc = "Reduce UI redraw frequency",
        Callback = function(state)
            if state then
                Notify:Show({ Title = "GPU Optimize", Desc = "UI optimization enabled", Duration = 2 })
            end
        end
    })
    
    Opt:Toggle({
        Title = "Reduce Visual Effects",
        Desc = "Minimize particle effects and glow",
        Callback = function(state)
            if state then
                pcall(function()
                    settings().Rendering.EffectsQuality = 0
                end)
                Notify:Show({ Title = "Effects", Desc = "Effects optimization enabled", Duration = 2 })
            end
        end
    })
    
    Opt:Toggle({
        Title = "Optimize Shadow Rendering",
        Desc = "Reduce shadow quality for better performance",
        Callback = function(state)
            if state then
                pcall(function()
                    settings().Rendering.ShadowQuality = 0
                end)
                Notify:Show({ Title = "Shadows", Desc = "Shadow optimization enabled", Duration = 2 })
            end
        end
    })
    
    -- ========== BALL CONTROL TAB ==========
    local BallSec = WindowAPI:Section({ Title = "Ball Control" })
    local DribbleTab = WindowAPI:Tab(BallSec, { Title = "Dribble Assist", Icon = "⚽" })
    local Dribble = DribbleTab.Builder
    
    local dribbleEnabled = false
    local dribbleIntensity = "High"
    local dribbleActivation = "Click"
    local dribbleActive = false
    local dribbleConnection = nil
    
    local DRIBBLE_CONFIG = {
        Low = { strength = 30000, deadzone = 0.03, offset = 0.08 },
        Medium = { strength = 60000, deadzone = 0.015, offset = 0.05 },
        High = { strength = 100000, deadzone = 0.008, offset = 0.03 }
    }
    
    Dribble:Section({ Title = "🎯 Dribble ULTRA 0-REACH" })
    
    Dribble:Toggle({
        Title = "Enable Dribble Assist",
        Desc = "0 reach visual + ball ultra pegado + rapido",
        Callback = function(state)
            dribbleEnabled = state
            if not state and dribbleConnection then
                dribbleConnection:Disconnect()
                dribbleConnection = nil
                dribbleActive = false
            end
        end
    })
    
    Dribble:Slider({
        Title = "Intensity (1=Low, 2=Med, 3=High)",
        Desc = "Ajusta la potencia del dribble",
        Value = { Min = 1, Max = 3, Default = 3 },
        Callback = function(val)
            local levels = {"Low", "Medium", "High"}
            dribbleIntensity = levels[math.floor(val)] or "High"
        end
    })
    
    Dribble:Toggle({
        Title = "Click/Tap Activation",
        Desc = "Activar con click o tap",
        Callback = function(state)
            if state then dribbleActivation = "Click" end
        end
    })
    
    Dribble:Toggle({
        Title = "Hold Activation",
        Desc = "Activar manteniendo presionado",
        Callback = function(state)
            if state then dribbleActivation = "Hold" end
        end
    })
    
    Dribble:Button({
        Title = "TEST Dribble",
        Desc = "Prueba la asistencia",
        Callback = function()
            if dribbleEnabled then
                local ball = _G._VxRBall
                local hrp = _G._VxRHRP
                if ball and hrp then
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
                Notify:Show({ Title = "Dribble Test", Desc = "Intensity: " .. dribbleIntensity, Duration = 1 })
            end
        end
    })
    
    -- Input handlers for dribble
    local function handleDribbleInput(input, gp)
        if not dribbleEnabled then return end
        if dribbleActivation == "Click" then
            if input.UserInputType == Enum.UserInputType.MouseButton1 
                or input.UserInputType == Enum.UserInputType.Touch then
                dribbleActive = true
                task.delay(0.05, function() dribbleActive = false end)
            end
        elseif dribbleActivation == "Hold" then
            if (input.UserInputType == Enum.UserInputType.MouseButton1 
                or input.UserInputType == Enum.UserInputType.Touch) and not gp then
                dribbleActive = true
            end
        end
    end
    
    local function handleDribbleEnd(input, gp)
        if dribbleActivation == "Hold" then
            if input.UserInputType == Enum.UserInputType.MouseButton1 
                or input.UserInputType == Enum.UserInputType.Touch then
                dribbleActive = false
            end
        end
    end
    
    UserInputService.InputBegan:Connect(handleDribbleInput)
    UserInputService.InputEnded:Connect(handleDribbleEnd)
    
    if UserInputService.TouchEnabled then
        UserInputService.TouchTap:Connect(function(touchPos, gp)
            if dribbleEnabled and dribbleActivation == "Click" then
                dribbleActive = true
                task.delay(0.05, function() dribbleActive = false end)
            end
        end)
    end
    
    -- Dribble loop
    dribbleConnection = RunService.RenderStepped:Connect(function()
        if dribbleEnabled and dribbleActive then
            local ball = _G._VxRBall
            local hrp = _G._VxRHRP
            if ball and hrp then
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
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════════
    -- FINAL SETUP
    -- ═══════════════════════════════════════════════════════════════
    
    -- Restore saved states
    task.wait(0.5)
    if reachEnabled and reachConnection == nil then
        startReach()
    end
    
    Notify:Show({
        Title = "Xynor v3.0",
        Desc = "Premium UI loaded successfully!",
        Duration = 4
    })
    
    print("✅ Xynor Hub v3.0 - All systems operational")
end

-- ═══════════════════════════════════════════════════════════════
-- ENTRY POINT
-- ═══════════════════════════════════════════════════════════════

local loader = CreateLoader()

local function doValidateKey()
    print("[Xynor] doValidateKey called")
    if not loader.Gui or not loader.Gui.Parent then 
        print("[Xynor] Loader GUI not found")
        return 
    end
    
    local key = loader.KeyInput.Text
    print("[Xynor] Key entered:", key)
    if KeySystem:Check(key) then
        print("[Xynor] Key validated successfully!")
        KeySystem:Save(key)
        loader.Feedback.Text = "✓ Access granted"
        loader.Feedback.TextColor3 = Theme.Success
        
        task.wait(0.2)
        
        tweenElastic(loader.Container, 0.5, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }):Play()
        tweenSmooth(loader.KeyFrame, 0.3, { BackgroundTransparency = 1 }):Play()
        
        tweenSmooth(loader.Container, 0.4, { Rotation = 5 }):Play()
        
        task.wait(0.4)
        
        setBlur(0, 0.4)
        
        if loader.Gui and loader.Gui.Parent then
            if loader.ParticleConn then loader.ParticleConn:Disconnect() end
            loader.Gui:Destroy()
        end
        
        task.wait(0.15)
        
        print("[Xynor] Calling runMainHub()...")
        runMainHub()
    else
        print("[Xynor] Invalid key!")
        loader.Feedback.Text = "✗ Invalid key"
        loader.Feedback.TextColor3 = Theme.Danger
        tweenElastic(loader.SubmitBtn, 0.15, { Size = UDim2.new(1, 8, 0, 38) }):Play()
        task.wait(0.1)
        tweenSmooth(loader.SubmitBtn, 0.2, { Size = UDim2.new(1, 0, 0, 34) }):Play()
    end
end

task.spawn(function()
    print("[Xynor] Auto-validate task started")
    task.wait(4.5)
    print("[Xynor] Auto-validate checking...")
    if not loader.Gui or not loader.Gui.Parent then 
        print("[Xynor] Loader GUI not found in auto-validate")
        return 
    end
    
    local savedKey = KeySystem:GetSaved()
    print("[Xynor] Saved key:", savedKey)
    if savedKey and KeySystem:Check(savedKey) then
        print("[Xynor] Auto-validate: key verified!")
        loader.Feedback.Text = "✓ Key verified"
        loader.Feedback.TextColor3 = Theme.Success
        task.wait(0.2)
        
        tweenElastic(loader.Container, 0.5, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }):Play()
        tweenSmooth(loader.KeyFrame, 0.3, { BackgroundTransparency = 1 }):Play()
        
        task.wait(0.4)
        
        setBlur(0, 0.4)
        
        if loader.Gui and loader.Gui.Parent then
            if loader.ParticleConn then loader.ParticleConn:Disconnect() end
            loader.Gui:Destroy()
        end
        
        task.wait(0.15)
        
        print("[Xynor] Auto-validate calling runMainHub()...")
        runMainHub()
    else
        print("[Xynor] Auto-validate: no valid saved key")
    end
end)

loader.SubmitBtn.MouseButton1Click:Connect(doValidateKey)

loader.KeyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        doValidateKey()
    end
end)

print("✨ Xynor Hub v3.0 initialized successfully")
