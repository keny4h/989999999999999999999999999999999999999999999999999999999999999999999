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
local CoreGui          = game:GetService("CoreGui")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

do
    local p = playerGui:FindFirstChild("KyroDev") or playerGui:FindFirstChild("KyroDevNeo")
    if p then p:Destroy() end
end

-- Tonos pastel - paleta suave y moderna
local PASTEL = {
    ROSE    = Color3.fromRGB(255, 200, 205),  -- Rosa pastel
    PEACH   = Color3.fromRGB(255, 218, 185),  -- Durazno
    LAVENDER= Color3.fromRGB(216, 191, 216),  -- Lavanda
    MINT    = Color3.fromRGB(189, 236, 220),  -- Menta
    CREAM   = Color3.fromRGB(255, 253, 208),  -- Crema suave
    SKY     = Color3.fromRGB(173, 216, 230),  -- Azul cielo
    BLUSH   = Color3.fromRGB(255, 209, 203),  -- Blush
    WHITE   = Color3.new(0.98, 0.98, 0.99),
    DEEP    = Color3.fromRGB(35, 30, 50),     -- Fondo profundo suave
    PANEL   = Color3.fromRGB(45, 40, 60),     -- Panel semi-transparente
    CARD    = Color3.fromRGB(55, 50, 70),     -- Cards
    DARK    = Color3.fromRGB(28, 25, 40),     -- Para headers
}

local ACCENT = Color3.fromRGB(120, 80, 220)   -- Acento morado suave
local GLOW   = Color3.fromRGB(180, 140, 240)

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

local function softGrad(obj, rot, c1, c2, c3)
    new("UIGradient", {
        Parent   = obj,
        Rotation = rot or 90,
        Color    = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   c1 or Color3.fromRGB(80, 70, 100)),
            ColorSequenceKeypoint.new(0.5, c2 or Color3.fromRGB(65, 60, 85)),
            ColorSequenceKeypoint.new(1,   c3 or Color3.fromRGB(50, 48, 70)),
        }),
    })
end

local function softHvr(btn, accent)
    btn.AutoButtonColor = false
    local orig = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = accent or GLOW,
            TextColor3 = PASTEL.WHITE
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = orig,
            TextColor3 = PASTEL.CREAM
        }):Play()
    end)
end

local function mkDrag(frame)
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
            frame.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
        end
    end)
end

local notifQueue = {}
local function notify(txt, success)
    local n = new("Frame", {
        Parent = playerGui,
        Size = UDim2.fromOffset(340, 50),
        Position = UDim2.new(0.5, -170, 1, -100 - (#notifQueue * 65)),
        BackgroundColor3 = PASTEL.PANEL,
        ZIndex = 100,
    })
    corner(n, 12)
    softGrad(n, 90)
    new("UIStroke", { Parent = n, Color = success and GLOW or ACCENT, Thickness = 1.5, Transparency = 0.3 })
    
    local icon = new("TextLabel", {
        Parent = n,
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = success and "✓" or "⚡",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = success and PASTEL.MINT or PASTEL.PEACH,
    })
    
    local lbl = new("TextLabel", {
        Parent = n,
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 48, 0, 0),
        BackgroundTransparency = 1,
        Text = txt,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = PASTEL.CREAM,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    })
    
    n.BackgroundTransparency = 1
    n.Position = UDim2.new(0.5, -170, 1, -80)
    TweenService:Create(n, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5, -170, 1, -100 - (#notifQueue * 65)),
    }):Play()
    
    table.insert(notifQueue, n)
    task.delay(3.5, function()
        if n and n.Parent then
            TweenService:Create(n, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, -170, 1, -120),
            }):Play()
            task.delay(0.3, function()
                if n and n.Parent then n:Destroy() end
                for i, v in ipairs(notifQueue) do
                    if v == n then table.remove(notifQueue, i) break end
                end
            end)
        end
    end)
end

local gui = new("ScreenGui", {
    Parent = playerGui,
    Name = "KyroDev",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local overlay = new("Frame", {
    Parent = gui,
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1,
    Visible = false,
})

-- Pequeño panel flotante (reducido significativamente)
local dock = new("Frame", {
    Parent = gui,
    Size = UDim2.fromOffset(44, 44),
    Position = UDim2.new(1, -56, 0.5, -22),
    BackgroundColor3 = PASTEL.DARK,
    Visible = true,
})
corner(dock, 22)
softGrad(dock, 90, PASTEL.DARK, Color3.fromRGB(40, 35, 55))
new("UIStroke", { Parent = dock, Color = ACCENT, Thickness = 1.2, Transparency = 0.3 })

local dockBtn = new("TextButton", {
    Parent = dock,
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "✨",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = PASTEL.CREAM,
})
mkDrag(dock)

-- Ventana principal (reducida: 380 -> 340, más compacta)
local win = new("Frame", {
    Parent = gui,
    Size = UDim2.fromOffset(340, 420),
    Position = UDim2.new(0.5, -170, 0.5, -210),
    BackgroundColor3 = PASTEL.DEEP,
    Visible = false,
})
corner(win, 16)
softGrad(win, 110, PASTEL.DEEP, Color3.fromRGB(30, 26, 45), Color3.fromRGB(38, 34, 52))
local wStroke = new("UIStroke", { Parent = win, Color = GLOW, Thickness = 1.8, Transparency = 0.15 })
win.Active = true
win.Selectable = true
mkDrag(win)

-- Animacion glow borde
local function startGlow()
    task.spawn(function()
        local t = 0
        while win.Parent do
            t = t + 0.3
            local s = 0.9 + math.abs(math.sin(math.rad(t * 40))) * 0.1
            wStroke.Color = Color3.fromRGB(120 + s * 40, 90 + s * 30, 200 + s * 50)
            task.wait(0.045)
        end
    end)
end

local hdr = new("Frame", {
    Parent = win,
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = PASTEL.DARK,
})
corner(hdr, 16)
new("UIGradient", { Parent = hdr, Rotation = 90, Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, PASTEL.DARK),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 35, 55)),
}) })
new("UIStroke", { Parent = hdr, Color = ACCENT, Thickness = 1, Transparency = 0.3 })

new("TextLabel", {
    Parent = hdr,
    Size = UDim2.new(1, -50, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "  ⚡ kn4  |  FFlag Injector",
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextColor3 = PASTEL.PEACH,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local closeBtn = new("TextButton", {
    Parent = hdr,
    Size = UDim2.fromOffset(20, 20),
    Position = UDim2.new(1, -24, 0, 10),
    BackgroundColor3 = PASTEL.DARK,
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextColor3 = PASTEL.PEACH,
})
corner(closeBtn, 5)
softHvr(closeBtn, Color3.fromRGB(220, 80, 80))

local minBtn = new("TextButton", {
    Parent = hdr,
    Size = UDim2.fromOffset(20, 20),
    Position = UDim2.new(1, -48, 0, 10),
    BackgroundColor3 = PASTEL.DARK,
    Text = "─",
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextColor3 = PASTEL.PEACH,
})
corner(minBtn, 5)
softHvr(minBtn, PASTEL.SKY)

local body = new("Frame", {
    Parent = win,
    Position = UDim2.new(0, 0, 0, 40),
    Size = UDim2.new(1, 0, 1, -40),
    BackgroundTransparency = 1,
})

-- Sidebar mas estrecha
local side = new("Frame", {
    Parent = body,
    Size = UDim2.new(0, 54, 1, 0),
    BackgroundColor3 = PASTEL.DARK,
})
corner(side, 12)
new("UIGradient", { Parent = side, Rotation = 90, Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, PASTEL.DARK),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 22, 35)),
}) })

local cnt = new("Frame", {
    Parent = body,
    Position = UDim2.new(0, 60, 0, 0),
    Size = UDim2.new(1, -66, 1, 0),
    BackgroundTransparency = 1,
})

local tabBtns = {}
local function mkTab(label, y)
    local b = new("TextButton", {
        Parent = side,
        Size = UDim2.new(1, -10, 0, 24),
        Position = UDim2.new(0, 5, 0, y),
        BackgroundColor3 = PASTEL.DARK,
        Text = label,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = PASTEL.CREAM,
    })
    corner(b, 6)
    softHvr(b, ACCENT)
    table.insert(tabBtns, b)
    return b
end

local tabF = mkTab("Flags", 6)
local tabL = mkTab("Log", 34)
local tabI = mkTab("Info", 62)

local function mkPage()
    local f = new("Frame", { Parent = cnt, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false })
    new("UICorner", { Parent = f, CornerRadius = UDim.new(0, 10) })
    return f
end

local pgF = mkPage()
local pgL = mkPage()
local pgI = mkPage()

local function showPage(idx)
    for i, btn in ipairs(tabBtns) do
        btn.BackgroundColor3 = (i == idx) and ACCENT or PASTEL.DARK
        btn.TextColor3 = (i == idx) and PASTEL.WHITE or PASTEL.CREAM
    end
    pgF.Visible = (idx == 1)
    pgL.Visible = (idx == 2)
    pgI.Visible = (idx == 3)
end

tabF.MouseButton1Click:Connect(function() showPage(1) end)
tabL.MouseButton1Click:Connect(function() showPage(2) end)
tabI.MouseButton1Click:Connect(function() showPage(3) end)
showPage(1)

-- ============= PAGINA FLAGS =============
local ffBox = new("TextBox", {
    Parent = pgF,
    Position = UDim2.new(0, 4, 0, 4),
    Size = UDim2.new(1, -8, 1, -80),
    MultiLine = true,
    ClearTextOnFocus = false,
    TextWrapped = true,
    Font = Enum.Font.Gotham,
    TextSize = 9,
    BackgroundColor3 = PASTEL.CARD,
    TextColor3 = PASTEL.CREAM,
    PlaceholderText = "Pegar JSON o lista de FastFlags...",
    PlaceholderColor3 = Color3.fromRGB(100, 95, 110),
})
corner(ffBox, 8)
new("UIStroke", { Parent = ffBox, Color = ACCENT, Thickness = 1, Transparency = 0.3 })

local szLbl = new("TextLabel", {
    Parent = pgF,
    Position = UDim2.new(0, 6, 1, -74),
    Size = UDim2.new(1, -12, 0, 14),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    TextSize = 8,
    TextColor3 = PASTEL.SKY,
    Text = "0 bytes",
    TextXAlignment = Enum.TextXAlignment.Left,
})
ffBox:GetPropertyChangedSignal("Text"):Connect(function()
    local t = ffBox.Text or ""
    szLbl.Text = string.format("%.1f KB | %d chars", #t / 1024, #t)
end)

local pBg = new("Frame", {
    Parent = pgF,
    Size = UDim2.new(1, -8, 0, 8),
    Position = UDim2.new(0, 4, 1, -56),
    BackgroundColor3 = PASTEL.DARK,
})
corner(pBg, 4)
local pFill = new("Frame", { Parent = pBg, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = ACCENT })
corner(pFill, 4)
new("UIGradient", { Parent = pFill, Rotation = 90, Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, GLOW),
    ColorSequenceKeypoint.new(1, ACCENT),
}) })

local pTxt = new("TextLabel", {
    Parent = pgF,
    Position = UDim2.new(0, 6, 1, -46),
    Size = UDim2.new(1, -12, 0, 12),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    TextSize = 8,
    TextColor3 = PASTEL.MINT,
    Text = "Listo",
    TextXAlignment = Enum.TextXAlignment.Left,
})

local function mkBtn(label, xs, xo, yo, accent)
    local b = new("TextButton", {
        Parent = pgF,
        Size = UDim2.new(0.5, -4, 0, 24),
        Position = UDim2.new(xs, xo, 1, yo),
        BackgroundColor3 = accent and ACCENT or PASTEL.CARD,
        Text = label,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = accent and PASTEL.WHITE or PASTEL.CREAM,
    })
    corner(b, 6)
    softHvr(b, accent and PASTEL.PEACH or ACCENT)
    return b
end

local pauseBtn  = mkBtn("⏸ Pausar", 0, 2, -22, false)
local cancelBtn = mkBtn("✕ Cancelar", 0.5, -2, -22, false)
local saveBtn   = mkBtn("💾 Sanitizar", 0, 2, 6, false)
local injectBtn = mkBtn("🚀 INYECTAR", 0.5, -2, 6, true)

-- ============= INYECCION =============
local hasSFF = type(setfflag) == "function"
local hasSFI = type(setfint) == "function"
local hasSFS = type(setfstring) == "function"

local PFXS = { "DFFlag","FFlag","SFFlag","DFInt","FInt","DFString","FString","FLog",
               "DFFlags","FFlags","DFInts","FInts","DFStrings","FStrings" }

local function stripPfx(k)
    for _, p in ipairs(PFXS) do
        if k:sub(1, #p) == p then return k:sub(#p + 1) end
    end
    return k
end

local function fkind(k)
    local lk = k:lower()
    if lk:find("flag") then return "bool"
    elseif lk:find("int") then return "int"
    else return "str" end
end

-- Limites ALTOS para bypass (sin restricciones)
local function safeValue(kind, vstr)
    if kind == "int" then
        local n = tonumber(vstr)
        if n then return math.floor(n) end
        return 999999999  -- default seguro
    end
    return vstr
end

local function trySet(key, val)
    local vstr = tostring(val)
    local kind = fkind(key)
    local safeVal = safeValue(kind, vstr)
    
    -- Intenta TODAS las variaciones posibles (bypass total)
    local attempts = {
        { setfflag, key, vstr },
        { setfflag, key, safeVal },
        { setfint, key, safeVal },
        { setfstring, key, vstr },
    }
    
    -- Intenta con y sin prefijo
    local name = stripPfx(key)
    if name ~= key then
        table.insert(attempts, { setfflag, name, vstr })
        table.insert(attempts, { setfint, name, safeVal })
        table.insert(attempts, { setfstring, name, vstr })
    end
    
    for _, a in ipairs(attempts) do
        local fn, k, v = a[1], a[2], a[3]
        if fn and type(fn) == "function" then
            local ok = pcall(fn, k, v)
            if ok then return true end
        end
    end
    
    -- Metodo fallback: setfflag con cualquier cast
    if hasSFF then
        -- Intenta forzar como booleano
        local bl = vstr:lower()
        if bl == "true" or bl == "1" or bl == "yes" then
            if pcall(setfflag, key, "True") then return true end
        elseif bl == "false" or bl == "0" or bl == "no" then
            if pcall(setfflag, key, "False") then return true end
        end
        -- Ultima opcion: string
        if pcall(setfflag, key, vstr) then return true end
        if pcall(setfflag, name, vstr) then return true end
    end
    
    return false
end

local function resolveInput(txt)
    local t = (txt or ""):match("^%s*(.-)%s*$"):gsub("#L%d+%-?%d*$", "")
    if t:lower():sub(-5) == ".json" then
        local ok, s = pcall(function() return readfile and readfile(t) end)
        if ok and type(s) == "string" and #s > 0 then return s end
    end
    if t:lower():sub(-4) == ".txt" then
        local ok, s = pcall(function() return readfile and readfile(t) end)
        if ok and type(s) == "string" and #s > 0 then return s end
    end
    return txt
end

local function parseJSONOrList(txt)
    -- Intenta JSON primero
    local ok, data = pcall(function() return HttpService:JSONDecode(txt) end)
    if ok and type(data) == "table" then
        return data
    end
    
    -- Parser de formato simple (clave=valor o "clave":"valor")
    local result = {}
    for line in txt:gmatch("[^\r\n]+") do
        line = line:gsub("//.*$", ""):gsub("/%*.-%*/", ""):gsub("^%s+", ""):gsub("%s+$", "")
        if #line > 0 then
            local k, v = line:match('^"([^"]+)"%s*:%s*"?([^",]+)"?$')
            if not k then k, v = line:match('^([^=%s]+)%s*=%s*(.+)$') end
            if not k then k, v = line:match('^%s*([%w_%-%.]+)%s*:?%s*(.*)$') end
            if k and v then
                k = k:gsub('^"', ''):gsub('"$', ''):gsub("^%s+", ""):gsub("%s+$", "")
                v = v:gsub('^"', ''):gsub('"$', ''):gsub("^%s+", ""):gsub("%s+$", "")
                result[k] = v
            end
        end
    end
    if next(result) then return result end
    return nil
end

local LATE_PAT = {
    "datasender", "raknet", "http", "batch", "task", "schedulertarget",
    "fps", "asset", "preload", "preloading", "numassets", "maxtopreload",
    "bandwidth", "clientpacket", "teleport", "clientasset"
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
            local isLate = false
            for _, pat in ipairs(LATE_PAT) do
                if lk:find(pat) then isLate = true break end
            end
            table.insert(isLate and late or early, { k = k, v = tostring(v) })
        end
    end
    local res = {}
    for _, p in ipairs(early) do res[#res + 1] = p end
    for _, p in ipairs(late) do res[#res + 1] = p end
    return res
end

local injState = { running = false, paused = false, cancel = false }
local INJECT_DELAY = 0.15  -- Inyeccion mas lenta para evitar crashes

local function doInject(txt)
    local src = resolveInput(txt)
    local data = parseJSONOrList(src)
    
    if not data then
        notify("Formato invalido - usar JSON o key=val", false)
        injectBtn.Text =  "INYECTAR"
        injectBtn.BackgroundColor3 = ACCENT
        injectBtn.Active = true
        return
    end
    
    local flags = buildList(data)
    local total = #flags
    
    if total == 0 then
        notify("No se encontraron flags", false)
        injectBtn.Text = " INYECTAR"
        injectBtn.BackgroundColor3 = ACCENT
        injectBtn.Active = true
        return
    end
    
    -- Limpiar logs previos
    if getgenv().Neo and getgenv().Neo.InjectLog then
        getgenv().Neo.InjectLog.clear()
    end
    
    task.spawn(function()
        injState.running = true
        injState.cancel = false
        injState.paused = false
        
        local done, good, bad = 0, 0, 0
        pTxt.Text = "Inyectando " .. total .. " flags..."
        
        for _, pair in ipairs(flags) do
            while injState.paused do
                pTxt.Text = "⏸ Pausado..."
                RunService.Heartbeat:Wait()
            end
            if injState.cancel then
                pTxt.Text = "✕ Cancelado (" .. done .. "/" .. total .. ")"
                break
            end
            
            local k, v = pair.k, pair.v
            local ok = pcall(function()
                local success = trySet(k, v)
                if success then
                    good = good + 1
                    if getgenv().Neo and getgenv().Neo.InjectLog then
                        getgenv().Neo.InjectLog.addSuccess(k, v)
                    end
                else
                    bad = bad + 1
                    if getgenv().Neo and getgenv().Neo.InjectLog then
                        getgenv().Neo.InjectLog.addFailed(k, v, "setfn err")
                    end
                end
            end)
            if not ok then
                bad = bad + 1
                if getgenv().Neo and getgenv().Neo.InjectLog then
                    getgenv().Neo.InjectLog.addFailed(k, v, "pcall err")
                end
            end
            
            done = done + 1
            
            if done % 5 == 0 or done == total then
                local pct = done / total
                TweenService:Create(pFill, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(pct, 0, 1, 0)
                }):Play()
                pTxt.Text = string.format("%.0f%% | %d/%d | ✓ %d | ✕ %d",
                    pct * 100, done, total, good, bad)
            end
            
            -- Delay lento para evitar crashes por buffer size 0 o valores rotos
            RunService.Heartbeat:Wait()
            task.wait(INJECT_DELAY)
        end
        
        pFill.Size = UDim2.new(1, 0, 1, 0)
        local msg = string.format("✓ %d  |  ✕ %d  |  Total %d", good, bad, total)
        pTxt.Text = msg
        notify(msg, true)
        
        -- Generar reporte
        if getgenv().Neo and getgenv().Neo.InjectLog then
            local report = getgenv().Neo.InjectLog.getReport()
            if writefile then
                writefile("KyroDev-InjectLog.txt", report)
            end
        end
        
        injState.running = false
        injectBtn.Text = "INYECTAR"
        injectBtn.BackgroundColor3 = ACCENT
        injectBtn.Active = true
    end)
end

injectBtn.MouseButton1Click:Connect(function()
    if injState.running then return end
    injectBtn.Text = "Inyectando..."
    injectBtn.BackgroundColor3 = PASTEL.CARD
    injectBtn.Active = false
    pFill.Size = UDim2.new(0, 0, 1, 0)
    pTxt.Text = "Iniciando..."
    injState.cancel = false
    injState.paused = false
    local ok, err = pcall(function() doInject(ffBox.Text) end)
    if not ok then
        notify("Error: " .. tostring(err), false)
        injectBtn.Text = " INYECTAR"
        injectBtn.BackgroundColor3 = ACCENT
        injectBtn.Active = true
    end
end)

pauseBtn.MouseButton1Click:Connect(function()
    if not injState.running then return end
    injState.paused = not injState.paused
    pauseBtn.Text = injState.paused and "▶ Reanudar" or "⏸ Pausar"
end)

cancelBtn.MouseButton1Click:Connect(function()
    if injState.running then injState.cancel = true end
da