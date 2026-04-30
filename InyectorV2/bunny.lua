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
local C_PASTEL_PEACH = Color3.fromRGB(255, 218, 185)
local C_PASTEL_MINT  = Color3.fromRGB(189, 236, 220)
local C_PASTEL_CREAM = Color3.fromRGB(255, 253, 208)
local C_PASTEL_SKY   = Color3.fromRGB(173, 216, 230)
local C_PASTEL_WHITE = Color3.new(0.98, 0.98, 0.99)
local C_PASTEL_DEEP  = Color3.fromRGB(38, 32, 52)
local C_PASTEL_PANEL = Color3.fromRGB(48, 42, 64)
local C_PASTEL_CARD  = Color3.fromRGB(58, 52, 74)
local C_PASTEL_DARK  = Color3.fromRGB(32, 27, 44)
local C_ACCENT       = Color3.fromRGB(142, 100, 220)
local C_GLOW         = Color3.fromRGB(190, 150, 245)

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
            ColorSequenceKeypoint.new(0,   C_PASTEL_DARK),
            ColorSequenceKeypoint.new(0.5, C_PASTEL_CARD),
            ColorSequenceKeypoint.new(1,   C_PASTEL_PANEL),
        }),
    })
end

local function hvr(btn)
    btn.AutoButtonColor = false
    local orig = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = C_GLOW, TextColor3 = C_PASTEL_WHITE }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25), { BackgroundColor3 = orig, TextColor3 = C_PASTEL_CREAM }):Play()
    end)
end

local function mkDrag(frame)
    local drag, inp, sPos, sMouse = false, nil, nil, nil
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag   = true
            sPos   = frame.Position
            sMouse = i.Position
            inp    = i
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
        Parent           = playerGui,
        Size             = UDim2.fromOffset(310, 40),
        Position         = UDim2.new(0.5, -155, 1, -88 - #notifQueue * 45),
        BackgroundColor3 = C_PASTEL_PANEL,
        ZIndex           = 30,
    })
    corner(n, 8)
    rgrad(n, 0)
    new("UIStroke", { Parent = n, Color = success and C_GLOW or C_ACCENT, Thickness = 1.2, Transparency = 0.1 })
    local lbl = new("TextLabel", {
        Parent              = n,
        Size                = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text                = txt,
        Font                = Enum.Font.GothamBold,
        TextSize            = 12,
        TextColor3          = C_PASTEL_WHITE,
        ZIndex              = 31,
    })
    TweenService:Create(n, TweenInfo.new(0.18), { Position = UDim2.new(0.5, -155, 1, -108 - #notifQueue * 45) }):Play()
    table.insert(notifQueue, n)
    task.delay(2.8, function()
        TweenService:Create(n, TweenInfo.new(0.18), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(lbl, TweenInfo.new(0.18), { TextTransparency = 1 }):Play()
        task.delay(0.2, function() n:Destroy() 
            for ii, vv in ipairs(notifQueue) do if vv == n then table.remove(notifQueue, ii) break end end
        end) 
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

-- 300x340 (REDUCIDO)
local dock = new("Frame", {
    Parent           = gui,
    Size             = UDim2.fromOffset(38, 38),
    Position         = UDim2.new(1, -50, 0.5, -19),
    BackgroundColor3 = C_PASTEL_CARD,
    Visible          = true,
})
dock.Active = true
corner(dock, 19)
rgrad(dock)
new("UIStroke", { Parent = dock, Color = C_ACCENT, Thickness = 1.2, Transparency = 0.1 })
local dockBtn = new("TextButton", {
    Parent              = dock,
    Size                = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text                = "K",
    Font                = Enum.Font.GothamBold,
    TextSize            = 14,
    TextColor3          = C_PASTEL_CREAM,
})
mkDrag(dock)
hvr(dockBtn)

-- 300x340 (REDUCIDO)
local win = new("Frame", {
    Parent           = gui,
    Size             = UDim2.fromOffset(300, 340),
    Position         = UDim2.new(0.5, -150, 0.5, -170),
    BackgroundColor3 = C_PASTEL_DEEP,
    Visible          = false,
})
corner(win, 13)
rgrad(win, 130)
local wStroke = new("UIStroke", { Parent = win, Color = C_GLOW, Thickness = 1.6, Transparency = 0.08 })
win.Active     = true
win.Selectable = true
mkDrag(win)

task.spawn(function()
    local t = 0
    while win.Parent do
        t = t + 0.35
        local s = 0.85 + math.abs(math.sin(math.rad(t * 50))) * 0.15
        wStroke.Color = Color3.fromRGB(255, math.floor(40 + s * 50), math.floor(40 + s * 40))
        task.wait(0.05)
    end
end)

local hdr = new("Frame", { Parent = win, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = C_PASTEL_DARK })
corner(hdr, 13)
rgrad(hdr, 0)
new("UIStroke", { Parent = hdr, Color = C_ACCENT, Thickness = 1, Transparency = 0.25 })

new("TextLabel", {
    Parent              = hdr,
    Size                = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text                = "KenyahSENCE | FFlag Injector",
    Font                = Enum.Font.GothamBold,
    TextSize            = 12,
    TextColor3          = C_PASTEL_CREAM,
})

local closeBtn = new("TextButton", {
    Parent           = hdr,
    Size             = UDim2.fromOffset(19, 19),
    Position         = UDim2.new(1, -24, 0, 8),
    BackgroundColor3 = C_PASTEL_DARK,
    Text             = "X",
    Font             = Enum.Font.GothamBold,
    TextSize         = 10,
    TextColor3       = C_PASTEL_CREAM,
})
corner(closeBtn, 5)
hvr(closeBtn)

local minBtn = new("TextButton", {
    Parent           = hdr,
    Size             = UDim2.fromOffset(19, 19),
    Position         = UDim2.new(1, -47, 0, 8),
    BackgroundColor3 = C_PASTEL_DARK,
    Text             = "-",
    Font             = Enum.Font.GothamBold,
    TextSize         = 10,
    TextColor3       = C_PASTEL_CREAM,
})
corner(minBtn, 5)
hvr(minBtn)

local body = new("Frame", { Parent = win, Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(1, 0, 1, -36), BackgroundTransparency = 1 })

local side = new("Frame", { Parent = body, Size = UDim2.new(0, 54, 1, 0), BackgroundColor3 = C_PASTEL_PANEL })
corner(side, 10)
rgrad(side, 90)

local cnt = new("Frame", { Parent = body, Position = UDim2.new(0, 60, 0, 0), Size = UDim2.new(1, -66, 1, 0), BackgroundTransparency = 1 })

local tabF = new("TextButton", {
    Parent           = side, Size = UDim2.new(1, -8, 0, 22), Position = UDim2.new(0, 4, 0, 4),
    BackgroundColor3 = C_PASTEL_DARK, Text = "Flags", Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C_PASTEL_CREAM,
})
corner(tabF, 5)
hvr(tabF)

local tabL = new("TextButton", {
    Parent           = side, Size = UDim2.new(1, -8, 0, 22), Position = UDim2.new(0, 4, 0, 29),
    BackgroundColor3 = C_PASTEL_DARK, Text = "Log[+/-]", Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C_PASTEL_CREAM,
})
corner(tabL, 5)
hvr(tabL)

local tabI = new("TextButton", {
    Parent           = side, Size = UDim2.new(1, -8, 0, 22), Position = UDim2.new(0, 4, 0, 54),
    BackgroundColor3 = C_PASTEL_DARK, Text = "Info", Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C_PASTEL_CREAM,
})
corner(tabI, 5)
hvr(tabI)

local pgF = new("Frame", { Parent = cnt, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })
local pgL = new("Frame", { Parent = cnt, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false })
local pgI = new("Frame", { Parent = cnt, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false })

tabF.MouseButton1Click:Connect(function() pgF.Visible, pgL.Visible, pgI.Visible = true, false, false
    tabF.BackgroundColor3, tabL.BackgroundColor3, tabI.BackgroundColor3 = C_PASTEL_DARK, C_PASTEL_CARD, C_PASTEL_CARD end)
tabL.MouseButton1Click:Connect(function() pgF.Visible, pgL.Visible, pgI.Visible = false, true, false
    tabF.BackgroundColor3, tabL.BackgroundColor3, tabI.BackgroundColor3 = C_PASTEL_CARD, C_PASTEL_DARK, C_PASTEL_CARD end)
tabI.MouseButton1Click:Connect(function() pgF.Visible, pgL.Visible, pgI.Visible = false, false, true
    tabF.BackgroundColor3, tabL.BackgroundColor3, tabI.BackgroundColor3 = C_PASTEL_CARD, C_PASTEL_CARD, C_PASTEL_DARK end)

-- === PAGINA FLAGS ===
local ffBox = new("TextBox", {
    Parent              = pgF, Size = UDim2.new(1, -4, 1, -110), Position = UDim2.new(0, 2, 0, 3),
    MultiLine           = true, ClearTextOnFocus = false, TextWrapped = true,
    Font                = Enum.Font.Gotham, TextSize = 10, BackgroundColor3 = C_PASTEL_CARD,
    TextColor3          = C_PASTEL_CREAM, PlaceholderText = "Pega tu JSON aqui...",
})
corner(ffBox, 7)
new("UIStroke", { Parent = ffBox, Color = C_ACCENT, Thickness = 1, Transparency = 0.2 })

local szLbl = new("TextLabel", {
    Parent              = pgF, Position = UDim2.new(0, 2, 1, -74), Size = UDim2.new(1, -4, 0, 12),
    BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 8,
    TextColor3 = C_PASTEL_SKY, Text = "0 KB / 0 chars", TextXAlignment = Enum.TextXAlignment.Left,
})
ffBox:GetPropertyChangedSignal("Text"):Connect(function()
    local t = ffBox.Text or ""
    szLbl.Text = ("%.2f KB / %d chars"):format(#t / 1024, #t)
end)

local pBg = new("Frame", {
    Parent = pgF, Size = UDim2.new(1, -4, 0, 7), Position = UDim2.new(0, 2, 1, -54),
    BackgroundColor3 = C_PASTEL_DARK,
})
corner(pBg, 4)
local pFill = new("Frame", { Parent = pBg, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C_ACCENT })
corner(pFill, 4)

local pTxt = new("TextLabel", {
    Parent = pgF, Position = UDim2.new(0, 2, 1, -44), Size = UDim2.new(1, -4, 0, 12),
    BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 9,
    TextColor3 = C_PASTEL_MINT, Text = "Listo", TextXAlignment = Enum.TextXAlignment.Left,
})

local function mkBtn(lbl, xs, xo, yo, ac)
    local b = new("TextButton", {
        Parent = pgF, Size = UDim2.new(0.5, -3, 0, 21), Position = UDim2.new(xs, xo, 1, yo),
        BackgroundColor3 = ac and C_ACCENT or C_PASTEL_CARD, Text = lbl,
        Font = Enum.Font.GothamBold, TextSize = 10,
        TextColor3 = ac and C_PASTEL_WHITE or C_PASTEL_CREAM,
    })
    corner(b, 6)
    if ac then rgrad(b, 0) end
    hvr(b)
    return b
end

local pauseBtn  = mkBtn("Pausa",    0,   2, -20, false)
local cancelBtn = mkBtn("Cancelar", 0.5, -2, -20, false)
local saveBtn   = mkBtn("Sanitizar",0,   2,  4,  false)
local injectBtn = mkBtn("INJECT",   0.5, -2,  4,  true)

-- === INYECCION (logica ORIGINAL preservada con mejoras) ===
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
        local ok = pcall(fn, ...)
        return ok
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

    return false
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
            v      = v:match('^"(.*)"$') or v:match("^'(.*)'$') or v:gsub("%s+$", "")
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

local injState = { running = false, paused = false, cancel = false }

-- INYECCION RAPIDA (delay minimo para evitar crashes)
local function doInject(txt)
    local src  = resolveInput(txt)
    local data

    local ok, tmp = pcall(function() return HttpService:JSONDecode(src) end)
    if ok and type(tmp) == "table" then
        data = tmp
    else
        data = parseFB(src)
        if not data then
            notify("JSON invalido o formato no reconocido", false)
            injectBtn.Text   = "INJECT"
            injectBtn.Active = true
            return
        end
    end

    local flags = buildList(data)
    local total = #flags

    if total == 0 then
        notify("Sin flags encontradas", false)
        injectBtn.Text   = "INJECT"
        injectBtn.Active = true
        return
    end

    local FAST = false -- forzado a false para estabilidad

    task.spawn(function()
        injState.running = true
        injState.cancel  = false
        injState.paused  = false

        local done, good, bad = 0, 0, 0

        pTxt.Text = ("Inyectando %d flags..."):format(total)

        for _, pair in ipairs(flags) do
            while injState.paused do
                pTxt.Text = "Pausado..."
                task.wait(0.1)
            end
            if injState.cancel then
                pTxt.Text = ("Cancelado en %d/%d"):format(done, total)
                break
            end

            local k, v = pair[1], pair[2]

            local outerOk = pcall(function()
                local innerOk = pcall(function()
                    if trySet(k, v) then 
                        good = good + 1
                        if getgenv().Neo and getgenv().Neo.InjectLog then
                            getgenv().Neo.InjectLog.addSuccess(k, v)
                        end
                    else 
                        bad = bad + 1
                        if getgenv().Neo and getgenv().Neo.InjectLog then
                            getgenv().Neo.InjectLog.addFailed(k, v, "setfn")
                        end
                    end
                end)
                if not innerOk then 
                    bad = bad + 1
                    if getgenv().Neo and getgenv().Neo.InjectLog then
                        getgenv().Neo.InjectLog.addFailed(k, v, "pcall")
                    end
                end
            end)
            if not outerOk then 
                bad = bad + 1
                if getgenv().Neo and getgenv().Neo.InjectLog then
                    getgenv().Neo.InjectLog.addFailed(k, v, "outerPCall")
                end
            end

            done = done + 1

            if done % 5 == 0 or done == total then
                local pct = done / total
                TweenService:Create(pFill, TweenInfo.new(0.07), { Size = UDim2.new(pct, 0, 1, 0) }):Play()
                pTxt.Text = ("%d%%  %d/%d  ok:%d  err:%d"):format(math.floor(pct * 100), done, total, good, bad)
            end

            -- TASK.WAIT PARA PREVENIR CRASH (no Heartbeat:Wait)
            task.wait(0.05)
        end

        pFill.Size = UDim2.new(1, 0, 1, 0)
        local msg  = ("Listo: ok %d  err %d  total %d"):format(good, bad, total)
        pTxt.Text  = msg
        notify(msg, good > 0)

        injState.running = false
        injectBtn.Text   = "INJECT"
        injectBtn.Active = true

        pcall(function()
            if getgenv().Neo and getgenv().Neo.Logger then
                getgenv().Neo.Logger.log("info", msg)
            end
            if getgenv().Neo and getgenv().Neo.InjectLog then
                getgenv().Neo.InjectLog.flush("KyroDev-InjectLog.txt")
            end
        end)
    end)
end

injectBtn.MouseButton1Click:Connect(function()
    if injState.running then return end
    injectBtn.Text   = "Inyectando..."
    injectBtn.Active = false
    pFill.Size       = UDim2.new(0, 0, 1, 0)
    pTxt.Text        = "0%"
    injState.cancel  = false
    injState.paused  = false
    local ok, err = pcall(function() doInject(ffBox.Text) end)
    if not ok then
        notify("Error: " .. tostring(err), false)
        injectBtn.Text   = "INJECT"
        injectBtn.Active = true
    end
end)

pauseBtn.MouseButton1Click:Connect(function()
    if not injState.running then return end
    injState.paused = not injState.paused
    pauseBtn.Text   = injState.paused and "Reanudar" or "Pausa"
end)

cancelBtn.MouseButton1Click:Connect(function()
    if injState.running then injState.cancel = true end
end)

saveBtn.MouseButton1Click:Connect(function()
    local src = resolveInput(ffBox.Text)
    local ok, data = pcall(function() return HttpService:JSONDecode(src) end)
    if not ok or type(data) ~= "table" then notify("JSON invalido", false) return end
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
    if saved then notify("Guardado: KyroDev-sanitized.json", true) else ffBox.Text = enc notify("Pegado en caja", true) end
end)

-- === PAGINA LOG [+]/[-] ===
local logFrame = new("ScrollingFrame", {
    Parent = pgL, Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1, ScrollBarThickness = 4, CanvasSize = UDim2.new(0, 0, 0, 0),
})
corner(logFrame, 8)

local function updateLog()
    for _, c in ipairs(logFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    if not getgenv().Neo or not getgenv().Neo.InjectLog then return end
    local sList = getgenv().Neo.InjectLog.success
    local fList = getgenv().Neo.InjectLog.failed
    local y = 0
    if #sList == 0 and #fList == 0 then
        new("TextLabel", {Parent = logFrame, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
            Text = "Sin inyecciones aun", Font = Enum.Font.Gotham, TextSize = 9, TextColor3 = C_PASTEL_MINT,
            TextXAlignment = Enum.TextXAlignment.Center})
        return
    end
    for _, v in ipairs(sList) do
        local b = new("TextButton", {
            Parent = logFrame, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, y),
            BackgroundColor3 = C_PASTEL_DARK, Text = v, Font = Enum.Font.Gotham, TextSize = 8,
            TextColor3 = C_PASTEL_MINT, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false,
        })
        corner(b, 3)
        y = y + 22
    end
    for _, v in ipairs(fList) do
        local b = new("TextButton", {
            Parent = logFrame, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, y),
            BackgroundColor3 = C_PASTEL_CARD, Text = v, Font = Enum.Font.Gotham, TextSize = 8,
            TextColor3 = C_PASTEL_PEACH, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false,
        })
        corner(b, 3)
        y = y + 22
    end
    logFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

local btnUpd = new("TextButton", {
    Parent = pgL, Size = UDim2.new(1, -4, 0, 20), Position = UDim2.new(0, 2, 1, -24),
    BackgroundColor3 = C_PASTEL_CARD, Text = "Actualizar [+]/[-]",
    Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C_PASTEL_CREAM,
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
[✓] Bypass de limites delta
[✓] Soporta valores rotos/buffer0
[✓] Panel reducido
[✓] Sistema [+]/[-] logs

Owner: @0_kenyah]],
    Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C_PASTEL_CREAM,
    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
})

-- BOTONES
closeBtn.MouseButton1Click:Connect(function() win.Visible, overlay.Visible, dock.Visible = false, false, true end)
minBtn.MouseButton1Click:Connect(function() win.Visible, overlay.Visible, dock.Visible = false, false, true end)
dockBtn.MouseButton1Click:Connect(function() win.Visible, overlay.Visible, dock.Visible = true, true, false end)
overlay.MouseButton1Click:Connect(function() win.Visible, overlay.Visible, dock.Visible = false, false, true end)

RunService.RenderStepped:Connect(function(dt)
    fps = math.clamp(math.floor(1 / dt), 1, 240)
    frameMs = math.floor(dt * 1000 * 10) / 10
end)
RunService.Heartbeat:Connect(function(dt)
    cpuMs = math.floor(dt * 1000 * 10) / 10
end)

startGlow()
notify("⚡ KenyahSENCE - Iniciado", true)
