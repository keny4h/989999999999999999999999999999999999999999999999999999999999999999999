-- Advanced Loader for KenyahSENCE FFlags Injector
-- Loads bunny.lua after animation

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

do
    local p = playerGui:FindFirstChild("Loader") or playerGui:FindFirstChild("KyroDev") or playerGui:FindFirstChild("KyroDevNeo")
    if p then p:Destroy() end
end

-- Theme Colors
local THEME = {
    BG = Color3.fromHex("#0d0f14"),
    PRIMARY = Color3.fromHex("#6366f1"),
    ACCENT = Color3.fromHex("#06b6d4"),
    WHITE = Color3.new(1, 1, 1),
    TEXT = Color3.fromHex("#e2e8f0"),
}

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

-- Loader GUI
local loaderGui = create("ScreenGui", {
    Parent = playerGui,
    Name = "Loader",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
})

local loaderFrame = create("Frame", {
    Parent = loaderGui,
    Size = UDim2.fromOffset(320, 180),
    Position = UDim2.new(0.5, -160, 0.5, -90),
    BackgroundColor3 = THEME.BG,
    ZIndex = 100,
})
addCorner(loaderFrame, 15)
addGradient(loaderFrame, {
    ColorSequenceKeypoint.new(0, THEME.PRIMARY),
    ColorSequenceKeypoint.new(1, THEME.ACCENT),
})
addStroke(loaderFrame, THEME.WHITE, 2)

local loaderTitle = create("TextLabel", {
    Parent = loaderFrame,
    Size = UDim2.new(1, 0, 0, 50),
    Position = UDim2.new(0, 0, 0, 10),
    BackgroundTransparency = 1,
    Text = "KenyahSENCE\nFFlags Injector",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = THEME.WHITE,
    TextWrapped = true,
})

local loaderBarBg = create("Frame", {
    Parent = loaderFrame,
    Size = UDim2.new(0.85, 0, 0, 12),
    Position = UDim2.new(0.075, 0, 0, 70),
    BackgroundColor3 = THEME.BG,
})
addCorner(loaderBarBg, 6)
addStroke(loaderBarBg, THEME.PRIMARY, 1)

local loaderBar = create("Frame", {
    Parent = loaderBarBg,
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = THEME.ACCENT,
})
addCorner(loaderBar, 6)
addGradient(loaderBar, {
    ColorSequenceKeypoint.new(0, THEME.ACCENT),
    ColorSequenceKeypoint.new(1, THEME.PRIMARY),
})

local loaderText = create("TextLabel", {
    Parent = loaderFrame,
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 90),
    BackgroundTransparency = 1,
    Text = "Initializing Advanced System...",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = THEME.TEXT,
})

local spinner = create("Frame", {
    Parent = loaderFrame,
    Size = UDim2.fromOffset(25, 25),
    Position = UDim2.new(0.5, -12.5, 0, 130),
    BackgroundColor3 = THEME.PRIMARY,
})
addCorner(spinner, 12.5)
addGradient(spinner, {
    ColorSequenceKeypoint.new(0, THEME.PRIMARY),
    ColorSequenceKeypoint.new(1, THEME.ACCENT),
})

-- Simple Animation
local messages = {
    "Initializing Advanced System...",
    "Loading Core Modules...",
    "Configuring UI Components...",
    "Preparing FFlags Engine...",
    "Almost Ready...",
}

for i = 1, 100 do
    TweenService:Create(loaderBar, TweenInfo.new(0.025), { Size = UDim2.new(i/100, 0, 1, 0) }):Play()
    local msgIndex = math.min(math.floor(i/20) + 1, #messages)
    loaderText.Text = messages[msgIndex] .. string.format(" %d%%", i)
    wait(0.025)
end

-- Spinner simple
TweenService:Create(spinner, TweenInfo.new(1), { Rotation = 360 }):Play()

-- Exit
TweenService:Create(loaderFrame, TweenInfo.new(0.5), {
    BackgroundTransparency = 1,
    Size = UDim2.fromOffset(0, 0),
}):Play()

wait(0.5)

loaderGui:Destroy()

-- Load bunny.lua
loadstring(readfile("bunny.lua"))()