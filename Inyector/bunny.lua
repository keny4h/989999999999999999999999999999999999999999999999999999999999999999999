do
    local ok, src = pcall(function() return readfile and readfile("neo_core.lua") end)
    if ok and type(src) == "string" and #src > 0 and type(loadstring) == "function" then
        pcall(function() loadstring(src)() end)
    end
end

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

do
    local p = playerGui:FindFirstChild("KyroDev") or playerGui:FindFirstChild("KyroDevNeo")
    if p then p:Destroy() end
end

local C_HOT   = Color3.fromRGB(255, 0, 255)  -- Magenta primario
local C_DARK  = Color3.fromRGB(20, 20, 20)   -- Gris oscuro cyber
local C_DIM   = Color3.fromRGB(40, 40, 40)   -- Gris medio
local C_BG    = Color3.fromRGB(0, 0, 0)      -- Fondo negro premium
local C_PANEL = Color3.fromRGB(10, 10, 10)   -- Panel casi negro
local C_CARD  = Color3.fromRGB(15, 15, 15)   -- Card gris claro
local C_WHITE = Color3.new(1, 1, 1)
local C_TEXT  = Color3.fromRGB(200, 200, 255) -- Texto azul claro
local C_GLOW  = Color3.fromRGB(0, 255, 255)  -- Cyan para acentos

local fps     = 60
local frameMs = 16
local cpuMs   = 16

local function new(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do
        if k == "Parent" then o.Parent = v else o[k] = v end
    end
    return o
end

local function corner(o, r)
    new("UICorner", { Parent = o, CornerRadius = UDim.new(0, r) })
end

local function rgrad(o, rot)
    new("UIGradient", {
        Parent   = o,
        Rotation = rot or 90,
        Color    = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 0, 255)),    -- Magenta
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 0, 128)),    -- Púrpura
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(0, 255, 255)),    -- Cyan
        }),
    })
end

local function hvr(btn)
    btn.AutoButtonColor = false
    local orig = btn.BackgroundColor3
    local origSize = btn.Size
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {
            BackgroundColor3 = C_GLOW,
            Size = UDim2.new(origSize.X.Scale, origSize.X.Offset * 1.05, origSize.Y.Scale, origSize.Y.Offset * 1.05)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {
            BackgroundColor3 = orig,
            Size = origSize
        }):Play()
    end)
end

local function clickFeedback(btn)
    local orig = btn.BackgroundColor3
    TweenService:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Sine), { BackgroundColor3 = C_WHITE }):Play()
    task.delay(0.08, function()
        TweenService:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Sine), { BackgroundColor3 = orig }):Play()
    end)
    -- Ripple effect
    local ripple = new("Frame", {
        Parent = btn,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = C_GLOW,
        BackgroundTransparency = 0.5,
        ZIndex = btn.ZIndex + 1,
    })
    corner(ripple, 50)
    TweenService:Create(ripple, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
        Size = UDim2.new(1, 10, 1, 10),
        BackgroundTransparency = 1,
    }):Play()
    task.delay(0.3, function() ripple:Destroy() end)
end

local function mkDrag(frame)
    local drag, inp, sPos, sMouse = false, nil, nil, nil
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            drag   = true
            sPos   = frame.Position
            sMouse = i.Position
            inp    = i
        end
    end)
    frame.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then
            inp = i
        end
    end)
    frame.InputEnded:Connect(function(i)
        if i == inp then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i == inp then
            local d = i.Position - sMouse
            frame.Position = UDim2.new(
                sPos.X.Scale, sPos.X.Offset + d.X,
                sPos.Y.Scale, sPos.Y.Offset + d.Y
            )
        end
    end)
end

local function notify(txt)
    local n = new("Frame", {
        Parent           = playerGui,
        Size             = UDim2.fromOffset(310, 40),
        Position         = UDim2.new(0.5, -155, 1, -88),
        BackgroundColor3 = C_PANEL,
        ZIndex           = 30,
    })
    corner(n, 8)
    rgrad(n, 0)
    new("UIStroke", { Parent = n, Color = C_HOT, Thickness = 1.2, Transparency = 0.1 })
    local lbl = new("TextLabel", {
        Parent              = n,
        Size                = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text                = txt,
        Font                = Enum.Font.GothamBold,
        TextSize            = 12,
        TextColor3          = C_WHITE,
        ZIndex              = 31,
    })
    TweenService:Create(n, TweenInfo.new(0.18), { Position = UDim2.new(0.5, -155, 1, -108) }):Play()
    task.delay(2.8, function()
        TweenService:Create(n,   TweenInfo.new(0.18), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(lbl, TweenInfo.new(0.18), { TextTransparency = 1 }):Play()
        task.delay(0.2, function() n:Destroy() end)
    end)
end

local gui = new("ScreenGui", {
    Parent         = playerGui,
    Name           = "KyroDev",
    IgnoreGuiInset = true,
    ResetOnSpawn   = false,
})

local overlay = new("Frame", {
    Parent              = gui,
    Size                = UDim2.fromScale(1, 1),
    BackgroundColor3    = Color3.new(0, 0, 0),
    BackgroundTransparency = 1,
    Visible             = false,
})

local dock = new("Frame", {
    Parent           = gui,
    Size             = UDim2.fromOffset(40, 40),
    Position         = UDim2.new(1, -52, 0, 78),
    BackgroundColor3 = C_CARD,
    Visible          = true,
})
dock.Active = true
corner(dock, 20)
rgrad(dock)
new("UIStroke", { Parent = dock, Color = C_HOT, Thickness = 1.2, Transparency = 0.1 })
local dockBtn = new("TextButton", {
    Parent              = dock,
    Size                = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text                = "K",
    Font                = Enum.Font.GothamBold,
    TextSize            = 16,
    TextColor3          = C_WHITE,
})
mkDrag(dock)

local win = new("Frame", {
    Parent           = gui,
    Size             = UDim2.fromOffset(280, 320),
    Position         = UDim2.new(0.5, -140, 0.5, -160),
    BackgroundColor3 = C_BG,
    Visible          = false,
})
corner(win, 13)
new("UIGradient", {
    Parent   = win,
    Rotation = 130,
    Color    = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(10,  2,  2)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(16,  4,  4)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(23,  8,  8)),
    }),
})
local wStroke = new("UIStroke", { Parent = win, Color = C_HOT, Thickness = 1.6, Transparency = 0.08 })
win.Active     = true
win.Selectable = true
mkDrag(win)

task.spawn(function()
    local t = 0
    while win.Parent do
        t = t + 0.35
        local s = 0.85 + math.abs(math.sin(math.rad(t))) * 0.15
        wStroke.Color = Color3.fromRGB(255, math.floor(20 + s * 35), math.floor(20 + s * 35))
        task.wait(0.05)
    end
end)

local hdr = new("Frame", { Parent = win, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = C_DARK })
corner(hdr, 13)
rgrad(hdr, 0)
new("UIStroke", { Parent = hdr, Color = C_HOT, Thickness = 1, Transparency = 0.25 })
local hdrGlow = new("UIGlow", { Parent = hdr, Color = C_HOT, Transparency = 0.8 })
task.spawn(function()
    while hdr.Parent do
        TweenService:Create(hdrGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine), { Transparency = 0.5 }):Play()
        task.wait(1.5)
        TweenService:Create(hdrGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine), { Transparency = 0.8 }):Play()
        task.wait(1.5)
    end
end)

new("TextLabel", {
    Parent              = hdr,
    Size                = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text                = "NeoInjector | Advanced FFlag Tool",
    Font                = Enum.Font.GothamBold,
    TextSize            = 12,
    TextColor3          = C_WHITE,
})

local closeBtn = new("TextButton", {
    Parent           = hdr,
    Size             = UDim2.fromOffset(19, 19),
    Position         = UDim2.new(1, -24, 0, 8),
    BackgroundColor3 = C_DIM,
    Text             = "X",
    Font             = Enum.Font.GothamBold,
    TextSize         = 10,
    TextColor3       = C_WHITE,
})
corner(closeBtn, 5)
hvr(closeBtn)

local minBtn = new("TextButton", {
    Parent           = hdr,
    Size             = UDim2.fromOffset(19, 19),
    Position         = UDim2.new(1, -47, 0, 8),
    BackgroundColor3 = C_DIM,
    Text             = "-",
    Font             = Enum.Font.GothamBold,
    TextSize         = 10,
    TextColor3       = C_WHITE,
})
corner(minBtn, 5)
hvr(minBtn)

local body = new("Frame", { Parent = win, Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(1, 0, 1, -36), BackgroundTransparency = 1 })

local side = new("Frame", { Parent = body, Size = UDim2.new(0, 50, 1, 0), BackgroundColor3 = C_PANEL })
corner(side, 10)
new("UIGradient", {
    Parent   = side, Rotation = 90,
    Color    = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 4, 4)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 3, 3)),
    }),
})

local cnt = new("Frame", { Parent = body, Position = UDim2.new(0, 56, 0, 0), Size = UDim2.new(1, -62, 1, 0), BackgroundTransparency = 1 })

local function mkTab(label, icon, y)
    local b = new("TextButton", {
        Parent           = side,
        Size             = UDim2.new(1, -8, 0, 25),
        Position         = UDim2.new(0, 4, 0, y),
        BackgroundColor3 = C_DIM,
        Text             = icon .. " " .. label,
        Font             = Enum.Font.GothamBold,
        TextSize         = 10,
        TextColor3       = C_WHITE,
    })
    corner(b, 6)
    hvr(b)
    return b
end

local tabF = mkTab("Flags", "⚙", 5)
local tabC = mkTab("Config", "🔧", 34)
local tabI = mkTab("Info", "ℹ", 63)

local pgF = new("Frame", { Parent = cnt, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })
local pgC = new("Frame", { Parent = cnt, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false })
local pgI = new("Frame", { Parent = cnt, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false })

-- Headers con iconos para secciones
local hdrF = new("TextLabel", {
    Parent = pgF,
    Position = UDim2.new(0, 2, 0, 0),
    Size = UDim2.new(1, -4, 0, 20),
    BackgroundTransparency = 1,
    Text = "⚙ FFlags Injection",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = C_HOT,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local hdrC = new("TextLabel", {
    Parent = pgC,
    Position = UDim2.new(0, 2, 0, 0),
    Size = UDim2.new(1, -4, 0, 20),
    BackgroundTransparency = 1,
    Text = "🔧 Configuration",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = C_HOT,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local hdrI = new("TextLabel", {
    Parent = pgI,
    Position = UDim2.new(0, 2, 0, 0),
    Size = UDim2.new(1, -4, 0, 20),
    BackgroundTransparency = 1,
    Text = "ℹ Information",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = C_HOT,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local currentPage = pgF
local function switchPage(newPage)
    if currentPage == newPage then return end
    TweenService:Create(currentPage, TweenInfo.new(0.15, Enum.EasingStyle.Sine), { BackgroundTransparency = 1 }):Play()
    for _, child in ipairs(currentPage:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextBox") or child:IsA("Frame") then
            TweenService:Create(child, TweenInfo.new(0.15), { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
        end
    end
    task.delay(0.15, function()
        currentPage.Visible = false
        newPage.Visible = true
        TweenService:Create(newPage, TweenInfo.new(0.15, Enum.EasingStyle.Sine), { BackgroundTransparency = 0 }):Play()
        for _, child in ipairs(newPage:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextBox") or child:IsA("Frame") then
                TweenService:Create(child, TweenInfo.new(0.15), { TextTransparency = 0, BackgroundTransparency = child.BackgroundTransparency }):Play()
            end
        end
        currentPage = newPage
    end)
end
tabF.MouseButton1Click:Connect(function() clickFeedback(tabF) switchPage(pgF) end)
tabC.MouseButton1Click:Connect(function() clickFeedback(tabC) switchPage(pgC) end)
tabI.MouseButton1Click:Connect(function() clickFeedback(tabI) switchPage(pgI) end)

local ffBox = new("TextBox", {
    Parent              = pgF,
    Position            = UDim2.new(0, 2, 0, 25),
    Size                = UDim2.new(1, -4, 1, -132),
    MultiLine           = true,
    ClearTextOnFocus    = false,
    TextWrapped         = true,
    Font                = Enum.Font.Gotham,
    TextSize            = 10,
    BackgroundColor3    = C_CARD,
    TextColor3          = C_WHITE,
    PlaceholderText     = "Pega tu JSON aqui...",
    TextXAlignment      = Enum.TextXAlignment.Left,
    TextYAlignment      = Enum.TextYAlignment.Top,
})
corner(ffBox, 7)
new("UIStroke", { Parent = ffBox, Color = C_DARK, Thickness = 1, Transparency = 0.2 })

local szLbl = new("TextLabel", {
    Parent              = pgF,
    Position            = UDim2.new(0, 2, 1, -83),
    Size                = UDim2.new(1, -4, 0, 12),
    BackgroundTransparency = 1,
    Font                = Enum.Font.GothamBold,
    TextSize            = 9,
    TextColor3          = C_TEXT,
    Text                = "0 KB",
    TextXAlignment      = Enum.TextXAlignment.Left,
})
ffBox:GetPropertyChangedSignal("Text"):Connect(function()
    local t = ffBox.Text or ""
    szLbl.Text = ("%.2f KB / %d chars"):format(#t / 1024, #t)
end)

local pBg = new("Frame", {
    Parent           = pgF,
    Size             = UDim2.new(1, -4, 0, 7),
    Position         = UDim2.new(0, 2, 1, -66),
    BackgroundColor3 = Color3.fromRGB(26, 5, 5),
})
corner(pBg, 4)
local pFill = new("Frame", { Parent = pBg, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C_HOT })
corner(pFill, 4)
rgrad(pFill, 0)

local pTxt = new("TextLabel", {
    Parent              = pgF,
    Position            = UDim2.new(0, 2, 1, -57),
    Size                = UDim2.new(1, -4, 0, 12),
    BackgroundTransparency = 1,
    Font                = Enum.Font.GothamBold,
    TextSize            = 9,
    TextColor3          = C_TEXT,
    Text                = "Listo",
    TextXAlignment      = Enum.TextXAlignment.Left,
})

local function mkBtn(label, xs, xo, yo, acc)
    local b = new("TextButton", {
        Parent           = pgF,
        Size             = UDim2.new(0.5, -3, 0, 22),
        Position         = UDim2.new(xs, xo, 1, yo),
        BackgroundColor3 = acc and C_HOT or C_DIM,
        Text             = label,
        Font             = Enum.Font.GothamBold,
        TextSize         = 10,
        TextColor3       = acc and Color3.new(0, 0, 0) or C_WHITE,
    })
    corner(b, 6)
    if acc then rgrad(b, 0) end
    hvr(b)
    return b
end

local pauseBtn  = mkBtn("Pausa",    0,   2, -38, false)
local cancelBtn = mkBtn("Cancelar", 0.5, 1, -38, false)
local saveBtn   = mkBtn("Sanitize", 0,   2, -12, false)
local injectBtn = mkBtn("INJECT",   0.5, 1, -12, true)

local perfOv = new("Frame", {
    Parent           = gui,
    Size             = UDim2.fromOffset(155, 50),
    Position         = UDim2.new(1, -170, 0, 16),
    BackgroundColor3 = C_PANEL,
    Visible          = false,
})
corner(perfOv, 8)
rgrad(perfOv)
new("UIStroke", { Parent = perfOv, Color = C_HOT, Thickness = 1, Transparency = 0.15 })
local perfTxt = new("TextLabel", {
    Parent              = perfOv,
    Size                = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Font                = Enum.Font.GothamBold,
    TextSize            = 11,
    TextColor3          = C_WHITE,
    Text                = "FPS --\nCPU -- ms",
})
local perfX = new("TextButton", {
    Parent           = perfOv,
    Size             = UDim2.fromOffset(17, 17),
    Position         = UDim2.new(1, -20, 0, 3),
    BackgroundColor3 = C_DIM,
    Text             = "X",
    Font             = Enum.Font.GothamBold,
    TextSize         = 9,
    TextColor3       = C_WHITE,
})
corner(perfX, 4)
perfOv.Active = true
mkDrag(perfOv)
local SHOW_OV = false
perfX.MouseButton1Click:Connect(function() SHOW_OV = false perfOv.Visible = false end)

local function addSetting(y, lbl, ctrl)
    new("TextLabel", {
        Parent              = pgC,
        Position            = UDim2.new(0, 4, 0, y),
        Size                = UDim2.new(1, -88, 0, 22),
        BackgroundTransparency = 1,
        Text                = lbl,
        Font                = Enum.Font.GothamBold,
        TextSize            = 10,
        TextColor3          = C_WHITE,
        TextXAlignment      = Enum.TextXAlignment.Left,
    })
    ctrl.Parent   = pgC
    ctrl.Position = UDim2.new(1, -82, 0, y)
end

local function mktgl()
    local on = false
    local b  = new("TextButton", {
        Size             = UDim2.fromOffset(68, 21),
        BackgroundColor3 = C_DIM,
        Text             = "OFF",
        Font             = Enum.Font.GothamBold,
        TextSize         = 10,
        TextColor3       = C_WHITE,
    })
    corner(b, 5)
    hvr(b)
    b.MouseButton1Click:Connect(function()
        clickFeedback(b)
        on             = not on
        b.Text             = on and "ON" or "OFF"
        b.BackgroundColor3 = on and C_HOT or C_DIM
        b.TextColor3       = on and Color3.new(0, 0, 0) or C_WHITE
    end)
    return b, function() return on end
end

local ovTgl,   getOv   = mktgl()
local fmTgl,   getFM   = mktgl()
local cpuTgl,  getCPU  = mktgl()

addSetting(4,  "Mostrar FPS:", ovTgl)
addSetting(30, "Fast Mode:",   fmTgl)
addSetting(56, "CPU Boost:",   cpuTgl)

ovTgl.MouseButton1Click:Connect(function() SHOW_OV = getOv() perfOv.Visible = SHOW_OV end)

local cpuEm, cpuTr = {}, {}
local function setCPU(on)
    task.spawn(function()
        if on then
            cpuEm, cpuTr = {}, {}
            for _, o in ipairs(workspace:GetDescendants()) do
                if o:IsA("BasePart") then o.Material = Enum.Material.Plastic o.Reflectance = 0 end
                if o:IsA("ParticleEmitter") and o.Enabled then table.insert(cpuEm, o) o.Enabled = false end
                if o:IsA("Trail") and o.Enabled then table.insert(cpuTr, o) o.Enabled = false end
            end
            notify("CPU Boost ON")
        else
            for _, e in ipairs(cpuEm) do if e and e.Parent then e.Enabled = true end end
            for _, t in ipairs(cpuTr) do if t and t.Parent then t.Enabled = true end end
            cpuEm, cpuTr = {}, {}
            notify("CPU Boost OFF")
        end
    end)
end
cpuTgl.MouseButton1Click:Connect(function() setCPU(getCPU()) end)

new("TextLabel", {
    Parent              = pgI,
    Position            = UDim2.new(0, 6, 0, 8),
    Size                = UDim2.new(1, -12, 0, 160),
    BackgroundTransparency = 1,
    Text                = "NeoInjector\n\nAdvanced FFlag Tool\n\nOwner: @0_kenyah\nDev:   @0_kenyah\n\nv4.0 - Premium Edition\nDark Theme with Animations",
    Font                = Enum.Font.GothamBold,
    TextSize            = 12,
    TextColor3          = C_TEXT,
    TextXAlignment      = Enum.TextXAlignment.Left,
})

local function openUI()
    win.Visible            = true
    overlay.Visible        = true
    overlay.BackgroundTransparency = 1
    TweenService:Create(overlay, TweenInfo.new(0.16), { BackgroundTransparency = 0.5 }):Play()
    win.BackgroundTransparency = 1
    TweenService:Create(win, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size                = UDim2.fromOffset(280, 320),
        BackgroundTransparency = 0,
    }):Play()
    dock.Visible = false
end

local function closeUI()
    TweenService:Create(win,     TweenInfo.new(0.16, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(overlay, TweenInfo.new(0.14), { BackgroundTransparency = 1 }):Play()
    task.delay(0.18, function()
        win.Visible     = false
        overlay.Visible = false
    end)
    dock.Visible = true
end

closeBtn.MouseButton1Click:Connect(function() clickFeedback(closeBtn) closeUI() end)
minBtn.MouseButton1Click:Connect(function() clickFeedback(minBtn) closeUI() end)
dockBtn.MouseButton1Click:Connect(function() clickFeedback(dockBtn) openUI() end)
openUI()

local injState = { running = false, paused = false, cancel = false }

local hasSFF = type(setfflag)   == "function"
local hasSFI = type(setfint)    == "function"
local hasSFS = type(setfstring) == "function"

local PFXS = { "DFFlag","FFlag","SFFlag","DFInt","FInt","DFString","FString","FLog" }

local function stripPfx(k)
    for _, p in ipairs(PFXS) do
        if k:sub(1, #p) == p then return k:sub(#p + 1) end
    end
    return k
end

local function fkind(k)
    for _, p in ipairs(PFXS) do
        if k:sub(1, #p) == p then
            local l = p:lower()
            if l:find("flag") then return "bool"
            elseif l:find("int") then return "int"
            else return "str" end
        end
    end
    return "str"
end

local function trySet(key, val)
    local vstr = tostring(val)
    local name = stripPfx(key)
    local kind = fkind(key)

    local bv
    local sl = vstr:lower()
    if sl == "true"  or sl == "1" or sl == "yes" or sl == "on"  then bv = "True"  end
    if sl == "false" or sl == "0" or sl == "no"  or sl == "off" then bv = "False" end

    local function attempt(fn, ...)
        for retry = 1, 3 do
            local ok, err = pcall(fn, ...)
            if ok then return true end
            task.wait(0.001)  -- Pequeño delay para evitar freeze
        end
        return false
    end

    if hasSFF then
        local use = (kind == "bool" and bv) and bv or vstr
        if attempt(setfflag, key,  use) then return true end
        if attempt(setfflag, name, use) then return true end
    end

    if kind == "int" then
        local n = tonumber(vstr)
        if n then
            local fl = math.floor(n)
            if hasSFI then
                if attempt(setfint, key,  fl) then return true end
                if attempt(setfint, name, fl) then return true end
            end
            if hasSFF then
                if attempt(setfflag, key,  tostring(fl)) then return true end
                if attempt(setfflag, name, tostring(fl)) then return true end
            end
        end
    end

    if hasSFS then
        if attempt(setfstring, key,  vstr) then return true end
        if attempt(setfstring, name, vstr) then return true end
    end

    if bv and hasSFF then
        if attempt(setfflag, key,  bv) then return true end
        if attempt(setfflag, name, bv) then return true end
    end

    local n2 = tonumber(vstr)
    if n2 then
        local fl2 = math.floor(n2)
        if hasSFI then
            if attempt(setfint, key,  fl2) then return true end
            if attempt(setfint, name, fl2) then return true end
        end
        if hasSFF then
            if attempt(setfflag, key,  tostring(fl2)) then return true end
            if attempt(setfflag, name, tostring(fl2)) then return true end
        end
    end

    if hasSFF then
        if attempt(setfflag, key,  vstr) then return true end
        if attempt(setfflag, name, vstr) then return true end
    end

    return false  -- Ignorar si falla, no crashear
end

local function resolveInput(txt)
    local t = (txt or ""):match("^%s*(.-)%s*$"):gsub("#L%d+%-?%d*$", "")
    if t:lower():sub(-5) == ".json" then
        local ok, s = pcall(function() return readfile and readfile(t) end)
        if ok and type(s) == "string" and #s > 0 then return s end
    end
    return txt
end

local function parseFB(txt)
    local tbl   = {}
    local clean = txt:gsub("//[^\n]*", ""):gsub("/%*.-%*/", "")
    for line in clean:gmatch("[^\r\n]+") do
        local l   = line:gsub("[,%s]*$", "")
        local k, v
        k, v = l:match('"(.-)"%s*:%s*"(.-)"')
        if not k then k, v = l:match('"(.-)"%s*:%s*([^,}%s]+)') end
        if not k then k, v = l:match("^%s*([%w_%-]+)%s*=%s*(.+)%s*$") end
        if k and v then
            v      = v:match('^"(.*)"$') or v:match("^'(.*)'$") or v:gsub("%s+$", "")
            tbl[k] = v
        end
    end
    local n = 0
    for _ in pairs(tbl) do n = n + 1 end
    return n > 0 and tbl or nil
end

local LATE_PAT = {
    "datasender","raknetuseslidingwindow","httpbatch",
    "taskschedulertargetfps","assetpreloading","numassetsmaxtopreload",
    "bandwidth","clientpacket","teleportclientassetpreloading",
}

local function buildList(data)
    local seen  = {}
    local early = {}
    local late  = {}
    for k, v in pairs(data) do
        local name = stripPfx(k)
        if not seen[name] then
            seen[name] = true
            local lk   = name:lower()
            local isL  = false
            for _, p in ipairs(LATE_PAT) do
                if lk:find(p) then isL = true break end
            end
            table.insert(isL and late or early, { k, tostring(v) })
        end
    end
    local res = {}
    for _, p in ipairs(early) do res[#res + 1] = p end
    for _, p in ipairs(late)  do res[#res + 1] = p end
    return res
end

local function doInject(txt)
    local src  = resolveInput(txt)
    local data

    local ok, tmp = pcall(function() return HttpService:JSONDecode(src) end)
    if ok and type(tmp) == "table" then
        data = tmp
    else
        data = parseFB(src)
        if not data then
            notify("JSON invalido o formato no reconocido")
            injectBtn.Text   = "INJECT"
            injectBtn.Active = true
            return
        end
    end

    -- Convertir valores no string a string para compatibilidad con flags rotos
    for k, v in pairs(data) do
        if type(v) ~= "string" then data[k] = tostring(v) end
    end

    local flags = buildList(data)
    local total = #flags

    if total == 0 then
        notify("Sin flags encontradas")
        injectBtn.Text   = "INJECT"
        injectBtn.Active = true
        return
    end

    local FAST = getFM()
    local BATCH_SIZE = FAST and 50 or 10  -- Paralelizar en lotes para pesadas

    task.spawn(function()
        injState.running = true
        injState.cancel  = false
        injState.paused  = false

        local done, good, bad = 0, 0, 0

        pTxt.Text = ("Inyectando %d flags..."):format(total)

        local function injectBatch(batch)
            for _, pair in ipairs(batch) do
                if injState.cancel then return end
                local k, v = pair[1], pair[2]
                if trySet(k, v) then good = good + 1 else bad = bad + 1 end
                done = done + 1
            end
        end

        local batch = {}
        for i, pair in ipairs(flags) do
            while injState.paused do
                pTxt.Text = "Pausado..."
                RunService.Heartbeat:Wait()
            end
            if injState.cancel then
                pTxt.Text = ("Cancelado en %d/%d"):format(done, total)
                break
            end

            table.insert(batch, pair)
            if #batch >= BATCH_SIZE or i == total then
                task.spawn(injectBatch, batch)  -- Paralelizar lote
                batch = {}
                if not FAST then task.wait(0.01) end  -- Delay entre lotes para estabilidad
            end

            if done % 50 == 0 or i == total then
                local pct = done / total
                TweenService:Create(pFill, TweenInfo.new(0.07), { Size = UDim2.new(pct, 0, 1, 0) }):Play()
                pTxt.Text = ("%d%%  %d/%d  ok:%d  err:%d"):format(math.floor(pct * 100), done, total, good, bad)
            end
        end

        -- Esperar a que todos los lotes terminen
        while done < total and not injState.cancel do
            RunService.Heartbeat:Wait()
        end

        pFill.Size = UDim2.new(1, 0, 1, 0)
        local msg  = ("Listo: ok %d  err %d  total %d"):format(good, bad, total)
        pTxt.Text  = msg
        notify(msg)

        injState.running = false
        injectBtn.Text   = "INJECT"
        injectBtn.Active = true

        pcall(function()
            if getgenv().Neo and getgenv().Neo.Logger then
                getgenv().Neo.Logger.log("info", msg)
                getgenv().Neo.Logger.flush("NeoLog.txt")
            end
        end)
    end)
end

injectBtn.MouseButton1Click:Connect(function()
    clickFeedback(injectBtn)
    if injState.running then return end
    injectBtn.Text   = "Inyectando..."
    injectBtn.Active = false
    pFill.Size       = UDim2.new(0, 0, 1, 0)
    pTxt.Text        = "0%"
    injState.cancel  = false
    injState.paused  = false
    local ok, err = pcall(function() doInject(ffBox.Text) end)
    if not ok then
        notify("Error: " .. tostring(err))
        injectBtn.Text   = "INJECT"
        injectBtn.Active = true
    end
end)

pauseBtn.MouseButton1Click:Connect(function()
    clickFeedback(pauseBtn)
    if not injState.running then return end
    injState.paused = not injState.paused
    pauseBtn.Text   = injState.paused and "Reanudar" or "Pausa"
end)

cancelBtn.MouseButton1Click:Connect(function()
    clickFeedback(cancelBtn)
    if injState.running then injState.cancel = true end
end)

saveBtn.MouseButton1Click:Connect(function()
    clickFeedback(saveBtn)
    local src = resolveInput(ffBox.Text)
    local ok, data = pcall(function() return HttpService:JSONDecode(src) end)
    if not ok or type(data) ~= "table" then notify("JSON invalido") return end
    local out = {}
    for k, v in pairs(data) do
        local s  = tostring(v)
        local sl = s:lower()
        local tp = fkind(k)
        if tp == "bool" then
            if sl == "true"  or sl == "1" or sl == "yes" then s = "True"
            elseif sl == "false" or sl == "0" or sl == "no" then s = "False" end
        elseif tp == "int" then
            local n = tonumber(s); s = n and tostring(math.floor(n)) or "0"
        end
        out[k] = s
    end
    local enc   = HttpService:JSONEncode(out)
    local saved = pcall(function() if writefile then writefile("KyroDev-sanitized.json", enc) end end)
    if saved then notify("Guardado: KyroDev-sanitized.json") else ffBox.Text = enc notify("Pegado en caja") end
end)

RunService.RenderStepped:Connect(function(dt)
    fps     = math.clamp(math.floor(1 / dt), 1, 240)
    frameMs = math.floor(dt * 1000 * 10) / 10
end)
RunService.Heartbeat:Connect(function(dt)
    cpuMs = math.floor(dt * 1000 * 10) / 10
end)

task.spawn(function()
    while perfOv.Parent do
        local sf = (getgenv().Neo and getgenv().Neo.State.fps)     or fps
        local sc = (getgenv().Neo and getgenv().Neo.State.cpuMs)   or cpuMs
        local sg = (getgenv().Neo and getgenv().Neo.State.frameMs) or frameMs
        perfTxt.Text = ("FPS %d\nCPU %.1fms  GPU %.1fms"):format(sf, sc, sg)
        task.wait(0.3)
    end
end)
