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

-- COLORES PASTEL
local PASTEL = {
    PEACH  = Color3.fromRGB(255, 218, 185),
    MINT   = Color3.fromRGB(189, 236, 220),
    CREAM  = Color3.fromRGB(255, 253, 208),
    SKY    = Color3.fromRGB(173, 216, 230),
    WHITE  = Color3.new(0.98, 0.98, 0.99),
    DEEP   = Color3.fromRGB(38, 32, 52),
    PANEL  = Color3.fromRGB(48, 42, 64),
    CARD   = Color3.fromRGB(58, 52, 74),
    DARK   = Color3.fromRGB(32, 27, 44),
}
local ACCENT = Color3.fromRGB(142, 100, 220)
local GLOW   = Color3.fromRGB(190, 150, 245)

-- Retrocompatibilidad
local C_HOT = ACCENT
local C_DARK = PASTEL.DARK
local C_DIM = PASTEL.CARD
local C_BG = PASTEL.DEEP
local C_PANEL = PASTEL.PANEL
local C_CARD = PASTEL.CARD
local C_WHITE = PASTEL.WHITE
local C_TEXT = PASTEL.SKY
local C_GLOW = GLOW

local fps = 60
local frameMs = 16
local cpuMs = 16

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
        Parent = o, Rotation = rot or 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, PASTEL.DARK),
            ColorSequenceKeypoint.new(0.5, PASTEL.CARD),
            ColorSequenceKeypoint.new(1, PASTEL.PANEL),
        })
    })
end

local function hvr(btn)
    btn.AutoButtonColor = false
    local orig = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = GLOW, TextColor3 = PASTEL.WHITE }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25), { BackgroundColor3 = orig, TextColor3 = PASTEL.CREAM }):Play()
    end)
end

local function mkDrag(frame)
    local drag, inp, sPos, sMouse = false, nil, nil, nil
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag, sPos, sMouse, inp = true, frame.Position, i.Position, i
        end
    end)
    frame.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            inp = i
        end
    end)
    frame.InputEnded:Connect(function(i) if i == inp then drag = false end end)
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
        Parent = playerGui, Size = UDim2.fromOffset(310, 40),
        Position = UDim2.new(0.5, -155, 1, -88 - #notifQueue * 45),
        BackgroundColor3 = PASTEL.PANEL, ZIndex = 30,
    })
    corner(n, 8)
    rgrad(n, 0)
    new("UIStroke", { Parent = n, Color = success and GLOW or ACCENT, Thickness = 1.2, Transparency = 0.1 })
    new("TextLabel", {
        Parent = n, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = txt, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = PASTEL.WHITE,
        ZIndex = 31,
    })
    TweenService:Create(n, TweenInfo.new(0.18), { Position = UDim2.new(0.5, -155, 1, -108 - #notifQueue * 45) }):Play()
    table.insert(notifQueue, n)
    task.delay(2.8, function()
        TweenService:Create(n, TweenInfo.new(0.18), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(n, TweenInfo.new(0.18), { TextTransparency = 1 }):Play()
        task.delay(0.2, function()
            n:Destroy()
            for ii, vv in ipairs(notifQueue) do if vv == n then table.remove(notifQueue, ii) break end end
        end)
    end)
end

local gui = new("ScreenGui", {
    Parent = playerGui, Name = "KyroDev", IgnoreGuiInset = true, ResetOnSpawn = false,
})

local overlay = new("Frame", {
    Parent = gui, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1, Visible = false,
})

-- REDUCIDO: 300x340
local dock = new("Frame", {
    Parent = gui, Size = UDim2.fromOffset(38, 38), Position = UDim2.new(1, -50, 0.5, -19),
    BackgroundColor3 = PASTEL.CARD, Visible = true,
})
dock.Active = true
corner(dock, 19)
rgrad(dock)
new("UIStroke", { Parent = dock, Color = ACCENT, Thickness = 1.2, Transparency = 0.1 })
local dockBtn = new("TextButton", {
    Parent = dock, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    Text = "K", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = PASTEL.CREAM,
})
mkDrag(dock)
hvr(dockBtn)

-- REDUCIDO: 300x340
local win = new("Frame", {
    Parent = gui, Size = UDim2.fromOffset(300, 340), Position = UDim2.new(0.5, -150, 0.5, -170),
    BackgroundColor3 = PASTEL.DEEP, Visible = false,
})
corner(win, 13)
rgrad(win, 130)
local wStroke = new("UIStroke", { Parent = win, Color = GLOW, Thickness = 1.6, Transparency = 0.08 })
win.Active = true
win.Selectable = true
mkDrag(win)

-- Glow animacion
local function startGlow()
    task.spawn(function()
        local t = 0
        while win.Parent do
            t = t + 0.35
            local s = 0.85 + math.abs(math.sin(math.rad(t * 50))) * 0.15
            wStroke.Color = Color3.fromRGB(255, math.floor(40 + s * 50), math.floor(40 + s * 40))
            task.wait(0.05)
        end
    end)
end

local hdr = new("Frame", { Parent = win, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = PASTEL.DARK })
corner(hdr, 13)
rgrad(hdr, 0)
new("UIStroke", { Parent = hdr, Color = ACCENT, Thickness = 1, Transparency = 0.25 })

new("TextLabel", {
    Parent = hdr, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    Text = "KenyahSENCE | FFlag Injector", Font = Enum.Font.GothamBold,
    TextSize = 12, TextColor3 = PASTEL.CREAM,
})

local closeBtn = new("TextButton", {
    Parent = hdr, Size = UDim2.fromOffset(19, 19), Position = UDim2.new(1, -24, 0, 8),
    BackgroundColor3 = PASTEL.DIM, Text = "X", Font = Enum.Font.GothamBold, TextSize = 10,
    TextColor3 = PASTEL.CREAM,
})
corner(closeBtn, 5)
hvr(closeBtn)

local minBtn = new("TextButton", {
    Parent = hdr, Size = UDim2.fromOffset(19, 19), Position = UDim2.new(1, -47, 0, 8),
    BackgroundColor3 = PASTEL.DIM, Text = "-", Font = Enum.Font.GothamBold, TextSize = 10,
    TextColor3 = PASTEL.CREAM,
})
corner(minBtn, 5)
hvr(minBtn)

local body = new("Frame", { Parent = win, Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(1, 0, 1, -36), BackgroundTransparency = 1 })

local side = new("Frame", { Parent = body, Size = UDim2.new(0, 54, 1, 0), BackgroundColor3 = PASTEL.PANEL })
corner(side, 10)
rgrad(side, 90)

local cnt = new("Frame", { Parent = body, Position = UDim2.new(0, 60, 0, 0), Size = UDim2.new(1, -66, 1, 0), BackgroundTransparency = 1 })

local tabF = new("TextButton", {
    Parent = side, Size = UDim2.new(1, -8, 0, 22), Position = UDim2.new(0, 4, 0, 4),
    BackgroundColor3 = PASTEL.DARK, Text = "Flags", Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = PASTEL.CREAM,
})
corner(tabF, 5)
hvr(tabF)

local tabL = new("TextButton", {
    Parent = side, Size = UDim2.new(1, -8, 0, 22), Position = UDim2.new(0, 4, 0, 29),
    BackgroundColor3 = PASTEL.DARK, Text = "Log[+/-]", Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = PASTEL.CREAM,
})
corner(tabL, 5)
hvr(tabL)

local tabI = new("TextButton", {
    Parent = side, Size = UDim2.new(1, -8, 0, 22), Position = UDim2.new(0, 4, 0, 54),
    BackgroundColor3 = PASTEL.DARK, Text = "Info", Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = PASTEL.CREAM,
})
corner(tabI, 5)
hvr(tabI)

local pgF = new("Frame", { Parent = cnt, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })
local pgL = new("Frame", { Parent = cnt, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false })
local pgI = new("Frame", { Parent = cnt, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false })

tabF.MouseButton1Click:Connect(function() pgF.Visible, pgL.Visible, pgI.Visible = true, false, false
    tabF.BackgroundColor3, tabL.BackgroundColor3, tabI.BackgroundColor3 = PASTEL.DARK, PASTEL.CARD, PASTEL.CARD end)
tabL.MouseButton1Click:Connect(function() pgF.Visible, pgL.Visible, pgI.Visible = false, true, false
    tabF.BackgroundColor3, tabL.BackgroundColor3, tabI.BackgroundColor3 = PASTEL.CARD, PASTEL.DARK, PASTEL.CARD end)
tabI.MouseButton1Click:Connect(function() pgF.Visible, pgL.Visible, pgI.Visible = false, false, true
    tabF.BackgroundColor3, tabL.BackgroundColor3, tabI.BackgroundColor3 = PASTEL.CARD, PASTEL.CARD, PASTEL.DARK end)

-- === PAGINA FLAGS ===
local ffBox = new("TextBox", {
    Parent = pgF, Size = UDim2.new(1, -4, 1, -110), Position = UDim2.new(0, 2, 0, 3),
    MultiLine = true, ClearTextOnFocus = false, TextWrapped = true,
    Font = Enum.Font.Gotham, TextSize = 10, BackgroundColor3 = PASTEL.CARD,
    TextColor3 = PASTEL.CREAM, PlaceholderText = "JSON o flags...",
})
corner(ffBox, 7)
new("UIStroke", { Parent = ffBox, Color = ACCENT, Thickness = 1, Transparency = 0.2 })

local szLbl = new("TextLabel", {
    Parent = pgF, Size = UDim2.new(1, -4, 0, 12), Position = UDim2.new(0, 2, 1, -74),
    BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 8,
    TextColor3 = PASTEL.SKY, Text = "0 KB", TextXAlignment = Enum.TextXAlignment.Left,
})
ffBox:GetPropertyChangedSignal("Text"):Connect(function()
    local t = ffBox.Text or ""
    szLbl.Text = string.format("%.1f KB | %d chars", #t / 1024, #t)
end)

local pBg = new("Frame", {
    Parent = pgF, Size = UDim2.new(1, -4, 0, 6), Position = UDim2.new(0, 2, 1, -54),
    BackgroundColor3 = PASTEL.DARK,
})
corner(pBg, 3)
local pFill = new("Frame", { Parent = pBg, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = ACCENT })
corner(pFill, 3)

local pTxt = new("TextLabel", {
    Parent = pgF, Size = UDim2.new(1, -4, 0, 12), Position = UDim2.new(0, 2, 1, -44),
    BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 8,
    TextColor3 = PASTEL.MINT, Text = "Listo", TextXAlignment = Enum.TextXAlignment.Left,
})

local function mkBtn(lbl, xs, xo, yo, ac)
    local b = new("TextButton", {
        Parent = pgF, Size = UDim2.new(0.5, -3, 0, 21), Position = UDim2.new(xs, xo, 1, yo),
        BackgroundColor3 = ac and ACCENT or PASTEL.CARD, Text = lbl,
        Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = ac and PASTEL.WHITE or PASTEL.CREAM,
    })
    corner(b, 5)
    if ac then rgrad(b, 0) end
    hvr(b)
    return b
end

local pauseBtn = mkBtn("Pausa", 0, 2, -20, false)
local cancelBtn = mkBtn("Cancelar", 0.5, -2, -20, false)
local saveBtn = mkBtn("Sanitizar", 0, 2, 4, false)
local injectBtn = mkBtn("INJECT", 0.5, -2, 4, true)

-- === INYECCION ===
local hasSFF = type(setfflag) == "function"
local hasSFI = type(setfint) == "function"
local hasSFS = type(setfstring) == "function"
local PFXS = { "DFFlag","FFlag","SFFlag","DFInt","FInt","DFString","FString","FLog" }

local function stripPfx(k)
    for _, p in ipairs(PFXS) do if k:sub(1, #p) == p then return k:sub(#p + 1) end end
    return k
end

local function fkind(k)
    for _, p in ipairs(PFXS) do
        if k:sub(1, #p) == p then
            local l = p:lower()
            if l:find("flag") then return "bool" elseif l:find("int") then return "int" else return "str" end
        end
    end
    return "str"
end

-- DELAY ANTI-CRASH (0.15s)
local INJECT_DELAY = 0.15

local function trySet(key, val)
    local vstr, kind = tostring(val), fkind(key)
    local name = stripPfx(key)
    local function attempt(fn, ...)
        return fn and type(fn) == "function" and pcall(fn, ...)
    end
    if kind == "int" then
        local n = tonumber(vstr) or 999999999
        if hasSFI and attempt(setfint, key, n) then return true end
        if hasSFI and attempt(setfint, name, n) then return true end
        if hasSFF and attempt(setfflag, key, tostring(n)) then return true end
        if hasSFF and attempt(setfflag, name, tostring(n)) then return true end
    end
    local bl = vstr:lower()
    if bl == "true" or bl == "1" or bl == "yes" then
        if hasSFF and (attempt(setfflag, key, "True") or attempt(setfflag, name, "True")) then return true end
    elseif bl == "false" or bl == "0" or bl == "no" then
        if hasSFF and (attempt(setfflag, key, "False") or attempt(setfflag, name, "False")) then return true end
    end
    if hasSFF and (attempt(setfflag, key, vstr) or attempt(setfflag, name, vstr)) then return true end
    if hasSFS and (attempt(setfstring, key, vstr) or attempt(setfstring, name, vstr)) then return true end
    return false
end

local function resolveInput(txt)
    local t = (txt or ""):match("^%s*(.-)%s*$"):gsub("#L%d+%-?%d*$", "")
    if t:lower():match("%.json$") or t:lower():match("%.txt$") then
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
        local k, v = l:match('"([^"]+)"%s*:%s*"?([^",]+)"?$') or l:match('^([^=%s]+)%s*=%s*(.+)$')
        if k and v then
            v = v:gsub('^["\']', ""):gsub('["\']$', ""):gsub("%s+$", "")
            tbl[k] = v
        end
    end
    return next(tbl) and tbl or nil
end

local LATE_PAT = {
    "datasender","raknet","http","batch","task","schedulertarget",
    "fps","asset","preload","preloading","numassets","maxtopreload",
    "bandwidth","clientpacket","teleport","clientasset",
}

local function buildList(data)
    local seen, early, late = {}, {}, {}
    for k, v in pairs(data) do
        local name = stripPfx(k)
        if not seen[name] then
            seen[name] = true
            local isLate = false
            for _, p in ipairs(LATE_PAT) do
                if name:lower():find(p) then isLate = true break end
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

local function doInject(txt)
    local src = resolveInput(txt)
    local ok, data = pcall(function() return HttpService:JSONDecode(src) end)
    if not ok or type(data) ~= "table" then
        data = parseFB(src)
        if not data then notify("Formato invalido", false)
            injectBtn.Text, injectBtn.Active = "INJECT", true
            return
        end
    end
    local flags = buildList(data)
    local total = #flags
    if total == 0 then notify("Sin flags", false)
        injectBtn.Text, injectBtn.Active = "INJECT", true
        return
    end
    task.spawn(function()
        injState.running, injState.cancel, injState.paused = true, false, false
        local done, good, bad = 0, 0, 0
        pTxt.Text = "Inyectando " .. total .. " flags..."
        for _, p in ipairs(flags) do
            while injState.paused do pTxt.Text = "Pausado..." RunService.Heartbeat:Wait() end
            if injState.cancel then pTxt.Text = "Cancelado " .. done .. "/" .. total break end
            local k, v = p.k, p.v
            local ok = pcall(function()
                if trySet(k, v) then
                    good = good + 1
                    if getgenv().Neo and getgenv().Neo.InjectLog then
                        getgenv().Neo.InjectLog.addSuccess(k, v)
                    end
                else
                    bad = bad + 1
                    if getgenv().Neo and getgenv().Neo.InjectLog then
                        getgenv().Neo.InjectLog.addFailed(k, v, "err")
                    end
                end
            end)
            if not ok then
                bad = bad + 1
                if getgenv().Neo and getgenv().Neo.InjectLog then
                    getgenv().Neo.InjectLog.addFailed(k, v, "pcall")
                end
            end
            done = done + 1
            if done % 3 == 0 or done == total then
                local pc = done / total
                TweenService:Create(pFill, TweenInfo.new(0.12), { Size = UDim2.new(pc, 0, 1, 0) }):Play()
                pTxt.Text = string.format("%.0f%% | %d/%d | ✓ %d | ✕ %d", pc * 100, done, total, good, bad)
            end
            RunService.Heartbeat:Wait()
            task.wait(INJECT_DELAY)
        end
        pFill.Size = UDim2.new(1, 0, 1, 0)
        local msg = string.format("✓ %d  ✕ %d  Total %d", good, bad, total)
        pTxt.Text = msg
        notify(msg, true)
        if getgenv().Neo and getgenv().Neo.InjectLog then
            local rep = getgenv().Neo.InjectLog.getReport()
            if writefile then writefile("KyroDev-InjectLog.txt", rep) end
        end
        injState.running = false
        injectBtn.Text, injectBtn.Active = "INJECT", true
    end)
end

injectBtn.MouseButton1Click:Connect(function()
    if injState.running then return end
    injectBtn.Text, injectBtn.Active = "Inyectando...", false
    pFill.Size, pTxt.Text = UDim2.new(0, 0, 1, 0), "Iniciando..."
    injState.cancel, injState.paused = false, false
    local ok, err = pcall(function() doInject(ffBox.Text) end)
    if not ok then
        notify("Error: " .. tostring(err), false)
        injectBtn.Text, injectBtn.Active = "INJECT", true
    end
end)

pauseBtn.MouseButton1Click:Connect(function()
    if not injState.running then return end
    injState.paused = not injState.paused
    pauseBtn.Text = injState.paused and "▶ Reanudar" or "Pausa"
end)

cancelBtn.MouseButton1Click:Connect(function()
    if injState.running then injState.cancel = true end
end)

local function sanitize()
    local src = resolveInput(ffBox.Text)
    local ok, data = pcall(function() return HttpService:JSONDecode(src) end)
    if not ok or type(data) ~= "table" then notify("JSON invalido", false) return end
    local out = {}
    for k, v in pairs(data) do
        local s, l = tostring(v), tostring(v):lower()
        local t = fkind(k)
        if t == "bool" then
            if l == "true" or l == "1" or l == "yes" then s = "True"
            elseif l == "false" or l == "0" or l == "no" then s = "False" end
        elseif t == "int" then
            local n = tonumber(s); s = n and tostring(math.floor(n)) or "0"
        end
        out[k] = s
    end
    local enc = HttpService:JSONEncode(out)
    local sv = pcall(function() if writefile then writefile("KyroDev-sanitized.json", enc) end end)
    if sv then notify("Guardado", true) else ffBox.Text = enc notify("Copiado", true) end
end

saveBtn.MouseButton1Click:Connect(sanitize)

-- === PAGINA LOG [+]/[-] ===
local logFrame = new("ScrollingFrame", {
    Parent = pgL, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    ScrollBarThickness = 4, CanvasSize = UDim2.new(0, 0, 0, 0),
})
corner(logFrame, 8)

local function updateLog()
    for _, c in ipairs(logFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    if not getgenv().Neo or not getgenv().Neo.InjectLog then return end
    local sList, fList = getgenv().Neo.InjectLog.success, getgenv().Neo.InjectLog.failed
    local y = 0
    if #sList == 0 and #fList == 0 then
        new("TextLabel", {Parent = logFrame, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
            Text = "Sin inyecciones", Font = Enum.Font.Gotham, TextSize = 9, TextColor3 = PASTEL.MINT,
            TextXAlignment = Enum.TextXAlignment.Center})
        return
    end
    for _, v in ipairs(sList) do
        local b = new("TextButton", {
            Parent = logFrame, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, y),
            BackgroundColor3 = PASTEL.DARK, Text = v, Font = Enum.Font.Gotham,
            TextSize = 8, TextColor3 = PASTEL.MINT, TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
        })
        corner(b, 3)
        y = y + 22
    end
    for _, v in ipairs(fList) do
        local b = new("TextButton", {
            Parent = logFrame, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, y),
            BackgroundColor3 = PASTEL.CARD, Text = v, Font = Enum.Font.Gotham,
            TextSize = 8, TextColor3 = PASTEL.PEACH, TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
        })
        corner(b, 3)
        y = y + 22
    end
    logFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

local btnUpd = new("TextButton", {
    Parent = pgL, Size = UDim2.new(1, -4, 0, 20), Position = UDim2.new(0, 2, 1, -24),
    BackgroundColor3 = PASTEL.CARD, Text = "Actualizar [+]/[-]",
    Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = PASTEL.CREAM,
})
corner(btnUpd, 5)
hvr(btnUpd)
btnUpd.MouseButton1Click:Connect(updateLog)

-- === PAGINA INFO ===
new("TextLabel", {
    Parent = pgI, Size = UDim2.new(1, -8, 0, 200), Position = UDim2.new(0, 4, 0, 4),
    BackgroundTransparency = 1, Text = [[⚡ KenyahSENCE
FFlag Injector v4 Pastel

[✓] Inyeccion lenta (anti-crash)
[✓] Bypass limites delta
[✓] Valores rotos/buffer0
[✓] Panel reducido
[✓] Sistema [+]/[-]

Owner: @0_kenyah]],
    Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = PASTEL.CREAM,
    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
})

-- CABECERA
closeBtn.MouseButton1Click:Connect(function() win.Visible, overlay.Visible, dock.Visible = false, false, true end)
minBtn.MouseButton1Click:Connect(function() win.Visible, overlay.Visible, dock.Visible = false, false, true end)
dockBtn.MouseButton1Click:Connect(function() win.Visible, overlay.Visible, dock.Visible = true, true, false end)
overlay.MouseButton1Click:Connect(function() win.Visible, overlay.Visible, dock.Visible = false, false, true end)

-- MONITOREO
RunService.RenderStepped:Connect(function(dt)
    fps = math.clamp(math.floor(1 / dt), 1, 240)
    frameMs = math.floor(dt * 1000 * 10) / 10
end)
RunService.Heartbeat:Connect(function(dt)
    cpuMs = math.floor(dt * 1000 * 10) / 10
end)

-- INICIAR
startGlow()
notify("⚡ KenyahSENCE - Iniciado", true)
