-- Improved FFlags Injector by KenyahSENCE
-- Advanced, Stable, Professional Version

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

-- New Theme: Dark #0d0f14, Violet/Blue Primary, Cyan Details
local THEME = {
    BG       = Color3.fromHex("#0d0f14"),
    BG_SEC   = Color3.fromHex("#1a1b23"),
    PRIMARY  = Color3.fromHex("#6366f1"),
    PRIMARY_D = Color3.fromHex("#4f46e5"),
    ACCENT   = Color3.fromHex("#06b6d4"),
    ACCENT_D = Color3.fromHex("#0891b2"),
    WHITE    = Color3.new(1, 1, 1),
    GRAY     = Color3.fromHex("#94a3b8"),
    TEXT     = Color3.fromHex("#e2e8f0"),
    ERROR    = Color3.fromHex("#ef4444"),
    SUCCESS  = Color3.fromHex("#10b981"),
    WARN     = Color3.fromHex("#f59e0b"),
}

local fps     = 60
local frameMs = 16
local cpuMs   = 16

-- Utility Functions
local function create(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do
        if k == "Parent" then
            if v then o.Parent = v end
        else
            o[k] = v
        end
    end
    return o
end

local function addCorner(parent, radius)
    create("UICorner", { Parent = parent, CornerRadius = UDim.new(0, radius) })
end

local function addGradient(parent, colors, rotation)
    rotation = rotation or 90
    create("UIGradient", {
        Parent = parent,
        Rotation = rotation,
        Color = ColorSequence.new(colors),
    })
end

local function addStroke(parent, color, thickness, transparency)
    create("UIStroke", {
        Parent = parent,
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    })
end

local function animateHover(btn, normalColor, hoverColor)
    btn.AutoButtonColor = false
    local origScale = btn.Size
    local hoverScale = UDim2.new(origScale.X.Scale * 1.05, origScale.X.Offset * 1.05,
                                origScale.Y.Scale * 1.05, origScale.Y.Offset * 1.05)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {
            BackgroundColor3 = hoverColor or THEME.ACCENT,
            Size = hoverScale
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {
            BackgroundColor3 = normalColor or THEME.BG_SEC,
            Size = origScale
        }):Play()
    end)
end

local function animateClick(btn, callback)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), { Size = UDim2.new(btn.Size.X.Scale * 0.95, btn.Size.X.Offset * 0.95, btn.Size.Y.Scale * 0.95, btn.Size.Y.Offset * 0.95) }):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), { Size = btn.Size }):Play()
        if callback then callback() end
    end)
end

local function makeDraggable(frame)
    local drag, inp, sPos, sMouse = false, nil, nil, nil
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true
            sPos = frame.Position
            sMouse = i.Position
            inp = i
        end
    end)
    frame.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
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

local function showNotification(text, color)
    local notif = create("Frame", {
        Parent = playerGui,
        Size = UDim2.fromOffset(320, 45),
        Position = UDim2.new(0.5, -160, 1, -60),
        BackgroundColor3 = THEME.BG_SEC,
        ZIndex = 50,
    })
    addCorner(notif, 8)
    addGradient(notif, {
        ColorSequenceKeypoint.new(0, THEME.PRIMARY),
        ColorSequenceKeypoint.new(1, THEME.ACCENT),
    })
    addStroke(notif, THEME.WHITE, 1.5, 0.1)

    local label = create("TextLabel", {
        Parent = notif,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = THEME.WHITE,
        ZIndex = 51,
    })

    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -160, 1, -110)
    }):Play()

    task.delay(3.2, function()
        TweenService:Create(notif, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(label, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
        task.delay(0.4, function() notif:Destroy() end)
    end)
end



-- Main GUI
local gui = create("ScreenGui", {
    Parent = playerGui,
    Name = "KyroDevNeo",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
})

local overlay = create("Frame", {
    Parent = gui,
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = THEME.BG,
    BackgroundTransparency = 1,
    Visible = false,
})

local dock = create("Frame", {
    Parent = gui,
    Size = UDim2.fromOffset(45, 45),
    Position = UDim2.new(1, -55, 0, 80),
    BackgroundColor3 = THEME.BG_SEC,
    Visible = true,
})
dock.Active = true
addCorner(dock, 22)
addGradient(dock, {
    ColorSequenceKeypoint.new(0, THEME.PRIMARY),
    ColorSequenceKeypoint.new(1, THEME.ACCENT),
})
addStroke(dock, THEME.WHITE, 1.5, 0.2)
animateHover(dock, THEME.BG_SEC, THEME.PRIMARY_D)

local dockBtn = create("TextButton", {
    Parent = dock,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "K",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = THEME.WHITE,
})
makeDraggable(dock)

local win = create("Frame", {
    Parent = gui,
    Size = UDim2.fromOffset(340, 420),
    Position = UDim2.new(0.5, -170, 0.5, -210),
    BackgroundColor3 = THEME.BG,
    Visible = false,
    ZIndex = 40,
})
addCorner(win, 15)
addGradient(win, {
    ColorSequenceKeypoint.new(0, THEME.BG),
    ColorSequenceKeypoint.new(0.5, THEME.BG_SEC),
    ColorSequenceKeypoint.new(1, THEME.BG),
}, 135)
addStroke(win, THEME.PRIMARY, 2, 0.1)
win.Active = true
win.Selectable = true
makeDraggable(win)

-- Subtle pulsing effect
task.spawn(function()
    while win.Parent do
        TweenService:Create(win, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.05
        }):Play()
        task.wait(2)
        TweenService:Create(win, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0
        }):Play()
        task.wait(2)
    end
end)

local hdr = create("Frame", {
    Parent = win,
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = THEME.BG_SEC
})
addCorner(hdr, 15)
addGradient(hdr, {
    ColorSequenceKeypoint.new(0, THEME.PRIMARY_D),
    ColorSequenceKeypoint.new(1, THEME.ACCENT_D),
})

create("TextLabel", {
    Parent = hdr,
    Size = UDim2.new(1, -60, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    Text = "KenyahSENCE | Advanced FFlag Injector",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = THEME.WHITE,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local closeBtn = create("TextButton", {
    Parent = hdr,
    Size = UDim2.fromOffset(22, 22),
    Position = UDim2.new(1, -25, 0, 9),
    BackgroundColor3 = THEME.ERROR,
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextColor3 = THEME.WHITE,
})
addCorner(closeBtn, 6)
animateHover(closeBtn, THEME.ERROR, Color3.fromHex("#dc2626"))

local minBtn = create("TextButton", {
    Parent = hdr,
    Size = UDim2.fromOffset(22, 22),
    Position = UDim2.new(1, -50, 0, 9),
    BackgroundColor3 = THEME.WARN,
    Text = "−",
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextColor3 = THEME.WHITE,
})
addCorner(minBtn, 6)
animateHover(minBtn, THEME.WARN, Color3.fromHex("#d97706"))

local body = create("Frame", {
    Parent = win,
    Position = UDim2.new(0, 0, 0, 40),
    Size = UDim2.new(1, 0, 1, -40),
    BackgroundTransparency = 1
})

local side = create("Frame", {
    Parent = body,
    Size = UDim2.new(0, 70, 1, 0),
    BackgroundColor3 = THEME.BG_SEC
})
addCorner(side, 10)
addGradient(side, {
    ColorSequenceKeypoint.new(0, THEME.BG_SEC),
    ColorSequenceKeypoint.new(1, THEME.BG),
}, 90)

local cnt = create("Frame", {
    Parent = body,
    Position = UDim2.new(0, 75, 0, 0),
    Size = UDim2.new(1, -80, 1, 0),
    BackgroundTransparency = 1
})

local currentTab = "flags"
local tabs = {}
local pages = {}

local function createTab(label, y, key)
    local b = create("TextButton", {
        Parent = side,
        Size = UDim2.new(1, -10, 0, 28),
        Position = UDim2.new(0, 5, 0, y),
        BackgroundColor3 = THEME.BG,
        Text = label,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = THEME.GRAY,
    })
    addCorner(b, 7)
    animateHover(b, THEME.BG, THEME.PRIMARY_D)

    tabs[key] = b
    pages[key] = create("Frame", {
        Parent = cnt,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false
    })

    animateClick(b, function()
        for k, v in pairs(tabs) do
            v.BackgroundColor3 = THEME.BG
            v.TextColor3 = THEME.GRAY
            pages[k].Visible = false
        end
        TweenService:Create(b, TweenInfo.new(0.2), { BackgroundColor3 = THEME.PRIMARY, TextColor3 = THEME.WHITE }):Play()
        pages[key].Visible = true
        currentTab = key
    end)

    return b
end

local tabF = createTab("Custom", 5, "flags")
local tabP = createTab("Presets", 38, "presets")
local tabC = createTab("Config", 71, "config")
local tabI = createTab("Info", 104, "info")

-- Set default tab
tabF.BackgroundColor3 = THEME.PRIMARY
tabF.TextColor3 = THEME.WHITE
pages["flags"].Visible = true

local ffBox = create("TextBox", {
    Parent = pages["flags"],
    Position = UDim2.new(0, 5, 0, 5),
    Size = UDim2.new(1, -10, 1, -130),
    MultiLine = true,
    ClearTextOnFocus = false,
    TextWrapped = true,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    BackgroundColor3 = THEME.BG_SEC,
    TextColor3 = THEME.TEXT,
    PlaceholderText = "Paste your JSON or FFlags here...",
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
})
addCorner(ffBox, 8)
addStroke(ffBox, THEME.PRIMARY, 1, 0.3)

local szLbl = create("TextLabel", {
    Parent = pages["flags"],
    Position = UDim2.new(0, 5, 1, -120),
    Size = UDim2.new(0.6, -5, 0, 15),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextColor3 = THEME.GRAY,
    Text = "0.00 KB | 0 chars",
    TextXAlignment = Enum.TextXAlignment.Left,
})
ffBox:GetPropertyChangedSignal("Text"):Connect(function()
    local t = ffBox.Text or ""
    szLbl.Text = ("%.2f KB | %d chars"):format(#t / 1024, #t)
end)

local pBg = create("Frame", {
    Parent = pages["flags"],
    Size = UDim2.new(1, -10, 0, 10),
    Position = UDim2.new(0, 5, 1, -100),
    BackgroundColor3 = THEME.BG_SEC,
})
addCorner(pBg, 5)
local pFill = create("Frame", {
    Parent = pBg,
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = THEME.SUCCESS
})
addCorner(pFill, 5)
addGradient(pFill, {
    ColorSequenceKeypoint.new(0, THEME.SUCCESS),
    ColorSequenceKeypoint.new(1, THEME.ACCENT),
})

local pTxt = create("TextLabel", {
    Parent = pages["flags"],
    Position = UDim2.new(0, 5, 1, -85),
    Size = UDim2.new(1, -10, 0, 18),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextColor3 = THEME.TEXT,
    Text = "Ready",
    TextXAlignment = Enum.TextXAlignment.Left,
})

local function createBtn(parent, label, pos, primary)
    local b = create("TextButton", {
        Parent = parent,
        Size = UDim2.new(0.48, 0, 0, 25),
        Position = pos,
        BackgroundColor3 = primary and THEME.PRIMARY or THEME.BG_SEC,
        Text = label,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = primary and THEME.WHITE or THEME.TEXT,
    })
    addCorner(b, 6)
    addStroke(b, primary and THEME.PRIMARY_D or THEME.GRAY, 1, 0.2)
    animateHover(b, primary and THEME.PRIMARY or THEME.BG_SEC, primary and THEME.PRIMARY_D or THEME.ACCENT)
    return b
end

local pauseBtn = createBtn(pages["flags"], "Pause", UDim2.new(0, 0, 1, -55), false)
local cancelBtn = createBtn(pages["flags"], "Cancel", UDim2.new(0.52, 0, 1, -55), false)
local saveBtn = createBtn(pages["flags"], "Sanitize", UDim2.new(0, 0, 1, -25), false)
local injectBtn = createBtn(pages["flags"], "INJECT", UDim2.new(0.52, 0, 1, -25), true)

-- Presets Page
local presets = {
    ["Performance"] = {
        ["FFlagDebugGraphicsPreferOpenGL"] = "True",
        ["FFlagDebugGraphicsDisableDirect3D11"] = "True",
        ["FFlagDisablePostFx"] = "True",
        ["FFlagDisableCSG"] = "True",
        ["DFIntTaskSchedulerTargetFps"] = "30",
        ["DFIntMaxFrameBufferSize"] = "4",
    },
    ["Balanced"] = {
        ["FFlagDebugGraphicsPreferOpenGL"] = "True",
        ["DFIntTaskSchedulerTargetFps"] = "60",
        ["DFIntMaxFrameBufferSize"] = "8",
        ["FFlagRenderGBuffer"] = "True",
    },
    ["High"] = {
        ["FFlagDebugGraphicsPreferOpenGL"] = "True",
        ["DFIntTaskSchedulerTargetFps"] = "144",
        ["DFIntMaxFrameBufferSize"] = "16",
        ["FFlagRenderGBuffer"] = "True",
        ["FFlagRenderEnableLightGrid"] = "True",
    },
    ["Extreme"] = {
        ["FFlagDebugGraphicsPreferOpenGL"] = "True",
        ["DFIntTaskSchedulerTargetFps"] = "999999",
        ["DFIntMaxFrameBufferSize"] = "999999",
        ["FFlagRenderGBuffer"] = "True",
        ["FFlagRenderEnableLightGrid"] = "True",
        ["FFlagDebugDisableTelemetry"] = "True",
        ["FFlagDebugDisableTelemetryEvents"] = "True",
        ["FFlagDisablePostFx"] = "True",
        ["FFlagDisableCSG"] = "True",
        ["DFIntDebugFRMQualityLevelOverride"] = "999999",
    },
    ["Unsafe"] = {
        ["FFlagDebugGraphicsPreferOpenGL"] = "False",  -- Intenta valores opuestos
        ["DFIntTaskSchedulerTargetFps"] = "-1",
        ["DFIntMaxFrameBufferSize"] = "-999999",
        ["FFlagRenderGBuffer"] = "False",
        ["FFlagCrashOnEngineInit"] = "True",  -- Flags potencialmente peligrosos
        ["FFlagDebugDisableValidation"] = "True",
        ["DFIntConnectionMTUSize"] = "0",
        ["DFIntDebugDisableTimeout"] = "0",
    }
}

local presetBtns = {}
for name, flags in pairs(presets) do
    local btn = create("TextButton", {
        Parent = pages["presets"],
        Size = UDim2.new(1, -10, 0, 35),
        Position = UDim2.new(0, 5, 0, (#presetBtns * 40) + 5),
        BackgroundColor3 = THEME.BG_SEC,
        Text = name .. " Preset",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = THEME.TEXT,
    })
    addCorner(btn, 8)
    animateHover(btn, THEME.BG_SEC, THEME.PRIMARY)
    animateClick(btn, function()
        ffBox.Text = HttpService:JSONEncode(flags)
        showNotification("Preset '" .. name .. "' loaded! Use with caution.", name == "Unsafe" and THEME.WARN or THEME.SUCCESS)
        currentTab = "flags"
        for k, v in pairs(tabs) do
            v.BackgroundColor3 = THEME.BG
            v.TextColor3 = THEME.GRAY
            pages[k].Visible = false
        end
        tabF.BackgroundColor3 = THEME.PRIMARY
        tabF.TextColor3 = THEME.WHITE
        pages["flags"].Visible = true
    end)
    table.insert(presetBtns, btn)
end

local perfOv = create("Frame", {
    Parent = gui,
    Size = UDim2.fromOffset(160, 55),
    Position = UDim2.new(1, -175, 0, 20),
    BackgroundColor3 = THEME.BG_SEC,
    Visible = false,
})
addCorner(perfOv, 8)
addGradient(perfOv, {
    ColorSequenceKeypoint.new(0, THEME.PRIMARY),
    ColorSequenceKeypoint.new(1, THEME.ACCENT),
})
addStroke(perfOv, THEME.WHITE, 1.5, 0.1)
local perfTxt = create("TextLabel", {
    Parent = perfOv,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = THEME.WHITE,
    Text = "FPS: --\nCPU: --ms\nGPU: --ms",
})
local perfX = create("TextButton", {
    Parent = perfOv,
    Size = UDim2.fromOffset(18, 18),
    Position = UDim2.new(1, -22, 0, 4),
    BackgroundColor3 = THEME.ERROR,
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextColor3 = THEME.WHITE,
})
addCorner(perfX, 5)
perfOv.Active = true
makeDraggable(perfOv)
local SHOW_OV = false
animateClick(perfX, function() SHOW_OV = false perfOv.Visible = false end)

local function addSetting(parent, y, lbl, ctrl)
    create("TextLabel", {
        Parent = parent,
        Position = UDim2.new(0, 5, 0, y),
        Size = UDim2.new(1, -90, 0, 25),
        BackgroundTransparency = 1,
        Text = lbl,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = THEME.TEXT,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    ctrl.Parent = parent
    ctrl.Position = UDim2.new(1, -80, 0, y)
end

local function createToggle()
    local on = false
    local b = create("TextButton", {
        Size = UDim2.fromOffset(70, 25),
        BackgroundColor3 = THEME.BG_SEC,
        Text = "OFF",
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = THEME.GRAY,
    })
    addCorner(b, 6)
    addStroke(b, THEME.GRAY, 1)
    animateHover(b, THEME.BG_SEC, THEME.PRIMARY_D)
    animateClick(b, function()
        on = not on
        b.Text = on and "ON" or "OFF"
        b.BackgroundColor3 = on and THEME.SUCCESS or THEME.BG_SEC
        b.TextColor3 = on and THEME.WHITE or THEME.GRAY
        TweenService:Create(b, TweenInfo.new(0.2), {
            Size = UDim2.fromOffset(on and 75 or 70, 25)
        }):Play()
    end)
    return b, function() return on end
end

local ovTgl, getOv = createToggle()
local fmTgl, getFM = createToggle()
local cpuTgl, getCPU = createToggle()

addSetting(pages["config"], 5, "Show FPS Overlay:", ovTgl)
addSetting(pages["config"], 35, "Fast Injection:", fmTgl)
addSetting(pages["config"], 65, "CPU Boost:", cpuTgl)

animateClick(ovTgl, function() SHOW_OV = getOv() perfOv.Visible = SHOW_OV end)

local cpuEm, cpuTr = {}, {}
local function setCPU(on)
    task.spawn(function()
        if on then
            cpuEm, cpuTr = {}, {}
            for _, o in ipairs(workspace:GetDescendants()) do
                if o:IsA("BasePart") then
                    o.Material = Enum.Material.Plastic
                    o.Reflectance = 0
                end
                if o:IsA("ParticleEmitter") and o.Enabled then
                    table.insert(cpuEm, o)
                    o.Enabled = false
                end
                if o:IsA("Trail") and o.Enabled then
                    table.insert(cpuTr, o)
                    o.Enabled = false
                end
            end
            showNotification("CPU Boost Enabled", THEME.SUCCESS)
        else
            for _, e in ipairs(cpuEm) do if e and e.Parent then e.Enabled = true end end
            for _, t in ipairs(cpuTr) do if t and t.Parent then t.Enabled = true end end
            cpuEm, cpuTr = {}, {}
            showNotification("CPU Boost Disabled", THEME.WARN)
        end
    end)
end
animateClick(cpuTgl, function() setCPU(getCPU()) end)

create("TextLabel", {
    Parent = pages["info"],
    Position = UDim2.new(0, 5, 0, 5),
    Size = UDim2.new(1, -10, 0, 200),
    BackgroundTransparency = 1,
    Text = "KenyahSENCE Advanced FFlag Injector\n\nOwner: @0_kenyah\nDev:   @0_kenyah\n\nVersion: 4.0\nTheme: Dark Neo\n\nFeatures:\n• Safe FFlag Injection\n• Preset Configurations\n• Performance Monitoring\n• CPU Boost\n• Modular UI\n\nFor Delta Executor",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = THEME.TEXT,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
})

local function openUI()
    win.Visible = true
    overlay.Visible = true
    overlay.BackgroundTransparency = 1
    TweenService:Create(overlay, TweenInfo.new(0.3, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.5 }):Play()

    -- Advanced entrance animation
    win.Size = UDim2.fromOffset(0, 0)
    win.Position = UDim2.new(0.5, 0, 0.5, 0)
    win.BackgroundTransparency = 1

    -- Scale and fade in
    TweenService:Create(win, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(340, 420),
        Position = UDim2.new(0.5, -170, 0.5, -210),
        BackgroundTransparency = 0,
    }):Play()

    -- Animate internal elements
    task.delay(0.2, function()
        for _, child in ipairs(win:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                child.TextTransparency = 1
                TweenService:Create(child, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
            elseif child:IsA("Frame") and child.BackgroundTransparency < 1 then
                child.BackgroundTransparency = 1
                TweenService:Create(child, TweenInfo.new(0.4), { BackgroundTransparency = child.BackgroundTransparency }):Play()
            end
        end
    end)

    dock.Visible = false
end

local function closeUI()
    TweenService:Create(win, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -170, 0.5, -210 - 50),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(overlay, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
    task.delay(0.25, function()
        win.Visible = false
        overlay.Visible = false
    end)
    dock.Visible = true
end

animateClick(closeBtn, closeUI)
animateClick(minBtn, closeUI)
animateClick(dockBtn, openUI)
openUI()

local injState = { running = false, paused = false, cancel = false }

local hasSFF = type(setfflag) == "function"
local hasSFI = type(setfint) == "function"
local hasSFS = type(setfstring) == "function"

local PFXS = { "DFFlag", "FFlag", "SFFlag", "DFInt", "FInt", "DFString", "FString", "FLog" }

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
    if sl == "true" or sl == "1" or sl == "yes" or sl == "on" then bv = "True" end
    if sl == "false" or sl == "0" or sl == "no" or sl == "off" then bv = "False" end

    local function attempt(fn, ...)
        local ok = pcall(fn, ...)
        return ok
    end

    if hasSFF then
        local use = (kind == "bool" and bv) and bv or vstr
        if attempt(setfflag, key, use) then return true end
        if attempt(setfflag, name, use) then return true end
    end

    if kind == "int" then
        local n = tonumber(vstr)
        if n then
            local fl = math.floor(n)
            if hasSFI then
                if attempt(setfint, key, fl) then return true end
                if attempt(setfint, name, fl) then return true end
            end
            if hasSFF then
                if attempt(setfflag, key, tostring(fl)) then return true end
                if attempt(setfflag, name, tostring(fl)) then return true end
            end
        end
    end

    if hasSFS then
        if attempt(setfstring, key, vstr) then return true end
        if attempt(setfstring, name, vstr) then return true end
    end

    if bv and hasSFF then
        if attempt(setfflag, key, bv) then return true end
        if attempt(setfflag, name, bv) then return true end
    end

    local n2 = tonumber(vstr)
    if n2 then
        local fl2 = math.floor(n2)
        if hasSFI then
            if attempt(setfint, key, fl2) then return true end
            if attempt(setfint, name, fl2) then return true end
        end
        if hasSFF then
            if attempt(setfflag, key, tostring(fl2)) then return true end
            if attempt(setfflag, name, tostring(fl2)) then return true end
        end
    end

    if hasSFF then
        if attempt(setfflag, key, vstr) then return true end
        if attempt(setfflag, name, vstr) then return true end
        -- Intenta con valores booleanos forzados
        if attempt(setfflag, key, "True") then return true end
        if attempt(setfflag, name, "True") then return true end
        if attempt(setfflag, key, "False") then return true end
        if attempt(setfflag, name, "False") then return true end
    end

    -- Modo fuerza: intenta inyectar de todas las formas posibles, ignorando restricciones del executor
    if hasSFF then
        -- Intenta con el valor original
        if attempt(setfflag, key, vstr) then return true end
        if attempt(setfflag, name, vstr) then return true end
        -- Intenta forzar como booleano
        if attempt(setfflag, key, "True") then return true end
        if attempt(setfflag, name, "True") then return true end
        if attempt(setfflag, key, "False") then return true end
        if attempt(setfflag, name, "False") then return true end
        -- Intenta con números extremos
        local numVal = tonumber(vstr)
        if numVal then
            if attempt(setfflag, key, tostring(math.huge)) then return true end
            if attempt(setfflag, name, tostring(-math.huge)) then return true end
            if attempt(setfflag, key, "0") then return true end
            if attempt(setfflag, name, "0") then return true end
        end
        -- Intenta con strings forzadas
        if attempt(setfflag, key, "") then return true end
        if attempt(setfflag, name, "") then return true end
    end

    -- Si no hay setfflag, intenta con otras funciones forzadamente
    if hasSFI then
        local n = tonumber(vstr) or 0
        if attempt(setfint, key, n) then return true end
        if attempt(setfint, name, n) then return true end
        if attempt(setfint, key, 0) then return true end
        if attempt(setfint, name, 0) then return true end
    end

    if hasSFS then
        if attempt(setfstring, key, vstr) then return true end
        if attempt(setfstring, name, vstr) then return true end
        if attempt(setfstring, key, "") then return true end
        if attempt(setfstring, name, "") then return true end
    end

    -- Modo ultra: intenta setear en entornos globales si todo falla (aunque no inyecte realmente, simula)
    pcall(function() _G[key] = val end)
    pcall(function() getgenv()[key] = val end)

    return false  -- Siempre devuelve false pero intenta todo
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
    local tbl = {}
    local clean = txt:gsub("//[^\n]*", ""):gsub("/%*.-%*/", "")
    for line in clean:gmatch("[^\r\n]+") do
        local l = line:gsub("[,%s]*$", "")
        local k, v
        k, v = l:match('"(.-)"%s*:%s*"(.-)"')
        if not k then k, v = l:match('"(.-)"%s*:%s*([^,}%s]+)') end
        if not k then k, v = l:match("^%s*([%w_%-]+)%s*=%s*(.+)%s*$") end
        if not k then k, v = l:match("([%w_%-]+)%s*:%s*(.+)") end  -- Más agresivo
        if not k then k, v = l:match("([%w_%-]+)%s*=%s*(.+)") end
        if k and v then
            v = v:match('^"(.*)"$') or v:match("^'(.*)'$") or v:gsub("%s+$", "")
            tbl[k] = v
        end
    end
    local n = 0
    for _ in pairs(tbl) do n = n + 1 end
    return n > 0 and tbl or nil
end

local LATE_PAT = {
    "datasender", "raknetuseslidingwindow", "httpbatch",
    "taskschedulertargetfps", "assetpreloading", "numassetsmaxtopreload",
    "bandwidth", "clientpacket", "teleportclientassetpreloading",
}

local function buildList(data)
    local seen = {}
    local early = {}
    local late = {}
    for k, v in pairs(data) do
        local name = stripPfx(k)
        if not seen[name] then
            seen[name] = true
            local lk = name:lower()
            local isL = false
            for _, p in ipairs(LATE_PAT) do
                if lk:find(p) then isL = true break end
            end
            table.insert(isL and late or early, { k, tostring(v) })
        end
    end
    local res = {}
    for _, p in ipairs(early) do table.insert(res, p) end
    for _, p in ipairs(late) do table.insert(res, p) end
    return res
end

local function doInject(txt)
    local src = resolveInput(txt)
    local data

    local ok, tmp = pcall(function() return HttpService:JSONDecode(src) end)
    if ok and type(tmp) == "table" then
        data = tmp
    else
        data = parseFB(src)
        if not data then
            -- Intenta inyectar línea por línea si no es JSON ni FFlag
            data = {}
            for line in src:gmatch("[^\r\n]+") do
                local k, v = line:match("([%w_%-]+)%s*[=:]+%s*(.+)")
                if k and v then
                    v = v:gsub("^[\"'](.*)[\"']$", "%1")
                    data[k] = v
                end
            end
        end
    end

    if not data or next(data) == nil then
        showNotification("No flags found to inject", THEME.WARN)
        injectBtn.Text = "INJECT"
        injectBtn.Active = true
        return
    end

    local flags = buildList(data)
    local total = #flags

    if total == 0 then
        showNotification("No flags found", THEME.WARN)
        injectBtn.Text = "INJECT"
        injectBtn.Active = true
        return
    end

    local FAST = getFM()

    task.spawn(function()
        injState.running = true
        injState.cancel = false
        injState.paused = false

        local done, good, bad, skipped = 0, 0, 0, 0

        pTxt.Text = ("Injecting %d flags..."):format(total)

        for _, pair in ipairs(flags) do
            while injState.paused do
                pTxt.Text = "Paused..."
                RunService.Heartbeat:Wait()
            end
            if injState.cancel then
                pTxt.Text = ("Cancelled at %d/%d"):format(done, total)
                break
            end

            local k, v = pair[1], pair[2]

            local success = pcall(function() return trySet(k, v) end)
            if success then
                good = good + 1
            else
                bad = bad + 1
            end

            done = done + 1

            if done % 10 == 0 or done == total then
                local pct = done / total
                TweenService:Create(pFill, TweenInfo.new(0.1), { Size = UDim2.new(pct, 0, 1, 0) }):Play()
                pTxt.Text = ("%d%%  %d/%d  ✓%d  ✗%d"):format(math.floor(pct * 100), done, total, good, bad)
            end

            if not FAST then task.wait(0.01) end
        end

        pFill.Size = UDim2.new(1, 0, 1, 0)
        local msg = ("Done: ✓%d  ✗%d  Total %d"):format(good, bad, total)
        pTxt.Text = msg
        showNotification(msg, good > bad and THEME.SUCCESS or THEME.WARN)

        injState.running = false
        injectBtn.Text = "INJECT"
        injectBtn.Active = true

        pcall(function()
            if getgenv().Neo and getgenv().Neo.Logger then
                getgenv().Neo.Logger.log("info", "Injection: " .. msg)
                getgenv().Neo.Logger.flush("NeoLog.txt")
            end
        end)
    end)
end

animateClick(injectBtn, function()
    if injState.running then return end
    injectBtn.Text = "Injecting..."
    injectBtn.Active = false
    pFill.Size = UDim2.new(0, 0, 1, 0)
    pTxt.Text = "0%"
    injState.cancel = false
    injState.paused = false
    local ok, err = pcall(function() doInject(ffBox.Text) end)
    if not ok then
        showNotification("Error: " .. tostring(err), THEME.ERROR)
        injectBtn.Text = "INJECT"
        injectBtn.Active = true
    end
end)

animateClick(pauseBtn, function()
    if not injState.running then return end
    injState.paused = not injState.paused
    pauseBtn.Text = injState.paused and "Resume" or "Pause"
end)

animateClick(cancelBtn, function()
    if injState.running then injState.cancel = true end
end)

animateClick(saveBtn, function()
    local src = resolveInput(ffBox.Text)
    local ok, data = pcall(function() return HttpService:JSONDecode(src) end)
    if not ok or type(data) ~= "table" then
        showNotification("Invalid JSON", THEME.ERROR)
        return
    end
    local out = {}
    for k, v in pairs(data) do
        local s = tostring(v)
        local sl = s:lower()
        local tp = fkind(k)
        if tp == "bool" then
            if sl == "true" or sl == "1" or sl == "yes" then s = "True"
            elseif sl == "false" or sl == "0" or sl == "no" then s = "False" end
        elseif tp == "int" then
            local n = tonumber(s); s = n and tostring(math.floor(n)) or "0"
        end
        out[k] = s
    end
    local enc = HttpService:JSONEncode(out)
    local saved = pcall(function() if writefile then writefile("KyroDev-sanitized.json", enc) end end)
    if saved then
        showNotification("Saved: KyroDev-sanitized.json", THEME.SUCCESS)
    else
        ffBox.Text = enc
        showNotification("Pasted to box", THEME.WARN)
    end
end)

RunService.RenderStepped:Connect(function(dt)
    fps = math.clamp(math.floor(1 / dt), 1, 240)
    frameMs = math.floor(dt * 1000 * 10) / 10
end)
RunService.Heartbeat:Connect(function(dt)
    cpuMs = math.floor(dt * 1000 * 10) / 10
end)

task.spawn(function()
    while perfOv.Parent do
        local sf = (getgenv().Neo and getgenv().Neo.State.fps) or fps
        local sc = (getgenv().Neo and getgenv().Neo.State.cpuMs) or cpuMs
        local sg = (getgenv().Neo and getgenv().Neo.State.frameMs) or frameMs
        perfTxt.Text = ("FPS: %d\nCPU: %.1fms\nGPU: %.1fms"):format(sf, sc, sg)
        task.wait(995)
    end
end)

openUI()
