local HttpService = game:GetService("HttpService")
local RunService  = game:GetService("RunService")

local Neo = {}

Neo.State = { fps = 60, frameMs = 16, cpuMs = 16 }

Neo.Perf = {}
Neo.Perf.start = function()
    RunService.RenderStepped:Connect(function(dt)
        Neo.State.fps     = math.clamp(math.floor(1 / dt), 1, 240)
        Neo.State.frameMs = math.floor(dt * 1000 * 10) / 10
    end)
    RunService.Heartbeat:Connect(function(dt)
        Neo.State.cpuMs = math.floor(dt * 1000 * 10) / 10
    end)
end

Neo.Logger        = {}
Neo.Logger.buffer = {}
Neo.Logger.max    = 100000

Neo.Logger.log = function(level, msg)
    local b    = Neo.Logger.buffer
    b[#b + 1]  = "[" .. tostring(level) .. "] " .. tostring(tick()) .. " " .. tostring(msg)
    if #b > Neo.Logger.max then table.remove(b, 1) end
end

Neo.Logger.flush = function(fname)
    if not writefile then return false end
    return pcall(writefile, fname or "NeoLog.txt", table.concat(Neo.Logger.buffer, "\n"))
end

getgenv().Neo = Neo
return Neo
