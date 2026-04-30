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
local player           = Players.LocalPlayer
local playerGui        = player:WaitForChild("PlayerGui")

do
    local p = playerGui:FindFirstChild("KyroDev")
    if p then p:Destroy() end
end

local PASTEL = {
    ROSE    = Color3.fromRGB(255, 200, 205),
    PEACH   = Color3.fromRGB(255, 218, 185),
    LAVENDER= Color3.fromRGB(216, 191, 216),
    MINT    = Color3.fromRGB(189, 236, 220),
    CREAM   = Color3.fromRGB(255, 253, 208),
    SKY     = Color3.fromRGB(173, 216, 230),
    WHITE   = Color3.new(0.98, 0.98, 0.99),
    DEEP    = Color3.fromRGB(35, 30, 50),
    PANEL   = Color3.fromRGB(45, 40, 60),
    CARD    = Color3.fromRGB(55, 50, 70),
    DARK    = Color3.fromRGB(28, 25, 40),
}
local ACCENT = Color3.fromRGB(120, 80, 220)
local GLOW   = Color3.fromRGB(180, 140, 240)

local fps, frameMs, cpuMs = 60, 16, 16

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

local function softHvr(btn, accent)
    btn.AutoButtonColor = false
    local orig = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25), { BackgroundColor3 = accent or GLOW, TextColor3 = PASTEL.WHITE }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), { BackgroundColor3 = orig, TextColor3 = PASTEL.CREAM }):Play()
    end)
end

local function mkDrag(frame)
    local drag, sPos, sMouse = false, nil, nil
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag, sPos, sMouse = true, frame.Position, i.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - sMouse
            frame.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
        end
    end)
    frame.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
end

local notifQueue = {}
local function notify(txt, success)
    local n = new("Frame", { Parent = playerGui, Size = UDim2.fromOffset(340, 50), Position = UDim2.new(0.5, -170, 1, -100), BackgroundColor3 = PASTEL.PANEL, ZIndex = 100 })
    corner(n, 12)
    new("UIStroke", { Parent = n, Color = success and GLOW or ACCENT, Thickness = 1.5, Transparency = 0.3 })
    new("TextLabel", { Parent = n, Size = UDim2.fromOffset(30, 30), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, Text = success and "✓" or "⚡", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = success and PASTEL.MINT or PASTEL.PEACH })
    local lbl = new("TextLabel", { Parent = n, Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 48, 0, 0), BackgroundTransparency = 1, Text = txt, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = PASTEL.CREAM, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center })
    n.BackgroundTransparency = 1
    n.Position = UDim2.new(0.5, -170, 1, -80)
    TweenService:Create(n, TweenInfo.new(0.35, Enum.EasingStyle.Back), { BackgroundTransparency = 0, Position = UDim2.new(0.5, -170, 1, -100 - (#notifQueue * 65)) }):Play()
    table.insert(notifQueue, n)
    task.delay(3.5, function()
        if n and n.Parent then
            TweenService:Create(n, TweenInfo.new(0.25), { BackgroundTransparency = 1, Position = UDim2.new(0.5, -170, 1, -120) }):Play()
            task.delay(0.3, function() if n then n:Destroy() end end)
        end
    end)
end

local gui = new("ScreenGui", { Parent = playerGui, Name = "KyroDev", IgnoreGuiInset = true, ResetOnSpawn = false })
local overlay = new("Frame", { Parent = gui, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, Visible = false })

local dock = new("Frame", { Parent = gui, Size = UDim2.fromOffset(44, 44), Position = UDim2.new(1, -56, 0.5, -22), BackgroundColor3 = PASTEL.DARK, Visible = true })
corner(dock, 22)
new("UIStroke", { Parent = dock, Color = ACCENT, Thickness = 1.2, Transparency = 0.3 })
new("TextButton", { Parent = dock, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "✨", Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = PASTEL.CREAM })
mkDrag(dock)

local win = new("Frame", { Parent = gui, Size = UDim2.fromOffset(340, 420), Position = UDim2.new(0.5, -170, 0.5, -210), BackgroundColor3 = PASTEL.DEEP, Visible = false })
corner(win, 16)
local wStroke = new("UIStroke", { Parent = win, Color = GLOW, Thickness = 1.8, Transparency = 0.15 })
win.Active = true
win.Selectable = true
mkDrag(win)

task.spawn(function()
    local t = 0
    while win.Parent do
        t = t + 0.3
        local s = 0.9 + math.abs(math.sin(math.rad(t * 40))) * 0.1
        wStroke.Color = Color3.fromRGB(120 + s * 40, 90 + s * 30, 200 + s * 50)
        task.wait(0.045)
    end
end)

local hdr = new("Frame", { Parent = win, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = PASTEL.DARK })
corner(hdr, 16)
new("TextLabel", { Parent = hdr, Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, Text = "  ⚡ KenyahSENCE  |  FFlag Injector", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = PASTEL.PEACH, TextXAlignment = Enum.TextXAlignment.Left })

local closeBtn = new("TextButton", { Parent = hdr, Size = UDim2.fromOffset(20, 20), Position = UDim2.new(1, -24, 0, 10), BackgroundColor3 = PASTEL.DARK, Text = "✕", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = PASTEL.PEACH })
corner(closeBtn, 5)
softHvr(closeBtn, Color3.fromRGB(220, 80, 80))

local minBtn = new("TextButton", { Parent = hdr, Size = UDim2.fromOffset(20, 20), Position = UDim2.new(1, -48, 0, 10), BackgroundColor3 = PASTEL.DARK, Text = "─", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = PASTEL.PEACH })
corner(minBtn, 5)
softHvr(minBtn, PASTEL.SKY)

local body = new("Frame", { Parent = win, Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(1, 0, 1, -40), BackgroundTransparency = 1 })

local side = new("Frame", { Parent = body, Size = UDim2.new(0, 54, 1, 0), BackgroundColor3 = PASTEL.DARK })
corner(side, 12)

local cnt = new("Frame", { Parent = body, Position = UDim2.new(0, 60, 0, 0), Size = UDim2.new(1, -66, 1, 0), BackgroundTransparency = 1 })

local tabBtns = {}
local function mkTab(label, y)
    local b = new("TextButton", { Parent = side, Size = UDim2.new(1, -10, 0, 24), Position = UDim2.new(0, 5, 0, y), BackgroundColor3 = PASTEL.DARK, Text = label, Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = PASTEL.CREAM })
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
    corner(f, 10)
    return f
end

local pgF, pgL, pgI = mkPage(), mkPage(), mkPage()

local function showPage(idx)
    for i, btn in ipairs(tabBtns) do
        btn.BackgroundColor3 = (i == idx) and ACCENT or PASTEL.DARK
        btn.TextColor3 = (i == idx) and PASTEL.WHITE or PASTEL.CREAM
    end
    pgF.Visible, pgL.Visible, pgI.Visible = (idx == 1), (idx == 2), (idx == 3)
end

tabF.MouseButton1Click:Connect(function() showPage(1) end)
tabL.MouseButton1Click:Connect(function() showPage(2) end)
tabI.MouseButton1Click:Connect(function() showPage(3) end)
showPage(1)

local ffBox = new("TextBox", { Parent = pgF, Position = UDim2.new(0, 4, 0, 4), Size = UDim2.new(1, -8, 1, -80), MultiLine = true, ClearTextOnFocus = false, TextWrapped = true, Font = Enum.Font.Gotham, TextSize = 9, BackgroundColor3 = PASTEL.CARD, TextColor3 = PASTEL.CREAM, PlaceholderText = "Pegar JSON o flags..." })
corner(ffBox, 8)

local szLbl = new("TextLabel", { Parent = pgF, Position = UDim2.new(0, 6, 1, -74), Size = UDim2.new(1, -12, 0, 14), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 8, TextColor3 = PASTEL.SKY, Text = "0 bytes", TextXAlignment = Enum.TextXAlignment.Left })
ffBox:GetPropertyChangedSignal("Text"):Connect(function() szLbl.Text = string.format("%.1f KB | %d chars", #ffBox.Text / 1024, #ffBox.Text) end)

local pBg = new("Frame", { Parent = pgF, Size = UDim2.new(1, -8, 0, 8), Position = UDim2.new(0, 4, 1, -56), BackgroundColor3 = PASTEL.DARK })
corner(pBg, 4)
local pFill = new("Frame", { Parent = pBg, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = ACCENT })
corner(pFill, 4)

local pTxt = new("TextLabel", { Parent = pgF, Position = UDim2.new(0, 6, 1, -46), Size = UDim2.new(1, -12, 0, 12), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 8, TextColor3 = PASTEL.MINT, Text = "Listo", TextXAlignment = Enum.TextXAlignment.Left })

local function mkBtn(label, xs, xo, yo, accent)
    local b = new("TextButton", { Parent = pgF, Size = UDim2.new(0.5, -4, 0, 24), Position = UDim2.new(xs, xo, 1, yo), BackgroundColor3 = accent and ACCENT or PASTEL.CARD, Text = label, Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = accent and PASTEL.WHITE or PASTEL.CREAM })
    corner(b, 6)
    softHvr(b, accent and PASTEL.PEACH or ACCENT)
    return b
end

local pauseBtn  = mkBtn("⏸ Pausar", 0, 2, -22, false)
local cancelBtn = mkBtn("✕ Cancelar", 0.5, -2, -22, false)
local saveBtn   = mkBtn("💾 Sanitizar", 0, 2, 6, false)
local injectBtn = mkBtn("🚀 INYECTAR", 0.5, -2, 6, true)

local hasSFF, hasSFI, hasSFS = type(setfflag) == "function", type(setfint) == "function", type(setfstring) == "function"
local PFXS = { "DFFlag","FFlag","SFFlag","DFInt","FInt","DFString","FString","FLog", "DFFlags","FFlags","DFInts","FInts","DFStrings","FStrings" }

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

local function safeValue(kind, vstr)
    if kind == "int" then local n = tonumber(vstr) if n then return math.floor(n) end return 999999999 end
    return vstr
end

local function trySet(key, val)
    local vstr, kind = tostring(val), fkind(key)
    local safeVal = safeValue(kind, vstr)
    local name = stripPfx(key)
    local attempts = {
        {setfflag, key, vstr}, {setfflag, key, safeVal}, {setfint, key, safeVal}, {setfstring, key, vstr},
    }
    if name ~= key then
        table.insert(attempts, {setfflag, name, vstr})
        table.insert(attempts, {setfint, name, safeVal})
        table.insert(attempts, {setfstring, name, vstr})
    end
    for _, a in ipairs(attempts) do
        local fn, k, v = a[1], a[2], a[3]
        if fn and type(fn) == "function" then
            local ok = pcall(fn, k, v)
            if ok then return true end
        end
    end
    if hasSFF then
        local bl = vstr:lower()
        if bl == "true" or bl == "1" or bl == "yes" then if pcall(setfflag, key, "True") then return true end
        elseif bl == "false" or bl == "0" or bl == "no" then if pcall(setfflag, key, "False") then return true end
        end
        if pcall(setfflag, key, vstr) then return true end
        if pcall(setfflag, name, vstr) then return true end
    end
    return false
end

local function resolveInput(txt)
    local t = (txt or ""):match("^%s*(.-)%s*$"):gsub("#L%d+%-?%d*$", "")
    if t:lower():sub(-5) == ".json" or t:lower():sub(-4) == ".txt" then
        local ok, s = pcall(function() return readfile and readfile(t) end)
        if ok and type(s) == "string" and #s > 0 then return s end
    end
    return txt
end

local function parseJSONOrList(txt)
    local ok, data = pcall(function() return HttpService:JSONDecode(txt) end)
    if ok and type(data) == "table" then return data end
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
    return next(result) and result or nil
end

local LATE_PAT = {"datasender","raknet","http","batch","task","schedulertarget","fps","asset","preload","preloading","numassets","maxtopreload","bandwidth","clientpacket","teleport","clientasset"}

local function buildList(data)
    local seen, early, late = {}, {}, {}
    for k, v in pairs(data) do
        local name = stripPfx(k)
        if not seen[name] then
            seen[name] = true
            local lk, isLate = name:lower(), false
            for _, pat in ipairs(LATE_PAT) do
                if lk:find(pat) then isLate = true break end
            end
            table.insert(isLate and late or early, {k = k, v = tostring(v)})
        end
    end
    local res = {}
    for _, p in ipairs(early) do res[#res + 1] = p end
    for _, p in ipairs(late) do res[#res + 1] = p end
    return res
end

local injState = { running = false, paused = false, cancel = false }
local INJECT_DELAY = 0.15

if getgenv().Neo and getgenv().Neo.InjectLog then getgenv().Neo.InjectLog.clear() end

local function doInject(txt)
    local src = resolveInput(txt)
    local data = parseJSONOrList(src)
    if not data then notify("Formato invalido - usar JSON o key=val", false) injectBtn.Text = "🚀 INYECTAR" injectBtn.Active = true return end
    local flags = buildList(data)
    local total = #flags
    if total == 0 then notify("No se encontraron flags", false) injectBtn.Text = "🚀 INYECTAR" injectBtn.Active = true return end
    task.spawn(function()
        injState.running, injState.cancel, injState.paused = true, false, false
        local done, good, bad = 0, 0, 0
        pTxt.Text = "Inyectando " .. total .. " flags..."
        for _, pair in ipairs(flags) do
            while injState.paused do pTxt.Text = "⏸ Pausado..." RunService.Heartbeat:Wait() end
            if injState.cancel then pTxt.Text = "✕ Cancelado (" .. done .. "/" .. total .. ")" break end
            local k, v = pair.k, pair.v
            local ok = pcall(function()
                local success = trySet(k, v)
                if success then
                    good = good + 1
                    if getgenv().Neo and getgenv().Neo.InjectLog then getgenv().Neo.InjectLog.addSuccess(k, v) end
                else
                    bad = bad + 1
                    if getgenv().Neo and getgenv().Neo.InjectLog then getgenv().Neo.InjectLog.addFailed(k, v, "setfn err") end
                end
            end)
            if not ok then
                bad = bad + 1
                if getgenv().Neo and getgenv().Neo.InjectLog then getgenv().Neo.InjectLog.addFailed(k, v, "pcall err") end
            end
            done = done + 1
            if done % 5 == 0 or done == total then
                local pct = done / total
                TweenService:Create(pFill, TweenInfo.new(0.15), { Size = UDim2.new(pct, 0, 1, 0) }):Play()
                pTxt.Text = string.format("%.0f%% | %d/%d | ✓ %d | ✕ %d", pct * 100, done, total, good, bad)
            end
            RunService.Heartbeat:Wait()
            task.wait(INJECT_DELAY)
        end
        pFill.Size = UDim2.new(1, 0, 1, 0)
        local msg = string.format("✓ %d  |  ✕ %d  |  Total %d", good, bad, total)
        pTxt.Text = msg
        notify(msg, true)
        if getgenv().Neo and getgenv().Neo.InjectLog then
            local report = getgenv().Neo.InjectLog.getReport()
            if writefile then writefile("KyroDev-InjectLog.txt", report) end
        end
        injState.running = false
        injectBtn.Text = "🚀 INYECTAR"
        injectBtn.Active = true
    end)
end

local function sanitize()
    local src = resolveInput(ffBox.Text)
    local ok, data = pcall(function() return HttpService:JSONDecode(src) end)
    if not ok or type(data) ~= "table" then notify("JSON invalido", false) return end
    local out = {}
    for k, v in pairs(data) do
        local s, sl = tostring(v), tostring(v):lower()
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
    if saved then notify("Guardado: KyroDev-sanitized.json", true) else ffBox.Text = enc notify("Pegado en caja", true) end
end

injectBtn.MouseButton1Click:Connect(function()
    if injState.running then return end
    injectBtn.Text, injectBtn.Active = "Inyectando...", false
    pFill.Size, pTxt.Text = UDim2.new(0, 0, 1, 0), "Iniciando..."
    injState.cancel, injState.paused = false, false
    local ok, err = pcall(function() doInject(ffBox.Text) end)
    if not ok then notify("Error: " .. tostring(err), false) injectBtn.Text, injectBtn.Active = "🚀 INYECTAR", true end
end)

pauseBtn.MouseButton1Click:Connect(function()
    if not injState.running then return end
    injState.paused = not injState.paused
    pauseBtn.Text = injState.paused and "▶ Reanudar" or "⏸ Pausar"
end)

cancelBtn.MouseButton1Click:Connect(function()
    if injState.running then injState.cancel = true end
end)

saveBtn.MouseButton1Click:Connect(sanitize)

closeBtn.MouseButton1Click:Connect(function() win.Visible, overlay.Visible, dock.Visible = false, false, true end)
minBtn.MouseButton1Click:Connect(function() win.Visible, overlay.Visible, dock.Visible = false, false, true end)
dock:GetChildren()[1].MouseButton1Click:Connect(function() win.Visible, overlay.Visible, dock.Visible = true, true, false end)
overlay.MouseButton1Click:Connect(function() win.Visible, overlay.Visible, dock.Visible = false, false, true end)

RunService.RenderStepped:Connect(function(dt) fps, frameMs = math.clamp(math.floor(1 / dt), 1, 240), math.floor(dt * 1000 * 10) / 10 end)
RunService.Heartbeat:Connect(function(dt) cpuMs = math.floor(dt * 1000 * 10) / 10 end)

if getgenv().Neo then
    task.spawn(function()
        while perfOv or true do
            task.wait(0.3)
        end
    end)
end

notify("⚡ kn4 - FFlag Injector cargado", true)
