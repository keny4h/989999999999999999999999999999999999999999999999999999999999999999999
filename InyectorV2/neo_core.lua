local HttpService = game:GetService("HttpService")
local RunService  = game:GetService("RunService")
local Players     = game:GetService("Players")

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

Neo.InjectLog = {
    success = {},  -- flags inyectados correctamente [+]
    failed  = {}   -- flags fallidos [-]
}

Neo.InjectLog.addSuccess = function(key, value)
    local entry = "[+] " .. tostring(key) .. " = " .. tostring(value)
    table.insert(Neo.InjectLog.success, entry)
    Neo.Logger.log("success", entry)
end

Neo.InjectLog.addFailed = function(key, value, reason)
    local entry = "[-] " .. tostring(key) .. " = " .. tostring(value) .. " | " .. tostring(reason or "error")
    table.insert(Neo.InjectLog.failed, entry)
    Neo.Logger.log("fail", entry)
end

Neo.InjectLog.clear = function()
    Neo.InjectLog.success = {}
    Neo.InjectLog.failed  = {}
end

Neo.InjectLog.getReport = function()
    local report = {}
    local sCount = #Neo.InjectLog.success
    local fCount = #Neo.InjectLog.failed
    table.insert(report, "===== Reporte de Inyeccion =====")
    table.insert(report, "Total: " .. (sCount + fCount) .. " | Exitoso: " .. sCount .. " | Fallido: " .. fCount)
    table.insert(report, "")
    if sCount > 0 then
        table.insert(report, "--- Exitosas [+] ---")
        for i, v in ipairs(Neo.InjectLog.success) do
            table.insert(report, v)
        end
        table.insert(report, "")
    end
    if fCount > 0 then
        table.insert(report, "--- Fallidas [-] ---")
        for i, v in ipairs(Neo.InjectLog.failed) do
            table.insert(report, v)
        end
    end
    return table.concat(report, "\n")
end

getgenv().Neo = Neo
Neo.Perf.start()
return Neo
